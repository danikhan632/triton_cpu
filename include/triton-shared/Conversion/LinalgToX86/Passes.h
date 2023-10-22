//===----------------------------------------------------------------------===//
//
// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.
//
//===----------------------------------------------------------------------===//

#ifndef LINALG_TO_X86_CONVERSION_PASSES_H
#define LINALG_TO_X86_CONVERSION_PASSES_H

#include "triton-shared/Conversion/LinalgToX86/LinalgToX86.h"

namespace mlir {
namespace triton {

#define GEN_PASS_REGISTRATION
#include "triton-shared/Conversion/LinalgToX86/Passes.h.inc"

} // namespace triton
} // namespace mlir

#endif
