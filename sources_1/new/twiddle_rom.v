
`timescale 1ns/100ps
/**************** Twiddle Factor ROM ******************
 * This module stores the 32 unique twiddle factors
 * for the 64-point FFT calculation.
 ******************************************************/
module twiddle_rom (
    input [4:0] addr,
    output reg signed [15:0] factor_real,
    output reg signed [15:0] factor_imag
);
    always @(*) begin
        case (addr)
            5'd0: {factor_real, factor_imag} = {16'h2000, 16'h0000};
            5'd1: {factor_real, factor_imag} = {16'h1ff6, 16'hfe0a};
            5'd2: {factor_real, factor_imag} = {16'h1fd8, 16'hfc14};
            5'd3: {factor_real, factor_imag} = {16'h1fa7, 16'hfa1e};
            5'd4: {factor_real, factor_imag} = {16'h1f62, 16'hf82a};
            5'd5: {factor_real, factor_imag} = {16'h1f0a, 16'hf638};
            5'd6: {factor_real, factor_imag} = {16'h1e9e, 16'hf448};
            5'd7: {factor_real, factor_imag} = {16'h1e20, 16'hf25a};
            5'd8: {factor_real, factor_imag} = {16'h1d8f, 16'hf06e};
            5'd9: {factor_real, factor_imag} = {16'h1ce9, 16'hee86};
            5'd10: {factor_real, factor_imag} = {16'h1c30, 16'heca1};
            5'd11: {factor_real, factor_imag} = {16'h1b66, 16'heac0};
            5'd12: {factor_real, factor_imag} = {16'h1a8c, 16'he8e3};
            5'd13: {factor_real, factor_imag} = {16'h19a1, 16'he70a};
            5'd14: {factor_real, factor_imag} = {16'h18a6, 16'he536};
            5'd15: {factor_real, factor_imag} = {16'h179b, 16'he368};
            5'd16: {factor_real, factor_imag} = {16'h1680, 16'he19e};
            5'd17: {factor_real, factor_imag} = {16'h1556, 16'hdfdc};
            5'd18: {factor_real, factor_imag} = {16'h141d, 16'hde20};
            5'd19: {factor_real, factor_imag} = {16'h12d6, 16'hdc6a};
            5'd20: {factor_real, factor_imag} = {16'h1182, 16'hdabe};
            5'd21: {factor_real, factor_imag} = {16'h1021, 16'hd91c};
            5'd22: {factor_real, factor_imag} = {16'h0eb5, 16'hd780};
            5'd23: {factor_real, factor_imag} = {16'h0d3d, 16'hd5ee};
            5'd24: {factor_real, factor_imag} = {16'h0bb8, 16'hd468};
            5'd25: {factor_real, factor_imag} = {16'h0a28, 16'hd2ec};
            5'd26: {factor_real, factor_imag} = {16'h088d, 16'hd17c};
            5'd27: {factor_real, factor_imag} = {16'h06e8, 16'hd018};
            5'd28: {factor_real, factor_imag} = {16'h053a, 16'hcebe};
            5'd29: {factor_real, factor_imag} = {16'h0384, 16'hcd70};
            5'd30: {factor_real, factor_imag} = {16'h01c5, 16'hcc2c};
            5'd31: {factor_real, factor_imag} = {16'h0000, 16'hcaf0};
            default: {factor_real, factor_imag} = {16'h0000, 16'h0000};
        endcase
    end
endmodule
