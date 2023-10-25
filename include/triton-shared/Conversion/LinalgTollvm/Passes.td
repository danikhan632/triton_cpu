//===----------------------------------------------------------------------===//
//
// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.
//
//===----------------------------------------------------------------------===//

#ifndef LINALG_TO_llvm_CONVERSION_PASSES
#define LINALG_TO_llvm_CONVERSION_PASSES

include "mlir/Pass/PassBase.td"

def LinalgTollvm : Pass<"linalg-to-llvm", "mlir::ModuleOp"> {
  let summary = "Convert Triton to Linalg dialect";
  let constructor = "triton::createLinalgTollvmPass()";
}

#endif
