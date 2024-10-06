add_mlir_dialect_library(VortexGPUIR
  VortexGPUOps.cpp
  VortexGPUDialect.cpp

  DEPENDS
  VortexGPUTableGen

  LINK_LIBS PUBLIC
  TritonIR
  MLIRIR
  )
