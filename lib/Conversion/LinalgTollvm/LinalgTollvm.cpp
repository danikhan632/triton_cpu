//===----------------------------------------------------------------------===//
//
// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.
//
//===----------------------------------------------------------------------===//

#include "triton-shared/Conversion/LinalgTollvm/LinalgTollvm.h"
#include "triton-shared/Analysis/MaskAnalysis.h"
#include "triton-shared/Analysis/OpFoldResultUtils.h"
#include "triton-shared/Analysis/PtrAnalysis.h"
 #include "mlir/Conversion/MemRefToLLVM/MemRefToLLVM.h"
  
 #include "mlir/Analysis/DataLayoutAnalysis.h"
 #include "mlir/Conversion/ConvertToLLVM/ToLLVMInterface.h"
 #include "mlir/Conversion/LLVMCommon/ConversionTarget.h"
 #include "mlir/Conversion/LLVMCommon/Pattern.h"
 #include "mlir/Conversion/LLVMCommon/TypeConverter.h"
 #include "mlir/Conversion/MemRefToLLVM/AllocLikeConversion.h"
 #include "mlir/Dialect/Arith/IR/Arith.h"
 #include "mlir/Dialect/Func/IR/FuncOps.h"
 #include "mlir/Dialect/LLVMIR/FunctionCallUtils.h"
 #include "mlir/Dialect/LLVMIR/LLVMDialect.h"
 #include "mlir/Dialect/LLVMIR/LLVMTypes.h"
 #include "mlir/Dialect/MemRef/IR/MemRef.h"
 #include "mlir/Dialect/MemRef/Utils/MemRefUtils.h"
 #include "mlir/IR/AffineMap.h"
 #include "mlir/IR/IRMapping.h"
 #include "mlir/Pass/Pass.h"
 #include "mlir/Support/MathExtras.h"
 #include "llvm/ADT/SmallBitVector.h"
#include "triton/Dialect/Triton/IR/Dialect.h"

#include "mlir/Dialect/Affine/IR/AffineOps.h"
#include "mlir/Dialect/Bufferization/IR/Bufferization.h"
#include "mlir/Dialect/ControlFlow/IR/ControlFlowOps.h"
#include "mlir/Dialect/Linalg/IR/Linalg.h"
#include "mlir/Dialect/Linalg/Passes.h"

#include "llvm/ADT/SmallVectorExtras.h"
#include "llvm/ADT/TypeSwitch.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/FormatVariadic.h"
#include "llvm/Support/MathExtras.h"

#include <numeric>
#include <type_traits>

#define DEBUG_TYPE "linalg-to-llvm"

using namespace mlir;
using namespace triton;

#define GEN_PASS_CLASSES
#include "triton-shared/Conversion/LinalgTollvm/Passes.h.inc"

//===----------------------------------------------------------------------===//
// Utilities
//===----------------------------------------------------------------------===//



namespace {

}


void mlir::populateLinalgToLLVMConversionPatterns(
    TypeConverter &typeConverter, RewritePatternSet &patterns) {
  
  // Convert Linalg function ops to LLVM function ops
  populateFunctionOpInterfaceTypeConversionPattern<linalg::GenericOp>(
      patterns, typeConverter);

  // Populate patterns to convert Linalg element-wise ops to LLVM operations
  // (This is a placeholder; actual conversion utility functions might differ)
  llvm::populateLinalgToLLVMElementwiseConversionPatterns(patterns);


}
