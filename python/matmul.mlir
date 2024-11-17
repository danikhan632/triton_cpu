#map = affine_map<(d0, d1) -> (-d0 + 32, d1)>
#map1 = affine_map<(d0, d1) -> (-d0 + 64, d1)>
#map2 = affine_map<(d0, d1, d2) -> (d0, d2)>
#map3 = affine_map<(d0, d1, d2) -> (d2, d1)>
#map4 = affine_map<(d0, d1, d2) -> (d0, d1)>
#map5 = affine_map<(d0, d1) -> (d0, d1)>
module {
  func.func @matmul_kernel_0d1d2d34567c89c1011c(%arg0: memref<*xf32> {tt.divisibility = 16 : i32}, %arg1: memref<*xf32> {tt.divisibility = 16 : i32}, %arg2: memref<*xf32> {tt.divisibility = 16 : i32}, %arg3: i32, %arg4: i32, %arg5: i32, %arg6: i32, %arg7: i32, %arg8: i32, %arg9: i32, %arg10: i32, %arg11: i32, %arg12: i32, %arg13: i32, %arg14: i32) {
    %cst = arith.constant dense<false> : vector<2x[4]xi1>
    %c2 = arith.constant 2 : index
    %c4 = arith.constant 4 : index
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
    %cst_0 = arith.constant 0.000000e+00 : f32
    %alloc = memref.alloc() {alignment = 64 : i64} : memref<32x64xf32>
    linalg.fill ins(%cst_0 : f32) outs(%alloc : memref<32x64xf32>)
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
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [%18], sizes: [%23, %c16], strides: [%17, %c1] : memref<*xf32> to memref<?x16xf32, strided<[?, ?], offset: ?>>
    %24 = arith.subi %c32, %23 : index
    %reinterpret_cast_1 = memref.reinterpret_cast %arg0 to offset: [%19], sizes: [%24, %c16], strides: [%17, %c1] : memref<*xf32> to memref<?x16xf32, strided<[?, ?], offset: ?>>
    %25 = arith.index_cast %arg7 : i32 to index
    %26 = arith.index_cast %arg4 : i32 to index
    %27 = arith.index_cast %14 : i32 to index
    %28 = arith.remsi %27, %26 : index
    %29 = arith.subi %27, %28 : index
    %30 = arith.addi %28, %c64 : index
    %31 = arith.minsi %30, %26 : index
    %32 = arith.subi %31, %28 : index
    %reinterpret_cast_2 = memref.reinterpret_cast %arg1 to offset: [%27], sizes: [%c16, %32], strides: [%25, %c1] : memref<*xf32> to memref<16x?xf32, strided<[?, ?], offset: ?>>
    %33 = arith.subi %c64, %32 : index
    %reinterpret_cast_3 = memref.reinterpret_cast %arg1 to offset: [%29], sizes: [%c16, %33], strides: [%25, %c1] : memref<*xf32> to memref<16x?xf32, strided<[?, ?], offset: ?>>
    %34 = arith.addi %arg5, %c15_i32 : i32
    %35 = arith.divsi %34, %c16_i32 : i32
    %36 = arith.muli %arg7, %c16_i32 : i32
    %37 = arith.index_cast %arg3 : i32 to index
    %38 = arith.index_cast %13 : i32 to index
    %39 = arith.index_cast %arg6 : i32 to index
    %40 = arith.muli %38, %39 : index
    %41 = arith.index_cast %arg7 : i32 to index
    %42 = arith.index_cast %arg4 : i32 to index
    %43 = arith.index_cast %14 : i32 to index
    %44:7 = scf.for %arg15 = %c0_i32 to %35 step %c1_i32 iter_args(%arg16 = %alloc, %arg17 = %reinterpret_cast, %arg18 = %reinterpret_cast_2, %arg19 = %40, %arg20 = %c0, %arg21 = %reinterpret_cast_1, %arg22 = %reinterpret_cast_3) -> (memref<32x64xf32>, memref<?x16xf32, strided<[?, ?], offset: ?>>, memref<16x?xf32, strided<[?, ?], offset: ?>>, index, index, memref<?x16xf32, strided<[?, ?], offset: ?>>, memref<16x?xf32, strided<[?, ?], offset: ?>>)  : i32 {
      %62 = arith.muli %arg15, %c16_i32 : i32
      %63 = arith.subi %arg5, %62 : i32
      %alloc_6 = memref.alloc() : memref<32x16xf32>
      %64 = arith.index_cast %63 : i32 to index
      %65 = arith.minsi %64, %c16 : index
      %66 = arith.cmpi slt, %65, %c16 : index
      scf.if %66 {
        linalg.fill ins(%cst_0 : f32) outs(%alloc_6 : memref<32x16xf32>)
      }
      %dim = memref.dim %arg17, %c0 : memref<?x16xf32, strided<[?, ?], offset: ?>>
      %67 = arith.minsi %dim, %c32 : index
      %68 = arith.subi %c32, %67 : index
      %subview_7 = memref.subview %arg17[0, 0] [%67, %65] [1, 1] : memref<?x16xf32, strided<[?, ?], offset: ?>> to memref<?x?xf32, strided<[?, ?], offset: ?>>
      %subview_8 = memref.subview %arg21[0, 0] [%68, %65] [1, 1] : memref<?x16xf32, strided<[?, ?], offset: ?>> to memref<?x?xf32, strided<[?, ?], offset: ?>>
      %subview_9 = memref.subview %alloc_6[0, 0] [%67, %65] [1, 1] : memref<32x16xf32> to memref<?x?xf32, strided<[16, 1]>>
      %subview_10 = memref.subview %alloc_6[%67, 0] [%68, %65] [1, 1] : memref<32x16xf32> to memref<?x?xf32, strided<[16, 1], offset: ?>>
      memref.copy %subview_7, %subview_9 : memref<?x?xf32, strided<[?, ?], offset: ?>> to memref<?x?xf32, strided<[16, 1]>>
      memref.copy %subview_8, %subview_10 : memref<?x?xf32, strided<[?, ?], offset: ?>> to memref<?x?xf32, strided<[16, 1], offset: ?>>
      %alloc_11 = memref.alloc() : memref<16x64xf32>
      %69 = arith.index_cast %63 : i32 to index
      %70 = arith.minsi %69, %c16 : index
      %71 = arith.cmpi slt, %70, %c16 : index
      scf.if %71 {
        linalg.fill ins(%cst_0 : f32) outs(%alloc_11 : memref<16x64xf32>)
      }
      %dim_12 = memref.dim %arg18, %c1 : memref<16x?xf32, strided<[?, ?], offset: ?>>
      %72 = arith.minsi %dim_12, %c64 : index
      %73 = arith.subi %c64, %72 : index
      %subview_13 = memref.subview %arg18[0, 0] [%70, %72] [1, 1] : memref<16x?xf32, strided<[?, ?], offset: ?>> to memref<?x?xf32, strided<[?, ?], offset: ?>>
      %subview_14 = memref.subview %arg22[0, 0] [%70, %73] [1, 1] : memref<16x?xf32, strided<[?, ?], offset: ?>> to memref<?x?xf32, strided<[?, ?], offset: ?>>
      %subview_15 = memref.subview %alloc_11[0, 0] [%70, %72] [1, 1] : memref<16x64xf32> to memref<?x?xf32, strided<[64, 1]>>
      %subview_16 = memref.subview %alloc_11[0, %72] [%70, %73] [1, 1] : memref<16x64xf32> to memref<?x?xf32, strided<[64, 1], offset: ?>>
      memref.copy %subview_13, %subview_15 : memref<?x?xf32, strided<[?, ?], offset: ?>> to memref<?x?xf32, strided<[64, 1]>>
      memref.copy %subview_14, %subview_16 : memref<?x?xf32, strided<[?, ?], offset: ?>> to memref<?x?xf32, strided<[64, 1], offset: ?>>
      %alloc_17 = memref.alloc() {alignment = 64 : i64} : memref<32x64xf32>
      linalg.fill ins(%cst_0 : f32) outs(%alloc_17 : memref<32x64xf32>)
      %vscale = vector.vscale
      %74 = arith.muli %vscale, %c4 : index
      %75 = arith.muli %vscale, %c4 : index
      %76 = scf.for %arg23 = %c0 to %c32 step %74 iter_args(%arg24 = %alloc_17) -> (memref<32x64xf32>) {
        %93 = scf.for %arg25 = %c0 to %c64 step %75 iter_args(%arg26 = %arg24) -> (memref<32x64xf32>) {
          %94 = scf.for %arg27 = %c0 to %c16 step %c2 iter_args(%arg28 = %arg26) -> (memref<32x64xf32>) {
            %95 = affine.min #map(%arg23, %74)
            %96 = affine.min #map1(%arg25, %75)
            %97 = affine.min #map(%arg23, %74)
            %98 = affine.min #map1(%arg25, %75)
            %subview_22 = memref.subview %alloc_6[%arg23, %arg27] [%95, 2] [1, 1] : memref<32x16xf32> to memref<?x2xf32, strided<[16, 1], offset: ?>>
            %subview_23 = memref.subview %alloc_11[%arg27, %arg25] [2, %96] [1, 1] : memref<16x64xf32> to memref<2x?xf32, strided<[64, 1], offset: ?>>
            %subview_24 = memref.subview %arg28[%arg23, %arg25] [%97, %98] [1, 1] : memref<32x64xf32> to memref<?x?xf32, strided<[64, 1], offset: ?>>
            %99 = vector.create_mask %95, %c2 : vector<[4]x2xi1>
            %100 = vector.transfer_read %subview_22[%c0, %c0], %cst_0, %99 {in_bounds = [true, true]} : memref<?x2xf32, strided<[16, 1], offset: ?>>, vector<[4]x2xf32>
            %101 = vector.create_mask %96 : vector<[4]xi1>
            %102 = vector.insert %101, %cst [0] : vector<[4]xi1> into vector<2x[4]xi1>
            %103 = vector.insert %101, %102 [1] : vector<[4]xi1> into vector<2x[4]xi1>
            %104 = vector.transfer_read %subview_23[%c0, %c0], %cst_0, %103 {in_bounds = [true, true]} : memref<2x?xf32, strided<[64, 1], offset: ?>>, vector<2x[4]xf32>
            %105 = vector.create_mask %95, %96 : vector<[4]x[4]xi1>
            %106 = vector.transfer_read %subview_24[%c0, %c0], %cst_0, %105 {in_bounds = [true, true]} : memref<?x?xf32, strided<[64, 1], offset: ?>>, vector<[4]x[4]xf32>
            %107 = vector.create_mask %95, %96, %c2 : vector<[4]x[4]x2xi1>
            %108 = vector.mask %107 { vector.contract {indexing_maps = [#map2, #map3, #map4], iterator_types = ["parallel", "parallel", "reduction"], kind = #vector.kind<add>} %100, %104, %106 : vector<[4]x2xf32>, vector<2x[4]xf32> into vector<[4]x[4]xf32> } : vector<[4]x[4]x2xi1> -> vector<[4]x[4]xf32>
            vector.transfer_write %108, %subview_24[%c0, %c0], %105 {in_bounds = [true, true]} : vector<[4]x[4]xf32>, memref<?x?xf32, strided<[64, 1], offset: ?>>
            %subview_25 = memref.subview %arg28[%arg23, %arg25] [%97, %98] [1, 1] : memref<32x64xf32> to memref<?x?xf32, strided<[64, 1], offset: ?>>
            memref.copy %subview_24, %subview_25 : memref<?x?xf32, strided<[64, 1], offset: ?>> to memref<?x?xf32, strided<[64, 1], offset: ?>>
            scf.yield %arg28 : memref<32x64xf32>
          }
          scf.yield %94 : memref<32x64xf32>
        }
        scf.yield %93 : memref<32x64xf32>
      }
      linalg.generic {indexing_maps = [#map5, #map5, #map5], iterator_types = ["parallel", "parallel"]} ins(%76, %arg16 : memref<32x64xf32>, memref<32x64xf32>) outs(%76 : memref<32x64xf32>) {
      ^bb0(%in: f32, %in_22: f32, %out: f32):
        %93 = arith.addf %in, %in_22 : f32
        linalg.yield %93 : f32
      }
      %77 = arith.addi %arg19, %c16 : index
      %78 = arith.remsi %77, %39 : index
      %79 = arith.muli %37, %39 : index
      %80 = arith.addi %79, %78 : index
      %81 = arith.subi %80, %77 : index
      %82 = arith.divsi %81, %39 : index
      %reinterpret_cast_18 = memref.reinterpret_cast %arg0 to offset: [%77], sizes: [%82, %c16], strides: [%39, %c1] : memref<*xf32> to memref<?x16xf32, strided<[?, ?], offset: ?>>
      %83 = arith.subi %c32, %82 : index
      %reinterpret_cast_19 = memref.reinterpret_cast %arg0 to offset: [%78], sizes: [%83, %c16], strides: [%39, %c1] : memref<*xf32> to memref<?x16xf32, strided<[?, ?], offset: ?>>
      %84 = arith.index_cast %36 : i32 to index
      %85 = arith.addi %arg20, %84 : index
      %86 = arith.addi %85, %43 : index
      %87 = arith.remsi %86, %42 : index
      %88 = arith.subi %86, %87 : index
      %89 = arith.addi %87, %c64 : index
      %90 = arith.minsi %89, %42 : index
      %91 = arith.subi %90, %87 : index
      %reinterpret_cast_20 = memref.reinterpret_cast %arg1 to offset: [%86], sizes: [%c16, %91], strides: [%41, %c1] : memref<*xf32> to memref<16x?xf32, strided<[?, ?], offset: ?>>
      %92 = arith.subi %c64, %91 : index
      %reinterpret_cast_21 = memref.reinterpret_cast %arg1 to offset: [%88], sizes: [%c16, %92], strides: [%41, %c1] : memref<*xf32> to memref<16x?xf32, strided<[?, ?], offset: ?>>
      scf.yield %76, %reinterpret_cast_18, %reinterpret_cast_20, %77, %85, %reinterpret_cast_19, %reinterpret_cast_21 : memref<32x64xf32>, memref<?x16xf32, strided<[?, ?], offset: ?>>, memref<16x?xf32, strided<[?, ?], offset: ?>>, index, index, memref<?x16xf32, strided<[?, ?], offset: ?>>, memref<16x?xf32, strided<[?, ?], offset: ?>>
    }
    %45 = arith.index_cast %arg8 : i32 to index
    %46 = arith.index_cast %13 : i32 to index
    %47 = arith.muli %46, %45 : index
    %48 = arith.index_cast %14 : i32 to index
    %49 = arith.addi %47, %48 : index
    %reinterpret_cast_4 = memref.reinterpret_cast %arg2 to offset: [%49], sizes: [32, 64], strides: [%45, 1] : memref<*xf32> to memref<32x64xf32, strided<[?, 1], offset: ?>>
    %50 = arith.index_cast %13 : i32 to index
    %51 = arith.addi %50, %c32 : index
    %52 = arith.index_cast %arg3 : i32 to index
    %53 = arith.minsi %51, %52 : index
    %54 = arith.subi %53, %50 : index
    %55 = arith.index_cast %14 : i32 to index
    %56 = arith.addi %55, %c64 : index
    %57 = arith.index_cast %arg4 : i32 to index
    %58 = arith.minsi %56, %57 : index
    %59 = arith.subi %58, %55 : index
    %60 = arith.minsi %54, %c32 : index
    %61 = arith.minsi %59, %c64 : index
    %subview = memref.subview %44#0[0, 0] [%60, %61] [1, 1] : memref<32x64xf32> to memref<?x?xf32, strided<[64, 1]>>
    %subview_5 = memref.subview %reinterpret_cast_4[0, 0] [%60, %61] [1, 1] : memref<32x64xf32, strided<[?, 1], offset: ?>> to memref<?x?xf32, strided<[?, 1], offset: ?>>
    memref.copy %subview, %subview_5 : memref<?x?xf32, strided<[64, 1]>> to memref<?x?xf32, strided<[?, 1], offset: ?>>
    return
  }
}

