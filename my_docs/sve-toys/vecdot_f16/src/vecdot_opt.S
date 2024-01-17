.text
.global calc_vecdot_opt              // Declare 'calc_vecdot_opt' as a global function.
.type calc_vecdot_opt, %function     // Define the type of 'calc_vecdot_opt' as a function.

size        .req x0                  // Define 'size' as an alias for x0, representing the size of vectors.
aPtr        .req x1                  // Define 'aPtr' as an alias for x1, pointer to the first input vector.
bPtr        .req x2                  // Define 'bPtr' as an alias for x2, pointer to the second input vector.
outPtr      .req x3                  // Define 'outPtr' as an alias for x3, pointer to the output vector.

calc_vecdot_opt:                     // Start of the 'calc_vecdot_opt' function.
    dup     z4.d, #0                 // Initialize Z register z4 to zero.
    dup     z5.d, #0                 // Initialize Z register z5 to zero.
    dup     z6.d, #0                 // Initialize Z register z6 to zero.
    dup     z7.d, #0                 // Initialize Z register z7 to zero.

    ptrue   p2.h                     // Set all elements of predicate register p2 to 'true' for half-word elements.
    add     size, aPtr, size, LSL #1 // Calculate the ending address of the first vector.
    incb    aPtr                     // Increment the pointer to the first vector by one byte.
    whilelt p4.b, aPtr, size         // Initialize predicate register p4 for loop iteration.
    b.nfrst .L_tail_vecdot           // Jump to tail handling if necessary.

.L_unrolled_loop_vecdot:             // Label for the start of the unrolled loop.
    ld1h    z0.h, p2/z, [aPtr, #-1, MUL VL] // Load half-words from 'aPtr' into z0 using p2 predicate.
    ld1h    z2.h, p4/z, [aPtr]              // Load half-words from 'aPtr' into z2 using p4 predicate.
    ld1h    z1.h, p2/z, [bPtr]              // Load half-words from 'bPtr' into z1 using p2 predicate.
    ld1h    z3.h, p4/z, [bPtr, #1, MUL VL]  // Load half-words from 'bPtr' into z3 using p4 predicate.

    fmlalb  z4.s, z0.h, z1.h                // Perform fused multiply-add on z0 and z1, lower half, accumulate in z4.
    fmlalt  z5.s, z0.h, z1.h                // Perform fused multiply-add on z0 and z1, upper half, accumulate in z5.
    fmlalb  z6.s, z2.h, z3.h                // Perform fused multiply-add on z2 and z3, lower half, accumulate in z6.
    fmlalt  z7.s, z2.h, z3.h                // Perform fused multiply-add on z2 and z3, upper half, accumulate in z7.

    incb    aPtr, ALL, MUL #2               // Increment 'aPtr' by two bytes.
    incb    bPtr, ALL, MUL #2               // Increment 'bPtr' by two bytes.
    whilelt p4.b, aPtr, size                // Check if 'aPtr' is still less than the end address.
    b.first .L_unrolled_loop_vecdot         // Repeat the unrolled loop if condition is true.

.L_tail_vecdot:                             // Label for handling remaining elements.
    decb    aPtr                             // Decrement 'aPtr' by one byte.
    whilelt p4.b, aPtr, size                 // Set up predicate register p4 for remaining elements.
    b.nfrst .L_return_vecdot                 // Jump to final reduction if no more elements.

    ld1h    z0.h, p4/z, [aPtr]               // Load remaining half-words from 'aPtr' into z0.
    ld1h    z1.h, p4/z, [bPtr]               // Load remaining half-words from 'bPtr' into z1.

    fmlalb  z4.s, z0.h, z1.h                 // Perform fused multiply-add on remaining elements, accumulate in z4.
    fmlalt  z5.s, z0.h, z1.h                 // Perform fused multiply-add on remaining elements, accumulate in z5.

.L_return_vecdot:                           // Label for final reduction and result storage.
    fadd    z4.s, z4.s, z5.s                 // Add the results in z4 and z5.
    fadd    z6.s, z6.s, z7.s                 // Add the results in z6 and z7.
    fadd    z6.s, z6.s, z4.s                 // Add the results of previous additions.
    faddv   s6, p2, z6.s                     // Perform horizontal addition across z6 and store in scalar register s6.
    str     s6, [outPtr]                     // Store the final result to the memory pointed by 'outPtr'.

    ret                                      // Return from the function.

.size calc_vecdot_opt, .-calc_vecdot_opt    // Define the size of 'calc_vecdot_opt' function.
