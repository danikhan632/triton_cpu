from mlir.ir import *
from mlir.dialects import transform
from mlir.dialects.transform.structured import TileUsingForOp

from mlir.ir import *
from mlir.dialects import linalg
from mlir.dialects.transform.structured import TileUsingForOp
from mlir.ir import *
from mlir.dialects import linalg
from mlir.ir import *
from mlir.dialects import linalg
from mlir.ir import *
from mlir.dialects import linalg
from mlir.dialects.transform.structured import TileUsingForOp
from mlir.dialects import scf
def run(code: str):
    # Create and use a context for all MLIR operations
    with Context() as ctx:
        # Parse the input within the context
        with Location.unknown(ctx):
            module = Module.parse(code, ctx)

        # Locate the matmul operation
        matmul = None
        parent_block=None
        for op in module.operation.regions[0].blocks[0]:
            if op.operation.name == "func.func":
                for func_op in op.regions[0].blocks[0]:
                    if func_op.operation.name == "linalg.matmul":
                        matmul = func_op
                        parent_block = op.regions[0].blocks[0]
                        break
                if matmul is not None:
                    break

        if matmul is None:
            print("linalg.matmul operation not found.")
            return

        # Apply tiling to the located matmul operation
    # ... [previous code]

    # Apply tiling to the located matmul operation
# ... [previous code]

# Apply tiling to the located matmul operation
# ... [previous code]

# Apply tiling to the located matmul operation
    if matmul:
       
        sizes_attr = ArrayAttr.get([IntegerAttr.get(IndexType.get(ctx), size) for size in [4, 4, 1]], ctx)

        # Use the block that contains the matmul operation as the insertion point
        with InsertionPoint.at_block_terminator(parent_block):
            # Construct TileUsingForOp with the correct arguments
            # Note that 'target' is not used as a keyword argument
            tiled_op, loops = TileUsingForOp(
                matmul,  # The matmul operation is passed as a positional argument
                sizes=sizes_attr,  # Pass the sizes as an ArrayAttr
                loc=Location.unknown(ctx)  # Location is passed as a keyword argument
            )
        print("Applied tiling to linalg.matmul operation with TileUsingForOp.")


if __name__ == '__main__':
    layer = open("/home/green/code/triton_cpu_new/extras/kernels/dot.mlir","r").read()
    run(layer)
