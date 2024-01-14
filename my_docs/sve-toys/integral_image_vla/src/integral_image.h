//------------------------------------------------------------------------------------
// Copyright (C) Arm Limited, 2019-2021 All rights reserved.
//
// The example code is provided to you as an aid to learning when working
// with Arm-based technology, including but not limited to programming tutorials.
//
// Arm hereby grants to you, subject to the terms and conditions of this Licence,
// a non-exclusive, non-transferable, non-sub-licensable, free-of-charge copyright
// licence, to use, copy and modify the Software solely for the purpose of internal
// demonstration and evaluation.
//
// You accept that the Software has not been tested by Arm therefore the Software
// is provided "as is", without warranty of any kind, express or implied. In no
// event shall the authors or copyright holders be liable for any claim, damages
// or other liability, whether in action or contract, tort or otherwise, arising
// from, out of or in connection with the Software or the use of Software.
//------------------------------------------------------------------------------------

void calc_integral_image_ref(int64_t height, int64_t width, float input[height-1][width-1], float output[height][width]);
void calc_integral_image_opt(int64_t height, int64_t width, float input[height-1][width], float output[height][width]);
