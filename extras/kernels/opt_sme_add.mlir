module {
  llvm.func @malloc(i64) -> !llvm.ptr
  func.func @scalable_tile(%arg0: tensor<?xf32>, %arg1: tensor<?xf32>, %arg2: tensor<?xf32>, %arg3: f32) -> tensor<?xf32> {
    %0 = llvm.mlir.constant(1 : index) : i64
    %1 = llvm.mlir.constant(0 : index) : i64
    %2 = builtin.unrealized_conversion_cast %1 : i64 to index
    %3 = bufferization.to_memref %arg1 : memref<?xf32, strided<[?], offset: ?>>
    %4 = builtin.unrealized_conversion_cast %3 : memref<?xf32, strided<[?], offset: ?>> to !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %5 = bufferization.to_memref %arg0 : memref<?xf32, strided<[?], offset: ?>>
    %6 = builtin.unrealized_conversion_cast %5 : memref<?xf32, strided<[?], offset: ?>> to !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %7 = bufferization.to_memref %arg2 : memref<?xf32, strided<[?], offset: ?>>
    %8 = builtin.unrealized_conversion_cast %7 : memref<?xf32, strided<[?], offset: ?>> to !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %9 = llvm.mlir.constant(1 : index) : i64
    %10 = llvm.extractvalue %8[3] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %11 = llvm.alloca %9 x !llvm.array<1 x i64> : (i64) -> !llvm.ptr
    llvm.store %10, %11 : !llvm.array<1 x i64>, !llvm.ptr
    %12 = llvm.getelementptr %11[0, 0] : (!llvm.ptr) -> !llvm.ptr, !llvm.array<1 x i64>
    %13 = llvm.load %12 : !llvm.ptr -> i64
    %14 = llvm.mlir.constant(1 : index) : i64
    %15 = llvm.mlir.zero : !llvm.ptr
    %16 = llvm.getelementptr %15[%13] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %17 = llvm.ptrtoint %16 : !llvm.ptr to i64
    %18 = llvm.mlir.constant(64 : index) : i64
    %19 = llvm.add %17, %18  : i64
    %20 = llvm.call @malloc(%19) : (i64) -> !llvm.ptr
    %21 = llvm.ptrtoint %20 : !llvm.ptr to i64
    %22 = llvm.mlir.constant(1 : index) : i64
    %23 = llvm.sub %18, %22  : i64
    %24 = llvm.add %21, %23  : i64
    %25 = llvm.urem %24, %18  : i64
    %26 = llvm.sub %24, %25  : i64
    %27 = llvm.inttoptr %26 : i64 to !llvm.ptr
    %28 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %29 = llvm.insertvalue %20, %28[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %30 = llvm.insertvalue %27, %29[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %31 = llvm.mlir.constant(0 : index) : i64
    %32 = llvm.insertvalue %31, %30[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %33 = llvm.insertvalue %13, %32[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %34 = llvm.insertvalue %14, %33[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %35 = builtin.unrealized_conversion_cast %34 : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> to memref<?xf32>
    %36 = llvm.mlir.constant(1 : index) : i64
    %37 = llvm.extractvalue %6[3] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %38 = llvm.alloca %36 x !llvm.array<1 x i64> : (i64) -> !llvm.ptr
    llvm.store %37, %38 : !llvm.array<1 x i64>, !llvm.ptr
    %39 = llvm.getelementptr %38[0, 0] : (!llvm.ptr) -> !llvm.ptr, !llvm.array<1 x i64>
    %40 = llvm.load %39 : !llvm.ptr -> i64
    %41 = builtin.unrealized_conversion_cast %40 : i64 to index
    cf.br ^bb1(%2 : index)
  ^bb1(%42: index):  // 2 preds: ^bb0, ^bb2
    %43 = builtin.unrealized_conversion_cast %42 : index to i64
    %44 = builtin.unrealized_conversion_cast %42 : index to i64
    %45 = llvm.icmp "slt" %44, %40 : i64
    llvm.cond_br %45, ^bb2, ^bb3
  ^bb2:  // pred: ^bb1
    %46 = llvm.extractvalue %6[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %47 = llvm.extractvalue %6[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %48 = llvm.getelementptr %46[%47] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %49 = llvm.extractvalue %6[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %50 = llvm.mul %43, %49  : i64
    %51 = llvm.getelementptr %48[%50] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %52 = llvm.load %51 : !llvm.ptr -> f32
    %53 = llvm.extractvalue %4[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %54 = llvm.extractvalue %4[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %55 = llvm.getelementptr %53[%54] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %56 = llvm.extractvalue %4[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %57 = llvm.mul %43, %56  : i64
    %58 = llvm.getelementptr %55[%57] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %59 = llvm.load %58 : !llvm.ptr -> f32
    %60 = llvm.fadd %52, %59  : f32
    %61 = llvm.fmul %arg3, %60  : f32
    %62 = llvm.getelementptr %27[%43] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %61, %62 : f32, !llvm.ptr
    %63 = llvm.add %44, %0  : i64
    %64 = builtin.unrealized_conversion_cast %63 : i64 to index
    cf.br ^bb1(%64 : index)
  ^bb3:  // pred: ^bb1
    %65 = bufferization.to_tensor %35 : memref<?xf32>
    return %65 : tensor<?xf32>
  }
}

