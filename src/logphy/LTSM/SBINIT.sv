`include "SB_codex_pkg.vh"

module SBINIT (
    input clk_100MHz,
    input clk_800MHz,
    input reset,
    input enable_i,

    input SB_clkPin_RX_i,
    input SB_dataPin_RX_i,
    output logic SB_clkPin_TX_o,
    output logic SB_dataPin_TX_o,

    output logic SBINIT_done_o,

    output SB_msg_t TX_msg_o,
    output logic TX_msg_valid_o,
    input SB_msg_t RX_msg_i,
    output logic RX_msg_req_o,
    input logic RX_msg_valid_i,

);

endmodule
