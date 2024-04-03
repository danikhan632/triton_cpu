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



struct PrefetchingPass : public PassWrapper<PrefetchingPass, OperationPass<func::FuncOp>> {
  void getDependentDialects(DialectRegistry &registry) const override {
    registry.insert<affine::AffineDialect, arith::ArithDialect, memref::MemRefDialect, scf::SCFDialect>();
  }

  void runOnOperation() override {
    func::FuncOp funcOp = getOperation();
    RewritePatternSet patterns(&getContext());
    populatePrefetchingPatterns(patterns);
    (void)applyPatternsAndFoldGreedily(funcOp, std::move(patterns));
  }

  void populatePrefetchingPatterns(RewritePatternSet &patterns) {
    patterns.add<InsertPrefetchingPattern>(&getContext());
  }

  class InsertPrefetchingPattern : public OpRewritePattern<scf::ForOp> {
  public:
    using OpRewritePattern<scf::ForOp>::OpRewritePattern;

    LogicalResult matchAndRewrite(scf::ForOp forOp, PatternRewriter &rewriter) const override {
      // Check if the loop nest has the expected structure
      if (!hasExpectedLoopStructure(forOp))
        return failure();

      // // Insert prefetching before the innermost loop nest
      // insertPrefetchingBeforeInnerLoop(forOp, rewriter);

      // // Insert prefetching inside the innermost loop nest
      // insertPrefetchingInsideInnerLoop(forOp, rewriter);

      // // Insert prefetching before the final memref.copy operation
      // insertPrefetchingBeforeCopy(forOp, rewriter);

      return success();
    }

  private:


    bool hasExpectedLoopStructure(scf::ForOp forOp) const {
      // Check if the loop nest has the expected structure
      // In this example, we expect three nested scf::ForOp loops
      if (forOp.getBody()->getOperations().size() != 1)
        return false;

      auto innerForOp = dyn_cast<scf::ForOp>(forOp.getBody()->getOperations().front());
      if (!innerForOp || innerForOp.getBody()->getOperations().size() != 1)
        return false;

      auto innerMostForOp = dyn_cast<scf::ForOp>(innerForOp.getBody()->getOperations().front());
      if (!innerMostForOp)
        return false;

      return true;
    }

    // void insertPrefetchingBeforeInnerLoop(scf::ForOp forOp, PatternRewriter &rewriter) const {
    //   auto innerForOp = dyn_cast<scf::ForOp>(forOp.getBody()->getOperations().front());
    //   auto innerMostForOp = dyn_cast<scf::ForOp>(innerForOp.getBody()->getOperations().front());

    //   OpBuilder::InsertionGuard guard(rewriter);
    //   rewriter.setInsertionPoint(innerMostForOp);

    //   // Get the memref operands for prefetching
    //   auto memrefA = innerMostForOp.getOperand(0);
    //   auto memrefB = innerMostForOp.getOperand(1);

    //   // Create constants for prefetch distance and indices
    //   auto prefetchDistance = rewriter.create<arith::ConstantIndexOp>(innerMostForOp.getLoc(), 2);
    //   auto zeroIndex = rewriter.create<arith::ConstantIndexOp>(innerMostForOp.getLoc(), 0);

    //   // Create affine expressions for prefetch offsets
    //   auto dimExpr0 = rewriter.getAffineDimExpr(0);
    //   auto dimExpr1 = rewriter.getAffineDimExpr(1);
    //   auto distanceExpr = rewriter.getAffineSymbolExpr(0);

    //   // Calculate prefetch offsets
    //   auto prefetchOffsetA = rewriter.create<mlir::affine::AffineApplyOp>(
    //       innerMostForOp.getLoc(),
    //       AffineMap::get(3, 1, {dimExpr0, dimExpr1, distanceExpr}, rewriter.getContext()),
    //       ValueRange{innerMostForOp.getInductionVar(), innerForOp.getInductionVar(), prefetchDistance});
    //   auto prefetchOffsetB = rewriter.create<mlir::affine::AffineApplyOp>(
    //       innerMostForOp.getLoc(),
    //       AffineMap::get(3, 1, {distanceExpr, dimExpr0, dimExpr1}, rewriter.getContext()),
    //       ValueRange{prefetchDistance, innerMostForOp.getInductionVar(), innerForOp.getInductionVar()});

    //   // Create memref.prefetch operations
    //   rewriter.create<memref::PrefetchOp>(innerMostForOp.getLoc(), memrefA, prefetchOffsetA,
    //                                       /*isWrite=*/false, /*localityHint=*/0, /*isDataCache=*/true);
    //   rewriter.create<memref::PrefetchOp>(innerMostForOp.getLoc(), memrefB, prefetchOffsetB,
    //                                       /*isWrite=*/false, /*localityHint=*/0, /*isDataCache=*/true);
    // }

    // void insertPrefetchingInsideInnerLoop(scf::ForOp forOp, PatternRewriter &rewriter) const {
    //   auto innerForOp = dyn_cast<scf::ForOp>(forOp.getBody()->getOperations().front());
    //   auto innerMostForOp = dyn_cast<scf::ForOp>(innerForOp.getBody()->getOperations().front());

    //   OpBuilder::InsertionGuard guard(rewriter);
    //   rewriter.setInsertionPointToEnd(innerMostForOp.getBody());

    //   // Get the memref operands for prefetching
    //   auto memrefA = innerMostForOp.getOperand(0);
    //   auto memrefB = innerMostForOp.getOperand(1);

    //   // Create constants for prefetch distance and indices
    //   auto prefetchDistance = rewriter.create<arith::ConstantIndexOp>(innerMostForOp.getLoc(), 2);
    //   auto zeroIndex = rewriter.create<arith::ConstantIndexOp>(innerMostForOp.getLoc(), 0);

    //   // Create affine expressions for prefetch offsets
    //   auto dimExpr0 = rewriter.getAffineDimExpr(0);
    //   auto dimExpr1 = rewriter.getAffineDimExpr(1);
    //   auto distanceExpr = rewriter.getAffineSymbolExpr(0);

    //   // Calculate prefetch offsets
    //   auto prefetchOffsetA = rewriter.create<mlir::affine::AffineApplyOp>(
    //       innerMostForOp.getLoc(),
    //       AffineMap::get(3, 1, {dimExpr0, dimExpr1, distanceExpr}, rewriter.getContext()),
    //       ValueRange{innerMostForOp.getInductionVar(), innerForOp.getInductionVar(), prefetchDistance});
    //   auto prefetchOffsetB = rewriter.create<mlir::affine::AffineApplyOp>(
    //       innerMostForOp.getLoc(),
    //       AffineMap::get(3, 1, {distanceExpr, dimExpr0, dimExpr1}, rewriter.getContext()),
    //       ValueRange{prefetchDistance, innerMostForOp.getInductionVar(), innerForOp.getInductionVar()});

    //   // Create memref.prefetch operations
    //   rewriter.create<memref::PrefetchOp>(innerMostForOp.getLoc(), memrefA, prefetchOffsetA,
    //                                       /*isWrite=*/false, /*localityHint=*/0, /*isDataCache=*/true);
    //   rewriter.create<memref::PrefetchOp>(innerMostForOp.getLoc(), memrefB, prefetchOffsetB,
    //                                       /*isWrite=*/false, /*localityHint=*/0, /*isDataCache=*/true);
    // }

    void insertPrefetchingBeforeCopy(scf::ForOp forOp, PatternRewriter &rewriter) const {
      auto copyOp = forOp.getBody()->getTerminator()->getPrevNode();
      if (!isa<memref::CopyOp>(copyOp))
        return;

      OpBuilder::InsertionGuard guard(rewriter);
      rewriter.setInsertionPoint(copyOp);

      // Get the memref operand for prefetching
      auto memref = cast<memref::CopyOp>(copyOp).getTarget();

      // Create constants for prefetch indices
      auto zeroIndex = rewriter.create<arith::ConstantIndexOp>(copyOp->getLoc(), 0);

      // Create memref.prefetch operation
      rewriter.create<memref::PrefetchOp>(copyOp->getLoc(), memref, ValueRange{zeroIndex},
                                          /*isWrite=*/true, /*localityHint=*/0, /*isDataCache=*/true);
    }
  
  
  
  };
};







struct RestrictToTensorOpsPass
    : public PassWrapper<RestrictToTensorOpsPass, OperationPass<func::FuncOp>> {
  MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(RestrictToTensorOpsPass)

  void runOnOperation() override {
    func::FuncOp funcOp = getOperation();
    MLIRContext *context = &getContext();

    funcOp.walk([&](bufferization::ToTensorOp op) {
      OpBuilder builder(op);
      Location loc = op.getLoc();
      Value alloc = op.getMemref();
      Type tensorType = op.getType();

      Value tensor = builder.create<bufferization::ToTensorOp>(
          loc, tensorType, alloc, true /* restrict */, true /* writable */);
      op.replaceAllUsesWith(tensor);
      op.erase();
    });
  }
};
struct OneShotBufferizationPass : public PassWrapper<OneShotBufferizationPass, OperationPass<ModuleOp>> {
  MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(OneShotBufferizationPass)

  void getDependentDialects(DialectRegistry &registry) const override {
    registry.insert<bufferization::BufferizationDialect>();
  }

  void runOnOperation() override {
    ModuleOp moduleOp = getOperation();
    MLIRContext *context = &getContext();

    // Set up OneShotBufferizationOptions.
    bufferization::OneShotBufferizationOptions options;
    //  auto options = mlir::bufferization::OneShotBufferizationOptions();
    options.allowReturnAllocsFromLoops = true;
    options.allowUnknownOps = true;
    options.bufferizeFunctionBoundaries = true;
    options.unknownTypeConverterFn =
        [](mlir::Value value, mlir::Attribute memorySpace,
           const mlir::bufferization::BufferizationOptions &options) {
          return mlir::bufferization::getMemRefTypeWithStaticIdentityLayout(
              value.getType().cast<mlir::TensorType>(), memorySpace);
        };
    options.setFunctionBoundaryTypeConversion(
        mlir::bufferization::LayoutMapOption::IdentityLayoutMap);
    // options.getMemorySpaceFn = [](mlir::TensorType t) {
    //   if (auto rt = t.dyn_cast<mlir::RankedTensorType>())
    //     return rt.getEncoding();
    //   return mlir::Attribute();
    // };

    // Run One-Shot Bufferize.
    if (failed(bufferization::runOneShotBufferize(moduleOp, options))) {
      return signalPassFailure();
    }
  }
};



struct MatmulTileConversion : public OpRewritePattern<linalg::MatmulOp> {
  explicit MatmulTileConversion(MLIRContext *context, bool enableSME)
      : OpRewritePattern<linalg::MatmulOp>(context), enableSME(enableSME) {}

  LogicalResult matchAndRewrite(linalg::MatmulOp op,
                                PatternRewriter &rewriter) const override {
    linalg::LinalgTilingOptions tilingOptions;

    tilingOptions.setTileSizeComputationFunction(
        [&](OpBuilder &b, Operation *) {
          SmallVector<Value, 4> sizes;
          sizes.reserve(3);

          Location loc = op.getLoc();
          Value vscale = b.create<vector::VectorScaleOp>(loc, b.getIndexType());

          if (enableSME) {
            Value tileM = b.create<arith::ConstantIndexOp>(loc, 4);
            Value tileMScaled = b.create<arith::MulIOp>(loc, tileM, vscale);
            sizes.push_back(tileMScaled);
          } else {
            Value tileM = b.create<arith::ConstantIndexOp>(loc, 2);
            sizes.push_back(tileM);
          }
          Value tileN = b.create<arith::ConstantIndexOp>(loc, 4);
          Value tileNScaled = b.create<arith::MulIOp>(loc, tileN, vscale);
          sizes.push_back(tileNScaled);
          Value tileK = b.create<arith::ConstantIndexOp>(loc, 2);
          sizes.push_back(tileK);

          return sizes;
        });
    std::cout << enableSME << std::endl;

    auto tiledOpResult = tileLinalgOp(rewriter, op, tilingOptions);
    if (failed(tiledOpResult)) {
      std::cout << "TILING FAILED" << std::endl;
      return failure();
    }

    SmallVector<int64_t, 4> inputVectorSizes = {enableSME ? 4 : 2, 4, 2};
    SmallVector<bool, 4> inputScalableVecDims = {enableSME, true, false};

    if (failed(linalg::vectorize(
            rewriter, cast<linalg::LinalgOp>(tiledOpResult->op.getOperation()),
            inputVectorSizes, inputScalableVecDims))) {
      std::cout << "Vectorization FAILED" << std::endl;
      return failure();
    }

    MLIRContext *context = getContext();
    rewriter.replaceOp(op, tiledOpResult->tensorResults);

    return success();
  }


private:
  bool enableSME;
};

struct MatmulTileConversionPass
    : public PassWrapper<MatmulTileConversionPass,
                          OperationPass<func::FuncOp>> {
  MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(MatmulTileConversionPass)

  explicit MatmulTileConversionPass(bool enableSME) : enableSME(enableSME) {}

  void getDependentDialects(DialectRegistry &registry) const override {
    registry.insert<linalg::LinalgDialect, func::FuncDialect, scf::SCFDialect,
                    vector::VectorDialect>();
  }

  void runOnOperation() override {
    func::FuncOp funcOp = getOperation();
    MLIRContext *context = &getContext();

    RewritePatternSet patterns(context);
    patterns.add<MatmulTileConversion>(context, enableSME);

    ConversionTarget target(*context);
    target.addLegalDialect<linalg::LinalgDialect, func::FuncDialect,
                           vector::VectorDialect, affine::AffineDialect,
                           scf::SCFDialect>();

    if (failed(applyPatternsAndFoldGreedily(funcOp, std::move(patterns)))) {
      signalPassFailure();
    }
  }

private:
  bool enableSME;
};

struct OuterProductVectorizationPass
    : public PassWrapper<OuterProductVectorizationPass,
                          OperationPass<func::FuncOp>> {
  MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(OuterProductVectorizationPass)

  void getDependentDialects(DialectRegistry &registry) const override {
    registry.insert<vector::VectorDialect, func::FuncDialect>();
  }

  void runOnOperation() override {
   func::FuncOp funcOp = getOperation();
    MLIRContext *context = funcOp.getContext();
    RewritePatternSet patterns(context);
    ConversionTarget target(*context);
      // Apply patterns for lowering masked transfers
    transform::ApplyLowerMaskedTransfersPatternsOp lowerMaskedTransfersPatterns;
    lowerMaskedTransfersPatterns.populatePatterns(patterns);

    // Apply patterns for transfer permutation
    transform::ApplyTransferPermutationPatternsOp transferPermutationPatterns;
    transferPermutationPatterns.populatePatterns(patterns);

    // Apply patterns for reduction to contract
    transform::ApplyVectorReductionToContractPatternsOp reductionToContractPatterns;
    reductionToContractPatterns.populatePatterns(patterns);
    transform::ApplyLowerMasksPatternsOp lowerMasksPatterns;
    lowerMasksPatterns.populatePatterns(patterns);

    // Apply patterns for rank-reducing subview
    transform::ApplyRankReducingSubviewPatternsOp rankReducingSubviewPatterns;
    rankReducingSubviewPatterns.populatePatterns(patterns);
    
    vector::populateVectorContractLoweringPatterns(
        patterns, vector::VectorTransformsOptions().setVectorTransformsOptions(
                      vector::VectorContractLowering::OuterProduct));
    target.addIllegalOp<vector::ContractionOp>();  

    if (failed(applyPatternsAndFoldGreedily(funcOp, std::move(patterns)))) {
      return signalPassFailure();
    }
  }
};


  std::unique_ptr<Pass> createOuterProductVectorizationPass() {
    return std::make_unique<OuterProductVectorizationPass>();
  }
  std::unique_ptr<Pass> createPrefetchPass() {
    return std::make_unique<PrefetchingPass>();
  }
  std::unique_ptr<Pass> createMatmulTileConversionPass(bool enableSME) {
    return std::make_unique<MatmulTileConversionPass>(enableSME);
  }

  std::unique_ptr<Pass> createRestrictToTensorOpsPass() {
    return std::make_unique<RestrictToTensorOpsPass>();
  }

  std::unique_ptr<Pass> createOneShotBufferizationPass() {
    return std::make_unique<OneShotBufferizationPass>();
  }
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


  PassPipelineRegistration<> smeConversionPipeline(
      "sme-conversion",
      "Converts linalg.matmul to a more optimized form using SME",
      [](OpPassManager &pm) {
        pm.addPass(matmul_conversion::createMatmulTileConversionPass(true));
        pm.addPass(matmul_conversion::createRestrictToTensorOpsPass());
        pm.addPass(matmul_conversion::createOneShotBufferizationPass());
        pm.addPass(matmul_conversion::createOuterProductVectorizationPass());
      });

  PassPipelineRegistration<> sveConversionPipeline(
      "sve-conversion",
      "Converts linalg.matmul to a more optimized form using SME",
      [](OpPassManager &pm) {
        pm.addPass(matmul_conversion::createMatmulTileConversionPass(false));
        pm.addPass(matmul_conversion::createRestrictToTensorOpsPass());
        pm.addPass(matmul_conversion::createOneShotBufferizationPass());
        pm.addPass(matmul_conversion::createOuterProductVectorizationPass());
      });

  PassPipelineRegistration<> prefConversionPipeline(
      "prefetch",
      "Converts linalg.matmul to a more optimized form using SME",
      [](OpPassManager &pm) {
        pm.addPass(matmul_conversion::createPrefetchPass());
      });



  return asMainReturnCode(
      MlirOptMain(argc, argv, "Optimizer Driver\n", registry));
}