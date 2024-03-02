from typing import Optional
from mlir.ir import *
from mlir.dialects import transform
from mlir.dialects.transform.structured import TileUsingForOp

from mlir.ir import *
from mlir.dialects import linalg

from mlir.dialects.transform import structured as tx

def printc(obj, color="cyan"):
    color_code = {
        "black": "30", "red": "31", "green": "32", "yellow": "33",
        "blue": "34", "magenta": "35", "cyan": "36", "white": "37"
    }
    colored_text = f"\033[{color_code[color]}m{obj}\033[0m" if color in color_code else obj
    print(colored_text)


def run(code: str):
    with Context() as ctx, Location.unknown(ctx):
        module = Module.parse(code)

        # Initialize variables to store the matmul operation and its containing block
        matmul_op = None
        containing_block = None

        # Iterate through the module to find the linalg.matmul operation
        for op in module.body.operations:
            if op.operation.name == "func.func":
                for block in op.regions[0].blocks:
                    for nested_op in block.operations:
                        if nested_op.name == "linalg.matmul":
                            matmul_op = nested_op
                            containing_block = block  # Store the block containing the matmul operation
                            break
                    if matmul_op:
                        break
                if matmul_op:
                    break

        if not matmul_op:
            print("linalg.matmul operation not found.")
            return

        # Define the static sizes for the tiling
        static_sizes_attr = ArrayAttr.get([IntegerAttr.get(IndexType.get(), size) for size in [4, 4, 1]])

        # Ensure the containing block is correctly identified for setting the insertion point
        if containing_block:
            # for b in containing_block.operations:
            #     printc(b)
            printc(containing_block.operations[18])
            with InsertionPoint(containing_block.operations[18]):  # Set the insertion point at the end of the containing block
                # Apply TileUsingForOp transformation
                tiled_op, loops = tx.TileUsingForOp(
                    target=matmul_op,
                    sizes=static_sizes_attr,
                    loc=matmul_op.loc
                )
                print("Applied tiling to linalg.matmul operation with TileUsingForOp.")
        else:
            print("Error: Containing block for linalg.matmul operation not found.")


if __name__ == '__main__':
    layer = open("/home/green/code/triton-cpu/extras/kernels/dot.mlir","r").read()
    run(layer)