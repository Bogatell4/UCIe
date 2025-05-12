`timescale 1ps/1ps // Use picosecond precision for high-frequency clocks

module MB_RX_tb;

    // Parameters
    parameter flit_buffer_size = 4; // Number of flit buffers, must be a power of 2 and not 1

    // Clock and reset
    reg clk;
    reg reset;

    // Inputs to MB_RX
    reg valid_iPin;
    reg [1:0] periph_clkPins_i;
    reg [15:0] dataPins_i;

    // Outputs from MB_RX
    wire valid_o;
    wire [7:0] data_o [63:0];

    // Instantiate the MB_RX module
    MB_RX #(
        .flit_buffer_size(flit_buffer_size)
    ) uut (
        .clk(clk_100MHz),
        .reset(reset),
        .valid_iPin(valid_iPin),
        .periph_clkPins_i(periph_clkPins_i),
        .dataPins_i(dataPins_i),
        .valid_o(valid_o),
        .data_o(data_o)
    );

    // Clock generation for main clk (2 GHz, 500 ps period)
    initial begin
        clk = 0;
        forever #250 clk = ~clk; // 500 ps clock period (2 GHz)
    end

    // 100 MHz clock generation (10 ns period)
    reg clk_100MHz;

    initial begin
        clk_100MHz = 0;
        forever #5000 clk_100MHz = ~clk_100MHz; // Toggle every 5 ns (10 ns period)
    end

    // Peripheral clock generation
    initial begin
        periph_clkPins_i[0] = 0; // 90-degree phase delay (125 ps offset)
        #125;
        forever #250 periph_clkPins_i[0] = ~periph_clkPins_i[0]; // 500 ps clock period (2 GHz)
    end

    initial begin
        periph_clkPins_i[1] = 0; // 270-degree phase delay (375 ps offset)
        #375; 
        forever #250 periph_clkPins_i[1] = ~periph_clkPins_i[1]; // 500 ps clock period (2 GHz)
    end

    initial begin
        $dumpfile("../MB_RX_tb.vcd");
        $dumpvars(0, MB_RX_tb);
    end

    // Reset logic
    initial begin
        reset = 1;
        #1000 reset = 0;
    end

    // Test data: Single flit (64 bytes)
    reg [7:0] ascii_flit [0:2] [0:63]; // Single flit of 64 bytes

    initial begin
        // Flit 0
        ascii_flit[0][0]  = "H"; ascii_flit[0][1]  = "e"; ascii_flit[0][2]  = "l"; ascii_flit[0][3]  = "l";
        ascii_flit[0][4]  = "o"; ascii_flit[0][5]  = ","; ascii_flit[0][6]  = " "; ascii_flit[0][7]  = "W";
        ascii_flit[0][8]  = "o"; ascii_flit[0][9]  = "r"; ascii_flit[0][10] = "l"; ascii_flit[0][11] = "d";
        ascii_flit[0][12] = "!"; ascii_flit[0][13] = " "; ascii_flit[0][14] = "T"; ascii_flit[0][15] = "h";
        ascii_flit[0][16] = "i"; ascii_flit[0][17] = "s"; ascii_flit[0][18] = " "; ascii_flit[0][19] = "i";
        ascii_flit[0][20] = "s"; ascii_flit[0][21] = " "; ascii_flit[0][22] = "a"; ascii_flit[0][23] = " ";
        ascii_flit[0][24] = "t"; ascii_flit[0][25] = "e"; ascii_flit[0][26] = "s"; ascii_flit[0][27] = "t";
        ascii_flit[0][28] = "."; ascii_flit[0][29] = " "; ascii_flit[0][30] = "F"; ascii_flit[0][31] = "l";
        ascii_flit[0][32] = "i"; ascii_flit[0][33] = "t"; ascii_flit[0][34] = " "; ascii_flit[0][35] = "0";
        for (int i = 36; i < 64; i++) ascii_flit[0][i] = " "; // Fill remaining bytes with spaces

        // Flit 1
        ascii_flit[1][0]  = "T"; ascii_flit[1][1]  = "h"; ascii_flit[1][2]  = "i"; ascii_flit[1][3]  = "s";
        ascii_flit[1][4]  = " "; ascii_flit[1][5]  = "i"; ascii_flit[1][6]  = "s"; ascii_flit[1][7]  = " ";
        ascii_flit[1][8]  = "F"; ascii_flit[1][9]  = "l"; ascii_flit[1][10] = "i"; ascii_flit[1][11] = "t";
        ascii_flit[1][12] = " "; ascii_flit[1][13] = "1"; ascii_flit[1][14] = "."; ascii_flit[1][15] = " ";
        ascii_flit[1][16] = "I"; ascii_flit[1][17] = "t"; ascii_flit[1][18] = " "; ascii_flit[1][19] = "h";
        ascii_flit[1][20] = "a"; ascii_flit[1][21] = "s"; ascii_flit[1][22] = " "; ascii_flit[1][23] = "m";
        ascii_flit[1][24] = "o"; ascii_flit[1][25] = "r"; ascii_flit[1][26] = "e"; ascii_flit[1][27] = " ";
        ascii_flit[1][28] = "d"; ascii_flit[1][29] = "a"; ascii_flit[1][30] = "t"; ascii_flit[1][31] = "a";
        for (int i = 32; i < 64; i++) ascii_flit[1][i] = " "; // Fill remaining bytes with spaces

        // Flit 2
        ascii_flit[2][0]  = "F"; ascii_flit[2][1]  = "l"; ascii_flit[2][2]  = "i"; ascii_flit[2][3]  = "t";
        ascii_flit[2][4]  = " "; ascii_flit[2][5]  = "2"; ascii_flit[2][6]  = "."; ascii_flit[2][7]  = " ";
        ascii_flit[2][8]  = "T"; ascii_flit[2][9]  = "h"; ascii_flit[2][10] = "i"; ascii_flit[2][11] = "s";
        ascii_flit[2][12] = " "; ascii_flit[2][13] = "i"; ascii_flit[2][14] = "s"; ascii_flit[2][15] = " ";
        ascii_flit[2][16] = "t"; ascii_flit[2][17] = "h"; ascii_flit[2][18] = "e"; ascii_flit[2][19] = " ";
        ascii_flit[2][20] = "l"; ascii_flit[2][21] = "a"; ascii_flit[2][22] = "s"; ascii_flit[2][23] = "t";
        ascii_flit[2][24] = " "; ascii_flit[2][25] = "o"; ascii_flit[2][26] = "n"; ascii_flit[2][27] = "e";
        ascii_flit[2][28] = "."; ascii_flit[2][29] = " "; ascii_flit[2][30] = " "; ascii_flit[2][31] = " ";
        for (int i = 32; i < 64; i++) ascii_flit[2][i] = " "; // Fill remaining bytes with spaces
    end

    initial begin
        // Drive inputs
        valid_iPin = 0;
        dataPins_i = 16'h0000;

        #1500; // Wait for reset to deassert
        for (int flitNum = 0; flitNum <= 2; flitNum++) begin
            for (int k = 0; k < 64; k = k + 16) begin   //Send serialized data (2bytes at a time)
            @(posedge clk);
            valid_iPin = 1;
            dataPins_i = {  ascii_flit[flitNum][k+15][0], ascii_flit[flitNum][k+14][0], ascii_flit[flitNum][k+13][0], ascii_flit[flitNum][k+12][0],
                ascii_flit[flitNum][k+11][0], ascii_flit[flitNum][k+10][0], ascii_flit[flitNum][k+9][0], ascii_flit[flitNum][k+8][0],
                ascii_flit[flitNum][k+7][0], ascii_flit[flitNum][k+6][0], ascii_flit[flitNum][k+5][0], ascii_flit[flitNum][k+4][0],
                ascii_flit[flitNum][k+3][0], ascii_flit[flitNum][k+2][0], ascii_flit[flitNum][k+1][0], ascii_flit[flitNum][k][0]};
            @(negedge clk);
            dataPins_i = {  ascii_flit[flitNum][k+15][1], ascii_flit[flitNum][k+14][1], ascii_flit[flitNum][k+13][1], ascii_flit[flitNum][k+12][1],
                ascii_flit[flitNum][k+11][1], ascii_flit[flitNum][k+10][1], ascii_flit[flitNum][k+9][1], ascii_flit[flitNum][k+8][1],
                ascii_flit[flitNum][k+7][1], ascii_flit[flitNum][k+6][1], ascii_flit[flitNum][k+5][1], ascii_flit[flitNum][k+4][1],
                ascii_flit[flitNum][k+3][1], ascii_flit[flitNum][k+2][1], ascii_flit[flitNum][k+1][1], ascii_flit[flitNum][k][1]};
            @(posedge clk);
            dataPins_i = {  ascii_flit[flitNum][k+15][2], ascii_flit[flitNum][k+14][2], ascii_flit[flitNum][k+13][2], ascii_flit[flitNum][k+12][2],
                ascii_flit[flitNum][k+11][2], ascii_flit[flitNum][k+10][2], ascii_flit[flitNum][k+9][2], ascii_flit[flitNum][k+8][2],
                ascii_flit[flitNum][k+7][2], ascii_flit[flitNum][k+6][2], ascii_flit[flitNum][k+5][2], ascii_flit[flitNum][k+4][2],
                ascii_flit[flitNum][k+3][2], ascii_flit[flitNum][k+2][2], ascii_flit[flitNum][k+1][2], ascii_flit[flitNum][k][2]};
            @(negedge clk);
            dataPins_i = {  ascii_flit[flitNum][k+15][3], ascii_flit[flitNum][k+14][3], ascii_flit[flitNum][k+13][3], ascii_flit[flitNum][k+12][3],
                ascii_flit[flitNum][k+11][3], ascii_flit[flitNum][k+10][3], ascii_flit[flitNum][k+9][3], ascii_flit[flitNum][k+8][3],
                ascii_flit[flitNum][k+7][3], ascii_flit[flitNum][k+6][3], ascii_flit[flitNum][k+5][3], ascii_flit[flitNum][k+4][3],
                ascii_flit[flitNum][k+3][3], ascii_flit[flitNum][k+2][3], ascii_flit[flitNum][k+1][3], ascii_flit[flitNum][k][3]};
            @(posedge clk);
            valid_iPin = 0;
            dataPins_i = {  ascii_flit[flitNum][k+15][4], ascii_flit[flitNum][k+14][4], ascii_flit[flitNum][k+13][4], ascii_flit[flitNum][k+12][4],
                ascii_flit[flitNum][k+11][4], ascii_flit[flitNum][k+10][4], ascii_flit[flitNum][k+9][4], ascii_flit[flitNum][k+8][4],
                ascii_flit[flitNum][k+7][4], ascii_flit[flitNum][k+6][4], ascii_flit[flitNum][k+5][4], ascii_flit[flitNum][k+4][4],
                ascii_flit[flitNum][k+3][4], ascii_flit[flitNum][k+2][4], ascii_flit[flitNum][k+1][4], ascii_flit[flitNum][k][4]};
            @(negedge clk);
            dataPins_i = {  ascii_flit[flitNum][k+15][5], ascii_flit[flitNum][k+14][5], ascii_flit[flitNum][k+13][5], ascii_flit[flitNum][k+12][5],
                ascii_flit[flitNum][k+11][5], ascii_flit[flitNum][k+10][5], ascii_flit[flitNum][k+9][5], ascii_flit[flitNum][k+8][5],
                ascii_flit[flitNum][k+7][5], ascii_flit[flitNum][k+6][5], ascii_flit[flitNum][k+5][5], ascii_flit[flitNum][k+4][5],
                ascii_flit[flitNum][k+3][5], ascii_flit[flitNum][k+2][5], ascii_flit[flitNum][k+1][5], ascii_flit[flitNum][k][5]};
            @(posedge clk);
            dataPins_i = {  ascii_flit[flitNum][k+15][6], ascii_flit[flitNum][k+14][6], ascii_flit[flitNum][k+13][6], ascii_flit[flitNum][k+12][6],
                ascii_flit[flitNum][k+11][6], ascii_flit[flitNum][k+10][6], ascii_flit[flitNum][k+9][6], ascii_flit[flitNum][k+8][6],
                ascii_flit[flitNum][k+7][6], ascii_flit[flitNum][k+6][6], ascii_flit[flitNum][k+5][6], ascii_flit[flitNum][k+4][6],
                ascii_flit[flitNum][k+3][6], ascii_flit[flitNum][k+2][6], ascii_flit[flitNum][k+1][6], ascii_flit[flitNum][k][6]};
            @(negedge clk);
            dataPins_i = {  ascii_flit[flitNum][k+15][7], ascii_flit[flitNum][k+14][7], ascii_flit[flitNum][k+13][7], ascii_flit[flitNum][k+12][7],
                ascii_flit[flitNum][k+11][7], ascii_flit[flitNum][k+10][7], ascii_flit[flitNum][k+9][7], ascii_flit[flitNum][k+8][7],
                ascii_flit[flitNum][k+7][7], ascii_flit[flitNum][k+6][7], ascii_flit[flitNum][k+5][7], ascii_flit[flitNum][k+4][7],
                ascii_flit[flitNum][k+3][7], ascii_flit[flitNum][k+2][7], ascii_flit[flitNum][k+1][7], ascii_flit[flitNum][k][7]};
            end
        end

        #100000; // Wait for processing to complete

        // End simulation
        $finish;
    end

endmodule
