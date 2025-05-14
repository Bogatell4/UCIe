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

    reg [7:0] ascii_flit [0:2][0:63];

    initial begin // Initialize the ascii_flit array
        string flit_str [0:2];
        flit_str[0] = "Hello, World! This is a test. Flit 0";
        flit_str[1] = "This is Flit 1. I love UCIe!";
        flit_str[2] = "Flit 2. This is the last one.";

        // Fill ascii_flit arrays with string contents, pad with spaces
        for (int f = 0; f < 3; f++) begin
            for (int i = 0; i < 64; i++) begin
                if (i < flit_str[f].len())
                    ascii_flit[f][i] = flit_str[f].getc(i);
                else
                    ascii_flit[f][i] = " ";
            end
        end
    end

    // Check for valid output and compare with expected data flit
    integer check_flit = 0;
    always @(posedge clk_100MHz) begin
        if (valid_o) begin
            // Compare all 64 bytes of the current flit
            for (int i = 0; i < 64; i++) begin
                if (data_o[i] !== ascii_flit[check_flit][i]) begin
                    $error("Time %0t: Mismatch at flit %0d, byte %0d: expected %h, got %h", $time, check_flit, i, ascii_flit[check_flit][i], data_o[i]);
                end
            end
            $display("Flit %0d recieved ok, match.", check_flit);
            check_flit <= check_flit + 1;
        end
    end

    initial begin
        // Drive inputs
        valid_iPin = 0;
        dataPins_i = 16'h0000;

        #1500; // Wait for reset to deassert
        for (int flitNum = 0; flitNum <= 2; flitNum++) begin 
            for (int k = 0; k < 64; k = k + 16) begin   //Send serialized data (2bytes at a time) for each flit
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
