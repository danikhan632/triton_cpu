set(TRITON_SHARED_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}")
set(TRITON_SHARED_BINARY_DIR "${CMAKE_CURRENT_BINARY_DIR}")
set(CMAKE_BUILD_TYPE Debug)

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/include)
include_directories(${CMAKE_CURRENT_BINARY_DIR}/include) # Tablegen'd files
add_subdirectory(include)
add_subdirectory(lib)
add_subdirectory(test)
add_subdirectory(tools)
add_triton_plugin(TritonShared 
  ${CMAKE_CURRENT_SOURCE_DIR}/triton_shared.cc
  ${PYTHON_SRC}
  LINK_LIBS 
  TritonSharedAnalysis
  TritonToLinalg
  TritonTilingExtIR
  ${dialect_libs}
  ${conversion_libs}
  MLIRAnalysis
  MLIRDialect
  MLIRIR
  MLIRParser
  MLIRPass
  MLIRTransforms
  MLIRSupport
  TritonAnalysis
  TritonTransforms
  TritonGPUTransforms
)

set(PYTHON_SRC ${PYTHON_SRC_PATH}/main.cc ${PYTHON_SRC_PATH}/triton_shared.cc)
include_directories("." ${PYTHON_SRC_PATH})
