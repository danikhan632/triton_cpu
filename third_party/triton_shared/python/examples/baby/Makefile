# Makefile for MLIR optimization example

CXX := g++
CXXFLAGS := -std=c++17 -O2
MLIR_LIBS := $(shell llvm-config --libs) $(shell llvm-config --ldflags) -lMLIRIR -lMLIRParser -lMLIRPass -lMLIRX86Vector

# Name of your executable
TARGET := mlir_optimizer

# Source files
SRC := main.cpp

$(TARGET): $(SRC)
    @echo "Building..."
    $(CXX) $(CXXFLAGS) -o $@ $^ $(MLIR_LIBS)

clean:
    rm -f $(TARGET)

.PHONY: clean
