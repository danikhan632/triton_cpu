struct EnableZAPattern extends OpRewritePattern of FuncOp:
    constructor(parameters):
        inherit constructor(parameters)

    method matchAndRewrite(op, rewriter):
        guard = OpBuilder.InsertionGuard(rewriter)
        rewriter.setInsertionPointToStart(op.front())
        rewriter.create(arm_sme.aarch64_sme_za_enable, op.getLoc())
        rewriter.updateRootInPlace(op, lambda {})
        return success()

struct DisableZAPattern extends OpRewritePattern of ReturnOp:
    constructor(parameters):
        inherit constructor(parameters)

    method matchAndRewrite(op, rewriter):
        guard = OpBuilder.InsertionGuard(rewriter)
        rewriter.setInsertionPoint(op)
        rewriter.create(arm_sme.aarch64_sme_za_disable, op.getLoc())
        rewriter.updateRootInPlace(op, lambda {})
        return success()

struct ZeroOpConversion extends ConvertOpToLLVMPattern of ZeroOp:
    constructor(parameters):
        inherit constructor(parameters)

    method matchAndRewrite(zero, adaptor, rewriter):
        loc = zero.getLoc()
        tileElementWidth = zero.getVectorType().getElementType().getIntOrFloatBitWidth()

        tileId = rewriter.create(arm_sme.GetTileID, loc, rewriter.getIntegerType(tileElementWidth))

        baseMaskForSize = calculateBaseMaskForSize(tileElementWidth)

        maskType = rewriter.getI32Type()
        baseMask = rewriter.create(arith.ConstantOp, loc, maskType, baseMaskForSize)

        tileMask = rewriter.create(arith.ShLIOp, loc, baseMask, castTileIDToI32(tileId, loc, rewriter))
        rewriter.create(arm_sme.aarch64_sme_zero, loc, tileMask)

        rewriter.replaceOpWithNewOp(arm_sme.CastTileToVector, zero, zero.getType(), tileId)

        return success()

function calculateBaseMaskForSize(tileElementWidth):
    switch tileElementWidth:
        case 8:
            return 0b1111'1111
        case 16:
            return 0b0101'0101
        case 32:
            return 0b0001'0001
        case 64:
            return 0b0000'0001
        default:
            raise "bad element size"

function castTileIDToI32(tileId, loc, rewriter):
    # Perform the necessary conversion here and return the result.
    # You may use rewriter to create operations.
struct LoadTileSliceToArmSMELowering extends ConvertOpToLLVMPattern of LoadTileSliceOp:
    constructor(parameters):
        inherit constructor(parameters)

    method matchAndRewrite(loadTileSliceOp, adaptor, rewriter):
        loc = loadTileSliceOp.getLoc()
        tileType = loadTileSliceOp.getVectorType()
        tileElementType = tileType.getElementType()
        tileElementWidth = tileElementType.getIntOrFloatBitWidth()

        tile = rewriter.create(arm_sme.CastVectorToTile, loc, rewriter.getIntegerType(tileElementWidth), loadTileSliceOp.getTile())

        ptr = getStridedElementPtr(loc, loadTileSliceOp.getMemRefType(), adaptor.getBase(), adaptor.getIndices(), rewriter)
        tileSlice = loadTileSliceOp.getTileSliceIndex()
        tileSliceI32 = rewriter.create(arith.IndexCastUIOp, loc, rewriter.getI32Type(), tileSlice)

        one = rewriter.create(arith.ConstantOp, loc, rewriter.getI1Type(), rewriter.getIntegerAttr(rewriter.getI1Type(), 1))
        predTy = VectorType.get(tileType.getShape()[0], rewriter.getI1Type(), true)
        allActiveMask = rewriter.create(vector.SplatOp, loc, predTy, one)

        tileI32 = castTileIDToI32(tile, loc, rewriter)
        layout = loadTileSliceOp.getLayout()

        if layout == arm_sme.TileSliceLayout.Horizontal:
            switch tileElementWidth:
                default:
                    raise "unexpected element type!"
                case 8:
                    rewriter.create(arm_sme.aarch64_sme_ld1b_horiz, loc, allActiveMask, ptr, tileI32, tileSliceI32)
                case 16:
                    rewriter.create(arm_sme.aarch64_sme_ld1h_horiz, loc, allActiveMask, ptr, tileI32, tileSliceI32)
                case 32:
                    rewriter.create(arm_sme.aarch64_sme_ld1w_horiz, loc, allActiveMask, ptr, tileI32, tileSliceI32)
                case 64:
                    rewriter.create(arm_sme.aarch64_sme_ld1d_horiz, loc, allActiveMask, ptr, tileI32, tileSliceI32)
                case 128:
                    rewriter.create(arm_sme.aarch64_sme_ld1q_horiz, loc, allActiveMask, ptr, tileI32, tileSliceI32)
        else:
            switch tileElementWidth:
                default:
                    raise "unexpected element type!"
                case 8:
                    rewriter.create(arm_sme.aarch64_sme_ld1b_vert, loc, allActiveMask, ptr, tileI32, tileSliceI32)
                case 16:
                    rewriter.create(arm_sme.aarch64_sme_ld1h_vert, loc, allActiveMask, ptr, tileI32, tileSliceI32)
                case 32:
                    rewriter.create(arm_sme.aarch64_sme_ld1w_vert, loc, allActiveMask, ptr, tileI32, tileSliceI32)
                case 64:
                    rewriter.create(arm_sme.aarch64_sme_ld1d_vert, loc, allActiveMask, ptr, tileI32, tileSliceI32)
                case 128:
                    rewriter.create(arm_sme.aarch64_sme_ld1q_vert, loc, allActiveMask, ptr, tileI32, tileSliceI32)

        rewriter.replaceOpWithNewOp(arm_sme.CastTileToVector, loadTileSliceOp, tileType, tile)
        return success()

struct StoreTileSliceToArmSMELowering extends ConvertOpToLLVMPattern of StoreTileSliceOp:
    constructor(parameters):
        inherit constructor(parameters)

    method matchAndRewrite(storeTileSliceOp, adaptor, rewriter):
        loc = storeTileSliceOp.getLoc()
        tileType = storeTileSliceOp.getVectorType()
        tileElementType = tileType.getElementType()
        tileElementWidth = tileElementType.getIntOrFloatBitWidth()

        tile = rewriter.create(arm_sme.CastVectorToTile, loc, rewriter.getIntegerType(tileElementWidth), storeTileSliceOp.getTile())
        ptr = getStridedElementPtr(loc, storeTileSliceOp.getMemRefType(), adaptor.getBase(), adaptor.getIndices(), rewriter)
        tileSlice = storeTileSliceOp.getTileSliceIndex()
        tileSliceI32 = rewriter.create(arith.IndexCastUIOp, loc, rewriter.getI32Type(), tileSlice)

        one = rewriter.create(arith.ConstantOp, loc, rewriter.getI1Type(), rewriter.getIntegerAttr(rewriter.getI1Type(), 1))
        predTy = VectorType.get(tileType.getShape()[0], rewriter.getI1Type(), true)
        allActiveMask = rewriter.create(vector.SplatOp, loc, predTy, one)

        tileI32 = castTileIDToI32(tile, loc, rewriter)
        layout = storeTileSliceOp.getLayout()

        if layout == arm_sme.TileSliceLayout.Horizontal:
            switch tileElementWidth:
                default:
                    raise "unexpected element type!"
                case 8:
                    rewriter.replaceOpWithNewOp(arm_sme.aarch64_sme_st1b_horiz, storeTileSliceOp, allActiveMask, ptr, tileI32, tileSliceI32)
                case 16:
                    rewriter.replaceOpWithNewOp(arm_sme.aarch64_sme_st1h_horiz, storeTileSliceOp, allActiveMask, ptr, tileI32, tileSliceI32)
                case 32:
                    rewriter.replaceOpWithNewOp(arm_sme.aarch64_sme_st1w_horiz, storeTileSliceOp, allActiveMask, ptr, tileI32, tileSliceI32)
                case 64:
                    rewriter.replaceOpWithNewOp(arm_sme.aarch64_sme_st1d_horiz, storeTileSliceOp, allActiveMask, ptr, tileI32, tileSliceI32)
                case 128:
                    rewriter.replaceOpWithNewOp(arm_sme.aarch64_sme_st1q_horiz, storeTileSliceOp, allActiveMask, ptr, tileI32, tileSliceI32)
        else:
            switch tileElementWidth:
                default:
                    raise "unexpected element type!"
                case 8:
                    rewriter.replaceOpWithNewOp(arm_sme.aarch64_sme_st1b_vert, storeTileSliceOp, allActiveMask, ptr, tileI32, tileSliceI32)
                case 16:
                    rewriter.replaceOpWithNewOp(arm_sme.aarch64_sme_st1h_vert, storeTileSliceOp, allActiveMask, ptr, tileI32, tileSliceI32)
                case 32:
                    rewriter.replaceOpWithNewOp(arm_sme.aarch64_sme_st1w_vert, storeTileSliceOp, allActiveMask, ptr, tileI32, tileSliceI32)
                case 64:
                    rewriter.replaceOpWithNewOp(arm_sme.aarch64_sme_st1d_vert, storeTileSliceOp, allActiveMask, ptr, tileI32, tileSliceI32)
                case 128:
                    rewriter.replaceOpWithNewOp(arm_sme.aarch64_sme_st1q_vert, storeTileSliceOp, allActiveMask, ptr, tileI32, tileSliceI32)
        
        return success()
struct MoveVectorToTileSliceToArmSMELowering extends ConvertOpToLLVMPattern of MoveVectorToTileSliceOp:
    constructor(parameters):
        inherit constructor(parameters)

    method matchAndRewrite(moveVectorToTileSliceOp, adaptor, rewriter):
        loc = moveVectorToTileSliceOp.getLoc()
        tileType = moveVectorToTileSliceOp.getTileType()
        tileElementType = tileType.getElementType()
        tileElementWidth = tileElementType.getIntOrFloatBitWidth()

        tile = rewriter.create(arm_sme.CastVectorToTile, loc, rewriter.getIntegerType(tileElementWidth), moveVectorToTileSliceOp.getTile())
        tileSlice = moveVectorToTileSliceOp.getTileSliceIndex()
        tileSliceI32 = rewriter.create(arith.IndexCastUIOp, loc, rewriter.getI32Type(), tileSlice)

        one = rewriter.create(arith.ConstantOp, loc, rewriter.getI1Type(), rewriter.getIntegerAttr(rewriter.getI1Type(), 1))
        predTy = VectorType.get(tileType.getShape()[0], rewriter.getI1Type(), true)
        allActiveMask = rewriter.create(vector.SplatOp, loc, predTy, one)

        tileI32 = castTileIDToI32(tile, loc, rewriter)
        
        rewriter.create(arm_sme.aarch64_sme_write_horiz, loc, tileI32, tileSliceI32, allActiveMask, moveVectorToTileSliceOp.getVector())
        rewriter.replaceOpWithNewOp(arm_sme.CastTileToVector, moveVectorToTileSliceOp, tileType, tile)
        
        return success()

struct MoveTileSliceToVectorArmSMELowering extends ConvertOpToLLVMPattern of MoveTileSliceToVectorOp:
    constructor(parameters):
        inherit constructor(parameters)

    method matchAndRewrite(moveTileSliceToVector, _, rewriter):
        loc = moveTileSliceToVector.getLoc()
        sliceType = moveTileSliceToVector.getSliceType()
        tile = moveTileSliceToVector.getTile()
        sliceIndex = moveTileSliceToVector.getTileSliceIndex()

        tileId = rewriter.create(arm_sme.CastVectorToTile, loc, tile)
        tileIdI32 = castTileIDToI32(tileId, loc, rewriter)

        predicateType = sliceType.cloneWith({}, rewriter.getI1Type())
        allTruePredicate = rewriter.create(arith.ConstantOp, loc, DenseElementsAttr.get(predicateType, true))
        
        zeroVector = rewriter.create(arith.ConstantOp, loc, sliceType, rewriter.getZeroAttr(sliceType))
        sliceIndexI32 = rewriter.create(arith.IndexCastOp, loc, rewriter.getI32Type(), sliceIndex)

        rewriter.replaceOpWithNewOp(arm_sme.aarch64_sme_read_horiz, moveTileSliceToVector, sliceType, zeroVector, allTruePredicate, tileIdI32, sliceIndexI32)

        return success()



struct VectorOuterProductToArmSMELowering extends ConvertOpToLLVMPattern of OuterProductOp:
    constructor(parameters):
        inherit constructor(parameters)

    method matchAndRewrite(outerProductOp, adaptor, rewriter):
        isSupportedType = function(vectorType):
            // Check if the vector type is supported for lowering.
            // Implementation of the function is omitted for brevity.

        resultVectorType = outerProductOp.getResultVectorType()
        if !isSupportedType(resultVectorType):
            outerProductOp.emitError("unsupported type")
            return failure()

        kind = outerProductOp.getKind()
        if kind != CombiningKind.ADD:
            outerProductOp.emitError("unsupported kind")
            return failure()

        maskableOp = cast<MaskableOpInterface>(outerProductOp.getOperation())
        if maskableOp.isMasked():
            outerProductOp.emitError("masking is currently unsupported")
            return failure()

        if !isa<VectorType>(outerProductOp.getOperandTypeRHS()):
            // AXPY operation not suited for SME.
            return failure()

        loc = outerProductOp.getLoc()

        acc = outerProductOp.getAcc()
        if !acc:
            // Initialize accumulator with zero.
            acc = rewriter.create(arm_sme.ZeroOp, loc, resultVectorType)

        elementWidth = resultVectorType.getElementTypeBitWidth()
        tileId = rewriter.create(arm_sme.CastVectorToTile, loc, rewriter.getIntegerType(elementWidth), acc)

        one = rewriter.create(arith.ConstantOp, loc, rewriter.getI1Type(), rewriter.getIntegerAttr(rewriter.getI1Type(), 1))
        predTy = VectorType.get(resultVectorType.getShape()[0], rewriter.getI1Type(), true)
        allActiveMask = rewriter.create(vector.SplatOp, loc, predTy, one)

        tileI32 = castTileIDToI32(tileId, loc, rewriter)

        rewriter.create(arm_sme.aarch64_sme_mopa, loc, tileI32, allActiveMask, allActiveMask, outerProductOp.getLhs(), outerProductOp.getRhs())

        rewriter.replaceOpWithNewOp(arm_sme.CastTileToVector, outerProductOp, resultVectorType, tileId)

        return success()

struct VectorExtractToArmSMELowering extends ConvertOpToLLVMPattern of ExtractOp:
    constructor(parameters):
        inherit constructor(parameters)

    method matchAndRewrite(extractOp, adaptor, rewriter):
        sourceType = extractOp.getSourceVectorType()
        if !isValidSMETileVectorType(sourceType):
            return failure()

        loc = extractOp.getLoc()
        position = extractOp.getMixedPosition()

        sourceVector = extractOp.getVector()

        if position.empty():
            // Extract entire vector. Should be handled by folder, but just to be safe.
            rewriter.replaceOp(extractOp, sourceVector)
            return success()

        sliceIndex = vector.getAsValues(rewriter, loc, position[0]).front()
        moveTileSliceToVector = rewriter.create(arm_sme.MoveTileSliceToVectorOp, loc, sourceVector, sliceIndex)

        if position.size() == 1:
            // Single index case: Extracts a 1D slice.
            rewriter.replaceOp(extractOp, moveTileSliceToVector)
            return success()

        // Two indices case: Extracts a single element.
        assert(position.size() == 2)
        rewriter.replaceOpWithNewOp(vector.ExtractOp, extractOp, moveTileSliceToVector, position[1])

        return success()

struct VectorInsertToArmSMELowering extends ConvertOpToLLVMPattern of InsertOp:
    constructor(parameters):
        inherit constructor(parameters)

    method matchAndRewrite(insertOp, adaptor, rewriter):
        resultType = insertOp.getResult().getType()

        if !isValidSMETileVectorType(resultType):
            return failure()

        loc = insertOp.getLoc()
        position = insertOp.getMixedPosition()

        source = adaptor.getSource()

        if position.empty():
            // Overwrite entire vector with value. Should be handled by folder, but
            // just to be safe.
            rewriter.replaceOp(insertOp, source)
            return success()

        tileSlice = source
        sliceIndex = vector.getAsValues(rewriter, loc, position[0]).front()
        if position.size() == 2:
            // Two indices case: Insert single element into tile.
            // We need to first extract the existing slice and update the element.
            tileSlice = rewriter.create(arm_sme.MoveTileSliceToVectorOp, loc, adaptor.getDest(), sliceIndex)
            tileSlice = rewriter.create(vector.InsertOp, loc, source, tileSlice, position[1])

        // Insert the slice into the destination tile.
        rewriter.replaceOpWithNewOp(arm_sme.MoveVectorToTileSliceOp, insertOp, tileSlice, adaptor.getDest(), sliceIndex)
        return success()


# Configure legalizations for the Arm SME export target.
function configureArmSMELegalizeForExportTarget(target):
    # Add legal operations to the target.
    target.addLegalOp(
        scf::ForOp, scf::YieldOp, arm_sme::CastTileToVector,
        arm_sme::CastVectorToTile, arm_sme::aarch64_sme_zero,
        arm_sme::aarch64_sme_str, arm_sme::aarch64_sme_ld1b_horiz,
        arm_sme::aarch64_sme_ld1h_horiz, arm_sme::aarch64_sme_ld1w_horiz,
        arm_sme::aarch64_sme_ld1d_horiz, arm_sme::aarch64_sme_ld1q_horiz,
        arm_sme::aarch64_sme_st1b_horiz, arm_sme::aarch64_sme_st1h_horiz,
        arm_sme::aarch64_sme_st1w_horiz, arm_sme::aarch64_sme_st1d_horiz,
        arm_sme::aarch64_sme_st1q_horiz, arm_sme::aarch64_sme_ld1b_vert,
        arm_sme::aarch64_sme_ld1h_vert, arm_sme::aarch64_sme_ld1w_vert,
        arm_sme::aarch64_sme_ld1d_vert, arm_sme::aarch64_sme_ld1q_vert,
        arm_sme::aarch64_sme_st1b_vert, arm_sme::aarch64_sme_st1h_vert,
        arm_sme::aarch64_sme_st1w_vert, arm_sme::aarch64_sme_st1d_vert,
        arm_sme::aarch64_sme_st1q_vert, arm_sme::aarch64_sme_read_horiz,
        arm_sme::aarch64_sme_write_horiz, arm_sme::aarch64_sme_mopa,
        arm_sme::aarch64_sme_za_enable, arm_sme::aarch64_sme_za_disable
    )
    target.addLegalOp(GetTileID)
    target.addIllegalOp(vector::OuterProductOp)

    # Mark 'func.func' ops as legal under specific conditions.
    target.addDynamicallyLegalOp(func::FuncOp, funcOp => {
        if funcOp.isDeclaration():
            return true
        firstOp = funcOp.getBody().front().begin()
        return !funcOp->hasAttr("arm_za") || isa<arm_sme::aarch64_sme_za_enable>(firstOp)
    })

    # Mark 'func.return' ops as legal under specific conditions.
    target.addDynamicallyLegalOp(func::ReturnOp, returnOp => {
        hasDisableZA = false
        funcOp = returnOp->getParentOp()
        funcOp.walk<WalkOrder::PreOrder>(op => {
            if isa<arm_sme::aarch64_sme_za_disable>(op):
                hasDisableZA = true
        })
        return !funcOp->hasAttr("arm_za") || hasDisableZA
    })

# Populate patterns for Arm SME legalizations when exporting to LLVM.
function populateArmSMELegalizeForLLVMExportPatterns(converter, patterns):
    patterns.add<DisableZAPattern, EnableZAPattern>(patterns.getContext())
    patterns.add<
        LoadTileSliceToArmSMELowering, MoveTileSliceToVectorArmSMELowering,
        MoveVectorToTileSliceToArmSMELowering, StoreTileSliceToArmSMELowering,
        VectorOuterProductToArmSMELowering, ZeroOpConversion,
        VectorExtractToArmSMELowering, VectorInsertToArmSMELowering
    >(converter)
