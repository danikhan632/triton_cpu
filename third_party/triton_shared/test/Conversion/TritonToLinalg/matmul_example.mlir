
func @matmul_example(%arg0: memref<?x?xf32>, %arg1: memref<?x?xf32>, %arg2: memref<?x?xf32>) {
  linalg.matmul ins(%arg0, %arg1 : memref<?x?xf32>, memref<?x?xf32>)
                 outs(%arg2 : memref<?x?xf32>);
  return
}
