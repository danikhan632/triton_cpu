#ifndef LINALG_TO_VECTOR_CONVERSION_PASSES
#define LINALG_TO_VECTOR_CONVERSION_PASSES

include "mlir/Pass/PassBase.td"

include "mlir/Pass/PassBase.td"

def LinalgToVector : Pass<"linalg-to-vector", "mlir::ModuleOp"> {
  let summary = "Convert Triton to Linalg dialect";
  let constructor = "createLinalgToVectorPass()";
}

#endif

