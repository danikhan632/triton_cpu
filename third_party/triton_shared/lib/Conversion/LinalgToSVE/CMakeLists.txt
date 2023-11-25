#===------------------------------------------------------------------------===#
#
# Copyright (Triton Project Contributors.
#
#===------------------------------------------------------------------------===#

add_mlir_conversion_library(ConvertArithToSVE
  ConvertArithToSVE.cpp
  ConvertArithToSVEPass.cpp

  DEPENDS
  # Add dependencies for tablegen or other generated files if needed

  LINK_COMPONENTS
  Core

  LINK_LIBS PUBLIC
  MLIRArithDialect
  MLIRIR
  MLIRPass
  MLIRSupport
  MLIRTransforms
  MLIRARMsvEIR
  # Add other necessary MLIR dialects and libraries
  # You might need to add dependencies specific to ARM SVE dialect or other relevant dialects
)

# If there are tablegen dependencies, add them here
# add_mlir_doc(ConvertArithToSVE -gen-pass-doc ConvertArithToSVEPass ./)
