#map = affine_map<(d0, d1) -> (-d0 + 32, d1)>
#map1 = affine_map<(d0, d1) -> (-d0 + 64, d1)>
#map2 = affine_map<(d0, d1) -> (d0, 0, d1)>
#map3 = affine_map<(d0, d1) -> (0, d1, d0)>
#map4 = affine_map<(d0, d1, d2) -> (d0, d1, d2)>
#map5 = affine_map<(d0, d1, d2) -> (d0, d1)>
#map6 = affine_map<(d0, d1) -> (d0, d1)>
module {
  func.func @matmul_kernel_0d1d2d34567c89c1011c(%arg0: memref<*xf16> {tt.divisibility = 16 : i32}, %arg1: memref<*xf16> {tt.divisibility = 16 : i32}, %arg2: memref<*xf16> {tt.divisibility = 16 : i32}, %arg3: i32, %arg4: i32, %arg5: i32, %arg6: i32, %arg7: i32, %arg8: i32, %arg9: i32, %arg10: i32, %arg11: i32, %arg12: i32, %arg13: i32, %arg14: i32) {
    %cst = arith.constant dense<false> : vector<1x[4]xi1>
    %c4 = arith.constant 4 : index
    %c8_i32 = arith.constant 8 : i32
    %c32_i32 = arith.constant 32 : i32
    %c64_i32 = arith.constant 64 : i32
    %c16_i32 = arith.constant 16 : i32
    %cst_0 = arith.constant 0.000000e+00 : f32
    %c0_i32 = arith.constant 0 : i32
    %c1_i32 = arith.constant 1 : i32
    %c31_i32 = arith.constant 31 : i32
    %c63_i32 = arith.constant 63 : i32
    %c15_i32 = arith.constant 15 : i32
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %c16 = arith.constant 16 : index
    %cst_1 = arith.constant 0.000000e+00 : f16
    %c32 = arith.constant 32 : index
    %c64 = arith.constant 64 : index
    %alloc = memref.alloc() {alignment = 64 : i64} : memref<32x64xf32>
    linalg.fill ins(%cst_0 : f32) outs(%alloc : memref<32x64xf32>)
    %0 = bufferization.to_tensor %alloc : memref<32x64xf32>
    %1 = arith.addi %arg3, %c31_i32 : i32
    %2 = arith.divsi %1, %c32_i32 : i32
    %3 = arith.addi %arg4, %c63_i32 : i32
    %4 = arith.divsi %3, %c64_i32 : i32
    %5 = arith.muli %4, %c8_i32 : i32
    %6 = arith.divsi %arg12, %5 : i32
    %7 = arith.muli %6, %c8_i32 : i32
    %8 = arith.subi %2, %7 : i32
    %9 = arith.minsi %8, %c8_i32 : i32
    %10 = arith.remsi %arg12, %9 : i32
    %11 = arith.addi %7, %10 : i32
    %12 = arith.remsi %arg12, %5 : i32
    %13 = arith.divsi %12, %9 : i32
    %14 = arith.muli %11, %c32_i32 : i32
    %15 = arith.index_cast %14 : i32 to index
    %16 = arith.muli %13, %c64_i32 : i32
    %17 = arith.index_cast %16 : i32 to index
    %18 = arith.index_cast %arg3 : i32 to index
    %19 = arith.index_cast %arg6 : i32 to index
    %20 = arith.muli %15, %19 : index
    %21 = arith.muli %18, %19 : index
    %22 = arith.index_cast %arg7 : i32 to index
    %23 = arith.index_cast %arg4 : i32 to index
    %24 = arith.addi %arg5, %c15_i32 : i32
    %25 = arith.divsi %24, %c16_i32 : i32
    %26 = arith.muli %arg7, %c16_i32 : i32
    %27 = arith.index_cast %26 : i32 to index
    %28:3 = scf.for %arg15 = %c0_i32 to %25 step %c1_i32 iter_args(%arg16 = %0, %arg17 = %20, %arg18 = %c0) -> (tensor<32x64xf32>, index, index)  : i32 {
      %41 = bufferization.to_memref %arg16 : memref<32x64xf32>
      %42 = arith.addi %arg18, %17 : index
      %43 = arith.remsi %42, %23 : index
      %44 = arith.subi %42, %43 : index
      %45 = arith.addi %43, %c64 : index
      %46 = arith.minsi %45, %23 : index
      %47 = arith.subi %46, %43 : index
      %reinterpret_cast_4 = memref.reinterpret_cast %arg1 to offset: [%42], sizes: [%c16, %47], strides: [%22, %c1] : memref<*xf16> to memref<16x?xf16, strided<[?, ?], offset: ?>>
      %48 = arith.subi %c64, %47 : index
      %reinterpret_cast_5 = memref.reinterpret_cast %arg1 to offset: [%44], sizes: [%c16, %48], strides: [%22, %c1] : memref<*xf16> to memref<16x?xf16, strided<[?, ?], offset: ?>>
      %49 = arith.remsi %arg17, %19 : index
      %50 = arith.addi %21, %49 : index
      %51 = arith.subi %50, %arg17 : index
      %52 = arith.divsi %51, %19 : index
      %reinterpret_cast_6 = memref.reinterpret_cast %arg0 to offset: [%arg17], sizes: [%52, %c16], strides: [%19, %c1] : memref<*xf16> to memref<?x16xf16, strided<[?, ?], offset: ?>>
      %53 = arith.subi %c32, %52 : index
      %reinterpret_cast_7 = memref.reinterpret_cast %arg0 to offset: [%49], sizes: [%53, %c16], strides: [%19, %c1] : memref<*xf16> to memref<?x16xf16, strided<[?, ?], offset: ?>>
      %54 = arith.muli %arg15, %c16_i32 : i32
      %55 = arith.subi %arg5, %54 : i32
      %56 = arith.index_cast %55 : i32 to index
      %57 = arith.minsi %56, %c16 : index
      %alloc_8 = memref.alloc() : memref<32x16xf16>
      %58 = arith.cmpi slt, %57, %c16 : index
      scf.if %58 {
        linalg.fill ins(%cst_1 : f16) outs(%alloc_8 : memref<32x16xf16>)
      }
      %59 = arith.minsi %52, %c32 : index
      %60 = arith.subi %c32, %59 : index
      %subview_9 = memref.subview %reinterpret_cast_6[0, 0] [%59, %57] [1, 1] : memref<?x16xf16, strided<[?, ?], offset: ?>> to memref<?x?xf16, strided<[?, ?], offset: ?>>
      %subview_10 = memref.subview %reinterpret_cast_7[0, 0] [%60, %57] [1, 1] : memref<?x16xf16, strided<[?, ?], offset: ?>> to memref<?x?xf16, strided<[?, ?], offset: ?>>
      %subview_11 = memref.subview %alloc_8[0, 0] [%59, %57] [1, 1] : memref<32x16xf16> to memref<?x?xf16, strided<[16, 1]>>
      %subview_12 = memref.subview %alloc_8[%59, 0] [%60, %57] [1, 1] : memref<32x16xf16> to memref<?x?xf16, strided<[16, 1], offset: ?>>
      memref.copy %subview_9, %subview_11 : memref<?x?xf16, strided<[?, ?], offset: ?>> to memref<?x?xf16, strided<[16, 1]>>
      memref.copy %subview_10, %subview_12 : memref<?x?xf16, strided<[?, ?], offset: ?>> to memref<?x?xf16, strided<[16, 1], offset: ?>>
      %alloc_13 = memref.alloc() : memref<16x64xf16>
      %61 = arith.cmpi slt, %57, %c16 : index
      scf.if %61 {
        linalg.fill ins(%cst_1 : f16) outs(%alloc_13 : memref<16x64xf16>)
      }
      %62 = arith.minsi %47, %c64 : index
      %63 = arith.subi %c64, %62 : index
      %subview_14 = memref.subview %reinterpret_cast_4[0, 0] [%57, %62] [1, 1] : memref<16x?xf16, strided<[?, ?], offset: ?>> to memref<?x?xf16, strided<[?, ?], offset: ?>>
      %subview_15 = memref.subview %reinterpret_cast_5[0, 0] [%57, %63] [1, 1] : memref<16x?xf16, strided<[?, ?], offset: ?>> to memref<?x?xf16, strided<[?, ?], offset: ?>>
      %subview_16 = memref.subview %alloc_13[0, 0] [%57, %62] [1, 1] : memref<16x64xf16> to memref<?x?xf16, strided<[64, 1]>>
      %subview_17 = memref.subview %alloc_13[0, %62] [%57, %63] [1, 1] : memref<16x64xf16> to memref<?x?xf16, strided<[64, 1], offset: ?>>
      memref.copy %subview_14, %subview_16 : memref<?x?xf16, strided<[?, ?], offset: ?>> to memref<?x?xf16, strided<[64, 1]>>
      memref.copy %subview_15, %subview_17 : memref<?x?xf16, strided<[?, ?], offset: ?>> to memref<?x?xf16, strided<[64, 1], offset: ?>>
      %64 = vector.vscale
      %65 = arith.muli %64, %c4 : index
      %66 = arith.muli %64, %c4 : index
      %67 = scf.for %arg19 = %c0 to %c32 step %65 iter_args(%arg20 = %0) -> (tensor<32x64xf32>) {
        %72 = scf.for %arg21 = %c0 to %c64 step %66 iter_args(%arg22 = %arg20) -> (tensor<32x64xf32>) {
          %73 = scf.for %arg23 = %c0 to %c16 step %c1 iter_args(%arg24 = %arg22) -> (tensor<32x64xf32>) {
            %74 = bufferization.to_memref %arg24 : memref<32x64xf32>
            %75 = bufferization.to_memref %arg24 : memref<32x64xf32>
            %76 = affine.min #map(%arg19, %65)
            %77 = affine.min #map1(%arg21, %66)
            %78 = affine.min #map(%arg19, %65)
            %79 = affine.min #map1(%arg21, %66)
            %subview_19 = memref.subview %alloc_8[%arg19, %arg23] [%76, 1] [1, 1] : memref<32x16xf16> to memref<?x1xf16, strided<[16, 1], offset: ?>>
            %80 = bufferization.to_tensor %subview_19 : memref<?x1xf16, strided<[16, 1], offset: ?>>
            %subview_20 = memref.subview %alloc_13[%arg23, %arg21] [1, %77] [1, 1] : memref<16x64xf16> to memref<1x?xf16, strided<[64, 1], offset: ?>>
            %81 = bufferization.to_tensor %subview_20 : memref<1x?xf16, strided<[64, 1], offset: ?>>
            %subview_21 = memref.subview %75[%arg19, %arg21] [%78, %79] [1, 1] : memref<32x64xf32> to memref<?x?xf32, strided<[64, 1], offset: ?>>
            %82 = bufferization.to_tensor %subview_21 : memref<?x?xf32, strided<[64, 1], offset: ?>>
            %83 = vector.create_mask %76, %c1 : vector<[4]x1xi1>
            %84 = vector.transfer_read %80[%c0, %c0], %cst_1, %83 {in_bounds = [true, true, true], permutation_map = #map2} : tensor<?x1xf16>, vector<[4]x[4]x1xf16>
            %85 = vector.create_mask %77 : vector<[4]xi1>
            %86 = vector.insert %85, %cst [0] : vector<[4]xi1> into vector<1x[4]xi1>
            %87 = vector.transfer_read %81[%c0, %c0], %cst_1, %86 {in_bounds = [true, true, true], permutation_map = #map3} : tensor<1x?xf16>, vector<[4]x[4]x1xf16>
            %88 = vector.create_mask %76, %77 : vector<[4]x[4]xi1>
            %89 = vector.transfer_read %82[%c0, %c0], %cst_0, %88 {in_bounds = [true, true]} : tensor<?x?xf32>, vector<[4]x[4]xf32>
            %90 = arith.extf %84 : vector<[4]x[4]x1xf16> to vector<[4]x[4]x1xf32>
            %91 = arith.extf %87 : vector<[4]x[4]x1xf16> to vector<[4]x[4]x1xf32>
            %92 = vector.create_mask %76, %77, %c1 : vector<[4]x[4]x1xi1>
            %93 = vector.mask %92 { vector.contract {indexing_maps = [#map4, #map4, #map5], iterator_types = ["parallel", "parallel", "reduction"], kind = #vector.kind<add>} %90, %91, %89 : vector<[4]x[4]x1xf32>, vector<[4]x[4]x1xf32> into vector<[4]x[4]xf32> } : vector<[4]x[4]x1xi1> -> vector<[4]x[4]xf32>
            %94 = vector.transfer_write %93, %82[%c0, %c0], %88 {in_bounds = [true, true]} : vector<[4]x[4]xf32>, tensor<?x?xf32>
            %95 = bufferization.to_memref %94 : memref<?x?xf32>
            %alloc_22 = memref.alloc() {alignment = 64 : i64} : memref<32x64xf32>
            memref.copy %74, %alloc_22 : memref<32x64xf32> to memref<32x64xf32>
            %subview_23 = memref.subview %alloc_22[%arg19, %arg21] [%78, %79] [1, 1] : memref<32x64xf32> to memref<?x?xf32, strided<[64, 1], offset: ?>>
            memref.copy %95, %subview_23 : memref<?x?xf32> to memref<?x?xf32, strided<[64, 1], offset: ?>>
            %96 = bufferization.to_tensor %alloc_22 : memref<32x64xf32>
            scf.yield %96 : tensor<32x64xf32>
          }
          scf.yield %73 : tensor<32x64xf32>
        }
        scf.yield %72 : tensor<32x64xf32>
      }
      %68 = bufferization.to_memref %67 : memref<32x64xf32>
      %alloc_18 = memref.alloc() {alignment = 64 : i64} : memref<32x64xf32>
      linalg.generic {indexing_maps = [#map6, #map6, #map6], iterator_types = ["parallel", "parallel"]} ins(%68, %41 : memref<32x64xf32>, memref<32x64xf32>) outs(%alloc_18 : memref<32x64xf32>) {
      ^bb0(%in: f32, %in_19: f32, %out: f32):
        %72 = arith.addf %in, %in_19 : f32
        linalg.yield %72 : f32
      }
      %69 = bufferization.to_tensor %alloc_18 : memref<32x64xf32>
      %70 = arith.addi %arg17, %c16 : index
      %71 = arith.addi %arg18, %27 : index
      scf.yield %69, %70, %71 : tensor<32x64xf32>, index, index
    }
    %29 = bufferization.to_memref %28#0 : memref<32x64xf32>
    %30 = arith.index_cast %arg8 : i32 to index
    %31 = arith.muli %15, %30 : index
    %32 = arith.addi %31, %17 : index
    %reinterpret_cast = memref.reinterpret_cast %arg2 to offset: [%32], sizes: [32, 64], strides: [%30, 1] : memref<*xf16> to memref<32x64xf16, strided<[?, 1], offset: ?>>
    %alloc_2 = memref.alloc() {alignment = 64 : i64} : memref<32x64xf16>
    linalg.generic {indexing_maps = [#map6, #map6], iterator_types = ["parallel", "parallel"]} ins(%29 : memref<32x64xf32>) outs(%alloc_2 : memref<32x64xf16>) {
    ^bb0(%in: f32, %out: f16):
      %41 = arith.truncf %in : f32 to f16
      linalg.yield %41 : f16
    }
    %33 = arith.addi %15, %c32 : index
    %34 = arith.minsi %33, %18 : index
    %35 = arith.subi %34, %15 : index
    %36 = arith.addi %17, %c64 : index
    %37 = arith.minsi %36, %23 : index
    %38 = arith.subi %37, %17 : index
    %39 = arith.minsi %35, %c32 : index
    %40 = arith.minsi %38, %c64 : index
    %subview = memref.subview %alloc_2[0, 0] [%39, %40] [1, 1] : memref<32x64xf16> to memref<?x?xf16, strided<[64, 1]>>
    %subview_3 = memref.subview %reinterpret_cast[0, 0] [%39, %40] [1, 1] : memref<32x64xf16, strided<[?, 1], offset: ?>> to memref<?x?xf16, strided<[?, 1], offset: ?>>
    memref.copy %subview, %subview_3 : memref<?x?xf16, strided<[64, 1]>> to memref<?x?xf16, strided<[?, 1], offset: ?>>
    return
  }
}
