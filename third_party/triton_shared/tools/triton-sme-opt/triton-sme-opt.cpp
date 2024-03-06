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

//------------------------------------------------------------------------------



namespace {





struct PrefetchPattern : public OpRewritePattern<linalg::MatmulOp> {
  using OpRewritePattern<linalg::MatmulOp>::OpRewritePattern;

  LogicalResult matchAndRewrite(linalg::MatmulOp matmulOp,
                                PatternRewriter &rewriter) const override {
    auto loc = matmulOp.getLoc();
    auto aMemRef = matmulOp.getDpsInputOperand(0)->get();
    auto bMemRef = matmulOp.getDpsInputOperand(1)->get();

    auto aMemRefType = aMemRef.getType().cast<MemRefType>();
    auto bMemRefType = bMemRef.getType().cast<MemRefType>();
    auto aShape = aMemRefType.getShape();
    auto bShape = bMemRefType.getShape();

    auto aPrefetchShape = llvm::ArrayRef<int64_t>{aShape[0], 16};
    auto bPrefetchShape = llvm::ArrayRef<int64_t>{16, bShape[1]};

    auto aPrefetchMemRef = rewriter.create<memref::AllocOp>(loc, MemRefType::get(aPrefetchShape, aMemRefType.getElementType()));
    auto bPrefetchMemRef = rewriter.create<memref::AllocOp>(loc, MemRefType::get(bPrefetchShape, bMemRefType.getElementType()));

    auto aOffset = llvm::ArrayRef<int64_t>{0, 0};
    auto bOffset = llvm::ArrayRef<int64_t>{0, 0};
    auto aSize = llvm::ArrayRef<int64_t>{aShape[0], std::min<int64_t>(16, aShape[1])};
    auto bSize = llvm::ArrayRef<int64_t>{std::min<int64_t>(16, bShape[0]), bShape[1]};
    auto aStride = llvm::ArrayRef<int64_t>{1, 1};
    auto bStride = llvm::ArrayRef<int64_t>{1, 1};

    auto aSubview = rewriter.create<memref::SubViewOp>(loc, aMemRef, aOffset, aSize, aStride);
    auto bSubview = rewriter.create<memref::SubViewOp>(loc, bMemRef, bOffset, bSize, bStride);

    rewriter.create<memref::CopyOp>(loc, aSubview, aPrefetchMemRef);
    rewriter.create<memref::CopyOp>(loc, bSubview, bPrefetchMemRef);

    rewriter.replaceOpWithNewOp<linalg::MatmulOp>(matmulOp, matmulOp.getType(0), ValueRange{aPrefetchMemRef, bPrefetchMemRef}, matmulOp->getAttrs());

    return success();
  }
};

struct PrefetchPass : public PassWrapper<PrefetchPass, OperationPass<func::FuncOp>> {
  MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(PrefetchPass)

  void runOnOperation() override {
    auto funcOp = getOperation();

    RewritePatternSet patterns(&getContext());
    patterns.add<PrefetchPattern>(&getContext());

    if (failed(applyPatternsAndFoldGreedily(funcOp, std::move(patterns)))) {
      signalPassFailure();
    }
  }
};



//----------------------------------------------------------------------------------

struct OuterProductVectorizationPass : public PassWrapper<OuterProductVectorizationPass, OperationPass<func::FuncOp>> {
  void getDependentDialects(DialectRegistry &registry) const override {
    registry.insert<vector::VectorDialect, func::FuncDialect>();
  }

  void runOnOperation() override {
    func::FuncOp funcOp = getOperation();
    MLIRContext *context = funcOp.getContext();
    RewritePatternSet patterns(context);

    // Step 4: Lower vector.multi_reduction to vector.contract (+ some helpful patterns)
    vector::VectorTransformsOptions vectorTransformsOptions;
    vectorTransformsOptions.setVectorTransformsOptions(vector::VectorContractLowering::OuterProduct);
    vector::populateVectorTransferDropUnitDimsPatterns(patterns);
    vector::populateVectorReductionToContractPatterns(patterns);

    if (failed(applyPatternsAndFoldGreedily(funcOp, std::move(patterns)))) {
      return signalPassFailure();
    }

    // Step 5: Lower vector.contract to vector.outerproduct. Also drop unit dims.
    patterns.clear();
    vectorTransformsOptions.setVectorTransformsOptions(vector::VectorContractLowering::OuterProduct);
    vector::populateVectorTransferDropUnitDimsPatterns(patterns);

    if (failed(applyPatternsAndFoldGreedily(funcOp, std::move(patterns)))) {
      return signalPassFailure();
    }
  }
};


  struct MatmulTileConversion: public OpRewritePattern <linalg::MatmulOp> {
    using OpRewritePattern <linalg::MatmulOp> ::OpRewritePattern;

    LogicalResult matchAndRewrite(linalg::MatmulOp op, PatternRewriter & rewriter) const override {

      SmallVector<int64_t, 3> tileSizes = {4, 4,1}; // Tile sizes for [M, N, K] dimensions tofo


      linalg::LinalgTilingOptions tilingOptions = linalg::LinalgTilingOptions().setTileSizes(tileSizes);
      auto tiledOpResult = tileLinalgOp(rewriter, op, tilingOptions);
      if (failed(tiledOpResult)) {
        std::cout << "TILING FAILED" << std::endl;
        return failure();
      }

      if (failed(linalg::vectorize(rewriter, cast<linalg::LinalgOp> (tiledOpResult->op.getOperation())))) {
        return failure();
      }
      MLIRContext *context = getContext();


      rewriter.replaceOp(op, tiledOpResult->tensorResults);
      return success();

    }
  };

  class MatmulTileConversionPass
    : public PassWrapper <MatmulTileConversionPass, OperationPass <func::FuncOp>> {
      public: void getDependentDialects(DialectRegistry & registry) const override {
        registry.insert <linalg::LinalgDialect, func::FuncDialect, scf::SCFDialect, vector::VectorDialect> ();
      }

      void runOnOperation() override {
        func::FuncOp funcOp = getOperation();
        MLIRContext *context = &getContext();
      

        RewritePatternSet patterns(context);
        patterns.add<MatmulTileConversion>(context);

        ConversionTarget target( * context);
        target.addLegalDialect <linalg::LinalgDialect, func::FuncDialect, vector::VectorDialect, affine::AffineDialect, scf::SCFDialect> ();

        if (failed(applyPatternsAndFoldGreedily(funcOp, std::move(patterns)))) {
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
  std::unique_ptr<Pass> createPrefetchPass() {
    return std::make_unique<PrefetchPass>();
  }
}

int main(int argc, char ** argv) {
  mlir::DialectRegistry registry;

  registry.insert<func::FuncDialect, arith::ArithDialect, math::MathDialect,
    linalg::LinalgDialect, affine::AffineDialect, scf::SCFDialect,
    tensor::TensorDialect, bufferization::BufferizationDialect,
    vector::VectorDialect, memref::MemRefDialect, func::FuncDialect>();


  registerAllDialects(registry);
  registerAllPasses();

  MLIRContext context;
  context.appendDialectRegistry(registry);
  context.loadAllAvailableDialects();

  PassPipelineRegistration<> pipeline(
    "sme-converison",
    "Converts linalg.matmul to a more optimized form",
    [](OpPassManager & pm) {
      pm.addPass(createMatmulTileConversionPass());
      pm.addPass(createOuterProductVectorizationPass());
    }
  );


  return asMainReturnCode(
    MlirOptMain(argc, argv, "Optimizer Driver\n", registry)
  );
}