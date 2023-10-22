//===----------------------------------------------------------------------===//
//
// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.
//
//===----------------------------------------------------------------------===//

#ifndef LINALG_TO_X86_CONVERSION_PASSES
#define LINALG_TO_X86_CONVERSION_PASSES

include "mlir/Pass/PassBase.td"

def LinalgToX86 : Pass<"linalg-to-x86", "mlir::ModuleOp"> {
  let summary = "Convert Triton to Linalg dialect";
  let constructor = "triton::createLinalgToX86Pass()";
}

#endif
