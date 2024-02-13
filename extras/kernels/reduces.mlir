func.func @vectorize_reduce(%arg0: memref<16x32x64xf32>,
                  %arg1: memref<16x64xf32>) {
  linalg.reduce ins(%arg0 : memref<16x32x64xf32>)
                outs(%arg1 : memref<16x64xf32>) dimensions = [1]
    (%in: f32, %init: f32) {
      %0 = arith.addf %in, %init : f32
      linalg.yield %0 : f32
    }
  return
}
// CHECK-LABEL: func @vectorize_reduce
// CHECK:         vector.multi_reduction <add>
// CHECK-SAME:    : vector<16x32x64xf32> to vector<16x64xf32>

module attributes {transform.with_named_sequence} {
  transform.named_sequence @__transform_main(%module : !transform.any_op {transform.consumed}) {
    %red = transform.structured.match ops{["linalg.reduce"]} in %module: (!transform.any_op) -> !transform.any_op

    // Step 1: Tile for size [4] x [4], which corresponds to SVLs x SVLs, where
    // SVLs is the number of 32-bit elements in a vector of SVL bits.
    %tiled_linalg_op, %loops:3 = transform.structured.tile_using_for %red[[4], [4], 1]: (!transform.any_op)  -> (!transform.any_op, !transform.any_op, !transform.any_op, !transform.any_op)

    // Step 2: Vectorize.
    // transform.structured.vectorize %red vector_sizes [[4], [4], 1]: !transform.any_op

    // Step 3: Bufferize ahead of TransferReadDropUnitDimsPattern, which
    // currently only supports memrefs.
    // %bufferize = transform.bufferization.one_shot_bufferize %module {bufferize_function_boundaries=true} : (!transform.any_op) -> !transform.any_op

    // %func = transform.structured.match ops{["func.func"]} in %bufferize: (!transform.any_op) -> !transform.any_op

    // // Step 4: Lower vector.multi_reduction to vector.contract (+ some helpful patterns).
    // transform.apply_patterns to %func {
    //       transform.apply_patterns.vector.lower_broadcast
    //       transform.apply_patterns.vector.lower_contraction
    //       transform.apply_patterns.vector.lower_multi_reduction
    // } : !transform.any_op

    // Step 5: Lower vector.contract to vector.outerproduct. Also drop unit
    // dims, specifically to prevent vector.transfer_read of vector<[4]x1xf32>,
    // which can't be lowered in generic path.


    transform.yield
  }
}