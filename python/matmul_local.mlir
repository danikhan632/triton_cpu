#map = affine_map<(d0, d1) -> (-d0 + 32, d1)>
#map1 = affine_map<(d0, d1) -> (-d0 + 64, d1)>
#map2 = affine_map<(d0, d1, d2) -> (d0, d2)>
#map3 = affine_map<(d0, d1, d2) -> (d2, d1)>
#map4 = affine_map<(d0, d1, d2) -> (d0, d1)>
#map5 = affine_map<(d0, d1) -> (d0, d1)>
module {
  memref.global "private" constant @shared_mem_1152920405095242752 : memref<32x64xf32, 1152920405095242752> {shared_memory, shared_memory_address = 1152920405095242752 : i64, shared_memory_size = 8192 : i64}
  memref.global "private" constant @shared_mem_1152920405095234560 : memref<32x64xf32, 1152920405095234560> {shared_memory, shared_memory_address = 1152920405095234560 : i64, shared_memory_size = 8192 : i64}
  memref.global "private" constant @shared_mem_1152920405095233536 : memref<32x16xf16, 1152920405095233536> {shared_memory, shared_memory_address = 1152920405095233536 : i64, shared_memory_size = 1024 : i64}
  memref.global "private" constant @shared_mem_1152920405095231488 : memref<16x64xf16, 1152920405095231488> {shared_memory, shared_memory_address = 1152920405095231488 : i64, shared_memory_size = 2048 : i64}
  memref.global "private" constant @shared_mem_1152920405095223296 : memref<32x64xf32, 1152920405095223296> {shared_memory, shared_memory_address = 1152920405095223296 : i64, shared_memory_size = 8192 : i64}
  memref.global "private" constant @shared_mem_1152920405095219200 : memref<32x64xf16, 1152920405095219200> {shared_memory, shared_memory_address = 1152920405095219200 : i64, shared_memory_size = 4096 : i64}
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
    %0 = memref.get_global @shared_mem_1152920405095242752 : memref<32x64xf32, 1152920405095242752>
    %memspacecast = memref.memory_space_cast %0 : memref<32x64xf32, 1152920405095242752> to memref<32x64xf32>
    linalg.fill ins(%cst_1 : f32) outs(%memspacecast : memref<32x64xf32>)
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
    %15 = arith.muli %13, %c64_i32 : i32
    %16 = arith.index_cast %arg3 : i32 to index
    %17 = arith.index_cast %14 : i32 to index
    %18 = arith.index_cast %arg6 : i32 to index
    %19 = arith.muli %17, %18 : index
    %20 = arith.remsi %19, %18 : index
    %21 = arith.muli %16, %18 : index
    %22 = arith.addi %21, %20 : index
    %23 = arith.subi %22, %19 : index
    %24 = arith.divsi %23, %18 : index
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [%19], sizes: [%24, %c16], strides: [%18, %c1] : memref<*xf16> to memref<?x16xf16, strided<[?, ?], offset: ?>>
    %25 = arith.subi %c32, %24 : index
    %reinterpret_cast_2 = memref.reinterpret_cast %arg0 to offset: [%20], sizes: [%25, %c16], strides: [%18, %c1] : memref<*xf16> to memref<?x16xf16, strided<[?, ?], offset: ?>>
    %26 = arith.index_cast %arg7 : i32 to index
    %27 = arith.index_cast %arg4 : i32 to index
    %28 = arith.index_cast %15 : i32 to index
    %29 = arith.remsi %28, %27 : index
    %30 = arith.subi %28, %29 : index
    %31 = arith.addi %29, %c64 : index
    %32 = arith.minsi %31, %27 : index
    %33 = arith.subi %32, %29 : index
    %reinterpret_cast_3 = memref.reinterpret_cast %arg1 to offset: [%28], sizes: [%c16, %33], strides: [%26, %c1] : memref<*xf16> to memref<16x?xf16, strided<[?, ?], offset: ?>>
    %34 = arith.subi %c64, %33 : index
    %reinterpret_cast_4 = memref.reinterpret_cast %arg1 to offset: [%30], sizes: [%c16, %34], strides: [%26, %c1] : memref<*xf16> to memref<16x?xf16, strided<[?, ?], offset: ?>>
    %35 = arith.addi %arg5, %c15_i32 : i32
    %36 = arith.divsi %35, %c16_i32 : i32
    %37 = arith.muli %arg7, %c16_i32 : i32
    %38 = memref.get_global @shared_mem_1152920405095234560 : memref<32x64xf32, 1152920405095234560>
    %memspacecast_5 = memref.memory_space_cast %38 : memref<32x64xf32, 1152920405095234560> to memref<32x64xf32>
    memref.copy %memspacecast, %memspacecast_5 : memref<32x64xf32> to memref<32x64xf32>
    %39:7 = scf.for %arg15 = %c0_i32 to %36 step %c1_i32 iter_args(%arg16 = %memspacecast_5, %arg17 = %reinterpret_cast, %arg18 = %reinterpret_cast_3, %arg19 = %19, %arg20 = %c0, %arg21 = %reinterpret_cast_2, %arg22 = %reinterpret_cast_4) -> (memref<32x64xf32>, memref<?x16xf16, strided<[?, ?], offset: ?>>, memref<16x?xf16, strided<[?, ?], offset: ?>>, index, index, memref<?x16xf16, strided<[?, ?], offset: ?>>, memref<16x?xf16, strided<[?, ?], offset: ?>>)  : i32 {
      %52 = arith.muli %arg15, %c16_i32 : i32
      %53 = arith.subi %arg5, %52 : i32
      %54 = memref.get_global @shared_mem_1152920405095233536 : memref<32x16xf16, 1152920405095233536>
      %memspacecast_9 = memref.memory_space_cast %54 : memref<32x16xf16, 1152920405095233536> to memref<32x16xf16>
      %55 = arith.index_cast %53 : i32 to index
      %56 = arith.minsi %55, %c16 : index
      %57 = arith.cmpi slt, %56, %c16 : index
      scf.if %57 {
        linalg.fill ins(%cst_0 : f16) outs(%memspacecast_9 : memref<32x16xf16>)
      }
      %dim = memref.dim %arg17, %c0 : memref<?x16xf16, strided<[?, ?], offset: ?>>
      %58 = arith.minsi %dim, %c32 : index
      %59 = arith.subi %c32, %58 : index
      %subview_10 = memref.subview %arg17[0, 0] [%58, %56] [1, 1] : memref<?x16xf16, strided<[?, ?], offset: ?>> to memref<?x?xf16, strided<[?, ?], offset: ?>>
      %subview_11 = memref.subview %arg21[0, 0] [%59, %56] [1, 1] : memref<?x16xf16, strided<[?, ?], offset: ?>> to memref<?x?xf16, strided<[?, ?], offset: ?>>
      %subview_12 = memref.subview %memspacecast_9[0, 0] [%58, %56] [1, 1] : memref<32x16xf16> to memref<?x?xf16, strided<[16, 1]>>
      %subview_13 = memref.subview %memspacecast_9[%58, 0] [%59, %56] [1, 1] : memref<32x16xf16> to memref<?x?xf16, strided<[16, 1], offset: ?>>
      memref.copy %subview_10, %subview_12 : memref<?x?xf16, strided<[?, ?], offset: ?>> to memref<?x?xf16, strided<[16, 1]>>
      memref.copy %subview_11, %subview_13 : memref<?x?xf16, strided<[?, ?], offset: ?>> to memref<?x?xf16, strided<[16, 1], offset: ?>>
      %60 = memref.get_global @shared_mem_1152920405095231488 : memref<16x64xf16, 1152920405095231488>
      %memspacecast_14 = memref.memory_space_cast %60 : memref<16x64xf16, 1152920405095231488> to memref<16x64xf16>
      scf.if %57 {
        linalg.fill ins(%cst_0 : f16) outs(%memspacecast_14 : memref<16x64xf16>)
      }
      %dim_15 = memref.dim %arg18, %c1 : memref<16x?xf16, strided<[?, ?], offset: ?>>
      %61 = arith.minsi %dim_15, %c64 : index
      %62 = arith.subi %c64, %61 : index
      %subview_16 = memref.subview %arg18[0, 0] [%56, %61] [1, 1] : memref<16x?xf16, strided<[?, ?], offset: ?>> to memref<?x?xf16, strided<[?, ?], offset: ?>>
      %subview_17 = memref.subview %arg22[0, 0] [%56, %62] [1, 1] : memref<16x?xf16, strided<[?, ?], offset: ?>> to memref<?x?xf16, strided<[?, ?], offset: ?>>
      %subview_18 = memref.subview %memspacecast_14[0, 0] [%56, %61] [1, 1] : memref<16x64xf16> to memref<?x?xf16, strided<[64, 1]>>
      %subview_19 = memref.subview %memspacecast_14[0, %61] [%56, %62] [1, 1] : memref<16x64xf16> to memref<?x?xf16, strided<[64, 1], offset: ?>>
      memref.copy %subview_16, %subview_18 : memref<?x?xf16, strided<[?, ?], offset: ?>> to memref<?x?xf16, strided<[64, 1]>>
      memref.copy %subview_17, %subview_19 : memref<?x?xf16, strided<[?, ?], offset: ?>> to memref<?x?xf16, strided<[64, 1], offset: ?>>
      %vscale = vector.vscale
      %63 = arith.muli %vscale, %c4 : index
      %64 = arith.muli %vscale, %c4 : index
      %65 = memref.get_global @shared_mem_1152920405095223296 : memref<32x64xf32, 1152920405095223296>
      %memspacecast_20 = memref.memory_space_cast %65 : memref<32x64xf32, 1152920405095223296> to memref<32x64xf32>
      memref.copy %memspacecast, %memspacecast_20 : memref<32x64xf32> to memref<32x64xf32>
      %66 = scf.for %arg23 = %c0 to %c32 step %63 iter_args(%arg24 = %memspacecast_20) -> (memref<32x64xf32>) {
        %82 = scf.for %arg25 = %c0 to %c64 step %64 iter_args(%arg26 = %arg24) -> (memref<32x64xf32>) {
          %83 = scf.for %arg27 = %c0 to %c16 step %c2 iter_args(%arg28 = %arg26) -> (memref<32x64xf32>) {
            %84 = affine.min #map(%arg23, %63)
            %85 = affine.min #map1(%arg25, %64)
            %86 = affine.min #map(%arg23, %63)
            %87 = affine.min #map1(%arg25, %64)
            %subview_25 = memref.subview %memspacecast_9[%arg23, %arg27] [%84, 2] [1, 1] : memref<32x16xf16> to memref<?x2xf16, strided<[16, 1], offset: ?>>
            %subview_26 = memref.subview %memspacecast_14[%arg27, %arg25] [2, %85] [1, 1] : memref<16x64xf16> to memref<2x?xf16, strided<[64, 1], offset: ?>>
            %subview_27 = memref.subview %arg28[%arg23, %arg25] [%86, %87] [1, 1] : memref<32x64xf32> to memref<?x?xf32, strided<[64, 1], offset: ?>>
            %88 = vector.create_mask %84, %c2 : vector<[4]x2xi1>
            %89 = vector.transfer_read %subview_25[%c0, %c0], %cst_0, %88 {in_bounds = [true, true]} : memref<?x2xf16, strided<[16, 1], offset: ?>>, vector<[4]x2xf16>
            %90 = vector.create_mask %85 : vector<[4]xi1>
            %91 = vector.insert %90, %cst [0] : vector<[4]xi1> into vector<2x[4]xi1>
            %92 = vector.insert %90, %91 [1] : vector<[4]xi1> into vector<2x[4]xi1>
            %93 = vector.transfer_read %subview_26[%c0, %c0], %cst_0, %92 {in_bounds = [true, true]} : memref<2x?xf16, strided<[64, 1], offset: ?>>, vector<2x[4]xf16>
            %94 = vector.create_mask %84, %85 : vector<[4]x[4]xi1>
            %95 = vector.transfer_read %subview_27[%c0, %c0], %cst_1, %94 {in_bounds = [true, true]} : memref<?x?xf32, strided<[64, 1], offset: ?>>, vector<[4]x[4]xf32>
            %96 = arith.extf %89 : vector<[4]x2xf16> to vector<[4]x2xf32>
            %97 = arith.extf %93 : vector<2x[4]xf16> to vector<2x[4]xf32>
            %98 = vector.create_mask %84, %85, %c2 : vector<[4]x[4]x2xi1>
            %99 = vector.mask %98 { vector.contract {indexing_maps = [#map2, #map3, #map4], iterator_types = ["parallel", "parallel", "reduction"], kind = #vector.kind<add>} %96, %97, %95 : vector<[4]x2xf32>, vector<2x[4]xf32> into vector<[4]x[4]xf32> } : vector<[4]x[4]x2xi1> -> vector<[4]x[4]xf32>
            vector.transfer_write %99, %subview_27[%c0, %c0], %94 {in_bounds = [true, true]} : vector<[4]x[4]xf32>, memref<?x?xf32, strided<[64, 1], offset: ?>>
            %subview_28 = memref.subview %arg28[%arg23, %arg25] [%86, %87] [1, 1] : memref<32x64xf32> to memref<?x?xf32, strided<[64, 1], offset: ?>>
            memref.copy %subview_27, %subview_28 : memref<?x?xf32, strided<[64, 1], offset: ?>> to memref<?x?xf32, strided<[64, 1], offset: ?>>
            scf.yield %arg28 : memref<32x64xf32>
          }
          scf.yield %83 : memref<32x64xf32>
        }
        scf.yield %82 : memref<32x64xf32>
      }
      linalg.generic {indexing_maps = [#map5, #map5, #map5], iterator_types = ["parallel", "parallel"]} ins(%66, %arg16 : memref<32x64xf32>, memref<32x64xf32>) outs(%66 : memref<32x64xf32>) {
      ^bb0(%in: f32, %in_25: f32, %out: f32):
        %82 = arith.addf %in, %in_25 : f32
        linalg.yield %82 : f32
      }
      %67 = arith.addi %arg19, %c16 : index
      %68 = arith.remsi %67, %18 : index
      %69 = arith.addi %21, %68 : index
      %70 = arith.subi %69, %67 : index
      %71 = arith.divsi %70, %18 : index
      %reinterpret_cast_21 = memref.reinterpret_cast %arg0 to offset: [%67], sizes: [%71, %c16], strides: [%18, %c1] : memref<*xf16> to memref<?x16xf16, strided<[?, ?], offset: ?>>
      %72 = arith.subi %c32, %71 : index
      %reinterpret_cast_22 = memref.reinterpret_cast %arg0 to offset: [%68], sizes: [%72, %c16], strides: [%18, %c1] : memref<*xf16> to memref<?x16xf16, strided<[?, ?], offset: ?>>
      %73 = arith.index_cast %37 : i32 to index
      %74 = arith.addi %arg20, %73 : index
      %75 = arith.addi %74, %28 : index
      %76 = arith.remsi %75, %27 : index
      %77 = arith.subi %75, %76 : index
      %78 = arith.addi %76, %c64 : index
      %79 = arith.minsi %78, %27 : index
      %80 = arith.subi %79, %76 : index
      %reinterpret_cast_23 = memref.reinterpret_cast %arg1 to offset: [%75], sizes: [%c16, %80], strides: [%26, %c1] : memref<*xf16> to memref<16x?xf16, strided<[?, ?], offset: ?>>
      %81 = arith.subi %c64, %80 : index
      %reinterpret_cast_24 = memref.reinterpret_cast %arg1 to offset: [%77], sizes: [%c16, %81], strides: [%26, %c1] : memref<*xf16> to memref<16x?xf16, strided<[?, ?], offset: ?>>
      scf.yield %66, %reinterpret_cast_21, %reinterpret_cast_23, %67, %74, %reinterpret_cast_22, %reinterpret_cast_24 : memref<32x64xf32>, memref<?x16xf16, strided<[?, ?], offset: ?>>, memref<16x?xf16, strided<[?, ?], offset: ?>>, index, index, memref<?x16xf16, strided<[?, ?], offset: ?>>, memref<16x?xf16, strided<[?, ?], offset: ?>>
    }
    %40 = arith.index_cast %arg8 : i32 to index
    %41 = arith.muli %17, %40 : index
    %42 = arith.addi %41, %28 : index
    %reinterpret_cast_6 = memref.reinterpret_cast %arg2 to offset: [%42], sizes: [32, 64], strides: [%40, 1] : memref<*xf16> to memref<32x64xf16, strided<[?, 1], offset: ?>>
    %43 = memref.get_global @shared_mem_1152920405095219200 : memref<32x64xf16, 1152920405095219200>
    %memspacecast_7 = memref.memory_space_cast %43 : memref<32x64xf16, 1152920405095219200> to memref<32x64xf16>
    linalg.generic {indexing_maps = [#map5, #map5], iterator_types = ["parallel", "parallel"]} ins(%39#0 : memref<32x64xf32>) outs(%memspacecast_7 : memref<32x64xf16>) {
    ^bb0(%in: f32, %out: f16):
      %52 = arith.truncf %in : f32 to f16
      linalg.yield %52 : f16
    }
    %44 = arith.addi %17, %c32 : index
    %45 = arith.minsi %44, %16 : index
    %46 = arith.subi %45, %17 : index
    %47 = arith.addi %28, %c64 : index
    %48 = arith.minsi %47, %27 : index
    %49 = arith.subi %48, %28 : index
    %50 = arith.minsi %46, %c32 : index
    %51 = arith.minsi %49, %c64 : index
    %subview = memref.subview %memspacecast_7[0, 0] [%50, %51] [1, 1] : memref<32x64xf16> to memref<?x?xf16, strided<[64, 1]>>
    %subview_8 = memref.subview %reinterpret_cast_6[0, 0] [%50, %51] [1, 1] : memref<32x64xf16, strided<[?, 1], offset: ?>> to memref<?x?xf16, strided<[?, 1], offset: ?>>
    memref.copy %subview, %subview_8 : memref<?x?xf16, strided<[64, 1]>> to memref<?x?xf16, strided<[?, 1], offset: ?>>
    return
  }
}

