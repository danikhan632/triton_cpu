	.text
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_a2p1_f2p2_zicond1p0_zicsr2p0"
	.file	"LLVMDialectModule"
	.globl	matmul_kernel_0d1d2d34567c89c1011c # -- Begin function matmul_kernel_0d1d2d34567c89c1011c
	.p2align	2
	.type	matmul_kernel_0d1d2d34567c89c1011c,@function
matmul_kernel_0d1d2d34567c89c1011c:     # @matmul_kernel_0d1d2d34567c89c1011c
	.cfi_startproc
# %bb.0:
	addi	sp, sp, -272
	.cfi_def_cfa_offset 272
	sw	ra, 268(sp)                     # 4-byte Folded Spill
	sw	s0, 264(sp)                     # 4-byte Folded Spill
	sw	s1, 260(sp)                     # 4-byte Folded Spill
	sw	s2, 256(sp)                     # 4-byte Folded Spill
	sw	s3, 252(sp)                     # 4-byte Folded Spill
	sw	s4, 248(sp)                     # 4-byte Folded Spill
	sw	s5, 244(sp)                     # 4-byte Folded Spill
	sw	s6, 240(sp)                     # 4-byte Folded Spill
	sw	s7, 236(sp)                     # 4-byte Folded Spill
	sw	s8, 232(sp)                     # 4-byte Folded Spill
	sw	s9, 228(sp)                     # 4-byte Folded Spill
	sw	s10, 224(sp)                    # 4-byte Folded Spill
	sw	s11, 220(sp)                    # 4-byte Folded Spill
	fsw	fs0, 216(sp)                    # 4-byte Folded Spill
	fsw	fs1, 212(sp)                    # 4-byte Folded Spill
	fsw	fs2, 208(sp)                    # 4-byte Folded Spill
	.cfi_offset ra, -4
	.cfi_offset s0, -8
	.cfi_offset s1, -12
	.cfi_offset s2, -16
	.cfi_offset s3, -20
	.cfi_offset s4, -24
	.cfi_offset s5, -28
	.cfi_offset s6, -32
	.cfi_offset s7, -36
	.cfi_offset s8, -40
	.cfi_offset s9, -44
	.cfi_offset s10, -48
	.cfi_offset s11, -52
	.cfi_offset fs0, -56
	.cfi_offset fs1, -60
	.cfi_offset fs2, -64
	addi	s0, sp, 272
	.cfi_def_cfa s0, 0
	lw	a0, 40(s0)
	lw	a1, 24(s0)
	sw	a1, -252(s0)                    # 4-byte Folded Spill
	lw	a1, 20(s0)
	sw	a1, -72(s0)                     # 4-byte Folded Spill
	lw	s8, 16(s0)
	lw	a1, 12(s0)
	sw	a1, -212(s0)                    # 4-byte Folded Spill
	lw	a1, 8(s0)
	sw	a1, -200(s0)                    # 4-byte Folded Spill
	lw	s2, 4(s0)
	lw	a1, 0(s0)
	sw	a1, -264(s0)                    # 4-byte Folded Spill
	sw	a5, -216(s0)                    # 4-byte Folded Spill
	sw	a2, -220(s0)                    # 4-byte Folded Spill
	li	a1, 0
	li	a2, 0
	lui	a3, %hi(.Lshared_mem_1152920405095242752)
	addi	a3, a3, %lo(.Lshared_mem_1152920405095242752)
	j	.LBB0_2
.LBB0_1:                                #   in Loop: Header=BB0_2 Depth=1
	addi	a1, a1, 1
	seqz	a4, a1
	add	a2, a2, a4
.LBB0_2:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_4 Depth 2
	sgtz	a4, a2
	czero.eqz	a4, a4, a2
	sltiu	a5, a1, 32
	xori	a5, a5, 1
	czero.nez	a5, a5, a2
	or	a4, a5, a4
	bnez	a4, .LBB0_6
# %bb.3:                                # %.preheader12
                                        #   in Loop: Header=BB0_2 Depth=1
	li	a5, 0
	slli	a6, a1, 6
.LBB0_4:                                #   Parent Loop BB0_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	sgtz	a7, a5
	czero.eqz	a7, a7, a5
	sltiu	t0, a4, 64
	xori	t0, t0, 1
	czero.nez	t0, t0, a5
	or	a7, t0, a7
	bnez	a7, .LBB0_1
# %bb.5:                                #   in Loop: Header=BB0_4 Depth=2
	add	a7, a6, a4
	slli	a7, a7, 2
	add	a7, a3, a7
	sw	zero, 0(a7)
	addi	a4, a4, 1
	seqz	a7, a4
	add	a5, a5, a7
	j	.LBB0_4
.LBB0_6:
	addi	a1, s2, 31
	srai	a2, a1, 31
	srli	a2, a2, 27
	add	a1, a1, a2
	srai	a1, a1, 5
	lw	s1, -200(s0)                    # 4-byte Folded Reload
	addi	a2, s1, 63
	srai	a3, a2, 31
	srli	a3, a3, 26
	add	a2, a2, a3
	srai	a2, a2, 6
	slli	a2, a2, 3
	div	a3, a0, a2
	slli	a3, a3, 3
	sub	a1, a1, a3
	slti	a4, a1, 8
	czero.eqz	a1, a1, a4
	li	a5, 8
	czero.nez	a4, a5, a4
	or	a1, a1, a4
	rem	a4, a0, a1
	add	a3, a3, a4
	rem	a0, a0, a2
	div	a0, a0, a1
	slli	a3, a3, 5
	slli	s6, a0, 6
	srai	s4, s8, 31
	mulh	s3, a3, s8
	sw	a3, -256(s0)                    # 4-byte Folded Spill
	mul	s5, a3, s8
	mv	a0, s5
	mv	a1, s3
	mv	a2, s8
	mv	a3, s4
	call	__moddi3
	mv	a2, a0
	mul	a3, s2, s8
	sw	s2, -260(s0)                    # 4-byte Folded Spill
	mulh	a0, s2, s8
	sw	a0, -240(s0)                    # 4-byte Folded Spill
	sw	a1, -132(s0)                    # 4-byte Folded Spill
	add	a0, a0, a1
	sw	a2, -128(s0)                    # 4-byte Folded Spill
	add	a2, a3, a2
	sw	a3, -236(s0)                    # 4-byte Folded Spill
	sltu	a1, a2, a3
	sw	s3, -76(s0)                     # 4-byte Folded Spill
	sub	a0, a0, s3
	add	a0, a0, a1
	sltu	a1, a2, s5
	sub	a1, a0, a1
	sub	a0, a2, s5
	mv	a2, s8
	sw	s4, -124(s0)                    # 4-byte Folded Spill
	mv	a3, s4
	call	__divdi3
	sw	a0, -152(s0)                    # 4-byte Folded Spill
	mv	s3, a1
	lw	a0, -220(s0)                    # 4-byte Folded Reload
	lw	a1, 0(a0)
	sw	a1, -140(s0)                    # 4-byte Folded Spill
	lw	a0, 4(a0)
	sw	a0, -144(s0)                    # 4-byte Folded Spill
	lw	s4, -72(s0)                     # 4-byte Folded Reload
	srai	a0, s4, 31
	sw	a0, -112(s0)                    # 4-byte Folded Spill
	srai	s2, s1, 31
	srai	s11, s6, 31
	mv	a0, s6
	mv	a1, s11
	mv	a2, s1
	mv	a3, s2
	call	__moddi3
	sltu	a2, s6, a0
	sub	a3, s11, a1
	sub	a3, a3, a2
	sw	a3, -116(s0)                    # 4-byte Folded Spill
	sub	a2, s6, a0
	sw	a2, -120(s0)                    # 4-byte Folded Spill
	addi	a2, a0, 64
	sltu	a3, a2, a0
	add	a3, a1, a3
	xor	a4, a3, s2
	slt	a5, a3, s2
	czero.eqz	a5, a5, a4
	sltu	a6, a2, s1
	czero.nez	a4, a6, a4
	or	a4, a4, a5
	sw	s2, -208(s0)                    # 4-byte Folded Spill
	czero.nez	a5, s2, a4
	czero.eqz	a3, a3, a4
	or	a3, a3, a5
	czero.nez	a5, s1, a4
	czero.eqz	a2, a2, a4
	or	a2, a2, a5
	sltu	a4, a2, a0
	sub	a3, a3, a1
	sub	s10, a3, a4
	sub	a2, a2, a0
	sw	a2, -148(s0)                    # 4-byte Folded Spill
	lw	a0, -216(s0)                    # 4-byte Folded Reload
	lw	s2, 0(a0)
	lw	a0, 4(a0)
	sw	a0, -84(s0)                     # 4-byte Folded Spill
	lw	a0, -212(s0)                    # 4-byte Folded Reload
	addi	a0, a0, 15
	srai	a1, a0, 31
	srli	a1, a1, 28
	add	a0, a0, a1
	srai	a0, a0, 4
	sw	a0, -224(s0)                    # 4-byte Folded Spill
	slli	s4, s4, 4
	sw	s4, -244(s0)                    # 4-byte Folded Spill
	lui	a0, %hi(.Lshared_mem_1152920405095234560)
	addi	s9, a0, %lo(.Lshared_mem_1152920405095234560)
	lui	a0, %hi(.Lshared_mem_1152920405095242752)
	addi	a1, a0, %lo(.Lshared_mem_1152920405095242752)
	lui	a2, 2
	mv	a0, s9
	sw	a1, -248(s0)                    # 4-byte Folded Spill
	call	memcpy
	mv	t0, s5
	li	a1, 0
	li	a7, 0
	li	s1, 0
	sw	zero, -104(s0)                  # 4-byte Folded Spill
	csrr	a0, tmask
	sw	a0, -228(s0)                    # 4-byte Folded Spill
	lui	a0, %hi(.Lshared_mem_1152920405095233536)
	addi	s4, a0, %lo(.Lshared_mem_1152920405095233536)
	lui	a0, 912092
	addi	a0, a0, -273
	sw	a0, -80(s0)                     # 4-byte Folded Spill
	lui	a0, %hi(.Lshared_mem_1152920405095231488)
	addi	s7, a0, %lo(.Lshared_mem_1152920405095231488)
	lui	s5, %hi(.Lshared_mem_1152920405095223296)
	addi	a0, s5, %lo(.Lshared_mem_1152920405095223296)
	sw	a0, -108(s0)                    # 4-byte Folded Spill
	li	a0, 16
	sw	a0, -88(s0)                     # 4-byte Folded Spill
	li	a0, 1
	sw	a0, -68(s0)                     # 4-byte Folded Spill
	sw	s6, -204(s0)                    # 4-byte Folded Spill
	sw	s6, -136(s0)                    # 4-byte Folded Spill
	mv	a3, t0
	sw	s8, -232(s0)                    # 4-byte Folded Spill
	j	.LBB0_8
.LBB0_7:                                #   in Loop: Header=BB0_8 Depth=1
	lw	s6, -204(s0)                    # 4-byte Folded Reload
	srai	s2, s6, 31
	lw	a0, -72(s0)                     # 4-byte Folded Reload
	srai	a0, a0, 31
	sw	a0, -112(s0)                    # 4-byte Folded Spill
	srai	s3, s8, 31
	lw	a0, -164(s0)                    # 4-byte Folded Reload
	addi	s10, a0, 16
	sltu	a0, s10, a0
	lw	s1, -76(s0)                     # 4-byte Folded Reload
	add	s1, s1, a0
	mv	a0, s10
	mv	a1, s1
	mv	a2, s8
	mv	a3, s3
	call	__moddi3
	mv	a2, a0
	lw	a0, -240(s0)                    # 4-byte Folded Reload
	sw	a1, -132(s0)                    # 4-byte Folded Spill
	add	a0, a0, a1
	lw	a1, -236(s0)                    # 4-byte Folded Reload
	sw	a2, -128(s0)                    # 4-byte Folded Spill
	add	a2, a1, a2
	sltu	a1, a2, a1
	sw	s1, -76(s0)                     # 4-byte Folded Spill
	sub	a0, a0, s1
	add	a0, a0, a1
	sltu	a1, a2, s10
	sub	a1, a0, a1
	sub	a0, a2, s10
	mv	a2, s8
	sw	s3, -124(s0)                    # 4-byte Folded Spill
	mv	a3, s3
	call	__divdi3
	sw	a0, -152(s0)                    # 4-byte Folded Spill
	mv	s3, a1
	lw	a0, -220(s0)                    # 4-byte Folded Reload
	lw	a1, 0(a0)
	sw	a1, -140(s0)                    # 4-byte Folded Spill
	lw	a0, 4(a0)
	sw	a0, -144(s0)                    # 4-byte Folded Spill
	li	a0, 1
	sw	a0, -68(s0)                     # 4-byte Folded Spill
	li	a0, 16
	sw	a0, -88(s0)                     # 4-byte Folded Spill
	lw	s1, -244(s0)                    # 4-byte Folded Reload
	srai	a0, s1, 31
	lw	a1, -160(s0)                    # 4-byte Folded Reload
	add	s1, a1, s1
	sltu	a1, s1, a1
	lw	a2, -104(s0)                    # 4-byte Folded Reload
	add	a0, a2, a0
	add	a1, a0, a1
	add	s9, s1, s6
	sltu	a0, s9, s1
	sw	a1, -104(s0)                    # 4-byte Folded Spill
	add	s2, a1, s2
	add	s11, s2, a0
	mv	a0, s9
	mv	a1, s11
	lw	s2, -200(s0)                    # 4-byte Folded Reload
	mv	a2, s2
	lw	s6, -208(s0)                    # 4-byte Folded Reload
	mv	a3, s6
	call	__moddi3
	mv	t0, s10
	li	a7, 0
	sub	a2, s11, a1
	sltu	a3, s9, a0
	sub	a2, a2, a3
	sw	a2, -116(s0)                    # 4-byte Folded Spill
	addi	a2, a0, 64
	sltu	a3, a2, a0
	add	a3, a1, a3
	xor	a4, a3, s6
	slt	a5, a3, s6
	czero.eqz	a5, a5, a4
	sltu	a6, a2, s2
	czero.nez	a4, a6, a4
	sw	s9, -136(s0)                    # 4-byte Folded Spill
	sub	a6, s9, a0
	sw	a6, -120(s0)                    # 4-byte Folded Spill
	or	a4, a4, a5
	czero.nez	a5, s6, a4
	czero.eqz	a3, a3, a4
	or	a3, a3, a5
	czero.nez	a5, s2, a4
	czero.eqz	a2, a2, a4
	or	a2, a2, a5
	sltu	a4, a2, a0
	sub	a3, a3, a1
	lw	a1, -216(s0)                    # 4-byte Folded Reload
	lw	s2, 0(a1)
	lw	a1, 4(a1)
	sw	a1, -84(s0)                     # 4-byte Folded Spill
	sub	s10, a3, a4
	sub	a2, a2, a0
	sw	a2, -148(s0)                    # 4-byte Folded Spill
	lw	a1, -156(s0)                    # 4-byte Folded Reload
	addi	a1, a1, 1
	lw	s9, -108(s0)                    # 4-byte Folded Reload
	mv	a3, t0
.LBB0_8:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_12 Depth 2
                                        #       Child Loop BB0_14 Depth 3
                                        #     Child Loop BB0_19 Depth 2
                                        #       Child Loop BB0_21 Depth 3
                                        #     Child Loop BB0_25 Depth 2
                                        #       Child Loop BB0_28 Depth 3
                                        #         Child Loop BB0_30 Depth 4
                                        #     Child Loop BB0_34 Depth 2
                                        #       Child Loop BB0_36 Depth 3
	lw	a0, -224(s0)                    # 4-byte Folded Reload
	slt	a0, a1, a0
	lw	a2, -228(s0)                    # 4-byte Folded Reload
	vx_pred	a0, a2
	beqz	a0, .LBB0_38
# %bb.9:                                #   in Loop: Header=BB0_8 Depth=1
	sw	a3, -164(s0)                    # 4-byte Folded Spill
	sw	s1, -160(s0)                    # 4-byte Folded Spill
	sw	a1, -156(s0)                    # 4-byte Folded Spill
	slli	a0, a1, 4
	lw	a1, -212(s0)                    # 4-byte Folded Reload
	sub	a0, a1, a0
	slti	a1, a0, 16
	czero.eqz	s1, a0, a1
	li	a0, 16
	czero.nez	a0, a0, a1
	or	a1, s1, a0
	srai	s1, s1, 31
	slti	a0, s1, 0
	czero.eqz	a0, a0, s1
	sw	a1, -96(s0)                     # 4-byte Folded Spill
	sltiu	a1, a1, 16
	sw	s1, -100(s0)                    # 4-byte Folded Spill
	czero.nez	a1, a1, s1
	or	a1, a1, a0
	vx_split_n	a0, a1
	sw	a1, -176(s0)                    # 4-byte Folded Spill
	beqz	a1, .LBB0_16
# %bb.10:                               # %.preheader10
                                        #   in Loop: Header=BB0_8 Depth=1
	li	a1, 0
	li	a2, 0
	j	.LBB0_12
.LBB0_11:                               #   in Loop: Header=BB0_12 Depth=2
	addi	a1, a1, 1
	seqz	a3, a1
	add	a2, a2, a3
.LBB0_12:                               #   Parent Loop BB0_8 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_14 Depth 3
	sgtz	a3, a2
	czero.eqz	a3, a3, a2
	sltiu	a4, a1, 32
	xori	a4, a4, 1
	czero.nez	a4, a4, a2
	or	a3, a4, a3
	bnez	a3, .LBB0_16
# %bb.13:                               # %.preheader7
                                        #   in Loop: Header=BB0_12 Depth=2
	li	a4, 0
.LBB0_14:                               #   Parent Loop BB0_8 Depth=1
                                        #     Parent Loop BB0_12 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	sgtz	a5, a4
	czero.eqz	a5, a5, a4
	sltiu	a6, a3, 16
	xori	a6, a6, 1
	czero.nez	a6, a6, a4
	or	a5, a6, a5
	bnez	a5, .LBB0_11
# %bb.15:                               #   in Loop: Header=BB0_14 Depth=3
	slli	a5, a1, 4
	add	a5, a5, a3
	slli	a5, a5, 1
	add	a5, s4, a5
	sh	zero, 0(a5)
	addi	a3, a3, 1
	seqz	a5, a3
	add	a4, a4, a5
	j	.LBB0_14
.LBB0_16:                               # %join_stub13
                                        #   in Loop: Header=BB0_8 Depth=1
	sw	s10, -172(s0)                   # 4-byte Folded Spill
	sw	s2, -92(s0)                     # 4-byte Folded Spill
	sw	s11, -168(s0)                   # 4-byte Folded Spill
	vx_join	a0
	mv	a0, sp
	addi	sp, a0, -16
	sw	sp, -188(s0)                    # 4-byte Folded Spill
	lw	a2, -152(s0)                    # 4-byte Folded Reload
	sw	a2, -16(a0)
	sw	s3, -12(a0)
	lw	a1, -88(s0)                     # 4-byte Folded Reload
	sw	a1, -8(a0)
	sw	a7, -4(a0)
	sltiu	a0, a2, 32
	czero.nez	a0, a0, s3
	slti	a1, s3, 0
	czero.eqz	a1, a1, s3
	or	a0, a0, a1
	li	a3, 32
	czero.nez	a1, a3, a0
	czero.eqz	a2, a2, a0
	or	a1, a2, a1
	czero.eqz	a0, s3, a0
	sub	a4, a3, a1
	sw	a4, -192(s0)                    # 4-byte Folded Spill
	sltu	a3, a3, a1
	neg	a4, a0
	sub	a4, a4, a3
	sw	a4, -196(s0)                    # 4-byte Folded Spill
	srli	a2, a2, 28
	slli	a3, a0, 4
	or	a2, a3, a2
	sw	a2, -184(s0)                    # 4-byte Folded Spill
	slli	a2, a1, 4
	sw	a2, -180(s0)                    # 4-byte Folded Spill
	mv	a2, sp
	addi	a3, a2, -48
	mv	sp, a3
	sw	a7, -4(a2)
	lw	a4, -68(s0)                     # 4-byte Folded Reload
	sw	a4, -8(a2)
	lw	s10, -124(s0)                   # 4-byte Folded Reload
	sw	s10, -12(a2)
	sw	s8, -16(a2)
	lw	s2, -100(s0)                    # 4-byte Folded Reload
	sw	s2, -20(a2)
	lw	s1, -96(s0)                     # 4-byte Folded Reload
	sw	s1, -24(a2)
	sw	a0, -28(a2)
	sw	a1, -32(a2)
	lw	a4, -76(s0)                     # 4-byte Folded Reload
	sw	a4, -36(a2)
	sw	t0, -40(a2)
	lw	s11, -144(s0)                   # 4-byte Folded Reload
	sw	s11, -44(a2)
	lw	s6, -140(s0)                    # 4-byte Folded Reload
	sw	s6, -48(a2)
	mv	a2, sp
	addi	a4, a2, -48
	mv	sp, a4
	sw	zero, -4(a2)
	li	a5, 1
	sw	a5, -8(a2)
	sw	zero, -12(a2)
	li	a5, 16
	sw	a5, -16(a2)
	sw	s2, -20(a2)
	sw	s1, -24(a2)
	sw	a0, -28(a2)
	sw	a1, -32(a2)
	sw	zero, -36(a2)
	sw	zero, -40(a2)
	sw	s4, -44(a2)
	lw	a0, -80(s0)                     # 4-byte Folded Reload
	sw	a0, -48(a2)
	mv	a0, sp
	addi	a2, a0, -16
	mv	sp, a2
	sw	zero, -12(a0)
	li	a1, 2
	sw	a1, -16(a0)
	sw	a3, -8(a0)
	mv	a0, sp
	addi	a3, a0, -16
	mv	sp, a3
	sw	zero, -12(a0)
	sw	a1, -16(a0)
	sw	a4, -8(a0)
	li	a0, 2
	li	a1, 0
	mv	s3, a7
	call	memrefCopy
	lw	sp, -188(s0)                    # 4-byte Folded Reload
	mv	a0, sp
	addi	a1, a0, -48
	mv	sp, a1
	sw	s3, -152(s0)                    # 4-byte Folded Spill
	sw	s3, -4(a0)
	lw	a2, -68(s0)                     # 4-byte Folded Reload
	sw	a2, -8(a0)
	sw	s10, -12(a0)
	sw	s8, -16(a0)
	sw	s2, -20(a0)
	sw	s1, -24(a0)
	lw	a5, -196(s0)                    # 4-byte Folded Reload
	sw	a5, -28(a0)
	lw	a3, -192(s0)                    # 4-byte Folded Reload
	sw	a3, -32(a0)
	lw	a2, -132(s0)                    # 4-byte Folded Reload
	sw	a2, -36(a0)
	lw	a2, -128(s0)                    # 4-byte Folded Reload
	sw	a2, -40(a0)
	sw	s11, -44(a0)
	sw	s6, -48(a0)
	mv	a0, sp
	addi	a4, a0, -48
	mv	sp, a4
	sw	zero, -4(a0)
	li	a2, 1
	sw	a2, -8(a0)
	sw	zero, -12(a0)
	li	a2, 16
	sw	a2, -16(a0)
	sw	s2, -20(a0)
	sw	s1, -24(a0)
	sw	a5, -28(a0)
	sw	a3, -32(a0)
	lw	a2, -184(s0)                    # 4-byte Folded Reload
	sw	a2, -36(a0)
	lw	a2, -180(s0)                    # 4-byte Folded Reload
	sw	a2, -40(a0)
	sw	s4, -44(a0)
	lw	a2, -80(s0)                     # 4-byte Folded Reload
	sw	a2, -48(a0)
	mv	a0, sp
	addi	a2, a0, -16
	mv	sp, a2
	sw	zero, -12(a0)
	li	a5, 2
	sw	a5, -16(a0)
	sw	a1, -8(a0)
	mv	a0, sp
	addi	a3, a0, -16
	mv	sp, a3
	sw	zero, -12(a0)
	sw	a5, -16(a0)
	sw	a4, -8(a0)
	li	a0, 2
	li	a1, 0
	call	memrefCopy
	lw	sp, -188(s0)                    # 4-byte Folded Reload
	lw	a1, -176(s0)                    # 4-byte Folded Reload
	vx_split_n	a0, a1
	lw	a7, -168(s0)                    # 4-byte Folded Reload
	lw	t0, -172(s0)                    # 4-byte Folded Reload
	beqz	a1, .LBB0_23
# %bb.17:                               # %.preheader9
                                        #   in Loop: Header=BB0_8 Depth=1
	li	a1, 0
	li	a2, 0
	j	.LBB0_19
.LBB0_18:                               #   in Loop: Header=BB0_19 Depth=2
	addi	a1, a1, 1
	seqz	a3, a1
	add	a2, a2, a3
.LBB0_19:                               #   Parent Loop BB0_8 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_21 Depth 3
	sgtz	a3, a2
	czero.eqz	a3, a3, a2
	sltiu	a4, a1, 16
	xori	a4, a4, 1
	czero.nez	a4, a4, a2
	or	a3, a4, a3
	bnez	a3, .LBB0_23
# %bb.20:                               # %.preheader6
                                        #   in Loop: Header=BB0_19 Depth=2
	li	a4, 0
.LBB0_21:                               #   Parent Loop BB0_8 Depth=1
                                        #     Parent Loop BB0_19 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	sgtz	a5, a4
	czero.eqz	a5, a5, a4
	sltiu	a6, a3, 64
	xori	a6, a6, 1
	czero.nez	a6, a6, a4
	or	a5, a6, a5
	bnez	a5, .LBB0_18
# %bb.22:                               #   in Loop: Header=BB0_21 Depth=3
	slli	a5, a1, 6
	add	a5, a5, a3
	slli	a5, a5, 1
	add	a5, s7, a5
	sh	zero, 0(a5)
	addi	a3, a3, 1
	seqz	a5, a3
	add	a4, a4, a5
	j	.LBB0_21
.LBB0_23:                               # %join_stub
                                        #   in Loop: Header=BB0_8 Depth=1
	vx_join	a0
	mv	a0, sp
	addi	sp, a0, -16
	sw	sp, -124(s0)                    # 4-byte Folded Spill
	lw	a1, -88(s0)                     # 4-byte Folded Reload
	sw	a1, -16(a0)
	lw	s1, -152(s0)                    # 4-byte Folded Reload
	sw	s1, -12(a0)
	lw	a2, -148(s0)                    # 4-byte Folded Reload
	sw	a2, -8(a0)
	sw	t0, -4(a0)
	sltiu	a0, a2, 64
	czero.nez	a0, a0, t0
	slti	a1, t0, 0
	czero.eqz	a1, a1, t0
	or	a0, a0, a1
	li	a1, 64
	czero.nez	a1, a1, a0
	li	a3, 64
	czero.eqz	a2, a2, a0
	or	s2, a2, a1
	czero.eqz	s3, t0, a0
	li	a1, 32
	sub	a0, a1, s2
	addi	a2, a0, 32
	sw	a2, -88(s0)                     # 4-byte Folded Spill
	sltu	a0, a2, a0
	sltu	a1, a1, s2
	add	a1, s3, a1
	sub	a0, a0, a1
	sw	a0, -128(s0)                    # 4-byte Folded Spill
	mv	a0, sp
	addi	a1, a0, -48
	mv	sp, a1
	sw	s1, -4(a0)
	lw	a2, -68(s0)                     # 4-byte Folded Reload
	sw	a2, -8(a0)
	lw	s10, -112(s0)                   # 4-byte Folded Reload
	sw	s10, -12(a0)
	lw	a2, -72(s0)                     # 4-byte Folded Reload
	sw	a2, -16(a0)
	sw	s3, -20(a0)
	sw	s2, -24(a0)
	lw	s8, -100(s0)                    # 4-byte Folded Reload
	sw	s8, -28(a0)
	lw	s6, -96(s0)                     # 4-byte Folded Reload
	sw	s6, -32(a0)
	sw	a7, -36(a0)
	lw	a2, -136(s0)                    # 4-byte Folded Reload
	sw	a2, -40(a0)
	lw	a2, -84(s0)                     # 4-byte Folded Reload
	sw	a2, -44(a0)
	lw	a2, -92(s0)                     # 4-byte Folded Reload
	sw	a2, -48(a0)
	mv	a0, sp
	addi	a4, a0, -48
	mv	sp, a4
	sw	zero, -4(a0)
	li	a2, 1
	sw	a2, -8(a0)
	sw	zero, -12(a0)
	sw	a3, -16(a0)
	sw	s3, -20(a0)
	sw	s2, -24(a0)
	sw	s8, -28(a0)
	sw	s6, -32(a0)
	sw	zero, -36(a0)
	sw	zero, -40(a0)
	sw	s7, -44(a0)
	lw	s11, -80(s0)                    # 4-byte Folded Reload
	sw	s11, -48(a0)
	mv	a0, sp
	addi	a2, a0, -16
	mv	sp, a2
	sw	zero, -12(a0)
	li	a5, 2
	sw	a5, -16(a0)
	sw	a1, -8(a0)
	mv	a0, sp
	addi	a3, a0, -16
	mv	sp, a3
	sw	zero, -12(a0)
	sw	a5, -16(a0)
	sw	a4, -8(a0)
	li	a0, 2
	li	a1, 0
	call	memrefCopy
	lw	sp, -124(s0)                    # 4-byte Folded Reload
	mv	a0, sp
	addi	a1, a0, -48
	mv	sp, a1
	sw	s1, -4(a0)
	lw	a2, -68(s0)                     # 4-byte Folded Reload
	sw	a2, -8(a0)
	sw	s10, -12(a0)
	lw	a2, -72(s0)                     # 4-byte Folded Reload
	sw	a2, -16(a0)
	lw	a5, -128(s0)                    # 4-byte Folded Reload
	sw	a5, -20(a0)
	lw	a3, -88(s0)                     # 4-byte Folded Reload
	sw	a3, -24(a0)
	sw	s8, -28(a0)
	sw	s6, -32(a0)
	lw	a2, -116(s0)                    # 4-byte Folded Reload
	sw	a2, -36(a0)
	lw	a2, -120(s0)                    # 4-byte Folded Reload
	sw	a2, -40(a0)
	lw	a2, -84(s0)                     # 4-byte Folded Reload
	sw	a2, -44(a0)
	lw	a2, -92(s0)                     # 4-byte Folded Reload
	sw	a2, -48(a0)
	mv	a0, sp
	addi	a4, a0, -48
	mv	sp, a4
	sw	zero, -4(a0)
	li	a2, 1
	sw	a2, -8(a0)
	sw	zero, -12(a0)
	li	a2, 64
	sw	a2, -16(a0)
	sw	a5, -20(a0)
	sw	a3, -24(a0)
	sw	s8, -28(a0)
	sw	s6, -32(a0)
	sw	s3, -36(a0)
	sw	s2, -40(a0)
	sw	s7, -44(a0)
	sw	s11, -48(a0)
	mv	a0, sp
	addi	a2, a0, -16
	mv	sp, a2
	sw	zero, -12(a0)
	li	a5, 2
	sw	a5, -16(a0)
	sw	a1, -8(a0)
	mv	a0, sp
	addi	a3, a0, -16
	mv	sp, a3
	sw	zero, -12(a0)
	sw	a5, -16(a0)
	sw	a4, -8(a0)
	li	a0, 2
	li	a1, 0
	call	memrefCopy
	lw	sp, -124(s0)                    # 4-byte Folded Reload
	lui	a2, 2
	lw	a0, -108(s0)                    # 4-byte Folded Reload
	lw	a1, -248(s0)                    # 4-byte Folded Reload
	call	memcpy
	li	s1, 0
	li	s2, 0
	j	.LBB0_25
.LBB0_24:                               #   in Loop: Header=BB0_25 Depth=2
	addi	s1, s1, 1
	seqz	a0, s1
	add	s2, s2, a0
.LBB0_25:                               #   Parent Loop BB0_8 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_28 Depth 3
                                        #         Child Loop BB0_30 Depth 4
	sltiu	a0, s1, 32
	czero.nez	a0, a0, s2
	slti	a1, s2, 0
	czero.eqz	a1, a1, s2
	or	a0, a0, a1
	beqz	a0, .LBB0_32
# %bb.26:                               # %.preheader5
                                        #   in Loop: Header=BB0_25 Depth=2
	li	s3, 0
	li	s6, 0
	j	.LBB0_28
.LBB0_27:                               #   in Loop: Header=BB0_28 Depth=3
	addi	s3, s3, 1
	seqz	a0, s3
	add	s6, s6, a0
.LBB0_28:                               #   Parent Loop BB0_8 Depth=1
                                        #     Parent Loop BB0_25 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB0_30 Depth 4
	sgtz	a0, s6
	czero.eqz	a0, a0, s6
	sltiu	a1, s3, 64
	xori	a1, a1, 1
	czero.nez	a1, a1, s6
	or	a0, a1, a0
	bnez	a0, .LBB0_24
# %bb.29:                               # %.preheader3
                                        #   in Loop: Header=BB0_28 Depth=3
	li	s8, 0
	li	s10, 0
.LBB0_30:                               #   Parent Loop BB0_8 Depth=1
                                        #     Parent Loop BB0_25 Depth=2
                                        #       Parent Loop BB0_28 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	sgtz	a0, s10
	czero.eqz	a0, a0, s10
	sltiu	a1, s8, 16
	xori	a1, a1, 1
	czero.nez	a1, a1, s10
	or	a0, a1, a0
	bnez	a0, .LBB0_27
# %bb.31:                               #   in Loop: Header=BB0_30 Depth=4
	slli	a0, s1, 4
	add	a0, a0, s8
	slli	a0, a0, 1
	add	a0, s4, a0
	lhu	a0, 0(a0)
	slli	a1, s1, 6
	add	a1, a1, s3
	slli	a1, a1, 2
	addi	a2, s5, %lo(.Lshared_mem_1152920405095223296)
	add	s11, a2, a1
	slli	a1, s8, 6
	add	a1, a1, s3
	slli	a1, a1, 1
	add	a1, s7, a1
	lhu	a1, 0(a1)
	flw	fs2, 0(s11)
	fmv.w.x	fa0, a0
	fmv.w.x	fs0, a1
	call	__extendhfsf2
	fmv.s	fs1, fa0
	fmv.s	fa0, fs0
	call	__extendhfsf2
	fmul.s	fa5, fs1, fa0
	fadd.s	fa5, fs2, fa5
	fsw	fa5, 0(s11)
	addi	s8, s8, 1
	seqz	a0, s8
	add	s10, s10, a0
	j	.LBB0_30
.LBB0_32:                               # %.preheader8
                                        #   in Loop: Header=BB0_8 Depth=1
	li	a1, 0
	lw	s8, -232(s0)                    # 4-byte Folded Reload
	j	.LBB0_34
.LBB0_33:                               #   in Loop: Header=BB0_34 Depth=2
	addi	a0, a0, 1
	seqz	a2, a0
	add	a1, a1, a2
.LBB0_34:                               #   Parent Loop BB0_8 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_36 Depth 3
	sgtz	a2, a1
	czero.eqz	a2, a2, a1
	sltiu	a3, a0, 32
	xori	a3, a3, 1
	czero.nez	a3, a3, a1
	or	a2, a3, a2
	bnez	a2, .LBB0_7
# %bb.35:                               # %.preheader4
                                        #   in Loop: Header=BB0_34 Depth=2
	li	a3, 0
.LBB0_36:                               #   Parent Loop BB0_8 Depth=1
                                        #     Parent Loop BB0_34 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	sgtz	a4, a3
	czero.eqz	a4, a4, a3
	sltiu	a5, a2, 64
	xori	a5, a5, 1
	czero.nez	a5, a5, a3
	or	a4, a5, a4
	bnez	a4, .LBB0_33
# %bb.37:                               #   in Loop: Header=BB0_36 Depth=3
	slli	a4, a0, 6
	add	a4, a4, a2
	slli	a4, a4, 2
	addi	a5, s5, %lo(.Lshared_mem_1152920405095223296)
	add	a5, a5, a4
	flw	fa5, 0(a5)
	add	a4, s9, a4
	flw	fa4, 0(a4)
	fadd.s	fa5, fa5, fa4
	fsw	fa5, 0(a5)
	addi	a2, a2, 1
	seqz	a4, a2
	add	a3, a3, a4
	j	.LBB0_36
.LBB0_38:
	li	s6, 0
	li	s7, 0
	lw	s1, -204(s0)                    # 4-byte Folded Reload
	srai	s5, s1, 31
	lw	a1, -252(s0)                    # 4-byte Folded Reload
	lw	a2, -256(s0)                    # 4-byte Folded Reload
	mulh	a0, a2, a1
	mul	a1, a2, a1
	add	s1, a1, s1
	sltu	s4, s1, a1
	add	a0, a0, s5
	lw	a1, -264(s0)                    # 4-byte Folded Reload
	lw	a2, 0(a1)
	sw	a2, -68(s0)                     # 4-byte Folded Spill
	lw	s3, 4(a1)
	add	s4, a0, s4
	lui	a0, %hi(.Lshared_mem_1152920405095219200)
	addi	s8, a0, %lo(.Lshared_mem_1152920405095219200)
	j	.LBB0_40
.LBB0_39:                               #   in Loop: Header=BB0_40 Depth=1
	addi	s6, s6, 1
	seqz	a0, s6
	add	s7, s7, a0
.LBB0_40:                               # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_42 Depth 2
	sgtz	a0, s7
	czero.eqz	a0, a0, s7
	sltiu	a1, s6, 32
	xori	a1, a1, 1
	czero.nez	a1, a1, s7
	or	a0, a1, a0
	bnez	a0, .LBB0_44
# %bb.41:                               # %.preheader
                                        #   in Loop: Header=BB0_40 Depth=1
	li	s2, 0
	li	s11, 0
.LBB0_42:                               #   Parent Loop BB0_40 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	sgtz	a0, s11
	czero.eqz	a0, a0, s11
	sltiu	a1, s2, 64
	xori	a1, a1, 1
	czero.nez	a1, a1, s11
	or	a0, a1, a0
	bnez	a0, .LBB0_39
# %bb.43:                               #   in Loop: Header=BB0_42 Depth=2
	slli	a0, s6, 6
	add	s10, a0, s2
	slli	a0, s10, 2
	add	a0, s9, a0
	flw	fa0, 0(a0)
	call	__truncsfhf2
	fmv.x.w	a0, fa0
	slli	s10, s10, 1
	add	s10, s8, s10
	sh	a0, 0(s10)
	addi	s2, s2, 1
	seqz	a0, s2
	add	s11, s11, a0
	j	.LBB0_42
.LBB0_44:
	mv	s6, sp
	lw	t0, -256(s0)                    # 4-byte Folded Reload
	srai	a1, t0, 31
	lw	a7, -260(s0)                    # 4-byte Folded Reload
	srai	a2, a7, 31
	addi	a3, t0, 32
	sltu	a0, a3, t0
	add	a4, a1, a0
	xor	a0, a4, a2
	slt	a5, a4, a2
	czero.eqz	a5, a5, a0
	sltu	a6, a3, a7
	czero.nez	a6, a6, a0
	lw	t2, -252(s0)                    # 4-byte Folded Reload
	srai	a0, t2, 31
	or	a5, a6, a5
	czero.nez	a2, a2, a5
	czero.eqz	a4, a4, a5
	or	a2, a4, a2
	czero.nez	a4, a7, a5
	czero.eqz	a3, a3, a5
	or	a3, a3, a4
	sltu	a4, a3, t0
	sub	a2, a2, a1
	sub	a2, a2, a4
	sub	a1, a3, t0
	lw	t1, -204(s0)                    # 4-byte Folded Reload
	addi	a3, t1, 64
	sltu	a4, a3, t1
	add	a4, s5, a4
	lw	t3, -208(s0)                    # 4-byte Folded Reload
	xor	a5, a4, t3
	slt	a6, a4, t3
	czero.eqz	a6, a6, a5
	lw	t0, -200(s0)                    # 4-byte Folded Reload
	sltu	a7, a3, t0
	czero.nez	a5, a7, a5
	or	a5, a5, a6
	czero.nez	a6, t3, a5
	czero.eqz	a4, a4, a5
	or	a4, a4, a6
	czero.nez	a6, t0, a5
	czero.eqz	a3, a3, a5
	or	a3, a3, a6
	sltu	a5, a3, t1
	sub	a4, a4, s5
	sub	a4, a4, a5
	sub	a3, a3, t1
	slti	a5, a2, 0
	czero.eqz	a5, a5, a2
	sltiu	a6, a1, 32
	czero.nez	a6, a6, a2
	or	a5, a6, a5
	li	a6, 32
	czero.nez	a6, a6, a5
	czero.eqz	a1, a1, a5
	or	a1, a1, a6
	czero.eqz	a2, a2, a5
	slti	a5, a4, 0
	czero.eqz	a5, a5, a4
	sltiu	a6, a3, 64
	czero.nez	a6, a6, a4
	or	a5, a6, a5
	li	a6, 64
	czero.nez	a7, a6, a5
	czero.eqz	a3, a3, a5
	or	a3, a3, a7
	czero.eqz	a4, a4, a5
	lui	a5, %hi(.Lshared_mem_1152920405095219200)
	addi	a5, a5, %lo(.Lshared_mem_1152920405095219200)
	mv	a7, sp
	addi	t0, a7, -48
	mv	sp, t0
	sw	zero, -4(a7)
	li	t1, 1
	sw	t1, -8(a7)
	sw	zero, -12(a7)
	sw	a6, -16(a7)
	sw	zero, -36(a7)
	sw	zero, -40(a7)
	sw	a5, -44(a7)
	lui	a5, 912092
	addi	a5, a5, -273
	sw	a5, -48(a7)
	sw	a4, -20(a7)
	sw	a2, -28(a7)
	sw	a3, -24(a7)
	sw	a1, -32(a7)
	mv	a5, sp
	addi	a6, a5, -48
	mv	sp, a6
	sw	zero, -4(a5)
	sw	t1, -8(a5)
	sw	a0, -12(a5)
	sw	t2, -16(a5)
	sw	a4, -20(a5)
	sw	a3, -24(a5)
	sw	a2, -28(a5)
	sw	a1, -32(a5)
	sw	s4, -36(a5)
	sw	s1, -40(a5)
	sw	s3, -44(a5)
	lw	a0, -68(s0)                     # 4-byte Folded Reload
	sw	a0, -48(a5)
	mv	a0, sp
	addi	a2, a0, -16
	mv	sp, a2
	sw	zero, -12(a0)
	li	a1, 2
	sw	a1, -16(a0)
	sw	t0, -8(a0)
	mv	a0, sp
	addi	a3, a0, -16
	mv	sp, a3
	sw	zero, -12(a0)
	sw	a1, -16(a0)
	sw	a6, -8(a0)
	li	a0, 2
	li	a1, 0
	call	memrefCopy
	mv	sp, s6
	addi	sp, s0, -272
	lw	ra, 268(sp)                     # 4-byte Folded Reload
	lw	s0, 264(sp)                     # 4-byte Folded Reload
	lw	s1, 260(sp)                     # 4-byte Folded Reload
	lw	s2, 256(sp)                     # 4-byte Folded Reload
	lw	s3, 252(sp)                     # 4-byte Folded Reload
	lw	s4, 248(sp)                     # 4-byte Folded Reload
	lw	s5, 244(sp)                     # 4-byte Folded Reload
	lw	s6, 240(sp)                     # 4-byte Folded Reload
	lw	s7, 236(sp)                     # 4-byte Folded Reload
	lw	s8, 232(sp)                     # 4-byte Folded Reload
	lw	s9, 228(sp)                     # 4-byte Folded Reload
	lw	s10, 224(sp)                    # 4-byte Folded Reload
	lw	s11, 220(sp)                    # 4-byte Folded Reload
	flw	fs0, 216(sp)                    # 4-byte Folded Reload
	flw	fs1, 212(sp)                    # 4-byte Folded Reload
	flw	fs2, 208(sp)                    # 4-byte Folded Reload
	addi	sp, sp, 272
	ret
.Lfunc_end0:
	.size	matmul_kernel_0d1d2d34567c89c1011c, .Lfunc_end0-matmul_kernel_0d1d2d34567c89c1011c
	.cfi_endproc
                                        # -- End function
	.type	.Lshared_mem_1152920405095242752,@object # @shared_mem_1152920405095242752
	.section	.rodata,"a",@progbits
	.p2align	4, 0x0
.Lshared_mem_1152920405095242752:
	.zero	8192
	.size	.Lshared_mem_1152920405095242752, 8192

	.type	.Lshared_mem_1152920405095234560,@object # @shared_mem_1152920405095234560
	.p2align	4, 0x0
.Lshared_mem_1152920405095234560:
	.zero	8192
	.size	.Lshared_mem_1152920405095234560, 8192

	.type	.Lshared_mem_1152920405095233536,@object # @shared_mem_1152920405095233536
	.p2align	4, 0x0
.Lshared_mem_1152920405095233536:
	.zero	1024
	.size	.Lshared_mem_1152920405095233536, 1024

	.type	.Lshared_mem_1152920405095231488,@object # @shared_mem_1152920405095231488
	.p2align	4, 0x0
.Lshared_mem_1152920405095231488:
	.zero	2048
	.size	.Lshared_mem_1152920405095231488, 2048

	.type	.Lshared_mem_1152920405095223296,@object # @shared_mem_1152920405095223296
	.p2align	4, 0x0
.Lshared_mem_1152920405095223296:
	.zero	8192
	.size	.Lshared_mem_1152920405095223296, 8192

	.type	.Lshared_mem_1152920405095219200,@object # @shared_mem_1152920405095219200
	.p2align	4, 0x0
.Lshared_mem_1152920405095219200:
	.zero	4096
	.size	.Lshared_mem_1152920405095219200, 4096

	.section	".note.GNU-stack","",@progbits
