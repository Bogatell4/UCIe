`include "SB_codex_pkg.vh"

module ACTIVE (
    input clk_100MHz,
    input clk_800MHz,
    input clk_2GHz,
    input reset,
    input enable_i,

    output ACTIVE_done_o,

    output SB_msg_t TX_msg_o,
    output TX_msg_valid_o,
    input TX_msg_valid_ack_i,
    input SB_msg_t RX_msg_i,
    input RX_msg_valid_i,
    output RX_msg_req_o,

    output reset_state_timeout_counter_o

);

assign reset_state_timeout_counter_o = 1'b1; // No timeout counter in ACTIVE state

endmodule
