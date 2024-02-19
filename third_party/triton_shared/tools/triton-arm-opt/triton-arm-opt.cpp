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
    int useless =5;
    return success();
  }
};

// using namespace mlir;
// namespace {
// struct GenericConversion : public OpRewritePattern<linalg::GenericOp> {
//   using OpRewritePattern<linalg::GenericOp>::OpRewritePattern;

//   LogicalResult matchAndRewrite(linalg::GenericOp op,
//                                 PatternRewriter &rewriter) const override {
    

//     return success();
//   }
// };
// } 



class ArmMatmulConversionPass
    : public PassWrapper<ArmMatmulConversionPass, OperationPass<func::FuncOp>> {
public:

  void runOnOperation() override {
    auto func = getOperation();
    MLIRContext *context = func.getContext();

    RewritePatternSet patterns(context);
    // patterns.add<GenericConversion>(context);
    patterns.add<ArmMatmulConversion>(context);

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
                  vector::VectorDialect, arm_sve::ArmSVEDialect, memref::MemRefDialect,func::FuncDialect
                  >();

  mlir::registerAllPasses();

  mlir::MLIRContext context;
  context.appendDialectRegistry(registry);

  PassPipelineRegistration<> pipeline(
      "am", "Converts linalg.matmul to ame-sme-matmul operation",
      [](OpPassManager &pm) { pm.addPass(createArmMatmulConversionPass()); });

  return mlir::asMainReturnCode(
      mlir::MlirOptMain(argc, argv, "Linalg-opt driver\n", registry));
}