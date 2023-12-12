#include "mlir/Dialect/Linalg/IR/Linalg.h"
#include "mlir/IR/Dialect.h"
#include "mlir/IR/MLIRContext.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/InitAllDialects.h"
#include "mlir/InitAllPasses.h"
#include "mlir/Pass/Pass.h"
#include "mlir/Pass/PassManager.h"
#include "mlir/Tools/mlir-opt/MlirOptMain.h"
#include "mlir/Transforms/GreedyPatternRewriteDriver.h"
#include "mlir/Transforms/Passes.h"
#include <iostream>
#include <llvm/Support/raw_ostream.h> // Include if using llvm::outs()
#include "mlir/Dialect/ArmSME/IR/ArmSME.h"
using namespace mlir;

namespace {
struct FakeMatmulConversion : public OpRewritePattern<linalg::MatmulOp> {
  using OpRewritePattern<linalg::MatmulOp>::OpRewritePattern;

  LogicalResult matchAndRewrite(linalg::MatmulOp op, PatternRewriter &rewriter) const override {
    // Extract operands and results from the Matmul operation
    Value lhs = op.getInputs()[0];
    Value rhs = op.getInputs()[1];
    Value result = op.getOutputs()[0];

    // Get the types of the operands and the result
    auto lhsType = lhs.getType().cast<RankedTensorType>();
    auto rhsType = rhs.getType().cast<RankedTensorType>();
    auto resultType = result.getType().cast<RankedTensorType>();

    // Extract dimensions of operands and result
    auto lhsDims = lhsType.getShape();
    auto rhsDims = rhsType.getShape();
    auto resultDims = resultType.getShape();

    // Define types for tiles
    auto tileType = VectorType::get({4, 4}, rewriter.getF32Type());

    // Constants for indexing
    auto c0 = rewriter.create<arith::ConstantIndexOp>(op.getLoc(), 0);
    auto c4 = rewriter.create<arith::ConstantIndexOp>(op.getLoc(), 4);

    // Zero initialization for tiles
    Value zeroTile = rewriter.create<arm_sme::ZeroOp>(op.getLoc(), tileType);

    // Assuming `i`, `k`, and `j` are loop variables as indices
    for (int i = 0; i < resultDims[0]; i += 4) {
        for (int j = 0; j < resultDims[1]; j += 4) {
            // Initialize accumulator for the current result tile
            Value accTile = zeroTile;

            for (int k = 0; k < lhsDims[1]; k += 4) {
                // Load tile slices from lhs and rhs matrices
                auto lhsIndex = rewriter.create<arith::ConstantIndexOp>(op.getLoc(), i);
                auto rhsIndex = rewriter.create<arith::ConstantIndexOp>(op.getLoc(), j);
                auto kIndex = rewriter.create<arith::ConstantIndexOp>(op.getLoc(), k);

                Value lhsTile = rewriter.create<arm_sme::LoadTileSliceOp>(
                    op.getLoc(), lhs, accTile, lhsIndex, kIndex);
                Value rhsTile = rewriter.create<arm_sme::LoadTileSliceOp>(
                    op.getLoc(), rhs, accTile, rhsIndex, kIndex);

                // Compute the outer product and accumulate
                accTile = rewriter.create<arm_sme::OuterProductOp>(op.getLoc(), lhsTile, rhsTile, accTile);
            }

            // Store the computed tile back to the result matrix
            auto storeIndex = rewriter.create<arith::ConstantIndexOp>(op.getLoc(), i);
            rewriter.create<arm_sme::StoreTileSliceOp>(op.getLoc(), accTile, result, storeIndex, c0);
        }
    }

    return success();
}

};

class FakeMatmulConversionPass
    : public PassWrapper<FakeMatmulConversionPass,
                         OperationPass<func::FuncOp>> {
public:
  void runOnOperation() override {
    auto func = getOperation();
    MLIRContext *context = func.getContext();

    RewritePatternSet patterns(context);
    patterns.add<FakeMatmulConversion>(context);

    (void)applyPatternsAndFoldGreedily(func, std::move(patterns));
  }
};
} // namespace

std::unique_ptr<Pass> createFakeMatmulConversionPass() {
  return std::make_unique<FakeMatmulConversionPass>();
}

int main(int argc, char **argv) {
  DialectRegistry registry;
  registerAllDialects(registry);
  registry.insert<mlir::arm_sme::ArmSMEDialect>(); // Adjust the namespace if needed

  registerAllPasses();

  // Register your custom pass
  PassPipelineRegistration<> pipeline(
      "fake-matmul-conversion", "Converts linalg.matmul to a fake operation",
      [](OpPassManager &pm) { pm.addPass(createFakeMatmulConversionPass()); });

  return mlir::asMainReturnCode(
      mlir::MlirOptMain(argc, argv, "Linalg-opt driver\n", registry));
}
