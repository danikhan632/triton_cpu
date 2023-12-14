#include "/home/green/.triton/llvm/llvm-49af6502-ubuntu-x64/include/mlir/Dialect/ArmSVE/IR/ArmSVEDialect.h"
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
using namespace mlir;

namespace {
struct ArmMatmulConversion : public OpRewritePattern<linalg::MatmulOp> {
  using OpRewritePattern<linalg::MatmulOp>::OpRewritePattern;

  LogicalResult matchAndRewrite(linalg::MatmulOp op,
                                PatternRewriter &rewriter) const override {
    // Extract operands and results from the Matmul operation
    Value lhs = op.getDpsInputOperand(0)->get();
    Value rhs = op.getDpsInputOperand(1)->get();
    Value result = op.getDpsOutputOperand(0)->get();
    RankedTensorType lhsType = lhs.getType().cast<RankedTensorType>();
    RankedTensorType rhsType = rhs.getType().cast<RankedTensorType>();

    if (!lhsType || !rhsType) {
      return failure(); // Ensure input matrices are ranked tensors
    }

    // Get the dimensions of the input matrices
    int64_t lhsRows = lhsType.getShape()[0];
    int64_t lhsCols = lhsType.getShape()[1];
    int64_t rhsCols = rhsType.getShape()[1];

    // Define tile sizes and loop unrolling factor
    const int64_t tileSize = 256; // Example tile size

    // Create nested scf::ForOp loops for tiling and iteration
    auto loopI =
        rewriter.create<scf::ForOp>(op.getLoc(), rewriter.getI64IntegerAttr(0),
                                    rewriter.getI64IntegerAttr(lhsRows),
                                    rewriter.getI64IntegerAttr(tileSize));

    auto loopIBodyBuilder = [&](OpBuilder &nestedBuilder, Location loc,
                                Value ivI, ValueRange loopICarry) {
      auto loopJ = nestedBuilder.create<scf::ForOp>(
          loc, nestedBuilder.getI64IntegerAttr(0),
          nestedBuilder.getI64IntegerAttr(rhsCols),
          rewriter.getI64IntegerAttr(tileSize));

      auto loopJBodyBuilder = [&](OpBuilder &nestedBuilder, Location loc,
                                  Value ivJ, ValueRange loopJCarry) {
        // Initialize 'acc' for each iteration of the 'j' loop
        Value acc = nestedBuilder.create<mlir::ConstantOp>(
            loc, FloatType::getF32(nestedBuilder.getContext()),
            nestedBuilder.getFloatAttr(0.0));

        auto loopK = nestedBuilder.create<scf::ForOp>(
            loc, nestedBuilder.getI64IntegerAttr(0),
            nestedBuilder.getI64IntegerAttr(lhsCols),
            rewriter.getI64IntegerAttr(tileSize));

        auto loopKBodyBuilder = [&](OpBuilder &nestedBuilder, Location loc,
                                    Value ivK, ValueRange loopKCarry) {
          // Perform matrix multiplication using Arm SVE operations
          Value lhsVal =
              nestedBuilder.create<LoadOp>(loc, lhs, ValueRange{ivI, ivK});
          Value rhsVal =
              nestedBuilder.create<LoadOp>(loc, rhs, ValueRange{ivK, ivJ});

          // Floating-point multiplication
          Value mulVal = nestedBuilder.create<arm_sve::ScalableMaskedMulFOp>(
              loc, lhsVal, rhsVal);

          // Accumulate the result
          acc = nestedBuilder.create<arm_sve::ScalableMaskedAddFOp>(loc, acc,
                                                                    mulVal);

          nestedBuilder.create<scf::YieldOp>(loc, acc);
        };

        nestedBuilder.create<scf::YieldOp>(loc); // Yield for loopK
        loopK.getRegion().front().addArguments(nestedBuilder.getF32Type(),
                                               loc); // Add loopK arguments
        loopK.getRegion().front().walk(loopKBodyBuilder);
      };

      nestedBuilder.create<scf::YieldOp>(loc); // Yield for loopJ
      loopJ.getRegion().front().addArguments(nestedBuilder.getF32Type(),
                                             loc); // Add loopJ arguments
      loopJ.getRegion().front().walk(loopJBodyBuilder);
    };

    rewriter.create<scf::YieldOp>(op.getLoc()); // Yield for loopI
    loopI.getRegion().front().addArguments(rewriter.getF32Type(),
                                           op.getLoc()); // Add loopI arguments
    loopI.getRegion().front().walk(loopIBodyBuilder);

    // Rest of the implementation...

    return success();
  }
};

class ArmMatmulConversionPass
    : public PassWrapper<ArmMatmulConversionPass, OperationPass<func::FuncOp>> {
public:
  void runOnOperation() override {
    auto func = getOperation();
    MLIRContext *context = func.getContext();

    RewritePatternSet patterns(context);
    patterns.add<ArmMatmulConversion>(context);

    (void)applyPatternsAndFoldGreedily(func, std::move(patterns));
  }
};
} // namespace

std::unique_ptr<Pass> createArmMatmulConversionPass() {
  return std::make_unique<ArmMatmulConversionPass>();
}

int main(int argc, char **argv) {
  DialectRegistry registry;
  registerAllDialects(registry);
  registry
      .insert<mlir::arm_sme::ArmSMEDialect>(); // Adjust the namespace if needed

  registerAllPasses();

  // Register your custom pass
  PassPipelineRegistration<> pipeline(
      "ame-sme-matmul-conversion",
      "Converts linalg.matmul to ame-sme-matmul operation",
      [](OpPassManager &pm) { pm.addPass(createArmMatmulConversionPass()); });

  return mlir::asMainReturnCode(
      mlir::MlirOptMain(argc, argv, "Linalg-opt driver\n", registry));
}
