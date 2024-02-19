cmake_minimum_required(VERSION 3.13.4)
project(MyMLIRTool)

find_package(MLIR REQUIRED CONFIG)

set(LLVM_LINK_COMPONENTS
  Core
  Support
)

set(MLIR_LINK_COMPONENTS
  All
)

add_executable(my-mlir-tool main.cpp)

llvm_map_components_to_libnames(llvm_libs ${LLVM_LINK_COMPONENTS})
target_link_libraries(my-mlir-tool PRIVATE ${llvm_libs} MLIRIR MLIRParser MLIRSupport)
