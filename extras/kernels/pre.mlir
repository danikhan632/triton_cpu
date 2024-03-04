// Example MLIR script for standalone execution: Batch Matrix Multiplication using linalg.matmul
module {
  func.func @batch_matmul(%arg0: tensor<128x64xbf16>, %arg1: tensor<64x256xbf16>) -> tensor<128x256xbf16> {
    // Constants used in the loop and tensor operations
    %c0 = arith.constant 0 : index
    %c4 = arith.constant 4 : index
    %c64 = arith.constant 64 : index
    %c1 = arith.constant 1 : index
    %c128 = arith.constant 128 : index
    %c256 = arith.constant 256 : index
    %cst = arith.constant 0.000000e+00 : bf16

    // Initialize an output tensor with zeros
    %init_tensor = linalg.init_tensor [%c128, %c256] : tensor<128x256xbf16>

    // Main loop iterating over the first dimension
    %result = scf.for %i = %c0 to %c128 step %c4 iter_args(%accum = %init_tensor : tensor<128x256xbf16>) -> (tensor<128x256xbf16>) {
      // Nested loop iterating over the second dimension
      %inner_result = scf.for %j = %c0 to %c256 step %c4 iter_args(%inner_accum = %accum : tensor<128x256xbf16>) -> (tensor<128x256xbf16>) {
        // Extract slices for multiplication
        %slice_a = tensor.extract_slice %arg0[%i, %c0] [4, 64] [1, 1] : tensor<128x64xbf16> to tensor<4x64xbf16>
        %slice_b = tensor.extract_slice %arg1[%c0, %j] [64, 4] [1, 1] : tensor<64x256xbf16> to tensor<64x4xbf16>
        %slice_c = tensor.extract_slice %inner_accum[%i, %j] [4, 4] [1, 1] : tensor<128x256xbf16> to tensor<4x4xbf16>

        // Perform matrix multiplication using linalg.matmul
        %mul_result = linalg.matmul ins(%slice_a, %slice_b : tensor<4x64xbf16>, tensor<64x4xbf16>) outs(%slice_c : tensor<4x4xbf16>) -> tensor<4x4xbf16>

        // Insert the result back into the accumulator tensor
        %updated_accum = tensor.insert_slice %mul_result into %inner_accum[%i, %j] [4, 4] [1, 1] : tensor<4x4xbf16> into tensor<128x256xbf16>
        scf.yield %updated_accum : tensor<128x256xbf16>
      }
      scf.yield %inner_result : tensor<128x256xbf16>
    }
    return %result : tensor<128x256xbf16>
  }
}
