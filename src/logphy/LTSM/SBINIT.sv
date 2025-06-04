`include "SB_codex_pkg.vh"

module SBINIT (
    input clk_100MHz,
    input clk_800MHz,
    input reset,
    input enable_i,

    input SB_clkPin_RX_i,
    input SB_dataPin_RX_i,
    output SB_clkPin_TX_o,
    output SB_dataPin_TX_o,

    output SBINIT_done_o,

    output SB_msg_t TX_msg_o,
    output TX_msg_valid_o,
    input TX_msg_valid_ack_i,
    input SB_msg_t RX_msg_i,
    output RX_msg_req_o,
    input RX_msg_valid_i,

    output enable_SB_tx,
    output enable_SB_rx,

    output reset_state_timeout_counter_o
);

endmodule
