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

#include "mlir/Transforms/DialectConversion.h"

#include <iostream>

#include "mlir/IR/Operation.h"

#include <llvm/Support/raw_ostream.h>

using namespace mlir;
using namespace mlir::linalg;
using namespace mlir::memref;
using namespace mlir::arith;

using namespace mlir;




namespace {

  struct ArmMatmulConversion: public OpRewritePattern < linalg::MatmulOp > {
    using OpRewritePattern < linalg::MatmulOp > ::OpRewritePattern;

    LogicalResult matchAndRewrite(linalg::MatmulOp op, PatternRewriter & rewriter) const override {

      SmallVector < int64_t, 3 > tileSizes = {4, 4,1}; // Tile sizes for [M, N, K] dimensions

      LinalgTilingOptions tilingOptions = LinalgTilingOptions().setTileSizes(tileSizes);

      // Note the correct type for the tiled operation result
      auto tiledOpResult = tileLinalgOp(rewriter, op, tilingOptions);
      if (failed(tiledOpResult)) {
        std::cout << "dang it, inshallah next time works" << std::endl;
        return failure();
      }
      // tiledOpResult->op.getOperation()->print(llvm::outs());


      // Apply vectorization
      // This step assumes that the tiled operation can be directly vectorized,
      // which may require additional setup or configuration in a more complex scenario.
      if (failed(vectorize(rewriter, cast<LinalgOp> (tiledOpResult->op.getOperation())))) {
        return failure();
      }
      // tiledOpResult->op.getOperation()->print(llvm::outs());

      // RewritePatternSet vectorPatterns(tiledOpResult->op.getOperation());
      // mlir::vector::VectorTransformsOptions vectorTransformsOptions;
      // mlir::vector::populateVectorTransferFullPartialPatterns(vectorPatterns, vectorTransformsOptions);
      // vectorTransformsOptions.setVectorTransformsOptions(vector::VectorContractLowering::OuterProduct);
      // vector::populateVectorTransferDropUnitDimsPatterns(vectorPatterns);
      // vector::populateVectorMaskMaterializationPatterns(vectorPatterns, /*force32BitVectorIndices=*/false);

      // if (failed(applyPatternsAndFoldGreedily(tiledOpResult->op.getOperation(), std::move(vectorPatterns)))) {
      //   llvm::errs() << "Failed to apply vector transformation patterns.\n";
      //   return failure();
      // }
      llvm::outs() << "\n";
      for (auto* loopOp : tiledOpResult->loops) {
          if (loopOp) {
              loopOp->print(llvm::outs());
          } else {
              llvm::outs() << "null\n";
          }
      }
      llvm::outs() << "\n";
      rewriter.eraseOp(op);
      return success();

    }
  };

  class ArmMatmulConversionPass
    : public PassWrapper < ArmMatmulConversionPass, OperationPass < func::FuncOp >> {
      public: void getDependentDialects(DialectRegistry & registry) const override {
        registry.insert < linalg::LinalgDialect, mlir::func::FuncDialect, scf::SCFDialect, mlir::vector::VectorDialect > ();
      }

      void runOnOperation() override {
        func::FuncOp funcOp = getOperation();
        MLIRContext * context = & getContext();

        RewritePatternSet patterns(context);
        patterns.add<ArmMatmulConversion>(context);

        ConversionTarget target( * context);
        target.addLegalDialect <linalg::LinalgDialect, mlir::func::FuncDialect, mlir::vector::VectorDialect, mlir::affine::AffineDialect, scf::SCFDialect> ();
        target.addIllegalOp<linalg::MatmulOp> (); // Assuming you want to make linalg.matmul illegal to ensure conversion

        patterns.add<ArmMatmulConversion>(context);

        if (failed(applyPartialConversion(funcOp, target, std::move(patterns)))) {
          signalPassFailure();
        }
      }
    };

  std::unique_ptr < Pass > createArmMatmulConversionPass() {
    return std::make_unique < ArmMatmulConversionPass > ();
  }
}

int main(int argc, char ** argv) {
  mlir::DialectRegistry registry;

  registry.insert < func::FuncDialect, arith::ArithDialect, math::MathDialect,
    linalg::LinalgDialect, affine::AffineDialect, scf::SCFDialect,
    tensor::TensorDialect, bufferization::BufferizationDialect,
    vector::VectorDialect, memref::MemRefDialect, func::FuncDialect >
    ();

  // Register all the necessary dialects
  registerAllDialects(registry);
  registerAllPasses();

  MLIRContext context;
  context.appendDialectRegistry(registry);
  context.loadAllAvailableDialects();

  // Register your pass pipeline
  PassPipelineRegistration < > pipeline(
    "am",
    "Converts linalg.matmul to a more optimized form",
    [](OpPassManager & pm) {
      pm.addPass(createArmMatmulConversionPass());
    }
  );

  // Process command line arguments and run the pass pipeline
  return mlir::asMainReturnCode(
    mlir::MlirOptMain(argc, argv, "Optimizer Driver\n", registry)
  );
}