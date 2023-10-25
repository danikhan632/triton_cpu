add_subdirectory(triton-shared-opt)
if("$ENV{CPU_TRITON}" STREQUAL "1")
    add_subdirectory(triton-shared-llvm)
endif()

