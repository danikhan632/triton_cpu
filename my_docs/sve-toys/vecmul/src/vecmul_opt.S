
.text
.global calc_vecmul_opt              // Declare 'calc_vecmul_opt' as a global function.
.type calc_vecmul_opt, %function     // Define the type of 'calc_vecmul_opt' as a function.

size        .req x0                  // Define 'size' as an alias for x0, representing the size of vectors.
aPtr        .req x1                  // Define 'aPtr' as an alias for x1, pointer to the first input vector (complex int16).
bPtr        .req x2                  // Define 'bPtr' as an alias for x2, pointer to the second input vector (complex int16).
outPtr      .req x3                  // Define 'outPtr' as an alias for x3, pointer to the output vector (complex int16).

aPtr_1st    .req x4                  // Auxiliary pointer for first input vector.
bPtr_1st    .req x5                  // Auxiliary pointer for second input vector.
outPtr_1st  .req x6                  // Auxiliary pointer for output vector.
count       .req x7                  // Loop counter.

calc_vecmul_opt:                     // Start of the 'calc_vecmul_opt' function.
    ptrue       p2.h                 // Set all elements of predicate register p2 to 'true' for half-word elements.
    lsl         size, size, #1       // Left shift 'size' by 1 (complex numbers have two parts).
    dup         z31.s, #0            // Initialize Z register z31 to zero.

    cnth        count                // Initialize the 'count' with the current core's hardware thread ID.
    whilelt     p4.h, count, size    // Initialize predicate register p4 for loop iteration.
    b.nfrst     .L_tail_vecmul       // Jump to tail handling if necessary.

    addvl       aPtr_1st, aPtr, #-1  // Initialize 'aPtr_1st' for vector loading.
    addvl       bPtr_1st, bPtr, #-1  // Initialize 'bPtr_1st' for vector loading.
    addvl       outPtr_1st, outPtr, #-1 // Initialize 'outPtr_1st' for vector storing.

.L_unrolled_loop_vecmul:             // Label for the start of the unrolled loop.
    ld1h        z0.h, p2/z, [aPtr_1st, count, LSL #1] // Load half-words from 'aPtr_1st' into z0.
    ld1h        z2.h, p4/z, [aPtr, count, LSL #1]     // Load half-words from 'aPtr' into z2.
    ld1h        z1.h, p2/z, [bPtr_1st, count, LSL #1] // Load half-words from 'bPtr_1st' into z1.
    ld1h        z3.h, p4/z, [bPtr, count, LSL #1]     // Load half-words from 'bPtr' into z3.

    movprfx     z4, z31              // Move prefix to initialize z4 with z31's content (zero).
    sqrdcmlah   z4.h, z0.h, z1.h, #0 // Complex multiply-accumulate operation part 1.
    sqrdcmlah   z4.h, z0.h, z1.h, #90 // Complex multiply-accumulate operation part 2.

    movprfx     z5, z31              // Move prefix to initialize z5 with z31's content (zero).
    sqrdc

mlah   z5.h, z2.h, z3.h, #0 // Complex multiply-accumulate operation part 1 for second pair.
    sqrdcmlah   z5.h, z2.h, z3.h, #90 // Complex multiply-accumulate operation part 2 for second pair.

    st1h        z4.h, p2, [outPtr_1st, count, LSL #1] // Store the result from z4 to 'outPtr_1st'.
    st1h        z5.h, p4, [outPtr, count, LSL #1]     // Store the result from z5 to 'outPtr'.
    inch        count, ALL, MUL #2                    // Increment 'count' by two for next iteration.

    whilelt     p4.h, count, size                     // Check if 'count' is still less than 'size'.
    b.first     .L_unrolled_loop_vecmul               // Repeat the unrolled loop if condition is true.

.L_tail_vecmul:                                      // Label for handling remaining elements.
    dech        count                                 // Decrement 'count' for tail processing.
    whilelt     p2.h, count, size                     // Set up predicate register p2 for remaining elements.
    b.nfrst     .L_return_vecmul                      // Jump to final store if no more elements.

    ld1h        z0.h, p2/z, [aPtr, count, LSL #1]     // Load remaining half-words from 'aPtr' into z0.
    ld1h        z1.h, p2/z, [bPtr, count, LSL #1]     // Load remaining half-words from 'bPtr' into z1.

    movprfx     z4, z31                               // Move prefix to initialize z4 with z31's content (zero).
    sqrdcmlah   z4.h, z0.h, z1.h, #0                  // Complex multiply-accumulate operation part 1 for tail.
    sqrdcmlah   z4.h, z0.h, z1.h, #90                 // Complex multiply-accumulate operation part 2 for tail.
    st1h        z4.h, p2, [outPtr, count, LSL #1]     // Store the result from z4 to 'outPtr'.

.L_return_vecmul:                                    // Label for returning from function.
    ret                                               // Return from the function.

.size calc_vecmul_opt, .-calc_vecmul_opt             // Define the size of 'calc_vecmul_opt' function.
