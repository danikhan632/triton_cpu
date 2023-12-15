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
using namespace mlir::linalg;
using namespace mlir::memref;
using namespace mlir::arith;

namespace {
struct ArmMatmulConversion : public OpRewritePattern<linalg::MatmulOp> {
  using OpRewritePattern<linalg::MatmulOp>::OpRewritePattern;



LogicalResult matchAndRewrite(linalg::MatmulOp op,
                              PatternRewriter &rewriter) const override {

    auto loc = op.getLoc();

    // Extracting the operands and result
    Value matrixA = op.getOperand(0);
    Value matrixB = op.getOperand(1);
    auto outputs = op.getOutputs();

    // Assuming there's only one output operand
    assert(outputs.size() == 1 && "MatmulOp should have a single output");
    Value matrixC = outputs[0];

    // Ensure operands are tensors
    if (!matrixA.getType().isa<mlir::TensorType>() ||
        !matrixB.getType().isa<mlir::TensorType>() ||
        !matrixC.getType().isa<mlir::TensorType>()) {
      llvm::errs() << "Error: One or more matrices are not of TensorType.\n";
      return failure();
    }

    // Cast the types to TensorType
    auto matrixAType = matrixA.getType().cast<mlir::TensorType>();
    auto matrixBType = matrixB.getType().cast<mlir::TensorType>();
    auto matrixCType = matrixC.getType().cast<mlir::TensorType>();

    // Prepare a new result tensor, initially empty
    auto resultType = matrixCType;
    Value newResult = rewriter.create<tensor::EmptyOp>(loc, resultType.getShape(), resultType.getElementType());

    // Loop over the rows of A and columns of B
    for (int64_t i = 0; i < matrixAType.getShape()[0]; ++i) {
        for (int64_t j = 0; j < matrixBType.getShape()[1]; ++j) {
            Value iIndex = rewriter.create<arith::ConstantIndexOp>(loc, i);
            Value jIndex = rewriter.create<arith::ConstantIndexOp>(loc, j);

            Value sum = rewriter.create<arith::ConstantFloatOp>(loc, APFloat(0.0f), rewriter.getF32Type());

            for (int64_t k = 0; k < matrixAType.getShape()[1]; ++k) {
                Value kIndex = rewriter.create<arith::ConstantIndexOp>(loc, k);

                Value aElem = rewriter.create<tensor::ExtractOp>(loc, matrixA, ValueRange{iIndex, kIndex});
                Value bElem = rewriter.create<tensor::ExtractOp>(loc, matrixB, ValueRange{kIndex, jIndex});

                auto prod = rewriter.create<arith::MulFOp>(loc, aElem, bElem);
                sum = rewriter.create<arith::AddFOp>(loc, sum, prod);
            }

            newResult = rewriter.create<tensor::InsertOp>(loc, sum, newResult, ValueRange{iIndex, jIndex});
        }
    }

    // Replace all uses of the original matmul operation with the new result
    rewriter.replaceOp(op, newResult);

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
      .insert<mlir::arm_sve::ArmSVEDialect>(); // Adjust the namespace if needed

  registerAllPasses();

  // Register your custom pass
  PassPipelineRegistration<> pipeline(
      "am",
      "Converts linalg.matmul to ame-sme-matmul operation",
      [](OpPassManager &pm) { pm.addPass(createArmMatmulConversionPass()); });

  return mlir::asMainReturnCode(
      mlir::MlirOptMain(argc, argv, "Linalg-opt driver\n", registry));
}
