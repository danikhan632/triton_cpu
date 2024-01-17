func.func @matmul(%arg0: memref<128x64xf32>, %arg1: memref<64x256xf32>, %arg2: memref<128x256xf32>) {
  affine.for %i = 0 to 128 {
    
    affine.for %j = 0 to 256 {
      // Initialize the result matrix element to zero
      %sum_init = arith.constant 0.0 : f32
      affine.store %sum_init, %arg2[%i, %j] : memref<128x256xf32>

      affine.for %k = 0 to 64 {
        %a = affine.load %arg0[%i, %k] : memref<128x64xf32>
        %b = affine.load %arg1[%k, %j] : memref<64x256xf32>
        %product = arith.mulf %a, %b : f32

        %sum = affine.load %arg2[%i, %j] : memref<128x256xf32>
        %sum_updated = arith.addf %sum, %product : f32
        affine.store %sum_updated, %arg2[%i, %j] : memref<128x256xf32>
      }
    }
  }
  return
}
