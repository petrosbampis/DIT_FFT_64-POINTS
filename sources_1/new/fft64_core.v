`timescale 1ns/100ps
/**************** 64-Point FFT Core (Streaming & Pipelined) ******
 * This module implements a 64-point FFT with a streaming interface
 * and a correctly pipelined core architecture.
 ******************************************************************/
module fft64_core (
    input clk,
    input rstn,

    // Streaming Input Interface
    input                   din_valid,
    input signed [23:0]     din_real,
    input signed [23:0]     din_imag,

    // Streaming Output Interface
    output                  dout_valid,
    output signed [23:0]    dout_real,
    output signed [23:0]    dout_imag
);

    //================================================================
    // Input Buffering and Control
    //================================================================
    reg [5:0] din_cnt;
    reg signed [23:0] input_buffer_real [63:0];
    reg signed [23:0] input_buffer_imag [63:0];
    reg start_pulse; // Single-cycle pulse to start the FFT pipeline

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            din_cnt <= 0;
            start_pulse <= 0;
        end else begin
            start_pulse <= 0; // Pulse is high for one cycle only
            if (din_valid) begin
                input_buffer_real[din_cnt] <= din_real;
                input_buffer_imag[din_cnt] <= din_imag;
                if (din_cnt == 6'd63) begin
                    din_cnt <= 0;
                    start_pulse <= 1; // Buffer is full, start the FFT
                end else begin
                    din_cnt <= din_cnt + 1;
                end
            end
        end
    end

    //================================================================
    // Internal FFT Pipeline
    //================================================================
    
    // Pipeline stage data arrays are now wires connecting the stages.
    // The registers are inside the butterfly units.
    wire signed [23:0] stage_data_real [6:0][63:0];
    wire signed [23:0] stage_data_imag [6:0][63:0];

    // Stage 0: Bit Reversal (combinational)
    bit_reverser br_inst (
        .x0_real(input_buffer_real[0]), .x0_imag(input_buffer_imag[0]), .x1_real(input_buffer_real[1]), .x1_imag(input_buffer_imag[1]), 
        .x2_real(input_buffer_real[2]), .x2_imag(input_buffer_imag[2]), .x3_real(input_buffer_real[3]), .x3_imag(input_buffer_imag[3]), 
        .x4_real(input_buffer_real[4]), .x4_imag(input_buffer_imag[4]), .x5_real(input_buffer_real[5]), .x5_imag(input_buffer_imag[5]), 
        .x6_real(input_buffer_real[6]), .x6_imag(input_buffer_imag[6]), .x7_real(input_buffer_real[7]), .x7_imag(input_buffer_imag[7]), 
        .x8_real(input_buffer_real[8]), .x8_imag(input_buffer_imag[8]), .x9_real(input_buffer_real[9]), .x9_imag(input_buffer_imag[9]), 
        .x10_real(input_buffer_real[10]), .x10_imag(input_buffer_imag[10]), .x11_real(input_buffer_real[11]), .x11_imag(input_buffer_imag[11]), 
        .x12_real(input_buffer_real[12]), .x12_imag(input_buffer_imag[12]), .x13_real(input_buffer_real[13]), .x13_imag(input_buffer_imag[13]), 
        .x14_real(input_buffer_real[14]), .x14_imag(input_buffer_imag[14]), .x15_real(input_buffer_real[15]), .x15_imag(input_buffer_imag[15]), 
        .x16_real(input_buffer_real[16]), .x16_imag(input_buffer_imag[16]), .x17_real(input_buffer_real[17]), .x17_imag(input_buffer_imag[17]), 
        .x18_real(input_buffer_real[18]), .x18_imag(input_buffer_imag[18]), .x19_real(input_buffer_real[19]), .x19_imag(input_buffer_imag[19]), 
        .x20_real(input_buffer_real[20]), .x20_imag(input_buffer_imag[20]), .x21_real(input_buffer_real[21]), .x21_imag(input_buffer_imag[21]), 
        .x22_real(input_buffer_real[22]), .x22_imag(input_buffer_imag[22]), .x23_real(input_buffer_real[23]), .x23_imag(input_buffer_imag[23]), 
        .x24_real(input_buffer_real[24]), .x24_imag(input_buffer_imag[24]), .x25_real(input_buffer_real[25]), .x25_imag(input_buffer_imag[25]), 
        .x26_real(input_buffer_real[26]), .x26_imag(input_buffer_imag[26]), .x27_real(input_buffer_real[27]), .x27_imag(input_buffer_imag[27]), 
        .x28_real(input_buffer_real[28]), .x28_imag(input_buffer_imag[28]), .x29_real(input_buffer_real[29]), .x29_imag(input_buffer_imag[29]), 
        .x30_real(input_buffer_real[30]), .x30_imag(input_buffer_imag[30]), .x31_real(input_buffer_real[31]), .x31_imag(input_buffer_imag[31]), 
        .x32_real(input_buffer_real[32]), .x32_imag(input_buffer_imag[32]), .x33_real(input_buffer_real[33]), .x33_imag(input_buffer_imag[33]), 
        .x34_real(input_buffer_real[34]), .x34_imag(input_buffer_imag[34]), .x35_real(input_buffer_real[35]), .x35_imag(input_buffer_imag[35]), 
        .x36_real(input_buffer_real[36]), .x36_imag(input_buffer_imag[36]), .x37_real(input_buffer_real[37]), .x37_imag(input_buffer_imag[37]), 
        .x38_real(input_buffer_real[38]), .x38_imag(input_buffer_imag[38]), .x39_real(input_buffer_real[39]), .x39_imag(input_buffer_imag[39]), 
        .x40_real(input_buffer_real[40]), .x40_imag(input_buffer_imag[40]), .x41_real(input_buffer_real[41]), .x41_imag(input_buffer_imag[41]), 
        .x42_real(input_buffer_real[42]), .x42_imag(input_buffer_imag[42]), .x43_real(input_buffer_real[43]), .x43_imag(input_buffer_imag[43]), 
        .x44_real(input_buffer_real[44]), .x44_imag(input_buffer_imag[44]), .x45_real(input_buffer_real[45]), .x45_imag(input_buffer_imag[45]), 
        .x46_real(input_buffer_real[46]), .x46_imag(input_buffer_imag[46]), .x47_real(input_buffer_real[47]), .x47_imag(input_buffer_imag[47]), 
        .x48_real(input_buffer_real[48]), .x48_imag(input_buffer_imag[48]), .x49_real(input_buffer_real[49]), .x49_imag(input_buffer_imag[49]), 
        .x50_real(input_buffer_real[50]), .x50_imag(input_buffer_imag[50]), .x51_real(input_buffer_real[51]), .x51_imag(input_buffer_imag[51]), 
        .x52_real(input_buffer_real[52]), .x52_imag(input_buffer_imag[52]), .x53_real(input_buffer_real[53]), .x53_imag(input_buffer_imag[53]), 
        .x54_real(input_buffer_real[54]), .x54_imag(input_buffer_imag[54]), .x55_real(input_buffer_real[55]), .x55_imag(input_buffer_imag[55]), 
        .x56_real(input_buffer_real[56]), .x56_imag(input_buffer_imag[56]), .x57_real(input_buffer_real[57]), .x57_imag(input_buffer_imag[57]), 
        .x58_real(input_buffer_real[58]), .x58_imag(input_buffer_imag[58]), .x59_real(input_buffer_real[59]), .x59_imag(input_buffer_imag[59]), 
        .x60_real(input_buffer_real[60]), .x60_imag(input_buffer_imag[60]), .x61_real(input_buffer_real[61]), .x61_imag(input_buffer_imag[61]), 
        .x62_real(input_buffer_real[62]), .x62_imag(input_buffer_imag[62]), .x63_real(input_buffer_real[63]), .x63_imag(input_buffer_imag[63]),
        
        .y0_real(stage_data_real[0][0]), .y0_imag(stage_data_imag[0][0]), .y1_real(stage_data_real[0][1]), .y1_imag(stage_data_imag[0][1]),
        .y2_real(stage_data_real[0][2]), .y2_imag(stage_data_imag[0][2]), .y3_real(stage_data_real[0][3]), .y3_imag(stage_data_imag[0][3]),
        .y4_real(stage_data_real[0][4]), .y4_imag(stage_data_imag[0][4]), .y5_real(stage_data_real[0][5]), .y5_imag(stage_data_imag[0][5]),
        .y6_real(stage_data_real[0][6]), .y6_imag(stage_data_imag[0][6]), .y7_real(stage_data_real[0][7]), .y7_imag(stage_data_imag[0][7]),
        .y8_real(stage_data_real[0][8]), .y8_imag(stage_data_imag[0][8]), .y9_real(stage_data_real[0][9]), .y9_imag(stage_data_imag[0][9]),
        .y10_real(stage_data_real[0][10]), .y10_imag(stage_data_imag[0][10]), .y11_real(stage_data_real[0][11]), .y11_imag(stage_data_imag[0][11]),
        .y12_real(stage_data_real[0][12]), .y12_imag(stage_data_imag[0][12]), .y13_real(stage_data_real[0][13]), .y13_imag(stage_data_imag[0][13]),
        .y14_real(stage_data_real[0][14]), .y14_imag(stage_data_imag[0][14]), .y15_real(stage_data_real[0][15]), .y15_imag(stage_data_imag[0][15]),
        .y16_real(stage_data_real[0][16]), .y16_imag(stage_data_imag[0][16]), .y17_real(stage_data_real[0][17]), .y17_imag(stage_data_imag[0][17]),
        .y18_real(stage_data_real[0][18]), .y18_imag(stage_data_imag[0][18]), .y19_real(stage_data_real[0][19]), .y19_imag(stage_data_imag[0][19]),
        .y20_real(stage_data_real[0][20]), .y20_imag(stage_data_imag[0][20]), .y21_real(stage_data_real[0][21]), .y21_imag(stage_data_imag[0][21]),
        .y22_real(stage_data_real[0][22]), .y22_imag(stage_data_imag[0][22]), .y23_real(stage_data_real[0][23]), .y23_imag(stage_data_imag[0][23]),
        .y24_real(stage_data_real[0][24]), .y24_imag(stage_data_imag[0][24]), .y25_real(stage_data_real[0][25]), .y25_imag(stage_data_imag[0][25]),
        .y26_real(stage_data_real[0][26]), .y26_imag(stage_data_imag[0][26]), .y27_real(stage_data_real[0][27]), .y27_imag(stage_data_imag[0][27]),
        .y28_real(stage_data_real[0][28]), .y28_imag(stage_data_imag[0][28]), .y29_real(stage_data_real[0][29]), .y29_imag(stage_data_imag[0][29]),
        .y30_real(stage_data_real[0][30]), .y30_imag(stage_data_imag[0][30]), .y31_real(stage_data_real[0][31]), .y31_imag(stage_data_imag[0][31]),
        .y32_real(stage_data_real[0][32]), .y32_imag(stage_data_imag[0][32]), .y33_real(stage_data_real[0][33]), .y33_imag(stage_data_imag[0][33]),
        .y34_real(stage_data_real[0][34]), .y34_imag(stage_data_imag[0][34]), .y35_real(stage_data_real[0][35]), .y35_imag(stage_data_imag[0][35]),
        .y36_real(stage_data_real[0][36]), .y36_imag(stage_data_imag[0][36]), .y37_real(stage_data_real[0][37]), .y37_imag(stage_data_imag[0][37]),
        .y38_real(stage_data_real[0][38]), .y38_imag(stage_data_imag[0][38]), .y39_real(stage_data_real[0][39]), .y39_imag(stage_data_imag[0][39]),
        .y40_real(stage_data_real[0][40]), .y40_imag(stage_data_imag[0][40]), .y41_real(stage_data_real[0][41]), .y41_imag(stage_data_imag[0][41]),
        .y42_real(stage_data_real[0][42]), .y42_imag(stage_data_imag[0][42]), .y43_real(stage_data_real[0][43]), .y43_imag(stage_data_imag[0][43]),
        .y44_real(stage_data_real[0][44]), .y44_imag(stage_data_imag[0][44]), .y45_real(stage_data_real[0][45]), .y45_imag(stage_data_imag[0][45]),
        .y46_real(stage_data_real[0][46]), .y46_imag(stage_data_imag[0][46]), .y47_real(stage_data_real[0][47]), .y47_imag(stage_data_imag[0][47]),
        .y48_real(stage_data_real[0][48]), .y48_imag(stage_data_imag[0][48]), .y49_real(stage_data_real[0][49]), .y49_imag(stage_data_imag[0][49]),
        .y50_real(stage_data_real[0][50]), .y50_imag(stage_data_imag[0][50]), .y51_real(stage_data_real[0][51]), .y51_imag(stage_data_imag[0][51]),
        .y52_real(stage_data_real[0][52]), .y52_imag(stage_data_imag[0][52]), .y53_real(stage_data_real[0][53]), .y53_imag(stage_data_imag[0][53]),
        .y54_real(stage_data_real[0][54]), .y54_imag(stage_data_imag[0][54]), .y55_real(stage_data_real[0][55]), .y55_imag(stage_data_imag[0][55]),
        .y56_real(stage_data_real[0][56]), .y56_imag(stage_data_imag[0][56]), .y57_real(stage_data_real[0][57]), .y57_imag(stage_data_imag[0][57]),
        .y58_real(stage_data_real[0][58]), .y58_imag(stage_data_imag[0][58]), .y59_real(stage_data_real[0][59]), .y59_imag(stage_data_imag[0][59]),
        .y60_real(stage_data_real[0][60]), .y60_imag(stage_data_imag[0][60]), .y61_real(stage_data_real[0][61]), .y61_imag(stage_data_imag[0][61]),
        .y62_real(stage_data_real[0][62]), .y62_imag(stage_data_imag[0][62]), .y63_real(stage_data_real[0][63]), .y63_imag(stage_data_imag[0][63])
    );
    
    // Create a shift register to delay the enable signal for each stage
    reg [17:0] en_shifter;
    always @(posedge clk or negedge rstn) begin
        if (!rstn)
            en_shifter <= 0;
        else
            en_shifter <= {en_shifter[16:0], start_pulse};
    end

    // Butterfly Instantiation Pipeline
    genvar m, k;
    generate
        for (m = 0; m <= 5; m = m + 1) begin: stage
            for (k = 0; k <= 31; k = k + 1) begin: unit
                // --- Δεικτοδότηση ---
                localparam BUTTERFLIES_PER_GROUP = 1 << m;
                localparam GROUP_SIZE            = 1 << (m + 1);
                localparam GROUP_INDEX           = k / BUTTERFLIES_PER_GROUP;
                localparam PAIR_INDEX            = k % BUTTERFLIES_PER_GROUP;
                
                localparam P_INDEX = GROUP_INDEX * GROUP_SIZE + PAIR_INDEX;
                localparam Q_INDEX = P_INDEX + BUTTERFLIES_PER_GROUP;
                
                wire signed [15:0] factor_r, factor_i;
                wire [4:0] rom_addr = (PAIR_INDEX * (32 >> m));
    
                twiddle_rom rom_inst (
                    .addr(rom_addr),
                    .factor_real(factor_r),
                    .factor_imag(factor_i)
                );
    
                butterfly butter_inst (
                    .clk(clk),
                    .rstn(rstn),
                    .en(en_shifter[m*3]), 
                    
                    .xp_real(stage_data_real[m][P_INDEX]),
                    .xp_imag(stage_data_imag[m][P_INDEX]),
                    .xq_real(stage_data_real[m][Q_INDEX]),
                    .xq_imag(stage_data_imag[m][Q_INDEX]),
                    
                    .factor_real(factor_r),
                    .factor_imag(factor_i),
                    
                    .valid(), 
                    .yp_real(stage_data_real[m + 1][P_INDEX]),
                    .yp_imag(stage_data_imag[m + 1][P_INDEX]),
                    .yq_real(stage_data_real[m + 1][Q_INDEX]),
                    .yq_imag(stage_data_imag[m + 1][Q_INDEX])
                );
            end
        end
    endgenerate
    
    
    
    //================================================================
    // Output Control and Streaming
    //================================================================
    // The final result is ready after the last stage's latency.
    // Latency = 18 cycles total (6 stages * 3 cycles/stage)
    // The en_shifter already tracks this latency.
    wire core_valid = en_shifter[17];

    // Output streaming logic
    reg [5:0] dout_cnt;
    reg streaming_out;
    reg signed [23:0] dout_real_reg;
    reg signed [23:0] dout_imag_reg;
    reg dout_valid_reg;
    
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            streaming_out <= 0;
            dout_cnt <= 0;
            dout_valid_reg <= 0;
        end else begin
            if (core_valid) begin
                streaming_out <= 1;
                dout_cnt <= 0;
            end
            
            if (streaming_out) begin
                dout_valid_reg <= 1;
                dout_real_reg <= stage_data_real[6][dout_cnt];
                dout_imag_reg <= stage_data_imag[6][dout_cnt];
                
                if (dout_cnt == 6'd63) begin
                    dout_cnt <= 0;
                    streaming_out <= 0;
                end else begin
                    dout_cnt <= dout_cnt + 1;
                end
            end else begin
                dout_valid_reg <= 0;
            end
        end
    end

    assign dout_real = dout_real_reg;
    assign dout_imag = dout_imag_reg;
    assign dout_valid = dout_valid_reg;

endmodule



