`include "SB_codex_pkg.vh"

module MBTRAIN (
    input clk_100MHz,
    input clk_800MHz,
    input clk_2GHz,
    input reset,
    input enable_i,

    input [1:0] MB_clkPins_RX_MBTRAIN_i,
    input [15:0] MB_dataPins_RX_MBTRAIN_i,
    output logic [1:0] MB_clkPins_TX_MBTRAIN_o,
    output logic [15:0] MB_dataPins_TX_MBTRAIN_o,

    output logic MTRAIN_done_o,

    output SB_msg_t TX_msg_o,
    output logic TX_msg_valid_o,
    input SB_msg_t RX_msg_i,
    input logic RX_msg_valid_i,
    output logic RX_msg_req_o

);

endmodule
