from mlir.ir import *
from mlir.dialects import transform
from mlir.dialects.transform.structured import TileUsingForOp

from mlir.ir import *
from mlir.dialects import linalg
from mlir.dialects import transform
from mlir.dialects.transform.structured import TileUsingForOp
from mlir.ir import *
from mlir.dialects import linalg
from mlir.ir import *
from mlir.dialects import linalg
from mlir.ir import *
from mlir.dialects import linalg
from mlir.dialects.transform.structured import structured_vectorize
from mlir.dialects import scf


def printc(obj, color="cyan"):
    color_code = {
        "black": "30", "red": "31", "green": "32", "yellow": "33",
        "blue": "34", "magenta": "35", "cyan": "36", "white": "37"
    }
    colored_text = f"\033[{color_code[color]}m{obj}\033[0m" if color in color_code else obj
    print(colored_text)


def TransformLinalgGenericOp(op: linalg.GenericOp):
    printc(op,"green")
    # Assuming `op` is your target operation and `vector_sizes` are correctly defined:
    vectorized_op = structured_vectorize(
        transformed=op,  # Assuming `op` is the result of some transformation or the original op
        target=op,  # Target operation for vectorization
        vectorize_nd_extract=True,  # Hypothetical example flag
        vectorize_padding=True,  # Another example flag
        # Other parameters as needed
    )

    printc(vectorized_op, "yellow")
        
     
def TransformLinalgReduceOp(op: linalg.ReduceOp):
    printc(op, "red")
    
    
def TransformLinalgMatmulOp(op: linalg.MatmulOp):
    printc(op, "blue")
    # Apply tiling to the located matmul operation
    sizes_attr = ArrayAttr.get([IntegerAttr.get(IndexType.get(op.context), size) for size in [4, 4, 1]], op.context)
    tiled = TileUsingForOp(op, sizes=sizes_attr)
    
    



def run(code: str):
    # Create and use a context for all MLIR operations
    printc("Creating and using a context for all MLIR operations", "magenta")
    with Context() as ctx:
        # Parse the input within the context
        with Location.unknown(ctx):
            module = Module.parse(code, ctx)
            for op in module.operation.regions[0].blocks[0]:
                        # print(op.operation.name)
                        if op.operation.name == "func.func":
                            for func_op in op.regions[0].blocks[0]:
                                # print(func_op)
                                match func_op.operation.name:                              
                                    # case "linalg.generic":
                                    #     TransformLinalgGenericOp(func_op)
                                 
                                    # case "linalg.reduce":
                                    #     TransformLinalgReduceOp(func_op)     
                                           
                                    case "linalg.matmul":
                                        TransformLinalgMatmulOp(func_op)                               



if __name__ == '__main__':
    layer = open("/home/green/code/triton_cpu_new/extras/kernels/dot.mlir","r").read()
    run(layer)
