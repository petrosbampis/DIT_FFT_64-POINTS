`timescale 1ns/100ps
/**************** butter unit *************************
 * This module performs the core butterfly calculation
 * for a radix-2 FFT.
 * Yp = Xp + W*Xq
 * Yq = Xp - W*Xq
 ******************************************************/
module butterfly (
    input clk,
    input rstn,
    input en,
    input signed [23:0] xp_real, // Xm(p)
    input signed [23:0] xp_imag,
    input signed [23:0] xq_real, // Xm(q)
    input signed [23:0] xq_imag,
    input signed [15:0] factor_real, // Wnr
    input signed [15:0] factor_imag,

    output valid,
    output signed [23:0] yp_real, //Xm+1(p)
    output signed [23:0] yp_imag,
    output signed [23:0] yq_real, //Xm+1(q)
    output signed [23:0] yq_imag
);

    reg [2:0] en_r; // 3-cycle pipeline
    always @(posedge clk or negedge rstn) begin
        if (!rstn)
            en_r <= 'b0;
        else
            en_r <= {en_r[1:0], en};
    end

    // Stage 1: Complex Multiplication (Xq * W) and delay for Xp
    reg signed [39:0] xq_wnr_real0, xq_wnr_real1;
    reg signed [39:0] xq_wnr_imag0, xq_wnr_imag1;
    reg signed [39:0] xp_real_d, xp_imag_d;

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            xp_real_d <= 'b0;
            xp_imag_d <= 'b0;
            xq_wnr_real0 <= 'b0;
            xq_wnr_real1 <= 'b0;
            xq_wnr_imag0 <= 'b0;
            xq_wnr_imag1 <= 'b0;
        end else if (en) begin
            xq_wnr_real0 <= xq_real * factor_real;
            xq_wnr_real1 <= xq_imag * factor_imag;
            xq_wnr_imag0 <= xq_real * factor_imag;
            xq_wnr_imag1 <= xq_imag * factor_real;
            // Scale Xp by 8192 (2^13) to match the twiddle factor scaling
            xp_real_d <= {xp_real, 13'b0};
            xp_imag_d <= {xp_imag, 13'b0};
        end
    end

    // Stage 2: Complete the complex multiplication
    reg signed [39:0] xp_real_d1, xp_imag_d1;
    reg signed [39:0] xq_wnr_real, xq_wnr_imag;

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            xp_real_d1 <= 'b0;
            xp_imag_d1 <= 'b0;
            xq_wnr_real <= 'b0;
            xq_wnr_imag <= 'b0;
        end else if (en_r[0]) begin
            xp_real_d1 <= xp_real_d;
            xp_imag_d1 <= xp_imag_d;
            xq_wnr_real <= xq_wnr_real0 - xq_wnr_real1; // (ac - bd)
            xq_wnr_imag <= xq_wnr_imag0 + xq_wnr_imag1; // (ad + bc)
        end
    end

    // Stage 3: Final Addition/Subtraction
    reg signed [39:0] yp_real_r, yp_imag_r;
    reg signed [39:0] yq_real_r, yq_imag_r;

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            yp_real_r <= 'b0;
            yp_imag_r <= 'b0;
            yq_real_r <= 'b0;
            yq_imag_r <= 'b0;
        end else if (en_r[1]) begin
            yp_real_r <= xp_real_d1 + xq_wnr_real;
            yp_imag_r <= xp_imag_d1 + xq_wnr_imag;
            yq_real_r <= xp_real_d1 - xq_wnr_real;
            yq_imag_r <= xp_imag_d1 - xq_wnr_imag;
        end
    end

    // Discard the lower 13 bits to remove scaling factor
    assign yp_real = yp_real_r[36:13];
    assign yp_imag = yp_imag_r[36:13];
    assign yq_real = yq_real_r[36:13];
    assign yq_imag = yq_imag_r[36:13];
    assign valid = en_r[2];
endmodule

