//-------------------------------------------------
// DESIRED LOWERING FOR SME - HAND WRITTEN
// linalg.matmul as vector.outerproduct
// 
// Overview:
//   * element type - f32
//   * number of OP accumulators - 4
//   * C is partitioned into 4 tiles
//   * A and B are partitioned into 2 halves
//   * A is transposed before entering the kernel
//-------------------------------------------------

// LEGEND: 
//  Matrix C. Each tile is [SVL_s x SVL_s] (4x4xf32 in this example)
// -----------------------------
// |            |              |
// |            |              |
// |  tile0_C   |   tile1_C    |
// |            |              |
// |            |              |
// -----------------------------
// |            |              |
// |            |              |
// |  tile2_C   |  tile3_C     |
// |            |              |
// |            |              |
// -----------------------------
 
//  Matrix B. Each tile is [K x SVL_s] (6x4xf32 in this example)
// ----------------------------------
// |               |                |
// |               |                |
// |  tile_B_left  |  tile_B_right  |
// |               |                |
// |               |                |
// ---------------------------------|
 
//  Matrix A transpose. Each tile is [K x SVL_s] (6x4xf32 in this example)
// ----------------------------------
// |               |                |
// |               |                |
// |  tile_A_upper |  tile_A_lower  |
// |               |                |
// |               |                |
// ---------------------------------|
// Columns of A are rows of A^T.
 
// Row 3 of matrix B. Each half is SVL_s long (4xf32 in this example)
// -----------------------------
// | B_row_3_0  | B_row_3_1    |
// -----------------------------
//    half 0        half 1
 
// %mat_A_tr - transpose of A
module {
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
 
 
    // ===================================================================================================================
    //  1 COMPUTE UPPER HALF OF C
    // ===================================================================================================================
    // 1.1 Input tile "upper" from A and "left" from B - accumulate to ZA0.s (tile 0 of C)
    %A_col_0_0 = vector.extract %tile_A_hi[0] : vector<6x4xf32>
    %A_col_1_0 = vector.extract %tile_A_hi[1] : vector<6x4xf32>
    %A_col_2_0 = vector.extract %tile_A_hi[2] : vector<6x4xf32>
    %A_col_3_0 = vector.extract %tile_A_hi[3] : vector<6x4xf32>
    %A_col_4_0 = vector.extract %tile_A_hi[4] : vector<6x4xf32>
    %A_col_5_0 = vector.extract %tile_A_hi[5] : vector<6x4xf32>
 
    %B_row_0_0 = vector.extract %tile_B_left[0] : vector<6x4xf32>
    %B_row_1_0 = vector.extract %tile_B_left[1] : vector<6x4xf32>
    %B_row_2_0 = vector.extract %tile_B_left[2] : vector<6x4xf32>
    %B_row_3_0 = vector.extract %tile_B_left[3] : vector<6x4xf32>
    %B_row_4_0 = vector.extract %tile_B_left[3] : vector<6x4xf32>
    %B_row_5_0 = vector.extract %tile_B_left[3] : vector<6x4xf32>
 
    %op_0 = vector.outerproduct %A_col_0_0, %B_row_0_0, %tile0_C {kind = #vector.kind<add>} : vector<4xf32>, vector<4xf32>
    %op_1 = vector.outerproduct %A_col_1_0, %B_row_1_0, %op_0 {kind = #vector.kind<add>} : vector<4xf32>, vector<4xf32>
    %op_2 = vector.outerproduct %A_col_2_0, %B_row_2_0, %op_1 {kind = #vector.kind<add>} : vector<4xf32>, vector<4xf32>
    %op_3 = vector.outerproduct %A_col_3_0, %B_row_3_0, %op_2 {kind = #vector.kind<add>} : vector<4xf32>, vector<4xf32>
    %op_4 = vector.outerproduct %A_col_4_0, %B_row_4_0, %op_3 {kind = #vector.kind<add>} : vector<4xf32>, vector<4xf32>
    %op_5 = vector.outerproduct %A_col_5_0, %B_row_5_0, %op_4 {kind = #vector.kind<add>} : vector<4xf32>, vector<4xf32>
 
    vector.transfer_write %op_5, %mat_C[%c0, %c0] {in_bounds = [true, true]} : vector<4x4xf32>, memref<8x8xf32>
 
    // 1.2 Input tile "upper" from A and "right" from B - accumulate to ZA1.s (tile 1 of C)
    %B_row_0_1 = vector.extract %tile_B_right[0] : vector<6x4xf32>
    %B_row_1_1 = vector.extract %tile_B_right[1] : vector<6x4xf32>
    %B_row_2_1 = vector.extract %tile_B_right[2] : vector<6x4xf32>
    %B_row_3_1 = vector.extract %tile_B_right[3] : vector<6x4xf32>
    %B_row_4_1 = vector.extract %tile_B_right[3] : vector<6x4xf32>
    %B_row_5_1 = vector.extract %tile_B_right[3] : vector<6x4xf32>
 
    %op_6  = vector.outerproduct %A_col_0_0, %B_row_0_1, %tile1_C {kind = #vector.kind<add>} : vector<4xf32>, vector<4xf32>
    %op_7  = vector.outerproduct %A_col_1_0, %B_row_1_1, %op_6  {kind = #vector.kind<add>} : vector<4xf32>, vector<4xf32>
    %op_8  = vector.outerproduct %A_col_2_0, %B_row_2_1, %op_7  {kind = #vector.kind<add>} : vector<4xf32>, vector<4xf32>
    %op_9  = vector.outerproduct %A_col_3_0, %B_row_3_1, %op_8  {kind = #vector.kind<add>} : vector<4xf32>, vector<4xf32>
    %op_10 = vector.outerproduct %A_col_4_0, %B_row_4_1, %op_9  {kind = #vector.kind<add>} : vector<4xf32>, vector<4xf32>
    %op_11 = vector.outerproduct %A_col_5_0, %B_row_5_1, %op_10 {kind = #vector.kind<add>} : vector<4xf32>, vector<4xf32>
 
    vector.transfer_write %op_11, %mat_C[%c0, %c4] {in_bounds = [true, true]} : vector<4x4xf32>, memref<8x8xf32>
 
    // ===================================================================================================================
    //  2 COMPUTE LOWER HALF OF C
    // ===================================================================================================================
    // 2.1 Input tile "lower" for A and tile left from B - accumulate to ZA2.s (tile 2 of C)
    %A_col_0_1 = vector.extract %tile_A_lo[0] : vector<6x4xf32>
    %A_col_1_1 = vector.extract %tile_A_lo[1] : vector<6x4xf32>
    %A_col_2_1 = vector.extract %tile_A_lo[2] : vector<6x4xf32>
    %A_col_3_1 = vector.extract %tile_A_lo[3] : vector<6x4xf32>
    %A_col_4_1 = vector.extract %tile_A_lo[4] : vector<6x4xf32>
    %A_col_5_1 = vector.extract %tile_A_lo[5] : vector<6x4xf32>
 
    %op_12 = vector.outerproduct %A_col_0_1, %B_row_0_0, %tile2_C {kind = #vector.kind<add>} : vector<4xf32>, vector<4xf32>
    %op_13 = vector.outerproduct %A_col_1_1, %B_row_1_0, %op_12 {kind = #vector.kind<add>} : vector<4xf32>, vector<4xf32>
    %op_14 = vector.outerproduct %A_col_2_1, %B_row_2_0, %op_13 {kind = #vector.kind<add>} : vector<4xf32>, vector<4xf32>
    %op_15 = vector.outerproduct %A_col_3_1, %B_row_3_0, %op_14 {kind = #vector.kind<add>} : vector<4xf32>, vector<4xf32>
    %op_16 = vector.outerproduct %A_col_3_1, %B_row_4_0, %op_15 {kind = #vector.kind<add>} : vector<4xf32>, vector<4xf32>
    %op_17 = vector.outerproduct %A_col_3_1, %B_row_5_0, %op_16 {kind = #vector.kind<add>} : vector<4xf32>, vector<4xf32>
 
    vector.transfer_write %op_17, %mat_C[%c4, %c0] {in_bounds = [true, true]} : vector<4x4xf32>, memref<8x8xf32>
 
    // 2.2 Input tile "lower" from A and tile "right" from B - accumulate to ZA3.s (tile 3 of C)
    %op_18 = vector.outerproduct %A_col_0_1, %B_row_0_1, %tile3_C {kind = #vector.kind<add>} : vector<4xf32>, vector<4xf32>
    %op_19 = vector.outerproduct %A_col_1_1, %B_row_1_1, %op_18 {kind = #vector.kind<add>} : vector<4xf32>, vector<4xf32>
    %op_20 = vector.outerproduct %A_col_2_1, %B_row_2_1, %op_19 {kind = #vector.kind<add>} : vector<4xf32>, vector<4xf32>
    %op_21 = vector.outerproduct %A_col_3_1, %B_row_3_1, %op_20 {kind = #vector.kind<add>} : vector<4xf32>, vector<4xf32>
    %op_22 = vector.outerproduct %A_col_3_1, %B_row_4_1, %op_21 {kind = #vector.kind<add>} : vector<4xf32>, vector<4xf32>
    %op_23 = vector.outerproduct %A_col_3_1, %B_row_5_1, %op_22 {kind = #vector.kind<add>} : vector<4xf32>, vector<4xf32>
 
    vector.transfer_write %op_23, %mat_C[%c4, %c4] {in_bounds = [true, true]} : vector<4x4xf32>, memref<8x8xf32>
 
    return
  }
}