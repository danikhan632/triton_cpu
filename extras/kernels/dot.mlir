#map = affine_map<(d0) -> (d0)>
#map1 = affine_map<(d0, d1) -> (d0, 0)>
#map2 = affine_map<(d0, d1) -> (d0, d1)>
#map3 = affine_map<(d0, d1) -> (0, d1)>
module {
  func.func @kernel(%arg0: !tt.ptr<bf16, 1>, %arg1: !tt.ptr<bf16, 1>, %arg2: !tt.ptr<bf16, 1>, %arg3: i32, %arg4: i32, %arg5: i32, %arg6: i32, %arg7: i32, %arg8: i32) {
    %c256_i32 = arith.constant 256 : i32
    %0 = tensor.empty() : tensor<128xi32>
    %1 = linalg.fill ins(%c256_i32 : i32) outs(%0 : tensor<128xi32>) -> tensor<128xi32>
    %c256_i32_0 = arith.constant 256 : i32
    %2 = tensor.empty() : tensor<64xi32>
    %3 = linalg.fill ins(%c256_i32_0 : i32) outs(%2 : tensor<64xi32>) -> tensor<64xi32>
    %c128_i32 = arith.constant 128 : i32
    %4 = tensor.empty() : tensor<128xi32>
    %5 = linalg.fill ins(%c128_i32 : i32) outs(%4 : tensor<128xi32>) -> tensor<128xi32>
    %6 = tensor.empty() : tensor<128xi32>
    %7 = linalg.generic {indexing_maps = [#map], iterator_types = ["parallel"]} outs(%6 : tensor<128xi32>) {
    ^bb0(%out: i32):
      %49 = linalg.index 0 : index
      %50 = arith.index_cast %49 : index to i32
      linalg.yield %50 : i32
    } -> tensor<128xi32>
    %8 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel"]} ins(%7, %5 : tensor<128xi32>, tensor<128xi32>) outs(%7 : tensor<128xi32>) {
    ^bb0(%in: i32, %in_6: i32, %out: i32):
      %49 = arith.muli %in, %in_6 : i32
      linalg.yield %49 : i32
    } -> tensor<128xi32>
    %expanded = tensor.expand_shape %8 [[0, 1]] : tensor<128xi32> into tensor<128x1xi32>
    %9 = tensor.empty() : tensor<128x64xi32>
    %10 = linalg.generic {indexing_maps = [#map1, #map2], iterator_types = ["parallel", "parallel"]} ins(%expanded : tensor<128x1xi32>) outs(%9 : tensor<128x64xi32>) attrs =  {broadcastDims = array<i64: 1>} {
    ^bb0(%in: i32, %out: i32):
      linalg.yield %in : i32
    } -> tensor<128x64xi32>
    %11 = tensor.empty() : tensor<64xi32>
    %12 = linalg.generic {indexing_maps = [#map], iterator_types = ["parallel"]} outs(%11 : tensor<64xi32>) {
    ^bb0(%out: i32):
      %49 = linalg.index 0 : index
      %50 = arith.index_cast %49 : index to i32
      linalg.yield %50 : i32
    } -> tensor<64xi32>
    %expanded_1 = tensor.expand_shape %12 [[0, 1]] : tensor<64xi32> into tensor<1x64xi32>
    %13 = tensor.empty() : tensor<128x64xi32>
    %14 = linalg.generic {indexing_maps = [#map3, #map2], iterator_types = ["parallel", "parallel"]} ins(%expanded_1 : tensor<1x64xi32>) outs(%13 : tensor<128x64xi32>) attrs =  {broadcastDims = array<i64: 0>} {
    ^bb0(%in: i32, %out: i32):
      linalg.yield %in : i32
    } -> tensor<128x64xi32>
    %15 = linalg.generic {indexing_maps = [#map2, #map2, #map2], iterator_types = ["parallel", "parallel"]} ins(%10, %14 : tensor<128x64xi32>, tensor<128x64xi32>) outs(%10 : tensor<128x64xi32>) {
    ^bb0(%in: i32, %in_6: i32, %out: i32):
      %49 = arith.addi %in, %in_6 : i32
      linalg.yield %49 : i32
    } -> tensor<128x64xi32>
    %16 = tensor.empty() : tensor<256xi32>
    %17 = linalg.generic {indexing_maps = [#map], iterator_types = ["parallel"]} outs(%16 : tensor<256xi32>) {
    ^bb0(%out: i32):
      %49 = linalg.index 0 : index
      %50 = arith.index_cast %49 : index to i32
      linalg.yield %50 : i32
    } -> tensor<256xi32>
    %expanded_2 = tensor.expand_shape %17 [[0, 1]] : tensor<256xi32> into tensor<256x1xi32>
    %18 = tensor.empty() : tensor<256x64xi32>
    %19 = linalg.generic {indexing_maps = [#map1, #map2], iterator_types = ["parallel", "parallel"]} ins(%expanded_2 : tensor<256x1xi32>) outs(%18 : tensor<256x64xi32>) attrs =  {broadcastDims = array<i64: 1>} {
    ^bb0(%in: i32, %out: i32):
      linalg.yield %in : i32
    } -> tensor<256x64xi32>
    %20 = tensor.empty() : tensor<64xi32>
    %21 = linalg.generic {indexing_maps = [#map], iterator_types = ["parallel"]} outs(%20 : tensor<64xi32>) {
    ^bb0(%out: i32):
      %49 = linalg.index 0 : index
      %50 = arith.index_cast %49 : index to i32
      linalg.yield %50 : i32
    } -> tensor<64xi32>
    %22 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel"]} ins(%21, %3 : tensor<64xi32>, tensor<64xi32>) outs(%21 : tensor<64xi32>) {
    ^bb0(%in: i32, %in_6: i32, %out: i32):
      %49 = arith.muli %in, %in_6 : i32
      linalg.yield %49 : i32
    } -> tensor<64xi32>
    %expanded_3 = tensor.expand_shape %22 [[0, 1]] : tensor<64xi32> into tensor<1x64xi32>
    %23 = tensor.empty() : tensor<256x64xi32>
    %24 = linalg.generic {indexing_maps = [#map3, #map2], iterator_types = ["parallel", "parallel"]} ins(%expanded_3 : tensor<1x64xi32>) outs(%23 : tensor<256x64xi32>) attrs =  {broadcastDims = array<i64: 0>} {
    ^bb0(%in: i32, %out: i32):
      linalg.yield %in : i32
    } -> tensor<256x64xi32>
    %25 = linalg.generic {indexing_maps = [#map2, #map2, #map2], iterator_types = ["parallel", "parallel"]} ins(%19, %24 : tensor<256x64xi32>, tensor<256x64xi32>) outs(%19 : tensor<256x64xi32>) {
    ^bb0(%in: i32, %in_6: i32, %out: i32):
      %49 = arith.addi %in, %in_6 : i32
      linalg.yield %49 : i32
    } -> tensor<256x64xi32>
    %26 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel"]} ins(%7, %1 : tensor<128xi32>, tensor<128xi32>) outs(%7 : tensor<128xi32>) {
    ^bb0(%in: i32, %in_6: i32, %out: i32):
      %49 = arith.muli %in, %in_6 : i32
      linalg.yield %49 : i32
    } -> tensor<128xi32>
    %expanded_4 = tensor.expand_shape %26 [[0, 1]] : tensor<128xi32> into tensor<128x1xi32>
    %27 = tensor.empty() : tensor<128x256xi32>
    %28 = linalg.generic {indexing_maps = [#map1, #map2], iterator_types = ["parallel", "parallel"]} ins(%expanded_4 : tensor<128x1xi32>) outs(%27 : tensor<128x256xi32>) attrs =  {broadcastDims = array<i64: 1>} {
    ^bb0(%in: i32, %out: i32):
      linalg.yield %in : i32
    } -> tensor<128x256xi32>
    %expanded_5 = tensor.expand_shape %17 [[0, 1]] : tensor<256xi32> into tensor<1x256xi32>
    %29 = tensor.empty() : tensor<128x256xi32>
    %30 = linalg.generic {indexing_maps = [#map3, #map2], iterator_types = ["parallel", "parallel"]} ins(%expanded_5 : tensor<1x256xi32>) outs(%29 : tensor<128x256xi32>) attrs =  {broadcastDims = array<i64: 0>} {
    ^bb0(%in: i32, %out: i32):
      linalg.yield %in : i32
    } -> tensor<128x256xi32>
    %31 = linalg.generic {indexing_maps = [#map2, #map2, #map2], iterator_types = ["parallel", "parallel"]} ins(%28, %30 : tensor<128x256xi32>, tensor<128x256xi32>) outs(%28 : tensor<128x256xi32>) {
    ^bb0(%in: i32, %in_6: i32, %out: i32):
      %49 = arith.addi %in, %in_6 : i32
      linalg.yield %49 : i32
    } -> tensor<128x256xi32>
    %32 = tensor.empty() : tensor<128x64x!tt.ptr<bf16, 1>>
    %33 = linalg.fill ins(%arg0 : !tt.ptr<bf16, 1>) outs(%32 : tensor<128x64x!tt.ptr<bf16, 1>>) -> tensor<128x64x!tt.ptr<bf16, 1>>
    %34 = linalg.generic {indexing_maps = [#map2, #map2, #map2], iterator_types = ["parallel", "parallel"]} ins(%33, %15 : tensor<128x64x!tt.ptr<bf16, 1>>, tensor<128x64xi32>) outs(%33 : tensor<128x64x!tt.ptr<bf16, 1>>) {
    ^bb0(%in: !tt.ptr<bf16, 1>, %in_6: i32, %out: !tt.ptr<bf16, 1>):
      %49 = tt.addptr %in, %in_6 : !tt.ptr<bf16, 1>, i32
      linalg.yield %49 : !tt.ptr<bf16, 1>
    } -> tensor<128x64x!tt.ptr<bf16, 1>>
    %35 = tt.load %34 {cache = 1 : i32, evict = 1 : i32, isVolatile = false} : tensor<128x64xbf16>
    %36 = tensor.empty() : tensor<256x64x!tt.ptr<bf16, 1>>
    %37 = linalg.fill ins(%arg1 : !tt.ptr<bf16, 1>) outs(%36 : tensor<256x64x!tt.ptr<bf16, 1>>) -> tensor<256x64x!tt.ptr<bf16, 1>>
    %38 = linalg.generic {indexing_maps = [#map2, #map2, #map2], iterator_types = ["parallel", "parallel"]} ins(%37, %25 : tensor<256x64x!tt.ptr<bf16, 1>>, tensor<256x64xi32>) outs(%37 : tensor<256x64x!tt.ptr<bf16, 1>>) {
    ^bb0(%in: !tt.ptr<bf16, 1>, %in_6: i32, %out: !tt.ptr<bf16, 1>):
      %49 = tt.addptr %in, %in_6 : !tt.ptr<bf16, 1>, i32
      linalg.yield %49 : !tt.ptr<bf16, 1>
    } -> tensor<256x64x!tt.ptr<bf16, 1>>
    %39 = tt.load %38 {cache = 1 : i32, evict = 1 : i32, isVolatile = false} : tensor<256x64xbf16>
    %40 = tensor.empty() : tensor<64x256xbf16>
    %transposed = linalg.transpose ins(%39 : tensor<256x64xbf16>) outs(%40 : tensor<64x256xbf16>) permutation = [1, 0] 
    %41 = tensor.empty() : tensor<128x256x!tt.ptr<bf16, 1>>
    %42 = linalg.fill ins(%arg2 : !tt.ptr<bf16, 1>) outs(%41 : tensor<128x256x!tt.ptr<bf16, 1>>) -> tensor<128x256x!tt.ptr<bf16, 1>>
    %43 = linalg.generic {indexing_maps = [#map2, #map2, #map2], iterator_types = ["parallel", "parallel"]} ins(%42, %31 : tensor<128x256x!tt.ptr<bf16, 1>>, tensor<128x256xi32>) outs(%42 : tensor<128x256x!tt.ptr<bf16, 1>>) {
    ^bb0(%in: !tt.ptr<bf16, 1>, %in_6: i32, %out: !tt.ptr<bf16, 1>):
      %49 = tt.addptr %in, %in_6 : !tt.ptr<bf16, 1>, i32
      linalg.yield %49 : !tt.ptr<bf16, 1>
    } -> tensor<128x256x!tt.ptr<bf16, 1>>
    %44 = tt.load %43 {cache = 1 : i32, evict = 1 : i32, isVolatile = false} : tensor<128x256xbf16>
    %45 = tensor.empty() : tensor<128x256xbf16>
    %cst = arith.constant 0.000000e+00 : bf16
    %46 = linalg.fill ins(%cst : bf16) outs(%45 : tensor<128x256xbf16>) -> tensor<128x256xbf16>
    %47 = linalg.matmul ins(%35, %transposed : tensor<128x64xbf16>, tensor<64x256xbf16>) outs(%46 : tensor<128x256xbf16>) -> tensor<128x256xbf16>
    %48 = linalg.generic {indexing_maps = [#map2, #map2, #map2], iterator_types = ["parallel", "parallel"]} ins(%47, %44 : tensor<128x256xbf16>, tensor<128x256xbf16>) outs(%47 : tensor<128x256xbf16>) {
    ^bb0(%in: bf16, %in_6: bf16, %out: bf16):
      %49 = arith.addf %in, %in_6 : bf16
      linalg.yield %49 : bf16
    } -> tensor<128x256xbf16>
    tt.store %43, %48 {cache = 1 : i32, evict = 1 : i32} : tensor<128x256xbf16>
    return
  }
}