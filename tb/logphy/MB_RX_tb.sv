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
    reg [7:0] ascii_flit [0:63]; // Single flit of 64 bytes

    initial begin
        // Initialize ASCII flit
        ascii_flit[0]  = 8'b11111111; ascii_flit[1]  = "e"; ascii_flit[2]  = "l"; ascii_flit[3]  = "l";
        ascii_flit[4]  = "o"; ascii_flit[5]  = ","; ascii_flit[6]  = " "; ascii_flit[7]  = "W";
        ascii_flit[8]  = 8'b11111110; ascii_flit[9]  = "r"; ascii_flit[10] = "l"; ascii_flit[11] = "d";
        ascii_flit[12] = "!"; ascii_flit[13] = " "; ascii_flit[14] = "T"; ascii_flit[15] = "h";

        ascii_flit[16] = "i"; ascii_flit[17] = "s"; ascii_flit[18] = " "; ascii_flit[19] = "i";
        ascii_flit[20] = "s"; ascii_flit[21] = " "; ascii_flit[22] = "a"; ascii_flit[23] = " ";
        ascii_flit[24] = "t"; ascii_flit[25] = "e"; ascii_flit[26] = "s"; ascii_flit[27] = "t";
        ascii_flit[28] = "."; ascii_flit[29] = " "; ascii_flit[30] = "H"; ascii_flit[31] = "a";
        ascii_flit[32] = "v"; ascii_flit[33] = "e"; ascii_flit[34] = " "; ascii_flit[35] = "f";
        ascii_flit[36] = "u"; ascii_flit[37] = "n"; ascii_flit[38] = "!"; ascii_flit[39] = " ";
        ascii_flit[40] = "F"; ascii_flit[41] = "l"; ascii_flit[42] = "i"; ascii_flit[43] = "t";
        ascii_flit[44] = " "; ascii_flit[45] = "1"; ascii_flit[46] = "."; ascii_flit[47] = " ";
        for (int i = 48; i < 64; i++) ascii_flit[i] = " "; // Fill remaining bytes with spaces

        // Drive inputs
        valid_iPin = 0;
        dataPins_i = 16'h0000;

        #1500; // Wait for reset to deassert

        for (int k = 0; k < 64; k = k + 16) begin   //Send serialized data (2bytes at a time)
            @(posedge clk);
            valid_iPin = 1;
            dataPins_i = {  ascii_flit[k+15][0], ascii_flit[k+14][0], ascii_flit[k+13][0], ascii_flit[k+12][0],
                    ascii_flit[k+11][0], ascii_flit[k+10][0], ascii_flit[k+9][0], ascii_flit[k+8][0],
                    ascii_flit[k+7][0], ascii_flit[k+6][0], ascii_flit[k+5][0], ascii_flit[k+4][0],
                    ascii_flit[k+3][0], ascii_flit[k+2][0], ascii_flit[k+1][0], ascii_flit[k][0]};
            @(negedge clk);
            dataPins_i = {  ascii_flit[k+15][1], ascii_flit[k+14][1], ascii_flit[k+13][1], ascii_flit[k+12][1],
                    ascii_flit[k+11][1], ascii_flit[k+10][1], ascii_flit[k+9][1], ascii_flit[k+8][1],
                    ascii_flit[k+7][1], ascii_flit[k+6][1], ascii_flit[k+5][1], ascii_flit[k+4][1],
                    ascii_flit[k+3][1], ascii_flit[k+2][1], ascii_flit[k+1][1], ascii_flit[k][1]};
            @(posedge clk);
            dataPins_i = {  ascii_flit[k+15][2], ascii_flit[k+14][2], ascii_flit[k+13][2], ascii_flit[k+12][2],
                    ascii_flit[k+11][2], ascii_flit[k+10][2], ascii_flit[k+9][2], ascii_flit[k+8][2],
                    ascii_flit[k+7][2], ascii_flit[k+6][2], ascii_flit[k+5][2], ascii_flit[k+4][2],
                    ascii_flit[k+3][2], ascii_flit[k+2][2], ascii_flit[k+1][2], ascii_flit[k][2]};
            @(negedge clk);
            dataPins_i = {  ascii_flit[k+15][3], ascii_flit[k+14][3], ascii_flit[k+13][3], ascii_flit[k+12][3],
                    ascii_flit[k+11][3], ascii_flit[k+10][3], ascii_flit[k+9][3], ascii_flit[k+8][3],
                    ascii_flit[k+7][3], ascii_flit[k+6][3], ascii_flit[k+5][3], ascii_flit[k+4][3],
                    ascii_flit[k+3][3], ascii_flit[k+2][3], ascii_flit[k+1][3], ascii_flit[k][3]};
            @(posedge clk);
            valid_iPin = 0;
            dataPins_i = {  ascii_flit[k+15][4], ascii_flit[k+14][4], ascii_flit[k+13][4], ascii_flit[k+12][4],
                    ascii_flit[k+11][4], ascii_flit[k+10][4], ascii_flit[k+9][4], ascii_flit[k+8][4],
                    ascii_flit[k+7][4], ascii_flit[k+6][4], ascii_flit[k+5][4], ascii_flit[k+4][4],
                    ascii_flit[k+3][4], ascii_flit[k+2][4], ascii_flit[k+1][4], ascii_flit[k][4]};
            @(negedge clk);
            dataPins_i = {  ascii_flit[k+15][5], ascii_flit[k+14][5], ascii_flit[k+13][5], ascii_flit[k+12][5],
                    ascii_flit[k+11][5], ascii_flit[k+10][5], ascii_flit[k+9][5], ascii_flit[k+8][5],
                    ascii_flit[k+7][5], ascii_flit[k+6][5], ascii_flit[k+5][5], ascii_flit[k+4][5],
                    ascii_flit[k+3][5], ascii_flit[k+2][5], ascii_flit[k+1][5], ascii_flit[k][5]};
            @(posedge clk);
            dataPins_i = {  ascii_flit[k+15][6], ascii_flit[k+14][6], ascii_flit[k+13][6], ascii_flit[k+12][6],
                    ascii_flit[k+11][6], ascii_flit[k+10][6], ascii_flit[k+9][6], ascii_flit[k+8][6],
                    ascii_flit[k+7][6], ascii_flit[k+6][6], ascii_flit[k+5][6], ascii_flit[k+4][6],
                    ascii_flit[k+3][6], ascii_flit[k+2][6], ascii_flit[k+1][6], ascii_flit[k][6]};
            @(negedge clk);
            dataPins_i = {  ascii_flit[k+15][7], ascii_flit[k+14][7], ascii_flit[k+13][7], ascii_flit[k+12][7],
                    ascii_flit[k+11][7], ascii_flit[k+10][7], ascii_flit[k+9][7], ascii_flit[k+8][7],
                    ascii_flit[k+7][7], ascii_flit[k+6][7], ascii_flit[k+5][7], ascii_flit[k+4][7],
                    ascii_flit[k+3][7], ascii_flit[k+2][7], ascii_flit[k+1][7], ascii_flit[k][7]};
        end

        #10000; // Wait for processing to complete

        // End simulation
        $finish;
    end

endmodule
