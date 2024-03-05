
#map = affine_map<(d0, d1) -> (d0, 0, d1)>
#map1 = affine_map<(d0, d1) -> (0, d1, d0)>
#map2 = affine_map<(d0, d1, d2) -> (d0, d1, d2)>
#map3 = affine_map<(d0, d1, d2) -> (d0, d1)>
#map4 = affine_map<(d0, d1) -> (d0, d1)>
module {
  func.func @kernel(%arg0: memref<*xbf16>, %arg1: memref<*xbf16>, %arg2: memref<*xbf16>, %arg3: i32, %arg4: i32, %arg5: i32, %arg6: i32, %arg7: i32, %arg8: i32) {
    %c1 = arith.constant 1 : index
    %c64 = arith.constant 64 : index
    %c4 = arith.constant 4 : index
    %c0 = arith.constant 0 : index
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
    memref.copy %reinterpret_cast_2, %alloc_3 : memref<128x256xbf16, strided<[?, 1]>> to memref<128x256xbf16>
    %3 = bufferization.to_tensor %alloc_3 restrict writable : memref<128x256xbf16>
    %4 = tensor.empty() : tensor<128x256xbf16>
    %5 = linalg.fill ins(%cst : bf16) outs(%4 : tensor<128x256xbf16>) -> tensor<128x256xbf16>
    %6 = scf.for %arg9 = %c0 to %c128 step %c4 iter_args(%arg10 = %5) -> (tensor<128x256xbf16>) {
      %8 = scf.for %arg11 = %c0 to %c256 step %c4 iter_args(%arg12 = %arg10) -> (tensor<128x256xbf16>) {
        %9 = scf.for %arg13 = %c0 to %c64 step %c1 iter_args(%arg14 = %arg12) -> (tensor<128x256xbf16>) {
          %extracted_slice = tensor.extract_slice %0[%arg9, %arg13] [4, 1] [1, 1] : tensor<128x64xbf16> to tensor<4x1xbf16>
          %extracted_slice_4 = tensor.extract_slice %transposed[%arg13, %arg11] [1, 4] [1, 1] : tensor<64x256xbf16> to tensor<1x4xbf16>
          %extracted_slice_5 = tensor.extract_slice %arg14[%arg9, %arg11] [4, 4] [1, 1] : tensor<128x256xbf16> to tensor<4x4xbf16>
          %10 = vector.transfer_read %extracted_slice[%c0, %c0], %cst {in_bounds = [true, true, true], permutation_map = #map} : tensor<4x1xbf16>, vector<4x4x1xbf16>
          %11 = vector.transfer_read %extracted_slice_4[%c0, %c0], %cst {in_bounds = [true, true, true], permutation_map = #map1} : tensor<1x4xbf16>, vector<4x4x1xbf16>
          %12 = vector.transfer_read %extracted_slice_5[%c0, %c0], %cst {in_bounds = [true, true]} : tensor<4x4xbf16>, vector<4x4xbf16>
          %13 = vector.contract {indexing_maps = [#map2, #map2, #map3], iterator_types = ["parallel", "parallel", "reduction"], kind = #vector.kind<add>} %10, %11, %12 : vector<4x4x1xbf16>, vector<4x4x1xbf16> into vector<4x4xbf16>
          %14 = vector.transfer_write %13, %extracted_slice_5[%c0, %c0] {in_bounds = [true, true]} : vector<4x4xbf16>, tensor<4x4xbf16>
          %inserted_slice = tensor.insert_slice %14 into %arg14[%arg9, %arg11] [4, 4] [1, 1] : tensor<4x4xbf16> into tensor<128x256xbf16>
          scf.yield %inserted_slice : tensor<128x256xbf16>
        }
        scf.yield %9 : tensor<128x256xbf16>
      }
      scf.yield %8 : tensor<128x256xbf16>
    }
    %7 = linalg.generic {indexing_maps = [#map4, #map4, #map4], iterator_types = ["parallel", "parallel"]} ins(%6, %3 : tensor<128x256xbf16>, tensor<128x256xbf16>) outs(%6 : tensor<128x256xbf16>) {
    ^bb0(%in: bf16, %in_4: bf16, %out: bf16):
      %8 = arith.addf %in, %in_4 : bf16
      linalg.yield %8 : bf16
    } -> tensor<128x256xbf16>
    bufferization.materialize_in_destination %7 in writable %reinterpret_cast_2 : (tensor<128x256xbf16>, memref<128x256xbf16, strided<[?, 1]>>) -> ()
    return
  }
}