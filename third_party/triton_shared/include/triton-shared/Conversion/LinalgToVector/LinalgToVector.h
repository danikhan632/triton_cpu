#ifndef TRITON_CONVERSION_LINALGTOVECTOR_LINALGTOVECTOR_H
#define TRITON_CONVERSION_LINALGTOVECTOR_LINALGTOVECTOR_H

#include "mlir/Pass/Pass.h"
#include "mlir/Transforms/DialectConversion.h"
#include "mlir/Dialect/Transform/IR/TransformDialect.h"
#include "triton/Dialect/Triton/IR/Dialect.h"

namespace mlir {


#define GEN_PASS_DECL
#include "triton-shared/Conversion/LinalgToVector/Passes.h.inc"

std::unique_ptr<OperationPass<ModuleOp>> createLinalgToVectorPass();

void populateLinalgToVectorConversionPatterns(RewritePatternSet &patterns);


} // namespace mlir

#endif // TRITON_CONVERSION_LINALGTOVECTOR_LINALGTOVECTOR_H
