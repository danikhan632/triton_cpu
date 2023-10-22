//===----------------------------------------------------------------------===//
//
// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.
//
//===----------------------------------------------------------------------===//

#ifndef TRITON_CONVERSION_LINALG_TO_X86__LINALG_TO_X86_H
#define TRITON_CONVERSION_LINALG_TO_X86_LINALG_TO_X86_H

#include "mlir/Dialect/Bufferization/IR/Bufferization.h"
#include "mlir/Dialect/Linalg/IR/Linalg.h"
#include "mlir/Pass/Pass.h"
#include "mlir/Transforms/DialectConversion.h"

#include "triton/Dialect/Triton/IR/Dialect.h"

namespace mlir {
namespace triton {

std::unique_ptr<OperationPass<ModuleOp>> createLinalgToX86Pass();

void populateLinalgToX86CanonicalizationPatterns(
    RewritePatternSet &patterns);

void populateLinalgToX86ConversionPatterns(TypeConverter &typeConverter,
                                              RewritePatternSet &patterns,
                                              unsigned int launchGridRank);

} // namespace triton
} // namespace mlir

#endif // TRITON_CONVERSION_LINALG_TO_X86_LINALG_TO_X86_H
