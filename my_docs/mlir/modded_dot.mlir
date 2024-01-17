#map = affine_map<(d0, d1) -> (d0, d1)>
module {
  func.func @kernel(%arg0: memref<*xbf16>, %arg1: memref<*xbf16>, %arg2: memref<*xbf16>, %arg3: i32, %arg4: i32, %arg5: i32, %arg6: i32, %arg7: i32, %arg8: i32) {
    %cst = arith.constant 0.000000e+00 : bf16
    %c256 = arith.constant 256 : index
    %c128 = arith.constant 128 : index
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [0], sizes: [128, 64], strides: [%c128, 1] : memref<*xbf16> to memref<128x64xbf16, strided<[?, 1]>>
    %alloc = memref.alloc() : memref<128x64xbf16>
    memref.copy %reinterpret_cast, %alloc : memref<128x64xbf16, strided<[?, 1]>> to memref<128x64xbf16>
    %0 = bufferization.to_tensor %alloc restrict writable : memref<128x64xbf16>
    %reinterpret_cast_0 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [256, 64], strides: [1, %c256] : memref<*xbf16> to memref<256x64xbf16, strided<[1, ?]>>
    %alloc_1 = memref.alloc() : memref<256x64xbf16>
    memref.copy %reinterpret_cast_0, %alloc_1 : memref<256x64xbf16, strided<[1, ?]>> to memref<256x64xbf16>
    %1 = bufferization.to_tensor %alloc_1 restrict writable : memref<256x64xbf16>
    %2 = tensor.empty() : tensor<64x256xbf16>
    %transposed = linalg.transpose ins(%1 : tensor<256x64xbf16>) outs(%2 : tensor<64x256xbf16>) permutation = [1, 0] 
    %reinterpret_cast_2 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [128, 256], strides: [%c256, 1] : memref<*xbf16> to memref<128x256xbf16, strided<[?, 1]>>
    %alloc_3 = memref.alloc() : memref<128x256xbf16>
 

    return
  }
}
