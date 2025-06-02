`include "SB_codex_pkg.vh"

module LINKINIT (
    input clk_100MHz,
    input clk_800MHz,
    input clk_2GHz,
    input reset,
    input enable_i,

    output logic LINKINIT_done_o,

    output SB_msg_t TX_msg_o,
    output logic TX_msg_valid_o,
    input SB_msg_t RX_msg_i,
    input logic RX_msg_valid_i,
    output logic RX_msg_req_o,

);

endmodule
