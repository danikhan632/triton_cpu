#include "triton-shared/Dialect/VortexGPU/IR/VortexGPUDialect.h"

using namespace mlir;
using namespace mlir::tts;

/// Dialect creation, the instance will be owned by the context. This is the
/// point of registration of custom types and operations for the dialect.
void VortexGPUDialect::initialize() {
  addOperations<
#define GET_OP_LIST
#include "triton-shared/Dialect/VortexGPU/IR/VortexGPUOps.cpp.inc"
      >();
}

//===----------------------------------------------------------------------===//
// TableGen'd op method definitions
//===----------------------------------------------------------------------===//

#define GET_OP_CLASSES
#include "triton-shared/Dialect/VortexGPU/IR/VortexGPUOps.cpp.inc"

#include "triton-shared/Dialect/VortexGPU/IR/VortexGPUDialect.cpp.inc"
