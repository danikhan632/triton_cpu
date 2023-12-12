The image you've uploaded appears to be a diagram or chart with various technical terms related to computer architecture or programming, specifically referring to types of SIMD (Single Instruction, Multiple Data) execution units or extensions in processors. Without more context, it's difficult to provide in-depth explanations, but I can give you a general idea of what these terms refer to:

1. **SME (Streaming SIMD Extensions)**: This usually refers to a set of instructions that can be used to perform operations on multiple data points simultaneously, commonly used for improving performance in multimedia, scientific, and financial applications.

2. **SVE (Scalable Vector Extensions)**: This is a type of SIMD instruction set that is designed to scale with different hardware implementations. It can handle vectors of varying lengths and is used for high-performance computing tasks.

3. **SVE2**: An evolution of SVE, typically offering enhancements and additional capabilities over its predecessor.

4. **NEON DSP ++**: NEON is an advanced SIMD architecture extension for ARM processors. The "DSP++" part suggests enhancements to digital signal processing capabilities.

5. **Multi-precision arithmetic**: This refers to arithmetic operations with numbers of various sizes (precision). It's crucial in scientific computing where the range and precision of computations vary greatly.

6. **Matrix tile transposition, outer product**: These are specific matrix operations used in linear algebra, particularly in high-performance computing applications. Transposition is the rearrangement of a matrix's rows and columns, and the outer product is a specific type of matrix multiplication.

7. **Match detect & histogram**: These might refer to operations for searching data (match detection) and statistical analysis (histograms), often used in data processing and analysis.

8. **Bitwise ternary logic, permute**: These are low-level operations performed on binary data. Bitwise ternary logic refers to operations involving three operands, and permute operations rearrange the bits or vectors in a specific order.

9. **Crypto extensions like AES, SHA3, SM4**: These are likely instructions that accelerate cryptographic operations like encryption, decryption, and hash functions for security purposes.

10. **Per-lane predication**: In SIMD, 'lanes' refer to individual elements or data paths. Predication is a way to enable/disable operations on a per-element basis.

11. **Gather-load & Scatter-store**: These refer to instructions that load and store data from non-contiguous memory locations, which can improve the performance of certain algorithms.

12. **ML extensions (FP16 + DOT product)**: These are likely instructions specifically designed to accelerate machine learning algorithms, including operations on 16-bit floating-point numbers (FP16) and dot product calculations.

13. **v8.6 BF16, FP & Int8 matmul**: This refers to matrix multiplication (matmul) operations on different data types (bfloat16, floating-point, and 8-bit integers), likely related to machine learning or scientific computing.
The image you've uploaded appears to be a presentation slide detailing the register state of SME (Streaming SIMD Extensions), which is an extension to SIMD (Single Instruction, Multiple Data) capabilities in processors. Here's a breakdown of the elements shown:

1. **32 scalable SVE vector Z registers**: This refers to a set of 32 vector registers that are part of the SVE (Scalable Vector Extensions) architecture. Vector registers are used to hold multiple values for SIMD operations, and "scalable" indicates that these registers can adapt to different vector lengths for flexibility in handling various data sizes.

2. **16 scalable SVE predicate P registers**: Predicate registers in SVE are used to control which elements in the vector registers are active for SIMD operations. There are 16 of these registers, and they are also scalable.

3. **Scalable 2D ZA accumulator**: This is a new feature that acts as an accumulator for operations, likely matrix operations given the 2D nature. An accumulator is a register where intermediate arithmetic results are stored. The "horizontal and vertical 'slice' access" indicates that this accumulator can be accessed in a manner that slices through the data horizontally or vertically, which can be useful for certain types of vector or matrix operations.

4. **ZA contains virtual tiles depending on element size**: The ZA (presumably Z accumulator) is organized into "virtual tiles," which are segments of the register that can be manipulated. The size of these tiles depends on the size of the elements being processed (e.g., 8-bit integers, 16-bit integers, 32-bit floats, etc.). This allows for flexible use of the accumulator for different data types and operations.

   - The table details the virtual tile dimensions for different element sizes, implying that larger data types will have fewer tiles within the ZA. For example, 8-bit integer elements (i8) can have 16 tiles in a (16*vscale) x (16*vscale) dimension, while 128-bit elements can only have one tile of (1*vscale) x (1*vscale). The term "vscale" likely refers to a variable scaling factor that adjusts the size of the tiles based on the implementation or the operation being performed.

   - The tile names (ZA0.B, ZA1.H, ZA2.S, ZA3.D, ZA15.Q) likely refer to specific portions of the ZA with varying sizes. For instance, ".B" could stand for byte (8-bit), ".H" for half-word (16-bit), ".S" for word (32-bit), ".D" for double-word (64-bit), and ".Q" for quad-word (128-bit).

5. **Visualization of ZA tiles**: The images show the visual representation of these tiles within the ZA registers for 32-bit element tiles. The representation of Z0-31 alongside each tile indicates that these tiles span across the entire set of Z registers.

This is a simplified explanation and understanding the full depth of these concepts typically requires a background in computer architecture and assembly language programming. The specific implementation details can vary based on the processor design and the exact nature of the SIMD extensions being described.

A "ZA tile," as shown in the context of the diagrams you've uploaded, is a concept from advanced SIMD (Single Instruction, Multiple Data) architectures, likely referring to an accumulator that is used for SIMD operations in a processor. SIMD operations allow a processor to perform the same operation on multiple data points simultaneously. In SIMD architectures, "registers" are used to hold the data that these operations are 1. **Interesting Aspect:** The concept of an "access-first design" philosophy in creating online information is intriguing. This approach, which extends from user-centered design and focuses on designing online content that is equally accessible and meaningful for people with disabilities, presents a thoughtful shift in web development.

2. **Desire to Learn More:** The practical applications of WCAG guidelines in web design, especially how these guidelines can be implemented to create more accessible and inclusive digital environments, are something I would like to explore further. Understanding the nuances of these guidelines could enhance web design skills significantly.

3. **Potential Discussion Topic:** The challenges and strategies for implementing alternative text for images and other multimedia elements in web design could be an engaging discussion topic. It would be beneficial to discuss the balance between providing necessary information and avoiding overloading users with unnecessary details, especially for those using assistive technologies.performed on.

Here's a breakdown of the term based on the information provided:

1. **ZA (Z Accumulator)**: The "Z" often denotes a type of register in SIMD architectures, and when paired with "A" for accumulator, it suggests that these registers are used to accumulate results from arithmetic operations. Accumulators are special registers that store the intermediate or final results of arithmetic and logic operations.

2. **Tile**: In this context, a "tile" is a subdivision of a larger register. It's like a virtual partition within a register that can be addressed and manipulated individually. This allows for more flexible and efficient processing of data since operations can be performed on just a section of the register rather than the entire register. This is particularly useful in matrix and vector operations, which are common in high-performance computing, graphics, and machine learning applications.

3. **Virtual Tiles**: The use of the term "virtual" suggests that these tiles are not fixed hardware divisions but are instead flexible partitions that can be sized and scaled according to the needs of the computation. This means the same physical register space can be used in different ways, depending on the operation.

4. **Element Size and Tile Dimensions**: The element size (e.g., 32-bit single word) refers to the size of each individual data element within the tile. The dimensions of the tile (e.g., 8x8i32) indicate how many of these elements fit within one tile.

In summary, a ZA tile in the SIMD architecture is a section of a vector accumulator register set aside for operating on a specific portion of data, characterized by its size and the type of data it holds. This concept is part of more advanced and scalable SIMD designs, which allow for more versatile and efficient data processing.



[RFC] Scalable Vectorisation in Linalg
MLIR
May 5
Jun 9

banach-space

1
May 5
Authors: Andrzej Warzynski (Arm) and Diego Caballero (Google)

Hi everyone,

Scalable vectors are a well-established technology with broad support in multiple components of the LLVM project:

Starting from Release 14 1, LLVM will default to scalable auto-vectorisation when targeting Arm CPUs that support it (see also LLVM 14 - what’s new and improved for Arm 2),
MLIR has had support for scalable vectors for quite a while now (see e.g. VectorType 4),
SparseTensor 1 vectoriser already supports scalable vectors (see e.g. SparseVectorization.cpp 1).
We propose to extend the Linalg vectoriser so that it can also target scalable vectors and leverage the full potential of architectures that support them (see Appendix for examples). This will require changes in the following areas:

Extend tiling so that it can generate tiles with scalable sizes,
Add any missing scalable vector representation to facilitate the changes proposed here,
Teach Linalg’s vectoriser to generate scalable vectors,
Implement the missing lowering from the Vector to the LLVM dialect (and to LLVM IR).
In the sections below we dive into details for each of the above. First, let us start with a bit of background (you can skip it if you’re already familiar with the concept of scalable vectors).

A Brief Primer on Scalable Vectors in LLVM and MLIR
Scalable vectors enable Vector Length Agnostic (VLA) programming. In this model, the developer and the compiler are free from concerns about the actual width of the available vectors (e.g. 128 vs 256 bits). This allows one, for example, to compile once and then execute on CPUs with different vector widths and still utilise full vector width in every case.

Scalable vectors are like regular vectors, but their actual size is e.g. 128 * vscale rather than plain 128 bits. The value of vscale is unknown at compile time, but known at runtime. At the LLVM IR level you can use the llvm.vscale intrinsic to retrieve this value (so that it can be used in various arithmetic operations). And when defining scalable vectors, you would use vscale x 4 instead of 4 when specifying vector length.

Here’s an example of fixed-width vs scalable reductions in LLVM IR:

// Extracted from llvm/test/CodeGen/AArch64/double_reduct.ll
define float @add_f32(<8 x float> %a, <4 x float> %b) {
  %r1 = call fast float @llvm.vector.reduce.fadd.f32.v8f32(float -0.0, <8 x float> %a)
  %r2 = call fast float @llvm.vector.reduce.fadd.f32.v4f32(float -0.0, <4 x float> %b)
  %r = fadd fast float %r1, %r2
  ret float %r
}
 
declare float @llvm.vector.reduce.fadd.f32.v8f32(float, <8 x float>)
declare float @llvm.vector.reduce.fadd.f32.v4f32(float, <4 x float>)

// Extracted from llvm/test/CodeGen/AArch64/sve-doublereduct.ll
define float @add_f32(<vscale x 8 x float> %a, <vscale x 4 x float> %b) {
  %r1 = call fast float @llvm.vector.reduce.fadd.f32.nxv8f32(float -0.0, <vscale x 8 x float> %a)
  %r2 = call fast float @llvm.vector.reduce.fadd.f32.nxv4f32(float -0.0, <vscale x 4 x float> %b)
  %r = fadd fast float %r1, %r2
  ret float %r
}
 
declare float @llvm.vector.reduce.fadd.f32.nxv8f32(float, <vscale x 8 x float>)
declare float @llvm.vector.reduce.fadd.f32.nxv4f32(float, <vscale x 4 x float>)
In MLIR, the Vector dialect already implements vector.vscale 1 and supports scalable vectors. The example below demonstrates fixed-width vs scalable vector splat.

// Extracted from mlir/test/Target/LLVMIR/llvmir.mlir
 llvm.func @vector_splat_1d() -> vector<4xf32> {
   %0 = llvm.mlir.constant(dense<0.000000e+00> : vector<4xf32>) : vector<4xf32>
   llvm.return %0 : vector<4xf32>
 }
 
 llvm.func @vector_splat_1d_scalable() -> vector<[4]xf32> {
   %0 = llvm.mlir.constant(dense<0.000000e+00> : vector<[4]xf32>) : vector<[4]xf32>
   llvm.return %0 : vector<[4]xf32>
 }
The key difference is vector<4xf32> vs vector<[4]xf32. Square brackets in the vector size, [4], is the MLIR syntax for vscale, i.e. [4] == vscale x 4.

Finally, below is an example of a regular scf.for loop over scalable vectors:

func.func @vector_scalable_memcopy(%src : memref<?xf32>, %dst : memref<?xf32>, %size : index) {
  %c0 = arith.constant 0 : index
  %c4 = arith.constant 4 : index
  %vs = vector.vscale
  %step = arith.muli %c4, %vs : index

  // %step is a multiple of `vscale`
  scf.for %i0 = %c0 to %size step %step {
    %0 = vector.load %src[%i0] : memref<?xf32>, vector<[4]xf32>
    vector.store %0, %dst[%i0] : memref<?xf32>, vector<[4]xf32>
  }

  return
}
MLIR can already lower this to valid SVE code utilising scalable vectors (example extracted from vector-scalable-memcpy.mlir 1).

Proposal
We have split this proposal into 4 components - each section below corresponds to one of the key elements of scalable vectorisation. We present what is already available, what is missing and what are the proposed changes.

We will use the following example to demonstrate what we are aiming for.

// example.mlir
#map = affine_map<(d0) -> (d0)>

module {
  func.func @example(%arg0: tensor<?xf32>, %arg1: tensor<?xf32>, %arg2: tensor<?xf32>, %arg3: f32) -> tensor<?xf32> {
    %0 = linalg.generic {indexing_maps = [#map, #map, #map], iterator_types = ["parallel"]} ins(%arg0, %arg1 : tensor<?xf32>, tensor<?xf32>) outs(%arg2 : tensor<?xf32>) {
    ^bb0(%in_1: f32, %in_2: f32, %out: f32):
      %1 = arith.addf %in_1, %in_2 : f32
      %2 = arith.mulf %arg3, %1 : f32
      linalg.yield %2 : f32
    } -> tensor<?xf32>
    return %0 : tensor<?xf32>
  }
}
In this example we are using tensors, but the whole discussion would apply to memrefs as well. We will use dynamic shapes for inputs/outputs as the most suitable representation for what will later be lowered to scalable vectors.

1. Scalable Tiling
While Linalg’s vectoriser can be used without tiling, in practice one would apply tiling so that the resulting Linalg Op operates on tensors/buffers closely matching native vector sizes.

MLIR command line:

$ mlir-opt --test-transform-dialect-interpreter='transform-file-name=tile.mlir' -cse example.mlir -o example_after_tiling.mlir
Transform dialect sequence:

// tile.mlir
transform.sequence failures(propagate) {
  ^bb0(%arg1: !pdl.operation):
    %0 = transform.structured.match ops{["linalg.generic"]} in %arg1 : (!pdl.operation) -> !pdl.operation
    %1, %loop = transform.structured.tile %0 [4] : (!pdl.operation) -> (!pdl.operation, !pdl.operation)
}
IR after tiling:

// example_after_tiling.mlir
#map = affine_map<(d0)[s0] -> (4, -d0 + s0)>
#map1 = affine_map<(d0) -> (d0)>
module {
  func.func @example(%arg0: tensor<?xf32>, %arg1: tensor<?xf32>, %arg2: tensor<?xf32>, %arg3: f32) -> tensor<?xf32> {
    %c0 = arith.constant 0 : index
    %dim = tensor.dim %arg0, %c0 : tensor<?xf32>
    %c4 = arith.constant 4 : index
    %0 = scf.for %arg4 = %c0 to %dim step %c4 iter_args(%arg5 = %arg2) -> (tensor<?xf32>) {
      %1 = affine.min #map(%arg4)[%dim]
      %extracted_slice = tensor.extract_slice %arg0[%arg4] [%1] [1] : tensor<?xf32> to tensor<?xf32>
      %extracted_slice_0 = tensor.extract_slice %arg1[%arg4] [%1] [1] : tensor<?xf32> to tensor<?xf32>
      %extracted_slice_1 = tensor.extract_slice %arg5[%arg4] [%1] [1] : tensor<?xf32> to tensor<?xf32>
      %2 = linalg.generic {indexing_maps = [#map1, #map1, #map1], iterator_types = ["parallel"]} ins(%extracted_slice, %extracted_slice_0 : tensor<?xf32>, tensor<?xf32>) outs(%extracted_slice_1 : tensor<?xf32>) {
      ^bb0(%in: f32, %in_2: f32, %out: f32):
        %3 = arith.addf %in, %in_2 : f32
        %4 = arith.mulf %arg3, %3 : f32
        linalg.yield %4 : f32
      } -> tensor<?xf32>
      %inserted_slice = tensor.insert_slice %2 into %arg5[%arg4] [%1] [1] : tensor<?xf32> into tensor<?xf32>
      scf.yield %inserted_slice : tensor<?xf32>
    }
    return %0 : tensor<?xf32>
  }
}
As expected, the step in the generated loop is fixed-width:

%c4 = arith.constant 4 : index
%c0_4 = arith.constant 0 : index
%0 = scf.for %arg4 = %c0_4 to %dim step %c4 
It is actually possible to generate a scalable loops by tweaking tileSizeComputationFunction 2. The following output was generated by updating the current implementation in LinalgTransformOps.cpp.

IR after scalable tiling:

#map = affine_map<(d0)[s0, s1] -> (s0, -d0 + s1)>
#map1 = affine_map<(d0) -> (d0)>
module {
  func.func @example(%arg0: tensor<?xf32>, %arg1: tensor<?xf32>, %arg2: tensor<?xf32>, %arg3: f32) -> tensor<?xf32> {
    %c0 = arith.constant 0 : index
    %dim = tensor.dim %arg0, %c0 : tensor<?xf32>
    %c4 = arith.constant 4 : index
    %0 = vector.vscale
    %1 = arith.muli %c4, %0 : index
    %2 = scf.for %arg4 = %c0 to %dim step %1 iter_args(%arg5 = %arg2) -> (tensor<?xf32>) {
      %3 = affine.min #map(%arg4)[%1, %dim]
      %extracted_slice = tensor.extract_slice %arg0[%arg4] [%3] [1] : tensor<?xf32> to tensor<?xf32>
      %extracted_slice_0 = tensor.extract_slice %arg1[%arg4] [%3] [1] : tensor<?xf32> to tensor<?xf32>
      %extracted_slice_1 = tensor.extract_slice %arg5[%arg4] [%3] [1] : tensor<?xf32> to tensor<?xf32>
      %4 = linalg.generic {indexing_maps = [#map1, #map1, #map1], iterator_types = ["parallel"]} ins(%extracted_slice, %extracted_slice_0 : tensor<?xf32>, tensor<?xf32>) outs(%extracted_slice_1 : tensor<?xf32>) {
      ^bb0(%in: f32, %in_2: f32, %out: f32):
        %5 = arith.addf %in, %in_2 : f32
        %6 = arith.mulf %arg3, %5 : f32
        linalg.yield %6 : f32
      } -> tensor<?xf32>
      %inserted_slice = tensor.insert_slice %4 into %arg5[%arg4] [%3] [1] : tensor<?xf32> into tensor<?xf32>
      scf.yield %inserted_slice : tensor<?xf32>
    }
    return %2 : tensor<?xf32>
  }
}
This time the step in the generated loop is scalable:

    %0 = vector.vscale
    %1 = arith.muli %c4, %0 : index
    %2 = scf.for %arg4 = %c0 to %dim step %1
This is pretty much what we need in order to proceed. Since we were able to generate that with minimal changes, we believe that most of the support is already there. Modulo some plumbing (yet to be implemented upstream).

The experiment above required a few edits in “LinalgTransformOps.cpp”. Instead, we would like to drive “scalable tiling” with the transform dialect. At the moment, there is no syntax for that. We propose the following notation:

transform.structured.tile %0 [[4]] to tile one dimension using a scalable vector size with base four.
transform.structured.tile %0 [2, [4]]] to tile two dimensions using fixed-length vector size two for the first dimension and a scalable vector size with base four for the second dimension.
Proposed Changes
Update the logic in LinalgTransformOps.cpp 1 so that it will generate scalable tiles when requested.
Add syntax and support to the Transform dialect that would allow to specify scalable tile sizes.
Stress test this functionality (e.g. by contributing tests upstream).
2. Scalable Vector Representation
Scalable vectorisation heavily relies on vector masking to iterate over the iteration space with a vector length that is unknown at compile time. Although Vector masking is fully supported in the Vector dialect, some of the main masking constructs still do not support scalable vectors. The following table summarises the existing support:

Operation	Scalable Vector Support
vector.create_mask	Yes
vector.constant_mask	Yes
vector.transfer_read	No
vector.transfer_write	No
vector.gather	Yes (lowered directly to llvm.intr.masked.gather)
vector.scatter	Yes (lowered directly to llvm.intr.masked.scatter)
vector.mask	No
vector.maskedload	Yes
vector.maskedstore	Yes
vector.maskedstore	Yes
Most of the existing support in these operations comes from the extraordinary work that the community has done in the Sparse compiler vectoriser 2. However, the Sparse vectoriser operates at a lower level of abstraction where operations like vector.mask and vector.transfer_* ops are not used. These operations are fundamental to masked vectorisation in the Linalg vectoriser and will require the proper scalable vector support.

Proposed Changes
Add support for scalable vectors to vector.mask and vector.transfer_* ops.
3. Linalg Vectoriser
After scalable tiling and with the proper scalable masking support in place, we will be ready to apply scalable vectorisation using the Linalg vectoriser. The following snippets show the proposed process to apply scalable vectorisation to our running example using the Transform dialect.

MLIR command line:

$ mlir-opt --test-transform-dialect-interpreter='transform-file-name=vectorise.mlir' -cse example.mlir -o example_after_tiling.mlir
Transform dialect sequence (note the scalable [4] vector size):

// vectorize.mlir
transform.sequence  failures(propagate) {
^bb0(%arg0: !pdl.operation):
    %0 = transform.structured.match ops{["linalg.generic"]} in %arg0 : (!pdl.operation) -> !pdl.operation
    transform.structured.masked_vectorize %0 vector_sizes [[4]]]
}
IR after scalable vectorisation:

#map = affine_map<(d0)[s0, s1] -> (s0, -d0 + s1)>
module {
  func.func @example(%arg0: tensor<?xf32>, %arg1: tensor<?xf32>, %arg2: tensor<?xf32>, %arg3: f32) -> tensor<?xf32> {
    %c0 = arith.constant 0 : index
    %dim = tensor.dim %arg0, %c0 : tensor<?xf32>
    %c4 = arith.constant 4 : index
    %0 = vector.vscale
    %1 = arith.muli %c4, %0 : index
    %2 = scf.for %arg4 = %c0 to %dim step %1 iter_args(%arg5 = %arg2) -> (tensor<?xf32>) {
      %3 = affine.min #map(%arg4)[%1, %dim]
      %extracted_slice = tensor.extract_slice %arg0[%arg4] [%3] [1] : tensor<?xf32> to tensor<?xf32>
      %extracted_slice_0 = tensor.extract_slice %arg1[%arg4] [%3] [1] : tensor<?xf32> to tensor<?xf32>
      %extracted_slice_1 = tensor.extract_slice %arg5[%arg4] [%3] [1] : tensor<?xf32> to tensor<?xf32>
      %dim_2 = tensor.dim %extracted_slice, %c0 : tensor<?xf32>
      %cst = arith.constant 0.000000e+00 : f32
      %4 = vector.create_mask %dim_2 : vector<[4]xi1>
      %5 = vector.mask %4 { vector.transfer_read %extracted_slice[%c0], %cst {in_bounds = [true]} : tensor<?xf32>, vector<[4]xf32> } : vector<[4]xi1> -> vector<[4]xf32>
      %6 = vector.mask %4 { vector.transfer_read %extracted_slice_0[%c0], %cst {in_bounds = [true]} : tensor<?xf32>, vector<[4]xf32> } : vector<[4]xi1> -> vector<[4]xf32>
      %7 = arith.addf %5, %6 : vector<[4]xf32>
      %8 = vector.broadcast %arg3 : f32 to vector<[4]xf32>
      %9 = arith.mulf %8, %7 : vector<[4]xf32>
      %10 = vector.mask %4 { vector.transfer_write %9, %extracted_slice_1[%c0] {in_bounds = [true]} : vector<[4]xf32>, tensor<?xf32> } : vector<[4]xi1> -> tensor<?xf32>
      %inserted_slice = tensor.insert_slice %10 into %arg5[%arg4] [%3] [1] : tensor<?xf32> into tensor<?xf32>
      scf.yield %inserted_slice : tensor<?xf32>
    }
    return %2 : tensor<?xf32>
  }
}
As discussed for scalable tiling, we have no mechanism to express scalable vectors in the Transform dialect vectorisation sequence. We propose to use the same notation as for scalable vector types:

transform.structured.masked_vectorize %0 vector_sizes [[4]]] will vectorise one dimension using a scalable vector size with base four.
transform.structured.masked_vectorize %0 vector_sizes [2, [4]]]: will vectorise two dimensions using fixed-length vector size two for the first dimension and a scalable vector size with base four for the second dimension.
The Linalg vectoriser would also have to be extended to vectorise operations using scalable vectors and to generate scalable vector masks. This includes changes ranging from the vectoriser API to the core vectorisation algorithm.

Scalable Vectorisation Strategies: Predicated vs Unpredicated Main Vector Loop
Similar to fix-length vectorisation, scalable vectorisation may benefit from different strategies when vectorising a number of iterations that is not multiple of the physical vector length. We plan to focus on the most widely applied two: predicated/masked main vector loop without remainder loop and unpredicated/unmasked main vector loop with remainder loop.

Predicating/masking the main vector loop seems like the most canonical approach for the existing scalable vector architectures and that is what we would like to focus on first. Supporting this approach only requires basic vector masking functionality using scalable masks, which is part of our plan already. However, generating an unpredicated/unmasked main vector loop with remainder loop may perform better in practice on some architectures so we would also like to explore this strategy. For example, for Arm’s Neoverse V1 [1], whilelt (“predicated loop” instruction) has lower throughput than cmp. In order to generate a remainder loop for scalable vectorisation we only have to apply peeling to the input iteration space using the target scalable vector sizes.

[1] Arm® Neoverse™ V1 Software Optimization Guide 2

Proposed Changes
Extend Linalg vectoriser API to support input scalable vector sizes.
Compute and propagate vector sizes to scalar operations from the input vector sizes.
Extend vector masking to support scalable masks.
Make sure that the peeling transformation works with scalable vectors (to support unpredicated vectorisation).
Add syntax and support to the Transform dialect that would allow to specify scalable vector sizes.
4. Missing Vector Lowerings/Canonicalisations
We are a bit unsure about the specifics here, but in general expect to discover a lot of missing lowerings and/or canonicalisations for scalable vectors. There are also bound to be cases where we need to introduce (or at least test) missing lowerings to LLVM IR.

For example, there’s already a bunch of end-to-end integration tests in MLIR that demonstrate how to to generate valid Arm SVE/scalable code from MLIR, see e.g. sparse tensor integration tests 1. However, we haven’t really tried predicated SVE loops yet.

Proposed Changes
Introduce lowerings for predicated loops and any other missing lowerings.
Extend all relevant canonicalisation patterns (e.g. for vector transfer/masking Ops) to support scalable vectors.
Stress test new and existing lowerings/canonicalisation for scalable vectors.
Next Steps
We plan to contribute the changes proposed above to MLIR upstream. They will be implemented and tested in isolation. Following that, we will use IREE ARM CPU backend to integrate the different components and perform end-to-end testing. Once that’s available, we plan to focus on:

Evaluating SVE vectorisation using real hardware with wide vectors (e.g. 256 bits),
Based on those experiments, work on fine-tuning the performance.
Thank you for taking a look! Any feedback is more than welcome!

Andrzej and Diego

Appendix
For folks less familiar with scalable vectors, here are two major architecture extension for Arm architecture which are “scalable”:

Arm’s Scalable Vector Extension 1 (SVE)
Arm’s Scalable Matrix Extension 5 (SME)
