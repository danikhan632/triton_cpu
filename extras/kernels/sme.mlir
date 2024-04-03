#map = affine_map<()[s0] -> (s0 * 16)>
#map1 = affine_map<(d0, d1) -> (-d0 + 32, d1)>
#map2 = affine_map<(d0, d1) -> (-d0 + 64, d1)>
#map3 = affine_map<()[s0, s1] -> (s0 * 16 + s1)>
#map4 = affine_map<()[s0, s1] -> (s0 * 64 + s1)>
#map5 = affine_map<(d0)[s0] -> (d0 * 16 + s0)>
#map6 = affine_map<(d0)[s0] -> (d0 + s0)>
module {
  func.func @matmul_kernel_0d1d2d34567c89c1011c(%arg0: memref<*xf16> {tt.divisibility = 16 : i32}, %arg1: memref<*xf16> {tt.divisibility = 16 : i32}, %arg2: memref<*xf16> {tt.divisibility = 16 : i32}, %arg3: i32, %arg4: i32, %arg5: i32, %arg6: i32, %arg7: i32, %arg8: i32, %arg9: i32, %arg10: i32, %arg11: i32, %arg12: i32, %arg13: i32, %arg14: i32) attributes {arm_sme.tiles_in_use = 34952 : i32} {
    %cst = arith.constant dense<0.000000e+00> : vector<[4]xf16>
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
    scf.for %arg15 = %c0 to %c32 step %c1 {
      scf.for %arg16 = %c0 to %c64 step %c1 {
        memref.store %cst_0, %alloc[%arg15, %arg16] : memref<32x64xf32>
      }
    }
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
    %14 = arith.index_cast %13 : i32 to index
    %15 = arith.muli %12, %c64_i32 : i32
    %16 = arith.index_cast %15 : i32 to index
    %17 = arith.index_cast %arg3 : i32 to index
    %18 = arith.index_cast %arg6 : i32 to index
    %19 = arith.muli %14, %18 : index
    %20 = arith.muli %17, %18 : index
    %21 = arith.index_cast %arg7 : i32 to index
    %22 = arith.index_cast %arg4 : i32 to index
    %23 = arith.addi %arg5, %c15_i32 : i32
    %24 = arith.divsi %23, %c16_i32 : i32
    %25 = arith.muli %arg7, %c16_i32 : i32
    %26 = arith.index_cast %25 : i32 to index
    %alloc_2 = memref.alloc() {alignment = 64 : i64} : memref<32x64xf32>
    memref.copy %alloc, %alloc_2 : memref<32x64xf32> to memref<32x64xf32>
    %27:3 = scf.for %arg15 = %c0_i32 to %24 step %c1_i32 iter_args(%arg16 = %alloc_2, %arg17 = %19, %arg18 = %c0) -> (memref<32x64xf32>, index, index)  : i32 {
      %39 = arith.addi %arg18, %16 : index
      %40 = arith.remsi %39, %22 : index
      %41 = arith.subi %39, %40 : index
      %42 = arith.addi %40, %c64 : index
      %43 = arith.minsi %42, %22 : index
      %44 = arith.subi %43, %40 : index
      %reinterpret_cast_6 = memref.reinterpret_cast %arg1 to offset: [%39], sizes: [%c16, %44], strides: [%21, %c1] : memref<*xf16> to memref<16x?xf16, strided<[?, ?], offset: ?>>
      %45 = arith.subi %c64, %44 : index
      %reinterpret_cast_7 = memref.reinterpret_cast %arg1 to offset: [%41], sizes: [%c16, %45], strides: [%21, %c1] : memref<*xf16> to memref<16x?xf16, strided<[?, ?], offset: ?>>
      %46 = arith.remsi %arg17, %18 : index
      %47 = arith.addi %20, %46 : index
      %48 = arith.subi %47, %arg17 : index
      %49 = arith.divsi %48, %18 : index
      %reinterpret_cast_8 = memref.reinterpret_cast %arg0 to offset: [%arg17], sizes: [%49, %c16], strides: [%18, %c1] : memref<*xf16> to memref<?x16xf16, strided<[?, ?], offset: ?>>
      %50 = arith.subi %c32, %49 : index
      %reinterpret_cast_9 = memref.reinterpret_cast %arg0 to offset: [%46], sizes: [%50, %c16], strides: [%18, %c1] : memref<*xf16> to memref<?x16xf16, strided<[?, ?], offset: ?>>
      %51 = arith.muli %arg15, %c16_i32 : i32
      %52 = arith.subi %arg5, %51 : i32
      %53 = arith.index_cast %52 : i32 to index
      %54 = arith.minsi %53, %c16 : index
      %alloc_10 = memref.alloc() : memref<32x16xf16>
      %55 = arith.cmpi slt, %54, %c16 : index
      scf.if %55 {
        scf.for %arg19 = %c0 to %c32 step %c1 {
          scf.for %arg20 = %c0 to %c16 step %c1 {
            memref.store %cst_1, %alloc_10[%arg19, %arg20] : memref<32x16xf16>
          }
        }
      }
      %56 = arith.minsi %49, %c32 : index
      %57 = arith.subi %c32, %56 : index
      %base_buffer_11, %offset_12, %sizes_13:2, %strides_14:2 = memref.extract_strided_metadata %reinterpret_cast_8 : memref<?x16xf16, strided<[?, ?], offset: ?>> -> memref<f16>, index, index, index, index, index
      %reinterpret_cast_15 = memref.reinterpret_cast %base_buffer_11 to offset: [%offset_12], sizes: [%56, %54], strides: [%strides_14#0, %strides_14#1] : memref<f16> to memref<?x?xf16, strided<[?, ?], offset: ?>>
      %base_buffer_16, %offset_17, %sizes_18:2, %strides_19:2 = memref.extract_strided_metadata %reinterpret_cast_9 : memref<?x16xf16, strided<[?, ?], offset: ?>> -> memref<f16>, index, index, index, index, index
      %reinterpret_cast_20 = memref.reinterpret_cast %base_buffer_16 to offset: [%offset_17], sizes: [%57, %54], strides: [%strides_19#0, %strides_19#1] : memref<f16> to memref<?x?xf16, strided<[?, ?], offset: ?>>
      %reinterpret_cast_21 = memref.reinterpret_cast %alloc_10 to offset: [0], sizes: [%56, %54], strides: [16, 1] : memref<32x16xf16> to memref<?x?xf16, strided<[16, 1]>>
      %58 = affine.apply #map()[%56]
      %reinterpret_cast_22 = memref.reinterpret_cast %alloc_10 to offset: [%58], sizes: [%57, %54], strides: [16, 1] : memref<32x16xf16> to memref<?x?xf16, strided<[16, 1], offset: ?>>
      memref.copy %reinterpret_cast_15, %reinterpret_cast_21 : memref<?x?xf16, strided<[?, ?], offset: ?>> to memref<?x?xf16, strided<[16, 1]>>
      memref.copy %reinterpret_cast_20, %reinterpret_cast_22 : memref<?x?xf16, strided<[?, ?], offset: ?>> to memref<?x?xf16, strided<[16, 1], offset: ?>>
      %alloc_23 = memref.alloc() : memref<16x64xf16>
      %59 = arith.cmpi slt, %54, %c16 : index
      scf.if %59 {
        scf.for %arg19 = %c0 to %c16 step %c1 {
          scf.for %arg20 = %c0 to %c64 step %c1 {
            memref.store %cst_1, %alloc_23[%arg19, %arg20] : memref<16x64xf16>
          }
        }
      }
      %60 = arith.minsi %44, %c64 : index
      %61 = arith.subi %c64, %60 : index
      %base_buffer_24, %offset_25, %sizes_26:2, %strides_27:2 = memref.extract_strided_metadata %reinterpret_cast_6 : memref<16x?xf16, strided<[?, ?], offset: ?>> -> memref<f16>, index, index, index, index, index
      %reinterpret_cast_28 = memref.reinterpret_cast %base_buffer_24 to offset: [%offset_25], sizes: [%54, %60], strides: [%strides_27#0, %strides_27#1] : memref<f16> to memref<?x?xf16, strided<[?, ?], offset: ?>>
      %base_buffer_29, %offset_30, %sizes_31:2, %strides_32:2 = memref.extract_strided_metadata %reinterpret_cast_7 : memref<16x?xf16, strided<[?, ?], offset: ?>> -> memref<f16>, index, index, index, index, index
      %reinterpret_cast_33 = memref.reinterpret_cast %base_buffer_29 to offset: [%offset_30], sizes: [%54, %61], strides: [%strides_32#0, %strides_32#1] : memref<f16> to memref<?x?xf16, strided<[?, ?], offset: ?>>
      %reinterpret_cast_34 = memref.reinterpret_cast %alloc_23 to offset: [0], sizes: [%54, %60], strides: [64, 1] : memref<16x64xf16> to memref<?x?xf16, strided<[64, 1]>>
      %reinterpret_cast_35 = memref.reinterpret_cast %alloc_23 to offset: [%60], sizes: [%54, %61], strides: [64, 1] : memref<16x64xf16> to memref<?x?xf16, strided<[64, 1], offset: ?>>
      memref.copy %reinterpret_cast_28, %reinterpret_cast_34 : memref<?x?xf16, strided<[?, ?], offset: ?>> to memref<?x?xf16, strided<[64, 1]>>
      memref.copy %reinterpret_cast_33, %reinterpret_cast_35 : memref<?x?xf16, strided<[?, ?], offset: ?>> to memref<?x?xf16, strided<[64, 1], offset: ?>>
      %62 = vector.vscale
      %63 = arith.muli %62, %c4 : index
      %64 = arith.muli %62, %c4 : index
      %alloc_36 = memref.alloc() {alignment = 64 : i64} : memref<32x64xf32>
      memref.copy %alloc, %alloc_36 : memref<32x64xf32> to memref<32x64xf32>
      scf.for %arg19 = %c0 to %c32 step %63 {
        scf.for %arg20 = %c0 to %c64 step %64 {
          scf.for %arg21 = %c0 to %c16 step %c1 {
            %67 = affine.min #map1(%arg19, %63)
            %68 = affine.min #map2(%arg20, %64)
            %69 = affine.min #map1(%arg19, %63)
            %70 = affine.min #map2(%arg20, %64)
            %71 = affine.apply #map3()[%arg19, %arg21]
            %72 = affine.apply #map4()[%arg21, %arg20]
            %73 = affine.apply #map4()[%arg19, %arg20]
            %reinterpret_cast_37 = memref.reinterpret_cast %alloc_36 to offset: [%73], sizes: [%69, %70], strides: [64, 1] : memref<32x64xf32> to memref<?x?xf32, strided<[64, 1], offset: ?>>
            %74 = vector.create_mask %67 : vector<[4]xi1>
            %reinterpret_cast_38 = memref.reinterpret_cast %alloc_10 to offset: [%71], sizes: [%67], strides: [16] : memref<32x16xf16> to memref<?xf16, #map5>
            %75 = vector.vscale
            %76 = arith.muli %75, %c4 : index
            %77 = scf.for %arg22 = %c0 to %76 step %c1 iter_args(%arg23 = %cst) -> (vector<[4]xf16>) {
              %107 = vector.extractelement %74[%arg22 : index] : vector<[4]xi1>
              %108 = scf.if %107 -> (vector<[4]xf16>) {
                %109 = memref.load %reinterpret_cast_38[%arg22] : memref<?xf16, #map5>
                %110 = vector.insertelement %109, %arg23[%arg22 : index] : vector<[4]xf16>
                scf.yield %110 : vector<[4]xf16>
              } else {
                scf.yield %arg23 : vector<[4]xf16>
              }
              scf.yield %108 : vector<[4]xf16>
            }
            %78 = vector.shape_cast %77 : vector<[4]xf16> to vector<[4]x1xf16>
            %79 = vector.create_mask %68 : vector<[4]xi1>
            %reinterpret_cast_39 = memref.reinterpret_cast %alloc_23 to offset: [%72], sizes: [%68], strides: [1] : memref<16x64xf16> to memref<?xf16, #map6>
            %80 = vector.transfer_read %reinterpret_cast_39[%c0], %cst_1, %79 {in_bounds = [true]} : memref<?xf16, #map6>, vector<[4]xf16>
            %81 = vector.shape_cast %80 : vector<[4]xf16> to vector<1x[4]xf16>
            %82 = arm_sme.zero {tile_id = 0 : i32} : vector<[4]x[4]xf32>
            %83 = vector.vscale
            %84 = arith.muli %83, %c4 : index
            %85 = arith.index_cast %67 : index to i64
            %86 = arith.index_cast %84 : index to i64
            %87 = arith.minsi %85, %86 : i64
            %88 = arith.index_cast %87 : i64 to index
            %89 = vector.create_mask %68 : vector<[4]xi1>
            %90 = scf.for %arg22 = %c0 to %88 step %c1 iter_args(%arg23 = %82) -> (vector<[4]x[4]xf32>) {
              %107 = arm_sme.load_tile_slice %reinterpret_cast_37[%arg22, %c0], %89, %arg23, %arg22 {tile_id = 0 : i32} : memref<?x?xf32, strided<[64, 1], offset: ?>>, vector<[4]xi1>, vector<[4]x[4]xf32>
              scf.yield %107 : vector<[4]x[4]xf32>
            }
            %91 = arith.extf %78 : vector<[4]x1xf16> to vector<[4]x1xf32>
            %92 = arith.extf %81 : vector<1x[4]xf16> to vector<1x[4]xf32>
            %93 = vector.transpose %91, [1, 0] : vector<[4]x1xf32> to vector<1x[4]xf32>
            %94 = vector.extract %93[0] : vector<[4]xf32> from vector<1x[4]xf32>
            %95 = vector.extract %92[0] : vector<[4]xf32> from vector<1x[4]xf32>
            %96 = vector.create_mask %67 : vector<[4]xi1>
            %97 = vector.create_mask %68 : vector<[4]xi1>
            %98 = arm_sme.outerproduct %94, %95 acc(%90) masks(%96, %97) {tile_id = 0 : i32} : vector<[4]xf32>, vector<[4]xf32>
            %99 = vector.vscale
            %100 = arith.muli %99, %c4 : index
            %101 = arith.index_cast %67 : index to i64
            %102 = arith.index_cast %100 : index to i64
            %103 = arith.minsi %101, %102 : i64
            %104 = arith.index_cast %103 : i64 to index
            %105 = vector.create_mask %68 : vector<[4]xi1>
            scf.for %arg22 = %c0 to %104 step %c1 {
              arm_sme.store_tile_slice %98, %arg22, %105, %reinterpret_cast_37[%arg22, %c0] {tile_id = 0 : i32} : memref<?x?xf32, strided<[64, 1], offset: ?>>, vector<[4]xi1>, vector<[4]x[4]xf32>
            }
            %106 = affine.apply #map4()[%arg19, %arg20]
            %reinterpret_cast_40 = memref.reinterpret_cast %alloc_36 to offset: [%106], sizes: [%69, %70], strides: [64, 1] : memref<32x64xf32> to memref<?x?xf32, strided<[64, 1], offset: ?>>
            memref.copy %reinterpret_cast_37, %reinterpret_cast_40 : memref<?x?xf32, strided<[64, 1], offset: ?>> to memref<?x?xf32, strided<[64, 1], offset: ?>>
          }
        }
      }
      scf.for %arg19 = %c0 to %c32 step %c1 {
        scf.for %arg20 = %c0 to %c64 step %c1 {
          %67 = memref.load %alloc_36[%arg19, %arg20] : memref<32x64xf32>
          %68 = memref.load %arg16[%arg19, %arg20] : memref<32x64xf32>
          %69 = arith.addf %67, %68 : f32
          memref.store %69, %alloc_36[%arg19, %arg20] : memref<32x64xf32>
        }
      }
      %65 = arith.addi %arg17, %c16 : index
      %66 = arith.addi %arg18, %26 : index
      scf.yield %alloc_36, %65, %66 : memref<32x64xf32>, index, index
    }
    %28 = arith.index_cast %arg8 : i32 to index
    %29 = arith.muli %14, %28 : index
    %30 = arith.addi %29, %16 : index
    %reinterpret_cast = memref.reinterpret_cast %arg2 to offset: [%30], sizes: [32, 64], strides: [%28, 1] : memref<*xf16> to memref<32x64xf16, strided<[?, 1], offset: ?>>
    %alloc_3 = memref.alloc() {alignment = 64 : i64} : memref<32x64xf16>
    scf.for %arg15 = %c0 to %c32 step %c1 {
      scf.for %arg16 = %c0 to %c64 step %c1 {
        %39 = memref.load %27#0[%arg15, %arg16] : memref<32x64xf32>
        %40 = arith.truncf %39 : f32 to f16
        memref.store %40, %alloc_3[%arg15, %arg16] : memref<32x64xf16>
      }
    }
    %31 = arith.addi %14, %c32 : index
    %32 = arith.minsi %31, %17 : index
    %33 = arith.subi %32, %14 : index
    %34 = arith.addi %16, %c64 : index
    %35 = arith.minsi %34, %22 : index
    %36 = arith.subi %35, %16 : index
    %37 = arith.minsi %33, %c32 : index
    %38 = arith.minsi %36, %c64 : index
    %reinterpret_cast_4 = memref.reinterpret_cast %alloc_3 to offset: [0], sizes: [%37, %38], strides: [64, 1] : memref<32x64xf16> to memref<?x?xf16, strided<[64, 1]>>
    %base_buffer, %offset, %sizes:2, %strides:2 = memref.extract_strided_metadata %reinterpret_cast : memref<32x64xf16, strided<[?, 1], offset: ?>> -> memref<f16>, index, index, index, index, index
    %reinterpret_cast_5 = memref.reinterpret_cast %base_buffer to offset: [%offset], sizes: [%37, %38], strides: [%strides#0, 1] : memref<f16> to memref<?x?xf16, strided<[?, 1], offset: ?>>
    memref.copy %reinterpret_cast_4, %reinterpret_cast_5 : memref<?x?xf16, strided<[64, 1]>> to memref<?x?xf16, strided<[?, 1], offset: ?>>
    return
  }
}



hey there, I believe we have crossed paths a few times on the triton repo most recently it
was for the mostly janky cross compiling script that I've ever written and I've had intrest the triton repo 
and have contributed occassionaly. recently been working on pass to lower linalg.matmul to this ArmSME dialect.
It may not be for GPUs but given the capabilites of ArmSME I figured that 


I wanted to ask if you would be willing to give me a refferal to a few positions @ OpenAi since I want to pursue
projects like this in more than just an open source capacity. I know that I may have a lack of proffesional work years 
however I think I have really good OSS experience to be able to work on these positions.

Plus if I work for OpenAi, I can fix that github actions runner when it inevitably breaks