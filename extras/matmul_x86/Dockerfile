


# sudo apt-get install -y build-essential ninja-build  libc6
# sudo add-apt-repository ppa:deadsnakes/ppa
# sudo apt-get install python3.11 python3.11-venv python3.11-dev python3.11-distutils python3-pip

# python3.11 -m pip install --upgrade pre-commit
# python3.11 -m pip install cmake==3.24 ninja pytest-xdist

# sudo apt-get install -y ccache clang lld

# wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-keyring_1.1-1_all.deb
# sudo dpkg -i cuda-keyring_1.1-1_all.deb
# sudo apt-get update
# sudo apt-get -y install cuda-toolkit-12-4



# python3.11 -m pre_commit run --all-files --verbose


# Use the latest Ubuntu as the base image
FROM ubuntu:latest

# Install necessary packages
RUN apt-get update -y && apt-get install -y \
    git \
    python3-pip \
    ccache \
    clang \
    lld 


# Setup the environment similar to GitHub Actions
ENV PATH="/root/.local/bin:${PATH}"
# ENV TRITON_PLUGIN_DIRS="/triton_shared"
ENV TRITON_BUILD_WITH_CLANG_LLD=true
ENV TRITON_BUILD_WITH_CCACHE=true

# Clone the triton-shared repository (adjust the branch as necessary)
# Note: You need to handle the input parameters and conditionals outside of Dockerfile.
RUN git clone https://github.com/openai/triton.git
WORKDIR /triton
RUN git checkout 62893c1d1ed64f3a42f6cfb5ca4501dc7b44d568

RUN cd third_party && git clone https://github.com/microsoft/triton-shared.git


RUN cd third_party && mv ./triton-shared ./triton_shared

# Optionally checkout a specific ref for triton
# RUN (cd /triton_shared/triton && git checkout your-branch)

# Clear Triton Cache
RUN rm -rf /root/.triton

# Install Python dependencies
RUN python3 -m pip install pre-commit cmake==3.24 ninja pytest-xdist pytest lit
RUN python3 -m pip install  torch --index-url https://download.pytorch.org/whl/cpu 



# Prepare the environment for running tests
# Note: Adjust the paths according to where things are actually located after the build
ENV LLVM_BINARY_DIR="/root/.triton/llvm/$(ls /root/.triton/llvm/ | grep -i llvm)/bin"
# The following might need adjustments based on the actual build directory structure
ENV TRITON_SHARED_OPT_PATH="/triton/python/build/cmake.linux-x86_64-cpython-3.10/third_party/triton_shared/tools/triton-shared-opt"

ENV TRITON_PLUGIN_DIRS="/triton/third_party/triton_shared"
# At this point, you would continue with the rest of your commands
# RUN cd python && python3 setup.py develop
# RUN commands to execute your tests and any other operations

# Set the default command for the container
CMD ["/bin/bash"]
# TRITON_BUILD_WITH_CLANG_LLD=true TRITON_CODEGEN_TRITON_SHARED=1 python3 setup.py develop
# sed -i 's/backends = \[\*BackendInstaller\.copy\(\["nvidia", "amd"\]\), \*BackendInstaller\.copy_externals\(\)\]/backends = \[\*BackendInstaller\.copy\(\["nvidia", "amd", "triton_shared"\]\), \*BackendInstaller\.copy_externals\(\)\]/g' setup.py


# export CC="/bin/clang-14"
# export CXX="/bin/clang++-14"
