//-------------------------------------------------
// DESIRED LOWERING FOR SME - HAND WRITTEN
// linalg.matmul as vector.contract
// 
// Overview:
//   * element type - f32
//   * number of vector.contract accumulators - 4
//   * C is partitioned into 4 tiles
//   * A and B are partitioned into 2 halves
//   * A is transposed before entering the kernel
//-------------------------------------------------

  // %mat_A_tr - transpose of A

  #map = affine_map<(d0, d1, d2) -> (d0, d2)>
  #map1 = affine_map<(d0, d1, d2) -> (d2, d1)>
  #map2 = affine_map<(d0, d1, d2) -> (d0, d1)>
  module attributes { transform.with_named_sequence } {
    func.func @outerproduct_matmul(%mat_A_tr: memref<6x8xf32>, %mat_B: memref<6x8xf32>, %mat_C: memref<8x8xf32>) {
      %c0 = arith.constant 0 : index
      %c4 = arith.constant 4 : index
      %cst = arith.constant 0.000000e+00 : f32
      // Tile 0
      %tile0_C = vector.transfer_read %mat_C[%c0, %c0], %cst {in_bounds = [true, true]} : memref<8x8xf32>, vector<4x4xf32>
      // Tile 1
      %tile1_C = vector.transfer_read %mat_C[%c0, %c4], %cst {in_bounds = [true, true]} : memref<8x8xf32>, vector<4x4xf32>
      // Tile 2
      %tile2_C = vector.transfer_read %mat_C[%c4, %c0], %cst {in_bounds = [true, true]} : memref<8x8xf32>, vector<4x4xf32>
      // Tile 3
      %tile3_C = vector.transfer_read %mat_C[%c4, %c4], %cst {in_bounds = [true, true]} : memref<8x8xf32>, vector<4x4xf32>

      // Tile upper - A
      %tile_A_hi = vector.transfer_read %mat_A_tr[%c0, %c0], %cst {in_bounds = [true, true]} : memref<6x8xf32>, vector<6x4xf32>
      // Tile lower - A
      %tile_A_lo = vector.transfer_read %mat_A_tr[%c0, %c4], %cst {in_bounds = [true, true]} : memref<6x8xf32>, vector<6x4xf32>
      // Tile left - B
      %tile_B_left = vector.transfer_read %mat_B[%c0, %c0], %cst {in_bounds = [true, true]} : memref<6x8xf32>, vector<6x4xf32>
      // Tile right - B
      %tile_B_right = vector.transfer_read %mat_B[%c0, %c4], %cst {in_bounds = [true, true]} : memref<6x8xf32>, vector<6x4xf32>

      %tile_A_hi_tr = vector.transpose %tile_A_hi, [1, 0] : vector<6x4xf32> to vector<4x6xf32>
      %tile_A_lo_tr = vector.transpose %tile_A_lo, [1, 0] : vector<6x4xf32> to vector<4x6xf32>

      // Compute upper half of C
      %tile0_matmul = vector.contract {indexing_maps = [#map, #map1, #map2], iterator_types = ["parallel", "parallel", "reduction"], kind = #vector.kind<add>} %tile_A_hi_tr, %tile_B_left, %tile0_C : vector<4x6xf32>, vector<6x4xf32> into vector<4x4xf32>
      %tile1_matmul = vector.contract {indexing_maps = [#map, #map1, #map2], iterator_types = ["parallel", "parallel", "reduction"], kind = #vector.kind<add>} %tile_A_hi_tr, %tile_B_right, %tile1_C : vector<4x6xf32>, vector<6x4xf32> into vector<4x4xf32>

      // Compute lower half of C
      %tile2_matmul = vector.contract {indexing_maps = [#map, #map1, #map2], iterator_types = ["parallel", "parallel", "reduction"], kind = #vector.kind<add>} %tile_A_lo_tr, %tile_B_left, %tile2_C : vector<4x6xf32>, vector<6x4xf32> into vector<4x4xf32>
      %tile3_matmul = vector.contract {indexing_maps = [#map, #map1, #map2], iterator_types = ["parallel", "parallel", "reduction"], kind = #vector.kind<add>} %tile_A_lo_tr, %tile_B_right, %tile3_C : vector<4x6xf32>, vector<6x4xf32> into vector<4x4xf32>

      vector.transfer_write %tile0_matmul, %mat_C[%c0, %c0] {in_bounds = [true, true]} : vector<4x4xf32>, memref<8x8xf32>
      vector.transfer_write %tile1_matmul, %mat_C[%c0, %c4] {in_bounds = [true, true]} : vector<4x4xf32>, memref<8x8xf32>
      vector.transfer_write %tile2_matmul, %mat_C[%c4, %c0] {in_bounds = [true, true]} : vector<4x4xf32>, memref<8x8xf32>
      vector.transfer_write %tile3_matmul, %mat_C[%c4, %c4] {in_bounds = [true, true]} : vector<4x4xf32>, memref<8x8xf32>
      return
    }