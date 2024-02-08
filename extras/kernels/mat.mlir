func.func @matmul(%A : tensor<?x?xf32>, %B : tensor<?x?xf32>, %C : tensor<?x?xf32>) {
  %res = linalg.matmul ins(%A, %B: tensor<?x?xf32>, tensor<?x?xf32>)
                       outs(%C: tensor<?x?xf32>) -> tensor<?x?xf32>
  %xf = tensor.cast %res : tensor<?x?xf32> to tensor<*xf32>
  return
}
