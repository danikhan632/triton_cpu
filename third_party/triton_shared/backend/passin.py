from typing import Optional
from mlir.ir import *
from mlir.dialects import transform
from mlir.dialects.transform.structured import TileUsingForOp

from mlir.ir import *
from mlir.dialects import linalg
from mlir.dialects.transform.structured import TileUsingForOp
from mlir.ir import *

import mlir

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
        module = Module.parse(code)
    # Step 0: Setup the transformation pipeline on the given module
        with mlir.ir.InsertionPoint(module.body):
            named_sequence = transform.NamedSequenceOp("__transform_main", module)

        # Step 1: Match the `linalg.matmul` operations in the module
        matmul = transform.match_ops(named_sequence, ["linalg.matmul"], consumed=True)

        # Step 2: Tile the matched `linalg.matmul` operation for size [4] x [4]
        tiled_linalg_op, loops = transform.tile_using_for(matmul, sizes=[[4, 4]], interchange=[1])

        # Step 3: Vectorize the tiled operation
        transform.vectorize(tiled_linalg_op, vector_sizes=[[4, 4], [1]])

        # Step 4: Bufferize the module to support memrefs
        bufferized = transform.one_shot_bufferize(module, bufferize_function_boundaries=True)

        # Step 5: Match `func.func` operations in the bufferized module
        func = transform.match_ops(bufferized, ["func.func"], consumed=True)

        # Step 6: Apply patterns for lowering vector.multi_reduction to vector.contract
        transform.apply_patterns(func, [
            "vector.lower_masked_transfers",
            "vector.transfer_permutation_patterns",
            "vector.reduction_to_contract"
        ])

        # Step 7: Further lower vector.contract to vector.outerproduct and apply other patterns
        transform.apply_patterns(func, [
            "vector.lower_contraction",
            "vector.lower_masks",
            "vector.rank_reducing_subview_patterns"
        ])

        return module

# Assuming `module` is your MLIR module object
# apply_transform(module)

            
    
    
if __name__ == '__main__':
    layer = open("/home/green/code/triton_cpu_new/extras/kernels/dot.mlir","r").read()
    run(layer)
