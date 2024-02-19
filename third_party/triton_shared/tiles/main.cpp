#include "mlir/IR/Builders.h"
#include "mlir/IR/MLIRContext.h"
#include "mlir/Parser.h"
#include <memory>

int main(int argc, char **argv) {
  mlir::MLIRContext context;
  // Load your MLIR code, e.g., from a file
  // For the sake of example, let's assume argv[1] is your input file
  auto module = mlir::parseSourceFile(argv[1], &context);
  if (!module) {
    llvm::errs() << "Failed to parse MLIR file.\n";
    return 1;
  }

  // Your logic here: manipulate the module, run passes, etc.

  module->dump(); // Simple way to print the module to stdout

  return 0;
}
