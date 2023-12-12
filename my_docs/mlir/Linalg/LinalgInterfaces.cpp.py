function canOpOperandsBeDroppedImpl(linalgOp, droppedOperands)
    indexingMaps = empty list of AffineMap
    for each opOperand in linalgOp.getOpOperands()
        if opOperand is contained in droppedOperands
            continue
        indexingMaps.push_back(linalgOp.getMatchingIndexingMap(opOperand))
    if indexingMaps is empty
        return linalgOp.getNumLoops() == 0
    return inversePermutation(concatenateAffineMaps(indexingMaps)) is not null

function getSourceSkipUnary(value)
    op = value.getDefiningOp()
    while op is not null and op.getNumOperands() == 1
        iface = dynamic_cast<MemoryEffectOpInterface>(op)
        if iface is null or not iface.hasNoEffect()
            break
        value = op.getOperand(0)
        op = value.getDefiningOp()
    return value

function isContractionBody(block, isaPair, errs)
    if block is empty or not block.back().mightHaveTrait(OpTrait::IsTerminator)
        errs << "no terminator in the block"
        return false
    if block.getNumArguments() != 3
        errs << "expected block with 3 arguments"
        return false
    terminator = block.getTerminator()
    if terminator.getNumOperands() != 1
        errs << "expected terminator with 1 operand"
        return false
    yielded = getSourceSkipUnary(terminator.getOperand(0))
    reductionOp = yielded.getDefiningOp()
    if reductionOp.getNumResults() != 1 or reductionOp.getNumOperands() != 2
        errs << "expected reduction op to be binary"
        return false
    reductionLHS = getSourceSkipUnary(reductionOp.getOperand(0))
    reductionRHS = getSourceSkipUnary(reductionOp.getOperand(1))
    if reductionLHS != block.getArgument(2) and reductionRHS != block.getArgument(2)
        errs << "expected reduction to take block argument #2 as one of the operands (modulo unary casts)"
        return false
    contributed = getSourceSkipUnary(if reductionLHS is BlockArgument then reductionRHS else reductionLHS)
    elementwiseOp = contributed.getDefiningOp()
    if elementwiseOp.getNumResults() != 1 or elementwiseOp.getNumOperands() != 2
        errs << "expected elementwise op to be binary"
        return false
    if not isaPair(elementwiseOp, reductionOp)
        errs << "expected reduction/elementwise op kind not satisfied"
        return false
    elementwiseLHS = getSourceSkipUnary(elementwiseOp.getOperand(0))
    elementwiseRHS = getSourceSkipUnary(elementwiseOp.getOperand(1))
    if (elementwiseLHS == block.getArgument(0) and elementwiseRHS == block.getArgument(1)) or
       (elementwiseLHS == block.getArgument(1) and elementwiseRHS == block.getArgument(0))
        return true
    errs << "expected elementwise op to apply to block arguments (modulo unary casts)"
    return false

function isPairTemplateImpl(add, mul, Args)
    if size of Args is odd
        raise "expected an even number of template arguments"
    if add is of type AddOpTy and mul is of type MulOpTy
        return true
    if size of Args > 0
        return isPairTemplateImpl<Args...>(add, mul)
    else
        return false

function isContractionBody(block, Args)
    return linalg::detail::isContractionBody(block, &isPairTemplateImpl<Args...>)

function findPermutationsIndexingOperand(linalgOp, opOperand, iter)
    res = empty SmallDenseSet of int64_t
    assert linalgOp is the owner of opOperand
    indexingMap = linalgOp.getMatchingIndexingMap(opOperand)
    for each e in indexingMap.getResults()
        if e is AffineDimExpr
            if linalgOp.getIteratorTypesArray()[e.getPosition()] is iter
                count = count elements in indexingMap.getResults() where it is a function of e.getPosition()
                if count == 1
                    res.insert(e.getPosition())
    return res

constants:
    par = utils::IteratorType::parallel
    red = utils::IteratorType::reduction

function inferContractionDims(linalgOp)
    if linalgOp.getNumDpsInits() != 1 or linalgOp.getNumDpsInputs() != 2
        return failure()
    a = findPermutationsIndexingOperand(linalgOp, linalgOp.getDpsInputOperand(0), par)
    b = findPermutationsIndexingOperand(linalgOp, linalgOp.getDpsInputOperand(1), par)
    c = findPermutationsIndexingOperand(linalgOp, linalgOp.getDpsInitOperand(0), par)
    ac = a intersect c subtract b
    bc = b intersect c subtract a
    batches = a intersect b intersect c
    ra = findPermutationsIndexingOperand(linalgOp, linalgOp.getDpsInputOperand(0), red)
    rb = findPermutationsIndexingOperand(linalgOp, linalgOp.getDpsInputOperand(1), red)
    ra intersect rb
    return ContractionDimensions(sorted batches, sorted ac, sorted bc, sorted ra)

enum MatchContractionResult:
    Success = 0,
    NotLinalgOp,
    WrongNumOperands,
    NoReduction,
    NotProjectedPermutations,
    NotAddMul

function isContractionInterfaceImpl(op, dimensions)
    linalgOp = cast to LinalgOp if possible
    if linalgOp is null
        return NotLinalgOp
    if linalgOp.getNumDpsInputs() != 2 or linalgOp.getNumDpsInits() != 1
        return WrongNumOperands
    mapRange = linalgOp.getIndexingMapsArray()
    if linalgOp.getNumReductionLoops() == 0
        return NoReduction
    if any m in mapRange where not m.isProjectedPermutation()
        return NotProjectedPermutations
    // TODO: more fields than add/mul.
    if not isContractionBody<
            arith::MulFOp, arith::AddFOp,
            arith::MulIOp, arith::AddIOp,
            complex::MulOp, complex::AddOp,
            arith::AndIOp, arith::OrIOp>(
        *linalgOp.getBlock())
        return NotAddMul

    if dimensions is not null
        res = inferContractionDims(linalgOp)
        assert succeeded(res) and "unexpected failure to infer contraction dims"
        dimensions = res
    return Success

function getMatchContractionMessage(res)
    switch res
        case NotLinalgOp:
            return "expected a LinalgOp"
        case WrongNumOperands:
            return "expected op with 2 inputs and 1 output"
        case NoReduction:
            return "expected at least 1 reduction"
        case NotProjectedPermutations:
            return "expected indexing maps to be projected permutations"
        case NotAddMul:
            return "expected add/mul op in the body"
        case Success:
            return ""
        default:
            raise "unhandled MatchContractionResult case"

function isaContractionOpInterface(linalgOp)
    if linalgOp is null
        return false
    op = linalgOp.getOperation()
    return isa<ContractionOpInterface>(op) or (
        isContractionInterfaceImpl(op) == Success
    )

function verifyContractionInterface(op)
    res = isContractionInterfaceImpl(op)
    if res != Success
        op.emitError(getMatchContractionMessage(res))
        return failure()
    return success()

// ConvolutionOpInterface implementation

function getAffineExprOfType(lhs, rhs)
    if lhs is of type T
        return lhs as T
    else if rhs is of type T
        return rhs as T
    else
        return null


struct ConvAccessExprWalker:
    convolvedDims: Set of int64_t
    convolvedDimMapping: Map of int64_t to int64_t
    unConvolvedDims: Set of int64_t
    strideAndDilationMapping: Map of int64_t to AffineExpr

    function clearMultiUseDims(map):
        for dimPos from 0 to map.getNumDims():
            if count elements in map.getResults() where it is a function of dimPos > 1:
                convolvedDims.erase(dimPos)
                unConvolvedDims.erase(dimPos)
                if dimPos in convolvedDimMapping:
                    pairedDim = convolvedDimMapping[dimPos]
                    convolvedDims.erase(pairedDim)
                    unConvolvedDims.erase(pairedDim)
                    strideAndDilationMapping.erase(pairedDim)
                    convolvedDimMapping.erase(dimPos)
                    convolvedDimMapping.erase(pairedDim)

    function visitDimExpr(dimExpr):
        position = dimExpr.getPosition()
        if position in unConvolvedDims or position in convolvedDims:
            return failure()
        unConvolvedDims.insert(position)
        return success()

    function visitSymbolExpr(expr):
        return failure()

    function visitConstantExpr(expr):
        return failure()

    function visitAffineBinaryOpExpr(binaryExpr):
        if binaryExpr.getKind() != AffineExprKind::Add:
            return failure()
        lhsDimPos = getDimExprOrMulExprDimPos(binaryExpr.getLHS())
        rhsDimPos = getDimExprOrMulExprDimPos(binaryExpr.getRHS())
        if failed(lhsDimPos) or failed(rhsDimPos):
            return failure()
        convolvedDimMapping[*lhsDimPos] = *rhsDimPos
        convolvedDimMapping[*rhsDimPos] = *lhsDimPos
        return success()

    function getDimExprOrMulExprDimPos(expr):
        if expr is AffineDimExpr:
            dim = expr.getPosition()
            if dim in convolvedDims or dim in unConvolvedDims:
                return failure()
            strideAndDilationMapping[dim] = AffineConstantExpr(1)
            convolvedDims.insert(dim)
            return dim
        if expr is AffineBinaryOpExpr:
            if expr.getKind() != AffineExprKind::Mul:
                return failure()
            lhsExpr = expr.getLHS()
            rhsExpr = expr.getRHS()
            mulExpr = getAffineExprOfType<AffineSymbolExpr>(lhsExpr, rhsExpr)
            if not mulExpr:
                mulExpr = getAffineExprOfType<AffineConstantExpr>(lhsExpr, rhsExpr)
            dimExpr = getAffineExprOfType<AffineDimExpr>(lhsExpr, rhsExpr)
            if not mulExpr or not dimExpr:
                return failure()
            dim = dimExpr.getPosition()
            if dim in convolvedDims or dim in unConvolvedDims:
                return failure()
            strideAndDilationMapping[dim] = mulExpr
            convolvedDims.insert(dim)
            return dim

function getPreservedDims(map):
    assert map.isProjectedPermutation() and "expected map to have projected permutations"
    preservedDims = Set of int64_t
    for expr in map.getResults():
        preservedDims.insert(expr.cast<AffineDimExpr>().getPosition())
    return preservedDims

function getConstantsFromExprList(exprs):
    vals = List of int64_t
    for e in exprs:
        constantExpr = e.dyn_cast<AffineConstantExpr>()
        assert constantExpr and "Found non-constant stride/dilation"
        vals.push_back(constantExpr.getValue())
    return vals

function inferConvolutionDimsImpl(linalgOp, inputExprWalker, allowEmptyConvolvedDims):
    filterDims = findPermutationsIndexingOperand(linalgOp, linalgOp.getDpsInputOperand(1), par)
    outputDims = findPermutationsIndexingOperand(linalgOp, linalgOp.getDpsInitOperand(0), par)

    batch = inputExprWalker.unConvolvedDims & outputDims - filterDims
    oi = inputExprWalker.convolvedDims & outputDims
    oc = filterDims & outputDims - inputExprWalker.unConvolvedDims
    depth = filterDims & outputDims & inputExprWalker.unConvolvedDims

    filterReducedDims = findPermutationsIndexingOperand(linalgOp, linalgOp.getDpsInputOperand(1), red)
    fl = inputExprWalker.convolvedDims & filterReducedDims
    ic = inputExprWalker.unConvolvedDims & filterReducedDims

    if oi.isEmpty() and not allowEmptyConvolvedDims:
        return failure()

    dimensions = ConvolutionDimensions(
        sorted(batch),
        sorted(oi),
        sorted(oc),
        sorted(fl),
        sorted(ic),
        sorted(depth),
        strides = [],
        dilations = []
    )

    nativeStrides = linalgOp->getAttrOfType<DenseIntElementsAttr>("strides")
    if not nativeStrides:
        strideExprs = []
        for oiDim in dimensions.outputImage:
            strideExprs.push_back(inputExprWalker.strideAndDilationMapping[oiDim])
        dimensions.strides = getConstantsFromExprList(strideExprs)
    else:
        dimensions.strides = nativeStrides.getValues<int64_t>()

    nativeDilations = linalgOp->getAttrOfType<DenseIntElementsAttr>("dilations")
    if not nativeDilations:
        dilationExprs = []
        for flDim in dimensions.filterLoop:
            dilationExprs.push_back(inputExprWalker.strideAndDilationMapping[flDim])
        dimensions.dilations = getConstantsFromExprList(dilationExprs)
    else:
        dimensions.dilations = nativeDilations.getValues<int64_t>()

    return dimensions

function inferConvolutionDims(linalgOp):
    if linalgOp.getNumDpsInits() != 1 or linalgOp.getNumDpsInputs() != 2:
        return failure()

    indexingMaps = linalgOp.getIndexingMapsArray()
    inputExprWalker = ConvAccessExprWalker()
    
    for expr in indexingMaps[0].getResults():
        if inputExprWalker.visit(expr) has failed:
            return failure()
    inputExprWalker.clearMultiUseDims(indexingMaps[0])
    
    return inferConvolutionDimsImpl(linalgOp, inputExprWalker, allowEmptyConvolvedDims=false)

function isConvolutionInterfaceImpl(op, dimensions):
    linalgOp = cast<linalg::LinalgOp>(op)
    if not linalgOp:
        return MatchConvolutionResult::NotLinalgOp
    if linalgOp.getNumDpsInputs() < 2 or linalgOp.getNumDpsInits() != 1:
        return MatchConvolutionResult::WrongNumOperands

    indexingMaps = linalgOp.getIndexingMapsArray()
    inputExprWalker = ConvAccessExprWalker()
    
    for expr in indexingMaps[0].getResults():
        if inputExprWalker.visit(expr) has failed:
            return MatchConvolutionResult::WrongInputIndexingMap
    
    if not indexingMaps[1].isProjectedPermutation() or not indexingMaps.back().isProjectedPermutation():
        return MatchConvolutionResult::NotProjectedPermutations

    iteratorTypes = linalgOp.getIteratorTypesArray()
    outputDims = getPreservedDims(indexingMaps.back())
    filterDims = getPreservedDims(indexingMaps[1])
    allLoopDims = Set of int64_t()

    for outputExpr in indexingMaps.back().getResults():
        outputDim = outputExpr.cast<AffineDimExpr>().getPosition()
        if outputDim in inputExprWalker.unConvolvedDims and outputDim not in filterDims:
            if iteratorTypes[outputDim] != utils::IteratorType::parallel:
                return MatchConvolutionResult::OutputDimsNotParallel
            allLoopDims.insert(outputDim)
            continue
        if outputDim in inputExprWalker.convolvedDims and outputDim not in filterDims:
            if iteratorTypes[outputDim] != utils::IteratorType::parallel:
                return MatchConvolutionResult::OutputDimsNotParallel
            allLoopDims.insert(outputDim)
            continue
        if outputDim not in inputExprWalker.convolvedDims and outputDim not in inputExprWalker.unConvolvedDims and outputDim in filterDims:
            if iteratorTypes[outputDim] != utils::IteratorType::parallel:
                return MatchConvolutionResult::OutputDimsNotParallel
            allLoopDims.insert(outputDim)
            continue
        if outputDim in inputExprWalker.unConvolvedDims and outputDim in filterDims:
            if iteratorTypes[outputDim] != utils::IteratorType::parallel:
                return MatchConvolutionResult::OutputDimsNotParallel
            allLoopDims.insert(outputDim)
            continue
        return MatchConvolutionResult::NonConvolutionLoop
    
    for filterExpr in indexingMaps[1].getResults():
        filterDim = filterExpr.cast<AffineDimExpr>().getPosition()
        if filterDim in outputDims and filterDim not in inputExprWalker.unConvolvedDims and filterDim not in inputExprWalker.convolvedDims:
            continue
        if filterDim in inputExprWalker.convolvedDims and filterDim not in outputDims:
            if iteratorTypes[filterDim] != utils::IteratorType::reduction:
                return MatchConvolutionResult::NonOutputDimNotReduction
            if filterDim in allLoopDims:
                return MatchConvolutionResult::NonConvolutionLoop
            allLoopDims.insert(filterDim)
            continue
        if filterDim in inputExprWalker.unConvolvedDims and filterDim not in outputDims:
            if iteratorTypes[filterDim] != utils::IteratorType::reduction:
                return MatchConvolutionResult::NonOutputDimNotReduction
            if filterDim in allLoopDims:
                return MatchConvolutionResult::NonConvolutionLoop
            allLoopDims.insert(filterDim)
            continue
        if filterDim in inputExprWalker.unConvolvedDims and filterDim in outputDims:
            continue
        return MatchConvolutionResult::NonConvolutionLoop
    
    if size(allLoopDims) != linalgOp.getNumLoops():
        return MatchConvolutionResult::NonConvolutionLoop

    if dimensions:
        res = inferConvolutionDimsImpl(linalgOp, inputExprWalker, allowEmptyConvolvedDims=true)
        assert succeeded(res) and "unexpected failure to infer convolution dims"
        dimensions = res

    return MatchConvolutionResult::Success

function getMatchConvolutionMessage(res):
    switch (res):
        case MatchConvolutionResult::NotLinalgOp:
            return "expected a LinalgOp"
        case MatchConvolutionResult::WrongNumOperands:
            return "expected op with 2 inputs and 1 output"
        case MatchConvolutionResult::WrongInputIndexingMap:
            return "unexpected input index map for convolutions"
        case MatchConvolutionResult::NotProjectedPermutations:
            return "expected output/filter indexing maps to be projected permutations"
        case MatchConvolutionResult::NonConvolutionLoop:
            return "unexpected loop dimension for convolution op"
        case MatchConvolutionResult::OutputDimsNotParallel:
            return "expected all iterators used to access outputs to be parallel"
        case MatchConvolutionResult::NonOutputDimNotReduction:
            return "expected all iterators not used to access outputs to be reduction"
        case MatchConvolutionResult::Success:
            return ""
        default:
            return "unhandled MatchConvolutionResult case"

function isaConvolutionOpInterface(linalgOp):
    return isConvolutionInterfaceImpl(linalgOp.getOperation()) == MatchConvolutionResult::Success

function verifyConvolutionInterface(op):
    res = isConvolutionInterfaceImpl(op)
    if res != MatchConvolutionResult::Success:
        return op.emitError(getMatchConvolutionMessage(res))
    return success()

enum class MatchFillResult:
    Success = 0,
    NotLinalgOp,
    WrongNumOperands,
    NotScalarInput

function isFillInterfaceImpl(op):
    linalgOp = cast<linalg::LinalgOp>(op)
    if not linalgOp:
        return MatchFillResult::NotLinalgOp
    if linalgOp.getNumDpsInputs() != 1 or linalgOp.getNumDpsInits() != 1:
        return MatchFillResult::WrongNumOperands

    value = linalgOp.getDpsInputOperand(0)
    if not linalgOp.isScalar(value):
        return MatchFillResult::NotScalarInput

    return MatchFillResult::Success

function verifyFillInterface(op):
    res = isFillInterfaceImpl(op)
    if res == MatchFillResult::NotLinalgOp:
        return op.emitError("expected a LinalgOp")
    if res == MatchFillResult::WrongNumOperands:
        return op.emitError("expected op with 1 input and 1 output")
    if res == MatchFillResult::NotScalarInput:
        return op.emitError("expected op with scalar input")

    return success()

function createFlatListOfOperandDims(b, loc):
    res = []
    for opOperand in getOperation().getOpOperands():
        for i = 0 to getRank(opOperand) - 1:
            res.push_back(createFoldedDimOp(b, loc, opOperand.get(), i))
    return res
function createFlatListOfOperandStaticDims():
    res = []  # Initialize an empty list
    assert(!hasDynamicShape(), "expected operands to have static shapes")
    
    for opOperand in getOperation().getOpOperands():
        # Append the static shape dimensions for each operand to 'res'
        appendRange(res, getShape(&opOperand))
    
    return res

function createLoopRanges(b, loc):
    loopsToShapesMap = getLoopsToShapesMap()
    numDims = loopsToShapesMap.getNumDims()
    numRes = loopsToShapesMap.getNumResults()
    viewSizes = createFlatListOfOperandDims(b, loc)
    res = []  # Initialize an empty list
    
    for idx in 0 to numRes - 1:
        result = loopsToShapesMap.getResult(idx)
        
        if result is an AffineDimExpr:
            if res[result.getPosition()].offset is not set:
                res[result.getPosition()] = Range {
                    b.getIndexAttr(0),
                    viewSizes[idx],
                    b.getIndexAttr(1)
                }
    
    return res

function computeStaticLoopSizes():
    loopsToShapesMap = getLoopsToShapesMap()
    numDims = loopsToShapesMap.getNumDims()
    numRes = loopsToShapesMap.getNumResults()
    allShapeSizes = createFlatListOfOperandStaticDims()
    res = []  # Initialize an empty list
    
    for idx in 0 to numRes - 1:
        result = loopsToShapesMap.getResult(idx)
        
        if result is an AffineDimExpr:
            res[result.getPosition()] = allShapeSizes[idx]
    
    return res

# Visitor to check if any of the given set of positions from AffineDimExprs
# are used within an AffineExpr.
class HasAffineDimExprVisitor(AffineExprVisitor):
    constructor(positions):
        self.positions = positions

    function visitAffineBinaryOpExpr(binaryOpExpr):
        return visit(binaryOpExpr.getLHS()) or visit(binaryOpExpr.getRHS())

    function visitDimExpr(dimExpr):
        return self.positions.test(dimExpr.getPosition())

    function visitConstantExpr(constExpr):
        return false

    function visitSymbolExpr(symbolExpr):
        return false

function getResultsPositionInLoopsToShapeMap(op):
    inputRankSum = 0
    outputRankSum = 0
    
    for input in op.getDpsInputOperands():
        inputRankSum += op.getRank(input)
    
    for output in op.getDpsInitsMutable():
        outputRankSum += op.getRank(output)
    
    return (inputRankSum, inputRankSum + outputRankSum)

function reifyResultShapes(b, reifiedReturnShapes):
    loopsToShapesMap = getLoopsToShapesMap()
    resultShapesSubMapPos = getResultsPositionInLoopsToShapeMap(this)
    loopToResultsShapeMap = loopsToShapesMap.getSliceMap(
        resultShapesSubMapPos.first,
        resultShapesSubMapPos.second - resultShapesSubMapPos.first)
    resultShapesFromInputShapesMap = loopToResultsShapeMap.compose(getShapesToLoopsMap())
    
    outputDims = [false] * resultShapesFromInputShapesMap.getNumDims()
    outputDims.set(resultShapesSubMapPos.first, resultShapesSubMapPos.second)
    
    checkDimExpr = HasAffineDimExprVisitor(outputDims)
    loc = getOperation().getLoc()
    rewriter = IRRewriter(b)
    allResultDimValues = affine::makeComposedFoldedMultiResultAffineApply(
        rewriter, loc, resultShapesFromInputShapesMap,
        createFlatListOfOperandDims(b, loc))
    pos = 0
    shapeExprs = resultShapesFromInputShapesMap.getResults()
    
    for opOperand in getDpsInitsMutable():
        shapes = []
        
        for dim in 0 to getRank(opOperand) - 1:
            shapedType = cast<ShapedType>(opOperand.get().getType())
            
            if not shapedType.isDynamicDim(dim):
                # Static dim: Return IntegerAttr.
                shapes.push_back(b.getIndexAttr(shapedType.getDimSize(dim)))
            else:
                # Dynamic dim: Return Value.
                ofr = checkDimExpr.visit(shapeExprs[pos]) ?
                    createOrFoldDimOp(b, loc, opOperand.get(), dim) :
                    allResultDimValues[pos]
                shapes.push_back(getValueOrCreateConstantIndexOp(b, loc, ofr))
            
            pos++
        
        reifiedReturnShapes.emplace_back(shapes)
    
    return success()

function getIndexingMapIndex(opOperand):
    operandNumber = opOperand.getOperandNumber()
    dpsIface = cast<DestinationStyleOpInterface>(this.getOperation())
    
    if not dpsIface.isDpsInput(opOperand):
        return operandNumber
    
    start = dpsIface.getDpsInits().getBeginOperandIndex()
    assert(!dpsIface.isDpsInit(opOperand))
    
    return dpsIface.getNumDpsInputs() + operandNumber - start

function verifyStructuredOpInterface(op):
    linalgOp = cast<LinalgOp>(op)
    
    if linalgOp.hasDynamicIndexingMaps():
        if failed(linalgOp.verifyIndexingMapRequiredAttributes()):
            return failure()
    
    if int64_t(linalgOp.getIndexingMapsArray().size()) != linalgOp->getNumOperands():
        op.emitOpError("expected the number of indexing_map (")
            << linalgOp.getIndexingMapsArray().size()
            << ") to be equal to the number of input/output operands ("
            << linalgOp->getNumOperands() << ")"
        return
    
    for opOperand in linalgOp->getOpOperands():
        indexingMap = linalgOp.getMatchingIndexingMap(opOperand)
        
        if indexingMap.getNumSymbols() != 0:
            op.emitOpError("unexpected symbols in indexing_map #")
                << opOperand.getOperandNumber()
            return
        
        numLoops = linalgOp.getNumLoops()
        
        if indexingMap.getNumDims() != numLoops:
            op.emitOpError("expected indexing_map #")
                << opOperand.getOperandNumber() << " to have " << numLoops
                << " dim(s) to match the number of loops"
            return
        
        rank = linalgOp.getRank(opOperand)
        
        if indexingMap.getNumResults() != rank:
            op.emitOpError("expected operand rank (")
                << rank << ") to match the result rank of indexing_map #"
                << opOperand.getOperandNumber() << " ("
                << indexingMap.getNumResults() << ")"
            return
    
    redDims = []
    linalgOp.getReductionDims(redDims)
    
    if not linalgOp.getShapesToLoopsMap():
        op.emitOpError("expected the shape-to-loops map to be non-null")
        return
    
    endLoopRangeValues = linalgOp.getStaticLoopRanges()
    startLoopRangeValues = [0] * len(endLoopRangeValues)
    
    if all(d != ShapedType::isDynamic for d in endLoopRangeValues):
        for range in endLoopRangeValues:
            range -= 1
        
        for opOperand in linalgOp->getOpOperands():
            indexingMap = linalgOp.getMatchingIndexingMap(opOperand)
            startIndices = indexingMap.compose(startLoopRangeValues)
            endIndices = indexingMap.compose(endLoopRangeValues)
            shape = linalgOp.getShape(opOperand)
            
            for dim in 0 to shape.size() - 1:
                if ShapedType::isDynamic(shape[dim]) or shape[dim] == 0:
                    continue
                
                inferredDimSize = max(startIndices[dim], endIndices[dim]) + 1
                
                if min(startIndices[dim], endIndices[dim]) < 0:
                    mapStr = indexingMap.toString()
                    op.emitOpError(
                            "unexpected result less than 0 at expression #")
                        << dim << " in " << mapStr
                    return
                
                if indexingMap.getResult(dim).dyn_cast<AffineDimExpr>():
                    if inferredDimSize != shape[dim]:
                        op.emitOpError("inferred input/output operand #")
                            << opOperand.getOperandNumber() << " has shape's dimension #"
                            << dim << " to be " << inferredDimSize << ", but found "
                            << shape[dim]
                        return
                else:
                    if inferredDimSize > shape[dim]:
                        op.emitOpError("inferred input/output operand #")
                            << opOperand.getOperandNumber() << " has shape's dimension #"
                            << dim << " to be greater than or equal to "
                            << inferredDimSize << ", but found " << shape[dim]
                        return
    
    if linalgOp->getNumRegions() != 1 or not llvm::hasSingleElement(linalgOp.getRegion(0)):
        op.emitOpError("expects to have 1 region with 1 block")
        return
    
    block = linalgOp.getRegion(0).front()
    
    if len(linalgOp.getOpOperandsMatchingBBargs()) != block.getNumArguments():
        op.emitOpError("expected as many non-induction variable region "
                       "arguments as the number of input/output operands")
        return
    
    for opOperand in linalgOp.getOpOperandsMatchingBBargs():
        elementType = getElementTypeOrSelf(opOperand.get())
        argType = block.getArgument(opOperand.getOperandNumber()).getType()
        
        if elementType != argType:
            op.emitOpError("expected type of bb argument #")
                << opOperand.getOperandNumber() << " (" << argType << ")"
                << " to match element or self type of the corresponding operand ("
                << elementType << ")"
            return
    
    return success()
