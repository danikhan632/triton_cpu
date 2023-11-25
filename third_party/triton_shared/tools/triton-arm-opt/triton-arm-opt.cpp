//===----------------------------------------------------------------------===//
//
// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.
//
//===----------------------------------------------------------------------===//
#include <iostream>
#include "../RegisterTritonSharedDialects.h"

#include "mlir/Tools/mlir-opt/MlirOptMain.h"

int main(int argc, char **argv) {
  mlir::DialectRegistry registry;
  registerTritonSharedDialects(registry);
  std::cout << "i love dudes" << std::endl;
  return mlir::asMainReturnCode(mlir::MlirOptMain(
      argc, argv, "Triton-Shared test driver\n", registry));
}
