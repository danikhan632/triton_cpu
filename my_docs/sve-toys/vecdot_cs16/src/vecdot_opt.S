
    .text
    .global calc_vecdot_opt
    .type calc_vecdot_opt, %function

    size        .req x0             // N
    aPtr        .req x1             // complex int16_t * a
    bPtr        .req x2             // complex int16_t * b
    outPtr      .req x3             // complex int16_t * c

calc_vecdot_opt:
    dup     z4.d, #0
    dup     z5.d, #0
    dup     z6.d, #0
    dup     z7.d, #0

    ptrue   p2.h
    ptrue   p1.h, VL1
    add     size, aPtr, size, LSL #2

    incb    aPtr
    whilelt p4.b, aPtr, size
    b.nfrst .L_tail_vecdot

.L_unrolled_loop_vecdot:
    ld1h    z0.h, p2/z, [aPtr, #-1, MUL VL]
    ld1h    z2.h, p4/z, [aPtr]
    ld1h    z1.h, p2/z, [bPtr]
    ld1h    z3.h, p4/z, [bPtr, #1, MUL VL]

    cdot    z4.d, z0.h, z1.h, #0
    cdot    z5.d, z0.h, z1.h, #90
    cdot    z6.d, z2.h, z3.h, #0
    cdot    z7.d, z2.h, z3.h, #90

    incb    aPtr, ALL, MUL #2
    incb    bPtr, ALL, MUL #2
    whilelt p4.b, aPtr, size
    b.first .L_unrolled_loop_vecdot

.L_tail_vecdot:
    decb    aPtr
    whilelt p4.b, aPtr, size
    b.nfrst .L_return_vecdot

    ld1h    z0.h, p4/z, [aPtr]
    ld1h    z1.h, p4/z, [bPtr]

    cdot    z4.d, z0.h, z1.h, #0
    cdot    z5.d, z0.h, z1.h, #90

.L_return_vecdot:
    add     z4.d, z4.d, z6.d
    add     z5.d, z5.d, z7.d
    uaddv   d4, p2, z4.d
    uaddv   d5, p2, z5.d
    asr     z4.d, z4.d, #15
    asr     z5.d, z5.d, #15
    st2h    {z4.h, z5.h}, p1, [outPtr]

    ret

    .size calc_vecdot_opt, .-calc_vecdot_opt
