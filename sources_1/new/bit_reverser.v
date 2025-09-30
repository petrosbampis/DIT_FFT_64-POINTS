`timescale 1ns/100ps
/**************** Bit Reverser ************************
 * This module reorders the 64 input samples according to the bit-reversed index for the FFT.
 ******************************************************/
module bit_reverser (

    input signed [23:0] x0_real, x0_imag, x1_real, x1_imag, x2_real, x2_imag, x3_real, x3_imag,
    input signed [23:0] x4_real, x4_imag, x5_real, x5_imag, x6_real, x6_imag, x7_real, x7_imag,
    input signed [23:0] x8_real, x8_imag, x9_real, x9_imag, x10_real, x10_imag, x11_real, x11_imag,
    input signed [23:0] x12_real, x12_imag, x13_real, x13_imag, x14_real, x14_imag, x15_real, x15_imag,
    input signed [23:0] x16_real, x16_imag, x17_real, x17_imag, x18_real, x18_imag, x19_real, x19_imag,
    input signed [23:0] x20_real, x20_imag, x21_real, x21_imag, x22_real, x22_imag, x23_real, x23_imag,
    input signed [23:0] x24_real, x24_imag, x25_real, x25_imag, x26_real, x26_imag, x27_real, x27_imag,
    input signed [23:0] x28_real, x28_imag, x29_real, x29_imag, x30_real, x30_imag, x31_real, x31_imag,
    input signed [23:0] x32_real, x32_imag, x33_real, x33_imag, x34_real, x34_imag, x35_real, x35_imag,
    input signed [23:0] x36_real, x36_imag, x37_real, x37_imag, x38_real, x38_imag, x39_real, x39_imag,
    input signed [23:0] x40_real, x40_imag, x41_real, x41_imag, x42_real, x42_imag, x43_real, x43_imag,
    input signed [23:0] x44_real, x44_imag, x45_real, x45_imag, x46_real, x46_imag, x47_real, x47_imag,
    input signed [23:0] x48_real, x48_imag, x49_real, x49_imag, x50_real, x50_imag, x51_real, x51_imag,
    input signed [23:0] x52_real, x52_imag, x53_real, x53_imag, x54_real, x54_imag, x55_real, x55_imag,
    input signed [23:0] x56_real, x56_imag, x57_real, x57_imag, x58_real, x58_imag, x59_real, x59_imag,
    input signed [23:0] x60_real, x60_imag, x61_real, x61_imag, x62_real, x62_imag, x63_real, x63_imag,


    output signed [23:0] y0_real, y0_imag, y1_real, y1_imag, y2_real, y2_imag, y3_real, y3_imag,
    output signed [23:0] y4_real, y4_imag, y5_real, y5_imag, y6_real, y6_imag, y7_real, y7_imag,
    output signed [23:0] y8_real, y8_imag, y9_real, y9_imag, y10_real, y10_imag, y11_real, y11_imag,
    output signed [23:0] y12_real, y12_imag, y13_real, y13_imag, y14_real, y14_imag, y15_real, y15_imag,
    output signed [23:0] y16_real, y16_imag, y17_real, y17_imag, y18_real, y18_imag, y19_real, y19_imag,
    output signed [23:0] y20_real, y20_imag, y21_real, y21_imag, y22_real, y22_imag, y23_real, y23_imag,
    output signed [23:0] y24_real, y24_imag, y25_real, y25_imag, y26_real, y26_imag, y27_real, y27_imag,
    output signed [23:0] y28_real, y28_imag, y29_real, y29_imag, y30_real, y30_imag, y31_real, y31_imag,
    output signed [23:0] y32_real, y32_imag, y33_real, y33_imag, y34_real, y34_imag, y35_real, y35_imag,
    output signed [23:0] y36_real, y36_imag, y37_real, y37_imag, y38_real, y38_imag, y39_real, y39_imag,
    output signed [23:0] y40_real, y40_imag, y41_real, y41_imag, y42_real, y42_imag, y43_real, y43_imag,
    output signed [23:0] y44_real, y44_imag, y45_real, y45_imag, y46_real, y46_imag, y47_real, y47_imag,
    output signed [23:0] y48_real, y48_imag, y49_real, y49_imag, y50_real, y50_imag, y51_real, y51_imag,
    output signed [23:0] y52_real, y52_imag, y53_real, y53_imag, y54_real, y54_imag, y55_real, y55_imag,
    output signed [23:0] y56_real, y56_imag, y57_real, y57_imag, y58_real, y58_imag, y59_real, y59_imag,
    output signed [23:0] y60_real, y60_imag, y61_real, y61_imag, y62_real, y62_imag, y63_real, y63_imag
);
    assign y0_real = x0_real; assign y0_imag = x0_imag;
    assign y1_real = x32_real; assign y1_imag = x32_imag;
    assign y2_real = x16_real; assign y2_imag = x16_imag;
    assign y3_real = x48_real; assign y3_imag = x48_imag;
    assign y4_real = x8_real; assign y4_imag = x8_imag;
    assign y5_real = x40_real; assign y5_imag = x40_imag;
    assign y6_real = x24_real; assign y6_imag = x24_imag;
    assign y7_real = x56_real; assign y7_imag = x56_imag;
    assign y8_real = x4_real; assign y8_imag = x4_imag;
    assign y9_real = x36_real; assign y9_imag = x36_imag;
    assign y10_real = x20_real; assign y10_imag = x20_imag;
    assign y11_real = x52_real; assign y11_imag = x52_imag;
    assign y12_real = x12_real; assign y12_imag = x12_imag;
    assign y13_real = x44_real; assign y13_imag = x44_imag;
    assign y14_real = x28_real; assign y14_imag = x28_imag;
    assign y15_real = x60_real; assign y15_imag = x60_imag;
    assign y16_real = x2_real; assign y16_imag = x2_imag;
    assign y17_real = x34_real; assign y17_imag = x34_imag;
    assign y18_real = x18_real; assign y18_imag = x18_imag;
    assign y19_real = x50_real; assign y19_imag = x50_imag;
    assign y20_real = x10_real; assign y20_imag = x10_imag;
    assign y21_real = x42_real; assign y21_imag = x42_imag;
    assign y22_real = x26_real; assign y22_imag = x26_imag;
    assign y23_real = x58_real; assign y23_imag = x58_imag;
    assign y24_real = x6_real; assign y24_imag = x6_imag;
    assign y25_real = x38_real; assign y25_imag = x38_imag;
    assign y26_real = x22_real; assign y26_imag = x22_imag;
    assign y27_real = x54_real; assign y27_imag = x54_imag;
    assign y28_real = x14_real; assign y28_imag = x14_imag;
    assign y29_real = x46_real; assign y29_imag = x46_imag;
    assign y30_real = x30_real; assign y30_imag = x30_imag;
    assign y31_real = x62_real; assign y31_imag = x62_imag;
    assign y32_real = x1_real; assign y32_imag = x1_imag;
    assign y33_real = x33_real; assign y33_imag = x33_imag;
    assign y34_real = x17_real; assign y34_imag = x17_imag;
    assign y35_real = x49_real; assign y35_imag = x49_imag;
    assign y36_real = x9_real; assign y36_imag = x9_imag;
    assign y37_real = x41_real; assign y37_imag = x41_imag;
    assign y38_real = x25_real; assign y38_imag = x25_imag;
    assign y39_real = x57_real; assign y39_imag = x57_imag;
    assign y40_real = x5_real; assign y40_imag = x5_imag;
    assign y41_real = x37_real; assign y41_imag = x37_imag;
    assign y42_real = x21_real; assign y42_imag = x21_imag;
    assign y43_real = x53_real; assign y43_imag = x53_imag;
    assign y44_real = x13_real; assign y44_imag = x13_imag;
    assign y45_real = x45_real; assign y45_imag = x45_imag;
    assign y46_real = x29_real; assign y46_imag = x29_imag;
    assign y47_real = x61_real; assign y47_imag = x61_imag;
    assign y48_real = x3_real; assign y48_imag = x3_imag;
    assign y49_real = x35_real; assign y49_imag = x35_imag;
    assign y50_real = x19_real; assign y50_imag = x19_imag;
    assign y51_real = x51_real; assign y51_imag = x51_imag;
    assign y52_real = x11_real; assign y52_imag = x11_imag;
    assign y53_real = x43_real; assign y53_imag = x43_imag;
    assign y54_real = x27_real; assign y54_imag = x27_imag;
    assign y55_real = x59_real; assign y55_imag = x59_imag;
    assign y56_real = x7_real; assign y56_imag = x7_imag;
    assign y57_real = x39_real; assign y57_imag = x39_imag;
    assign y58_real = x23_real; assign y58_imag = x23_imag;
    assign y59_real = x55_real; assign y59_imag = x55_imag;
    assign y60_real = x15_real; assign y60_imag = x15_imag;
    assign y61_real = x47_real; assign y61_imag = x47_imag;
    assign y62_real = x31_real; assign y62_imag = x31_imag;
    assign y63_real = x63_real; assign y63_imag = x63_imag;
endmodule