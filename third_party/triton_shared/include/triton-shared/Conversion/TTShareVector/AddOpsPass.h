#ifndef ADD_OPS_PASS_H_
#define ADD_OPS_PASS_H_

#include "mlir/Dialect/Affine/IR/AffineOps.h"
#include "mlir/Dialect/Bufferization/IR/Bufferization.h"
#include "mlir/Dialect/ControlFlow/IR/ControlFlowOps.h"
#include "mlir/Dialect/Linalg/IR/Linalg.h"
#include "mlir/Dialect/Linalg/Passes.h"
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Transforms/GreedyPatternRewriteDriver.h"
#include "mlir/Pass/Pass.h"

namespace mlir {

class AddPatern : public RewritePattern {
public:
  explicit AddPatern(MLIRContext *context);
  LogicalResult matchAndRewrite(Operation *op, PatternRewriter &rewriter) const override;
};

class AddOpsPass : public PassWrapper<AddOpsPass, OperationPass<ModuleOp>> {
public:
  MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(AddOpsPass)

  void runOnOperation() override;
};

// Function to register the pass
extern "C" void registerAddOpsPass();

} // namespace mlir

#endif // ADD_OPS_PASS_H_
