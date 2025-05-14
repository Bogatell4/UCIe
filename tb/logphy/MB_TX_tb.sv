`timescale 1ps/1ps

module MB_TX_tb;

    // Parameters
    parameter flit_buffer_size = 4; // Number of flit buffers, must be a power of 2 and not 1

    // Clocks and reset
    reg clk;
    reg clk_100MHz;
    reg reset;

    // MB_TX inputs
    reg valid_i;
    reg [7:0] data_i [63:0];
    reg [1:0] periph_clk_i;


    // MB_TX outputs
    wire [1:0] periph_clkPins_o;
    wire valid_pin_o;
    wire [15:0] dataPins_o;
    wire transmiting;

    // Instantiate MB_TX
    MB_TX #(
        .flit_buffer_size(flit_buffer_size)
    ) uut (
        .clk(clk),
        .clk_100MHz(clk_100MHz),
        .reset(reset),
        .valid_i(valid_i),
        .data_i(data_i),
        .periph_clk_i(periph_clk_i),
        .periph_clkPins_o(periph_clkPins_o),
        .valid_pin_o(valid_pin_o),
        .dataPins_o(dataPins_o),
        .transmiting_o(transmiting)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #250 clk = ~clk; // 2 GHz
    end

    initial begin
        clk_100MHz = 0;
        forever #5000 clk_100MHz = ~clk_100MHz; // 100 MHz
    end

    // Peripheral clock generation (phase shifted)
    initial begin
        periph_clk_i[0] = 0;
        #125;
        forever #250 periph_clk_i[0] = ~periph_clk_i[0];
    end

    initial begin
        periph_clk_i[1] = 0;
        #375;
        forever #250 periph_clk_i[1] = ~periph_clk_i[1];
    end

    // Test data: 3 flits, each 64 bytes
    reg [7:0] ascii_flit [0:2][0:63];

    initial begin
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

    // Stimulus: Send each flit to MB_TX
    initial begin
        valid_i = 0;
        data_i = '{default:0};
        reset = 1;
        #1000 reset = 0;

        for (int flitNum = 0; flitNum < 3; flitNum++) begin
            @(posedge clk_100MHz);
            valid_i = 1;
            for (int i = 0; i < 64; i++) begin
                data_i[i] = ascii_flit[flitNum][i];
            end
            wait(transmiting==0);
            valid_i = 0;
        end

        #10000;
        $finish;
    end

    // Optionally, monitor outputs
    always @(posedge clk) begin
        if (valid_pin_o) begin
            $display("Time %0t: TX output dataPins_o = %h", $time, dataPins_o);
        end
    end

endmodule
