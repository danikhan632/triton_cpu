get_property(dialect_libs GLOBAL PROPERTY MLIR_DIALECT_LIBS)
get_property(conversion_libs GLOBAL PROPERTY MLIR_CONVERSION_LIBS)
# Add LLVM and MLIR include directories
include_directories(${LLVM_INCLUDE_DIRS})
include_directories(${MLIR_INCLUDE_DIRS})

add_llvm_executable(triton-arm-opt triton-arm-opt.cpp PARTIAL_SOURCES_INTENDED)

# TODO: what's this?
llvm_update_compile_flags(triton-arm-opt)
target_link_libraries(triton-arm-opt PRIVATE

  ${dialect_libs}
  ${conversion_libs}
  # tests

  # MLIR core
  MLIROptLib
  MLIRPass
  MLIRTransforms
)


target_include_directories(triton-arm-opt PUBLIC
  ${MLIR_INCLUDE_PATHS}
  ${LLVM_INCLUDE_PATHS}
  # Other necessary include paths
)

