#map = affine_map<(d0, d1) -> (d0, d1)>
module {
  func.func @main(%arg0: memref<*xbf16>, %arg1: memref<*xbf16>, %arg2: memref<*xbf16>, %arg3: i32, %arg4: i32, %arg5: i32, %arg6: i32, %arg7: i32, %arg8: i32) {
    %cst = arith.constant 0.000000e+00 : bf16

    %4 = tensor.empty() : tensor<128x64xbf16>
    %5 = linalg.fill ins(%cst : bf16) outs(%4 : tensor<128x64xbf16>) -> tensor<128x64xbf16>

    // Create dummy tensors for %10 and %15 with compatible dimensions for matmul
    %10 = tensor.empty() : tensor<64x256xbf16> // Assuming this is the right-hand side operand
    %15 = tensor.empty() : tensor<128x256xbf16> // Assuming this is the output tensor

    %16 = "linalg.matmul"(%5, %10, %15) <{operandSegmentSizes = array<i32: 2, 1>}> ({
    ^bb0(%arg9: bf16, %arg10: bf16, %arg11: bf16):
      %18 = "arith.mulf"(%arg9, %arg10) <{fastmath = #arith.fastmath<none>}> : (bf16, bf16) -> bf16
      %19 = "arith.addf"(%arg11, %18) <{fastmath = #arith.fastmath<none>}> : (bf16, bf16) -> bf16
      "linalg.yield"(%19) : (bf16) -> ()
    }) {linalg.memoized_indexing_maps = [affine_map<(d0, d1, d2) -> (d0, d2)>, affine_map<(d0, d1, d2) -> (d2, d1)>, affine_map<(d0, d1, d2) -> (d0, d1)>]} : (tensor<128x64xbf16>, tensor<64x256xbf16>, tensor<128x256xbf16>) -> tensor<128x256xbf16>
    return
  }
}

module attributes {transform.with_named_sequence} {
  transform.named_sequence @__transform_main(%module : !transform.any_op {transform.consumed}) {
    %matmul = transform.structured.match ops{["linalg.matmul"]} in %module
      : (!transform.any_op) -> !transform.any_op

    // Step 1: Tile for size [4] x [4], which corresponds to SVLs x SVLs, where
    // SVLs is the number of 32-bit elements in a vector of SVL bits.
    %tiled_linalg_op, %loops:3 = transform.structured.tile_using_for %matmul[[4], [4], 1]
      : (!transform.any_op) -> (!transform.any_op, !transform.any_op, !transform.any_op, !transform.any_op)

    // Step 2: Vectorize.
    transform.structured.vectorize %tiled_linalg_op vector_sizes [[4], [4], 1]
      : !transform.any_op

    // Step 3: Bufferize ahead of TransferReadDropUnitDimsPattern, which
    // currently only supports memrefs.
    %bufferize = transform.bufferization.one_shot_bufferize %module
      {bufferize_function_boundaries=true} : (!transform.any_op) -> !transform.any_op

    %func = transform.structured.match ops{["func.func"]} in %bufferize
      : (!transform.any_op) -> !transform.any_op

    // Step 4: Lower vector.multi_reduction to vector.contract (+ some helpful patterns).
    transform.apply_patterns to %func {
      transform.apply_patterns.vector.lower_masked_transfers
      transform.apply_patterns.vector.transfer_permutation_patterns
      transform.apply_patterns.vector.reduction_to_contract
    } : !transform.any_op

    // Step 5: Lower vector.contract to vector.outerproduct. Also drop unit
    // dims, specifically to prevent vector.transfer_read of vector<[4]x1xf32>,
    // which can't be lowered in generic path.
    transform.apply_patterns to %func {
      transform.apply_patterns.vector.lower_contraction lowering_strategy = "outerproduct"
      transform.apply_patterns.vector.lower_masks
      transform.apply_patterns.vector.rank_reducing_subview_patterns
    } : !transform.any_op

    transform.yield
  }
}

