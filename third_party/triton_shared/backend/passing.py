from typing import Optional
from mlir.ir import *
from mlir.dialects import transform
from mlir.dialects.transform.structured import TileUsingForOp

from mlir.ir import *
from mlir.dialects import linalg
from mlir.dialects.transform.structured import TileUsingForOp
from mlir.ir import *



from mlir.ir import *
from mlir.dialects.transform import structured as tx





def extract_matmul(code: str):
    with Context() as ctx, Location.unknown(ctx):
        module = Module.parse(code)

        # Initialize variables to hold the matmul operation and its parent block
        matmul_op = None
        parent_block = None

        # Iterate through operations to find 'linalg.matmul'
        for op in module.body.operations:
            if op.operation.name == "func.func":
                for nested_op in op.regions[0].blocks[0].operations:
                    if nested_op.name == "linalg.matmul":
                        matmul_op = nested_op
                        parent_block = op.regions[0].blocks[0]  # Capture the parent block
                        break
                if matmul_op is not None:
                    break

        if matmul_op is None:
            print("linalg.matmul operation not found.")
            parent_block = None
        return matmul_op, parent_block
        


def run(code: str):
    with Context() as ctx, Location.unknown(ctx):
        matmul_op, parent_block = extract_matmul(code)
        static_sizes = [4, 4, 1]  # Example static sizes
        # Conversion to appropriate attribute format
        static_sizes_attr = ArrayAttr.get([IntegerAttr.get(IndexType.get(), size) for size in static_sizes])

        if matmul_op and parent_block:
            # Check if the block has a terminator; if not, use the end of the block for insertion
            if not parent_block.operations or not parent_block.operations[-1].is_terminator:
                insertion_point = InsertionPoint(parent_block)  # Insert at the end of the block
            else:
                insertion_point = InsertionPoint.at_block_terminator(parent_block)

            with insertion_point:
                # Adjust the call to TileUsingForOp according to its correct signature
                # Assuming 'matmul_op' is the target operation to tile and using static_sizes for simplicity
                print(help(matmul_op))
                tiled_op, loops = TileUsingForOp(
                    tiled_linalg_op=matmul_op.operation,  # The operation as part of the resulting tiled op
                    loops=[],  # Assuming no predefined loops
                    target=matmul_op,  # The target operation to tile
                    dynamic_sizes=[],  # Assuming no dynamic sizes for simplicity
                    static_sizes=static_sizes_attr,  # Using static sizes
                    loc=matmul_op.get_loc(),  # Location from the matmul operation
                    ip=None  # Let the context manage the insertion point
                )
                print("Applied tiling to linalg.matmul operation with TileUsingForOp.")



if __name__ == '__main__':
    layer = open("/home/green/code/triton_cpu_new/extras/kernels/dot.mlir","r").read()
    run(layer)
