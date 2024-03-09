#map = affine_map<(d0, d1) -> (-d0 + 32, d1)>
#map1 = affine_map<(d0, d1) -> (-d0 + 64, d1)>
#map2 = affine_map<(d0, d1) -> (d0, 0, d1)>
#map3 = affine_map<(d0, d1) -> (0, d1, d0)>
#map4 = affine_map<(d0, d1, d2) -> (d0, d1, d2)>
#map5 = affine_map<(d0, d1, d2) -> (d0, d1)>
#map6 = affine_map<(d0, d1) -> (d0, d1)>
module {
  func.func @matmul_kernel_0d1d2d34567c89c1011c(%arg0: memref<*xf16> {tt.divisibility = 16 : i32}, %arg1: memref<*xf16> {tt.divisibility = 16 : i32}, %arg2: memref<*xf16> {tt.divisibility = 16 : i32}, %arg3: i32, %arg4: i32, %arg5: i32, %arg6: i32, %arg7: i32, %arg8: i32, %arg9: i32, %arg10: i32, %arg11: i32, %arg12: i32, %arg13: i32, %arg14: i32) {
    %c4 = arith.constant 4 : index
    %cst = arith.constant 0.000000e+00 : f16
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
    %0 = tensor.empty() : tensor<32x64xf32>
    %1 = linalg.fill ins(%cst_0 : f32) outs(%0 : tensor<32x64xf32>) -> tensor<32x64xf32>
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
    %reinterpret_cast_1 = memref.reinterpret_cast %arg0 to offset: [%21], sizes: [%26, %c16], strides: [%19, %c1] : memref<*xf16> to memref<?x16xf16, strided<[?, ?], offset: ?>>
    %27 = arith.index_cast %arg7 : i32 to index
    %28 = arith.index_cast %arg4 : i32 to index
    %29 = arith.index_cast %16 : i32 to index
    %30 = arith.remsi %29, %28 : index
    %31 = arith.subi %29, %30 : index
    %32 = arith.addi %30, %c64 : index
    %33 = arith.minsi %32, %28 : index
    %34 = arith.subi %33, %30 : index
    %reinterpret_cast_2 = memref.reinterpret_cast %arg1 to offset: [%29], sizes: [%c16, %34], strides: [%27, %c1] : memref<*xf16> to memref<16x?xf16, strided<[?, ?], offset: ?>>
    %35 = arith.subi %c64, %34 : index
    %reinterpret_cast_3 = memref.reinterpret_cast %arg1 to offset: [%31], sizes: [%c16, %35], strides: [%27, %c1] : memref<*xf16> to memref<16x?xf16, strided<[?, ?], offset: ?>>
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
    %46:7 = scf.for %arg15 = %c0_i32 to %37 step %c1_i32 iter_args(%arg16 = %1, %arg17 = %reinterpret_cast, %arg18 = %reinterpret_cast_2, %arg19 = %42, %arg20 = %c0, %arg21 = %reinterpret_cast_1, %arg22 = %reinterpret_cast_3) -> (tensor<32x64xf32>, memref<?x16xf16, strided<[?, ?], offset: ?>>, memref<16x?xf16, strided<[?, ?], offset: ?>>, index, index, memref<?x16xf16, strided<[?, ?], offset: ?>>, memref<16x?xf16, strided<[?, ?], offset: ?>>)  : i32 {
      %66 = arith.muli %arg15, %c16_i32 : i32
      %67 = arith.subi %arg5, %66 : i32
      %alloc = memref.alloc() : memref<32x16xf16>
      %68 = arith.index_cast %67 : i32 to index
      %69 = arith.minsi %68, %c16 : index
      %70 = arith.cmpi slt, %69, %c16 : index
      scf.if %70 {
        linalg.fill ins(%cst : f16) outs(%alloc : memref<32x16xf16>)
      }
      %dim = memref.dim %arg17, %c0 : memref<?x16xf16, strided<[?, ?], offset: ?>>
      %71 = arith.minsi %dim, %c32 : index
      %72 = arith.subi %c32, %71 : index
      %subview_5 = memref.subview %arg17[0, 0] [%71, %69] [1, 1] : memref<?x16xf16, strided<[?, ?], offset: ?>> to memref<?x?xf16, strided<[?, ?], offset: ?>>
      %subview_6 = memref.subview %arg21[0, 0] [%72, %69] [1, 1] : memref<?x16xf16, strided<[?, ?], offset: ?>> to memref<?x?xf16, strided<[?, ?], offset: ?>>
      %subview_7 = memref.subview %alloc[0, 0] [%71, %69] [1, 1] : memref<32x16xf16> to memref<?x?xf16, strided<[16, 1]>>
      %subview_8 = memref.subview %alloc[%71, 0] [%72, %69] [1, 1] : memref<32x16xf16> to memref<?x?xf16, strided<[16, 1], offset: ?>>
      memref.copy %subview_5, %subview_7 : memref<?x?xf16, strided<[?, ?], offset: ?>> to memref<?x?xf16, strided<[16, 1]>>
      memref.copy %subview_6, %subview_8 : memref<?x?xf16, strided<[?, ?], offset: ?>> to memref<?x?xf16, strided<[16, 1], offset: ?>>
      %73 = bufferization.to_tensor %alloc restrict writable : memref<32x16xf16>
      %alloc_9 = memref.alloc() : memref<16x64xf16>
      %74 = arith.index_cast %67 : i32 to index
      %75 = arith.minsi %74, %c16 : index
      %76 = arith.cmpi slt, %75, %c16 : index
      scf.if %76 {
        linalg.fill ins(%cst : f16) outs(%alloc_9 : memref<16x64xf16>)
      }
      %dim_10 = memref.dim %arg18, %c1 : memref<16x?xf16, strided<[?, ?], offset: ?>>
      %77 = arith.minsi %dim_10, %c64 : index
      %78 = arith.subi %c64, %77 : index
      %subview_11 = memref.subview %arg18[0, 0] [%75, %77] [1, 1] : memref<16x?xf16, strided<[?, ?], offset: ?>> to memref<?x?xf16, strided<[?, ?], offset: ?>>
      %subview_12 = memref.subview %arg22[0, 0] [%75, %78] [1, 1] : memref<16x?xf16, strided<[?, ?], offset: ?>> to memref<?x?xf16, strided<[?, ?], offset: ?>>
      %subview_13 = memref.subview %alloc_9[0, 0] [%75, %77] [1, 1] : memref<16x64xf16> to memref<?x?xf16, strided<[64, 1]>>
      %subview_14 = memref.subview %alloc_9[0, %77] [%75, %78] [1, 1] : memref<16x64xf16> to memref<?x?xf16, strided<[64, 1], offset: ?>>
      memref.copy %subview_11, %subview_13 : memref<?x?xf16, strided<[?, ?], offset: ?>> to memref<?x?xf16, strided<[64, 1]>>
      memref.copy %subview_12, %subview_14 : memref<?x?xf16, strided<[?, ?], offset: ?>> to memref<?x?xf16, strided<[64, 1], offset: ?>>
      %79 = bufferization.to_tensor %alloc_9 restrict writable : memref<16x64xf16>
      %80 = tensor.empty() : tensor<32x64xf32>
      %81 = linalg.fill ins(%cst_0 : f32) outs(%80 : tensor<32x64xf32>) -> tensor<32x64xf32>
      %82 = vector.vscale
      %83 = arith.muli %82, %c4 : index
      %84 = arith.muli %82, %c4 : index
      %85 = scf.for %arg23 = %c0 to %c32 step %83 iter_args(%arg24 = %81) -> (tensor<32x64xf32>) {
        %103 = scf.for %arg25 = %c0 to %c64 step %84 iter_args(%arg26 = %arg24) -> (tensor<32x64xf32>) {
          %104 = scf.for %arg27 = %c0 to %c16 step %c1 iter_args(%arg28 = %arg26) -> (tensor<32x64xf32>) {
            %105 = affine.min #map(%arg23, %83)
            %106 = affine.min #map1(%arg25, %84)
            %107 = affine.min #map(%arg23, %83)
            %108 = affine.min #map1(%arg25, %84)
            %extracted_slice_19 = tensor.extract_slice %73[%arg23, %arg27] [%105, 1] [1, 1] : tensor<32x16xf16> to tensor<?x1xf16>
            %extracted_slice_20 = tensor.extract_slice %79[%arg27, %arg25] [1, %106] [1, 1] : tensor<16x64xf16> to tensor<1x?xf16>
            %extracted_slice_21 = tensor.extract_slice %arg28[%arg23, %arg25] [%107, %108] [1, 1] : tensor<32x64xf32> to tensor<?x?xf32>
            %109 = vector.create_mask %105, %c1 : vector<[4]x1xi1>
            %110 = vector.transfer_read %extracted_slice_19[%c0, %c0], %cst, %109 {in_bounds = [true, true, true], permutation_map = #map2} : tensor<?x1xf16>, vector<[4]x[4]x1xf16>
            %111 = vector.create_mask %c1, %106 : vector<1x[4]xi1>
            %112 = vector.transfer_read %extracted_slice_20[%c0, %c0], %cst, %111 {in_bounds = [true, true, true], permutation_map = #map3} : tensor<1x?xf16>, vector<[4]x[4]x1xf16>
            %113 = vector.create_mask %105, %106 : vector<[4]x[4]xi1>
            %114 = vector.transfer_read %extracted_slice_21[%c0, %c0], %cst_0, %113 {in_bounds = [true, true]} : tensor<?x?xf32>, vector<[4]x[4]xf32>
            %115 = arith.extf %110 : vector<[4]x[4]x1xf16> to vector<[4]x[4]x1xf32>
            %116 = arith.extf %112 : vector<[4]x[4]x1xf16> to vector<[4]x[4]x1xf32>
            %117 = vector.create_mask %105, %106, %c1 : vector<[4]x[4]x1xi1>
            %118 = vector.mask %117 { vector.contract {indexing_maps = [#map4, #map4, #map5], iterator_types = ["parallel", "parallel", "reduction"], kind = #vector.kind<add>} %115, %116, %114 : vector<[4]x[4]x1xf32>, vector<[4]x[4]x1xf32> into vector<[4]x[4]xf32> } : vector<[4]x[4]x1xi1> -> vector<[4]x[4]xf32>
            %119 = vector.transfer_write %118, %extracted_slice_21[%c0, %c0], %113 {in_bounds = [true, true]} : vector<[4]x[4]xf32>, tensor<?x?xf32>
            %inserted_slice = tensor.insert_slice %119 into %arg28[%arg23, %arg25] [%107, %108] [1, 1] : tensor<?x?xf32> into tensor<32x64xf32>
            scf.yield %inserted_slice : tensor<32x64xf32>
          }
          scf.yield %104 : tensor<32x64xf32>
        }
        scf.yield %103 : tensor<32x64xf32>
      }
      %86 = linalg.generic {indexing_maps = [#map6, #map6, #map6], iterator_types = ["parallel", "parallel"]} ins(%85, %arg16 : tensor<32x64xf32>, tensor<32x64xf32>) outs(%85 : tensor<32x64xf32>) {
      ^bb0(%in: f32, %in_19: f32, %out: f32):
        %103 = arith.addf %in, %in_19 : f32
        linalg.yield %103 : f32
      } -> tensor<32x64xf32>
      %87 = arith.addi %arg19, %c16 : index
      %88 = arith.remsi %87, %41 : index
      %89 = arith.muli %39, %41 : index
      %90 = arith.addi %89, %88 : index
      %91 = arith.subi %90, %87 : index
      %92 = arith.divsi %91, %41 : index
      %reinterpret_cast_15 = memref.reinterpret_cast %arg0 to offset: [%87], sizes: [%92, %c16], strides: [%41, %c1] : memref<*xf16> to memref<?x16xf16, strided<[?, ?], offset: ?>>
      %93 = arith.subi %c32, %92 : index
      %reinterpret_cast_16 = memref.reinterpret_cast %arg0 to offset: [%88], sizes: [%93, %c16], strides: [%41, %c1] : memref<*xf16> to memref<?x16xf16, strided<[?, ?], offset: ?>>
      %94 = arith.index_cast %38 : i32 to index
      %95 = arith.addi %arg20, %94 : index
      %96 = arith.addi %95, %45 : index
      %97 = arith.remsi %96, %44 : index
      %98 = arith.subi %96, %97 : index
      %99 = arith.addi %97, %c64 : index
      %100 = arith.minsi %99, %44 : index
      %101 = arith.subi %100, %97 : index
      %reinterpret_cast_17 = memref.reinterpret_cast %arg1 to offset: [%96], sizes: [%c16, %101], strides: [%43, %c1] : memref<*xf16> to memref<16x?xf16, strided<[?, ?], offset: ?>>
      %102 = arith.subi %c64, %101 : index
      %reinterpret_cast_18 = memref.reinterpret_cast %arg1 to offset: [%98], sizes: [%c16, %102], strides: [%43, %c1] : memref<*xf16> to memref<16x?xf16, strided<[?, ?], offset: ?>>
      scf.yield %86, %reinterpret_cast_15, %reinterpret_cast_17, %87, %95, %reinterpret_cast_16, %reinterpret_cast_18 : tensor<32x64xf32>, memref<?x16xf16, strided<[?, ?], offset: ?>>, memref<16x?xf16, strided<[?, ?], offset: ?>>, index, index, memref<?x16xf16, strided<[?, ?], offset: ?>>, memref<16x?xf16, strided<[?, ?], offset: ?>>
    }
    %47 = arith.index_cast %arg8 : i32 to index
    %48 = arith.index_cast %15 : i32 to index
    %49 = arith.muli %48, %47 : index
    %50 = arith.index_cast %16 : i32 to index
    %51 = arith.addi %49, %50 : index
    %reinterpret_cast_4 = memref.reinterpret_cast %arg2 to offset: [%51], sizes: [32, 64], strides: [%47, 1] : memref<*xf16> to memref<32x64xf16, strided<[?, 1], offset: ?>>
    %52 = tensor.empty() : tensor<32x64xf16>
    %53 = linalg.generic {indexing_maps = [#map6, #map6], iterator_types = ["parallel", "parallel"]} ins(%46#0 : tensor<32x64xf32>) outs(%52 : tensor<32x64xf16>) {
    ^bb0(%in: f32, %out: f16):
      %66 = arith.truncf %in : f32 to f16
      linalg.yield %66 : f16
    } -> tensor<32x64xf16>
    %54 = arith.index_cast %15 : i32 to index
    %55 = arith.addi %54, %c32 : index
    %56 = arith.index_cast %arg3 : i32 to index
    %57 = arith.minsi %55, %56 : index
    %58 = arith.subi %57, %54 : index
    %59 = arith.index_cast %16 : i32 to index
    %60 = arith.addi %59, %c64 : index
    %61 = arith.index_cast %arg4 : i32 to index
    %62 = arith.minsi %60, %61 : index
    %63 = arith.subi %62, %59 : index
    %64 = arith.minsi %58, %c32 : index
    %65 = arith.minsi %63, %c64 : index
    %extracted_slice = tensor.extract_slice %53[0, 0] [%64, %65] [1, 1] : tensor<32x64xf16> to tensor<?x?xf16>
    %subview = memref.subview %reinterpret_cast_4[0, 0] [%64, %65] [1, 1] : memref<32x64xf16, strided<[?, 1], offset: ?>> to memref<?x?xf16, strided<[?, 1], offset: ?>>
    bufferization.materialize_in_destination %extracted_slice in writable %subview : (tensor<?x?xf16>, memref<?x?xf16, strided<[?, 1], offset: ?>>) -> ()
    return
  }
}