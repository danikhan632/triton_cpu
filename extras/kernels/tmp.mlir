module {    
  llvm.func @matmul(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: i64, %arg3: i64, %arg4: i64, %arg5: i64, %arg6: i64, %arg7: !llvm.ptr, %arg8: !llvm.ptr, %arg9: i64, %arg10: i64, %arg11: i64, %arg12: i64, %arg13: i64, %arg14: !llvm.ptr, %arg15: !llvm.ptr, %arg16: i64, %arg17: i64, %arg18: i64, %arg19: i64, %arg20: i64) attributes {arm_locally_streaming, arm_new_za, arm_sme.tiles_in_use = 34952 : i32} {
    %0 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %1 = llvm.insertvalue %arg0, %0[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %2 = llvm.insertvalue %arg1, %1[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %3 = llvm.insertvalue %arg2, %2[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %4 = llvm.insertvalue %arg3, %3[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %5 = llvm.insertvalue %arg5, %4[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %6 = llvm.insertvalue %arg4, %5[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %7 = llvm.insertvalue %arg6, %6[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %8 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %9 = llvm.insertvalue %arg7, %8[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %10 = llvm.insertvalue %arg8, %9[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %11 = llvm.insertvalue %arg9, %10[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %12 = llvm.insertvalue %arg10, %11[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %13 = llvm.insertvalue %arg12, %12[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %14 = llvm.insertvalue %arg11, %13[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %15 = llvm.insertvalue %arg13, %14[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %16 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %17 = llvm.insertvalue %arg14, %16[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %18 = llvm.insertvalue %arg15, %17[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %19 = llvm.insertvalue %arg16, %18[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %20 = llvm.insertvalue %arg17, %19[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %21 = llvm.insertvalue %arg19, %20[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %22 = llvm.insertvalue %arg18, %21[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %23 = llvm.insertvalue %arg20, %22[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %24 = llvm.mlir.constant(0 : i32) : i32
    %25 = llvm.mlir.constant(dense<0.000000e+00> : vector<[4]xf32>) : vector<[4]xf32>
    %26 = llvm.mlir.constant(4 : index) : i64
    %27 = llvm.mlir.constant(1 : index) : i64
    %28 = llvm.mlir.constant(0 : index) : i64
    %29 = "llvm.intr.vscale"() : () -> i64
    %30 = llvm.mul %29, %26  : i64
    llvm.br ^bb1(%28 : i64)
  ^bb1(%31: i64):  // 2 preds: ^bb0, ^bb24
    %32 = llvm.icmp "slt" %31, %arg3 : i64
    llvm.cond_br %32, ^bb2, ^bb25
  ^bb2:  // pred: ^bb1
    %33 = llvm.sub %arg3, %31  : i64
    %34 = llvm.icmp "slt" %33, %30 : i64
    %35 = llvm.select %34, %33, %30 : i1, i64
    llvm.br ^bb3(%28 : i64)
  ^bb3(%36: i64):  // 2 preds: ^bb2, ^bb23
    %37 = llvm.icmp "slt" %36, %arg11 : i64
    llvm.cond_br %37, ^bb4, ^bb24
  ^bb4:  // pred: ^bb3
    %38 = llvm.sub %arg11, %36  : i64
    %39 = llvm.icmp "slt" %38, %30 : i64
    %40 = llvm.select %39, %38, %30 : i1, i64
    llvm.br ^bb5(%28 : i64)
  ^bb5(%41: i64):  // 2 preds: ^bb4, ^bb22
    %42 = llvm.icmp "slt" %41, %arg4 : i64
    llvm.cond_br %42, ^bb6, ^bb23
  ^bb6:  // pred: ^bb5
    %43 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64)>
    %44 = llvm.insertvalue %arg0, %43[0] : !llvm.struct<(ptr, ptr, i64)> 
    %45 = llvm.insertvalue %arg1, %44[1] : !llvm.struct<(ptr, ptr, i64)> 
    %46 = llvm.mlir.constant(0 : index) : i64
    %47 = llvm.insertvalue %46, %45[2] : !llvm.struct<(ptr, ptr, i64)> 
    %48 = llvm.mul %31, %arg5  : i64
    %49 = llvm.add %arg2, %48  : i64
    %50 = llvm.mul %41, %arg6  : i64
    %51 = llvm.add %49, %50  : i64
    %52 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64)>
    %53 = llvm.insertvalue %arg7, %52[0] : !llvm.struct<(ptr, ptr, i64)> 
    %54 = llvm.insertvalue %arg8, %53[1] : !llvm.struct<(ptr, ptr, i64)> 
    %55 = llvm.mlir.constant(0 : index) : i64
    %56 = llvm.insertvalue %55, %54[2] : !llvm.struct<(ptr, ptr, i64)> 
    %57 = llvm.mul %41, %arg12  : i64
    %58 = llvm.add %arg9, %57  : i64
    %59 = llvm.mul %36, %arg13  : i64
    %60 = llvm.add %58, %59  : i64
    %61 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64)>
    %62 = llvm.insertvalue %arg14, %61[0] : !llvm.struct<(ptr, ptr, i64)> 
    %63 = llvm.insertvalue %arg15, %62[1] : !llvm.struct<(ptr, ptr, i64)> 
    %64 = llvm.mlir.constant(0 : index) : i64
    %65 = llvm.insertvalue %64, %63[2] : !llvm.struct<(ptr, ptr, i64)> 
    %66 = llvm.mul %31, %arg19  : i64
    %67 = llvm.add %arg16, %66  : i64
    %68 = llvm.mul %36, %arg20  : i64
    %69 = llvm.add %67, %68  : i64
    %70 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %71 = llvm.insertvalue %arg14, %70[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %72 = llvm.insertvalue %arg15, %71[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %73 = llvm.insertvalue %69, %72[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %74 = llvm.insertvalue %35, %73[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %75 = llvm.insertvalue %arg19, %74[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %76 = llvm.insertvalue %40, %75[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %77 = llvm.insertvalue %arg20, %76[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %78 = llvm.intr.experimental.stepvector : vector<[4]xi32>
    %79 = llvm.trunc %35 : i64 to i32
    %80 = llvm.mlir.undef : vector<[4]xi32>
    %81 = llvm.insertelement %79, %80[%24 : i32] : vector<[4]xi32>
    %82 = llvm.shufflevector %81, %80 [0, 0, 0, 0] : vector<[4]xi32> 
    %83 = llvm.icmp "slt" %78, %82 : vector<[4]xi32>
    %84 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %85 = llvm.insertvalue %arg0, %84[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %86 = llvm.insertvalue %arg1, %85[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %87 = llvm.insertvalue %51, %86[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %88 = llvm.insertvalue %35, %87[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %89 = llvm.insertvalue %arg5, %88[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    llvm.br ^bb7(%28, %25 : i64, vector<[4]xf32>)
  ^bb7(%90: i64, %91: vector<[4]xf32>):  // 2 preds: ^bb6, ^bb10
    %92 = llvm.icmp "slt" %90, %30 : i64
    llvm.cond_br %92, ^bb8, ^bb11
  ^bb8:  // pred: ^bb7
    %93 = llvm.extractelement %83[%90 : i64] : vector<[4]xi1>
    llvm.cond_br %93, ^bb9, ^bb10(%91 : vector<[4]xf32>)
  ^bb9:  // pred: ^bb8
    %94 = llvm.getelementptr %arg1[%51] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %95 = llvm.mul %90, %arg5  : i64
    %96 = llvm.getelementptr %94[%95] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %97 = llvm.load %96 : !llvm.ptr -> f32
    %98 = llvm.insertelement %97, %91[%90 : i64] : vector<[4]xf32>
    llvm.br ^bb10(%98 : vector<[4]xf32>)
  ^bb10(%99: vector<[4]xf32>):  // 2 preds: ^bb8, ^bb9
    %100 = llvm.add %90, %27  : i64
    llvm.br ^bb7(%100, %99 : i64, vector<[4]xf32>)
  ^bb11:  // pred: ^bb7
    %101 = llvm.trunc %40 : i64 to i32
    %102 = llvm.insertelement %101, %80[%24 : i32] : vector<[4]xi32>
    %103 = llvm.shufflevector %102, %80 [0, 0, 0, 0] : vector<[4]xi32> 
    %104 = llvm.icmp "slt" %78, %103 : vector<[4]xi32>
    %105 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %106 = llvm.insertvalue %arg7, %105[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %107 = llvm.insertvalue %arg8, %106[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %108 = llvm.insertvalue %60, %107[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %109 = llvm.insertvalue %40, %108[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %110 = llvm.insertvalue %arg13, %109[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    llvm.br ^bb12(%28, %25 : i64, vector<[4]xf32>)
  ^bb12(%111: i64, %112: vector<[4]xf32>):  // 2 preds: ^bb11, ^bb15
    %113 = llvm.icmp "slt" %111, %30 : i64
    llvm.cond_br %113, ^bb13, ^bb16
  ^bb13:  // pred: ^bb12
    %114 = llvm.extractelement %104[%111 : i64] : vector<[4]xi1>
    llvm.cond_br %114, ^bb14, ^bb15(%112 : vector<[4]xf32>)
  ^bb14:  // pred: ^bb13
    %115 = llvm.getelementptr %arg8[%60] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %116 = llvm.mul %111, %arg13  : i64
    %117 = llvm.getelementptr %115[%116] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %118 = llvm.load %117 : !llvm.ptr -> f32
    %119 = llvm.insertelement %118, %112[%111 : i64] : vector<[4]xf32>
    llvm.br ^bb15(%119 : vector<[4]xf32>)
  ^bb15(%120: vector<[4]xf32>):  // 2 preds: ^bb13, ^bb14
    %121 = llvm.add %111, %27  : i64
    llvm.br ^bb12(%121, %120 : i64, vector<[4]xf32>)
  ^bb16:  // pred: ^bb12
    "arm_sme.intr.zero"() <{tile_mask = 17 : i32}> : () -> ()
    llvm.br ^bb17(%28 : i64)
  ^bb17(%122: i64):  // 2 preds: ^bb16, ^bb18
    %123 = llvm.icmp "slt" %122, %35 : i64
    llvm.cond_br %123, ^bb18, ^bb19
  ^bb18:  // pred: ^bb17
    %124 = llvm.getelementptr %arg15[%69] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %125 = llvm.mul %122, %arg19  : i64
    %126 = llvm.mul %arg20, %28  : i64
    %127 = llvm.add %125, %126  : i64
    %128 = llvm.getelementptr %124[%127] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %129 = llvm.trunc %122 : i64 to i32
    "arm_sme.intr.ld1w.horiz"(%104, %128, %129) <{tile_id = 0 : i32}> : (vector<[4]xi1>, !llvm.ptr, i32) -> ()
    %130 = llvm.add %122, %27  : i64
    llvm.br ^bb17(%130 : i64)
  ^bb19:  // pred: ^bb17
    "arm_sme.intr.mopa"(%83, %104, %91, %112) <{tile_id = 0 : i32}> : (vector<[4]xi1>, vector<[4]xi1>, vector<[4]xf32>, vector<[4]xf32>) -> ()
    llvm.br ^bb20(%28 : i64)
  ^bb20(%131: i64):  // 2 preds: ^bb19, ^bb21
    %132 = llvm.icmp "slt" %131, %35 : i64
    llvm.cond_br %132, ^bb21, ^bb22
  ^bb21:  // pred: ^bb20
    %133 = llvm.getelementptr %arg15[%69] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %134 = llvm.mul %131, %arg19  : i64
    %135 = llvm.mul %arg20, %28  : i64
    %136 = llvm.add %134, %135  : i64
    %137 = llvm.getelementptr %133[%136] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %138 = llvm.trunc %131 : i64 to i32
    "arm_sme.intr.st1w.horiz"(%104, %137, %138) <{tile_id = 0 : i32}> : (vector<[4]xi1>, !llvm.ptr, i32) -> ()
    %139 = llvm.add %131, %27  : i64
    llvm.br ^bb20(%139 : i64)
  ^bb22:  // pred: ^bb20
    %140 = llvm.add %41, %27  : i64
    llvm.br ^bb5(%140 : i64)
  ^bb23:  // pred: ^bb5
    %141 = llvm.add %36, %30  : i64
    llvm.br ^bb3(%141 : i64)
  ^bb24:  // pred: ^bb3
    %142 = llvm.add %31, %30  : i64
    llvm.br ^bb1(%142 : i64)
  ^bb25:  // pred: ^bb1
    llvm.return
  }
  module attributes {transform.with_named_sequence} {
  }
}