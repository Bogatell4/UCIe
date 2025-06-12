`timescale 1ns/1ps
`include "LTSM/SB_codex_pkg.vh"

module LTSM_tb;

    // Clocks and reset
    reg clk_100MHz = 0;
    reg clk_800MHz = 0;
    reg clk_2GHz = 0;
    reg reset = 1;
    reg enable_i = 1;
    reg start_LT_i = 0;

    // MB interconnect wires
    wire [1:0] MB_clkPins;
    wire MB_validPin;
    wire MB_trackPin;
    wire [15:0] MB_dataPins;
    wire MB_TX_validPin;
    wire MB_TX_trackPin;
    wire [1:0] MB_clkPins_o;
    wire [15:0] MB_dataPins_o;

    // SB interconnect wires
    wire SB_clkPin_TX_0, SB_dataPin_TX_0;
    wire SB_clkPin_TX_1, SB_dataPin_TX_1;

    // State monitoring
    wire LTSM_active_state_o_0, LTSM_active_state_o_1;

    // Instantiate LTSM_top 0 (acts as "left" device)
    LTSM_top dut0 (
        .clk_100MHz(clk_100MHz),
        .clk_800MHz(clk_800MHz),
        .clk_2GHz(clk_2GHz),
        .reset(reset),
        .enable_i(enable_i),
        .start_LT_i(start_LT_i),
        .LTSM_active_state_o(LTSM_active_state_o_0),

        // SB Pins
        .SB_clkPin_TX_o(SB_clkPin_TX_0),
        .SB_dataPin_TX_o(SB_dataPin_TX_0),
        .SB_clkPin_RX_i(SB_clkPin_TX_1),
        .SB_dataPin_RX_i(SB_dataPin_TX_1),

        // MB Pins
        .MB_clkPins_i(MB_clkPins),
        .MB_validPin_i(MB_validPin),
        .MB_trackPin_i(MB_trackPin),
        .MB_dataPins_i(MB_dataPins),
        .MB_TX_validPin_o(MB_TX_validPin),
        .MB_TX_trackPin_o(MB_TX_trackPin),
        .MB_clkPins_o(MB_clkPins_o),
        .MB_dataPins_o(MB_dataPins_o)
    );

    // Instantiate LTSM_top 1 (acts as "right" device)
    LTSM_top dut1 (
        .clk_100MHz(clk_100MHz),
        .clk_800MHz(clk_800MHz),
        .clk_2GHz(clk_2GHz),
        .reset(reset),
        .enable_i(enable_i),
        .start_LT_i(start_LT_i),
        .LTSM_active_state_o(LTSM_active_state_o_1),

        // SB Pins (cross-connected)
        .SB_clkPin_TX_o(SB_clkPin_TX_1),
        .SB_dataPin_TX_o(SB_dataPin_TX_1),
        .SB_clkPin_RX_i(SB_clkPin_TX_0),
        .SB_dataPin_RX_i(SB_dataPin_TX_0),

        // MB Pins (cross-connected)
        .MB_clkPins_i(MB_clkPins_o),
        .MB_validPin_i(MB_TX_validPin),
        .MB_trackPin_i(MB_TX_trackPin),
        .MB_dataPins_i(MB_dataPins_o),
        .MB_TX_validPin_o(MB_validPin),
        .MB_TX_trackPin_o(MB_trackPin),
        .MB_clkPins_o(MB_clkPins),
        .MB_dataPins_o(MB_dataPins)
    );

    // Clock generation
    always #5 clk_100MHz <= ~clk_100MHz;   // 100MHz
    always #0.625 clk_800MHz <= ~clk_800MHz; // 800MHz
    //always #0.25 clk_2GHz <= ~clk_2GHz;   // 2GHz Not used for now
    assign clk_2GHz = 0; // Disable 2GHz clock for now

    // Trace options and simulation finish
    initial begin
        $dumpfile("../LTSM_tb.vcd");
        $dumpvars(0, LTSM_tb);
        $display("Tracing enabled. Simulation will finish at 10ms.");
    end

    // Test sequence
    initial begin
        reset = 1;
        start_LT_i = 0;
        #100;
        reset = 0;
        #50;
        start_LT_i = 1;
        #10_000_000; // 10ms at 1ns resolution
        $display("Simulation finished at 10ms.");
        $finish;
    end

    // Monitor state changes and counters for both DUTs
    /*initial begin
        $display("Time\tDUT0_State\tDUT1_State\tDUT0_Active\tDUT1_Active");
        forever begin
            @(posedge clk_100MHz);
            $display("%0t\t%0d\t\t%0d\t\t%b\t\t%b",
                $time,
                dut0.LT_Current_state,
                dut1.LT_Current_state,
                LTSM_active_state_o_0,
                LTSM_active_state_o_1
            );
        end
    end*/

endmodule
