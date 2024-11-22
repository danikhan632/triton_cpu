#map = affine_map<(d0, d1) -> (d0, d1)>
module {
  func.func @matmul_kernel_0d1d2d34567c89c1011c(%arg0: memref<*xf16> {tt.divisibility = 16 : i32}, %arg1: memref<*xf16> {tt.divisibility = 16 : i32}, %arg2: memref<*xf16> {tt.divisibility = 16 : i32}, %arg3: i32, %arg4: i32, %arg5: i32, %arg6: i32, %arg7: i32, %arg8: i32, %arg9: i32, %arg10: i32, %arg11: i32, %arg12: i32, %arg13: i32, %arg14: i32) {
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
    %39:7 = scf.for %arg15 = %c0_i32 to %37 step %c1_i32 iter_args(%arg16 = %1, %arg17 = %reinterpret_cast, %arg18 = %reinterpret_cast_2, %arg19 = %20, %arg20 = %c0, %arg21 = %reinterpret_cast_1, %arg22 = %reinterpret_cast_3) -> (tensor<32x64xf32>, memref<?x16xf16, strided<[?, ?], offset: ?>>, memref<16x?xf16, strided<[?, ?], offset: ?>>, index, index, memref<?x16xf16, strided<[?, ?], offset: ?>>, memref<16x?xf16, strided<[?, ?], offset: ?>>)  : i32 {
      %53 = arith.muli %arg15, %c16_i32 : i32
      %54 = arith.subi %arg5, %53 : i32
      %alloc = memref.alloc() : memref<32x16xf16>
      %55 = arith.index_cast %54 : i32 to index
      %56 = arith.minsi %55, %c16 : index
      %57 = arith.cmpi slt, %56, %c16 : index
      scf.if %57 {
        linalg.fill ins(%cst : f16) outs(%alloc : memref<32x16xf16>)
      }
      %dim = memref.dim %arg17, %c0 : memref<?x16xf16, strided<[?, ?], offset: ?>>
      %58 = arith.minsi %dim, %c32 : index
      %59 = arith.subi %c32, %58 : index
      %subview_5 = memref.subview %arg17[0, 0] [%58, %56] [1, 1] : memref<?x16xf16, strided<[?, ?], offset: ?>> to memref<?x?xf16, strided<[?, ?], offset: ?>>
      %subview_6 = memref.subview %arg21[0, 0] [%59, %56] [1, 1] : memref<?x16xf16, strided<[?, ?], offset: ?>> to memref<?x?xf16, strided<[?, ?], offset: ?>>
      %subview_7 = memref.subview %alloc[0, 0] [%58, %56] [1, 1] : memref<32x16xf16> to memref<?x?xf16, strided<[16, 1]>>
      %subview_8 = memref.subview %alloc[%58, 0] [%59, %56] [1, 1] : memref<32x16xf16> to memref<?x?xf16, strided<[16, 1], offset: ?>>
      memref.copy %subview_5, %subview_7 : memref<?x?xf16, strided<[?, ?], offset: ?>> to memref<?x?xf16, strided<[16, 1]>>
      memref.copy %subview_6, %subview_8 : memref<?x?xf16, strided<[?, ?], offset: ?>> to memref<?x?xf16, strided<[16, 1], offset: ?>>
      %60 = bufferization.to_tensor %alloc restrict writable : memref<32x16xf16>
      %alloc_9 = memref.alloc() : memref<16x64xf16>
      scf.if %57 {
        linalg.fill ins(%cst : f16) outs(%alloc_9 : memref<16x64xf16>)
      }
      %dim_10 = memref.dim %arg18, %c1 : memref<16x?xf16, strided<[?, ?], offset: ?>>
      %61 = arith.minsi %dim_10, %c64 : index
      %62 = arith.subi %c64, %61 : index
      %subview_11 = memref.subview %arg18[0, 0] [%56, %61] [1, 1] : memref<16x?xf16, strided<[?, ?], offset: ?>> to memref<?x?xf16, strided<[?, ?], offset: ?>>
      %subview_12 = memref.subview %arg22[0, 0] [%56, %62] [1, 1] : memref<16x?xf16, strided<[?, ?], offset: ?>> to memref<?x?xf16, strided<[?, ?], offset: ?>>
      %subview_13 = memref.subview %alloc_9[0, 0] [%56, %61] [1, 1] : memref<16x64xf16> to memref<?x?xf16, strided<[64, 1]>>
      %subview_14 = memref.subview %alloc_9[0, %61] [%56, %62] [1, 1] : memref<16x64xf16> to memref<?x?xf16, strided<[64, 1], offset: ?>>
      memref.copy %subview_11, %subview_13 : memref<?x?xf16, strided<[?, ?], offset: ?>> to memref<?x?xf16, strided<[64, 1]>>
      memref.copy %subview_12, %subview_14 : memref<?x?xf16, strided<[?, ?], offset: ?>> to memref<?x?xf16, strided<[64, 1], offset: ?>>
      %63 = bufferization.to_tensor %alloc_9 restrict writable : memref<16x64xf16>
      %64 = linalg.matmul ins(%60, %63 : tensor<32x16xf16>, tensor<16x64xf16>) outs(%1 : tensor<32x64xf32>) -> tensor<32x64xf32>
      %65 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"]} ins(%64, %arg16 : tensor<32x64xf32>, tensor<32x64xf32>) outs(%64 : tensor<32x64xf32>) {
      ^bb0(%in: f32, %in_19: f32, %out: f32):
        %81 = arith.addf %in, %in_19 : f32
        linalg.yield %81 : f32
      } -> tensor<32x64xf32>
      %66 = arith.addi %arg19, %c16 : index
      %67 = arith.remsi %66, %19 : index
      %68 = arith.addi %22, %67 : index
      %69 = arith.subi %68, %66 : index
      %70 = arith.divsi %69, %19 : index
      %reinterpret_cast_15 = memref.reinterpret_cast %arg0 to offset: [%66], sizes: [%70, %c16], strides: [%19, %c1] : memref<*xf16> to memref<?x16xf16, strided<[?, ?], offset: ?>>
      %71 = arith.subi %c32, %70 : index
      %reinterpret_cast_16 = memref.reinterpret_cast %arg0 to offset: [%67], sizes: [%71, %c16], strides: [%19, %c1] : memref<*xf16> to memref<?x16xf16, strided<[?, ?], offset: ?>>
      %72 = arith.index_cast %38 : i32 to index
      %73 = arith.addi %arg20, %72 : index
      %74 = arith.addi %73, %29 : index
      %75 = arith.remsi %74, %28 : index
      %76 = arith.subi %74, %75 : index
      %77 = arith.addi %75, %c64 : index
      %78 = arith.minsi %77, %28 : index
      %79 = arith.subi %78, %75 : index
      %reinterpret_cast_17 = memref.reinterpret_cast %arg1 to offset: [%74], sizes: [%c16, %79], strides: [%27, %c1] : memref<*xf16> to memref<16x?xf16, strided<[?, ?], offset: ?>>
      %80 = arith.subi %c64, %79 : index
      %reinterpret_cast_18 = memref.reinterpret_cast %arg1 to offset: [%76], sizes: [%c16, %80], strides: [%27, %c1] : memref<*xf16> to memref<16x?xf16, strided<[?, ?], offset: ?>>
      scf.yield %65, %reinterpret_cast_15, %reinterpret_cast_17, %66, %73, %reinterpret_cast_16, %reinterpret_cast_18 : tensor<32x64xf32>, memref<?x16xf16, strided<[?, ?], offset: ?>>, memref<16x?xf16, strided<[?, ?], offset: ?>>, index, index, memref<?x16xf16, strided<[?, ?], offset: ?>>, memref<16x?xf16, strided<[?, ?], offset: ?>>
    }
    %40 = arith.index_cast %arg8 : i32 to index
    %41 = arith.muli %18, %40 : index
    %42 = arith.addi %41, %29 : index
    %reinterpret_cast_4 = memref.reinterpret_cast %arg2 to offset: [%42], sizes: [32, 64], strides: [%40, 1] : memref<*xf16> to memref<32x64xf16, strided<[?, 1], offset: ?>>
    %43 = tensor.empty() : tensor<32x64xf16>
    %44 = linalg.generic {indexing_maps = [#map, #map], iterator_types = ["parallel", "parallel"]} ins(%39#0 : tensor<32x64xf32>) outs(%43 : tensor<32x64xf16>) {
    ^bb0(%in: f32, %out: f16):
      %53 = arith.truncf %in : f32 to f16
      linalg.yield %53 : f16
    } -> tensor<32x64xf16>
    %45 = arith.addi %18, %c32 : index
    %46 = arith.minsi %45, %17 : index
    %47 = arith.subi %46, %18 : index
    %48 = arith.addi %29, %c64 : index
    %49 = arith.minsi %48, %28 : index
    %50 = arith.subi %49, %29 : index
    %51 = arith.minsi %47, %c32 : index
    %52 = arith.minsi %50, %c64 : index
    %extracted_slice = tensor.extract_slice %44[0, 0] [%51, %52] [1, 1] : tensor<32x64xf16> to tensor<?x?xf16>
    %subview = memref.subview %reinterpret_cast_4[0, 0] [%51, %52] [1, 1] : memref<32x64xf16, strided<[?, 1], offset: ?>> to memref<?x?xf16, strided<[?, 1], offset: ?>>
    bufferization.materialize_in_destination %extracted_slice in writable %subview : (tensor<?x?xf16>, memref<?x?xf16, strided<[?, 1], offset: ?>>) -> ()
    return
  }
}