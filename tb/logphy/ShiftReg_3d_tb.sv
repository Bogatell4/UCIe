`timescale 1ps/1ps

module ShiftReg_3d_tb;

    // Parameters
    parameter DATA_BIT_WIDTH = 8;

    // Testbench signals
    reg clk;
    reg reset;
    reg enable;
    reg [DATA_BIT_WIDTH-1:0] d_i;
    wire [DATA_BIT_WIDTH-1:0] q_o;
    wire enable_ack;
    wire valid_o;

    // Instantiate the ShiftReg_3d module
    ShiftReg_3d #(
        .DATA_BIT_WIDTH(DATA_BIT_WIDTH)
    ) uut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .enable_ack(enable_ack),
        .valid_o(valid_o),
        .d_i(d_i),
        .q_o(q_o)
    );

    initial begin
        $dumpfile("../ShiftReg_3d_tb.vcd");
        $dumpvars(0, ShiftReg_3d_tb);
    end

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Test sequence
    initial begin
        // Initialize signals
        reset = 1;
        enable = 0;
        d_i = 0;

        // Apply reset
        #20;
        reset = 0;

        // Test case 1: Shift data through the register
        #10;
        enable = 1;
        d_i = 8'b10101010; // Input data
        #10;
        enable = 0;

        // Wait for data to propagate through the shift register
        #30;

        // Test case 2: Shift new data
        enable = 1;
        d_i = 8'b01100110;
        #10;
        enable = 0;

        // Wait for data to propagate
        #30;

        // Test case 3: Reset the module
        reset = 1;
        #10;
        reset = 0;

        // End simulation
        #50;
        $finish;
    end

endmodule
