import re

def parse_args(command):
    # Updated regular expression to capture the elements
    lines = command.split('\n')
    before, after  = [], []
    reached = False
    for line in lines:
        if 'linalg.matmul' in line:
            command=line.strip()
            reached = True
            
        if not reached:
            after.append(line)
        else:
            before.append(line)

            
            
    # print(command)
    pattern = r'(%\d+)\s*=\s*(\w+\.\w+)\s*ins\(([^)]+)\)\s*outs\(([^)]+)\)\s*->\s*(.+)'
    
    match = re.match(pattern, command)
    if match:
        output_var = match.group(1)
        operation = match.group(2)
        inputs = match.group(3).split(', ')
        output_tensor_type = match.group(4)
        return_type = match.group(5)

        # Further processing to separate input variables and their types
        input_vars = []
        input_types = []
        for input in inputs:
            parts = input.split(' : ')
            if len(parts) == 2:
                var, var_type = parts
            else:
                var = parts[0]
                var_type = None
            input_vars.append(var.strip())
            input_types.append(var_type.strip() if var_type else None)
        data={
            "output_var": output_var,
            "operation": operation,
            "input_vars": input_vars,
            "input_types": input_types,
            "output_tensor_type": output_tensor_type,
            "return_type": return_type
        }
        return data, before , after
    else:
        return "No match found"


def process(mlir:str):
    op="""
    """


    data, bef, after = parse_args(mlir)
    
    
