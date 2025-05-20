`timescale 1ps/1ps

module SB_TX_tb;

    parameter buffer_size = 4;

    reg clk;
    reg reset;
    reg [63:0] data_i;
    reg valid_i;
    reg enable_i;
    wire dataPin_o;
    wire clkPin_o;

    // Instantiate the SB_TX module
    SB_TX #(
        .buffer_size(buffer_size)
    ) uut (
        .clk(clk),
        .reset(reset),
        .data_i(data_i),
        .valid_i(valid_i),
        .enable_i(enable_i),
        .dataPin_o(dataPin_o),
        .clkPin_o(clkPin_o)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #625 clk = ~clk; // 800 MHz clock (period = 1250 ps)
    end

    // Test data: 3 ASCII words, each 8 bytes (64 bits)
    reg [63:0] words [0:2];
    initial begin
        // "UCIeTest"
        words[0] = {"t","s","e","T","e","I","C","U"};
        // "Verilog!"
        words[1] = {"!","g","o","l","i","r","e","V"};
        // "OpenAI42"
        words[2] = {"2","4","I","A","n","e","p","O"};
    end

    // Stimulus
    integer i;
    initial begin
        reset = 1;
        valid_i = 0;
        enable_i = 0;
        data_i = 64'd0;
        #2000; // Hold reset for 2 ns
        reset = 0;
        enable_i = 1;
        #1250; // Wait one clock cycle

        for (i = 0; i < 3; i = i + 1) begin
            @(negedge clk);
            data_i = words[i];
            valid_i = 1;
        end
        valid_i = 0; // Deassert valid signal after last word
        
        #20000;
        $finish;
    end

    // Optionally, monitor the serialized output
    initial begin
        $display("Time\tdataPin_o\tclkPin_o");
        forever begin
            @(posedge clk);
            $display("%0t\t%b\t\t%b", $time, dataPin_o, clkPin_o);
        end
    end

endmodule
