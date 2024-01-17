.text
.global calc_fir_opt                // Declare 'calc_fir_opt' as a global function.
.type calc_fir_opt, %function       // Define the type of 'calc_fir_opt' as a function.

size        .req x0                 // Define 'size' as an alias for x0, representing the number of samples.
taps        .req x1                 // Define 'taps' as an alias for x1, representing the number of filter coefficients.
xPtr        .req x2                 // Define 'xPtr' as an alias for x2, pointer to the input samples array.
hPtr        .req x3                 // Define 'hPtr' as an alias for x3, pointer to the filter coefficients array.
yPtr        .req x4                 // Define 'yPtr' as an alias for x4, pointer to the output samples array.

calc_fir_opt:                       // Start of the 'calc_fir_opt' function.
    add         size, yPtr, size, LSL #1 // Calculate the ending address of the output array.
    whilelt     p4.b, yPtr, size         // Initialize predicate register p4 for loop iteration.
    add         taps, hPtr, taps, LSL #1 // Calculate the ending address of the filter coefficients array.
    ptrue       p5.h                     // Set all elements of predicate register p5 to 'true' for half-word elements.
    b.none      .L_return                // Exit if no work is to be done.

.L_FIR_outer_loop:                 // Label for the outer loop of the FIR filter calculation.
    mov         x6, #0             // Initialize the sample index to 0.
    mov         x7, hPtr           // Initialize the coefficient index to the start of the filter coefficients.
    ld1h        z2.h, p4/z, [xPtr, x6, LSL #1] // Load input sample into z2.
    ld1rh       z1.h, p5/z, [x7]               // Load and broadcast the first filter coefficient into z1.
    add         x6, x6, #1                     // Increment the sample index.
    add         x7, x7, #2                     // Increment the coefficient index.
    smullb      z3.s, z2.h, z1.h               // Perform signed multiply long of lower halves of z2 and z1.
    smullt      z4.s, z2.h, z1.h               // Perform signed multiply long of upper halves of z2 and z1.

.L_FIR_inner_loop:                 // Label for the inner loop of the FIR filter calculation.
    ld1h        z2.h, p4/z, [xPtr, x6, LSL #1] // Load next input sample into z2.
    ld1rh       z1.h, p5/z, [x7]               // Load and broadcast next filter coefficient into z1.
    add         x6, x6, #1                     // Increment the sample index.
    add         x7, x7, #2                     // Increment the coefficient index.
    smlalb      z3.s, z2.h, z1.h               // Accumulate multiply long of lower halves of z2 and z1.
    smlalt      z4.s, z2.h, z1.h               // Accumulate multiply long of upper halves of z2 and z1.
    cmp         x7, taps                       // Compare coefficient index with the number of taps.
    b.mi        .L_FIR_inner_loop              // Continue inner loop if more coefficients are to be processed.

    sqshrnb     z3.h, z3.s, #16                // Shift and narrow the results in z3.
    sqshrnt     z3.h, z4.s, #16                // Shift and narrow the results in z4, append to z3.
    st1h        z3.h, p4, [yPtr]               // Store the result to the output array.
    incb        yPtr                           // Increment the output pointer.
    addvl       xPtr, xPtr, #1                 // Increment the input pointer.
    whilelt     p4.b, yPtr, size               // Check if more output samples are to be processed.
    b.first     .L_FIR_outer_loop             // Repeat the outer loop if condition is true.

.L_return: // Label for returning from the function.
ret // Return from the function.

.size calc_fir_opt, .-calc_fir_opt // Define the size of 'calc_fir_opt' function.
