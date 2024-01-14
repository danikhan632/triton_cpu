#!/bin/bash

# Set commit hash and other variables
LLVM_COMMIT_HASH="49af6502c6dcb4a7f7520178bd14df396f78240c"
SHORT_LLVM_COMMIT_HASH="${LLVM_COMMIT_HASH:0:8}"
mkdir -p "$HOME/.triton/llvm"
INSTALL_DIR="$HOME/.triton/llvm/llvm-${SHORT_LLVM_COMMIT_HASH}-ubuntu-arm64"

Set up environment variables
export SCCACHE_DIR="$PWD/sccache"

# Create and clear sccache directory
# mkdir -p $SCCACHE_DIR
# rm -rf $SCCACHE_DIR/*

# Check out LLVM at specified commit
# git clone https://github.com/llvm/llvm-project.git
# cd llvm-project
# git checkout $LLVM_COMMIT_HASH
# cd ..

# Install prerequisites (Uncomment if necessary)
# sudo apt-get update
sudo apt-get install -y cmake ninja-build clang lld python3-pip
python3.11 -m pip install sccache

# Configure, build, and install LLVM
mkdir build
cd build
cmake -GNinja ../llvm-project/llvm \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ \
    -DCMAKE_C_COMPILER_LAUNCHER=sccache -DCMAKE_CXX_COMPILER_LAUNCHER=sccache \
    -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" \
    -DLLVM_TARGETS_TO_BUILD="AArch64" \
    -DLLVM_ENABLE_PROJECTS="mlir" \
    -DLLVM_ENABLE_ASSERTIONS=ON

ninja 
ninja install

# Package the build
cd ..
tar czf "${INSTALL_DIR}.tar.gz" -C "$HOME/.triton/llvm" "llvm-${SHORT_LLVM_COMMIT_HASH}-ubuntu-arm64"
