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
    %16 = arith.index_cast %15 : i32 to index
    %17 = arith.muli %14, %c64_i32 : i32
    %18 = arith.index_cast %17 : i32 to index
    %19 = arith.index_cast %arg3 : i32 to index
    %20 = arith.index_cast %arg6 : i32 to index
    %21 = arith.muli %16, %20 : index
    %22 = arith.muli %19, %20 : index
    %23 = arith.index_cast %arg7 : i32 to index
    %24 = arith.index_cast %arg4 : i32 to index
    %25 = arith.addi %arg5, %c15_i32 : i32
    %26 = arith.divsi %25, %c16_i32 : i32
    %27 = arith.muli %arg7, %c16_i32 : i32
    %28 = arith.index_cast %27 : i32 to index
    %29:3 = scf.for %arg15 = %c0_i32 to %26 step %c1_i32 iter_args(%arg16 = %1, %arg17 = %21, %arg18 = %c0) -> (tensor<32x64xf32>, index, index)  : i32 {
      %43 = arith.addi %arg18, %18 : index
      %44 = arith.remsi %43, %24 : index
      %45 = arith.subi %43, %44 : index
      %46 = arith.addi %44, %c64 : index
      %47 = arith.minsi %46, %24 : index
      %48 = arith.subi %47, %44 : index
      %reinterpret_cast_2 = memref.reinterpret_cast %arg1 to offset: [%43], sizes: [%c16, %48], strides: [%23, %c1] : memref<*xf16> to memref<16x?xf16, strided<[?, ?], offset: ?>>
      %49 = arith.subi %c64, %48 : index
      %reinterpret_cast_3 = memref.reinterpret_cast %arg1 to offset: [%45], sizes: [%c16, %49], strides: [%23, %c1] : memref<*xf16> to memref<16x?xf16, strided<[?, ?], offset: ?>>
      %50 = arith.remsi %arg17, %20 : index
      %51 = arith.addi %22, %50 : index
      %52 = arith.subi %51, %arg17 : index
      %53 = arith.divsi %52, %20 : index
      %reinterpret_cast_4 = memref.reinterpret_cast %arg0 to offset: [%arg17], sizes: [%53, %c16], strides: [%20, %c1] : memref<*xf16> to memref<?x16xf16, strided<[?, ?], offset: ?>>
      %54 = arith.subi %c32, %53 : index
      %reinterpret_cast_5 = memref.reinterpret_cast %arg0 to offset: [%50], sizes: [%54, %c16], strides: [%20, %c1] : memref<*xf16> to memref<?x16xf16, strided<[?, ?], offset: ?>>
      %55 = arith.muli %arg15, %c16_i32 : i32
      %56 = arith.subi %arg5, %55 : i32
      %57 = arith.index_cast %56 : i32 to index
      %58 = arith.minsi %57, %c16 : index
      %alloc = memref.alloc() : memref<32x16xf16>
      %59 = arith.cmpi slt, %58, %c16 : index
      scf.if %59 {
        linalg.fill ins(%cst_1 : f16) outs(%alloc : memref<32x16xf16>)
      }
      %60 = arith.minsi %53, %c32 : index
      %61 = arith.subi %c32, %60 : index
      %subview_6 = memref.subview %reinterpret_cast_4[0, 0] [%60, %58] [1, 1] : memref<?x16xf16, strided<[?, ?], offset: ?>> to memref<?x?xf16, strided<[?, ?], offset: ?>>
      %subview_7 = memref.subview %reinterpret_cast_5[0, 0] [%61, %58] [1, 1] : memref<?x16xf16, strided<[?, ?], offset: ?>> to memref<?x?xf16, strided<[?, ?], offset: ?>>
      %subview_8 = memref.subview %alloc[0, 0] [%60, %58] [1, 1] : memref<32x16xf16> to memref<?x?xf16, strided<[16, 1]>>
      %subview_9 = memref.subview %alloc[%60, 0] [%61, %58] [1, 1] : memref<32x16xf16> to memref<?x?xf16, strided<[16, 1], offset: ?>>
      memref.copy %subview_6, %subview_8 : memref<?x?xf16, strided<[?, ?], offset: ?>> to memref<?x?xf16, strided<[16, 1]>>
      memref.copy %subview_7, %subview_9 : memref<?x?xf16, strided<[?, ?], offset: ?>> to memref<?x?xf16, strided<[16, 1], offset: ?>>
      %62 = bufferization.to_tensor %alloc restrict writable : memref<32x16xf16>
      %alloc_10 = memref.alloc() : memref<16x64xf16>
      %63 = arith.cmpi slt, %58, %c16 : index
      scf.if %63 {
        linalg.fill ins(%cst_1 : f16) outs(%alloc_10 : memref<16x64xf16>)
      }
      %64 = arith.minsi %48, %c64 : index
      %65 = arith.subi %c64, %64 : index
      %subview_11 = memref.subview %reinterpret_cast_2[0, 0] [%58, %64] [1, 1] : memref<16x?xf16, strided<[?, ?], offset: ?>> to memref<?x?xf16, strided<[?, ?], offset: ?>>
      %subview_12 = memref.subview %reinterpret_cast_3[0, 0] [%58, %65] [1, 1] : memref<16x?xf16, strided<[?, ?], offset: ?>> to memref<?x?xf16, strided<[?, ?], offset: ?>>
      %subview_13 = memref.subview %alloc_10[0, 0] [%58, %64] [1, 1] : memref<16x64xf16> to memref<?x?xf16, strided<[64, 1]>>
      %subview_14 = memref.subview %alloc_10[0, %64] [%58, %65] [1, 1] : memref<16x64xf16> to memref<?x?xf16, strided<[64, 1], offset: ?>>
      memref.copy %subview_11, %subview_13 : memref<?x?xf16, strided<[?, ?], offset: ?>> to memref<?x?xf16, strided<[64, 1]>>
      memref.copy %subview_12, %subview_14 : memref<?x?xf16, strided<[?, ?], offset: ?>> to memref<?x?xf16, strided<[64, 1], offset: ?>>
      %66 = bufferization.to_tensor %alloc_10 restrict writable : memref<16x64xf16>
      %67 = vector.vscale
      %68 = arith.muli %67, %c4 : index
      %69 = arith.muli %67, %c4 : index
      %70 = scf.for %arg19 = %c0 to %c32 step %68 iter_args(%arg20 = %1) -> (tensor<32x64xf32>) {
        %74 = scf.for %arg21 = %c0 to %c64 step %69 iter_args(%arg22 = %arg20) -> (tensor<32x64xf32>) {
          %75 = scf.for %arg23 = %c0 to %c16 step %c1 iter_args(%arg24 = %arg22) -> (tensor<32x64xf32>) {
            %76 = affine.min #map(%arg19, %68)
            %77 = affine.min #map1(%arg21, %69)
            %78 = affine.min #map(%arg19, %68)
            %79 = affine.min #map1(%arg21, %69)
            %extracted_slice_15 = tensor.extract_slice %62[%arg19, %arg23] [%76, 1] [1, 1] : tensor<32x16xf16> to tensor<?x1xf16>
            %extracted_slice_16 = tensor.extract_slice %66[%arg23, %arg21] [1, %77] [1, 1] : tensor<16x64xf16> to tensor<1x?xf16>
            %extracted_slice_17 = tensor.extract_slice %arg24[%arg19, %arg21] [%78, %79] [1, 1] : tensor<32x64xf32> to tensor<?x?xf32>
            %80 = vector.create_mask %76, %c1 : vector<[4]x1xi1>
            %81 = vector.transfer_read %extracted_slice_15[%c0, %c0], %cst_1, %80 {in_bounds = [true, true, true], permutation_map = #map2} : tensor<?x1xf16>, vector<[4]x[4]x1xf16>
            %82 = vector.create_mask %77 : vector<[4]xi1>
            %83 = vector.insert %82, %cst [0] : vector<[4]xi1> into vector<1x[4]xi1>
            %84 = vector.transfer_read %extracted_slice_16[%c0, %c0], %cst_1, %83 {in_bounds = [true, true, true], permutation_map = #map3} : tensor<1x?xf16>, vector<[4]x[4]x1xf16>
            %85 = vector.create_mask %76, %77 : vector<[4]x[4]xi1>
            %86 = vector.transfer_read %extracted_slice_17[%c0, %c0], %cst_0, %85 {in_bounds = [true, true]} : tensor<?x?xf32>, vector<[4]x[4]xf32>
            %87 = arith.extf %81 : vector<[4]x[4]x1xf16> to vector<[4]x[4]x1xf32>
            %88 = arith.extf %84 : vector<[4]x[4]x1xf16> to vector<[4]x[4]x1xf32>
            %89 = vector.create_mask %76, %77, %c1 : vector<[4]x[4]x1xi1>
            %90 = vector.mask %89 { vector.contract {indexing_maps = [#map4, #map4, #map5], iterator_types = ["parallel", "parallel", "reduction"], kind = #vector.kind<add>} %87, %88, %86 : vector<[4]x[4]x1xf32>, vector<[4]x[4]x1xf32> into vector<[4]x[4]xf32> } : vector<[4]x[4]x1xi1> -> vector<[4]x[4]xf32>
            %91 = vector.transfer_write %90, %extracted_slice_17[%c0, %c0], %85 {in_bounds = [true, true]} : vector<[4]x[4]xf32>, tensor<?x?xf32>
            %inserted_slice = tensor.insert_slice %91 into %arg24[%arg19, %arg21] [%78, %79] [1, 1] : tensor<?x?xf32> into tensor<32x64xf32>
            scf.yield %inserted_slice : tensor<32x64xf32>
          }
          scf.yield %75 : tensor<32x64xf32>
        }
        scf.yield %74 : tensor<32x64xf32>
      }
      %71 = linalg.generic {indexing_maps = [#map6, #map6, #map6], iterator_types = ["parallel", "parallel"]} ins(%70, %arg16 : tensor<32x64xf32>, tensor<32x64xf32>) outs(%70 : tensor<32x64xf32>) {
      ^bb0(%in: f32, %in_15: f32, %out: f32):
        %74 = arith.addf %in, %in_15 : f32
        linalg.yield %74 : f32
      } -> tensor<32x64xf32>
      %72 = arith.addi %arg17, %c16 : index
      %73 = arith.addi %arg18, %28 : index
      scf.yield %71, %72, %73 : tensor<32x64xf32>, index, index
    }
    %30 = arith.index_cast %arg8 : i32 to index
    %31 = arith.muli %16, %30 : index
    %32 = arith.addi %31, %18 : index
    %reinterpret_cast = memref.reinterpret_cast %arg2 to offset: [%32], sizes: [32, 64], strides: [%30, 1] : memref<*xf16> to memref<32x64xf16, strided<[?, 1], offset: ?>>
    %33 = tensor.empty() : tensor<32x64xf16>
    %34 = linalg.generic {indexing_maps = [#map6, #map6], iterator_types = ["parallel", "parallel"]} ins(%29#0 : tensor<32x64xf32>) outs(%33 : tensor<32x64xf16>) {
    ^bb0(%in: f32, %out: f16):
      %43 = arith.truncf %in : f32 to f16
      linalg.yield %43 : f16
    } -> tensor<32x64xf16>
    %35 = arith.addi %16, %c32 : index
    %36 = arith.minsi %35, %19 : index
    %37 = arith.subi %36, %16 : index
    %38 = arith.addi %18, %c64 : index
    %39 = arith.minsi %38, %24 : index
    %40 = arith.subi %39, %18 : index
    %41 = arith.minsi %37, %c32 : index
    %42 = arith.minsi %40, %c64 : index
    %extracted_slice = tensor.extract_slice %34[0, 0] [%41, %42] [1, 1] : tensor<32x64xf16> to tensor<?x?xf16>
    %subview = memref.subview %reinterpret_cast[0, 0] [%41, %42] [1, 1] : memref<32x64xf16, strided<[?, 1], offset: ?>> to memref<?x?xf16, strided<[?, 1], offset: ?>>
    bufferization.materialize_in_destination %extracted_slice in writable %subview : (tensor<?x?xf16>, memref<?x?xf16, strided<[?, 1], offset: ?>>) -> ()
    return
  }
}