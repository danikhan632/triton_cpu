transform.sequence failures(propagate) {
^bb1(%arg1: !transform.any_op):
  %0 = transform.structured.match ops{["linalg.generic"]} in %arg1 : (!transform.any_op) -> !transform.any_op
  %1 = get_parent_op %0 {isolated_from_above} : (!transform.any_op) -> !transform.any_op
  %2 = transform.structured.vectorize_children_and_apply_patterns %1 { vectorize_nd_extract } : (!transform.any_op) -> !transform.any_op
}
// -----

#map = affine_map<(d0) -> (d0)>
func.func @vectorize_nd_tensor_extract_contiguous_and_gather(%arg0: tensor<6xf32>, %arg1: tensor<5xi32>) -> tensor<5xf32> {
 %c5 = arith.constant 5 : index
 %c0 = arith.constant 0 : index
 %0 = tensor.empty() : tensor<5xf32>
 %1 = linalg.generic {indexing_maps = [#map], iterator_types = ["parallel"]} outs(%0 : tensor<5xf32>) {
 ^bb0(%out: f32):
   %2 = linalg.index 0 : index
   %extracted = tensor.extract %arg1[%2] : tensor<5xi32>
   %3 = arith.index_cast %extracted : i32 to index
   %4 = arith.maxsi %3, %c0 : index
   %5 = arith.minsi %4, %c5 : index
   %extracted_0 = tensor.extract %arg0[%5] : tensor<6xf32>
   linalg.yield %extracted_0 : f32
 } -> tensor<5xf32>
 return %1 : tensor<5xf32>
}

// CHECK-LABEL: func.func @vectorize_elementwise_add(
// CHECK-SAME: %[[ARG0:.*]]: tensor<128x256xf32>, %[[ARG1:.*]]: tensor<128x256xf32>) -> tensor<128x256xf32> {
// CHECK:   %[[VAL_0:.*]] = linalg.init_tensor [128, 256] : tensor<128x256xf32>
// CHECK:   %[[VAL_1:.*]] = linalg.generic {indexing_maps = [#map0, #map1, #map1], iterator_types = ["parallel", "parallel"]} ins(%[[ARG0]], %[[ARG1]]: tensor<128x256xf32>, tensor<128x256xf32>) outs(%[[VAL_0]]: tensor<128x256xf32>) {
// CHECK:   ^bb0(%[[IN1:.*]]: f32, %[[IN2:.*]]: f32, %[[OUT:.*]]: f32):
// CHECK:     %[[ADD:.*]] = arith.addf %[[IN1]], %[[IN2]] : f32
// CHECK:     linalg.yield %[[ADD]] : f32
// CHECK:   } -> tensor<128x256xf32>
// CHECK:   return %[[VAL_1]] : tensor<128x256xf32>
// CHECK: }
