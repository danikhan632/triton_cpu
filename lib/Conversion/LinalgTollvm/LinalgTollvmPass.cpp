//===----------------------------------------------------------------------===//
//
// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.
//
//===----------------------------------------------------------------------===//

#include "triton-shared/Analysis/UseAnalysis.h"
#define GEN_PASS_CLASSES
#include "triton-shared/Conversion/LinalgTollvm/Passes.h.inc"
using namespace mlir;


namespace {

class LinalgToLLVMTypeConverter : public TypeConverter {
public:
  LinalgToLLVMTypeConverter() {
    // For example, convert memref types to LLVM pointers
    addConversion([](MemRefType type) -> Type {
      auto elementType = type.getElementType();
      return LLVM::LLVMPointerType::get(elementType);
    });
    // ... Add other type conversions as needed ...
  }
};

struct LinalgToLLVMPass : public PassWrapper<LinalgToLLVMPass, OperationPass<ModuleOp>> {
  void runOnOperation() override {
    LLVM::ensureLLVMDialect(getOperation().getContext());

    RewritePatternSet patterns(&getContext());
    LinalgToLLVMTypeConverter typeConverter;

    ConversionTarget target(getContext());
    target.addLegalDialect<LLVM::LLVMDialect>();
    target.addIllegalDialect<linalg::LinalgDialect>();

    // Add existing Linalg to LLVM conversion patterns
    // linalg::populateLinalgToLLVMConversionPatterns(typeConverter, patterns);

    // ... If needed, add custom conversion patterns for operations not handled by the above ...

    if (failed(applyFullConversion(getOperation(), target, std::move(patterns)))) {
      signalPassFailure();
    }
  }
};

} // namespace

std::unique_ptr<mlir::OperationPass<ModuleOp>> createLinalgToLLVMPass() {
  return std::make_unique<LinalgToLLVMPass>();
}

std::unique_ptr<mlir::OperationPass<ModuleOp>> triton::createLinalgTollvmPass() {
  return std::make_unique<LinalgTollvmPass>();
}
