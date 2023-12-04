// Lower `vector.contract` to `vector.outerproduct`

transform.sequence failures(propagate) {
 ^bb1(%arg1: !transform.any_op):
   %0 = transform.structured.match ops{["vector.contract"]} in %arg1 : (!transform.any_op) -> !transform.any_op
   %1 = transform.get_closest_isolated_parent %0 : (!transform.any_op) -> !transform.any_op
   %2 = transform.merge_handles %1 { deduplicate } : !transform.any_op
   transform.apply_patterns to %2 {
    transform.apply_patterns.vector.lower_contraction lowering_strategy = "outerproduct"
   } : !transform.any_op
}