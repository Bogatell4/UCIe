`include "SB_codex_pkg.vh"

module LINKINIT (
  input clk_100MHz,
  input clk_800MHz,
  input clk_2GHz,
  input reset,
  input enable_i,

  output LINKINIT_done_o,

  //MB Pins
  input MB_RX_validPin_i,
  input MB_RX_trackPin_i,
  input [1:0] MB_RX_clkPins_i,
  input [15:0] MB_RX_dataPins_i,
  
  output MB_TX_validPin_o,
  output MB_TX_trackPin_o,
  output [1:0] MB_TX_clkPins_o,
  output [15:0] MB_TX_dataPins_o,

  // SB Communication ports
  output SB_msg_t SB_TX_msg_o,
  output [63:0] SB_TX_dataBus_o,
  output SB_TX_msg_valid_o,
  input SB_TX_msg_sendNextFlag_i,

  input SB_msg_t SB_RX_msg_i,
  input [63:0] SB_RX_dataBus_i,
  output SB_RX_msg_req_o,
  input SB_RX_msg_valid_i,

  output reset_state_timeout_counter_o

);

endmodule
