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
  // A sequence that will tile and vectorise a Matmul Op
  transform.named_sequence @tile_and_vectorize_matmul(%func
    : !transform.op<"func.func"> {transform.readonly}) {

    // Step 0: Get a handle to the matmul Op
    %matmul = transform.structured.match ops{["linalg.matmul"]} in %func : (!transform.op<"func.func">) -> !transform.any_op

    // Step 1: Tile
    %tiled_matmul, %loops:3 = transform.structured.tile_using_for %matmul [2, [4], 1]
      : (!transform.any_op) -> (!transform.any_op, !transform.any_op, !transform.any_op, !transform.any_op)
    transform.print %tiled_matmul {name = "matmul lal"}: !transform.any_op

    // Step 2: Vectorize
    transform.structured.vectorize %tiled_matmul vector_sizes [2, [4], 1] : !transform.any_op

    // Step 3: Lower vector.multi_reduction to vector.contract (+ some helpful patterns)
    transform.apply_patterns to %func {
      transform.apply_patterns.vector.reduction_to_contract
      transform.apply_patterns.vector.transfer_permutation_patterns
      transform.apply_patterns.vector.lower_masked_transfers
    } : !transform.op<"func.func">

    // Step 4: Lower vector.contract to vector.fma
    transform.apply_patterns to %func {
      transform.apply_patterns.vector.lower_contraction lowering_strategy = "outerproduct"
      transform.apply_patterns.vector.lower_outerproduct
    } : !transform.op<"func.func">

    transform.yield
  }

  // A sequence that goes over all functions in tis module and applies
  // "tile_and_vectorize_matmul"
  transform.named_sequence @__transform_main(%module: !transform.any_op {transform.readonly}) {
    %funcs = transform.structured.match ops{["func.func"]} in %module
        : (!transform.any_op) -> !transform.op<"func.func">

    transform.foreach %funcs : !transform.op<"func.func"> {
      ^bb2(%func : !transform.op<"func.func">):
        transform.include @tile_and_vectorize_matmul failures(propagate)
        (%func) : (!transform.op<"func.func">) -> ()
    }
    transform.yield
  }
}