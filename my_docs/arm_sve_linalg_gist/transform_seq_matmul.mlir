// Lower `linalg.matmul` to `vector.outerproduct` - use 4 accumulators.

transform.sequence failures(propagate) {
^bb0(%arg1: !transform.any_op):
  %0 = transform.structured.match ops{["linalg.matmul"]} in %arg1 : (!transform.any_op) -> !transform.any_op
  %tiled, %loops:2 = transform.structured.tile %0 [4, 4] : (!transform.any_op) -> (!transform.any_op, !transform.op<"scf.for">, !transform.op<"scf.for">)
  %1 = get_closest_isolated_parent %tiled : (!transform.any_op) -> !transform.any_op
  %2 = transform.structured.vectorize %1  : (!transform.any_op) -> !transform.any_op
  %3 = transform.structured.match ops{["scf.for"]} in %2 : (!transform.any_op) -> !transform.op<"scf.for">
  transform.loop.unroll %3 { factor = 2 } : !transform.op<"scf.for">
}