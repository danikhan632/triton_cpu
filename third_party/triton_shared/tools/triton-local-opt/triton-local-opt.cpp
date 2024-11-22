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
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/MemRef/IR/MemRef.h"
#include "mlir/Dialect/SCF/IR/SCF.h"
#include "mlir/IR/BuiltinOps.h"


#include "mlir/Dialect/MemRef/IR/MemRef.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Transforms/GreedyPatternRewriteDriver.h"


using namespace mlir;



namespace matmul_conversion {

static constexpr uint64_t SHARED_MEMORY_BASE = 0xFFFFF0000000000;
static uint64_t currentSharedMemoryOffset = 0;

// Helper function to get the next shared memory address
static uint64_t getNextSharedMemoryAddress(uint64_t size) {
  size = (size + 7) & ~7;
  uint64_t address = SHARED_MEMORY_BASE + currentSharedMemoryOffset;
  currentSharedMemoryOffset += size;
  return address;
}

// Helper function to calculate memref size in bytes
static uint64_t getMemRefSizeInBytes(mlir::MemRefType type) {
  uint64_t size = 1;
  for (auto dim : type.getShape()) {
    size *= dim;
  }
  return size * type.getElementTypeBitWidth() / 8;
}

// Helper to create memory space attribute
static mlir::Attribute getSharedMemorySpaceAttr(mlir::MLIRContext* ctx, uint64_t address) {
  return mlir::IntegerAttr::get(mlir::IntegerType::get(ctx, 64), address);
}



struct ReplaceAllocWithGlobalPattern : public mlir::OpRewritePattern<mlir::memref::AllocOp> {
  using OpRewritePattern::OpRewritePattern;

  mlir::LogicalResult matchAndRewrite(mlir::memref::AllocOp allocOp,
                                    mlir::PatternRewriter &rewriter) const override {
    auto loc = allocOp.getLoc();
    auto memrefType = allocOp.getType();
    
    // Skip if already processed
    if (memrefType.getMemorySpace() || allocOp->hasAttr("shared_memory")) {
      return mlir::failure();
    }

    // Get module operation to insert globals
    auto moduleOp = allocOp->getParentOfType<mlir::ModuleOp>();
    if (!moduleOp) {
      return mlir::failure();
    }

    // Calculate size and address
    uint64_t size = getMemRefSizeInBytes(memrefType);
    uint64_t address = getNextSharedMemoryAddress(size);

    std::string globalName = "shared_mem_" + std::to_string(address);

    // Create shared memory type
    auto sharedType = mlir::MemRefType::get(
        memrefType.getShape(),
        memrefType.getElementType(),
        memrefType.getLayout(),
        getSharedMemorySpaceAttr(getContext(), address));

    // Check if global exists
  if (!moduleOp.lookupSymbol(globalName)) {
  OpBuilder::InsertionGuard guard(rewriter);
  rewriter.setInsertionPointToStart(moduleOp.getBody());
  
  // Create global with simpler builder signature
  auto globalOp = rewriter.create<mlir::memref::GlobalOp>(
      loc,
      rewriter.getStringAttr(globalName),     // sym_name
      rewriter.getStringAttr("private"),      // sym_visibility 
      mlir::TypeAttr::get(sharedType),        // type
      nullptr,                                // initial_value
      rewriter.getUnitAttr(),                 // constant
      nullptr                                 // alignment
  );

  // Add attributes after creation
  globalOp->setAttr("shared_memory", rewriter.getUnitAttr());
  globalOp->setAttr("shared_memory_size", rewriter.getI64IntegerAttr(size));
  globalOp->setAttr("shared_memory_address", rewriter.getI64IntegerAttr(address));
}

    // Replace alloc with get_global
    auto getGlobalOp = rewriter.create<mlir::memref::GetGlobalOp>(
        loc, 
        sharedType, 
        globalName);

    // Create memory space cast
    auto spaceCast = rewriter.create<mlir::memref::MemorySpaceCastOp>(
        loc,
        memrefType,
        getGlobalOp);

    rewriter.replaceOp(allocOp, spaceCast.getResult());
    return mlir::success();
  }
};




struct ReplaceCastPattern : public mlir::OpRewritePattern<mlir::memref::CastOp> {
  using OpRewritePattern::OpRewritePattern;

  mlir::LogicalResult matchAndRewrite(mlir::memref::CastOp castOp,
                                    mlir::PatternRewriter &rewriter) const override {
    auto source = castOp.getSource();
    auto sourceType = source.getType().dyn_cast<mlir::MemRefType>();
    auto resultType = castOp.getType().dyn_cast<mlir::MemRefType>();
    
    if (!sourceType || !resultType) {
      return mlir::failure();
    }

    if (sourceType.getMemorySpace() && !resultType.getMemorySpace()) {
      auto spaceCast = rewriter.create<mlir::memref::MemorySpaceCastOp>(
          castOp.getLoc(),
          resultType,
          source);
      rewriter.replaceOp(castOp, spaceCast.getResult());
      return mlir::success();
    }

    return mlir::failure();
  }
};

struct SharedMemoryPass 
    : public mlir::PassWrapper<SharedMemoryPass, mlir::OperationPass<mlir::ModuleOp>> {
  
  void getDependentDialects(mlir::DialectRegistry &registry) const override {
    registry.insert<mlir::memref::MemRefDialect>();
    registry.insert<mlir::scf::SCFDialect>();
  }

  void runOnOperation() override {
    currentSharedMemoryOffset = 0;
    
    mlir::RewritePatternSet patterns(&getContext());
    patterns.add<ReplaceAllocWithGlobalPattern>(&getContext());
    patterns.add<ReplaceCastPattern>(&getContext());

    if (mlir::failed(mlir::applyPatternsAndFoldGreedily(getOperation(), 
                                                       std::move(patterns)))) {
      signalPassFailure();
    }
  }
};

std::unique_ptr<mlir::Pass> createSharedMemoryGlobalPass() {
  return std::make_unique<SharedMemoryPass>();
}

} // end namespace



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
        
       pm.addPass(matmul_conversion::createSharedMemoryGlobalPass());
        
      });


  return asMainReturnCode(
      MlirOptMain(argc, argv, "Optimizer Driver\n", registry));
}