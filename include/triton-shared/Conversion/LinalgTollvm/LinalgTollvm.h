//===----------------------------------------------------------------------===//
//
// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.
//
//===----------------------------------------------------------------------===//

#ifndef TRITON_CONVERSION_LINALG_TO_llvm__LINALG_TO_llvm_H
#define TRITON_CONVERSION_LINALG_TO_llvm_LINALG_TO_llvm_H

#include "mlir/Dialect/Bufferization/IR/Bufferization.h"
#include "mlir/Dialect/Linalg/IR/Linalg.h"

#include "mlir/Pass/Pass.h"
#include "mlir/Transforms/DialectConversion.h"

#include "triton/Dialect/Triton/IR/Dialect.h"

namespace mlir {
namespace triton {

std::unique_ptr<OperationPass<ModuleOp>> createLinalgTollvmPass();

void populateLinalgTollvmCanonicalizationPatterns(
    RewritePatternSet &patterns);

void populateLinalgTollvmConversionPatterns(TypeConverter &typeConverter,
                                              RewritePatternSet &patterns,
                                              unsigned int launchGridRank);

} // namespace triton
} // namespace mlir

#endif // TRITON_CONVERSION_LINALG_TO_llvm_LINALG_TO_llvm_H
