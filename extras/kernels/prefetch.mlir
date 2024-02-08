func.func @load_store_prefetch(memref<4x4xi32>, index) {
^bb0(%0: memref<4x4xi32>, %1: index):
  // CHECK: %0 = memref.load %arg0[%arg1, %arg1] : memref<4x4xi32>
  %2 = "memref.load"(%0, %1, %1) : (memref<4x4xi32>, index, index)->i32

  // CHECK: %{{.*}} = memref.load %arg0[%arg1, %arg1] : memref<4x4xi32>
  %3 = memref.load %0[%1, %1] : memref<4x4xi32>

  // CHECK: memref.prefetch %arg0[%arg1, %arg1], write, locality<1>, data : memref<4x4xi32>
  memref.prefetch %0[%1, %1], write, locality<1>, data : memref<4x4xi32>

  // CHECK: memref.prefetch %arg0[%arg1, %arg1], read, locality<3>, instr : memref<4x4xi32>
  memref.prefetch %0[%1, %1], read, locality<3>, instr : memref<4x4xi32>

  return
}