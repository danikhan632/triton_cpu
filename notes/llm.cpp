#include "mlir/Dialect/LLVMIR/LLVMDialect.h"
#include "mlir/Dialect/LLVMIR/LLVMOps.h"
#include "mlir/Dialect/MemRef/IR/MemRef.h"
#include "mlir/Transforms/DialectConversion.h"
#include "mlir/Dialect/Linalg/IR/LinalgOps.h"
#include "mlir/Dialect/Tensor/IR/Tensor.h"
#include "mlir/Dialect/SCF/SCF.h"
using namespace mlir;

struct LinalgFillToLLVMConverter : public OpConversionPattern<linalg::FillOp> {
  using OpConversionPattern<linalg::FillOp>::OpConversionPattern;

  LogicalResult
  matchAndRewrite(linalg::FillOp op, OpAdaptor adaptor,
                  ConversionPatternRewriter &rewriter) const override {
    auto loc = op.getLoc();

    // Get the memref to be filled and the fill value.
    Value memref = adaptor.getOutputBuffer(0);
    Value fillValue = adaptor.getValue();

    // Extract memref type details.
    auto memrefType = memref.getType().cast<MemRefType>();
    unsigned rank = memrefType.getRank();

    // Create an LLVM loop to fill the memref.
    // For simplicity, let's assume a 1D memref. Multi-dimensional memrefs would require nested loops.

    // Create blocks for loop.
    auto loopBody = rewriter.createBlock(op->getBlock());
    auto loopEnd = rewriter.createBlock(op->getBlock());

    // Initialize loop variable to 0.
    Value zero = rewriter.create<LLVM::ConstantOp>(loc, rewriter.getI64Type(), rewriter.getI64IntegerAttr(0));
    rewriter.create<LLVM::BrOp>(loc, loopBody, zero);

    // Inside loop body, insert the fill operation and conditionally branch to loopEnd or next iteration.
    rewriter.setInsertionPointToStart(loopBody);
    Value loopVar = loopBody->getArgument(0);
    Value gep = rewriter.create<LLVM::GEPOp>(loc, fillValue.getType(), memref, loopVar);
    rewriter.create<LLVM::StoreOp>(loc, fillValue, gep);

    // Increment loop variable.
    Value one = rewriter.create<LLVM::ConstantOp>(loc, rewriter.getI64Type(), rewriter.getI64IntegerAttr(1));
    Value incremented = rewriter.create<LLVM::AddOp>(loc, loopVar, one);

    // Check loop termination condition.
    Value memrefSize = rewriter.create<LLVM::ConstantOp>(loc, rewriter.getI64Type(), rewriter.getI64IntegerAttr(memrefType.getDimSize(0)));
    Value condition = rewriter.create<LLVM::ICmpOp>(loc, LLVM::ICmpPredicate::slt, incremented, memrefSize);

    rewriter.create<LLVM::CondBrOp>(loc, condition, loopBody, incremented, loopEnd);

    // Continue with the rest of the program.
    rewriter.setInsertionPointToStart(loopEnd);

    rewriter.eraseOp(op);
    return success();
  }
};


struct LinalgBroadcastToLLVMConverter : public OpConversionPattern<linalg::GenericOp> {
  using OpConversionPattern<linalg::GenericOp>::OpConversionPattern;

  LogicalResult
  matchAndRewrite(linalg::GenericOp op, OpAdaptor adaptor,
                  ConversionPatternRewriter &rewriter) const override {
    // Check if this is a broadcasting GenericOp
    if (!op->hasAttr("broadcastDims"))
      return failure();

    auto loc = op.getLoc();

    // Extract the source and destination memrefs.
    Value srcMemref = adaptor.inputs()[0];
    Value dstMemref = adaptor.outputs()[0];

    // Extract memref type details.
    auto srcMemrefType = srcMemref.getType().cast<MemRefType>();
    auto dstMemrefType = dstMemref.getType().cast<MemRefType>();
    
    // For simplicity, assume both memrefs are 1D.
    if (srcMemrefType.getRank() != 1 || dstMemrefType.getRank() != 1)
      return failure();

    // Check if broadcasting is necessary.
    if (srcMemrefType.getDimSize(0) == 1 && dstMemrefType.getDimSize(0) > 1) {
      // Broadcasting is required.
      
      // Load the broadcast value.
      auto loadedVal = rewriter.create<LLVM::LoadOp>(loc, srcMemref);
      
      // Create a loop to fill the destination memref with the broadcast value.
      auto loop = rewriter.create<LLVM::ForOp>(loc, 
                                               rewriter.create<LLVM::ConstantOp>(loc, rewriter.getI64Type(), rewriter.getI64IntegerAttr(0)),
                                               rewriter.create<LLVM::ConstantOp>(loc, rewriter.getI64Type(), rewriter.getI64IntegerAttr(dstMemrefType.getDimSize(0))),
                                               rewriter.create<LLVM::ConstantOp>(loc, rewriter.getI64Type(), rewriter.getI64IntegerAttr(1)));
      
      // Inside the loop body, store the broadcast value at the current index.
      rewriter.setInsertionPointToStart(loop.getBody());
      auto idx = loop.getInductionVar();
      auto gep = rewriter.create<LLVM::GEPOp>(loc, dstMemref, idx);
      rewriter.create<LLVM::StoreOp>(loc, loadedVal, gep);
      
    } else if (srcMemrefType.getDimSize(0) == dstMemrefType.getDimSize(0)) {
      // No broadcasting needed, just copy values.
      
      // Create a loop to copy values from source to destination.
      auto loop = rewriter.create<LLVM::ForOp>(loc, 
                                               rewriter.create<LLVM::ConstantOp>(loc, rewriter.getI64Type(), rewriter.getI64IntegerAttr(0)),
                                               rewriter.create<LLVM::ConstantOp>(loc, rewriter.getI64Type(), rewriter.getI64IntegerAttr(srcMemrefType.getDimSize(0))),
                                               rewriter.create<LLVM::ConstantOp>(loc, rewriter.getI64Type(), rewriter.getI64IntegerAttr(1)));
      
      // Inside the loop body, load value from source and store to destination.
      rewriter.setInsertionPointToStart(loop.getBody());
      auto idx = loop.getInductionVar();
      auto srcGep = rewriter.create<LLVM::GEPOp>(loc, srcMemref, idx);
      auto loadedVal = rewriter.create<LLVM::LoadOp>(loc, srcGep);
      auto dstGep = rewriter.create<LLVM::GEPOp>(loc, dstMemref, idx);
      rewriter.create<LLVM::StoreOp>(loc, loadedVal, dstGep);

    } else {
      // Unsupported broadcasting pattern.
      return failure();
    }

    rewriter.eraseOp(op);
    return success();
  }
};


struct ExpandShapeToLLVMConverter : public OpConversionPattern<tensor::ExpandShapeOp> {
  using OpConversionPattern<tensor::ExpandShapeOp>::OpConversionPattern;

  LogicalResult
  matchAndRewrite(tensor::ExpandShapeOp op, OpAdaptor adaptor,
                  ConversionPatternRewriter &rewriter) const override {
    auto loc = op.getLoc();

    // Extract the source memref.
    Value srcMemref = adaptor.getSource();
    // TODO: Convert tensor type to memref if needed.

    // Extract memref type details.
    auto srcMemrefType = srcMemref.getType().cast<MemRefType>();
    auto dstMemrefType = op.getResult().getType().cast<MemRefType>();

    // For simplicity, assume the memrefs are 1D and 2D respectively.
    if (srcMemrefType.getRank() != 1 || dstMemrefType.getRank() != 2)
      return failure();

    // Allocate the expanded memref.
    Value expandedMemref = rewriter.create<memref::AllocaOp>(loc, dstMemrefType);

    // Create a loop to copy values from the source memref to the expanded memref.
    auto loop = rewriter.create<scf::ForOp>(loc, 
                                            rewriter.create<arith::ConstantOp>(loc, rewriter.getIndexType(), rewriter.getIndexAttr(0)),
                                            rewriter.create<arith::ConstantOp>(loc, rewriter.getIndexType(), rewriter.getIndexAttr(srcMemrefType.getDimSize(0))),
                                            rewriter.create<arith::ConstantOp>(loc, rewriter.getIndexType(), rewriter.getIndexAttr(1)),
                                            ValueRange{}, 
    [&](OpBuilder &b, Location loc, Value iv, ValueRange args) {
      auto loadedVal = b.create<memref::LoadOp>(loc, srcMemref, iv);
      b.create<memref::StoreOp>(loc, loadedVal, expandedMemref, ValueRange{iv, b.create<arith::ConstantOp>(loc, rewriter.getIndexType(), rewriter.getIndexAttr(0))});
      scf::YieldOp::build(b, loc, ValueRange{});
    });

    // TODO: If vectorization with the llvm vector dialect is applicable, replace the loop with vectorized operations.

    rewriter.replaceOp(op, expandedMemref);
    return success();
  }
};


struct LinalgLoadToLLVMConverter : public OpConversionPattern<memref::LoadOp> {
  using OpConversionPattern<memref::LoadOp>::OpConversionPattern;

  LogicalResult
  matchAndRewrite(memref::LoadOp op, OpAdaptor adaptor,
                  ConversionPatternRewriter &rewriter) const override {
    auto loc = op.getLoc();

    // Convert the memref type to an LLVM pointer type.
    MemRefType memrefType = op.getMemRefType();
    Type llvmPtrType = LLVM::LLVMPointerType::get(memrefType.getElementType());

    // Convert indices to LLVM type.
    SmallVector<Value, 4> llvmIndices;
    for (auto index : adaptor.indices()) {
      llvmIndices.push_back(rewriter.create<IndexCastOp>(loc, index, rewriter.getIntegerType(64)));
    }

    // Use `llvm.getelementptr` to calculate the pointer location.
    auto gepOp = rewriter.create<LLVM::GEPOp>(loc, llvmPtrType, adaptor.memref(), llvmIndices);

    // Use `llvm.load` to load the value from the calculated pointer.
    auto loadOp = rewriter.create<LLVM::LoadOp>(loc, gepOp);

    rewriter.replaceOp(op, loadOp.getResult());

    return success();
  }
};


struct LinalgStoreToLLVMConverter : public OpConversionPattern<memref::StoreOp> {
  using OpConversionPattern<memref::StoreOp>::OpConversionPattern;

  LogicalResult
  matchAndRewrite(memref::StoreOp op, OpAdaptor adaptor,
                  ConversionPatternRewriter &rewriter) const override {
    auto loc = op.getLoc();

    // Convert the memref type to an LLVM pointer type.
    MemRefType memrefType = op.getMemRefType();
    Type llvmPtrType = LLVM::LLVMPointerType::get(memrefType.getElementType());

    // Convert indices to LLVM type.
    SmallVector<Value, 4> llvmIndices;
    for (auto index : adaptor.indices()) {
      llvmIndices.push_back(rewriter.create<IndexCastOp>(loc, index, rewriter.getIntegerType(64)));
    }

    // Use `llvm.getelementptr` to calculate the pointer location.
    auto gepOp = rewriter.create<LLVM::GEPOp>(loc, llvmPtrType, adaptor.memref(), llvmIndices);

    // Use `llvm.store` to store the value to the calculated pointer.
    rewriter.create<LLVM::StoreOp>(loc, adaptor.value(), gepOp);

    rewriter.eraseOp(op);

    return success();
  }
};

struct LinalgForToLLVMConverter : public OpConversionPattern<scf::ForOp> {
  using OpConversionPattern<scf::ForOp>::OpConversionPattern;

  LogicalResult
  matchAndRewrite(scf::ForOp op, OpAdaptor adaptor,
                  ConversionPatternRewriter &rewriter) const override {
    auto loc = op.getLoc();
    
    // Convert loop bounds and step to LLVM integer type.
    Value lowerBound = rewriter.create<IndexCastOp>(loc, adaptor.lowerBound(), rewriter.getIntegerType(64));
    Value upperBound = rewriter.create<IndexCastOp>(loc, adaptor.upperBound(), rewriter.getIntegerType(64));
    Value step = rewriter.create<IndexCastOp>(loc, adaptor.step(), rewriter.getIntegerType(64));

    // Create the LLVM loop structure.
    auto loopBB = rewriter.createBlock(op.getBody());
    rewriter.setInsertionPointToStart(loopBB);
    auto iv = rewriter.create<LLVM::PhiOp>(loc, rewriter.getIntegerType(64), 2, ValueRange{lowerBound, nullptr}, ValueRange{op.before(), loopBB});
    rewriter.mergeBlockBefore(op.getBody(), loopBB, iv.getResult());

    auto cond = rewriter.create<LLVM::ICmpOp>(loc, LLVM::ICmpPredicate::slt, iv, upperBound);
    rewriter.create<LLVM::CondBrOp>(loc, cond, op.getBody(), ValueRange{iv}, op.after(), ValueRange{});

    // Update the loop induction variable increment.
    rewriter.setInsertionPointToEnd(loopBB);
    auto incremented = rewriter.create<LLVM::AddOp>(loc, iv, step);
    rewriter.create<LLVM::BrOp>(loc, ValueRange{incremented}, loopBB);

    rewriter.eraseOp(op);
    return success();
  }
};

struct LinalgYieldToLLVMConverter : public OpConversionPattern<scf::YieldOp> {
  using OpConversionPattern<scf::YieldOp>::OpConversionPattern;

  LogicalResult
  matchAndRewrite(scf::YieldOp op, OpAdaptor adaptor,
                  ConversionPatternRewriter &rewriter) const override {
    // For the SCF yield, we simply create an LLVM return operation.
    rewriter.replaceOpWithNewOp<LLVM::ReturnOp>(op, adaptor.getOperands());
    return success();
  }
};

// get_program_id and get_num_programs:
// When launching triton kernels, we pass 6 additional arguments to indicate
// num_programs and program_id. Amongst those six, we have 3 arguments
// correspond to each axis for num_programs followed by 3 additional arguments
// for program_id.
//
// For instance, with triton kernel example_kernel(a, b, c), we have:
//  example_kernel(
//    a, b, c,
//    num_programs_axis_0,
//    num_programs_axis_1,
//    num_programs_axis_2,
//    program_id_axis_0,
//    program_id_axis_1,
//    program_id_axis_2,
//   )
//
struct GetProgramIDConverter
    : public OpConversionPattern<triton::GetProgramIdOp> {
  using OpConversionPattern<triton::GetProgramIdOp>::OpConversionPattern;
  static uint32_t constexpr LAUNCH_GRID_RANK =
      getMaxEnumValForProgramIDDim() + 1;

public:
  GetProgramIDConverter(MLIRContext *context) : OpConversionPattern(context) {}

  LogicalResult
  matchAndRewrite(triton::GetProgramIdOp op, OpAdaptor adaptor,
                  ConversionPatternRewriter &rewriter) const override {
    auto axis = (uint32_t)op.getAxis();
    assert(axis < LAUNCH_GRID_RANK && "program_id expects "
                                      "axis to be either 0, "
                                      "1, or 2");

    auto func = op->getParentOfType<FunctionOpInterface>();
    auto numArgs = func.getNumArguments();
    auto id = func.getArgument(numArgs - LAUNCH_GRID_RANK + axis);

    rewriter.replaceOp(op, id);
    return success();
  }
};

struct GetNumProgramsConverter
    : public OpConversionPattern<triton::GetNumProgramsOp> {
  using OpConversionPattern<triton::GetNumProgramsOp>::OpConversionPattern;

private:
  static uint32_t constexpr LAUNCH_GRID_RANK =
      getMaxEnumValForProgramIDDim() + 1;

public:
  GetNumProgramsConverter(MLIRContext *context)
      : OpConversionPattern(context) {}

  LogicalResult
  matchAndRewrite(triton::GetNumProgramsOp op, OpAdaptor adaptor,
                  ConversionPatternRewriter &rewriter) const override {
    auto axis = (uint32_t)op.getAxis();
    assert(axis < LAUNCH_GRID_RANK && "program_id expects "
                                      "axis to be either 0, "
                                      "1, or 2");

    auto func = op->getParentOfType<FunctionOpInterface>();
    auto numArgs = func.getNumArguments();
    auto id = func.getArgument(numArgs - LAUNCH_GRID_RANK * 2 + axis);

    rewriter.replaceOp(op, id);
    return success();
  }
};


struct MatmulToLLVMConverter : public OpConversionPattern<linalg::MatmulOp> {
  using OpConversionPattern<linalg::MatmulOp>::OpConversionPattern;

  LogicalResult
  matchAndRewrite(linalg::MatmulOp op, OpAdaptor adaptor,
                  ConversionPatternRewriter &rewriter) const override {
    // Assumption: matrices are 2D and of float type for simplicity
    Value A = adaptor.getInput(0);
    Value B = adaptor.getInput(1);
    Value C = adaptor.getOutputBuffer(0);

    auto loc = op.getLoc();
    Type floatType = rewriter.getF32Type();

    // For now, let's assume matrices are of a known size for simplicity
    int M = A.getType().cast<MemRefType>().getDimSize(0);
    int N = B.getType().cast<MemRefType>().getDimSize(1);
    int K = A.getType().cast<MemRefType>().getDimSize(1);

    // Create loops for matrix multiplication
    auto loop1 = rewriter.create<scf::ForOp>(loc, 0, M, 1, ValueRange{}, [&](OpBuilder &b1, Location loc, Value i, ValueRange args1) {
      auto loop2 = b1.create<scf::ForOp>(loc, 0, N, 1, ValueRange{}, [&](OpBuilder &b2, Location loc, Value j, ValueRange args2) {
        Value sum = b2.create<arith::ConstantFloatOp>(loc, llvm::APFloat(0.0), floatType);
        
        auto loop3 = b2.create<scf::ForOp>(loc, 0, K, 1, ValueRange{sum}, [&](OpBuilder &b3, Location loc, Value k, ValueRange args3) {
          Value aElem = b3.create<memref::LoadOp>(loc, A, ValueRange{i, k});
          Value bElem = b3.create<memref::LoadOp>(loc, B, ValueRange{k, j});
          Value product = b3.create<arith::MulFOp>(loc, aElem, bElem);
          Value newSum = b3.create<arith::AddFOp>(loc, args3[0], product);
          b3.create<scf::YieldOp>(loc, newSum);
        });
        b2.create<memref::StoreOp>(loc, loop3.results()[0], C, ValueRange{i, j});
      });
    });

    rewriter.eraseOp(op);
    return success();
  }
};



struct LinalgFillToLLVMConverter : public OpConversionPattern<linalg::FillOp> {
  using OpConversionPattern<linalg::FillOp>::OpConversionPattern;

  LogicalResult
  matchAndRewrite(linalg::FillOp op, OpAdaptor adaptor,
                  ConversionPatternRewriter &rewriter) const override {
    auto loc = op.getLoc();
    auto value = adaptor.value();
    auto outputMemRef = adaptor.output();
    auto memRefType = outputMemRef.getType().cast<MemRefType>();
    auto elementType = memRefType.getElementType();

    // Create a loop for each dimension of the memref
    SmallVector<Value, 4> loopIVs;
    for (int i = 0; i < memRefType.getRank(); ++i) {
      auto loop = rewriter.create<LLVM::ForOp>(
          loc, rewriter.create<LLVM::ConstantOp>(
                   loc, rewriter.getIntegerType(64),
                   rewriter.getIntegerAttr(rewriter.getIntegerType(64), 0)),
          rewriter.create<LLVM::ConstantOp>(
              loc, rewriter.getIntegerType(64),
              rewriter.getIntegerAttr(rewriter.getIntegerType(64),
                                      memRefType.getDimSize(i))),
          rewriter.create<LLVM::ConstantOp>(
              loc, rewriter.getIntegerType(64),
              rewriter.getIntegerAttr(rewriter.getIntegerType(64), 1)));

      // Set insertion point inside the loop
      rewriter.setInsertionPointToStart(loop.getBody());
      loopIVs.push_back(loop.getInductionVar());
    }

    // Store the value into the memref at the current loop indices
    rewriter.create<LLVM::StoreOp>(loc, value, outputMemRef, loopIVs);

    // Erase the original linalg::FillOp
    rewriter.eraseOp(op);
    return success();
  }
};


//z

struct LLVMMinMaxConverter : public OpConversionPattern<arith::SelectOp> {
  using OpConversionPattern<arith::SelectOp>::OpConversionPattern;

public:
  LLVMMinMaxConverter(MLIRContext *context)
      : OpConversionPattern<arith::SelectOp>(context) {}

  LogicalResult matchAndRewrite(arith::SelectOp selectOp, OpAdaptor adaptor,
                                ConversionPatternRewriter &rewriter) const override {
    auto condition = selectOp.getCondition();
    auto trueValue = selectOp.getTrueValue();
    auto falseValue = selectOp.getFalseValue();

    // Check for a preceding CmpOp
    auto cmpOp = condition.getDefiningOp<arith::CmpOp>();
    if (!cmpOp) {
      return failure();
    }

    auto loc = selectOp.getLoc();

    // Replace with vectorized operations for floating point comparisons
    if (auto fcmp = dyn_cast<arith::CmpFOp>(cmpOp)) {
      switch (fcmp.getPredicate()) {
      case arith::CmpFPredicate::OGT:
      case arith::CmpFPredicate::OGT:
        rewriter.replaceOpWithNewOp<LLVM::MaxOp>(selectOp, trueValue, falseValue);
        return success();
      case arith::CmpFPredicate::OLT:
      case arith::CmpFPredicate::OLE:
        rewriter.replaceOpWithNewOp<LLVM::MinOp>(selectOp, trueValue, falseValue);
        return success();
      default:
        break;
      }
    }

    // Replace with vectorized operations for integer comparisons
    if (auto icmp = dyn_cast<arith::CmpIOp>(cmpOp)) {
      switch (icmp.getPredicate()) {
      case arith::CmpIPredicate::sgt:
      case arith::CmpIPredicate::sge:
        rewriter.replaceOpWithNewOp<LLVM::SMaxOp>(selectOp, trueValue, falseValue);
        return success();
      case arith::CmpIPredicate::slt:
      case arith::CmpIPredicate::sle:
        rewriter.replaceOpWithNewOp<LLVM::SMinOp>(selectOp, trueValue, falseValue);
        return success();
      case arith::CmpIPredicate::ugt:
      case arith::CmpIPredicate::uge:
        rewriter.replaceOpWithNewOp<LLVM::UMaxOp>(selectOp, trueValue, falseValue);
        return success();
      case arith::CmpIPredicate::ult:
      case arith::CmpIPredicate::ule:
        rewriter.replaceOpWithNewOp<LLVM::UMinOp>(selectOp, trueValue, falseValue);
        return success();
      default:
        break;
      }
    }

    return failure();
  }
};
