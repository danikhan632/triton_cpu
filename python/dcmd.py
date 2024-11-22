#!/usr/bin/env python3

import os
import subprocess
import argparse
import sys

def run_command(cmd: list, description: str):
    """Run a command with error handling."""
    print(f"\n=== Running {description} ===")
    print(f"Command: {' '.join(cmd)}")
    try:
        subprocess.run(cmd, check=True)
    except subprocess.CalledProcessError as e:
        print(f"Error during {description}: {e}", file=sys.stderr)
        sys.exit(1)

def compile_kernel(input_file: str, output_dir: str, build_dir: str):
    """Compile the kernel through the full pipeline."""
    
    # Create output directory if it doesn't exist
    os.makedirs(output_dir, exist_ok=True)
    
    # Intermediate file paths
    sme_mlir = os.path.join(output_dir, "matmul_sme.mlir")
    local_mlir = os.path.join(output_dir, "matmul_local.mlir")
    llvm_mlir = os.path.join(output_dir, "matmul_llvm.mlir")
    final_llvm = os.path.join(output_dir, "matmul.ll")
    
    # Tool paths
    triton_sme_opt = '/home/green/code/triton-cpu/python/build/cmake.linux-x86_64-cpython-3.11/third_party/triton_shared/tools/triton-sme-opt/triton-sme-opt'
    triton_local_opt = '/home/green/code/triton-cpu/python/build/cmake.linux-x86_64-cpython-3.11/third_party/triton_shared/tools/triton-local-opt/triton-local-opt'
    mlir_opt = '/home/green/.triton/llvm/llvm-6f44bb77-ubuntu-x64/bin/mlir-opt'
    mlir_translate = '/home/green/.triton/llvm/llvm-6f44bb77-ubuntu-x64/bin/mlir-translate'
    
    # Step 1: SME conversion
    run_command([
        triton_sme_opt,
        input_file,
        "--sme-conversion",
        "-o", sme_mlir
    ], "SME Conversion")
    
    # Step 2: Local memory conversion
    run_command([
        triton_local_opt,
        sme_mlir,
        "--local-mem-conversion",
        "-o", local_mlir
    ], "Local Memory Conversion")
    
    # Step 3: Convert to LLVM dialect
    # run_command([
    #     mlir_opt,
    #     local_mlir,
    #     "--convert-linalg-to-affine-loops",
    #     "--eliminate-empty-tensors",
    #     "--empty-tensor-to-alloc-tensor",
    #     "--one-shot-bufferize=allow-return-allocs-from-loops=true",
    #     "--lower-affine",
    #     "--convert-linalg-to-loops",
    #     "--convert-scf-to-cf",
    #     "--convert-cf-to-llvm",
    #     "--convert-arith-to-llvm",
    #     "--convert-math-to-llvm",
    #     "--convert-complex-to-llvm",
    #     "--convert-vector-to-llvm",
    #     "--convert-index-to-llvm=index-bitwidth=64",
    #     "--finalize-memref-to-llvm",
   
    #     "-o", local_mlir
    # ], "MLIR to LLVM Dialect Conversion")
    
    # run_command([
    #     mlir_opt,
    #     local_mlir,
    #     "--reconcile-unrealized-casts",
   
    #     "-o", local_mlir
    # ], "MLIR to LLVM Dialect Conversion")
    
    
    # Step 3: Convert to LLVM dialect
    run_command([
        mlir_opt,
        local_mlir,

        "--convert-scf-to-cf",
        "--convert-cf-to-llvm",
        "--convert-arith-to-llvm",
        "--convert-math-to-llvm",
        "--convert-complex-to-llvm",
        "--convert-vector-to-llvm",
        "--convert-index-to-llvm",
        "--memref-expand",
        "--expand-strided-metadata",
        "--finalize-memref-to-llvm",
        "--convert-func-to-llvm",
        "--lower-affine",
        "--convert-arith-to-llvm",
        "--reconcile-unrealized-casts",
        "-o", llvm_mlir
    ], "MLIR to LLVM Dialect Conversion")
    
    # Step 4: Convert LLVM dialect to LLVM IR
    run_command([
        mlir_translate,
        llvm_mlir,
        "--mlir-to-llvmir",
        "-o", final_llvm
    ], "LLVM Dialect to LLVM IR Translation")

def main():
    parser = argparse.ArgumentParser(description="Compile kernel with custom memory layout")
    parser.add_argument("input", help="Input .ttsharedir file")
    parser.add_argument("-o", "--output-dir", default=".", help="Output directory")
    parser.add_argument("--build-dir", help="Path to build directory containing tools")
    
    args = parser.parse_args()
    
    # Verify input file exists
    if not os.path.exists(args.input):
        print(f"Input file {args.input} does not exist", file=sys.stderr)
        sys.exit(1)
    
    compile_kernel(args.input, args.output_dir, args.build_dir)
    print("\nCompilation completed successfully!")

if __name__ == "__main__":
    main()