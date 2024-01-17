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
#map = affine_map<(d0, d1) -> (d0, d1)>
module {
  func.func @kernel(%arg0: memref<*xf32>, %arg1: memref<*xf32>, %arg2: memref<*xf32>, %arg3: i32, %arg4: i32, %arg5: i32, %arg6: i32, %arg7: i32, %arg8: i32) {
    %cst = arith.constant 0.000000e+00 : f32
    %c256 = arith.constant 256 : index
    %c128 = arith.constant 128 : index
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [0], sizes: [128, 64], strides: [%c128, 1] : memref<*xf32> to memref<128x64xf32, strided<[?, 1]>>
    %alloc = memref.alloc() : memref<128x64xf32>
    memref.copy %reinterpret_cast, %alloc : memref<128x64xf32, strided<[?, 1]>> to memref<128x64xf32>
    %0 = bufferization.to_tensor %alloc restrict writable : memref<128x64xf32>
    %reinterpret_cast_0 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [256, 64], strides: [1, %c256] : memref<*xf32> to memref<256x64xf32, strided<[1, ?]>>
    %alloc_1 = memref.alloc() : memref<256x64xf32>
    memref.copy %reinterpret_cast_0, %alloc_1 : memref<256x64xf32, strided<[1, ?]>> to memref<256x64xf32>
    %1 = bufferization.to_tensor %alloc_1 restrict writable : memref<256x64xf32>
    %2 = tensor.empty() : tensor<64x256xf32>
    %transposed = linalg.transpose ins(%1 : tensor<256x64xf32>) outs(%2 : tensor<64x256xf32>) permutation = [1, 0] 
    %reinterpret_cast_2 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [128, 256], strides: [%c256, 1] : memref<*xf32> to memref<128x256xf32, strided<[?, 1]>>
    %alloc_3 = memref.alloc() : memref<128x256xf32>
    memref.copy %reinterpret_cast_2, %alloc_3 : memref<128x256xf32, strided<[?, 1]>> to memref<128x256xf32>
    %3 = bufferization.to_tensor %alloc_3 restrict writable : memref<128x256xf32>
    %4 = tensor.empty() : tensor<128x256xf32>
    %5 = linalg.fill ins(%cst : f32) outs(%4 : tensor<128x256xf32>) -> tensor<128x256xf32>
    call @matmul(%0, %transposed, %5) : (tensor<128x64xf32>, tensor<64x256xf32>, tensor<128x256xf32>) -> ()
    %6 = %5 : tensor<128x256xf32>
    %7 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%6, %3 : tensor<128x256xf32>, tensor<128x256xf32>) outs(%6 : tensor<128x256xf32>) {
    ^bb0(%in: f32, %in_4: f32, %out: f32):
      %8 = arith.addf %in, %in_4 : f32
      linalg.yield %8 : f32
    } -> tensor<128x256xf32>
    memref.tensor_store %7, %reinterpret_cast_2 : memref<128x256xf32, strided<[?, 1]>>
    return
  }
}
