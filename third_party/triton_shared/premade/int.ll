module {
  llvm.func @arm_sve_sdot(%arg0: vector<[16]xi8>, %arg1: vector<[16]xi8>, %arg2: vector<[4]xi32>) -> vector<[4]xi32> {
    %0 = "arm_sve.intr.sdot"(%arg2, %arg0, %arg1) : (vector<[4]xi32>, vector<[16]xi8>, vector<[16]xi8>) -> vector<[4]xi32>
    llvm.return %0 : vector<[4]xi32>
  }
  llvm.func @arm_sve_smmla(%arg0: vector<[16]xi8>, %arg1: vector<[16]xi8>, %arg2: vector<[4]xi32>) -> vector<[4]xi32> {
    %0 = "arm_sve.intr.smmla"(%arg2, %arg0, %arg1) : (vector<[4]xi32>, vector<[16]xi8>, vector<[16]xi8>) -> vector<[4]xi32>
    llvm.return %0 : vector<[4]xi32>
  }
  llvm.func @arm_sve_udot(%arg0: vector<[16]xi8>, %arg1: vector<[16]xi8>, %arg2: vector<[4]xi32>) -> vector<[4]xi32> {
    %0 = "arm_sve.intr.udot"(%arg2, %arg0, %arg1) : (vector<[4]xi32>, vector<[16]xi8>, vector<[16]xi8>) -> vector<[4]xi32>
    llvm.return %0 : vector<[4]xi32>
  }
  llvm.func @arm_sve_ummla(%arg0: vector<[16]xi8>, %arg1: vector<[16]xi8>, %arg2: vector<[4]xi32>) -> vector<[4]xi32> {
    %0 = "arm_sve.intr.ummla"(%arg2, %arg0, %arg1) : (vector<[4]xi32>, vector<[16]xi8>, vector<[16]xi8>) -> vector<[4]xi32>
    llvm.return %0 : vector<[4]xi32>
  }
  llvm.func @arm_sve_masked_arithi(%arg0: vector<[4]xi32>, %arg1: vector<[4]xi32>, %arg2: vector<[4]xi32>, %arg3: vector<[4]xi32>, %arg4: vector<[4]xi32>, %arg5: vector<[4]xi1>) -> vector<[4]xi32> {
    %0 = "arm_sve.intr.mul"(%arg5, %arg0, %arg1) : (vector<[4]xi1>, vector<[4]xi32>, vector<[4]xi32>) -> vector<[4]xi32>
    %1 = "arm_sve.intr.add"(%arg5, %0, %arg2) : (vector<[4]xi1>, vector<[4]xi32>, vector<[4]xi32>) -> vector<[4]xi32>
    %2 = "arm_sve.intr.sub"(%arg5, %1, %arg3) : (vector<[4]xi1>, vector<[4]xi32>, vector<[4]xi32>) -> vector<[4]xi32>
    %3 = "arm_sve.intr.sdiv"(%arg5, %2, %arg4) : (vector<[4]xi1>, vector<[4]xi32>, vector<[4]xi32>) -> vector<[4]xi32>
    %4 = "arm_sve.intr.udiv"(%arg5, %3, %arg4) : (vector<[4]xi1>, vector<[4]xi32>, vector<[4]xi32>) -> vector<[4]xi32>
    llvm.return %2 : vector<[4]xi32>
  }
  llvm.func @arm_sve_masked_arithf(%arg0: vector<[4]xf32>, %arg1: vector<[4]xf32>, %arg2: vector<[4]xf32>, %arg3: vector<[4]xf32>, %arg4: vector<[4]xf32>, %arg5: vector<[4]xi1>) -> vector<[4]xf32> {
    %0 = "arm_sve.intr.fmul"(%arg5, %arg0, %arg1) : (vector<[4]xi1>, vector<[4]xf32>, vector<[4]xf32>) -> vector<[4]xf32>
    %1 = "arm_sve.intr.fadd"(%arg5, %0, %arg2) : (vector<[4]xi1>, vector<[4]xf32>, vector<[4]xf32>) -> vector<[4]xf32>
    %2 = "arm_sve.intr.fsub"(%arg5, %1, %arg3) : (vector<[4]xi1>, vector<[4]xf32>, vector<[4]xf32>) -> vector<[4]xf32>
    %3 = "arm_sve.intr.fdiv"(%arg5, %2, %arg4) : (vector<[4]xi1>, vector<[4]xf32>, vector<[4]xf32>) -> vector<[4]xf32>
    llvm.return %3 : vector<[4]xf32>
  }
  llvm.func @arm_sve_convert_to_svbool(%arg0: vector<[1]xi1>, %arg1: vector<[2]xi1>, %arg2: vector<[4]xi1>, %arg3: vector<[8]xi1>, %arg4: !llvm.array<2 x array<3 x vector<[1]xi1>>>, %arg5: !llvm.array<4 x vector<[2]xi1>>, %arg6: !llvm.array<1 x array<1 x array<1 x array<2 x vector<[4]xi1>>>>>, %arg7: !llvm.array<100 x vector<[8]xi1>>) {
    llvm.return
  }
  llvm.func @arm_sve_convert_from_svbool(%arg0: vector<[16]xi1>, %arg1: !llvm.array<2 x array<3 x vector<[16]xi1>>>, %arg2: !llvm.array<4 x vector<[16]xi1>>, %arg3: !llvm.array<1 x array<1 x array<1 x array<1 x vector<[16]xi1>>>>>, %arg4: !llvm.array<32 x vector<[16]xi1>>) {
    llvm.return
  }
}
