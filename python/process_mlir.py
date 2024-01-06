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
def run_command(command, color="green"):
    result = subprocess.run(command, capture_output=True, text=True)
    if result.stdout:
        printc(result.stdout, color)
    if result.stderr:
        print("Error:", result.stderr)

def process_mlir_file(file_path, triton_shared_opt_path, triton_arm_opt_path):
    # Define the output file path in the /tmp directory
    output_file_path = "/home/green/code/triton_cpu/python/output.mlir"

    # Run triton-shared-opt on the file
    triton_shared_opt_command = [
        triton_shared_opt_path, file_path, "--triton-to-linalg", "-o", output_file_path
    ]
    print("Running triton-shared-opt...")
    

    run_command(triton_shared_opt_command)
    text = open(output_file_path,"r").read()
    printc(text,"yellow")

    # Run triton-arm-opt on the processed file
    triton_arm_opt_command = [triton_arm_opt_path, output_file_path, "-am"]
    print("Running triton-arm-opt...")
    run_command(triton_arm_opt_command)

if __name__ == "__main__":
    os.system("clear")
    if len(sys.argv) < 2:
        print("Usage: python script.py <path_to_mlir_file>")
        sys.exit(1)
    os.system("rm -rf ~/.triton/cache")

    file_path = sys.argv[1]
    triton_shared_opt_path = "/home/green/code/triton_cpu/python/build/cmake.linux-x86_64-cpython-3.11/third_party/triton_shared/tools/triton-shared-opt/triton-shared-opt"
    triton_arm_opt_path = "/home/green/code/triton_cpu/python/build/cmake.linux-x86_64-cpython-3.11/third_party/triton_shared/tools/triton-arm-opt/triton-arm-opt"
    
    process_mlir_file(file_path, triton_shared_opt_path, triton_arm_opt_path)


