module {
  func.func @matmul(%arg0: tensor<?x?xf32>, %arg1: tensor<?x?xf32>, %arg2: tensor<?x?xf32>) {
    llvm.return
  }
  module attributes {transform.with_named_sequence} {
    transform.named_sequence @tile_and_vectorize_matmul(%arg0: !transform.op<"func.func"> {transform.readonly}) {
      %0 = transform.structured.match ops{["linalg.matmul"]} in %arg0 : (!transform.op<"func.func">) -> !transform.any_op
      %tiled_linalg_op, %loops:3 = transform.structured.tile_using_for %0[2, [4], 1] : (!transform.any_op) -> (!transform.any_op, !transform.any_op, !transform.any_op, !transform.any_op)
      transform.print %tiled_linalg_op {name = "matmul lal"} : !transform.any_op
      transform.structured.vectorize %tiled_linalg_op vector_sizes [2, [4], 1] : !transform.any_op
      transform.apply_patterns to %arg0 {
        transform.apply_patterns.vector.reduction_to_contract
        transform.apply_patterns.vector.transfer_permutation_patterns
        transform.apply_patterns.vector.lower_masked_transfers
      } : !transform.op<"func.func">
      transform.apply_patterns to %arg0 {
        transform.apply_patterns.vector.lower_contraction
        transform.apply_patterns.vector.lower_outerproduct
      } : !transform.op<"func.func">
      transform.yield 
    }
    transform.named_sequence @__transform_main(%arg0: !transform.any_op {transform.readonly}) {
      %0 = transform.structured.match ops{["func.func"]} in %arg0 : (!transform.any_op) -> !transform.op<"func.func">
      transform.foreach %0 : !transform.op<"func.func"> {
      ^bb0(%arg1: !transform.op<"func.func">):
        transform.include @tile_and_vectorize_matmul failures(propagate) (%arg1) : (!transform.op<"func.func">) -> ()
      }
      transform.yield 
    }
  }
}

