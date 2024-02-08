import subprocess
import sys
import os

def printc(obj, color="cyan"):
    color_code = {
        "black": "30", "red": "31", "green": "32", "yellow": "33",
        "blue": "34", "magenta": "35", "cyan": "36", "white": "37"
    }
    colored_text = f"\033[{color_code[color]}m{obj}\033[0m" if color in color_code else obj
    print(colored_text)
def run_command(command):
    result = subprocess.run(command, capture_output=True, text=True)
    if result.stdout:
        printc(result.stdout, "green")
    if result.stderr:
        print("Error:", result.stderr)

def process_mlir_file(file_path, triton_shared_opt_path):
    # Define the output file path in the /tmp directory
    output_file_path = "/tmp/dot.mlir"

    # Run triton-shared-opt on the file
    triton_shared_opt_command = [
        triton_shared_opt_path, file_path, "--triton-to-linalg", "-o", output_file_path
    ]
    # print("Running triton-shared-opt...")
    run_command(triton_shared_opt_command)


if __name__ == "__main__":
    os.system("clear")
    if len(sys.argv) < 2:
        print("Usage: python script.py <path_to_mlir_file>")
        sys.exit(1)
    os.system("clear")
    file_path = sys.argv[1]
    opt_path ="/home/green/.triton/llvm/llvm-c2301380-ubuntu-x64/bin/mlir-opt "
    flags = "  --convert-linalg-to-affine-loops --eliminate-empty-tensors --allow-unregistered-dialect --empty-tensor-to-alloc-tensor --one-shot-bufferize=allow-return-allocs-from-loops=true --lower-affine --convert-linalg-to-loops --convert-scf-to-cf --convert-cf-to-llvm --convert-arith-to-llvm --convert-math-to-llvm --convert-complex-to-llvm --convert-vector-to-llvm --convert-index-to-llvm --memref-expand --expand-strided-metadata --finalize-memref-to-llvm --convert-func-to-llvm --lower-affine --convert-arith-to-llvm -o "
    dir_name, base_name = os.path.split(file_path)

    new_file_name = "opt_" + base_name
    new_file_path = os.path.join(dir_name, new_file_name) if dir_name else new_file_name

    
    command = str(opt_path + file_path + flags + new_file_path)
    print(new_file_path)
    result = os.system(command)

