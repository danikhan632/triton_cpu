#include "mlir/InitAllDialects.h"
#include "mlir/InitAllPasses.h"
#include "mlir/IR/Dialect.h"
#include "mlir/IR/MLIRContext.h"
#include "mlir/Pass/PassManager.h"
#include "mlir/Tools/mlir-opt/MlirOptMain.h"
#include "mlir/Dialect/Linalg/IR/Linalg.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Pass/Pass.h"
#include "mlir/Transforms/GreedyPatternRewriteDriver.h"
#include "mlir/Transforms/Passes.h"
#include <iostream>



using namespace mlir;

namespace {
    struct FakeMatmulConversion : public OpRewritePattern<linalg::MatmulOp> {
        using OpRewritePattern<linalg::MatmulOp>::OpRewritePattern;

        LogicalResult matchAndRewrite(linalg::MatmulOp op, PatternRewriter &rewriter) const override {
            // Fake conversion: Simply succeed without doing anything.
            std::cout<< ("benchod") <<std::endl;
            return success();
        }
    };

    class FakeMatmulConversionPass : public PassWrapper<FakeMatmulConversionPass, OperationPass<func::FuncOp>> {
    public:
        void runOnOperation() override {
            auto func = getOperation();
            MLIRContext *context = func.getContext();

            RewritePatternSet patterns(context);
            patterns.add<FakeMatmulConversion>(context);

            (void)applyPatternsAndFoldGreedily(func, std::move(patterns));
        }
    };
}

std::unique_ptr<Pass> createFakeMatmulConversionPass() {
    return std::make_unique<FakeMatmulConversionPass>();
}

int main(int argc, char **argv) {
    DialectRegistry registry;
    registerAllDialects(registry);
    registry.insert<mlir::func::FuncDialect>();
    registerAllPasses();

    // Register your custom pass
    PassPipelineRegistration<> pipeline(
        "fake-matmul-conversion",
        "Converts linalg.matmul to a fake operation",
        [](OpPassManager &pm) {
            pm.addPass(createFakeMatmulConversionPass());
        }
    );

    return mlir::asMainReturnCode(mlir::MlirOptMain(argc, argv, "Linalg-opt driver\n", registry));
}
