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

    // State monitoring for state change display
    logic [2:0] prev_state_dut0, prev_state_dut1;

    // Flags to track if each DUT has ever entered ACTIVE (state 101)
    logic dut0_ACTIVE_reached, dut1_ACTIVE_reached;

    always @(posedge clk_100MHz or posedge reset) begin
        if (reset) begin
            dut0_ACTIVE_reached <= 1'b0;
            dut1_ACTIVE_reached <= 1'b0;
        end else begin
            if (dut0.LT_Current_state == 3'b101)
                dut0_ACTIVE_reached <= 1'b1;
            if (dut1.LT_Current_state == 3'b101)
                dut1_ACTIVE_reached <= 1'b1;
        end
    end

    // Display state changes for both DUTs
    always @(posedge clk_100MHz) begin
        if (reset) begin
            prev_state_dut0 <= 3'bxxx;
            prev_state_dut1 <= 3'bxxx;
        end else begin
            if (dut0.LT_Current_state !== prev_state_dut0) begin
                $display("dut0 entered state [%s] at %0t", 
                    (dut0.LT_Current_state == 3'b000) ? "RESET"  :
                    (dut0.LT_Current_state == 3'b001) ? "SBINIT" :
                    (dut0.LT_Current_state == 3'b010) ? "MBINIT" :
                    (dut0.LT_Current_state == 3'b011) ? "MBTRAIN":
                    (dut0.LT_Current_state == 3'b100) ? "LINKINIT":
                    (dut0.LT_Current_state == 3'b101) ? "ACTIVE" :
                    (dut0.LT_Current_state == 3'b110) ? "TRAINERROR" : "UNKNOWN",
                    $time);
                prev_state_dut0 <= dut0.LT_Current_state;
            end
            if (dut1.LT_Current_state !== prev_state_dut1) begin
                $display("dut1 entered state [%s] at %0t", 
                    (dut1.LT_Current_state == 3'b000) ? "RESET"  :
                    (dut1.LT_Current_state == 3'b001) ? "SBINIT" :
                    (dut1.LT_Current_state == 3'b010) ? "MBINIT" :
                    (dut1.LT_Current_state == 3'b011) ? "MBTRAIN":
                    (dut1.LT_Current_state == 3'b100) ? "LINKINIT":
                    (dut1.LT_Current_state == 3'b101) ? "ACTIVE" :
                    (dut1.LT_Current_state == 3'b110) ? "TRAINERROR" : "UNKNOWN",
                    $time);
                prev_state_dut1 <= dut1.LT_Current_state;
            end
        end
    end

    // Test sequence
    initial begin
        reset = 1;
        start_LT_i = 0;
        #100;
        reset = 0;
        #50;
        start_LT_i = 1;
        #20_000; // 20us at 1ns resolution

        // Check if both DUTs ever reached state 101 (ACTIVE)
        if (dut0_ACTIVE_reached && dut1_ACTIVE_reached) begin
            $display("TEST SUCCESSFUL: Both DUTs entered state ACTIVE (101) at some point during simulation.");
        end else begin
            $error("TEST FAILED: Both DUTs did not enter state ACTIVE (101). dut0_ACTIVE_reached=%0b, dut1_ACTIVE_reached=%0b", dut0_ACTIVE_reached, dut1_ACTIVE_reached);
        end

        $display("Simulation finished at 20us.");
        $finish;
    end

endmodule
