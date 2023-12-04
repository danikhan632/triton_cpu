// The following matmul maps very nicely onto SME with SVL=128bits. For f32, there are 4 4x4 tiles,
// that can be assembled as a 8x8 matrix.

// %mat_A_tr - transpose of A
func.func @matmul(%mat_A_tr: memref<6x8xf32>, %mat_B: memref<6x8xf32>, %mat_C: memref<8x8xf32>) {
  linalg.matmul ins(%mat_A_tr, %mat_B: memref<6x8xf32>, memref<6x8xf32>)
            outs(%mat_C: memref<8x8xf32>)
  return
}