#ifndef LINALG_TO_VECTOR_CONVERSION_PASSES_H
#define LINALG_TO_VECTOR_CONVERSION_PASSES_H

#include "triton-shared/Conversion/LinalgToVector/LinalgToVector.h"

namespace mlir {

#define GEN_PASS_REGISTRATION
#include "triton-shared/Conversion/LinalgToVector/Passes.h.inc"

std::unique_ptr<OperationPass<ModuleOp>> createLinalgToVectorPass();
} // namespace mlir

#endif
