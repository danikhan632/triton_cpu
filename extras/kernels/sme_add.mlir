#map = affine_map<(d0) -> (d0)>

module {
  func.func @scalable_tile(%arg0: tensor<?xf32>, %arg1: tensor<?xf32>, %arg2: tensor<?xf32>, %arg3: f32) -> tensor<?xf32> {
    %0 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel"]} ins(%arg0, %arg1 : tensor<?xf32>, tensor<?xf32>) outs(%arg2 : tensor<?xf32>) {
    ^bb0(%in_1: f32, %in_2: f32, %out: f32):
      %1 = arith.addf %in_1, %in_2 : f32
      %2 = arith.mulf %arg3, %1 : f32
      linalg.yield %2 : f32
    } -> tensor<?xf32>
    return %0 : tensor<?xf32>
  }
}

// CHECK-LABEL:   func.func @scalable_tile(
// CHECK-SAME:      %[[ARG_0:.*]]: tensor<?xf32>, %[[ARG_1:.*]]: tensor<?xf32>, %[[ARG_2:.*]]: tensor<?xf32>,
// CHECK:           %[[C4:.*]] = arith.constant 0 : index
// CHECK:           %[[DIM:.*]] = tensor.dim %[[ARG_0]], %[[C4]] : tensor<?xf32>
// CHECK:           %[[VEC_SIZE:.*]] = arith.constant 4 : index
// CHECK:           %[[VS:.*]] = vector.vscale
// CHECK:           %[[STEP:.*]] = arith.muli %[[VEC_SIZE]], %[[VS]] : index
// CHECK:           %[[C0:.*]] = arith.constant 0 : index
// CHECK:           scf.for %[[IV:.*]] = %[[C0]] to %[[DIM]] step %[[STEP]] iter_args(%[[VAL:.*]] = %[[ARG_2]]) -> (tensor<?xf32>) {
// CHECK:             %[[SIZE:.*]] = affine.min affine_map<(d0)[s0, s1] -> (s0, -d0 + s1)>(%[[IV]])[%[[STEP]], %[[DIM]]]
// CHECK:             %[[SLICE_ARG0:.*]] = tensor.extract_slice %[[ARG_0]][%[[IV]]] [%[[SIZE]]] [1] : tensor<?xf32> to tensor<?xf32>
// CHECK:             %[[SLICE_ARG1:.*]] = tensor.extract_slice %[[ARG_1]][%[[IV]]] [%[[SIZE]]] [1] : tensor<?xf32> to tensor<?xf32>
// CHECK:             %[[SLICE_ARG2:.*]] = tensor.extract_slice %[[VAL]][%[[IV]]] [%[[SIZE]]] [1] : tensor<?xf32> to tensor<?xf32>
// CHECK:             linalg.generic {indexing_maps = {{.*}}, iterator_types = ["parallel"]} ins(%[[SLICE_ARG0]], %[[SLICE_ARG1]] : tensor<?xf32>, tensor<?xf32>) outs(%[[SLICE_ARG2]] : tensor<?xf32>) {

// transform.sequence failures(propagate) {
//   ^bb0(%arg1: !transform.any_op):
//     %0 = transform.structured.match ops{["linalg.generic"]} in %arg1 : (!transform.any_op) -> !transform.any_op
//     %1, %loop = transform.structured.tile_using_for %0 [[4]] : (!transform.any_op) -> (!transform.any_op, !transform.any_op)
// }
