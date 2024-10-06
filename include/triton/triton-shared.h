#ifndef TRITON_SHARED_H
#define TRITON_SHARED_H

#include <pybind11/pybind11.h>
#include <pybind11/stl.h>
#include <pybind11/functional.h>
#include <pybind11/numpy.h>

#include <string>

namespace py = pybind11;

namespace triton {
namespace shared {

py::tuple translate_triton_gpu_to_spirv(const std::string &ttgir, py::dict computeCapability);

py::bytes compile_spirv_to_spvbin(const std::string &spirvCode, int capability);

void init_triton_shared(py::module &m);

}  // namespace shared
}  // namespace triton

// This is the function that libtriton.so is looking for
extern "C" {
    void init_triton_triton_shared(py::module &m);
}

#endif  // TRITON_SHARED_H