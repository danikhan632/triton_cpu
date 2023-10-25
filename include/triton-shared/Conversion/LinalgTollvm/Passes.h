//===----------------------------------------------------------------------===//
//
// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.
//
//===----------------------------------------------------------------------===//

#ifndef LINALG_TO_llvm_CONVERSION_PASSES_H
#define LINALG_TO_llvm_CONVERSION_PASSES_H

#include "triton-shared/Conversion/LinalgTollvm/LinalgTollvm.h"

namespace mlir {
namespace triton {

#define GEN_PASS_REGISTRATION
#include "triton-shared/Conversion/LinalgTollvm/Passes.h.inc"

} // namespace triton
} // namespace mlir

#endif
