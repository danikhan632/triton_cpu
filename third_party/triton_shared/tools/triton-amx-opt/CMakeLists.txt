get_property(dialect_libs GLOBAL PROPERTY MLIR_DIALECT_LIBS)
get_property(conversion_libs GLOBAL PROPERTY MLIR_CONVERSION_LIBS)

message(STATUS "MLIR Dialect Libraries: ${dialect_libs}")
message(STATUS "MLIR Conversion Libraries: ${conversion_libs}")
# Add LLVM and MLIR include directories
include_directories(${LLVM_INCLUDE_DIRS})
include_directories(${MLIR_INCLUDE_DIRS})

add_llvm_executable(triton-amx-opt triton-amx-opt.cpp PARTIAL_SOURCES_INTENDED)

# TODO: what's this?
llvm_update_compile_flags(triton-amx-opt)
target_link_libraries(triton-amx-opt PRIVATE

  ${dialect_libs}
  ${conversion_libs}
  # tests

  # MLIR core
  MLIROptLib
  MLIRPass
  MLIRTransforms
)


target_include_directories(triton-amx-opt PUBLIC
  ${MLIR_INCLUDE_PATHS}
  ${LLVM_INCLUDE_PATHS}
  # Other necessary include paths
)

