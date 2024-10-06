set(LLVM_TARGET_DEFINITIONS VortexGPUDialect.td)
mlir_tablegen(VortexGPUDialect.h.inc -gen-dialect-decls -dialect=tts)
mlir_tablegen(VortexGPUDialect.cpp.inc -gen-dialect-defs -dialect=tts)
mlir_tablegen(VortexGPUOps.h.inc -gen-op-decls)
mlir_tablegen(VortexGPUOps.cpp.inc -gen-op-defs)


add_public_tablegen_target(VortexGPUTableGen)
