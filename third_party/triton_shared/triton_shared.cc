
#include <pybind11/pybind11.h>
#include <string>

#include "mlir/Dialect/Bufferization/IR/Bufferization.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Index/IR/IndexDialect.h"
#include "mlir/Dialect/Linalg/IR/Linalg.h"
#include "mlir/Dialect/Linalg/Passes.h"
#include "mlir/Dialect/MemRef/IR/MemRef.h"
#include "mlir/Dialect/Tensor/IR/Tensor.h"
#include "mlir/Parser/Parser.h"
#include "mlir/Support/FileUtilities.h"
#include "triton/Dialect/Triton/IR/Dialect.h"
#include "triton/Dialect/TritonGPU/IR/Dialect.h"

#include "triton/Dialect/Triton/IR/Dialect.h"
#include "triton/Dialect/TritonGPU/IR/Dialect.h"

#include "triton/Dialect/Triton/Transforms/Passes.h"
#include "triton/Dialect/TritonGPU/Transforms/Passes.h"

#include "triton/Conversion/TritonToTritonGPU/Passes.h"

#include "triton-shared/Conversion/TritonToLinalg/Passes.h"

#include "mlir/InitAllPasses.h"
#include <Python.h>
#include <cctype>
#include <fstream>
#include <optional>
#include <pybind11/buffer_info.h>
#include <pybind11/functional.h>
#include <pybind11/pybind11.h>
#include <pybind11/stl.h>
#include <pybind11/stl_bind.h>
#include <regex>
#include <signal.h>
#include <sstream>
#include <stdexcept>
#include <string>

#include "llvm/Support/raw_ostream.h" // Include raw_ostream header

namespace py = pybind11;

// Function to add two integers
int add(int a, int b) { return a + b; }

// Function to translate triton GPU to SPIR-V (placeholder)
std::string translate_triton_gpu_to_spirv(const std::string &ttgir,
                                          int computeCapability) {
  // Placeholder implementation
  return "foo";
}

inline void registerTritonSharedDialects(mlir::DialectRegistry &registry) {
//   mlir::registerAllPasses();
//   mlir::registerTritonPasses();
//   mlir::registerTritonGPUPasses();
//   mlir::registerLinalgPasses();
//   mlir::triton::registerTritonToLinalgPass();

//   mlir::triton::registerConvertTritonToTritonGPUPass();

  registry.insert<mlir::triton::TritonDialect, mlir::cf::ControlFlowDialect,
                  mlir::triton::gpu::TritonGPUDialect, mlir::math::MathDialect,
                  mlir::arith::ArithDialect, mlir::scf::SCFDialect,
                  mlir::gpu::GPUDialect, mlir::linalg::LinalgDialect,
                  mlir::func::FuncDialect, mlir::tensor::TensorDialect,
                  mlir::memref::MemRefDialect,
                  mlir::bufferization::BufferizationDialect>();
}

// The CPU backend with triton_shared doesn't do compilation from within python
// but rather externally through triton-shared-opt, so we leave this function
// blank.
void init_triton_triton_shared(py::module &&m) {
  // Expose the add function to Python
  m.def("add", &add, "A function that adds two integers");

  // Expose the translate_triton_gpu_to_spirv function to Python
  m.def("translate_triton_gpu_to_spirv",
        [](const std::string &ttgir, int computeCapability) {
          py::print("Starting translation from TritonGPU to SPIRV...");

          mlir::MLIRContext context;
          mlir::DialectRegistry registry;
          registerTritonSharedDialects(registry);
          context.appendDialectRegistry(registry);
          context.loadAllAvailableDialects();

          llvm::raw_ostream &out = llvm::outs();
          out.changeColor(llvm::raw_ostream::BLUE, true);

          // Print the loaded dialects
          for (const auto &dialect : context.getLoadedDialects()) {
            out << "Loaded Dialect: " << dialect->getNamespace() << "\n";
          }
          
          out.resetColor();
          out << "\033[0m\n";

          // Parse module
          py::print("Parsing MLIR module...");
          mlir::OwningOpRef<mlir::ModuleOp> module =
              mlir::parseSourceString<mlir::ModuleOp>(ttgir, &context);
          if (!module)
            throw std::runtime_error("Parse MLIR file failed.");

          // Traverse and print operations inside the module
          module->walk([&](mlir::Operation *op) {
            std::string opName =
                op->getName().getStringRef().str(); // Convert to string
            py::print("Operation: ", opName);
          });
        });
}

PYBIND11_MODULE(triton_shared, m) { init_triton_triton_shared(std::move(m)); }
