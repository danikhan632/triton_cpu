/*
Copyright (c) 2015 - 2023 Advanced Micro Devices, Inc. All rights reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/
#ifndef HIP_INCLUDE_NVIDIA_HIP_GL_INTEROP_H
#define HIP_INCLUDE_NVIDIA_HIP_GL_INTEROP_H

#include <cuda_gl_interop.h>

typedef enum cudaGLDeviceList hipGLDeviceList;
#define hipGLDeviceListAll cudaGLDeviceListAll
#define hipGLDeviceListCurrentFrame  cudaGLDeviceListCurrentFrame
#define hipGLDeviceListNextFrame  cudaGLDeviceListNextFrame

inline static hipError_t hipGLGetDevices(unsigned int* pHipDeviceCount, int* pHipDevices, unsigned int hipDeviceCount,
                                         hipGLDeviceList deviceList) {
  return hipCUDAErrorTohipError(cudaGLGetDevices(pHipDeviceCount, pHipDevices, hipDeviceCount, deviceList));
}

inline static hipError_t hipGraphicsGLRegisterBuffer(hipGraphicsResource** resource, GLuint buffer, unsigned int flags) {
  return hipCUDAErrorTohipError(cudaGraphicsGLRegisterBuffer(resource, buffer, flags));
}

inline static hipError_t hipGraphicsGLRegisterImage(hipGraphicsResource** resource, GLuint image, GLenum target, unsigned int flags) {
  return hipCUDAErrorTohipError(cudaGraphicsGLRegisterImage(resource, image, target, flags));
}
#endif