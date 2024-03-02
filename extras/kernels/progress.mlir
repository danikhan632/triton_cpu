%6 = scf.for %arg9 = %c0 to %c128_5 step %c4_6 iter_args(%arg10 = %5) -> (tensor<128x256xbf16>) {
  %9 = scf.for %arg11 = %c0_7 to %c256_8 step %c4_9 iter_args(%arg12 = %arg10) -> (tensor<128x256xbf16>) {
    %10 = scf.for %arg13 = %c0_10 to %c64 step %c1_11 iter_args(%arg14 = %arg12) -> (tensor<128x256xbf16>) {
      %extracted_slice = tensor.extract_slice %0[%arg9, %arg13] [4, 1] [1, 1] : tensor<128x64xbf16> to tensor<4x1xbf16>
      %extracted_slice_12 = tensor.extract_slice %transposed[%arg13, %arg11] [1, 4] [1, 1] : tensor<64x256xbf16> to tensor<1x4xbf16>
      %extracted_slice_13 = tensor.extract_slice %arg14[%arg9, %arg11] [4, 4] [1, 1] : tensor<128x256xbf16> to tensor<4x4xbf16>
      %c4_14 = arith.constant 4 : index
      %c4_15 = arith.constant 4 : index
      %c1_16 = arith.constant 1 : index
      %c0_17 = arith.constant 0 : index
      %cst_18 = arith.constant 0.000000e+00 : bf16
      %11 = vector.transfer_read %extracted_slice[%c0_17, %c0_17], %cst_18 {permutation_map = affine_map<(d0, d1) -> (d0, 0, d1)>} : tensor<4x1xbf16>, vector<4x4x1xbf16>
      %cst_19 = arith.constant 0.000000e+00 : bf16
      %12 = vector.transfer_read %extracted_slice_12[%c0_17, %c0_17], %cst_19 {permutation_map = affine_map<(d0, d1) -> (0, d1, d0)>} : tensor<1x4xbf16>, vector<4x4x1xbf16>
      %cst_20 = arith.constant 0.000000e+00 : bf16
      %13 = vector.transfer_read %extracted_slice_13[%c0_17, %c0_17], %cst_20 : tensor<4x4xbf16>, vector<4x4xbf16>
      %14 = arith.mulf %11, %12 : vector<4x4x1xbf16>
      %15 = vector.multi_reduction <add>, %14, %13 [2] : vector<4x4x1xbf16> to vector<4x4xbf16>
      %c0_21 = arith.constant 0 : index
      %16 = vector.transfer_write %15, %extracted_slice_13[%c0_21, %c0_21] : vector<4x4xbf16>, tensor<4x4xbf16>
      %17 = linalg.matmul ins(%extracted_slice, %extracted_slice_12 : tensor<4x1xbf16>, tensor<1x4xbf16>) outs(%extracted_slice_13 : tensor<4x4xbf16>) -> tensor<4x4xbf16>
      %inserted_slice = tensor.insert_slice %17 into %arg14[%arg9, %arg11] [4, 4] [1, 1] : tensor<4x4xbf16> into tensor<128x256xbf16>
      scf.yield %inserted_slice : tensor<128x256xbf16>
    }
    scf.yield %10 : tensor<128x256xbf16>
  }
  scf.yield %9 : tensor<128x256xbf16>
}%9 = scf.for %arg11 = %c0_7 to %c256_8 step %c4_9 iter_args(%arg12 = %arg10) -> (tensor<128x256xbf16>) {
  %10 = scf.for %arg13 = %c0_10 to %c64 step %c1_11 iter_args(%arg14 = %arg12) -> (tensor<128x256xbf16>) {
    %extracted_slice = tensor.extract_slice %0[%arg9, %arg13] [4, 1] [1, 1] : tensor<128x64xbf16> to tensor<4x1xbf16>
    %extracted_slice_12 = tensor.extract_slice %transposed[%arg13, %arg11] [1, 4] [1, 1] : tensor<64x256xbf16> to tensor<1x4xbf16>
    %extracted_slice_13 = tensor.extract_slice %arg14[%arg9, %arg11] [4, 4] [1, 1] : tensor<128x256xbf16> to tensor<4x4xbf16>
    %c4_14 = arith.constant 4 : index
    %c4_15 = arith.constant 4 : index
    %c1_16 = arith.constant 1 : index
    %c0_17 = arith.constant 0 : index
    %cst_18 = arith.constant 0.000000e+00 : bf16
    %11 = vector.transfer_read %extracted_slice[%c0_17, %c0_17], %cst_18 {permutation_map = affine_map<(d0, d1) -> (d0, 0, d1)>} : tensor<4x1xbf16>, vector<4x4x1xbf16>
    %cst_19 = arith.constant 0.000000e+00 : bf16
    %12 = vector.transfer_read %extracted_slice_12[%c0_17, %c0_17], %cst_19 {permutation_map = affine_map<(d0, d1) -> (0, d1, d0)>} : tensor<1x4xbf16>, vector<4x4x1xbf16>
    %cst_20 = arith.constant 0.000000e+00 : bf16
    %13 = vector.transfer_read %extracted_slice_13[%c0_17, %c0_17], %cst_20 : tensor<4x4xbf16>, vector<4x4xbf16>
    %14 = arith.mulf %11, %12 : vector<4x4x1xbf16>
    %15 = vector.multi_reduction <add>, %14, %13 [2] : vector<4x4x1xbf16> to vector<4x4xbf16>
    %c0_21 = arith.constant 0 : index
    %16 = vector.transfer_write %15, %extracted_slice_13[%c0_21, %c0_21] : vector<4x4xbf16>, tensor<4x4xbf16>
    %17 = linalg.matmul ins(%extracted_slice, %extracted_slice_12 : tensor<4x1xbf16>, tensor<1x4xbf16>) outs(%extracted_slice_13 : tensor<4x4xbf16>) -> tensor<4x4xbf16>
    %inserted_slice = tensor.insert_slice %17 into %arg14[%arg9, %arg11] [4, 4] [1, 1] : tensor<4x4xbf16> into tensor<128x256xbf16>
    scf.yield %inserted_slice : tensor<128x256xbf16>
  }
  scf.yield %10 : tensor<128x256xbf16>
}%10 = scf.for %arg13 = %c0_10 to %c64 step %c1_11 iter_args(%arg14 = %arg12) -> (tensor<128x256xbf16>) {
  %extracted_slice = tensor.extract_slice %0[%arg9, %arg13] [4, 1] [1, 1] : tensor<128x64xbf16> to tensor<4x1xbf16>
  %extracted_slice_12 = tensor.extract_slice %transposed[%arg13, %arg11] [1, 4] [1, 1] : tensor<64x256xbf16> to tensor<1x4xbf16>
  %extracted_slice_13 = tensor.extract_slice %arg14[%arg9, %arg11] [4, 4] [1, 1] : tensor<128x256xbf16> to tensor<4x4xbf16>
  %c4_14 = arith.constant 4 : index
  %c4_15 = arith.constant 4 : index
  %c1_16 = arith.constant 1 : index
  %c0_17 = arith.constant 0 : index
  %cst_18 = arith.constant 0.000000e+00 : bf16
  %11 = vector.transfer_read %extracted_slice[%c0_17, %c0_17], %cst_18 {permutation_map = affine_map<(d0, d1) -> (d0, 0, d1)>} : tensor<4x1xbf16>, vector<4x4x1xbf16>
  %cst_19 = arith.constant 0.000000e+00 : bf16
  %12 = vector.transfer_read %extracted_slice_12[%c0_17, %c0_17], %cst_19 {permutation_map = affine_map<(d0, d1) -> (0, d1, d0)>} : tensor<1x4xbf16>, vector<4x4x1xbf16>
  %cst_20 = arith.constant 0.000000e+00 : bf16
  %13 = vector.transfer_read %extracted_slice_13[%c0_17, %c0_17], %cst_20 : tensor<4x4xbf16>, vector<4x4xbf16>
  %14 = arith.mulf %11, %12 : vector<4x4x1xbf16>
  %15 = vector.multi_reduction <add>, %14, %13 [2] : vector<4x4x1xbf16> to vector<4x4xbf16>
  %c0_21 = arith.constant 0 : index
  %16 = vector.transfer_write %15, %extracted_slice_13[%c0_21, %c0_21] : vector<4x4xbf16>, tensor<4x4xbf16>
  %17 = linalg.matmul ins(%extracted_slice, %extracted_slice_12 : tensor<4x1xbf16>, tensor<1x4xbf16>) outs(%extracted_slice_13 : tensor<4x4xbf16>) -> tensor<4x4xbf16>
  %inserted_slice = tensor.insert_slice %17 into %arg14[%arg9, %arg11] [4, 4] [1, 1] : tensor<4x4xbf16> into tensor<128x256xbf16>
  scf.yield %inserted_slice : tensor<128x256xbf16>
}