#map = affine_map<(d0, d1) -> (-d0 + 32, d1)>
#map1 = affine_map<(d0, d1) -> (-d0 + 64, d1)>
#map2 = affine_map<(d0, d1, d2) -> (d0, d2)>
#map3 = affine_map<(d0, d1, d2) -> (d2, d1)>
#map4 = affine_map<(d0, d1, d2) -> (d0, d1)>
#map5 = affine_map<(d0, d1) -> (d0, d1)>
module {
  func.func @matmul_kernel_0d1d2d34567c89c1011c(%arg0: memref<*xf16> {tt.divisibility = 16 : i32}, %arg1: memref<*xf16> {tt.divisibility = 16 : i32}, %arg2: memref<*xf16> {tt.divisibility = 16 : i32}, %arg3: i32, %arg4: i32, %arg5: i32, %arg6: i32, %arg7: i32, %arg8: i32, %arg9: i32, %arg10: i32, %arg11: i32, %arg12: i32, %arg13: i32, %arg14: i32) {
    %cst = arith.constant dense<false> : vector<2x[4]xi1>
    %c2 = arith.constant 2 : index
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
    linalg.fill ins(%cst_1 : f32) outs(%alloc : memref<32x64xf32>)
    %0 = arith.addi %arg3, %c31_i32 : i32
    %1 = arith.divsi %0, %c32_i32 : i32
    %2 = arith.addi %arg4, %c63_i32 : i32
    %3 = arith.divsi %2, %c64_i32 : i32
    %4 = arith.muli %3, %c8_i32 : i32
    %5 = arith.divsi %arg12, %4 : i32
    %6 = arith.muli %5, %c8_i32 : i32
    %7 = arith.subi %1, %6 : i32
    %8 = arith.minsi %7, %c8_i32 : i32
    %9 = arith.remsi %arg12, %8 : i32
    %10 = arith.addi %6, %9 : i32
    %11 = arith.remsi %arg12, %4 : i32
    %12 = arith.divsi %11, %8 : i32
    %13 = arith.muli %10, %c32_i32 : i32
    %14 = arith.muli %12, %c64_i32 : i32
    %15 = arith.index_cast %arg3 : i32 to index
    %16 = arith.index_cast %13 : i32 to index
    %17 = arith.index_cast %arg6 : i32 to index
    %18 = arith.muli %16, %17 : index
    %19 = arith.remsi %18, %17 : index
    %20 = arith.muli %15, %17 : index
    %21 = arith.addi %20, %19 : index
    %22 = arith.subi %21, %18 : index
    %23 = arith.divsi %22, %17 : index
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [%18], sizes: [%23, %c16], strides: [%17, %c1] : memref<*xf16> to memref<?x16xf16, strided<[?, ?], offset: ?>>
    %24 = arith.subi %c32, %23 : index
    %reinterpret_cast_2 = memref.reinterpret_cast %arg0 to offset: [%19], sizes: [%24, %c16], strides: [%17, %c1] : memref<*xf16> to memref<?x16xf16, strided<[?, ?], offset: ?>>
    %25 = arith.index_cast %arg7 : i32 to index
    %26 = arith.index_cast %arg4 : i32 to index
    %27 = arith.index_cast %14 : i32 to index
    %28 = arith.remsi %27, %26 : index
    %29 = arith.subi %27, %28 : index
    %30 = arith.addi %28, %c64 : index
    %31 = arith.minsi %30, %26 : index
    %32 = arith.subi %31, %28 : index
    %reinterpret_cast_3 = memref.reinterpret_cast %arg1 to offset: [%27], sizes: [%c16, %32], strides: [%25, %c1] : memref<*xf16> to memref<16x?xf16, strided<[?, ?], offset: ?>>
    %33 = arith.subi %c64, %32 : index
    %reinterpret_cast_4 = memref.reinterpret_cast %arg1 to offset: [%29], sizes: [%c16, %33], strides: [%25, %c1] : memref<*xf16> to memref<16x?xf16, strided<[?, ?], offset: ?>>
    %34 = arith.addi %arg5, %c15_i32 : i32
    %35 = arith.divsi %34, %c16_i32 : i32
    %36 = arith.muli %arg7, %c16_i32 : i32
    %alloc_5 = memref.alloc() {alignment = 64 : i64} : memref<32x64xf32>
    memref.copy %alloc, %alloc_5 : memref<32x64xf32> to memref<32x64xf32>
    %37:7 = scf.for %arg15 = %c0_i32 to %35 step %c1_i32 iter_args(%arg16 = %alloc_5, %arg17 = %reinterpret_cast, %arg18 = %reinterpret_cast_3, %arg19 = %18, %arg20 = %c0, %arg21 = %reinterpret_cast_2, %arg22 = %reinterpret_cast_4) -> (memref<32x64xf32>, memref<?x16xf16, strided<[?, ?], offset: ?>>, memref<16x?xf16, strided<[?, ?], offset: ?>>, index, index, memref<?x16xf16, strided<[?, ?], offset: ?>>, memref<16x?xf16, strided<[?, ?], offset: ?>>)  : i32 {
      %49 = arith.muli %arg15, %c16_i32 : i32
      %50 = arith.subi %arg5, %49 : i32
      %alloc_9 = memref.alloc() : memref<32x16xf16>
      %51 = arith.index_cast %50 : i32 to index
      %52 = arith.minsi %51, %c16 : index
      %53 = arith.cmpi slt, %52, %c16 : index
      scf.if %53 {
        linalg.fill ins(%cst_0 : f16) outs(%alloc_9 : memref<32x16xf16>)
      }
      %dim = memref.dim %arg17, %c0 : memref<?x16xf16, strided<[?, ?], offset: ?>>
      %54 = arith.minsi %dim, %c32 : index
      %55 = arith.subi %c32, %54 : index
      %subview_10 = memref.subview %arg17[0, 0] [%54, %52] [1, 1] : memref<?x16xf16, strided<[?, ?], offset: ?>> to memref<?x?xf16, strided<[?, ?], offset: ?>>
      %subview_11 = memref.subview %arg21[0, 0] [%55, %52] [1, 1] : memref<?x16xf16, strided<[?, ?], offset: ?>> to memref<?x?xf16, strided<[?, ?], offset: ?>>
      %subview_12 = memref.subview %alloc_9[0, 0] [%54, %52] [1, 1] : memref<32x16xf16> to memref<?x?xf16, strided<[16, 1]>>
      %subview_13 = memref.subview %alloc_9[%54, 0] [%55, %52] [1, 1] : memref<32x16xf16> to memref<?x?xf16, strided<[16, 1], offset: ?>>
      memref.copy %subview_10, %subview_12 : memref<?x?xf16, strided<[?, ?], offset: ?>> to memref<?x?xf16, strided<[16, 1]>>
      memref.copy %subview_11, %subview_13 : memref<?x?xf16, strided<[?, ?], offset: ?>> to memref<?x?xf16, strided<[16, 1], offset: ?>>
      %alloc_14 = memref.alloc() : memref<16x64xf16>
      scf.if %53 {
        linalg.fill ins(%cst_0 : f16) outs(%alloc_14 : memref<16x64xf16>)
      }
      %dim_15 = memref.dim %arg18, %c1 : memref<16x?xf16, strided<[?, ?], offset: ?>>
      %56 = arith.minsi %dim_15, %c64 : index
      %57 = arith.subi %c64, %56 : index
      %subview_16 = memref.subview %arg18[0, 0] [%52, %56] [1, 1] : memref<16x?xf16, strided<[?, ?], offset: ?>> to memref<?x?xf16, strided<[?, ?], offset: ?>>
      %subview_17 = memref.subview %arg22[0, 0] [%52, %57] [1, 1] : memref<16x?xf16, strided<[?, ?], offset: ?>> to memref<?x?xf16, strided<[?, ?], offset: ?>>
      %subview_18 = memref.subview %alloc_14[0, 0] [%52, %56] [1, 1] : memref<16x64xf16> to memref<?x?xf16, strided<[64, 1]>>
      %subview_19 = memref.subview %alloc_14[0, %56] [%52, %57] [1, 1] : memref<16x64xf16> to memref<?x?xf16, strided<[64, 1], offset: ?>>
      memref.copy %subview_16, %subview_18 : memref<?x?xf16, strided<[?, ?], offset: ?>> to memref<?x?xf16, strided<[64, 1]>>
      memref.copy %subview_17, %subview_19 : memref<?x?xf16, strided<[?, ?], offset: ?>> to memref<?x?xf16, strided<[64, 1], offset: ?>>
      %vscale = vector.vscale
      %58 = arith.muli %vscale, %c4 : index
      %59 = arith.muli %vscale, %c4 : index
      %alloc_20 = memref.alloc() {alignment = 64 : i64} : memref<32x64xf32>
      memref.copy %alloc, %alloc_20 : memref<32x64xf32> to memref<32x64xf32>
      %60 = scf.for %arg23 = %c0 to %c32 step %58 iter_args(%arg24 = %alloc_20) -> (memref<32x64xf32>) {
        %76 = scf.for %arg25 = %c0 to %c64 step %59 iter_args(%arg26 = %arg24) -> (memref<32x64xf32>) {
          %77 = scf.for %arg27 = %c0 to %c16 step %c2 iter_args(%arg28 = %arg26) -> (memref<32x64xf32>) {
            %78 = affine.min #map(%arg23, %58)
            %79 = affine.min #map1(%arg25, %59)
            %80 = affine.min #map(%arg23, %58)
            %81 = affine.min #map1(%arg25, %59)
            %subview_25 = memref.subview %alloc_9[%arg23, %arg27] [%78, 2] [1, 1] : memref<32x16xf16> to memref<?x2xf16, strided<[16, 1], offset: ?>>
            %subview_26 = memref.subview %alloc_14[%arg27, %arg25] [2, %79] [1, 1] : memref<16x64xf16> to memref<2x?xf16, strided<[64, 1], offset: ?>>
            %subview_27 = memref.subview %arg28[%arg23, %arg25] [%80, %81] [1, 1] : memref<32x64xf32> to memref<?x?xf32, strided<[64, 1], offset: ?>>
            %82 = vector.create_mask %78, %c2 : vector<[4]x2xi1>
            %83 = vector.transfer_read %subview_25[%c0, %c0], %cst_0, %82 {in_bounds = [true, true]} : memref<?x2xf16, strided<[16, 1], offset: ?>>, vector<[4]x2xf16>
            %84 = vector.create_mask %79 : vector<[4]xi1>
            %85 = vector.insert %84, %cst [0] : vector<[4]xi1> into vector<2x[4]xi1>
            %86 = vector.insert %84, %85 [1] : vector<[4]xi1> into vector<2x[4]xi1>
            %87 = vector.transfer_read %subview_26[%c0, %c0], %cst_0, %86 {in_bounds = [true, true]} : memref<2x?xf16, strided<[64, 1], offset: ?>>, vector<2x[4]xf16>
            %88 = vector.create_mask %78, %79 : vector<[4]x[4]xi1>
            %89 = vector.transfer_read %subview_27[%c0, %c0], %cst_1, %88 {in_bounds = [true, true]} : memref<?x?xf32, strided<[64, 1], offset: ?>>, vector<[4]x[4]xf32>
            %90 = arith.extf %83 : vector<[4]x2xf16> to vector<[4]x2xf32>
            %91 = arith.extf %87 : vector<2x[4]xf16> to vector<2x[4]xf32>
            %92 = vector.create_mask %78, %79, %c2 : vector<[4]x[4]x2xi1>
            %93 = vector.mask %92 { vector.contract {indexing_maps = [#map2, #map3, #map4], iterator_types = ["parallel", "parallel", "reduction"], kind = #vector.kind<add>} %90, %91, %89 : vector<[4]x2xf32>, vector<2x[4]xf32> into vector<[4]x[4]xf32> } : vector<[4]x[4]x2xi1> -> vector<[4]x[4]xf32>
            vector.transfer_write %93, %subview_27[%c0, %c0], %88 {in_bounds = [true, true]} : vector<[4]x[4]xf32>, memref<?x?xf32, strided<[64, 1], offset: ?>>
            %subview_28 = memref.subview %arg28[%arg23, %arg25] [%80, %81] [1, 1] : memref<32x64xf32> to memref<?x?xf32, strided<[64, 1], offset: ?>>
            memref.copy %subview_27, %subview_28 : memref<?x?xf32, strided<[64, 1], offset: ?>> to memref<?x?xf32, strided<[64, 1], offset: ?>>
            scf.yield %arg28 : memref<32x64xf32>
          }
          scf.yield %77 : memref<32x64xf32>
        }
        scf.yield %76 : memref<32x64xf32>
      }
      linalg.generic {indexing_maps = [#map5, #map5, #map5], iterator_types = ["parallel", "parallel"]} ins(%60, %arg16 : memref<32x64xf32>, memref<32x64xf32>) outs(%60 : memref<32x64xf32>) {
      ^bb0(%in: f32, %in_25: f32, %out: f32):
        %76 = arith.addf %in, %in_25 : f32
        linalg.yield %76 : f32
      }
      %61 = arith.addi %arg19, %c16 : index
      %62 = arith.remsi %61, %17 : index
      %63 = arith.addi %20, %62 : index
      %64 = arith.subi %63, %61 : index
      %65 = arith.divsi %64, %17 : index
      %reinterpret_cast_21 = memref.reinterpret_cast %arg0 to offset: [%61], sizes: [%65, %c16], strides: [%17, %c1] : memref<*xf16> to memref<?x16xf16, strided<[?, ?], offset: ?>>
      %66 = arith.subi %c32, %65 : index
      %reinterpret_cast_22 = memref.reinterpret_cast %arg0 to offset: [%62], sizes: [%66, %c16], strides: [%17, %c1] : memref<*xf16> to memref<?x16xf16, strided<[?, ?], offset: ?>>
      %67 = arith.index_cast %36 : i32 to index
      %68 = arith.addi %arg20, %67 : index
      %69 = arith.addi %68, %27 : index
      %70 = arith.remsi %69, %26 : index
      %71 = arith.subi %69, %70 : index
      %72 = arith.addi %70, %c64 : index
      %73 = arith.minsi %72, %26 : index
      %74 = arith.subi %73, %70 : index
      %reinterpret_cast_23 = memref.reinterpret_cast %arg1 to offset: [%69], sizes: [%c16, %74], strides: [%25, %c1] : memref<*xf16> to memref<16x?xf16, strided<[?, ?], offset: ?>>
      %75 = arith.subi %c64, %74 : index
      %reinterpret_cast_24 = memref.reinterpret_cast %arg1 to offset: [%71], sizes: [%c16, %75], strides: [%25, %c1] : memref<*xf16> to memref<16x?xf16, strided<[?, ?], offset: ?>>
      scf.yield %60, %reinterpret_cast_21, %reinterpret_cast_23, %61, %68, %reinterpret_cast_22, %reinterpret_cast_24 : memref<32x64xf32>, memref<?x16xf16, strided<[?, ?], offset: ?>>, memref<16x?xf16, strided<[?, ?], offset: ?>>, index, index, memref<?x16xf16, strided<[?, ?], offset: ?>>, memref<16x?xf16, strided<[?, ?], offset: ?>>
    }
    %38 = arith.index_cast %arg8 : i32 to index
    %39 = arith.muli %16, %38 : index
    %40 = arith.addi %39, %27 : index
    %reinterpret_cast_6 = memref.reinterpret_cast %arg2 to offset: [%40], sizes: [32, 64], strides: [%38, 1] : memref<*xf16> to memref<32x64xf16, strided<[?, 1], offset: ?>>
    %alloc_7 = memref.alloc() {alignment = 64 : i64} : memref<32x64xf16>
    linalg.generic {indexing_maps = [#map5, #map5], iterator_types = ["parallel", "parallel"]} ins(%37#0 : memref<32x64xf32>) outs(%alloc_7 : memref<32x64xf16>) {
    ^bb0(%in: f32, %out: f16):
      %49 = arith.truncf %in : f32 to f16
      linalg.yield %49 : f16
    }
    %41 = arith.addi %16, %c32 : index
    %42 = arith.minsi %41, %15 : index
    %43 = arith.subi %42, %16 : index
    %44 = arith.addi %27, %c64 : index
    %45 = arith.minsi %44, %26 : index
    %46 = arith.subi %45, %27 : index
    %47 = arith.minsi %43, %c32 : index
    %48 = arith.minsi %46, %c64 : index
    %subview = memref.subview %alloc_7[0, 0] [%47, %48] [1, 1] : memref<32x64xf16> to memref<?x?xf16, strided<[64, 1]>>
    %subview_8 = memref.subview %reinterpret_cast_6[0, 0] [%47, %48] [1, 1] : memref<32x64xf16, strided<[?, 1], offset: ?>> to memref<?x?xf16, strided<[?, 1], offset: ?>>
    memref.copy %subview, %subview_8 : memref<?x?xf16, strided<[64, 1]>> to memref<?x?xf16, strided<[?, 1], offset: ?>>
    return
  }
}

