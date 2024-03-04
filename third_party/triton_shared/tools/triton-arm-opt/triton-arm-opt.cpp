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
using namespace mlir::vector;
//------------------------------------------------------------------------------------------------------------------------------------


namespace {

class LinalgMatmulPrefetcher {
public:
  explicit LinalgMatmulPrefetcher(scf::ForOp forOp) : forOp(forOp) {}

  void run() {
    OpBuilder builder(forOp.getContext());
    // Walk through each MatMul operation within the loop.
    forOp.walk([&](linalg::MatmulOp matmulOp) {
      // Prefetch inputs and outputs at the start of the loop.
      // The prefetch locality and cache type are chosen arbitrarily here and should be tuned as per your target architecture and performance analysis.
      auto inputTensor = matmulOp.getInputs()[0];
      auto outputTensor = matmulOp.getOutputs()[0];
      
      builder.setInsertionPointToStart(forOp.getBody());
      builder.create<memref::PrefetchOp>(matmulOp.getLoc(), inputTensor, /*isWrite=*/false, /*localityHint=*/3, /*isDataCache=*/true);
      // Prefetch output tensor only if beneficial. This example shows prefetching for both input and output.
      builder.create<memref::PrefetchOp>(matmulOp.getLoc(), outputTensor, /*isWrite=*/true, /*localityHint=*/3, /*isDataCache=*/true);
    });
  }

private:
  scf::ForOp forOp;
};

struct LinalgMatmulPrefetchPass : public PassWrapper<LinalgMatmulPrefetchPass, OperationPass<func::FuncOp>> {
  void runOnOperation() override {
    getOperation().walk([&](scf::ForOp forOp) {
      LinalgMatmulPrefetcher prefetcher(forOp);
      prefetcher.run();
    });
  }
};

std::unique_ptr<Pass> createLinalgMatmulPrefetchPass() {
  return std::make_unique<LinalgMatmulPrefetchPass>();
}

} // end anonymous namespace


//------------------------------------------------------------------------------------------------------------------------------------------
namespace {
    struct OuterProductVectorizationPass : public PassWrapper<OuterProductVectorizationPass, OperationPass<func::FuncOp>> {
    void getDependentDialects(DialectRegistry &registry) const override {
      registry.insert<vector::VectorDialect, func::FuncDialect>();
    }

    void runOnOperation() override {
      llvm::outs() << "wayysaysyaysyasyays\n";
        func::FuncOp funcOp = getOperation();
        MLIRContext *context = funcOp.getContext();
        RewritePatternSet patterns(context);

        // Step 4: Lower vector.multi_reduction to vector.contract
        mlir::vector::VectorTransformsOptions vectorTransformsOptions;
        mlir::vector::populateVectorTransferFullPartialPatterns(patterns, vectorTransformsOptions);
        vectorTransformsOptions.setVectorTransformsOptions(vector::VectorContractLowering::OuterProduct);


        if (failed(applyPatternsAndFoldGreedily(funcOp, std::move(patterns)))) {
          signalPassFailure();
        }
          llvm::outs() << "\n";
        funcOp->print(llvm::outs());

      llvm::outs() << "\n";

  }
};



  struct MatmulTileConversion: public OpRewritePattern < linalg::MatmulOp > {
    using OpRewritePattern < linalg::MatmulOp > ::OpRewritePattern;

    LogicalResult matchAndRewrite(linalg::MatmulOp op, PatternRewriter & rewriter) const override {

      SmallVector < int64_t, 3 > tileSizes = {4, 4,1}; // Tile sizes for [M, N, K] dimensions

      LinalgTilingOptions tilingOptions = LinalgTilingOptions().setTileSizes(tileSizes);
      auto tiledOpResult = tileLinalgOp(rewriter, op, tilingOptions);
      if (failed(tiledOpResult)) {
        std::cout << "dang it, inshallah next time works" << std::endl;
        return failure();
      }

      if (failed(vectorize(rewriter, cast<LinalgOp> (tiledOpResult->op.getOperation())))) {
        return failure();
      }
      MLIRContext *context = getContext();



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

  class MatmulTileConversionPass
    : public PassWrapper < MatmulTileConversionPass, OperationPass < func::FuncOp >> {
      public: void getDependentDialects(DialectRegistry & registry) const override {
        registry.insert < linalg::LinalgDialect, mlir::func::FuncDialect, scf::SCFDialect, mlir::vector::VectorDialect > ();
      }

      void runOnOperation() override {
        func::FuncOp funcOp = getOperation();
        MLIRContext *context = &getContext();

        RewritePatternSet patterns(context);
        patterns.add<MatmulTileConversion>(context);

        ConversionTarget target( * context);
        target.addLegalDialect <linalg::LinalgDialect, mlir::func::FuncDialect, mlir::vector::VectorDialect, mlir::affine::AffineDialect, scf::SCFDialect> ();
        target.addIllegalOp<linalg::MatmulOp>(); // Assuming you want to make linalg.matmul illegal to ensure conversion


        if (failed(applyPartialConversion(funcOp, target, std::move(patterns)))) {
          signalPassFailure();
        }
      }
    };

  std::unique_ptr <Pass> createOuterProductVectorizationPass() {
    return std::make_unique <OuterProductVectorizationPass>();
  }
    std::unique_ptr <Pass> createMatmulTileConversionPass() {
    return std::make_unique <MatmulTileConversionPass>();
  }
}

int main(int argc, char ** argv) {
  mlir::DialectRegistry registry;

  registry.insert<func::FuncDialect, arith::ArithDialect, math::MathDialect,
    linalg::LinalgDialect, affine::AffineDialect, scf::SCFDialect,
    tensor::TensorDialect, bufferization::BufferizationDialect,
    vector::VectorDialect, memref::MemRefDialect, func::FuncDialect>();

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
      pm.addPass(createMatmulTileConversionPass());
      pm.addPass(createOuterProductVectorizationPass());
    }
  );

  // Process command line arguments and run the pass pipeline
  return mlir::asMainReturnCode(
    mlir::MlirOptMain(argc, argv, "Optimizer Driver\n", registry)
  );
}