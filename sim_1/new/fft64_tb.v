`timescale 1ns/100ps
/**************** FFT Testbench (Streaming with Results Buffer) *****
 * This testbench verifies the streaming fft64_core. It streams in
 * a delta pulse input and captures the streamed output into arrays.
 *****************************************************************/
module fft64_tb;
    reg clk;
    reg rstn;
    
    // DUT Interface
    reg din_valid;
    reg signed [23:0] din_real;
    reg signed [23:0] din_imag;
    
    wire dout_valid;
    wire signed [23:0] dout_real;
    wire signed [23:0] dout_imag;

    // Stimulus arrays for the testbench
    reg signed [23:0] x_real [63:0];
    reg signed [23:0] x_imag [63:0];
    
    //Arrays to capture the streaming output
    reg signed [23:0] results_real [63:0];
    reg signed [23:0] results_imag [63:0];
    
    // Clock and Reset Generation
    initial begin
        clk = 0;
        rstn = 0;
        din_valid = 0;
        din_real = 0;
        din_imag = 0;
        #20 rstn = 1;
    end
    
    always #10 clk = ~clk; // 50 MHz Clock

    // Instantiate the 64-point FFT core
    fft64_core u_fft (
        .clk(clk), 
        .rstn(rstn), 
        .din_valid(din_valid), 
        .din_real(din_real), 
        .din_imag(din_imag),
        .dout_valid(dout_valid), 
        .dout_real(dout_real), 
        .dout_imag(dout_imag)
    );
    
    // Data Input Generation
    integer i;
    initial begin
        x_real[0] = 24'd1;
        for (i = 1; i < 64; i = i + 1) begin
            x_real[i] = 0;
        end
        for (i = 0; i < 64; i = i + 1) begin
            x_imag[i] = 0;
        end
        
        wait (rstn === 1);
        @(posedge clk);

        $display("Starting data input stream...");
        for (i = 0; i < 64; i = i + 1) begin
            din_valid <= 1;
            din_real  <= x_real[i];
            din_imag  <= x_imag[i];
            @(posedge clk);
        end
        din_valid <= 0;
        din_real <= 0;
        din_imag <= 0;
        $display("Finished data input stream.");
    end
    
    // Monitor and display output
    integer out_count;
    initial begin
        out_count = 0;
        // Initialize the results buffer to a known value (e.g., zero)
        for (i = 0; i < 64; i = i + 1) begin
            results_real[i] = 0;
            results_imag[i] = 0;
        end
    end
    
    always @(posedge clk) begin
        if (rstn == 1 && dout_valid) begin
            results_real[out_count] <= dout_real;
            results_imag[out_count] <= dout_imag;
            
            $display("Output[%0d]: Real = %d, Imag = %d", out_count, dout_real, dout_imag);
            out_count = out_count + 1;
        end
    end

    // Finish simulation
    initial #4000 $finish;
endmodule


////**************** FFT Testbench (Square Wave Input) ***************
//// * This testbench verifies the streaming fft64_core. It streams in
//// * a 64-point square wave (0, A, 0, A, ...) and captures the output.
//`timescale 1ns/100ps

//module fft64_tb;
//    reg clk;
//    reg rstn;
    
//    // DUT Interface
//    reg din_valid;
//    reg signed [23:0] din_real;
//    reg signed [23:0] din_imag;
    
//    wire dout_valid;
//    wire signed [23:0] dout_real;
//    wire signed [23:0] dout_imag;

//    // Stimulus arrays for the testbench
//    reg signed [23:0] x_real [63:0];
//    reg signed [23:0] x_imag [63:0];
    
//    // Arrays to capture the streaming output for easy viewing
//    reg signed [23:0] results_real [63:0];
//    reg signed [23:0] results_imag [63:0];
    
//    localparam AMPLITUDE = 1;

//    // Clock and Reset Generation
//    initial begin
//        clk = 0;
//        rstn = 0;
//        din_valid = 0;
//        din_real = 0;
//        din_imag = 0;
//        #20 rstn = 1;
//    end
    
//    always #10 clk = ~clk; // 50 MHz Clock

//    // Instantiate the 64-point FFT core
//    fft64_core u_fft (
//        .clk(clk), 
//        .rstn(rstn), 
//        .din_valid(din_valid), 
//        .din_real(din_real), 
//        .din_imag(din_imag),
//        .dout_valid(dout_valid), 
//        .dout_real(dout_real), 
//        .dout_imag(dout_imag)
//    );
    
//    // Data Initialization: 64-point square wave
//    // This block generates a signal that alternates between 0 and AMPLITUDE.
//    initial begin
//        for (integer i = 0; i < 64; i = i + 1) begin
//            if (i % 4 == 0) begin //frequency
//                x_real[i] = 0;
//            end else begin
//                x_real[i] = AMPLITUDE;
//            end
//            x_imag[i] = 0;
//        end
//    end

//    // Data Input Generation
//    integer i;
//    initial begin
//        wait (rstn === 1);
//        @(posedge clk);

//        $display("Starting square wave input stream...");
//        for (i = 0; i < 64; i = i + 1) begin
//            din_valid <= 1;
//            din_real  <= x_real[i];
//            din_imag  <= x_imag[i];
//            @(posedge clk);
//        end
//        din_valid <= 0;
//        din_real <= 0;
//        din_imag <= 0;
//        $display("Finished data input stream.");
//    end
    
//    // Monitor and display output
//    integer out_count;
//    initial begin
//        out_count = 0;
//        for (i = 0; i < 64; i = i + 1) begin
//            results_real[i] = 0;
//            results_imag[i] = 0;
//        end
//    end
    
//    always @(posedge clk) begin
//        if (rstn == 1 && dout_valid) begin
//            results_real[out_count] <= dout_real;
//            results_imag[out_count] <= dout_imag;
            
//            $display("Output[%0d]: Real = %d, Imag = %d", out_count, dout_real, dout_imag);
//            out_count = out_count + 1;
//        end
//    end

//    // Finish simulation
//    initial #4000 $finish;
//endmodule


//`timescale 1ns/100ps

//module fft64_tb;
//    reg clk;
//    reg rstn;
    
//    // DUT Interface
//    reg din_valid;
//    reg signed [23:0] din_real;
//    reg signed [23:0] din_imag;
    
//    wire dout_valid;
//    wire signed [23:0] dout_real;
//    wire signed [23:0] dout_imag;

//    // Stimulus arrays for the testbench
//    reg signed [23:0] x_real [63:0];
//    reg signed [23:0] x_imag [63:0];
    
//    // Arrays to capture the streaming output for easy viewing
//    reg signed [23:0] results_real [63:0];
//    reg signed [23:0] results_imag [63:0];
    
//    localparam AMPLITUDE = 1000000;

//    // Clock and Reset Generation
//    initial begin
//        clk = 0;
//        rstn = 0;
//        din_valid = 0;
//        din_real = 0;
//        din_imag = 0;
//        #20 rstn = 1;
//    end
    
//    always #10 clk = ~clk; // 50 MHz Clock

//    // Instantiate the 64-point FFT core
//    fft64_core u_fft (
//        .clk(clk), 
//        .rstn(rstn), 
//        .din_valid(din_valid), 
//        .din_real(din_real), 
//        .din_imag(din_imag),
//        .dout_valid(dout_valid), 
//        .dout_real(dout_real), 
//        .dout_imag(dout_imag)
//    );
    
//    // Data Initialization: 64-point square wave
//    // This block generates a signal that alternates between 0 and AMPLITUDE.
//    initial begin
//        x_real[0] = 24'sd0;
//        x_real[1] = 24'sd707107;
//        x_real[2] = 24'sd1000000;
//        x_real[3] = 24'sd707107;
//        x_real[4] = 24'sd0;
//        x_real[5] = -24'sd707107;
//        x_real[6] = -24'sd1000000;
//        x_real[7] = -24'sd707107;
//        x_real[8] = 24'sd0;
//        x_real[9] = 24'sd707107;
//        x_real[10] = 24'sd1000000;
//        x_real[11] = 24'sd707107;
//        x_real[12] = 24'sd0;
//        x_real[13] = -24'sd707107;
//        x_real[14] = -24'sd1000000;
//        x_real[15] = -24'sd707107;
//        x_real[16] = 24'sd0;
//        x_real[17] = 24'sd707107;
//        x_real[18] = 24'sd1000000;
//        x_real[19] = 24'sd707107;
//        x_real[20] = 24'sd0;
//        x_real[21] = -24'sd707107;
//        x_real[22] = -24'sd1000000;
//        x_real[23] = -24'sd707107;
//        x_real[24] = 24'sd0;
//        x_real[25] = 24'sd707107;
//        x_real[26] = 24'sd1000000;
//        x_real[27] = 24'sd707107;
//        x_real[28] = 24'sd0;
//        x_real[29] = -24'sd707107;
//        x_real[30] = -24'sd1000000;
//        x_real[31] = -24'sd707107;
//        x_real[32] = 24'sd0;
//        x_real[33] = 24'sd707107;
//        x_real[34] = 24'sd1000000;
//        x_real[35] = 24'sd707107;
//        x_real[36] = 24'sd0;
//        x_real[37] = -24'sd707107;
//        x_real[38] = -24'sd1000000;
//        x_real[39] = -24'sd707107;
//        x_real[40] = 24'sd0;
//        x_real[41] = 24'sd707107;
//        x_real[42] = 24'sd1000000;
//        x_real[43] = 24'sd707107;
//        x_real[44] = 24'sd0;
//        x_real[45] = -24'sd707107;
//        x_real[46] = -24'sd1000000;
//        x_real[47] = -24'sd707107;
//        x_real[48] = 24'sd0;
//        x_real[49] = 24'sd707107;
//        x_real[50] = 24'sd1000000;
//        x_real[51] = 24'sd707107;
//        x_real[52] = 24'sd0;
//        x_real[53] = -24'sd707107;
//        x_real[54] = -24'sd1000000;
//        x_real[55] = -24'sd707107;
//        x_real[56] = 24'sd0;
//        x_real[57] = 24'sd707107;
//        x_real[58] = 24'sd1000000;
//        x_real[59] = 24'sd707107;
//        x_real[60] = 24'sd0;
//        x_real[61] = -24'sd707107;
//        x_real[62] = -24'sd1000000;
//        x_real[63] = -24'sd707107;
//        x_imag[0] = 24'sd0;
//        x_imag[1] = 24'sd0;
//        x_imag[2] = 24'sd0;
//        x_imag[3] = 24'sd0;
//        x_imag[4] = 24'sd0;
//        x_imag[5] = 24'sd0;
//        x_imag[6] = 24'sd0;
//        x_imag[7] = 24'sd0;
//        x_imag[8] = 24'sd0;
//        x_imag[9] = 24'sd0;
//        x_imag[10] = 24'sd0;
//        x_imag[11] = 24'sd0;
//        x_imag[12] = 24'sd0;
//        x_imag[13] = 24'sd0;
//        x_imag[14] = 24'sd0;
//        x_imag[15] = 24'sd0;
//        x_imag[16] = 24'sd0;
//        x_imag[17] = 24'sd0;
//        x_imag[18] = 24'sd0;
//        x_imag[19] = 24'sd0;
//        x_imag[20] = 24'sd0;
//        x_imag[21] = 24'sd0;
//        x_imag[22] = 24'sd0;
//        x_imag[23] = 24'sd0;
//        x_imag[24] = 24'sd0;
//        x_imag[25] = 24'sd0;
//        x_imag[26] = 24'sd0;
//        x_imag[27] = 24'sd0;
//        x_imag[28] = 24'sd0;
//        x_imag[29] = 24'sd0;
//        x_imag[30] = 24'sd0;
//        x_imag[31] = 24'sd0;
//        x_imag[32] = 24'sd0;
//        x_imag[33] = 24'sd0;
//        x_imag[34] = 24'sd0;
//        x_imag[35] = 24'sd0;
//        x_imag[36] = 24'sd0;
//        x_imag[37] = 24'sd0;
//        x_imag[38] = 24'sd0;
//        x_imag[39] = 24'sd0;
//        x_imag[40] = 24'sd0;
//        x_imag[41] = 24'sd0;
//        x_imag[42] = 24'sd0;
//        x_imag[43] = 24'sd0;
//        x_imag[44] = 24'sd0;
//        x_imag[45] = 24'sd0;
//        x_imag[46] = 24'sd0;
//        x_imag[47] = 24'sd0;
//        x_imag[48] = 24'sd0;
//        x_imag[49] = 24'sd0;
//        x_imag[50] = 24'sd0;
//        x_imag[51] = 24'sd0;
//        x_imag[52] = 24'sd0;
//        x_imag[53] = 24'sd0;
//        x_imag[54] = 24'sd0;
//        x_imag[55] = 24'sd0;
//        x_imag[56] = 24'sd0;
//        x_imag[57] = 24'sd0;
//        x_imag[58] = 24'sd0;
//        x_imag[59] = 24'sd0;
//        x_imag[60] = 24'sd0;
//        x_imag[61] = 24'sd0;
//        x_imag[62] = 24'sd0;
//        x_imag[63] = 24'sd0;
//    end



//    // Data Input Generation
//    integer i;
//    initial begin
//        wait (rstn === 1);
//        @(posedge clk);

//        $display("Starting square wave input stream...");
//        for (i = 0; i < 64; i = i + 1) begin
//            din_valid <= 1;
//            din_real  <= x_real[i];
//            din_imag  <= x_imag[i];
//            @(posedge clk);
//        end
//        din_valid <= 0;
//        din_real <= 0;
//        din_imag <= 0;
//        $display("Finished data input stream.");
//    end
    
//    // Monitor and display output
//    integer out_count;
//    initial begin
//        out_count = 0;
//        for (i = 0; i < 64; i = i + 1) begin
//            results_real[i] = 0;
//            results_imag[i] = 0;
//        end
//    end
    
//    always @(posedge clk) begin
//        if (rstn == 1 && dout_valid) begin
//            results_real[out_count] <= dout_real;
//            results_imag[out_count] <= dout_imag;
            
//            $display("Output[%0d]: Real = %d, Imag = %d", out_count, dout_real, dout_imag);
//            out_count = out_count + 1;
//        end
//    end

//    // Finish simulation
//    initial #4000 $finish;
//endmodule

