import functools
from typing import Callable

from mlir.ir import *
from mlir.dialects import transform
from mlir.dialects import pdl
from mlir.dialects.transform import structured
from mlir.dialects.transform import pdl as transform_pdl

from mlir.dialects.transform import sparse_tensor


def run(f):
    with Context(), Location.unknown():
        module = Module.create()
        with InsertionPoint(module.body):
            sequence = transform.SequenceOp(
                transform.FailurePropagationMode.Propagate,
                [],
                transform.AnyOpType.get(),
            )
            with InsertionPoint(sequence.body):
                f(sequence.bodyTarget)
                transform.YieldOp()

        print(module)
    return f
@run
def testMatchSparseInOut(target):
    print(target)
    sparse_tensor.MatchSparseInOut(transform.AnyOpType.get(), target)