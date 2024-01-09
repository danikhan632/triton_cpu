#include "mlir/Dialect/ArmSVE/IR/ArmSVEDialect.h"
#include "mlir/Dialect/Linalg/IR/Linalg.h"
#include "mlir/IR/Dialect.h"
#include "mlir/IR/MLIRContext.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/InitAllDialects.h"
#include "mlir/InitAllPasses.h"
#include "mlir/Interfaces/VectorInterfaces.h"
#include "mlir/Pass/Pass.h"
#include "mlir/Pass/PassManager.h"
#include "mlir/Tools/mlir-opt/MlirOptMain.h"
#include "mlir/Transforms/GreedyPatternRewriteDriver.h"
#include "mlir/Transforms/Passes.h"
#include <iostream>
#include <llvm/Support/raw_ostream.h> 
using namespace mlir;
using namespace mlir::linalg;
using namespace mlir::memref;
using namespace mlir::arith;

namespace {
struct ArmMatmulConversion : public OpRewritePattern<linalg::MatmulOp> {
  using OpRewritePattern<linalg::MatmulOp>::OpRewritePattern;

  LogicalResult matchAndRewrite(linalg::MatmulOp op,
                                PatternRewriter &rewriter) const override {

    return success();
  }
};

using namespace mlir;
namespace {
struct GenericConversion : public OpRewritePattern<linalg::GenericOp> {
  using OpRewritePattern<linalg::GenericOp>::OpRewritePattern;

  LogicalResult matchAndRewrite(linalg::GenericOp op,
                                PatternRewriter &rewriter) const override {
    llvm::outs() << "Full GenericOp: ";
    op.print(llvm::outs());
    llvm::outs() << "\n\n";

    auto indexingMaps = op.getIndexingMaps();
    llvm::outs() << "Indexing Maps:\n";
    for (auto map : indexingMaps) {
      map.print(llvm::outs());
      llvm::outs() << "\n";
    }

    auto iteratorTypes = op.getIteratorTypes();
    llvm::outs() << "Iterator Types:\n";
    for (auto type : iteratorTypes) {
      llvm::outs() << type << "\n";
    }

    auto &region = op.getRegion();
    llvm::outs() << "Region:\n";
    for (auto &block : region) {
      block.print(llvm::outs());
      llvm::outs() << "\n";
    }

    return success();
  }
};
} 

namespace {

struct ConvertArithAddfToArmSVE : public OpRewritePattern<arith::AddFOp> {
  using OpRewritePattern<arith::AddFOp>::OpRewritePattern;

  LogicalResult matchAndRewrite(arith::AddFOp op,
                                PatternRewriter &rewriter) const override {

    llvm::outs() << "repl\n";

    Value lhs = op.getOperand(0);
    Value rhs = op.getOperand(1);

    int vectorWidth = 16; 

    auto vectorType = VectorType::get({vectorWidth}, rewriter.getBF16Type());

    auto broadcastedLhs =rewriter.create<vector::BroadcastOp>(op.getLoc(), vectorType, lhs);
    auto broadcastedRhs =rewriter.create<vector::BroadcastOp>(op.getLoc(), vectorType, rhs);

    auto maskTrue = rewriter.create<arith::ConstantOp>(
        op.getLoc(),
        DenseIntElementsAttr::get(
            VectorType::get({vectorWidth}, rewriter.getI1Type()), true));

    auto svboolType =
        VectorType::get({16}, rewriter.getI1Type()); 
    auto maskSvbool = rewriter.create<arm_sve::ConvertToSvboolOp>(
        op.getLoc(), svboolType, maskTrue);

    auto armAddOp = rewriter.create<arm_sve::ScalableMaskedAddFOp>(
        op.getLoc(),
        vectorType,     
        maskSvbool,     
        broadcastedLhs, 
        broadcastedRhs  
    );

    rewriter.replaceOp(op, {armAddOp.getResult()});

    return success();
  }
};
} 

class ArmMatmulConversionPass
    : public PassWrapper<ArmMatmulConversionPass, OperationPass<func::FuncOp>> {
public:
  void runOnOperation() override {
    auto func = getOperation();
    MLIRContext *context = func.getContext();

    llvm::outs() << "Registered dialects in the current MLIRContext:\n";
    for (auto *dialect : context->getLoadedDialects()) {
      llvm::outs() << dialect->getNamespace()
                   << "\n"; 
    }

    RewritePatternSet patterns(context);
    patterns.add<ArmMatmulConversion>(context);
    patterns.add<GenericConversion>(context);
    patterns.add<ConvertArithAddfToArmSVE>(context);

    (void)applyPatternsAndFoldGreedily(func, std::move(patterns));
  }
};
} 

std::unique_ptr<Pass> createArmMatmulConversionPass() {
  return std::make_unique<ArmMatmulConversionPass>();
}

int main(int argc, char **argv) {

  mlir::DialectRegistry registry;

  mlir::registerAllDialects(registry);

  registry.insert<func::FuncDialect, arith::ArithDialect, math::MathDialect,
                  linalg::LinalgDialect, affine::AffineDialect, scf::SCFDialect,
                  tensor::TensorDialect, bufferization::BufferizationDialect, 
                  vector::VectorDialect, arm_sve::ArmSVEDialect, memref::MemRefDialect>();

  mlir::registerAllPasses();

  mlir::MLIRContext context;
  context.appendDialectRegistry(registry);

  PassPipelineRegistration<> pipeline(
      "am", "Converts linalg.matmul to ame-sme-matmul operation",
      [](OpPassManager &pm) { pm.addPass(createArmMatmulConversionPass()); });

  return mlir::asMainReturnCode(
      mlir::MlirOptMain(argc, argv, "Linalg-opt driver\n", registry));
}