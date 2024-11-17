
clear
/home/green/code/triton-cpu/python/build/cmake.linux-x86_64-cpython-3.11/third_party/triton_shared/tools/triton-sme-opt/triton-sme-opt /home/green/code/triton-cpu/extras/matmul_sve/matmul_kernel.ttsharedir --sme-conversion -o /home/green/code/triton-cpu/python/matmul.mlir


/home/green/code/triton-cpu/python/build/cmake.linux-x86_64-cpython-3.11/third_party/triton_shared/tools/triton-sme-opt/triton-sme-opt /home/green/code/triton-cpu/python/matmul.mlir --local-mem-conversion -o /home/green/code/triton-cpu/python/matmul_local.mlir