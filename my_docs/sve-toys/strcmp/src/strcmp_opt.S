.text
.global calc_strcmp_opt            // Declare 'calc_strcmp_opt' as a global function.
.type calc_strcmp_opt, %function   // Define the type of 'calc_strcmp_opt' as a function.

str1        .req x0                // Define 'str1' as an alias for x0, pointer to the first string.
str2        .req x1                // Define 'str2' as an alias for x1, pointer to the second string.
returnDiff  .req x2                // Define 'returnDiff' as an alias for x2, to store the result.

calc_strcmp_opt:                   // Start of the 'calc_strcmp_opt' function.
    ptrue       p5.b               // Set all elements of predicate register p5 to 'true' for byte elements.
    setffr                          // Set the First Fault Register.
    mov         x5, #0             // Initialize the index x5 to 0.

.L_loop:                           // Label for the start of the loop.
    ldff1b      z0.b, p5/z, [str1, x5] // Load bytes from 'str1' at offset 'x5' into z0.
    ldff1b      z1.b, p5/z, [str2, x5] // Load bytes from 'str2' at offset 'x5' into z1.
    rdffrs      p7.b, p5/z             // Read from First Fault Register to p7.
    b.nlast     .L_fault               // Branch to fault handling if there is a last fault.

    incb        x5                     // Increment the index x5 by one byte.
    cmpeq       p0.b, p5/z, z0.b, #0   // Compare bytes in z0 to zero and set p0 accordingly.
    cmpne       p1.b, p5/z, z0.b, z1.b // Compare bytes in z0 and z1 for inequality and set p1 accordingly.

.L_test:                            // Label to test the comparison results.
    orrs        p4.b, p5/z, p0.b, p1.b // OR p0 and p1 predicates and update p4 accordingly.
    b.none      .L_loop                // Branch back to loop if none of the predicates are true.

.L_return:                          // Label for returning from the function.
    brkb        p4.b, p5/z, p4.b       // Break the loop based on p4.
    lasta       w0, p4, z0.b           // Load the last active byte of z0 to w0.
    lasta       w1, p4, z1.b           // Load the last active byte of z1 to w1.
    sub         w0, w0, w1             // Subtract w1 from w0 and store the result in w0.

    mov         returnDiff, str1       // Move 'str1' pointer to 'returnDiff'.

    ret                                 // Return from the function.

.L_fault:                           // Label for fault handling.
    incp        x5, p7.b               // Increment x5 based on the predicate p7.
    setffr                              // Set the First Fault Register.
    cmpeq       p0.b, p7/z, z0.b, #0   // Compare bytes in z0 to zero under p7 predicate.
    cmpne       p1.b, p7/z, z0.b, z1.b // Compare bytes in z0 and z1 for inequality under p7 predicate.
    b           .L_test                // Branch to test the comparison results.

.size calc_strcmp_opt, .-calc_strcmp_opt // Define the size of 'calc_strcmp_opt' function.
