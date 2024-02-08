import os
import re

def find_tt_ops(root_dir):
    tt_ops = set()
    reduce_pattern = re.compile(r'\btt\.reduce\b')
    tt_op_pattern = re.compile(r'\btt\.\w+\b')

    for subdir, dirs, files in os.walk(root_dir):
        for file in files:
            file_path = os.path.join(subdir, file)
            try:
                with open(file_path, 'r') as f:
                    content = f.read()
                    # Find all tt.* operations, including the special case for tt.reduce
                    ops = tt_op_pattern.findall(content)
                    tt_ops.update(ops)
                    # Special handling for tt.reduce
                    if reduce_pattern.search(content):
                        tt_ops.add('tt.reduce')
            except (IOError, UnicodeDecodeError) as e:
                print(f"Error reading file {file_path}: {e}")

    return tt_ops

# Specify the root directory where to start searching from
root_directory = '/home/green/code/triton_cpu_new/third_party/triton_shared/test'  # Change this to your actual directory path
tt_operations = find_tt_ops(root_directory)

# Print out the unique tt.* operations
for op in sorted(tt_operations):
    print(op)
