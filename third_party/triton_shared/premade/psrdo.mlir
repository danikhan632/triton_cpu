Function kernel(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
    cst = 0.0 (as bf16)
    c256 = 256 (as index)
    c128 = 128 (as index)

    // Reinterpret arg0 as a 128x64 matrix and allocate a similar sized memory
    reinterpret_cast = ReinterpretCast(arg0, [0], [128, 64], [c128, 1])
    alloc = AllocateMemory(128x64xbf16)
    CopyMemory(reinterpret_cast, alloc)

    tensor0 = ConvertToTensor(alloc)

    // Reinterpret arg1 as a 256x64 matrix and allocate a similar sized memory
    reinterpret_cast_1 = ReinterpretCast(arg1, [0], [256, 64], [1, c256])
    alloc_1 = AllocateMemory(256x64xbf16)
    CopyMemory(reinterpret_cast_1, alloc_1)

    tensor1 = ConvertToTensor(alloc_1)

    // Transpose tensor1 from 256x64 to 64x256
    tensor2 = EmptyTensor(64x256xbf16)
    transposed = Transpose(tensor1, tensor2, permutation = [1, 0])

    // Reinterpret arg2 as a 128x256 matrix and allocate a similar sized memory
    reinterpret_cast_2 = ReinterpretCast(arg2, [0], [128, 256], [c256, 1])
    alloc_3 = AllocateMemory(128x256xbf16)
    CopyMemory(reinterpret_cast_2, alloc_3)

    tensor3 = ConvertToTensor(alloc_3)

    // Create an empty tensor and fill it with cst
    tensor4 = EmptyTensor(128x256xbf16)
    tensor5 = Fill(tensor4, cst)

    // Perform matrix multiplication of tensor0 and transposed, output to tensor5
    tensor6 = MatrixMultiply(tensor0, transposed, tensor5)

    // Generic linalg operation on tensor6 and tensor3, outputting to tensor6
    tensor7 = LinalgGenericOperation(tensor6, tensor3, {
        for each element in tensor6, tensor3
            element = element of tensor6 + element of tensor3
        return element
    })

    // Store tensor7 back to the memory pointed by arg2
    StoreTensor(tensor7, reinterpret_cast_2)

    return
