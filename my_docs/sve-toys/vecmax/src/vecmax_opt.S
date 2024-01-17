.text
.global calc_vecmax_first_opt            // Declare 'calc_vecmax_first_opt' as a global function.
.type calc_vecmax_first_opt, %function   // Define the type of 'calc_vecmax_first_opt' as a function.

srcPtr      .req x0                      // Define 'srcPtr' as an alias for x0, pointer to the source vector.
size        .req x1                      // Define 'size' as an alias for x1, the size of the vector.
maxElemPtr  .req x2                      // Define 'maxElemPtr' as an alias for x2, pointer to store the maximum element.
maxIndexPtr .req x3                      // Define 'maxIndexPtr' as an alias for x3, pointer to store the index of the maximum element.

calc_vecmax_first_opt:                   // Start of the 'calc_vecmax_first_opt' function.
    uxth        w1, w1                   // Zero extend the size from 16 to 32 bits.
    mov         x7, #0                   // Initialize index x7 to 0.
    dup         z0.h, #-1                // Initialize z0 with all elements set to -1.
    whilelt     p1.h, x7, size           // Initialize predicate register p1 for loop iteration.
    ld1h        z5.h, p1/z, [srcPtr]     // Load half-word elements from 'srcPtr' into z5.
    index       z1.h, #0, #1             // Create an index vector in z1 (0, 1, 2, ...).
    inch        x7                       // Increment index x7 by one half-word.
    whilelt     p2.h, x7, size           // Initialize predicate register p2 for next loop iteration.
    b.none      .LoopEnd                 // If no elements left, go to LoopEnd.
    mov         z2.d, z1.d               // Copy index vector from z1 to z2.

.LoopStart:                              // Label for the start of the loop.
    ld1h        z6.h, p2/z, [srcPtr, x7, LSL #1] // Load next half-word elements from 'srcPtr' into z6.
    inch        z2.h                     // Increment all elements in index vector z2.
    inch        x7                       // Increment index x7 by one half-word.
    cmpgt       p3.h, p2/z, z6.h, z5.h   // Compare elements of z6 with z5 and update predicate p3.
    smax        z5.h, p2/m, z5.h, z6.h   // Select max elements between z5 and z6 and store in z5.
    sel         z1.h, p3, z2.h, z1.h     // Select corresponding index from z2 or z1 based on p3 and store in z1.
    whilelt     p2.h, x7, size           // Update predicate p2 for the next iteration.
    b.first     .LoopStart               // Repeat the loop if more elements to process.

.LoopEnd:                                // Label for the end of the loop.
    smaxv       h6, p1, z5.h             // Reduce z5 to find the max value and store in h6.
    mov         z6.h, h6                 // Move the max value to all lanes of z6.
    cmpeq       p2.h, p1/z, z5.h, z6.h   // Compare all elements of z5 with max value and update p2.
    ptrue       p0.h                     // Set all elements of predicate register p0 to 'true'.
    sel         z1.h, p2, z1.h, z0.h     // Select index from z1 where max value occurs first and store in z1.
uminv h7, p0, z1.h // Find the minimum index (first occurrence) from z1 and store in h7.
str h6, [maxElemPtr] // Store the maximum element value to the memory pointed by 'maxElemPtr'.
str h7, [maxIndexPtr] // Store the index of the maximum element to the memory pointed by 'maxIndexPtr'.
ret                                 // Return from the function.
.size calc_vecmax_first_opt, .-calc_vecmax_first_opt // Define the size of 'calc_vecmax_first_opt' function.