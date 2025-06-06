`include "SB_codex_pkg.vh"

module SBINIT (
    input clk_100MHz,
    input clk_800MHz,
    input reset,
    input enable_i,

    output SBINIT_done_o,

    // SB Pins
    input SB_clkPin_RX_i,
    input SB_dataPin_RX_i,
    output SB_clkPin_TX_o,
    output SB_dataPin_TX_o,

    // SB Communication ports
    output SB_msg_t SB_TX_msg_o,
    output [63:0] SB_TX_dataBus_o,
    output SB_TX_msg_valid_o,
    input SB_TX_msg_sendNextFlag_i,

    input SB_msg_t SB_RX_msg_i,
    input [63:0] SB_RX_dataBus_i,
    output SB_RX_msg_req_o,
    input SB_RX_msg_valid_i,

    // SBINIT specific outputs
    output enable_SB_tx,
    output enable_SB_rx,

    output reset_state_timeout_counter_o
);

endmodule
