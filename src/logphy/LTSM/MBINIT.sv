`include "SB_codex_pkg.vh"

module MBINIT (
    input clk_100MHz,
    input clk_800MHz,
    input clk_2GHz,
    input reset,
    input enable_i,

    input [1:0] MB_clkPins_RX_MBINIT_i,
    input [15:0] MB_dataPins_RX_MBINIT_i,
    output [1:0] MB_clkPins_TX_MBINIT_o,
    output [15:0] MB_dataPins_TX_MBINIT_o,

    output MBINIT_done_o,

    output SB_msg_t TX_msg_o,
    output TX_msg_valid_o,
    input TX_msg_valid_ack_i,
    input SB_msg_t RX_msg_i,
    input RX_msg_valid_i,
    output RX_msg_req_o,

    output reset_state_timeout_counter_o

);

endmodule
