
clear
/home/green/code/triton-cpu/python/build/cmake.linux-x86_64-cpython-3.11/third_party/triton_shared/tools/triton-sme-opt/triton-sme-opt /home/green/code/triton-cpu/extras/matmul_sve/matmul_kernel.ttsharedir --sme-conversion -o /home/green/code/triton-cpu/python/matmul.mlir


/home/green/code/triton-cpu/python/build/cmake.linux-x86_64-cpython-3.11/third_party/triton_shared/tools/triton-local-opt/triton-local-opt /home/green/code/triton-cpu/python/matmul.mlir --local-mem-conversion -o /home/green/code/triton-cpu/python/matmul_local.mlir



# /home/green/.triton/llvm/llvm-6f44bb77-ubuntu-x64/bin/mlir-opt  

# /home/green/.triton/llvm/llvm-6f44bb77-ubuntu-x64/bin/mlir-translate /home/green/code/triton-cpu/python/matmul.mlir --mlir-to-llvmir -o /home/green/code/triton-cpu/python/matmul_local.mlir