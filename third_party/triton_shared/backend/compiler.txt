from triton.backends.compiler import BaseBackend
from triton._C.libtriton import ir, passes
from dataclasses import dataclass
from typing import Any
import hashlib
import tempfile
import os
import re
import subprocess
import functools
from pathlib import Path



def printc(obj, color="cyan"): #makes things easier to see, will remove later
    color_code = {
        "black": "30", "red": "31", "green": "32", "yellow": "33",
        "blue": "34", "magenta": "35", "cyan": "36", "white": "37"
    }
    colored_text = f"\033[{color_code[color]}m{obj}\033[0m" if color in color_code else obj
    print(colored_text)



def _get_triton_shared_opt_path() -> str:
    path = os.getenv("TRITON_SHARED_OPT_PATH", "")
    os.system("clear")
    # if path == "":
    #     raise Exception("TRITON_SHARED_OPT_PATH is not set.")
    path="/home/green/code/triton-cpu/python/build/cmake.linux-x86_64-cpython-3.11/third_party/triton_shared/tools/triton-shared-opt/triton-shared-opt"
    return path

def _get_triton_local_opt_path() -> str:
    path = os.getenv("TRITON_SHARED_OPT_PATH", "")
    os.system("clear")
    # if path == "":
    #     raise Exception("TRITON_SHARED_OPT_PATH is not set.")
    path="/home/green/code/triton-cpu/python/build/cmake.linux-x86_64-cpython-3.11/third_party/triton_shared/tools/triton-local-opt/triton-local-opt"
    return path


def _get_triton_sme_opt_path() -> str:
    path = os.getenv("TRITON_SHARED_OPT_PATH", "")
    os.system("clear")
    # if path == "":
    #     raise Exception("TRITON_SHARED_OPT_PATH is not set.")
    path="/home/green/code/triton-cpu/python/build/cmake.linux-x86_64-cpython-3.11/third_party/triton_shared/tools/triton-sme-opt/triton-sme-opt"
    return path



def _get_llvm_bin_path(bin_name: str) -> str:
    path = os.getenv("LLVM_BINARY_DIR", "")
    # if path == "":
    #     raise Exception("LLVM_BINARY_DIR is not set.")
    path="/home/green/code/triton-vortex/llvm/build/bin"
    return os.path.join(path, bin_name)


def _ttir_to_ttsharedir(mod):
    # Get Triton-MLIR as string
    
    ttir_code = str(mod)
    print(ttir_code)
    with tempfile.TemporaryDirectory() as tmpdir:
        src_path = os.path.join(tmpdir, "tt.mlir")
        dst_path = os.path.join(tmpdir, "ttshared.mlir")
        Path(src_path).write_text(ttir_code)
        triton_shared_opt_path = _get_triton_shared_opt_path()
        subprocess.check_call([triton_shared_opt_path, src_path, "--canonicalize", "--triton-to-linalg", "--cse", "-o", dst_path])
        printc(Path(src_path).read_text(),'green')
        foo = Path(dst_path).read_text()
        printc(foo)
        return foo

def _tensor_bufferize(ttsharedir: str) -> str:
    with tempfile.TemporaryDirectory() as tmpdir:
        src_path = os.path.join(tmpdir, "ttshared.mlir")
        dst_path = os.path.join(tmpdir, "bufferized.mlir")
        Path(src_path).write_text(ttsharedir)
        
        mlir_opt_path = _get_llvm_bin_path("mlir-opt")
        # First stage: Tensor bufferization
        subprocess.check_call([mlir_opt_path, src_path,
            "--convert-linalg-to-affine-loops",
            "--eliminate-empty-tensors",
            "--empty-tensor-to-alloc-tensor",
            "--one-shot-bufferize=allow-return-allocs-from-loops=true",
            "-o", dst_path])
            
        return Path(dst_path).read_text()

def _optimize_local_memory(bufferized_mlir: str) -> str:
    with tempfile.TemporaryDirectory() as tmpdir:
        src_path = os.path.join(tmpdir, "bufferized.mlir")
        dst_path = os.path.join(tmpdir, "localmem.mlir")
        Path(src_path).write_text(bufferized_mlir)
        
        # Second stage: Local memory optimization
        subprocess.check_call([_get_triton_local_opt_path(), 
            src_path, 
            "--local-mem-conversion",
            "-o", dst_path])
            
        return Path(dst_path).read_text()
    
    
def _optimize_vector_memory(bufferized_mlir: str) -> str:
    
    with tempfile.TemporaryDirectory() as tmpdir:
        src_path = os.path.join(tmpdir, "bufferized.mlir")
        dst_path = os.path.join(tmpdir, "shared_mem.mlir")
        Path(src_path).write_text(bufferized_mlir)
        
        # Second stage: Local memory optimization
        subprocess.check_call([_get_triton_sme_opt_path(), 
            src_path, 
            "--sme-conversion",
            "-o", dst_path])
        foo = Path(dst_path).read_text()
        printc(foo,"magenta")
        return foo

def _lower_to_llvm(optimized_mlir: str) -> str:
    with tempfile.TemporaryDirectory() as tmpdir:
        src_path = os.path.join(tmpdir, "optimized.mlir")
        llmlir_path = os.path.join(tmpdir, "ll.mlir")
        llir_path = os.path.join(tmpdir, "ll.ir")
        Path(src_path).write_text(optimized_mlir)
        printc(Path(src_path).read_text())
        mlir_opt_path = _get_llvm_bin_path("mlir-opt")
        # Third stage: Lower to LLVM
        subprocess.check_call([mlir_opt_path, src_path,
            "--lower-affine",
            "--convert-linalg-to-loops",
            "--convert-scf-to-cf",
            "--convert-cf-to-llvm",
            "--convert-arith-to-llvm",
            "--convert-math-to-llvm",
            "--convert-complex-to-llvm",
            "--convert-vector-to-llvm",
            "--convert-index-to-llvm",
            "--memref-expand",
            "--expand-strided-metadata",
            "--finalize-memref-to-llvm",
            "--convert-func-to-llvm",
            "--lower-affine",
            "--convert-arith-to-llvm",
            "--reconcile-unrealized-casts",
            "-o", llmlir_path])
            
        # Convert LLVM-MLIR to LLVM-IR
        mlir_translate_path = _get_llvm_bin_path("mlir-translate")
        subprocess.check_call([mlir_translate_path, llmlir_path,
            "--mlir-to-llvmir",
            "-o", llir_path])
            
        return Path(llir_path).read_text()

def process_mlir(ttsharedir: str) -> str:
    # Run the full pipeline
    bufferized = _tensor_bufferize(ttsharedir)
    optimized = _optimize_local_memory( _optimize_vector_memory(optimized))
    llvm_ir = _lower_to_llvm(optimized)
    return llvm_ir


def _optimize_llir(llir: str):
    # We don't apply any optimizations now, but we can add passes if needed.
    printc(llir,'yellow')
    return llir


def _llir_to_bin(llir: str, metadata):
    pattern = r"define void @(\w+)\(.+"
    matches = re.findall(pattern, llir)
    assert len(matches) == 1
    metadata["name"] = matches[0]
    
    with tempfile.TemporaryDirectory() as tmpdir:
        src_path = os.path.join(tmpdir, "kernel.ll")
        dst_path = os.path.join(tmpdir, "kernel.o")
        Path(src_path).write_text(llir)
        
        llc_path = _get_llvm_bin_path("llc")
        
        # Prepare the command with the provided arguments
        llc_command = [
            llc_path,
            "-march=riscv32",
            "-mattr=+m,+a,+f,+vortex,+zicond",
            "-mcpu=generic-rv32",
            "-mtriple=riscv32-unknown-elf",
            src_path,
            "-o", dst_path
        ]
        
        subprocess.check_call(llc_command)
        
        # Read the output binary (text-format assembly)
        foo = Path(dst_path).read_text()
        open("kernel.s","w").write(foo)
        printc(foo,'red')  # Assuming you want to print the assembly output in the console
        
        return foo



@dataclass(frozen=True)
class CPUOptions:
    debug: bool = False
    arch: str = None
    num_warps: int = 0
    num_ctas: int = 0
    num_stages: int = 1
    enable_warp_specialization: bool = False
    enable_fp_fusion: bool = False
    extern_libs = None
    cluster_dims: tuple = (1, 1, 1)
    shared: bool = False
    allow_fp8e4nv: bool = False

    def __post_init__(self):
        pass

    def hash(self):
        key = '_'.join([f'{name}-{val}' for name, val in self.__dict__.items()])
        return hashlib.md5(key.encode("utf-8")).hexdigest()


class CPUBackend(BaseBackend):
    binary_ext = 'cpuasm'

    @staticmethod
    def supports_target(target: str):
        return target == 'cpu'

    def __init__(self, target: tuple) -> None:
        super().__init__(target)

    def parse_options(self, opts) -> Any:
        args = {'arch': self.target}
        args.update({k: opts[k] for k in CPUOptions.__dataclass_fields__.keys() if k in opts})
        return CPUOptions(**args)

    # Our compilation pipeline isn't in python like nvidia or amd, no need to load
    # dialects. See `triton_shared.cc`
    def load_dialects(self, ctx):
        return

    @staticmethod
    def make_ttir(mod, metadata, opt):
        pm = ir.pass_manager(mod.context)
        pm.enable_debug()
        passes.common.add_inliner(pm)
        passes.ttir.add_combine(pm)
        passes.common.add_canonicalizer(pm)
        passes.ttir.add_reorder_broadcast(pm)
        passes.common.add_cse(pm)
        passes.common.add_licm(pm)
        passes.common.add_symbol_dce(pm)
        pm.run(mod)
        return mod

    def add_stages(self, stages, options):
        stages["ttir"] = lambda src, metadata: self.make_ttir(src, metadata, options)
        
        # Split ttsharedir into bufferize and local memory stages
        stages["ttbufferized"] = lambda src, metadata: _tensor_bufferize(_ttir_to_ttsharedir(src))
        stages["ttsharedir"] = lambda src, metadata: _optimize_local_memory(src)

  
        
        # Split llir into two stages
        stages["llmlir"] = lambda src, metadata: _lower_to_llvm(src)
        stages["llir"] = lambda src, metadata: _optimize_llir(src)
        
        stages["cpuasm"] = lambda src, metadata: _llir_to_bin(src, metadata)

    @functools.lru_cache()
    def hash(self):
        return self.target