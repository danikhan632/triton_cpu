#include "mlir/Dialect/Linalg/IR/Linalg.h"
#include "mlir/Dialect/Vector/IR/VectorOps.h"
#include "mlir/Dialect/Vector/TransformOps/VectorTransformOps.h"
#include "mlir/IR/Dialect.h"
#include "mlir/IR/MLIRContext.h"
#include "mlir/IR/Operation.h"
#include "mlir/IR/PatternMatch.h"
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
#include "mlir/Dialect/Linalg/Transforms/Transforms.h"
#include "mlir/Dialect/Tensor/Transforms/Passes.h"


using namespace mlir;
constexpr int64_t MAX_LOOPS = 64;
//------------------------------------------------------------------------------

namespace {

// struct PrefetchPattern : public OpRewritePattern<scf::ForOp> {
//   using OpRewritePattern<scf::ForOp>::OpRewritePattern;

//   LogicalResult matchAndRewrite(scf::ForOp forOp, PatternRewriter &rewriter)
//   const override {
//     // Check if the loop body contains tensor.extract_slice and
//     vector.contract operations if
//     (!hasTensorExtractSliceAndVectorContract(forOp.getBody()))
//       return failure();

//     auto loc = forOp.getLoc();
//     auto aMemRef = getMemRefOperand(forOp.getBody(), 0);
//     auto bMemRef = getMemRefOperand(forOp.getBody(), 1);
//     auto cMemRef = getMemRefOperand(forOp.getBody(), 2);

//     if (!aMemRef || !bMemRef || !cMemRef)
//       return failure();

//     auto aMemRefType = aMemRef.getType().cast<MemRefType>();
//     auto bMemRefType = bMemRef.getType().cast<MemRefType>();
//     auto cMemRefType = cMemRef.getType().cast<MemRefType>();

//     auto aTensorType = RankedTensorType::get(aMemRefType.getShape(),
//     aMemRefType.getElementType()); auto bTensorType =
//     RankedTensorType::get(bMemRefType.getShape(),
//     bMemRefType.getElementType()); auto cTensorType =
//     RankedTensorType::get(cMemRefType.getShape(),
//     cMemRefType.getElementType());

//     // Prefetch input memrefs
//     auto aPrefetchSize = rewriter.create<arith::ConstantOp>(loc,
//     rewriter.getIndexAttr(16)); auto bPrefetchSize =
//     rewriter.create<arith::ConstantOp>(loc, rewriter.getIndexAttr(16));

//     auto aPrefetchTag = rewriter.create<memref::DmaStartOp>(loc, aMemRef,
//     ValueRange{}, aPrefetchSize, aMemRef); auto bPrefetchTag =
//     rewriter.create<memref::DmaStartOp>(loc, bMemRef, ValueRange{},
//     bPrefetchSize, bMemRef);

//     // Prefetch output memref
//     auto cPrefetchSize = rewriter.create<arith::ConstantOp>(loc,
//     rewriter.getIndexAttr(16)); auto cPrefetchTag =
//     rewriter.create<memref::DmaStartOp>(loc, cMemRef, ValueRange{},
//     cPrefetchSize, cMemRef);

//     // Wait for prefetch to complete
//     rewriter.create<memref::DmaWaitOp>(loc, aPrefetchTag, aMemRef,
//     ValueRange{}, aPrefetchSize, aMemRef);
//     rewriter.create<memref::DmaWaitOp>(loc, bPrefetchTag, bMemRef,
//     ValueRange{}, bPrefetchSize, bMemRef);
//     rewriter.create<memref::DmaWaitOp>(loc, cPrefetchTag, cMemRef,
//     ValueRange{}, cPrefetchSize, cMemRef);

//     return success();
//   }

// private:
//   bool hasTensorExtractSliceAndVectorContract(Block *block) const {
//     return llvm::any_of(*block, [](Operation &op) {
//       return isa<tensor::ExtractSliceOp, vector::ContractionOp>(op);
//     });
//   }

//   Value getMemRefOperand(Block *block, int64_t index) const {
//     auto extractSliceOps = block->getOps<tensor::ExtractSliceOp>();
//     auto extractSliceOp = extractSliceOps.begin();
//     if (extractSliceOp == extractSliceOps.end())
//       return nullptr;
//     return extractSliceOp->getOperand(index);
//   }
// };

// struct PrefetchPass : public PassWrapper<PrefetchPass,
// OperationPass<func::FuncOp>> {
//   MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(PrefetchPass)

//   void runOnOperation() override {
//     auto funcOp = getOperation();

//     RewritePatternSet patterns(&getContext());
//     patterns.add<PrefetchPattern>(&getContext());

//     if (failed(applyPatternsAndFoldGreedily(funcOp, std::move(patterns)))) {
//       signalPassFailure();
//     }
//   }
// };
//----------------------------------------------------------------------------------

// // Helper function to create a MemRef type from a Tensor type.
// static MemRefType convertTensorToMemRef(TensorType tensorType) {
//   return MemRefType::get(tensorType.getShape(), tensorType.getElementType());
// }

// // Pattern to replace `linalg.fill` on tensors with `linalg.fill` on memrefs.
// struct LinalgFillTensorToMemRefPattern : public OpRewritePattern<linalg::FillOp> {
//   using OpRewritePattern<linalg::FillOp>::OpRewritePattern;

//   LogicalResult matchAndRewrite(linalg::FillOp op, PatternRewriter &rewriter) const override {
//     auto tensorType = op.output().getType().cast<TensorType>();
//     auto memrefType = convertTensorToMemRef(tensorType);

//     auto memref = rewriter.create<memref::AllocOp>(op.getLoc(), memrefType);
//     rewriter.create<linalg::FillOp>(op.getLoc(), op.value(), memref);

//     rewriter.replaceOp(op, memref.getResult());
//     return success();
//   }
// };

// // Pattern to replace `tensor.extract_slice` with `memref.subview`.
// struct TensorExtractSliceToMemRefSubviewPattern : public OpRewritePattern<tensor::ExtractSliceOp> {
//   using OpRewritePattern<tensor::ExtractSliceOp>::OpRewritePattern;

//   LogicalResult matchAndRewrite(tensor::ExtractSliceOp op, PatternRewriter &rewriter) const override {
//     auto sourceTensorType = op.getSource().getType().cast<TensorType>();
//     auto sourceMemRefType = convertTensorToMemRef(sourceTensorType);

//     auto sourceMemRef = rewriter.create<memref::CastOp>(op.getLoc(), sourceMemRefType, op.getSource());

//     auto subview = rewriter.create<memref::SubViewOp>(op.getLoc(), sourceMemRef, op.getMixedOffsets(), op.getMixedSizes(), op.getMixedStrides());

//     rewriter.replaceOp(op, subview.getResult());
//     return success();
//   }
// };

// // Pattern to replace `bufferization.to_tensor` with a `memref.cast`.
// struct BufferizationToTensorToMemRefCastPattern : public OpRewritePattern<bufferization::ToTensorOp> {
//   using OpRewritePattern<bufferization::ToTensorOp>::OpRewritePattern;

//   LogicalResult matchAndRewrite(bufferization::ToTensorOp op, PatternRewriter &rewriter) const override {
//     auto memrefType = op.getMemref().getType().cast<MemRefType>();
//     auto tensorType = op.getType().cast<TensorType>();

//     if (memrefType.getShape() != tensorType.getShape() || memrefType.getElementType() != tensorType.getElementType()) {
//       return failure();
//     }

//     rewriter.replaceOpWithNewOp<memref::CastOp>(op, memrefType, op.getMemref());
//     return success();
//   }
// };

// // Pass to replace and lower bufferization and tensor uses.
// struct ReplaceBufferizationTensorPass : public PassWrapper<ReplaceBufferizationTensorPass, OperationPass<ModuleOp>> {
//   void runOnOperation() override {
//     MLIRContext *context = &getContext();
//     RewritePatternSet patterns(context);

//     // Add patterns.
//     patterns.add<LinalgFillTensorToMemRefPattern,
//                  TensorExtractSliceToMemRefSubviewPattern,
//                  BufferizationToTensorToMemRefCastPattern>(context);

//     if (failed(applyPatternsAndFoldGreedily(getOperation(), std::move(patterns)))) {
//       signalPassFailure();
//     }
//   }
// };

//----------------------------------------------------------------------------------

struct LinalgFillTensorToMemrefPattern : public OpRewritePattern<linalg::FillOp> {
  using OpRewritePattern<linalg::FillOp>::OpRewritePattern;

  LogicalResult matchAndRewrite(linalg::FillOp op, PatternRewriter &rewriter) const override {

    if (!op.output().getType().isa<TensorType>()) {
      return failure();
    }

    // Get the tensor type and extract its shape.
    auto tensorType = op.output().getType().cast<TensorType>();
    auto shape = tensorType.getShape();

    // Create a memref type with the same shape and element type as the tensor.
    auto memrefType = MemRefType::get(shape, tensorType.getElementType());

    // Allocate a memref with the same shape as the tensor.
    auto memref = rewriter.create<memref::AllocOp>(op.getLoc(), memrefType);

    // Replace linalg.fill on tensors with an equivalent operation on memrefs.
    rewriter.create<linalg::FillOp>(op.getLoc(), op.value(), memref.getResult());


    // Replace the uses of the tensor with the memref.
    rewriter.replaceOp(op, memref.getResult());

    return success();
  }
};



struct LinalgFillTensorToMemrefPass
    : public PassWrapper<LinalgFillTensorToMemrefPass, OperationPass<ModuleOp>> {
  void runOnOperation() override {
    MLIRContext *context = &getContext();
    RewritePatternSet patterns(context);
    
    patterns.add<LinalgFillTensorToMemrefPattern>(context);
    
    if (failed(applyPatternsAndFoldGreedily(getOperation(), std::move(patterns))))
      signalPassFailure();
    getOperation()->dump();
  }
};

//----------------------------------------------------------------------------------

struct LoopUnrollPattern : public OpRewritePattern<scf::ForOp> {
  using OpRewritePattern<scf::ForOp>::OpRewritePattern;

  LogicalResult matchAndRewrite(scf::ForOp forOp,
                                PatternRewriter &rewriter) const override {
    auto lowerBound = forOp.getLowerBound();
    auto upperBound = forOp.getUpperBound();
    auto step = forOp.getStep();

    // Check if the loop bounds and step are constants.
    auto lowerBoundConst = lowerBound.getDefiningOp<arith::ConstantOp>();
    auto upperBoundConst = upperBound.getDefiningOp<arith::ConstantOp>();
    auto stepConst = step.getDefiningOp<arith::ConstantOp>();

    if (!lowerBoundConst || !upperBoundConst || !stepConst)
      return failure();

    // Get the constant values.
    int64_t lowerBoundValue =
        lowerBoundConst.getValue().cast<IntegerAttr>().getInt();
    int64_t upperBoundValue =
        upperBoundConst.getValue().cast<IntegerAttr>().getInt();
    int64_t stepValue = stepConst.getValue().cast<IntegerAttr>().getInt();

    // Calculate the number of iterations.
    int64_t numIterations =
        (upperBoundValue - lowerBoundValue + stepValue - 1) / stepValue;

    // Check if the number of iterations is less than or equal to MAX_LOOPS.

    if (numIterations > MAX_LOOPS) {
      std::cout << "error, num_loops: " << numIterations << std::endl;
      // return failure();
    }

    auto loc = forOp.getLoc();
    auto &block = forOp.getBody()->getOperations();
    SmallVector<Value, 4> unrolledResults;

    for (int64_t i = lowerBoundValue; i < upperBoundValue; i += stepValue) {
      IRMapping mapping;
      for (auto &regionArg : forOp.getRegionIterArgs())
        mapping.map(regionArg, regionArg);

      for (auto &op : block) {
        if (auto yieldOp = dyn_cast<scf::YieldOp>(op)) {
          SmallVector<Value, 4> yieldValues;
          for (auto value : yieldOp.getOperands())
            yieldValues.push_back(mapping.lookupOrDefault(value));
          unrolledResults.append(yieldValues);
        } else {
          rewriter.clone(op, mapping);
        }
      }
    }

    // Replace the loop operation with the unrolled operations.
    rewriter.replaceOp(forOp, unrolledResults);

    return success();
  }
};

struct LoopUnrollPass
    : public PassWrapper<LoopUnrollPass, OperationPass<ModuleOp>> {
  void runOnOperation() override {
    MLIRContext *context = &getContext();
    RewritePatternSet patterns(context);
    patterns.add<LoopUnrollPattern>(context);

    if (failed(applyPatternsAndFoldGreedily(getOperation(), std::move(patterns))))
      signalPassFailure();
  }
};

//----------------------------------------------------------------------------------

struct OuterProductVectorizationPass
    : public PassWrapper<OuterProductVectorizationPass,
                         OperationPass<func::FuncOp>> {
  void getDependentDialects(DialectRegistry &registry) const override {
    registry.insert<vector::VectorDialect, func::FuncDialect>();
  }

  void runOnOperation() override {
    func::FuncOp funcOp = getOperation();
    MLIRContext *context = funcOp.getContext();
    RewritePatternSet patterns(context);
    ConversionTarget target(*context);


      // Apply patterns for lowering masked transfers
    vector::populateVectorMaskLoweringPatternsForSideEffectingOps(patterns);

    // Apply patterns for transfer permutation
    vector::populateVectorReductionToContractPatterns(patterns);

    // Apply patterns for reduction to contract
    vector::populateVectorReductionToContractPatterns(patterns);

    vector::populateVectorMaskOpLoweringPatterns(patterns);
    vector::populateVectorTransferDropUnitDimsPatterns(patterns);
    vector::VectorTransformsOptions vectorTransformOptions;
    
    vectorTransformOptions.setVectorTransformsOptions(vector::VectorContractLowering::OuterProduct);
    vector::populateVectorContractLoweringPatterns(patterns, vectorTransformOptions);

    if (failed(applyPatternsAndFoldGreedily(funcOp, std::move(patterns)))) {
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
          SmallVector<mlir::Value, 4> sizes;
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
          Value tileK = b.create<arith::ConstantIndexOp>(loc, 1);
          sizes.push_back(tileK);

          return sizes;
        });
    std::cout << enableSME << std::endl;

    auto tiledOpResult = tileLinalgOp(rewriter, op, tilingOptions);
    if (failed(tiledOpResult)) {
      std::cout << "TILING FAILED" << std::endl;
      return failure();
    }

    // Specify vector sizes and scalable dimensions for each dimension
    SmallVector<int64_t, 4> inputVectorSizes = {enableSME ? 4 : 2, 4, 1};
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

class MatmulTileConversionPass
    : public PassWrapper<MatmulTileConversionPass,
                         OperationPass<func::FuncOp>> {
public:
  explicit MatmulTileConversionPass(bool enableSME) : enableSME(enableSME) {}

public:
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

  std::unique_ptr<Pass> createOuterProductVectorizationPass() {
    return std::make_unique<OuterProductVectorizationPass>();
  }
  std::unique_ptr<Pass> createMatmulTileConversionPass(bool enableSME) {
    return std::make_unique<MatmulTileConversionPass>(enableSME);
  }
  // std::unique_ptr<Pass> createPrefetchPass() {
  //   return std::make_unique<PrefetchPass>();
  // }
  std::unique_ptr<Pass> createLoopUnrollPass() {
    return std::make_unique<LoopUnrollPass>();
  }
  // std::unique_ptr<Pass> createFillPass() {
  //   return std::make_unique<ReplaceBufferizationTensorPass>();
  // }
} // namespace

int main(int argc, char **argv) {
  mlir::DialectRegistry registry;

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
        pm.addPass(createMatmulTileConversionPass(true));    
        pm.addPass(createOuterProductVectorizationPass());
        pm.addPass(mlir::tensor::createTensorBufferizePass());

          
        // pm.addPass(createLinalgBufferizePass());
        //pm.addPass(mlir::tensor::createTensorBufferizePass());
      });

  PassPipelineRegistration<> sveConversionPipeline(
      "sve-conversion",
      "Converts linalg.matmul to a more optimized form using SME",
      [](OpPassManager &pm) {
        pm.addPass(createMatmulTileConversionPass(false));
        
        pm.addPass(createOuterProductVectorizationPass());
        pm.addPass(createLinalgBufferizePass());
        // pm.addPass(createLoopUnrollPass());
      });

  return asMainReturnCode(
      MlirOptMain(argc, argv, "Optimizer Driver\n", registry));
}