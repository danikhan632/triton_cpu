func.func @arm_sve_sdot(%a: vector<[16]xi8>,
                   %b: vector<[16]xi8>,
                   %c: vector<[4]xi32>) {



  %0 = arm_sve.sdot %c, %a, %b :
             vector<[16]xi8> to vector<[4]xi32>
  return
}
