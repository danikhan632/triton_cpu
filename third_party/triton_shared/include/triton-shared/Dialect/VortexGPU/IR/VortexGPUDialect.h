#ifndef MLIR_DIALECT_TRITON_STRUCTURED_IR_TRITON_STRUCTURED_DIALECT_H_
#define MLIR_DIALECT_TRITON_STRUCTURED_IR_TRITON_STRUCTURED_DIALECT_H_

#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/BuiltinTypes.h"
#include "mlir/IR/Dialect.h"
#include "mlir/IR/MLIRContext.h"
#include "mlir/IR/OpDefinition.h"
#include "mlir/IR/SymbolTable.h"
#include "mlir/IR/TypeSupport.h"
#include "mlir/IR/Types.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"
#include "triton/Dialect/Triton/IR/Dialect.h"

#include "mlir/IR/Dialect.h"

//===----------------------------------------------------------------------===//
// VortexGPU Operations
//===----------------------------------------------------------------------===//
#include "triton-shared/Dialect/VortexGPU/IR/VortexGPUDialect.h.inc"

// Include the auto-generated header file containing the declarations of the
// VortexGPU operations.
#define GET_OP_CLASSES
#include "triton-shared/Dialect/VortexGPU/IR/VortexGPUOps.h.inc"

#endif
