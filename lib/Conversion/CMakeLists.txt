add_subdirectory(TritonToLinalg)
if("$ENV{CPU_TRITON}" STREQUAL "1")
    add_subdirectory(LinalgTollvm)
endif()

