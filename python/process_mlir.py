import subprocess
import sys
import os

def print_colored(text, color):
    colors = {"black": "30", "red": "31", "green": "32", "yellow": "33", "blue": "34", "magenta": "35", "cyan": "36", "white": "37"}
    color_code = colors.get(color, "")
    if color_code:
        print(f"\033[{color_code}m{text}\033[0m")
    else:
        print(text)

def run_command(command, success_color="green", error_color="cyan"):
    try:
        output = subprocess.check_output(command, stderr=subprocess.STDOUT, text=True)
        print_colored(output, success_color)
    except subprocess.CalledProcessError as e:
        print_colored(f"{e.output}", "yellow")

def process_file(file_path, shared_opt_path, arm_opt_path):
    output_file = "/tmp/output.mlir"

    # # Run shared optimization
    # print("Running triton-shared-opt...")
    # run_command([shared_opt_path, file_path, "--triton-to-linalg", "-o", output_file], "yellow")

    # Display output file content
    # with open(output_file, "r") as file:
    #     print_colored(file.read(), "green")

    # Run ARM optimization
    print("Running triton-arm-opt...")
    run_command([arm_opt_path, file_path, "-am"], "magenta")

if __name__ == "__main__":
    os.system("clear")
    if len(sys.argv) < 2:
        print("Usage: python script.py <path_to_mlir_file>")
        sys.exit(1)
    file_path = sys.argv[1]
    triton_shared_opt_path = "/home/green/code/triton-cpu/python/build/cmake.linux-x86_64-cpython-3.11/third_party/triton_shared/tools/triton-shared-opt/triton-shared-opt"
    triton_arm_opt_path = "/home/green/code/triton-cpu/python/build/cmake.linux-x86_64-cpython-3.11/third_party/triton_shared/tools/triton-arm-opt/triton-arm-opt"
    
    process_file(file_path, triton_shared_opt_path, triton_arm_opt_path)


