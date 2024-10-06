
clear
export LLVM_BUILD_DIR="/home/green/code/llvm-project/build"
source /home/green/code/triton-cpu/cpu/bin/activate
cd python
TRITON_BUILD_WITH_CLANG_LLD=true TRITON_CODEGEN_TRITON_SHARED=1 LLVM_INCLUDE_DIRS=$LLVM_BUILD_DIR/include LLVM_LIBRARY_DIR=$LLVM_BUILD_DIR/lib LLVM_SYSPATH=$LLVM_BUILD_DIR /home/green/code/triton-cpu/cpu/bin/python3 setup.py develop