#include "mlir/Dialect/Linalg/IR/Linalg.h"
#include "mlir/Dialect/Vector/IR/VectorOps.h"
#include "mlir/Dialect/Vector/TransformOps/VectorTransformOps.h"
#include "mlir/IR/Dialect.h"
#include "mlir/IR/MLIRContext.h"
#include "mlir/IR/Operation.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Dialect/Affine/IR/AffineOps.h"
#include "mlir/InitAllDialects.h"
#include "mlir/InitAllPasses.h"
#include "mlir/Interfaces/VectorInterfaces.h"
#include "mlir/Pass/Pass.h"
#include "mlir/Pass/PassManager.h"
#include "mlir/Tools/mlir-opt/MlirOptMain.h"
#include "mlir/Transforms/DialectConversion.h"
#include "mlir/Transforms/GreedyPatternRewriteDriver.h"
#include "mlir/Transforms/Passes.h"
#include <fstream>
#include <iostream>
#include <llvm/Support/raw_ostream.h>
#include "mlir/Dialect/Vector/Transforms/LoweringPatterns.h"
#include "mlir/Dialect/Bufferization/Transforms/Bufferize.h"
#include "mlir/Dialect/Linalg/TransformOps/LinalgTransformOps.h"
#include "mlir/Dialect/Affine/IR/AffineOps.h"
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/MemRef/IR/MemRef.h"
#include "mlir/Dialect/SCF/IR/SCF.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/Pass/Pass.h"
#include "mlir/Transforms/GreedyPatternRewriteDriver.h"
#include "mlir/Pass/Pass.h"

using namespace mlir;

namespace matmul_conversion {

class SharedMemoryPass
    : public PassWrapper<SharedMemoryPass, OperationPass<ModuleOp>> {
public:
  StringRef getArgument() const final { return "shared-mem-alloc"; }
  
  StringRef getDescription() const final {
    return "Convert memref.alloc ops to shared memory allocations starting at 0xffff";
  }
  
  void getDependentDialects(DialectRegistry &registry) const override {
    registry.insert<memref::MemRefDialect, LLVM::LLVMDialect, scf::SCFDialect>();
  }

private:
  // Convert a memref type to use shared memory space
  MemRefType getSharedMemoryType(Type type) {
    if (auto memrefType = type.dyn_cast<MemRefType>()) {
      return MemRefType::get(
          memrefType.getShape(),
          memrefType.getElementType(),
          memrefType.getLayout(),
          IntegerAttr::get(IntegerType::get(memrefType.getContext(), 32), 3));
    }
    return type.cast<MemRefType>();
  }

  bool updateMemRefTypes(Operation* op) {
    bool changed = false;
    
    // Update result types
    for (Value result : op->getResults()) {
      Type resultType = result.getType();
      if (auto memrefType = resultType.dyn_cast<MemRefType>()) {
        if (!memrefType.getMemorySpace() || 
            memrefType.getMemorySpace().cast<IntegerAttr>().getInt() != 3) {
          auto newType = getSharedMemoryType(memrefType);
          result.setType(newType);
          changed = true;
        }
      }
    }
    
    // Update operand types if needed
    for (OpOperand &operand : op->getOpOperands()) {
      Type operandType = operand.get().getType();
      if (auto memrefType = operandType.dyn_cast<MemRefType>()) {
        if (!memrefType.getMemorySpace() ||
            memrefType.getMemorySpace().cast<IntegerAttr>().getInt() != 3) {
          auto newType = getSharedMemoryType(memrefType);
          operand.get().setType(newType);
          changed = true;
        }
      }
    }
    
    return changed;
  }

  void processOperation(Operation* op) {
    // First process nested regions
    for (Region &region : op->getRegions()) {
      for (Block &block : region) {
        for (Operation &nestedOp : block) {
          processOperation(&nestedOp);
        }
      }
    }

    if (auto subviewOp = dyn_cast<memref::SubViewOp>(op)) {
      // Handle subview operations
      auto sourceType = subviewOp.getSource().getType().cast<MemRefType>();
      if (sourceType.getMemorySpace() && 
          sourceType.getMemorySpace().cast<IntegerAttr>().getInt() == 3) {
        // Create new result type with shared memory space
        auto currentType = subviewOp.getType().cast<MemRefType>();
        auto newType = MemRefType::get(
            currentType.getShape(),
            currentType.getElementType(),
            currentType.getLayout(),
            sourceType.getMemorySpace());
        
        // Create new subview operation
        OpBuilder builder(subviewOp);
        auto newSubview = builder.create<memref::SubViewOp>(
            subviewOp.getLoc(),
            newType,
            subviewOp.getSource(),
            subviewOp.getMixedOffsets(),
            subviewOp.getMixedSizes(),
            subviewOp.getMixedStrides());
            
        // Replace old subview with new one
        subviewOp->replaceAllUsesWith(newSubview.getOperation());
        subviewOp->erase();
      }
    } else if (auto allocOp = dyn_cast<memref::AllocOp>(op)) {
      // Handle allocation operations
      if (!allocOp->hasAttr("shared_mem_processed")) {
        auto memrefType = allocOp.getType();
        auto newType = getSharedMemoryType(memrefType);
        
        OpBuilder builder(allocOp);
        auto newAlloc = builder.create<memref::AllocOp>(
            allocOp.getLoc(),
            newType,
            allocOp.getDynamicSizes(),
            allocOp.getAlignmentAttr());
            
        allocOp.getResult().replaceAllUsesWith(newAlloc.getResult());
        allocOp->setAttr("shared_mem_processed", 
                        builder.getUnitAttr());
        allocOp->erase();
      }
    } else if (auto forOp = dyn_cast<scf::ForOp>(op)) {
      // Handle scf.for operations
      bool needsUpdate = false;
      SmallVector<Type, 4> newResultTypes;
      SmallVector<Value, 4> newInitArgs;
      
      // Check and update types
      for (auto [initArg, regionArg] : llvm::zip(forOp.getInitArgs(), 
                                                forOp.getRegionIterArgs())) {
        Type initType = initArg.getType();
        if (auto memrefType = initType.dyn_cast<MemRefType>()) {
          auto newType = getSharedMemoryType(memrefType);
          if (newType != memrefType) {
            needsUpdate = true;
            newResultTypes.push_back(newType);
            newInitArgs.push_back(initArg);
            continue;
          }
        }
        newResultTypes.push_back(initType);
        newInitArgs.push_back(initArg);
      }
      
      // Update for operation if needed
      if (needsUpdate) {
        OpBuilder builder(forOp);
        auto newForOp = builder.create<scf::ForOp>(
            forOp.getLoc(),
            forOp.getLowerBound(),
            forOp.getUpperBound(),
            forOp.getStep(),
            newInitArgs);
            
        // Move body to new operation
        newForOp.getRegion().takeBody(forOp.getRegion());
        
        // Update result types
        for (auto [oldResult, newType] : 
             llvm::zip(forOp.getResults(), newResultTypes)) {
          oldResult.setType(newType);
        }
        
        forOp->erase();
      }
    }
    
    // Update types for the current operation
    updateMemRefTypes(op);
  }

  void runOnOperation() override {
    auto module = getOperation();
    
    // Process all operations in the module
    for (Operation &op : module.getOps()) {
      processOperation(&op);
    }
  }
};


std::unique_ptr<Pass> createSharedMemoryPass() {
  return std::make_unique<SharedMemoryPass>();
}


std::unique_ptr<Pass> createSharedMemoryAllocPass() {
  return std::make_unique<SharedMemoryPass>();
}

struct AddLocalMemAttributePass
    : public PassWrapper<AddLocalMemAttributePass, OperationPass<ModuleOp>> {
  
  StringRef getArgument() const final { return "add-local-mem-attr"; }
  StringRef getDescription() const final { 
    return "Add local_mem attribute to memref.alloc operations"; 
  }

  void getDependentDialects(DialectRegistry &registry) const override {
    registry.insert<memref::MemRefDialect>();
  }

  void runOnOperation() override {
    ModuleOp module = getOperation();
    OpBuilder builder(module);

    // Walk through all memref.alloc operations
    module.walk([&](memref::AllocOp allocOp) {
      // Add the local_mem attribute if it doesn't exist
      if (!allocOp->hasAttr("local_mem")) {
        allocOp->setAttr("local_mem", builder.getUnitAttr());
      }
    });
  }
};

std::unique_ptr<Pass> createAddLocalMemAttributePass() {
  return std::make_unique<AddLocalMemAttributePass>();
}

  // std::unique_ptr<Pass> createReplaceAllocAndAdjustDerivedMemRefPass() {
  //   return std::make_unique<ReplaceAllocAndAdjustDerivedMemRefPass>();
  // }




} // namespace matmul_conversion

int main(int argc, char **argv) {
 DialectRegistry registry;

  registry.insert<func::FuncDialect, arith::ArithDialect, math::MathDialect,
                  linalg::LinalgDialect, affine::AffineDialect, scf::SCFDialect,
                  tensor::TensorDialect, bufferization::BufferizationDialect,
                  vector::VectorDialect, memref::MemRefDialect,
                  func::FuncDialect, arm_sme::ArmSMEDialect>();

  registerAllDialects(registry);
  registerAllPasses();

  MLIRContext context;
  context.appendDialectRegistry(registry);
  context.loadAllAvailableDialects();




  PassPipelineRegistration<> localConversionPipeline(
      "local-mem-conversion",
      "Converts local to a more optimized form using SME",
      [](OpPassManager &pm) {
        
       pm.addPass(matmul_conversion::createSharedMemoryAllocPass());
        
      });


  return asMainReturnCode(
      MlirOptMain(argc, argv, "Optimizer Driver\n", registry));
}