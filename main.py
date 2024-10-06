
import os
bin = "/home/green/code/triton-cpu/python/build/cmake.linux-x86_64-cpython-3.11/bin/triton-llvm-opt"
inp_mlir = "gemm_gpu.mlir"


# os.system(f"{bin} {inp_mlir}")


from triton._C.libtriton import triton_shared


# print(help(triton_shared))
ttgir = open(inp_mlir,"r").read()
print(triton_shared.add(2,2))
result = triton_shared.translate_triton_gpu_to_spirv(ttgir, 70)
print(result)
# arch={'num_warps': 8, 'threads_per_warp': 32} #just example nubers


# mod =  open("matmul.ttgir","r").read()



# spirv_code, share_memory_size = _triton.translate_triton_gpu_to_spirv(str(mod), arch)



# open('kernel.spirv','w').write(spirv_code)
# print("shared memory: ", share_memory_size)