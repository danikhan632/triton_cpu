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
    // auto loc = op.getLoc();
    // llvm::outs() << "Rnt:\n";
    // // Extracting the operands and result
    // Value matrixA = op.getOperand(0);
    // Value matrixB = op.getOperand(1);
    // auto outputs = op.getOutputs();

    // // Assuming there's only one output operand
    // assert(outputs.size() == 1 && "MatmulOp should have a single output");
    // Value matrixC = outputs[0];

    // // Ensure operands are tensors
    // if (!matrixA.getType().isa<mlir::TensorType>() ||
    //     !matrixB.getType().isa<mlir::TensorType>() ||
    //     !matrixC.getType().isa<mlir::TensorType>()) {
    //   llvm::errs() << "Error: One or more matrices are not of TensorType.\n";
    //   return failure();
    // }

    // // Cast the types to TensorType
    // auto matrixAType = matrixA.getType().cast<mlir::TensorType>();
    // auto matrixBType = matrixB.getType().cast<mlir::TensorType>();
    // auto matrixCType = matrixC.getType().cast<mlir::TensorType>();

    // // Prepare a new result tensor, initially empty
    // auto resultType = matrixCType;
    // Value newResult = rewriter.create<tensor::EmptyOp>(
    //     loc, resultType.getShape(), resultType.getElementType());

    // // Loop over the rows of A and columns of B
    // for (int64_t i = 0; i < matrixAType.getShape()[0]; ++i) {
    //   for (int64_t j = 0; j < matrixBType.getShape()[1]; ++j) {
    //     Value iIndex = rewriter.create<arith::ConstantIndexOp>(loc, i);
    //     Value jIndex = rewriter.create<arith::ConstantIndexOp>(loc, j);

    //     // Accumulator for the result at (i, j)
    //     Value sum = rewriter.create<arith::ConstantIntOp>(
    //         loc, 0, rewriter.getIntegerType(32)); // Initialize to 0

    //     // Loop over the inner dimension (k) for matrix multiplication
    //     for (int64_t k = 0; k < matrixAType.getShape()[1]; ++k) {
    //       Value kIndex = rewriter.create<arith::ConstantIndexOp>(loc, k);

    //       // Extract elements from matrices A and B
    //       Value aElem = rewriter.create<tensor::ExtractOp>(
    //           loc, matrixA, ValueRange{iIndex, kIndex});
    //       Value bElem = rewriter.create<tensor::ExtractOp>(
    //           loc, matrixB, ValueRange{kIndex, jIndex});

    //       // Perform unsigned integer matrix multiplication and accumulate
    //       the
    //       // result
    //       Value mulResult = rewriter.create<arm_sve::UmmlaOp>(
    //           loc, rewriter.getIntegerType(32), sum, aElem, bElem);
    //       sum = mulResult;
    //     }

    //     // Insert the accumulated result into the new result matrix
    //     newResult = rewriter.create<tensor::InsertOp>(
    //         loc, sum, newResult, ValueRange{iIndex, jIndex});
    //   }
    // }

    // // Replace all uses of the original matmul operation with the new result
    // rewriter.replaceOp(op, newResult);

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

    // Accessing and printing indexing maps
    auto indexingMaps = op.getIndexingMaps();
    llvm::outs() << "Indexing Maps:\n";
    for (auto map : indexingMaps) {
      map.print(llvm::outs());
      llvm::outs() << "\n";
    }

    // Accessing and printing iterator types
    auto iteratorTypes = op.getIteratorTypes();
    llvm::outs() << "Iterator Types:\n";
    for (auto type : iteratorTypes) {
      llvm::outs() << type << "\n";
    }

    // Accessing and printing region
    auto &region = op.getRegion();
    llvm::outs() << "Region:\n";
    for (auto &block : region) {
      block.print(llvm::outs());
      llvm::outs() << "\n";
    }

    return success();
  }
};
} // end anonymous namespace

using namespace mlir;
using namespace mlir::arm_sve;

namespace {

struct ConvertArithAddfToArmSVE : public OpRewritePattern<arith::AddFOp> {
  using OpRewritePattern<arith::AddFOp>::OpRewritePattern;

  LogicalResult matchAndRewrite(arith::AddFOp op,
                                PatternRewriter &rewriter) const override {
    // Debugging print
    llvm::outs() << "repl\n";

    // Directly get the operands without casting to VectorType
    Value lhs = op.getOperand(0);
    Value rhs = op.getOperand(1);

    // Define the SVE vector width you want to use, e.g., 16 for SVE 128-bit
    int vectorWidth = 16; // Adjust this to match your target SVE vector length

    // Create a vector type for the given width and bf16 element type
    auto vectorType = VectorType::get({vectorWidth}, rewriter.getBF16Type());

    // Broadcast the scalar operands to vector
    auto broadcastedLhs =rewriter.create<vector::BroadcastOp>(op.getLoc(), vectorType, lhs);
    auto broadcastedRhs =rewriter.create<vector::BroadcastOp>(op.getLoc(), vectorType, rhs);

    // Create a constant mask of true values for the vector operation
    auto maskTrue = rewriter.create<arith::ConstantOp>(
        op.getLoc(),
        DenseIntElementsAttr::get(
            VectorType::get({vectorWidth}, rewriter.getI1Type()), true));

    // Convert the mask to svbool type
    auto svboolType =
        VectorType::get({16}, rewriter.getI1Type()); // Adjust as needed
    auto maskSvbool = rewriter.create<arm_sve::ConvertToSvboolOp>(
        op.getLoc(), svboolType, maskTrue);

    // Replace the arith.addf operation with arm_sve.masked.addf
    auto armAddOp = rewriter.create<arm_sve::ScalableMaskedAddFOp>(
        op.getLoc(),
        vectorType,     // Result type (vector)
        maskSvbool,     // Mask (svbool type)
        broadcastedLhs, // Left-hand side operand (vector)
        broadcastedRhs  // Right-hand side operand (vector)
    );

    // Replace the original operation with the new SVE operation
    rewriter.replaceOp(op, {armAddOp.getResult()});

    return success();
  }
};
} // namespace

class ArmMatmulConversionPass
    : public PassWrapper<ArmMatmulConversionPass, OperationPass<func::FuncOp>> {
public:
  void runOnOperation() override {
    auto func = getOperation();
    MLIRContext *context = func.getContext();

    // Print all registered dialects
    llvm::outs() << "Registered dialects in the current MLIRContext:\n";
    for (auto *dialect : context->getLoadedDialects()) {
      llvm::outs() << dialect->getNamespace()
                   << "\n"; // Use getNamespace() to get the dialect namespace
    }

    RewritePatternSet patterns(context);
    patterns.add<ArmMatmulConversion>(context);
    patterns.add<GenericConversion>(context);
    patterns.add<ConvertArithAddfToArmSVE>(context);

    (void)applyPatternsAndFoldGreedily(func, std::move(patterns));
  }
};
} // namespace

std::unique_ptr<Pass> createArmMatmulConversionPass() {
  return std::make_unique<ArmMatmulConversionPass>();
}

int main(int argc, char **argv) {

  mlir::DialectRegistry registry;

  // Register all standard MLIR dialects
  mlir::registerAllDialects(registry);

  // Register the ArmSVE dialect

  // Register the ArmSVE dialect
  registry.insert<func::FuncDialect, arith::ArithDialect, math::MathDialect,
                  linalg::LinalgDialect, affine::AffineDialect, scf::SCFDialect,
                  tensor::TensorDialect, bufferization::BufferizationDialect, 
                  vector::VectorDialect, arm_sve::ArmSVEDialect, memref::MemRefDialect>();

  // Register all passes
  mlir::registerAllPasses();

  // Now we create the MLIR context and bind our dialect registry to it
  mlir::MLIRContext context;
  context.appendDialectRegistry(registry);


  // Register your custom pass
  PassPipelineRegistration<> pipeline(
      "am", "Converts linalg.matmul to ame-sme-matmul operation",
      [](OpPassManager &pm) { pm.addPass(createArmMatmulConversionPass()); });

  return mlir::asMainReturnCode(
      mlir::MlirOptMain(argc, argv, "Linalg-opt driver\n", registry));
}
