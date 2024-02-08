turn this into a UML diagram and group similar ops using mermaidcode


- **TT_IntToPtrOp**: Casts an integer to a pointer type.
- **TT_PtrToIntOp**: Casts a pointer to an integer type.
- **TT_BitcastOp**: Casts between types of the same bit width without changing the bit representation.
- **TT_FpToFpOp**: Casts between floating-point types with optional custom rounding modes.
- **TT_ClampFOp**: Clamps the values of a tensor between specified minimum and maximum values.
- **TT_LoadOp**: Loads data from a memory address pointed to by a tensor of pointers or a single tensor pointer.
- **TT_StoreOp**: Stores data to a memory address pointed to by a tensor of pointers or a single tensor pointer.
- **TT_AtomicRMWOp**: Performs an atomic read-modify-write operation on a value at a specified memory address.
- **TT_AtomicCASOp**: Performs an atomic compare-and-swap operation on a value at a specified memory address.
- **TT_SplatOp**: Broadcasts a scalar value to all elements of a tensor.
- **TT_ExpandDimsOp**: Expands the dimensions of a tensor at a specified axis.
- **TT_ReshapeOp**: Reshapes a tensor to a new shape, potentially allowing element reordering.
- **TT_BroadcastOp**: Broadcasts a tensor to a new shape by expanding dimensions of size 1.
- **TT_CatOp**: Concatenates two tensors along a specified dimension.
- **TT_ExperimentalInterleaveOp**: Interleaves the elements of two tensors along their minor dimension.
- **TT_TransOp**: Rearranges the dimensions of a tensor according to a specified order.
- **TT_GetProgramIdOp**: Retrieves the ID of the currently executing program or thread block.
- **TT_GetNumProgramsOp**: Retrieves the total number of program or thread blocks.
- **TT_ReduceOp**: Performs a reduction operation on a tensor along a specified axis.
- **TT_ReduceReturnOp**: Acts as the terminator for the `TT_ReduceOp`, specifying the result of the reduction.
- **TT_ScanOp**: Performs an inclusive or exclusive scan (prefix sum) operation on a tensor.
- **TT_ScanReturnOp**: Acts as the terminator for the `TT_ScanOp`, specifying the result of the scan.
- **TT_ExternElementwiseOp**: Calls an external function element-wise on the operands.
- **TT_MakeRangeOp**: Generates a range of integer values in a tensor.
- **TT_ElementwiseInlineAsmOp**: Executes inline assembly code for element-wise operations on tensors.
- **TT_HistogramOp**: Computes the histogram of values in an input tensor.
- **TT_PrintOp**: Prints a message for debugging purposes from device code.
- **TT_AssertOp**: Performs an assertion check in device code for debugging or correctness checking.
- **TT_MakeTensorPtrOp**: Creates a tensor pointer with metadata about the parent tensor and its block.
- **CallOp**: Represents a call to a function within the same symbol scope.
- **FuncOp**: Defines a function with a given signature and body.
- **ReturnOp**: Terminates a function and returns control to the caller, possibly with return values.

