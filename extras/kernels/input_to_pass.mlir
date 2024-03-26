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
    %cst_0 = arith.constant 0.000000e+00 : f16
    %c0 = arith.constant 0 : index
    %c64 = arith.constant 64 : index
    %c1 = arith.constant 1 : index
    %c16 = arith.constant 16 : index
    %c32 = arith.constant 32 : index
    %c8_i32 = arith.constant 8 : i32
    %c32_i32 = arith.constant 32 : i32
    %c64_i32 = arith.constant 64 : i32
    %c16_i32 = arith.constant 16 : i32
    %c15_i32 = arith.constant 15 : i32
    %c63_i32 = arith.constant 63 : i32
    %c31_i32 = arith.constant 31 : i32
    %c1_i32 = arith.constant 1 : i32
    %c0_i32 = arith.constant 0 : i32
    %cst_1 = arith.constant 0.000000e+00 : f32
    %alloc = memref.alloc() {alignment = 64 : i64} : memref<32x64xf32>
    %0 = bufferization.to_tensor %alloc : memref<32x64xf32>
    %1 = linalg.fill ins(%cst_1 : f32) outs(%0 : tensor<32x64xf32>) -> tensor<32x64xf32>
    %2 = arith.addi %arg3, %c31_i32 : i32
    %3 = arith.divsi %2, %c32_i32 : i32
    %4 = arith.addi %arg4, %c63_i32 : i32
    %5 = arith.divsi %4, %c64_i32 : i32
    %6 = arith.muli %5, %c8_i32 : i32
    %7 = arith.divsi %arg12, %6 : i32
    %8 = arith.muli %7, %c8_i32 : i32
    %9 = arith.subi %3, %8 : i32
    %10 = arith.minsi %9, %c8_i32 : i32
    %11 = arith.remsi %arg12, %10 : i32
    %12 = arith.addi %8, %11 : i32
    %13 = arith.remsi %arg12, %6 : i32
    %14 = arith.divsi %13, %10 : i32
    %15 = arith.muli %12, %c32_i32 : i32
    %16 = arith.muli %14, %c64_i32 : i32
    %17 = arith.index_cast %arg3 : i32 to index
    %18 = arith.index_cast %15 : i32 to index
    %19 = arith.index_cast %arg6 : i32 to index
    %20 = arith.muli %18, %19 : index
    %21 = arith.remsi %20, %19 : index
    %22 = arith.muli %17, %19 : index
    %23 = arith.addi %22, %21 : index
    %24 = arith.subi %23, %20 : index
    %25 = arith.divsi %24, %19 : index
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [%20], sizes: [%25, %c16], strides: [%19, %c1] : memref<*xf16> to memref<?x16xf16, strided<[?, ?], offset: ?>>
    %26 = arith.subi %c32, %25 : index
    %reinterpret_cast_2 = memref.reinterpret_cast %arg0 to offset: [%21], sizes: [%26, %c16], strides: [%19, %c1] : memref<*xf16> to memref<?x16xf16, strided<[?, ?], offset: ?>>
    %27 = arith.index_cast %arg7 : i32 to index
    %28 = arith.index_cast %arg4 : i32 to index
    %29 = arith.index_cast %16 : i32 to index
    %30 = arith.remsi %29, %28 : index
    %31 = arith.subi %29, %30 : index
    %32 = arith.addi %30, %c64 : index
    %33 = arith.minsi %32, %28 : index
    %34 = arith.subi %33, %30 : index
    %reinterpret_cast_3 = memref.reinterpret_cast %arg1 to offset: [%29], sizes: [%c16, %34], strides: [%27, %c1] : memref<*xf16> to memref<16x?xf16, strided<[?, ?], offset: ?>>
    %35 = arith.subi %c64, %34 : index
    %reinterpret_cast_4 = memref.reinterpret_cast %arg1 to offset: [%31], sizes: [%c16, %35], strides: [%27, %c1] : memref<*xf16> to memref<16x?xf16, strided<[?, ?], offset: ?>>
    %36 = arith.addi %arg5, %c15_i32 : i32
    %37 = arith.divsi %36, %c16_i32 : i32
    %38 = arith.muli %arg7, %c16_i32 : i32
    %39 = arith.index_cast %arg3 : i32 to index
    %40 = arith.index_cast %15 : i32 to index
    %41 = arith.index_cast %arg6 : i32 to index
    %42 = arith.muli %40, %41 : index
    %43 = arith.index_cast %arg7 : i32 to index
    %44 = arith.index_cast %arg4 : i32 to index
    %45 = arith.index_cast %16 : i32 to index
    %46:7 = scf.for %arg15 = %c0_i32 to %37 step %c1_i32 iter_args(%arg16 = %1, %arg17 = %reinterpret_cast, %arg18 = %reinterpret_cast_3, %arg19 = %42, %arg20 = %c0, %arg21 = %reinterpret_cast_2, %arg22 = %reinterpret_cast_4) -> (tensor<32x64xf32>, memref<?x16xf16, strided<[?, ?], offset: ?>>, memref<16x?xf16, strided<[?, ?], offset: ?>>, index, index, memref<?x16xf16, strided<[?, ?], offset: ?>>, memref<16x?xf16, strided<[?, ?], offset: ?>>)  : i32 {
      %67 = arith.muli %arg15, %c16_i32 : i32
      %68 = arith.subi %arg5, %67 : i32
      %alloc_8 = memref.alloc() : memref<32x16xf16>
      %69 = arith.index_cast %68 : i32 to index
      %70 = arith.minsi %69, %c16 : index
      %71 = arith.cmpi slt, %70, %c16 : index
      scf.if %71 {
        linalg.fill ins(%cst_0 : f16) outs(%alloc_8 : memref<32x16xf16>)
      }
      %dim = memref.dim %arg17, %c0 : memref<?x16xf16, strided<[?, ?], offset: ?>>
      %72 = arith.minsi %dim, %c32 : index
      %73 = arith.subi %c32, %72 : index
      %subview_9 = memref.subview %arg17[0, 0] [%72, %70] [1, 1] : memref<?x16xf16, strided<[?, ?], offset: ?>> to memref<?x?xf16, strided<[?, ?], offset: ?>>
      %subview_10 = memref.subview %arg21[0, 0] [%73, %70] [1, 1] : memref<?x16xf16, strided<[?, ?], offset: ?>> to memref<?x?xf16, strided<[?, ?], offset: ?>>
      %subview_11 = memref.subview %alloc_8[0, 0] [%72, %70] [1, 1] : memref<32x16xf16> to memref<?x?xf16, strided<[16, 1]>>
      %subview_12 = memref.subview %alloc_8[%72, 0] [%73, %70] [1, 1] : memref<32x16xf16> to memref<?x?xf16, strided<[16, 1], offset: ?>>
      memref.copy %subview_9, %subview_11 : memref<?x?xf16, strided<[?, ?], offset: ?>> to memref<?x?xf16, strided<[16, 1]>>
      memref.copy %subview_10, %subview_12 : memref<?x?xf16, strided<[?, ?], offset: ?>> to memref<?x?xf16, strided<[16, 1], offset: ?>>
      %alloc_13 = memref.alloc() : memref<16x64xf16>
      %74 = arith.index_cast %68 : i32 to index
      %75 = arith.minsi %74, %c16 : index
      %76 = arith.cmpi slt, %75, %c16 : index
      scf.if %76 {
        linalg.fill ins(%cst_0 : f16) outs(%alloc_13 : memref<16x64xf16>)
      }
      %dim_14 = memref.dim %arg18, %c1 : memref<16x?xf16, strided<[?, ?], offset: ?>>
      %77 = arith.minsi %dim_14, %c64 : index
      %78 = arith.subi %c64, %77 : index
      %subview_15 = memref.subview %arg18[0, 0] [%75, %77] [1, 1] : memref<16x?xf16, strided<[?, ?], offset: ?>> to memref<?x?xf16, strided<[?, ?], offset: ?>>
      %subview_16 = memref.subview %arg22[0, 0] [%75, %78] [1, 1] : memref<16x?xf16, strided<[?, ?], offset: ?>> to memref<?x?xf16, strided<[?, ?], offset: ?>>
      %subview_17 = memref.subview %alloc_13[0, 0] [%75, %77] [1, 1] : memref<16x64xf16> to memref<?x?xf16, strided<[64, 1]>>
      %subview_18 = memref.subview %alloc_13[0, %77] [%75, %78] [1, 1] : memref<16x64xf16> to memref<?x?xf16, strided<[64, 1], offset: ?>>
      memref.copy %subview_15, %subview_17 : memref<?x?xf16, strided<[?, ?], offset: ?>> to memref<?x?xf16, strided<[64, 1]>>
      memref.copy %subview_16, %subview_18 : memref<?x?xf16, strided<[?, ?], offset: ?>> to memref<?x?xf16, strided<[64, 1], offset: ?>>
      %alloc_19 = memref.alloc() {alignment = 64 : i64} : memref<32x64xf32>
      %79 = bufferization.to_tensor %alloc_19 : memref<32x64xf32>
      %80 = linalg.fill ins(%cst_1 : f32) outs(%79 : tensor<32x64xf32>) -> tensor<32x64xf32>
      %81 = vector.vscale
      %82 = arith.muli %81, %c4 : index
      %83 = arith.muli %81, %c4 : index
      %84 = scf.for %arg23 = %c0 to %c32 step %82 iter_args(%arg24 = %80) -> (tensor<32x64xf32>) {
        %102 = scf.for %arg25 = %c0 to %c64 step %83 iter_args(%arg26 = %arg24) -> (tensor<32x64xf32>) {
          %103 = scf.for %arg27 = %c0 to %c16 step %c1 iter_args(%arg28 = %arg26) -> (tensor<32x64xf32>) {
            %104 = bufferization.to_memref %arg28 : memref<32x64xf32>
            %105 = bufferization.to_memref %arg28 : memref<32x64xf32>
            %106 = affine.min #map(%arg23, %82)
            %107 = affine.min #map1(%arg25, %83)
            %108 = affine.min #map(%arg23, %82)
            %109 = affine.min #map1(%arg25, %83)
            %subview_24 = memref.subview %alloc_8[%arg23, %arg27] [%106, 1] [1, 1] : memref<32x16xf16> to memref<?x1xf16, strided<[16, 1], offset: ?>>
            %110 = bufferization.to_tensor %subview_24 : memref<?x1xf16, strided<[16, 1], offset: ?>>
            %subview_25 = memref.subview %alloc_13[%arg27, %arg25] [1, %107] [1, 1] : memref<16x64xf16> to memref<1x?xf16, strided<[64, 1], offset: ?>>
            %111 = bufferization.to_tensor %subview_25 : memref<1x?xf16, strided<[64, 1], offset: ?>>
            %subview_26 = memref.subview %105[%arg23, %arg25] [%108, %109] [1, 1] : memref<32x64xf32> to memref<?x?xf32, strided<[64, 1], offset: ?>>
            %112 = bufferization.to_tensor %subview_26 : memref<?x?xf32, strided<[64, 1], offset: ?>>
            %113 = vector.create_mask %106, %c1 : vector<[4]x1xi1>
            %114 = vector.transfer_read %110[%c0, %c0], %cst_0, %113 {in_bounds = [true, true, true], permutation_map = #map2} : tensor<?x1xf16>, vector<[4]x[4]x1xf16>
            %115 = vector.create_mask %107 : vector<[4]xi1>
            %116 = vector.insert %115, %cst [0] : vector<[4]xi1> into vector<1x[4]xi1>
            %117 = vector.transfer_read %111[%c0, %c0], %cst_0, %116 {in_bounds = [true, true, true], permutation_map = #map3} : tensor<1x?xf16>, vector<[4]x[4]x1xf16>
            %118 = vector.create_mask %106, %107 : vector<[4]x[4]xi1>
            %119 = vector.transfer_read %112[%c0, %c0], %cst_1, %118 {in_bounds = [true, true]} : tensor<?x?xf32>, vector<[4]x[4]xf32>
            %120 = arith.extf %114 : vector<[4]x[4]x1xf16> to vector<[4]x[4]x1xf32>
            %121 = arith.extf %117 : vector<[4]x[4]x1xf16> to vector<[4]x[4]x1xf32>
            %122 = vector.create_mask %106, %107, %c1 : vector<[4]x[4]x1xi1>
            %123 = vector.mask %122 { vector.contract {indexing_maps = [#map4, #map4, #map5], iterator_types = ["parallel", "parallel", "reduction"], kind = #vector.kind<add>} %120, %121, %119 : vector<[4]x[4]x1xf32>, vector<[4]x[4]x1xf32> into vector<[4]x[4]xf32> } : vector<[4]x[4]x1xi1> -> vector<[4]x[4]xf32>
            %124 = vector.transfer_write %123, %112[%c0, %c0], %118 {in_bounds = [true, true]} : vector<[4]x[4]xf32>, tensor<?x?xf32>
            %125 = bufferization.to_memref %124 : memref<?x?xf32>
            %alloc_27 = memref.alloc() {alignment = 64 : i64} : memref<32x64xf32>
            memref.copy %104, %alloc_27 : memref<32x64xf32> to memref<32x64xf32>
            %subview_28 = memref.subview %alloc_27[%arg23, %arg25] [%108, %109] [1, 1] : memref<32x64xf32> to memref<?x?xf32, strided<[64, 1], offset: ?>>
            memref.copy %125, %subview_28 : memref<?x?xf32> to memref<?x?xf32, strided<[64, 1], offset: ?>>
            %126 = bufferization.to_tensor %alloc_27 : memref<32x64xf32>
            scf.yield %126 : tensor<32x64xf32>
          }
          scf.yield %103 : tensor<32x64xf32>
        }
        scf.yield %102 : tensor<32x64xf32>
      }
      %85 = linalg.generic {indexing_maps = [#map6, #map6, #map6], iterator_types = ["parallel", "parallel"]} ins(%84, %arg16 : tensor<32x64xf32>, tensor<32x64xf32>) outs(%84 : tensor<32x64xf32>) {
      ^bb0(%in: f32, %in_24: f32, %out: f32):
        %102 = arith.addf %in, %in_24 : f32
        linalg.yield %102 : f32
      } -> tensor<32x64xf32>
      %86 = arith.addi %arg19, %c16 : index
      %87 = arith.remsi %86, %41 : index
      %88 = arith.muli %39, %41 : index
      %89 = arith.addi %88, %87 : index
      %90 = arith.subi %89, %86 : index
      %91 = arith.divsi %90, %41 : index
      %reinterpret_cast_20 = memref.reinterpret_cast %arg0 to offset: [%86], sizes: [%91, %c16], strides: [%41, %c1] : memref<*xf16> to memref<?x16xf16, strided<[?, ?], offset: ?>>
      %92 = arith.subi %c32, %91 : index
      %reinterpret_cast_21 = memref.reinterpret_cast %arg0 to offset: [%87], sizes: [%92, %c16], strides: [%41, %c1] : memref<*xf16> to memref<?x16xf16, strided<[?, ?], offset: ?>>
      %93 = arith.index_cast %38 : i32 to index
      %94 = arith.addi %arg20, %93 : index
      %95 = arith.addi %94, %45 : index
      %96 = arith.remsi %95, %44 : index
      %97 = arith.subi %95, %96 : index
      %98 = arith.addi %96, %c64 : index
      %99 = arith.minsi %98, %44 : index
      %100 = arith.subi %99, %96 : index
      %reinterpret_cast_22 = memref.reinterpret_cast %arg1 to offset: [%95], sizes: [%c16, %100], strides: [%43, %c1] : memref<*xf16> to memref<16x?xf16, strided<[?, ?], offset: ?>>
      %101 = arith.subi %c64, %100 : index
      %reinterpret_cast_23 = memref.reinterpret_cast %arg1 to offset: [%97], sizes: [%c16, %101], strides: [%43, %c1] : memref<*xf16> to memref<16x?xf16, strided<[?, ?], offset: ?>>
      scf.yield %85, %reinterpret_cast_20, %reinterpret_cast_22, %86, %94, %reinterpret_cast_21, %reinterpret_cast_23 : tensor<32x64xf32>, memref<?x16xf16, strided<[?, ?], offset: ?>>, memref<16x?xf16, strided<[?, ?], offset: ?>>, index, index, memref<?x16xf16, strided<[?, ?], offset: ?>>, memref<16x?xf16, strided<[?, ?], offset: ?>>
    }
    %47 = arith.index_cast %arg8 : i32 to index
    %48 = arith.index_cast %15 : i32 to index
    %49 = arith.muli %48, %47 : index
    %50 = arith.index_cast %16 : i32 to index
    %51 = arith.addi %49, %50 : index
    %reinterpret_cast_5 = memref.reinterpret_cast %arg2 to offset: [%51], sizes: [32, 64], strides: [%47, 1] : memref<*xf16> to memref<32x64xf16, strided<[?, 1], offset: ?>>
    %alloc_6 = memref.alloc() {alignment = 64 : i64} : memref<32x64xf16>
    %52 = bufferization.to_tensor %alloc_6 : memref<32x64xf16>
    %53 = linalg.generic {indexing_maps = [#map6, #map6], iterator_types = ["parallel", "parallel"]} ins(%46#0 : tensor<32x64xf32>) outs(%52 : tensor<32x64xf16>) {
    ^bb0(%in: f32, %out: f16):
      %67 = arith.truncf %in : f32 to f16
      linalg.yield %67 : f16
    } -> tensor<32x64xf16>
    %54 = bufferization.to_memref %53 : memref<32x64xf16>
    %55 = arith.index_cast %15 : i32 to index
    %56 = arith.addi %55, %c32 : index
    %57 = arith.index_cast %arg3 : i32 to index
    %58 = arith.minsi %56, %57 : index
    %59 = arith.subi %58, %55 : index
    %60 = arith.index_cast %16 : i32 to index
    %61 = arith.addi %60, %c64 : index
    %62 = arith.index_cast %arg4 : i32 to index
    %63 = arith.minsi %61, %62 : index
    %64 = arith.subi %63, %60 : index
    %65 = arith.minsi %59, %c32 : index
    %66 = arith.minsi %64, %c64 : index
    %subview = memref.subview %54[0, 0] [%65, %66] [1, 1] : memref<32x64xf16> to memref<?x?xf16, strided<[64, 1]>>
    %subview_7 = memref.subview %reinterpret_cast_5[0, 0] [%65, %66] [1, 1] : memref<32x64xf16, strided<[?, 1], offset: ?>> to memref<?x?xf16, strided<[?, 1], offset: ?>>
    memref.copy %subview, %subview_7 : memref<?x?xf16, strided<[64, 1]>> to memref<?x?xf16, strided<[?, 1], offset: ?>>
    return
  }
}
