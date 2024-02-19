get_property(dialect_libs GLOBAL PROPERTY MLIR_DIALECT_LIBS)
get_property(conversion_libs GLOBAL PROPERTY MLIR_CONVERSION_LIBS)

add_llvm_executable(triton-arm-opt triton-arm-opt.cpp PARTIAL_SOURCES_INTENDED)

# TODO: what's this?
llvm_update_compile_flags(triton-arm-opt)
target_link_libraries(triton-arm-opt PRIVATE

  ${dialect_libs}
  ${conversion_libs}
  # tests
  TritonTestAnalysis
  # MLIR core
  MLIROptLib
  MLIRPass
  MLIRTransforms
)

mlir_check_all_link_libraries(triton-arm-opt)
