// RUN: mlir-opt %s \
// RUN:   -transform-interpreter -test-transform-dialect-erase-schedule \
// RUN:   -canonicalize \
// RUN:   -convert-vector-to-arm-sme -allocate-arm-sme-tiles -convert-arm-sme-to-scf \
// RUN:   -enable-arm-streaming="streaming-mode=streaming-locally za-mode=new-za only-if-required-by-ops" \
// RUN:   -convert-vector-to-scf -cse -arm-sve-legalize-vector-storage \
// RUN:   -convert-arm-sme-to-llvm \
// RUN:   -convert-vector-to-llvm=enable-arm-sve \
// RUN:   -cse -canonicalize -test-lower-to-llvm | \
// RUN: %mcr_aarch64_cmd \
// RUN:   -e=main -entry-point-result=void \
// RUN:   -march=aarch64 -mattr="+sve,+sme" \
// RUN:   -shared-libs=%mlir_runner_utils,%mlir_c_runner_utils,%arm_sme_abi_shlib | \
// RUN: FileCheck %s

func.func @matmul(%A : tensor<?x?xf32>, %B : tensor<?x?xf32>, %C : tensor<?x?xf32>) {
  %res = linalg.matmul ins(%A, %B: tensor<?x?xf32>, tensor<?x?xf32>)
                       outs(%C: tensor<?x?xf32>) -> tensor<?x?xf32>
  %xf = tensor.cast %res : tensor<?x?xf32> to tensor<*xf32>
  return
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

