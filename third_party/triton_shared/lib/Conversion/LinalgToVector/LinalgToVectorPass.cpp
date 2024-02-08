//===----------------------------------------------------------------------===//
//
// Copyright (c) Microsoft Corporation, Meta Platforms.
// Licensed under the MIT license.
//
//===----------------------------------------------------------------------===//

#include "triton-shared/Conversion/LinalgToVector/LinalgToVector.h"
#include "triton-shared/Dialect/TritonStructured/IR/TritonStructuredDialect.h"
#include "triton-shared/Dialect/TritonTilingExt/IR/TritonTilingExtDialect.h"
#include "triton/Dialect/Triton/IR/Dialect.h"

#include "mlir/Dialect/Affine/IR/AffineOps.h"
#include "mlir/Dialect/Bufferization/IR/Bufferization.h"
#include "mlir/Dialect/Linalg/IR/Linalg.h"
#include "mlir/Pass/PassManager.h"
#include "mlir/Transforms/GreedyPatternRewriteDriver.h"
#include "mlir/Transforms/Passes.h"
#include "triton/Dialect/Triton/IR/Types.h"

#include "llvm/Support/Debug.h"

#define DEBUG_TYPE "linalg-to-vector"

using namespace mlir;


#define GEN_PASS_CLASSES
#include "triton-shared/Conversion/LinalgToVector/Passes.h.inc"

namespace {

class LinalgToVectorPass
    : public LinalgToVectorBase<LinalgToVectorPass> {

public:
  void getDependentDialects(DialectRegistry &registry) const override {
    registry
        .insert<arith::ArithDialect, math::MathDialect, affine::AffineDialect,
                scf::SCFDialect, tensor::TensorDialect, triton::TritonDialect,
                tts::TritonStructuredDialect>();
  }

  void runOnOperation() override {
    auto moduleOp = getOperation();


  }
};
} // namespace
namespace mlir{
std::unique_ptr<OperationPass<ModuleOp>>
createLinalgToVectorPass() {
  return std::make_unique<LinalgToVectorPass>();
}
}
