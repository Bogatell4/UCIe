module ProtocolLayer(
  input          clock,
  input          reset,
  input          io_fdi_lpData_ready, // @[src/main/scala/protocol/ProtocolLayer.scala 20:16]
  output         io_fdi_lpData_valid, // @[src/main/scala/protocol/ProtocolLayer.scala 20:16]
  output         io_fdi_lpData_irdy, // @[src/main/scala/protocol/ProtocolLayer.scala 20:16]
  output [511:0] io_fdi_lpData_bits, // @[src/main/scala/protocol/ProtocolLayer.scala 20:16]
  input          io_fdi_plData_valid, // @[src/main/scala/protocol/ProtocolLayer.scala 20:16]
  input  [511:0] io_fdi_plData_bits, // @[src/main/scala/protocol/ProtocolLayer.scala 20:16]
  output [3:0]   io_fdi_lpStateReq, // @[src/main/scala/protocol/ProtocolLayer.scala 20:16]
  output         io_fdi_lpLinkError, // @[src/main/scala/protocol/ProtocolLayer.scala 20:16]
  input  [3:0]   io_fdi_plStateStatus, // @[src/main/scala/protocol/ProtocolLayer.scala 20:16]
  input          io_fdi_plInbandPres, // @[src/main/scala/protocol/ProtocolLayer.scala 20:16]
  input          io_fdi_plRxActiveReq, // @[src/main/scala/protocol/ProtocolLayer.scala 20:16]
  output         io_fdi_lpRxActiveStatus, // @[src/main/scala/protocol/ProtocolLayer.scala 20:16]
  input          io_fdi_plStallReq, // @[src/main/scala/protocol/ProtocolLayer.scala 20:16]
  output         io_fdi_lpStallAck, // @[src/main/scala/protocol/ProtocolLayer.scala 20:16]
  output [3:0]   io_TLplStateStatus, // @[src/main/scala/protocol/ProtocolLayer.scala 20:16]
  input          io_TLlpData_valid, // @[src/main/scala/protocol/ProtocolLayer.scala 20:16]
  input  [511:0] io_TLlpData_bits, // @[src/main/scala/protocol/ProtocolLayer.scala 20:16]
  input          io_TLlpData_irdy, // @[src/main/scala/protocol/ProtocolLayer.scala 20:16]
  output         io_TLlpData_ready, // @[src/main/scala/protocol/ProtocolLayer.scala 20:16]
  output [511:0] io_TLplData_bits, // @[src/main/scala/protocol/ProtocolLayer.scala 20:16]
  output         io_TLplData_valid, // @[src/main/scala/protocol/ProtocolLayer.scala 20:16]
  input          io_TLready_to_rcv, // @[src/main/scala/protocol/ProtocolLayer.scala 20:16]
  input          io_fault, // @[src/main/scala/protocol/ProtocolLayer.scala 20:16]
  input          io_soft_reset // @[src/main/scala/protocol/ProtocolLayer.scala 20:16]
);
  reg  lp_rx_active_sts_reg; // @[src/main/scala/protocol/ProtocolLayer.scala 63:39]
  wire  lp_rx_active_pl_state = io_fdi_plStateStatus == 4'h1; // @[src/main/scala/protocol/ProtocolLayer.scala 68:55]
  wire  _GEN_0 = io_fdi_plRxActiveReq & io_TLready_to_rcv & lp_rx_active_pl_state | lp_rx_active_sts_reg; // @[src/main/scala/protocol/ProtocolLayer.scala 70:78 71:30 63:39]
  reg [3:0] lp_state_req_reg; // @[src/main/scala/protocol/ProtocolLayer.scala 76:35]
  wire  _reqActive_T_1 = lp_state_req_reg == 4'h0; // @[src/main/scala/protocol/ProtocolLayer.scala 79:38]
  wire  _reqActive_T_2 = io_fdi_plStateStatus == 4'h0 & _reqActive_T_1; // @[src/main/scala/protocol/ProtocolLayer.scala 78:63]
  wire  _reqActive_T_3 = _reqActive_T_2 & io_fdi_plInbandPres; // @[src/main/scala/protocol/ProtocolLayer.scala 79:58]
  wire  reqActive = _reqActive_T_3 | io_fdi_plStateStatus == 4'h9; // @[src/main/scala/protocol/ProtocolLayer.scala 80:42]
  reg  lp_stall_reg; // @[src/main/scala/protocol/ProtocolLayer.scala 97:31]
  assign io_fdi_lpData_valid = io_TLlpData_valid; // @[src/main/scala/protocol/ProtocolLayer.scala 37:25]
  assign io_fdi_lpData_irdy = io_TLlpData_irdy; // @[src/main/scala/protocol/ProtocolLayer.scala 38:24]
  assign io_fdi_lpData_bits = io_TLlpData_bits; // @[src/main/scala/protocol/ProtocolLayer.scala 36:24]
  assign io_fdi_lpStateReq = lp_state_req_reg; // @[src/main/scala/protocol/ProtocolLayer.scala 88:23]
  assign io_fdi_lpLinkError = io_fault; // @[src/main/scala/protocol/ProtocolLayer.scala 92:24]
  assign io_fdi_lpRxActiveStatus = lp_rx_active_sts_reg; // @[src/main/scala/protocol/ProtocolLayer.scala 73:29]
  assign io_fdi_lpStallAck = lp_stall_reg; // @[src/main/scala/protocol/ProtocolLayer.scala 99:23]
  assign io_TLplStateStatus = io_fdi_plStateStatus; // @[src/main/scala/protocol/ProtocolLayer.scala 34:24]
  assign io_TLlpData_ready = io_fdi_lpData_ready; // @[src/main/scala/protocol/ProtocolLayer.scala 39:23]
  assign io_TLplData_bits = io_fdi_plData_bits; // @[src/main/scala/protocol/ProtocolLayer.scala 42:22]
  assign io_TLplData_valid = io_fdi_plData_valid; // @[src/main/scala/protocol/ProtocolLayer.scala 41:23]
  always @(posedge clock) begin
    if (reset) begin // @[src/main/scala/protocol/ProtocolLayer.scala 63:39]
      lp_rx_active_sts_reg <= 1'h0; // @[src/main/scala/protocol/ProtocolLayer.scala 63:39]
    end else begin
      lp_rx_active_sts_reg <= _GEN_0;
    end
    if (reset) begin // @[src/main/scala/protocol/ProtocolLayer.scala 76:35]
      lp_state_req_reg <= 4'h0; // @[src/main/scala/protocol/ProtocolLayer.scala 76:35]
    end else if (reqActive) begin // @[src/main/scala/protocol/ProtocolLayer.scala 82:21]
      lp_state_req_reg <= 4'h1; // @[src/main/scala/protocol/ProtocolLayer.scala 83:26]
    end else if (~reqActive & io_soft_reset) begin // @[src/main/scala/protocol/ProtocolLayer.scala 84:48]
      lp_state_req_reg <= 4'h9; // @[src/main/scala/protocol/ProtocolLayer.scala 85:26]
    end else begin
      lp_state_req_reg <= 4'h0; // @[src/main/scala/protocol/ProtocolLayer.scala 86:36]
    end
    if (reset) begin // @[src/main/scala/protocol/ProtocolLayer.scala 97:31]
      lp_stall_reg <= 1'h0; // @[src/main/scala/protocol/ProtocolLayer.scala 97:31]
    end else begin
      lp_stall_reg <= io_fdi_plStallReq; // @[src/main/scala/protocol/ProtocolLayer.scala 98:18]
    end
  end
endmodule
module LinkDisabledSubmodule(
  input        clock,
  input        reset,
  input  [3:0] io_fdi_lp_state_req, // @[src/main/scala/d2dadapter/LinkDisabledSubmodule.scala 26:14]
  input  [3:0] io_fdi_lp_state_req_prev, // @[src/main/scala/d2dadapter/LinkDisabledSubmodule.scala 26:14]
  input  [3:0] io_link_state, // @[src/main/scala/d2dadapter/LinkDisabledSubmodule.scala 26:14]
  output       io_disabled_entry, // @[src/main/scala/d2dadapter/LinkDisabledSubmodule.scala 26:14]
  output [5:0] io_disabled_sb_snd, // @[src/main/scala/d2dadapter/LinkDisabledSubmodule.scala 26:14]
  input  [5:0] io_disabled_sb_rcv, // @[src/main/scala/d2dadapter/LinkDisabledSubmodule.scala 26:14]
  input        io_disabled_sb_rdy // @[src/main/scala/d2dadapter/LinkDisabledSubmodule.scala 26:14]
);
  reg  disabled_fdi_req_reg; // @[src/main/scala/d2dadapter/LinkDisabledSubmodule.scala 28:37]
  reg  disabled_sbmsg_req_rcv_reg; // @[src/main/scala/d2dadapter/LinkDisabledSubmodule.scala 29:43]
  reg  disabled_sbmsg_rsp_rcv_reg; // @[src/main/scala/d2dadapter/LinkDisabledSubmodule.scala 30:43]
  reg  disabled_sbmsg_ext_rsp_reg; // @[src/main/scala/d2dadapter/LinkDisabledSubmodule.scala 31:43]
  reg  disabled_sbmsg_ext_req_reg; // @[src/main/scala/d2dadapter/LinkDisabledSubmodule.scala 32:43]
  wire  _T = io_link_state == 4'h0; // @[src/main/scala/d2dadapter/LinkDisabledSubmodule.scala 35:21]
  wire  _T_1 = io_link_state == 4'h1; // @[src/main/scala/d2dadapter/LinkDisabledSubmodule.scala 36:21]
  wire  _T_2 = io_link_state == 4'h0 | _T_1; // @[src/main/scala/d2dadapter/LinkDisabledSubmodule.scala 35:40]
  wire  _T_3 = io_link_state == 4'hb; // @[src/main/scala/d2dadapter/LinkDisabledSubmodule.scala 37:21]
  wire  _T_4 = _T_2 | _T_3; // @[src/main/scala/d2dadapter/LinkDisabledSubmodule.scala 36:41]
  wire  _T_5 = io_link_state == 4'h9; // @[src/main/scala/d2dadapter/LinkDisabledSubmodule.scala 38:21]
  wire  _T_6 = _T_4 | _T_5; // @[src/main/scala/d2dadapter/LinkDisabledSubmodule.scala 37:42]
  wire  _T_8 = io_fdi_lp_state_req == 4'hc; // @[src/main/scala/d2dadapter/LinkDisabledSubmodule.scala 45:29]
  wire  _T_9 = _T & _T_8; // @[src/main/scala/d2dadapter/LinkDisabledSubmodule.scala 44:40]
  wire  _T_10 = io_fdi_lp_state_req_prev == 4'h0; // @[src/main/scala/d2dadapter/LinkDisabledSubmodule.scala 46:34]
  wire  _T_11 = _T_9 & _T_10; // @[src/main/scala/d2dadapter/LinkDisabledSubmodule.scala 45:54]
  wire  _T_13 = io_link_state != 4'h0; // @[src/main/scala/d2dadapter/LinkDisabledSubmodule.scala 51:23]
  wire  _T_14 = _T_8 & _T_13; // @[src/main/scala/d2dadapter/LinkDisabledSubmodule.scala 50:52]
  wire  _GEN_0 = _T_14 | disabled_fdi_req_reg; // @[src/main/scala/d2dadapter/LinkDisabledSubmodule.scala 52:7 53:28 55:28]
  wire  _GEN_1 = _T_11 | _GEN_0; // @[src/main/scala/d2dadapter/LinkDisabledSubmodule.scala 47:7 48:28]
  wire  _GEN_2 = io_disabled_sb_snd == 6'hc & io_disabled_sb_rdy | disabled_sbmsg_ext_req_reg; // @[src/main/scala/d2dadapter/LinkDisabledSubmodule.scala 58:84 59:34 61:34]
  wire  _GEN_3 = io_disabled_sb_snd == 6'h1c & io_disabled_sb_rdy | disabled_sbmsg_ext_rsp_reg; // @[src/main/scala/d2dadapter/LinkDisabledSubmodule.scala 64:84 65:34 67:34]
  wire  _GEN_4 = io_disabled_sb_rcv == 6'hc | disabled_sbmsg_req_rcv_reg; // @[src/main/scala/d2dadapter/LinkDisabledSubmodule.scala 70:63 71:34 73:34]
  wire  _GEN_5 = io_disabled_sb_rcv == 6'h1c | disabled_sbmsg_rsp_rcv_reg; // @[src/main/scala/d2dadapter/LinkDisabledSubmodule.scala 78:63 79:34 81:34]
  wire  _T_22 = disabled_fdi_req_reg & ~disabled_sbmsg_req_rcv_reg; // @[src/main/scala/d2dadapter/LinkDisabledSubmodule.scala 87:31]
  wire [5:0] _GEN_6 = disabled_sbmsg_req_rcv_reg & ~disabled_sbmsg_ext_rsp_reg ? 6'h1c : 6'h0; // @[src/main/scala/d2dadapter/LinkDisabledSubmodule.scala 90:75 91:26 93:26]
  wire [5:0] _GEN_7 = _T_22 & ~disabled_sbmsg_ext_req_reg ? 6'hc : _GEN_6; // @[src/main/scala/d2dadapter/LinkDisabledSubmodule.scala 88:42 89:26]
  wire  _GEN_9 = _T_6 & _GEN_1; // @[src/main/scala/d2dadapter/LinkDisabledSubmodule.scala 39:5 96:26]
  wire  _GEN_10 = _T_6 & _GEN_2; // @[src/main/scala/d2dadapter/LinkDisabledSubmodule.scala 39:5 99:32]
  wire  _GEN_11 = _T_6 & _GEN_3; // @[src/main/scala/d2dadapter/LinkDisabledSubmodule.scala 100:32 39:5]
  wire  _GEN_12 = _T_6 & _GEN_4; // @[src/main/scala/d2dadapter/LinkDisabledSubmodule.scala 39:5 97:32]
  wire  _GEN_13 = _T_6 & _GEN_5; // @[src/main/scala/d2dadapter/LinkDisabledSubmodule.scala 39:5 98:32]
  assign io_disabled_entry = _T_6 & (disabled_sbmsg_ext_rsp_reg | disabled_sbmsg_rsp_rcv_reg); // @[src/main/scala/d2dadapter/LinkDisabledSubmodule.scala 101:23 39:5 40:23]
  assign io_disabled_sb_snd = _T_6 ? _GEN_7 : 6'h0; // @[src/main/scala/d2dadapter/LinkDisabledSubmodule.scala 102:24 39:5]
  always @(posedge clock) begin
    if (reset) begin // @[src/main/scala/d2dadapter/LinkDisabledSubmodule.scala 28:37]
      disabled_fdi_req_reg <= 1'h0; // @[src/main/scala/d2dadapter/LinkDisabledSubmodule.scala 28:37]
    end else begin
      disabled_fdi_req_reg <= _GEN_9;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/LinkDisabledSubmodule.scala 29:43]
      disabled_sbmsg_req_rcv_reg <= 1'h0; // @[src/main/scala/d2dadapter/LinkDisabledSubmodule.scala 29:43]
    end else begin
      disabled_sbmsg_req_rcv_reg <= _GEN_12;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/LinkDisabledSubmodule.scala 30:43]
      disabled_sbmsg_rsp_rcv_reg <= 1'h0; // @[src/main/scala/d2dadapter/LinkDisabledSubmodule.scala 30:43]
    end else begin
      disabled_sbmsg_rsp_rcv_reg <= _GEN_13;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/LinkDisabledSubmodule.scala 31:43]
      disabled_sbmsg_ext_rsp_reg <= 1'h0; // @[src/main/scala/d2dadapter/LinkDisabledSubmodule.scala 31:43]
    end else begin
      disabled_sbmsg_ext_rsp_reg <= _GEN_11;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/LinkDisabledSubmodule.scala 32:43]
      disabled_sbmsg_ext_req_reg <= 1'h0; // @[src/main/scala/d2dadapter/LinkDisabledSubmodule.scala 32:43]
    end else begin
      disabled_sbmsg_ext_req_reg <= _GEN_10;
    end
  end
endmodule
module LinkResetSubmodule(
  input        clock,
  input        reset,
  input  [3:0] io_fdi_lp_state_req, // @[src/main/scala/d2dadapter/LinkResetSubmodule.scala 25:14]
  input  [3:0] io_fdi_lp_state_req_prev, // @[src/main/scala/d2dadapter/LinkResetSubmodule.scala 25:14]
  input  [3:0] io_link_state, // @[src/main/scala/d2dadapter/LinkResetSubmodule.scala 25:14]
  output       io_linkreset_entry, // @[src/main/scala/d2dadapter/LinkResetSubmodule.scala 25:14]
  output [5:0] io_linkreset_sb_snd, // @[src/main/scala/d2dadapter/LinkResetSubmodule.scala 25:14]
  input  [5:0] io_linkreset_sb_rcv, // @[src/main/scala/d2dadapter/LinkResetSubmodule.scala 25:14]
  input        io_linkreset_sb_rdy // @[src/main/scala/d2dadapter/LinkResetSubmodule.scala 25:14]
);
  reg  linkreset_fdi_req_reg; // @[src/main/scala/d2dadapter/LinkResetSubmodule.scala 27:38]
  reg  linkreset_sbmsg_req_rcv_flag; // @[src/main/scala/d2dadapter/LinkResetSubmodule.scala 28:45]
  reg  linkreset_sbmsg_rsp_rcv_flag; // @[src/main/scala/d2dadapter/LinkResetSubmodule.scala 29:45]
  reg  linkreset_sbmsg_ext_rsp_reg; // @[src/main/scala/d2dadapter/LinkResetSubmodule.scala 30:44]
  reg  linkreset_sbmsg_ext_req_reg; // @[src/main/scala/d2dadapter/LinkResetSubmodule.scala 31:44]
  wire  _T = io_link_state == 4'h0; // @[src/main/scala/d2dadapter/LinkResetSubmodule.scala 34:21]
  wire  _T_1 = io_link_state == 4'h1; // @[src/main/scala/d2dadapter/LinkResetSubmodule.scala 35:21]
  wire  _T_2 = io_link_state == 4'h0 | _T_1; // @[src/main/scala/d2dadapter/LinkResetSubmodule.scala 34:40]
  wire  _T_3 = io_link_state == 4'hb; // @[src/main/scala/d2dadapter/LinkResetSubmodule.scala 36:21]
  wire  _T_4 = _T_2 | _T_3; // @[src/main/scala/d2dadapter/LinkResetSubmodule.scala 35:41]
  wire  _T_6 = io_fdi_lp_state_req == 4'h9; // @[src/main/scala/d2dadapter/LinkResetSubmodule.scala 44:29]
  wire  _T_7 = _T & _T_6; // @[src/main/scala/d2dadapter/LinkResetSubmodule.scala 43:40]
  wire  _T_8 = io_fdi_lp_state_req_prev == 4'h0; // @[src/main/scala/d2dadapter/LinkResetSubmodule.scala 45:34]
  wire  _T_9 = _T_7 & _T_8; // @[src/main/scala/d2dadapter/LinkResetSubmodule.scala 44:55]
  wire  _T_11 = io_link_state != 4'h0; // @[src/main/scala/d2dadapter/LinkResetSubmodule.scala 50:23]
  wire  _T_12 = _T_6 & _T_11; // @[src/main/scala/d2dadapter/LinkResetSubmodule.scala 49:53]
  wire  _GEN_0 = _T_12 | linkreset_fdi_req_reg; // @[src/main/scala/d2dadapter/LinkResetSubmodule.scala 51:7 52:29 54:29]
  wire  _GEN_1 = _T_9 | _GEN_0; // @[src/main/scala/d2dadapter/LinkResetSubmodule.scala 46:7 47:29]
  wire  _GEN_2 = io_linkreset_sb_snd == 6'h9 & io_linkreset_sb_rdy | linkreset_sbmsg_ext_req_reg; // @[src/main/scala/d2dadapter/LinkResetSubmodule.scala 57:87 58:35 60:35]
  wire  _GEN_3 = io_linkreset_sb_snd == 6'h19 & io_linkreset_sb_rdy | linkreset_sbmsg_ext_rsp_reg; // @[src/main/scala/d2dadapter/LinkResetSubmodule.scala 63:87 64:35 66:35]
  wire  _GEN_4 = io_linkreset_sb_rcv == 6'h9 | linkreset_sbmsg_req_rcv_flag; // @[src/main/scala/d2dadapter/LinkResetSubmodule.scala 70:65 71:36 73:36]
  wire  _GEN_5 = io_linkreset_sb_rcv == 6'h19 | linkreset_sbmsg_rsp_rcv_flag; // @[src/main/scala/d2dadapter/LinkResetSubmodule.scala 78:65 79:36 81:36]
  wire  _T_21 = ~linkreset_sbmsg_ext_req_reg; // @[src/main/scala/d2dadapter/LinkResetSubmodule.scala 87:10]
  wire  _T_22 = linkreset_fdi_req_reg & ~linkreset_sbmsg_req_rcv_flag & _T_21; // @[src/main/scala/d2dadapter/LinkResetSubmodule.scala 86:65]
  wire [5:0] _GEN_6 = linkreset_sbmsg_req_rcv_flag & ~linkreset_sbmsg_ext_rsp_reg ? 6'h19 : 6'h0; // @[src/main/scala/d2dadapter/LinkResetSubmodule.scala 89:78 90:27 92:27]
  wire [5:0] _GEN_7 = _T_22 ? 6'h9 : _GEN_6; // @[src/main/scala/d2dadapter/LinkResetSubmodule.scala 87:40 88:27]
  wire  _GEN_9 = _T_4 & _GEN_1; // @[src/main/scala/d2dadapter/LinkResetSubmodule.scala 37:5 95:27]
  wire  _GEN_10 = _T_4 & _GEN_2; // @[src/main/scala/d2dadapter/LinkResetSubmodule.scala 37:5 98:33]
  wire  _GEN_11 = _T_4 & _GEN_3; // @[src/main/scala/d2dadapter/LinkResetSubmodule.scala 37:5 99:33]
  wire  _GEN_12 = _T_4 & _GEN_4; // @[src/main/scala/d2dadapter/LinkResetSubmodule.scala 37:5 96:34]
  wire  _GEN_13 = _T_4 & _GEN_5; // @[src/main/scala/d2dadapter/LinkResetSubmodule.scala 37:5 97:34]
  assign io_linkreset_entry = _T_4 & (linkreset_sbmsg_ext_rsp_reg | linkreset_sbmsg_rsp_rcv_flag); // @[src/main/scala/d2dadapter/LinkResetSubmodule.scala 100:24 37:5 39:24]
  assign io_linkreset_sb_snd = _T_4 ? _GEN_7 : 6'h0; // @[src/main/scala/d2dadapter/LinkResetSubmodule.scala 101:25 37:5]
  always @(posedge clock) begin
    if (reset) begin // @[src/main/scala/d2dadapter/LinkResetSubmodule.scala 27:38]
      linkreset_fdi_req_reg <= 1'h0; // @[src/main/scala/d2dadapter/LinkResetSubmodule.scala 27:38]
    end else begin
      linkreset_fdi_req_reg <= _GEN_9;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/LinkResetSubmodule.scala 28:45]
      linkreset_sbmsg_req_rcv_flag <= 1'h0; // @[src/main/scala/d2dadapter/LinkResetSubmodule.scala 28:45]
    end else begin
      linkreset_sbmsg_req_rcv_flag <= _GEN_12;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/LinkResetSubmodule.scala 29:45]
      linkreset_sbmsg_rsp_rcv_flag <= 1'h0; // @[src/main/scala/d2dadapter/LinkResetSubmodule.scala 29:45]
    end else begin
      linkreset_sbmsg_rsp_rcv_flag <= _GEN_13;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/LinkResetSubmodule.scala 30:44]
      linkreset_sbmsg_ext_rsp_reg <= 1'h0; // @[src/main/scala/d2dadapter/LinkResetSubmodule.scala 30:44]
    end else begin
      linkreset_sbmsg_ext_rsp_reg <= _GEN_11;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/LinkResetSubmodule.scala 31:44]
      linkreset_sbmsg_ext_req_reg <= 1'h0; // @[src/main/scala/d2dadapter/LinkResetSubmodule.scala 31:44]
    end else begin
      linkreset_sbmsg_ext_req_reg <= _GEN_10;
    end
  end
endmodule
module LinkInitSubmodule(
  input        clock,
  input        reset,
  input  [3:0] io_fdi_lp_state_req, // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 39:16]
  input  [3:0] io_fdi_lp_state_req_prev, // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 39:16]
  input        io_fdi_lp_rxactive_sts, // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 39:16]
  output       io_linkinit_fdi_pl_inband_pres, // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 39:16]
  output       io_linkinit_fdi_pl_rxactive_req, // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 39:16]
  input  [3:0] io_rdi_pl_state_sts, // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 39:16]
  input        io_rdi_pl_inband_pres, // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 39:16]
  output [3:0] io_linkinit_rdi_lp_state_req, // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 39:16]
  input  [3:0] io_link_state, // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 39:16]
  output       io_active_entry, // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 39:16]
  output [5:0] io_linkinit_sb_snd, // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 39:16]
  input  [5:0] io_linkinit_sb_rcv, // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 39:16]
  input        io_linkinit_sb_rdy // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 39:16]
);
  reg [2:0] linkinit_state_reg; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 42:37]
  reg  param_exch_sbmsg_rcv_flag; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 45:44]
  reg  param_exch_sbmsg_snt_flag; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 46:44]
  reg  active_sbmsg_req_rcv_flag; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 49:44]
  reg  active_sbmsg_rsp_rcv_flag; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 50:44]
  reg  active_sbmsg_ext_rsp_reg; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 51:43]
  reg  active_sbmsg_ext_req_reg; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 52:43]
  reg  transition_to_active_reg; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 54:43]
  wire [2:0] _GEN_1 = io_rdi_pl_state_sts == 4'h1 ? 3'h2 : linkinit_state_reg; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 94:59 95:34 97:34]
  wire [5:0] _GEN_2 = ~param_exch_sbmsg_snt_flag ? 6'h24 : 6'h0; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 105:46 106:34 108:34]
  wire  _GEN_3 = io_linkinit_sb_rcv == 6'h24 | param_exch_sbmsg_rcv_flag; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 112:65 113:43 115:43]
  wire  _GEN_4 = io_linkinit_sb_rdy & io_linkinit_sb_snd == 6'h24 | param_exch_sbmsg_snt_flag; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 118:88 119:43 121:43]
  wire [2:0] _GEN_5 = param_exch_sbmsg_snt_flag & param_exch_sbmsg_rcv_flag ? 3'h3 : linkinit_state_reg; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 125:74 126:36 128:36]
  wire [5:0] _GEN_7 = transition_to_active_reg & ~active_sbmsg_ext_req_reg ? 6'h1 : 6'h0; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 144:79 145:36 147:34]
  wire [5:0] _GEN_8 = io_fdi_lp_rxactive_sts & io_linkinit_fdi_pl_rxactive_req & ~active_sbmsg_ext_rsp_reg ? 6'h11 :
    _GEN_7; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 142:106 143:36]
  wire  _GEN_9 = io_linkinit_sb_rcv == 6'h11 | active_sbmsg_rsp_rcv_flag; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 150:69 151:41 153:41]
  wire  _GEN_10 = io_linkinit_sb_rcv == 6'h1 | active_sbmsg_req_rcv_flag; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 156:69 157:41 159:41]
  wire  _GEN_11 = io_linkinit_sb_snd == 6'h11 & io_linkinit_sb_rdy | active_sbmsg_ext_rsp_reg; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 162:91 163:40 165:40]
  wire  _GEN_12 = io_linkinit_sb_snd == 6'h1 & io_linkinit_sb_rdy | active_sbmsg_ext_req_reg; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 168:91 169:40 171:40]
  wire  _T_31 = io_fdi_lp_state_req_prev == 4'h0; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 175:43]
  wire  _T_32 = io_fdi_lp_state_req == 4'h1 & _T_31; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 174:61]
  wire  _GEN_13 = _T_32 | transition_to_active_reg; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 175:64 176:40 178:40]
  wire [2:0] _GEN_14 = active_sbmsg_ext_rsp_reg & active_sbmsg_rsp_rcv_flag ? 3'h4 : linkinit_state_reg; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 181:73 182:34 184:34]
  wire [2:0] _GEN_17 = 3'h4 == linkinit_state_reg ? 3'h4 : linkinit_state_reg; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 195:32 78:34 42:37]
  wire  _GEN_18 = 3'h3 == linkinit_state_reg | 3'h4 == linkinit_state_reg; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 78:34 133:44]
  wire  _GEN_19 = 3'h3 == linkinit_state_reg ? active_sbmsg_req_rcv_flag : 3'h4 == linkinit_state_reg; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 78:34]
  wire [5:0] _GEN_20 = 3'h3 == linkinit_state_reg ? _GEN_8 : 6'h0; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 78:34]
  wire [2:0] _GEN_26 = 3'h3 == linkinit_state_reg ? _GEN_14 : _GEN_17; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 78:34]
  wire  _GEN_27 = 3'h3 == linkinit_state_reg ? 1'h0 : 3'h4 == linkinit_state_reg; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 66:23 78:34]
  wire  _GEN_28 = 3'h2 == linkinit_state_reg | _GEN_18; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 78:34 102:42]
  wire [5:0] _GEN_29 = 3'h2 == linkinit_state_reg ? _GEN_2 : _GEN_20; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 78:34]
  wire [2:0] _GEN_32 = 3'h2 == linkinit_state_reg ? _GEN_5 : _GEN_26; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 78:34]
  wire  _GEN_33 = 3'h2 == linkinit_state_reg ? 1'h0 : _GEN_18; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 78:34 58:36]
  wire  _GEN_34 = 3'h2 == linkinit_state_reg ? 1'h0 : _GEN_19; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 78:34 68:39]
  wire  _GEN_35 = 3'h2 == linkinit_state_reg ? 1'h0 : 3'h3 == linkinit_state_reg & _GEN_9; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 73:33 78:34]
  wire  _GEN_36 = 3'h2 == linkinit_state_reg ? 1'h0 : 3'h3 == linkinit_state_reg & _GEN_10; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 72:33 78:34]
  wire  _GEN_37 = 3'h2 == linkinit_state_reg ? 1'h0 : 3'h3 == linkinit_state_reg & _GEN_11; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 74:32 78:34]
  wire  _GEN_38 = 3'h2 == linkinit_state_reg ? 1'h0 : 3'h3 == linkinit_state_reg & _GEN_12; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 75:32 78:34]
  wire  _GEN_39 = 3'h2 == linkinit_state_reg ? 1'h0 : 3'h3 == linkinit_state_reg & _GEN_13; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 76:32 78:34]
  wire  _GEN_40 = 3'h2 == linkinit_state_reg ? 1'h0 : _GEN_27; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 66:23 78:34]
  wire  _GEN_41 = 3'h1 == linkinit_state_reg | _GEN_28; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 78:34 93:42]
  wire [5:0] _GEN_43 = 3'h1 == linkinit_state_reg ? 6'h0 : _GEN_29; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 69:26 78:34]
  wire  _GEN_44 = 3'h1 == linkinit_state_reg ? 1'h0 : 3'h2 == linkinit_state_reg & _GEN_3; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 70:33 78:34]
  wire  _GEN_45 = 3'h1 == linkinit_state_reg ? 1'h0 : 3'h2 == linkinit_state_reg & _GEN_4; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 71:33 78:34]
  wire  _GEN_46 = 3'h1 == linkinit_state_reg ? 1'h0 : _GEN_33; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 78:34 58:36]
  wire  _GEN_47 = 3'h1 == linkinit_state_reg ? 1'h0 : _GEN_34; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 78:34 68:39]
  wire  _GEN_53 = 3'h1 == linkinit_state_reg ? 1'h0 : _GEN_40; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 66:23 78:34]
  wire  _GEN_54 = 3'h0 == linkinit_state_reg ? 1'h0 : _GEN_53; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 78:34 81:29]
  wire  _GEN_55 = 3'h0 == linkinit_state_reg ? 1'h0 : _GEN_41; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 78:34 82:42]
  wire  _GEN_56 = 3'h0 == linkinit_state_reg ? 1'h0 : _GEN_47; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 78:34 83:45]
  wire [5:0] _GEN_57 = 3'h0 == linkinit_state_reg ? 6'h0 : _GEN_43; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 78:34 84:32]
  wire  _GEN_59 = 3'h0 == linkinit_state_reg ? 1'h0 : _GEN_44; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 70:33 78:34]
  wire  _GEN_60 = 3'h0 == linkinit_state_reg ? 1'h0 : _GEN_45; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 71:33 78:34]
  wire  _GEN_61 = 3'h0 == linkinit_state_reg ? 1'h0 : _GEN_46; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 78:34 58:36]
  wire  _GEN_68 = io_link_state == 4'h0 & _GEN_55; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 201:36 64:44]
  wire  _GEN_71 = io_link_state == 4'h0 & _GEN_59; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 205:33 64:44]
  wire  _GEN_72 = io_link_state == 4'h0 & _GEN_60; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 206:33 64:44]
  assign io_linkinit_fdi_pl_inband_pres = io_link_state == 4'h0 & _GEN_61; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 203:38 64:44]
  assign io_linkinit_fdi_pl_rxactive_req = io_link_state == 4'h0 & _GEN_56; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 202:39 64:44]
  assign io_linkinit_rdi_lp_state_req = {{3'd0}, _GEN_68};
  assign io_active_entry = io_link_state == 4'h0 & _GEN_54; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 200:23 64:44]
  assign io_linkinit_sb_snd = io_link_state == 4'h0 ? _GEN_57 : 6'h0; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 204:26 64:44]
  always @(posedge clock) begin
    if (reset) begin // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 42:37]
      linkinit_state_reg <= 3'h0; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 42:37]
    end else if (io_link_state == 4'h0) begin // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 64:44]
      if (3'h0 == linkinit_state_reg) begin // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 78:34]
        if (io_rdi_pl_inband_pres) begin // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 85:41]
          linkinit_state_reg <= 3'h1; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 86:34]
        end
      end else if (3'h1 == linkinit_state_reg) begin // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 78:34]
        linkinit_state_reg <= _GEN_1;
      end else begin
        linkinit_state_reg <= _GEN_32;
      end
    end else begin
      linkinit_state_reg <= 3'h0; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 199:26]
    end
    if (reset) begin // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 45:44]
      param_exch_sbmsg_rcv_flag <= 1'h0; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 45:44]
    end else begin
      param_exch_sbmsg_rcv_flag <= _GEN_71;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 46:44]
      param_exch_sbmsg_snt_flag <= 1'h0; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 46:44]
    end else begin
      param_exch_sbmsg_snt_flag <= _GEN_72;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 49:44]
      active_sbmsg_req_rcv_flag <= 1'h0; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 49:44]
    end else if (io_link_state == 4'h0) begin // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 64:44]
      if (3'h0 == linkinit_state_reg) begin // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 78:34]
        active_sbmsg_req_rcv_flag <= 1'h0; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 72:33]
      end else if (3'h1 == linkinit_state_reg) begin // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 78:34]
        active_sbmsg_req_rcv_flag <= 1'h0; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 72:33]
      end else begin
        active_sbmsg_req_rcv_flag <= _GEN_36;
      end
    end
    if (reset) begin // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 50:44]
      active_sbmsg_rsp_rcv_flag <= 1'h0; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 50:44]
    end else if (io_link_state == 4'h0) begin // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 64:44]
      if (3'h0 == linkinit_state_reg) begin // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 78:34]
        active_sbmsg_rsp_rcv_flag <= 1'h0; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 73:33]
      end else if (3'h1 == linkinit_state_reg) begin // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 78:34]
        active_sbmsg_rsp_rcv_flag <= 1'h0; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 73:33]
      end else begin
        active_sbmsg_rsp_rcv_flag <= _GEN_35;
      end
    end
    if (reset) begin // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 51:43]
      active_sbmsg_ext_rsp_reg <= 1'h0; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 51:43]
    end else if (io_link_state == 4'h0) begin // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 64:44]
      if (3'h0 == linkinit_state_reg) begin // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 78:34]
        active_sbmsg_ext_rsp_reg <= 1'h0; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 74:32]
      end else if (3'h1 == linkinit_state_reg) begin // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 78:34]
        active_sbmsg_ext_rsp_reg <= 1'h0; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 74:32]
      end else begin
        active_sbmsg_ext_rsp_reg <= _GEN_37;
      end
    end
    if (reset) begin // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 52:43]
      active_sbmsg_ext_req_reg <= 1'h0; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 52:43]
    end else if (io_link_state == 4'h0) begin // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 64:44]
      if (3'h0 == linkinit_state_reg) begin // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 78:34]
        active_sbmsg_ext_req_reg <= 1'h0; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 75:32]
      end else if (3'h1 == linkinit_state_reg) begin // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 78:34]
        active_sbmsg_ext_req_reg <= 1'h0; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 75:32]
      end else begin
        active_sbmsg_ext_req_reg <= _GEN_38;
      end
    end
    if (reset) begin // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 54:43]
      transition_to_active_reg <= 1'h0; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 54:43]
    end else if (io_link_state == 4'h0) begin // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 64:44]
      if (3'h0 == linkinit_state_reg) begin // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 78:34]
        transition_to_active_reg <= 1'h0; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 76:32]
      end else if (3'h1 == linkinit_state_reg) begin // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 78:34]
        transition_to_active_reg <= 1'h0; // @[src/main/scala/d2dadapter/LinkInitSubmodule.scala 76:32]
      end else begin
        transition_to_active_reg <= _GEN_39;
      end
    end
  end
endmodule
module ParityNegotiationSubmodule(
  input        clock,
  input        reset,
  input        io_start_negotiation, // @[src/main/scala/d2dadapter/ParityNegotiationSubmodule.scala 26:16]
  input  [5:0] io_parity_sb_rcv, // @[src/main/scala/d2dadapter/ParityNegotiationSubmodule.scala 26:16]
  output [5:0] io_parity_sb_snd, // @[src/main/scala/d2dadapter/ParityNegotiationSubmodule.scala 26:16]
  input        io_parity_sb_rdy, // @[src/main/scala/d2dadapter/ParityNegotiationSubmodule.scala 26:16]
  output       io_parity_rx_enable, // @[src/main/scala/d2dadapter/ParityNegotiationSubmodule.scala 26:16]
  output       io_parity_tx_enable // @[src/main/scala/d2dadapter/ParityNegotiationSubmodule.scala 26:16]
);
  reg  parity_rsp_snt_flag_reg; // @[src/main/scala/d2dadapter/ParityNegotiationSubmodule.scala 28:42]
  reg  parity_req_rcv_flag_reg; // @[src/main/scala/d2dadapter/ParityNegotiationSubmodule.scala 30:42]
  reg  parity_rx_enable_reg; // @[src/main/scala/d2dadapter/ParityNegotiationSubmodule.scala 32:39]
  reg  parity_tx_enable_reg; // @[src/main/scala/d2dadapter/ParityNegotiationSubmodule.scala 33:39]
  wire  _T_3 = ~parity_rsp_snt_flag_reg; // @[src/main/scala/d2dadapter/ParityNegotiationSubmodule.scala 51:69]
  wire [5:0] _GEN_0 = parity_req_rcv_flag_reg & _T_3 ? 6'h32 : 6'h0; // @[src/main/scala/d2dadapter/ParityNegotiationSubmodule.scala 53:95 54:30 56:31]
  wire  _T_13 = io_parity_sb_snd == 6'h31; // @[src/main/scala/d2dadapter/ParityNegotiationSubmodule.scala 73:32]
  wire  _T_14 = io_parity_sb_snd == 6'h32; // @[src/main/scala/d2dadapter/ParityNegotiationSubmodule.scala 73:91]
  wire  _GEN_6 = (io_parity_sb_snd == 6'h31 | io_parity_sb_snd == 6'h32) & io_parity_sb_rdy | parity_rsp_snt_flag_reg; // @[src/main/scala/d2dadapter/ParityNegotiationSubmodule.scala 73:151 74:37 76:37]
  wire  _GEN_7 = io_parity_sb_rcv == 6'h21 | parity_req_rcv_flag_reg; // @[src/main/scala/d2dadapter/ParityNegotiationSubmodule.scala 79:70 80:37 82:37]
  wire  _T_18 = io_parity_sb_rcv == 6'h31; // @[src/main/scala/d2dadapter/ParityNegotiationSubmodule.scala 85:31]
  wire  _GEN_9 = _T_14 & io_parity_sb_rdy ? 1'h0 : parity_rx_enable_reg; // @[src/main/scala/d2dadapter/ParityNegotiationSubmodule.scala 94:96 95:34 32:39]
  wire  _GEN_10 = _T_14 & io_parity_sb_rdy ? _GEN_6 : parity_rsp_snt_flag_reg; // @[src/main/scala/d2dadapter/ParityNegotiationSubmodule.scala 94:96 97:37]
  wire  _GEN_11 = _T_13 & io_parity_sb_rdy | _GEN_9; // @[src/main/scala/d2dadapter/ParityNegotiationSubmodule.scala 92:90 93:34]
  wire  _GEN_12 = _T_13 & io_parity_sb_rdy ? _GEN_6 : _GEN_10; // @[src/main/scala/d2dadapter/ParityNegotiationSubmodule.scala 92:90]
  wire  _GEN_19 = io_start_negotiation & _GEN_12; // @[src/main/scala/d2dadapter/ParityNegotiationSubmodule.scala 43:31 113:33]
  wire  _GEN_20 = io_start_negotiation & _GEN_7; // @[src/main/scala/d2dadapter/ParityNegotiationSubmodule.scala 43:31 115:33]
  assign io_parity_sb_snd = io_start_negotiation ? _GEN_0 : 6'h0; // @[src/main/scala/d2dadapter/ParityNegotiationSubmodule.scala 109:27 43:31]
  assign io_parity_rx_enable = parity_rx_enable_reg; // @[src/main/scala/d2dadapter/ParityNegotiationSubmodule.scala 39:25]
  assign io_parity_tx_enable = parity_tx_enable_reg; // @[src/main/scala/d2dadapter/ParityNegotiationSubmodule.scala 40:25]
  always @(posedge clock) begin
    if (reset) begin // @[src/main/scala/d2dadapter/ParityNegotiationSubmodule.scala 28:42]
      parity_rsp_snt_flag_reg <= 1'h0; // @[src/main/scala/d2dadapter/ParityNegotiationSubmodule.scala 28:42]
    end else begin
      parity_rsp_snt_flag_reg <= _GEN_19;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityNegotiationSubmodule.scala 30:42]
      parity_req_rcv_flag_reg <= 1'h0; // @[src/main/scala/d2dadapter/ParityNegotiationSubmodule.scala 30:42]
    end else begin
      parity_req_rcv_flag_reg <= _GEN_20;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityNegotiationSubmodule.scala 32:39]
      parity_rx_enable_reg <= 1'h0; // @[src/main/scala/d2dadapter/ParityNegotiationSubmodule.scala 32:39]
    end else if (io_start_negotiation) begin // @[src/main/scala/d2dadapter/ParityNegotiationSubmodule.scala 43:31]
      parity_rx_enable_reg <= _GEN_11;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityNegotiationSubmodule.scala 33:39]
      parity_tx_enable_reg <= 1'h0; // @[src/main/scala/d2dadapter/ParityNegotiationSubmodule.scala 33:39]
    end else if (io_start_negotiation) begin // @[src/main/scala/d2dadapter/ParityNegotiationSubmodule.scala 43:31]
      parity_tx_enable_reg <= _T_18;
    end
  end
endmodule
module LinkManagementController(
  input        clock,
  input        reset,
  input  [3:0] io_fdi_lp_state_req, // @[src/main/scala/d2dadapter/LinkManagementController.scala 49:16]
  input        io_fdi_lp_linkerror, // @[src/main/scala/d2dadapter/LinkManagementController.scala 49:16]
  input        io_fdi_lp_rx_active_sts, // @[src/main/scala/d2dadapter/LinkManagementController.scala 49:16]
  output [3:0] io_fdi_pl_state_sts, // @[src/main/scala/d2dadapter/LinkManagementController.scala 49:16]
  output       io_fdi_pl_rx_active_req, // @[src/main/scala/d2dadapter/LinkManagementController.scala 49:16]
  output       io_fdi_pl_inband_pres, // @[src/main/scala/d2dadapter/LinkManagementController.scala 49:16]
  output       io_rdi_lp_linkerror, // @[src/main/scala/d2dadapter/LinkManagementController.scala 49:16]
  output [3:0] io_rdi_lp_state_req, // @[src/main/scala/d2dadapter/LinkManagementController.scala 49:16]
  input  [3:0] io_rdi_pl_state_sts, // @[src/main/scala/d2dadapter/LinkManagementController.scala 49:16]
  input        io_rdi_pl_inband_pres, // @[src/main/scala/d2dadapter/LinkManagementController.scala 49:16]
  output [5:0] io_sb_snd, // @[src/main/scala/d2dadapter/LinkManagementController.scala 49:16]
  input  [5:0] io_sb_rcv, // @[src/main/scala/d2dadapter/LinkManagementController.scala 49:16]
  input        io_sb_rdy, // @[src/main/scala/d2dadapter/LinkManagementController.scala 49:16]
  output       io_linkmgmt_stallreq, // @[src/main/scala/d2dadapter/LinkManagementController.scala 49:16]
  input        io_linkmgmt_stalldone, // @[src/main/scala/d2dadapter/LinkManagementController.scala 49:16]
  output       io_parity_rx_enable, // @[src/main/scala/d2dadapter/LinkManagementController.scala 49:16]
  output       io_parity_tx_enable // @[src/main/scala/d2dadapter/LinkManagementController.scala 49:16]
);
  wire  disabled_submodule_clock; // @[src/main/scala/d2dadapter/LinkManagementController.scala 53:36]
  wire  disabled_submodule_reset; // @[src/main/scala/d2dadapter/LinkManagementController.scala 53:36]
  wire [3:0] disabled_submodule_io_fdi_lp_state_req; // @[src/main/scala/d2dadapter/LinkManagementController.scala 53:36]
  wire [3:0] disabled_submodule_io_fdi_lp_state_req_prev; // @[src/main/scala/d2dadapter/LinkManagementController.scala 53:36]
  wire [3:0] disabled_submodule_io_link_state; // @[src/main/scala/d2dadapter/LinkManagementController.scala 53:36]
  wire  disabled_submodule_io_disabled_entry; // @[src/main/scala/d2dadapter/LinkManagementController.scala 53:36]
  wire [5:0] disabled_submodule_io_disabled_sb_snd; // @[src/main/scala/d2dadapter/LinkManagementController.scala 53:36]
  wire [5:0] disabled_submodule_io_disabled_sb_rcv; // @[src/main/scala/d2dadapter/LinkManagementController.scala 53:36]
  wire  disabled_submodule_io_disabled_sb_rdy; // @[src/main/scala/d2dadapter/LinkManagementController.scala 53:36]
  wire  linkreset_submodule_clock; // @[src/main/scala/d2dadapter/LinkManagementController.scala 55:37]
  wire  linkreset_submodule_reset; // @[src/main/scala/d2dadapter/LinkManagementController.scala 55:37]
  wire [3:0] linkreset_submodule_io_fdi_lp_state_req; // @[src/main/scala/d2dadapter/LinkManagementController.scala 55:37]
  wire [3:0] linkreset_submodule_io_fdi_lp_state_req_prev; // @[src/main/scala/d2dadapter/LinkManagementController.scala 55:37]
  wire [3:0] linkreset_submodule_io_link_state; // @[src/main/scala/d2dadapter/LinkManagementController.scala 55:37]
  wire  linkreset_submodule_io_linkreset_entry; // @[src/main/scala/d2dadapter/LinkManagementController.scala 55:37]
  wire [5:0] linkreset_submodule_io_linkreset_sb_snd; // @[src/main/scala/d2dadapter/LinkManagementController.scala 55:37]
  wire [5:0] linkreset_submodule_io_linkreset_sb_rcv; // @[src/main/scala/d2dadapter/LinkManagementController.scala 55:37]
  wire  linkreset_submodule_io_linkreset_sb_rdy; // @[src/main/scala/d2dadapter/LinkManagementController.scala 55:37]
  wire  linkinit_submodule_clock; // @[src/main/scala/d2dadapter/LinkManagementController.scala 57:36]
  wire  linkinit_submodule_reset; // @[src/main/scala/d2dadapter/LinkManagementController.scala 57:36]
  wire [3:0] linkinit_submodule_io_fdi_lp_state_req; // @[src/main/scala/d2dadapter/LinkManagementController.scala 57:36]
  wire [3:0] linkinit_submodule_io_fdi_lp_state_req_prev; // @[src/main/scala/d2dadapter/LinkManagementController.scala 57:36]
  wire  linkinit_submodule_io_fdi_lp_rxactive_sts; // @[src/main/scala/d2dadapter/LinkManagementController.scala 57:36]
  wire  linkinit_submodule_io_linkinit_fdi_pl_inband_pres; // @[src/main/scala/d2dadapter/LinkManagementController.scala 57:36]
  wire  linkinit_submodule_io_linkinit_fdi_pl_rxactive_req; // @[src/main/scala/d2dadapter/LinkManagementController.scala 57:36]
  wire [3:0] linkinit_submodule_io_rdi_pl_state_sts; // @[src/main/scala/d2dadapter/LinkManagementController.scala 57:36]
  wire  linkinit_submodule_io_rdi_pl_inband_pres; // @[src/main/scala/d2dadapter/LinkManagementController.scala 57:36]
  wire [3:0] linkinit_submodule_io_linkinit_rdi_lp_state_req; // @[src/main/scala/d2dadapter/LinkManagementController.scala 57:36]
  wire [3:0] linkinit_submodule_io_link_state; // @[src/main/scala/d2dadapter/LinkManagementController.scala 57:36]
  wire  linkinit_submodule_io_active_entry; // @[src/main/scala/d2dadapter/LinkManagementController.scala 57:36]
  wire [5:0] linkinit_submodule_io_linkinit_sb_snd; // @[src/main/scala/d2dadapter/LinkManagementController.scala 57:36]
  wire [5:0] linkinit_submodule_io_linkinit_sb_rcv; // @[src/main/scala/d2dadapter/LinkManagementController.scala 57:36]
  wire  linkinit_submodule_io_linkinit_sb_rdy; // @[src/main/scala/d2dadapter/LinkManagementController.scala 57:36]
  wire  parity_negotiation_submodule_clock; // @[src/main/scala/d2dadapter/LinkManagementController.scala 59:46]
  wire  parity_negotiation_submodule_reset; // @[src/main/scala/d2dadapter/LinkManagementController.scala 59:46]
  wire  parity_negotiation_submodule_io_start_negotiation; // @[src/main/scala/d2dadapter/LinkManagementController.scala 59:46]
  wire [5:0] parity_negotiation_submodule_io_parity_sb_rcv; // @[src/main/scala/d2dadapter/LinkManagementController.scala 59:46]
  wire [5:0] parity_negotiation_submodule_io_parity_sb_snd; // @[src/main/scala/d2dadapter/LinkManagementController.scala 59:46]
  wire  parity_negotiation_submodule_io_parity_sb_rdy; // @[src/main/scala/d2dadapter/LinkManagementController.scala 59:46]
  wire  parity_negotiation_submodule_io_parity_rx_enable; // @[src/main/scala/d2dadapter/LinkManagementController.scala 59:46]
  wire  parity_negotiation_submodule_io_parity_tx_enable; // @[src/main/scala/d2dadapter/LinkManagementController.scala 59:46]
  reg  rdi_lp_linkerror_reg; // @[src/main/scala/d2dadapter/LinkManagementController.scala 63:39]
  reg [3:0] rdi_lp_state_req_reg; // @[src/main/scala/d2dadapter/LinkManagementController.scala 64:39]
  reg  fdi_pl_rxactive_req_reg; // @[src/main/scala/d2dadapter/LinkManagementController.scala 66:42]
  reg  fdi_pl_inband_pres_reg; // @[src/main/scala/d2dadapter/LinkManagementController.scala 67:41]
  reg  linkmgmt_stallreq_reg; // @[src/main/scala/d2dadapter/LinkManagementController.scala 69:40]
  reg [3:0] fdi_lp_state_req_prev_reg; // @[src/main/scala/d2dadapter/LinkManagementController.scala 72:44]
  reg [3:0] link_state_reg; // @[src/main/scala/d2dadapter/LinkManagementController.scala 75:33]
  wire  _parity_negotiation_submodule_io_start_negotiation_T = link_state_reg == 4'hb; // @[src/main/scala/d2dadapter/LinkManagementController.scala 135:73]
  wire  linkerror_phy_sts = io_rdi_pl_state_sts == 4'ha; // @[src/main/scala/d2dadapter/LinkManagementController.scala 148:49]
  wire  stallhandler_handshake_done = linkmgmt_stallreq_reg & io_linkmgmt_stalldone; // @[src/main/scala/d2dadapter/LinkManagementController.scala 153:61]
  wire  rx_deactive = ~io_fdi_lp_rx_active_sts & ~io_fdi_pl_rx_active_req; // @[src/main/scala/d2dadapter/LinkManagementController.scala 156:50]
  wire  retrain_phy_sts = io_rdi_pl_state_sts == 4'hb; // @[src/main/scala/d2dadapter/LinkManagementController.scala 160:48]
  wire  _T = link_state_reg == 4'h1; // @[src/main/scala/d2dadapter/LinkManagementController.scala 169:25]
  wire  _linkmgmt_stallreq_reg_T = linkreset_submodule_io_linkreset_entry | disabled_submodule_io_disabled_entry; // @[src/main/scala/d2dadapter/LinkManagementController.scala 170:50]
  wire  _linkmgmt_stallreq_reg_T_1 = linkreset_submodule_io_linkreset_entry | disabled_submodule_io_disabled_entry |
    retrain_phy_sts; // @[src/main/scala/d2dadapter/LinkManagementController.scala 170:68]
  wire  _GEN_0 = link_state_reg == 4'h1 & (linkreset_submodule_io_linkreset_entry | disabled_submodule_io_disabled_entry
     | retrain_phy_sts); // @[src/main/scala/d2dadapter/LinkManagementController.scala 169:46 170:31 172:31]
  wire  _T_7 = link_state_reg == 4'h0; // @[src/main/scala/d2dadapter/LinkManagementController.scala 191:25]
  wire  _T_8 = link_state_reg == 4'ha; // @[src/main/scala/d2dadapter/LinkManagementController.scala 197:31]
  wire  _T_9 = link_state_reg == 4'hc; // @[src/main/scala/d2dadapter/LinkManagementController.scala 198:32]
  wire  _T_10 = link_state_reg == 4'ha | _T_9; // @[src/main/scala/d2dadapter/LinkManagementController.scala 197:54]
  wire  _T_11 = link_state_reg == 4'h9; // @[src/main/scala/d2dadapter/LinkManagementController.scala 199:32]
  wire  _T_12 = _T_10 | _T_11; // @[src/main/scala/d2dadapter/LinkManagementController.scala 198:54]
  wire  _T_14 = disabled_submodule_io_disabled_sb_snd != 6'h0; // @[src/main/scala/d2dadapter/LinkManagementController.scala 216:30]
  wire  _T_15 = linkreset_submodule_io_linkreset_sb_snd != 6'h0; // @[src/main/scala/d2dadapter/LinkManagementController.scala 219:37]
  wire [5:0] _GEN_8 = linkinit_submodule_io_linkinit_sb_snd != 6'h0 ? linkinit_submodule_io_linkinit_sb_snd : 6'h0; // @[src/main/scala/d2dadapter/LinkManagementController.scala 222:60 223:23 226:23]
  wire  _GEN_9 = linkinit_submodule_io_linkinit_sb_snd != 6'h0 & io_sb_rdy; // @[src/main/scala/d2dadapter/LinkManagementController.scala 212:21 222:60 224:29]
  wire [5:0] _GEN_10 = linkreset_submodule_io_linkreset_sb_snd != 6'h0 ? linkreset_submodule_io_linkreset_sb_snd :
    _GEN_8; // @[src/main/scala/d2dadapter/LinkManagementController.scala 219:61 220:23]
  wire  _GEN_11 = linkreset_submodule_io_linkreset_sb_snd != 6'h0 & io_sb_rdy; // @[src/main/scala/d2dadapter/LinkManagementController.scala 210:22 219:61 221:30]
  wire  _GEN_12 = linkreset_submodule_io_linkreset_sb_snd != 6'h0 ? 1'h0 : _GEN_9; // @[src/main/scala/d2dadapter/LinkManagementController.scala 212:21 219:61]
  wire [5:0] _GEN_13 = disabled_submodule_io_disabled_sb_snd != 6'h0 ? disabled_submodule_io_disabled_sb_snd : _GEN_10; // @[src/main/scala/d2dadapter/LinkManagementController.scala 216:54 217:23]
  wire  _GEN_14 = disabled_submodule_io_disabled_sb_snd != 6'h0 & io_sb_rdy; // @[src/main/scala/d2dadapter/LinkManagementController.scala 211:21 216:54 218:29]
  wire  _GEN_15 = disabled_submodule_io_disabled_sb_snd != 6'h0 ? 1'h0 : _GEN_11; // @[src/main/scala/d2dadapter/LinkManagementController.scala 210:22 216:54]
  wire  _GEN_16 = disabled_submodule_io_disabled_sb_snd != 6'h0 ? 1'h0 : _GEN_12; // @[src/main/scala/d2dadapter/LinkManagementController.scala 212:21 216:54]
  wire [5:0] _GEN_17 = _T_15 ? linkreset_submodule_io_linkreset_sb_snd : 6'h0; // @[src/main/scala/d2dadapter/LinkManagementController.scala 232:61 233:23 236:23]
  wire [5:0] _GEN_19 = _T_14 ? disabled_submodule_io_disabled_sb_snd : _GEN_17; // @[src/main/scala/d2dadapter/LinkManagementController.scala 229:54 230:23]
  wire [5:0] _GEN_22 = parity_negotiation_submodule_io_parity_sb_snd != 6'h0 ?
    parity_negotiation_submodule_io_parity_sb_snd : 6'h0; // @[src/main/scala/d2dadapter/LinkManagementController.scala 245:70 246:23 249:23]
  wire  _GEN_23 = parity_negotiation_submodule_io_parity_sb_snd != 6'h0 & io_sb_rdy; // @[src/main/scala/d2dadapter/LinkManagementController.scala 213:31 245:70 247:39]
  wire [5:0] _GEN_24 = _T_15 ? linkreset_submodule_io_linkreset_sb_snd : _GEN_22; // @[src/main/scala/d2dadapter/LinkManagementController.scala 242:61 243:23]
  wire  _GEN_26 = _T_15 ? 1'h0 : _GEN_23; // @[src/main/scala/d2dadapter/LinkManagementController.scala 213:31 242:61]
  wire [5:0] _GEN_27 = _T_14 ? disabled_submodule_io_disabled_sb_snd : _GEN_24; // @[src/main/scala/d2dadapter/LinkManagementController.scala 239:54 240:23]
  wire  _GEN_30 = _T_14 ? 1'h0 : _GEN_26; // @[src/main/scala/d2dadapter/LinkManagementController.scala 213:31 239:54]
  wire [5:0] _GEN_31 = _T_14 ? disabled_submodule_io_disabled_sb_snd : 6'h0; // @[src/main/scala/d2dadapter/LinkManagementController.scala 252:54 253:23 256:23]
  wire [5:0] _GEN_34 = _T_11 ? _GEN_31 : 6'h0; // @[src/main/scala/d2dadapter/LinkManagementController.scala 251:54]
  wire  _GEN_35 = _T_11 & _GEN_14; // @[src/main/scala/d2dadapter/LinkManagementController.scala 211:21 251:54]
  wire [5:0] _GEN_36 = _parity_negotiation_submodule_io_start_negotiation_T ? _GEN_27 : _GEN_34; // @[src/main/scala/d2dadapter/LinkManagementController.scala 238:52]
  wire  _GEN_37 = _parity_negotiation_submodule_io_start_negotiation_T ? _GEN_14 : _GEN_35; // @[src/main/scala/d2dadapter/LinkManagementController.scala 238:52]
  wire  _GEN_38 = _parity_negotiation_submodule_io_start_negotiation_T & _GEN_15; // @[src/main/scala/d2dadapter/LinkManagementController.scala 210:22 238:52]
  wire  _GEN_39 = _parity_negotiation_submodule_io_start_negotiation_T & _GEN_30; // @[src/main/scala/d2dadapter/LinkManagementController.scala 213:31 238:52]
  wire [5:0] _GEN_40 = _T ? _GEN_19 : _GEN_36; // @[src/main/scala/d2dadapter/LinkManagementController.scala 228:51]
  wire  _GEN_41 = _T ? _GEN_14 : _GEN_37; // @[src/main/scala/d2dadapter/LinkManagementController.scala 228:51]
  wire  _GEN_42 = _T ? _GEN_15 : _GEN_38; // @[src/main/scala/d2dadapter/LinkManagementController.scala 228:51]
  wire  _GEN_43 = _T ? 1'h0 : _GEN_39; // @[src/main/scala/d2dadapter/LinkManagementController.scala 213:31 228:51]
  wire  _T_33 = io_fdi_lp_state_req == 4'h1; // @[src/main/scala/d2dadapter/LinkManagementController.scala 275:34]
  wire  _T_35 = io_fdi_lp_state_req == 4'h1 & linkerror_phy_sts; // @[src/main/scala/d2dadapter/LinkManagementController.scala 275:57]
  wire [3:0] _GEN_51 = _T_33 ? 4'h1 : 4'hc; // @[src/main/scala/d2dadapter/LinkManagementController.scala 282:58 283:34 285:34]
  wire [3:0] _GEN_52 = _T_33 ? 4'h1 : 4'h9; // @[src/main/scala/d2dadapter/LinkManagementController.scala 288:58 289:34 291:34]
  wire [3:0] _GEN_53 = _T_11 ? _GEN_52 : rdi_lp_state_req_reg; // @[src/main/scala/d2dadapter/LinkManagementController.scala 287:55 64:39]
  wire [3:0] _GEN_54 = _T_9 ? _GEN_51 : _GEN_53; // @[src/main/scala/d2dadapter/LinkManagementController.scala 281:54]
  wire [3:0] _GEN_55 = _T_8 ? {{3'd0}, _T_35} : _GEN_54; // @[src/main/scala/d2dadapter/LinkManagementController.scala 273:55]
  wire  _T_43 = disabled_submodule_io_disabled_entry & rx_deactive; // @[src/main/scala/d2dadapter/LinkManagementController.scala 303:39]
  wire  _T_44 = linkreset_submodule_io_linkreset_entry & rx_deactive; // @[src/main/scala/d2dadapter/LinkManagementController.scala 305:40]
  wire [3:0] _GEN_59 = linkinit_submodule_io_active_entry ? 4'h1 : link_state_reg; // @[src/main/scala/d2dadapter/LinkManagementController.scala 307:38 308:32 310:32]
  wire [3:0] _GEN_60 = linkreset_submodule_io_linkreset_entry & rx_deactive ? 4'h9 : _GEN_59; // @[src/main/scala/d2dadapter/LinkManagementController.scala 305:56 306:32]
  wire [3:0] _GEN_63 = retrain_phy_sts & rx_deactive & stallhandler_handshake_done ? 4'hb : link_state_reg; // @[src/main/scala/d2dadapter/LinkManagementController.scala 321:87 322:32 324:32]
  wire [3:0] _GEN_64 = _T_44 & stallhandler_handshake_done ? 4'h9 : _GEN_63; // @[src/main/scala/d2dadapter/LinkManagementController.scala 319:87 320:32]
  wire [3:0] _GEN_65 = _T_43 & stallhandler_handshake_done ? 4'hc : _GEN_64; // @[src/main/scala/d2dadapter/LinkManagementController.scala 317:86 318:32]
  wire [3:0] _GEN_67 = linkreset_submodule_io_linkreset_entry ? 4'h9 : link_state_reg; // @[src/main/scala/d2dadapter/LinkManagementController.scala 335:41 336:32 338:32]
  wire [3:0] _GEN_68 = disabled_submodule_io_disabled_entry ? 4'hc : _GEN_67; // @[src/main/scala/d2dadapter/LinkManagementController.scala 333:40 334:32]
  wire [3:0] _GEN_69 = linkerror_phy_sts ? 4'ha : _GEN_68; // @[src/main/scala/d2dadapter/LinkManagementController.scala 331:37 332:32]
  wire  _T_62 = _T_33 | linkerror_phy_sts; // @[src/main/scala/d2dadapter/LinkManagementController.scala 345:62]
  wire [3:0] _GEN_70 = _T_62 & rx_deactive ? 4'h0 : link_state_reg; // @[src/main/scala/d2dadapter/LinkManagementController.scala 346:79 347:36 349:36]
  wire  _T_68 = io_rdi_pl_state_sts == 4'h0; // @[src/main/scala/d2dadapter/LinkManagementController.scala 357:45]
  wire  _T_69 = _T_33 | _T_68; // @[src/main/scala/d2dadapter/LinkManagementController.scala 356:67]
  wire [3:0] _GEN_71 = _T_69 ? 4'h0 : link_state_reg; // @[src/main/scala/d2dadapter/LinkManagementController.scala 357:65 358:32 360:32]
  wire [3:0] _GEN_72 = linkerror_phy_sts ? 4'ha : _GEN_71; // @[src/main/scala/d2dadapter/LinkManagementController.scala 354:37 355:32]
  wire [3:0] _GEN_74 = _T_43 ? 4'hc : _GEN_71; // @[src/main/scala/d2dadapter/LinkManagementController.scala 367:55 368:32]
  wire [3:0] _GEN_75 = linkerror_phy_sts ? 4'ha : _GEN_74; // @[src/main/scala/d2dadapter/LinkManagementController.scala 365:37 366:32]
  wire [3:0] _GEN_76 = 4'h9 == link_state_reg ? _GEN_75 : link_state_reg; // @[src/main/scala/d2dadapter/LinkManagementController.scala 297:28 75:33]
  wire [3:0] _GEN_77 = 4'hc == link_state_reg ? _GEN_72 : _GEN_76; // @[src/main/scala/d2dadapter/LinkManagementController.scala 297:28]
  wire [3:0] _GEN_78 = 4'ha == link_state_reg ? _GEN_70 : _GEN_77; // @[src/main/scala/d2dadapter/LinkManagementController.scala 297:28]
  LinkDisabledSubmodule disabled_submodule ( // @[src/main/scala/d2dadapter/LinkManagementController.scala 53:36]
    .clock(disabled_submodule_clock),
    .reset(disabled_submodule_reset),
    .io_fdi_lp_state_req(disabled_submodule_io_fdi_lp_state_req),
    .io_fdi_lp_state_req_prev(disabled_submodule_io_fdi_lp_state_req_prev),
    .io_link_state(disabled_submodule_io_link_state),
    .io_disabled_entry(disabled_submodule_io_disabled_entry),
    .io_disabled_sb_snd(disabled_submodule_io_disabled_sb_snd),
    .io_disabled_sb_rcv(disabled_submodule_io_disabled_sb_rcv),
    .io_disabled_sb_rdy(disabled_submodule_io_disabled_sb_rdy)
  );
  LinkResetSubmodule linkreset_submodule ( // @[src/main/scala/d2dadapter/LinkManagementController.scala 55:37]
    .clock(linkreset_submodule_clock),
    .reset(linkreset_submodule_reset),
    .io_fdi_lp_state_req(linkreset_submodule_io_fdi_lp_state_req),
    .io_fdi_lp_state_req_prev(linkreset_submodule_io_fdi_lp_state_req_prev),
    .io_link_state(linkreset_submodule_io_link_state),
    .io_linkreset_entry(linkreset_submodule_io_linkreset_entry),
    .io_linkreset_sb_snd(linkreset_submodule_io_linkreset_sb_snd),
    .io_linkreset_sb_rcv(linkreset_submodule_io_linkreset_sb_rcv),
    .io_linkreset_sb_rdy(linkreset_submodule_io_linkreset_sb_rdy)
  );
  LinkInitSubmodule linkinit_submodule ( // @[src/main/scala/d2dadapter/LinkManagementController.scala 57:36]
    .clock(linkinit_submodule_clock),
    .reset(linkinit_submodule_reset),
    .io_fdi_lp_state_req(linkinit_submodule_io_fdi_lp_state_req),
    .io_fdi_lp_state_req_prev(linkinit_submodule_io_fdi_lp_state_req_prev),
    .io_fdi_lp_rxactive_sts(linkinit_submodule_io_fdi_lp_rxactive_sts),
    .io_linkinit_fdi_pl_inband_pres(linkinit_submodule_io_linkinit_fdi_pl_inband_pres),
    .io_linkinit_fdi_pl_rxactive_req(linkinit_submodule_io_linkinit_fdi_pl_rxactive_req),
    .io_rdi_pl_state_sts(linkinit_submodule_io_rdi_pl_state_sts),
    .io_rdi_pl_inband_pres(linkinit_submodule_io_rdi_pl_inband_pres),
    .io_linkinit_rdi_lp_state_req(linkinit_submodule_io_linkinit_rdi_lp_state_req),
    .io_link_state(linkinit_submodule_io_link_state),
    .io_active_entry(linkinit_submodule_io_active_entry),
    .io_linkinit_sb_snd(linkinit_submodule_io_linkinit_sb_snd),
    .io_linkinit_sb_rcv(linkinit_submodule_io_linkinit_sb_rcv),
    .io_linkinit_sb_rdy(linkinit_submodule_io_linkinit_sb_rdy)
  );
  ParityNegotiationSubmodule parity_negotiation_submodule ( // @[src/main/scala/d2dadapter/LinkManagementController.scala 59:46]
    .clock(parity_negotiation_submodule_clock),
    .reset(parity_negotiation_submodule_reset),
    .io_start_negotiation(parity_negotiation_submodule_io_start_negotiation),
    .io_parity_sb_rcv(parity_negotiation_submodule_io_parity_sb_rcv),
    .io_parity_sb_snd(parity_negotiation_submodule_io_parity_sb_snd),
    .io_parity_sb_rdy(parity_negotiation_submodule_io_parity_sb_rdy),
    .io_parity_rx_enable(parity_negotiation_submodule_io_parity_rx_enable),
    .io_parity_tx_enable(parity_negotiation_submodule_io_parity_tx_enable)
  );
  assign io_fdi_pl_state_sts = link_state_reg; // @[src/main/scala/d2dadapter/LinkManagementController.scala 82:25]
  assign io_fdi_pl_rx_active_req = fdi_pl_rxactive_req_reg; // @[src/main/scala/d2dadapter/LinkManagementController.scala 83:29]
  assign io_fdi_pl_inband_pres = fdi_pl_inband_pres_reg; // @[src/main/scala/d2dadapter/LinkManagementController.scala 84:27]
  assign io_rdi_lp_linkerror = rdi_lp_linkerror_reg; // @[src/main/scala/d2dadapter/LinkManagementController.scala 79:25]
  assign io_rdi_lp_state_req = rdi_lp_state_req_reg; // @[src/main/scala/d2dadapter/LinkManagementController.scala 80:25]
  assign io_sb_snd = _T_7 ? _GEN_13 : _GEN_40; // @[src/main/scala/d2dadapter/LinkManagementController.scala 215:44]
  assign io_linkmgmt_stallreq = linkmgmt_stallreq_reg; // @[src/main/scala/d2dadapter/LinkManagementController.scala 86:26]
  assign io_parity_rx_enable = parity_negotiation_submodule_io_parity_rx_enable; // @[src/main/scala/d2dadapter/LinkManagementController.scala 133:25]
  assign io_parity_tx_enable = parity_negotiation_submodule_io_parity_tx_enable; // @[src/main/scala/d2dadapter/LinkManagementController.scala 132:25]
  assign disabled_submodule_clock = clock;
  assign disabled_submodule_reset = reset;
  assign disabled_submodule_io_fdi_lp_state_req = io_fdi_lp_state_req; // @[src/main/scala/d2dadapter/LinkManagementController.scala 93:44]
  assign disabled_submodule_io_fdi_lp_state_req_prev = fdi_lp_state_req_prev_reg; // @[src/main/scala/d2dadapter/LinkManagementController.scala 94:49]
  assign disabled_submodule_io_link_state = link_state_reg; // @[src/main/scala/d2dadapter/LinkManagementController.scala 95:38]
  assign disabled_submodule_io_disabled_sb_rcv = io_sb_rcv; // @[src/main/scala/d2dadapter/LinkManagementController.scala 100:43]
  assign disabled_submodule_io_disabled_sb_rdy = _T_7 ? _GEN_14 : _GEN_41; // @[src/main/scala/d2dadapter/LinkManagementController.scala 215:44]
  assign linkreset_submodule_clock = clock;
  assign linkreset_submodule_reset = reset;
  assign linkreset_submodule_io_fdi_lp_state_req = io_fdi_lp_state_req; // @[src/main/scala/d2dadapter/LinkManagementController.scala 104:45]
  assign linkreset_submodule_io_fdi_lp_state_req_prev = fdi_lp_state_req_prev_reg; // @[src/main/scala/d2dadapter/LinkManagementController.scala 105:50]
  assign linkreset_submodule_io_link_state = link_state_reg; // @[src/main/scala/d2dadapter/LinkManagementController.scala 106:39]
  assign linkreset_submodule_io_linkreset_sb_rcv = io_sb_rcv; // @[src/main/scala/d2dadapter/LinkManagementController.scala 111:45]
  assign linkreset_submodule_io_linkreset_sb_rdy = _T_7 ? _GEN_15 : _GEN_42; // @[src/main/scala/d2dadapter/LinkManagementController.scala 215:44]
  assign linkinit_submodule_clock = clock;
  assign linkinit_submodule_reset = reset;
  assign linkinit_submodule_io_fdi_lp_state_req = io_fdi_lp_state_req; // @[src/main/scala/d2dadapter/LinkManagementController.scala 115:44]
  assign linkinit_submodule_io_fdi_lp_state_req_prev = fdi_lp_state_req_prev_reg; // @[src/main/scala/d2dadapter/LinkManagementController.scala 116:49]
  assign linkinit_submodule_io_fdi_lp_rxactive_sts = io_fdi_lp_rx_active_sts; // @[src/main/scala/d2dadapter/LinkManagementController.scala 117:47]
  assign linkinit_submodule_io_rdi_pl_state_sts = io_rdi_pl_state_sts; // @[src/main/scala/d2dadapter/LinkManagementController.scala 118:44]
  assign linkinit_submodule_io_rdi_pl_inband_pres = io_rdi_pl_inband_pres; // @[src/main/scala/d2dadapter/LinkManagementController.scala 119:46]
  assign linkinit_submodule_io_link_state = link_state_reg; // @[src/main/scala/d2dadapter/LinkManagementController.scala 120:38]
  assign linkinit_submodule_io_linkinit_sb_rcv = io_sb_rcv; // @[src/main/scala/d2dadapter/LinkManagementController.scala 128:43]
  assign linkinit_submodule_io_linkinit_sb_rdy = _T_7 & _GEN_16; // @[src/main/scala/d2dadapter/LinkManagementController.scala 212:21 215:44]
  assign parity_negotiation_submodule_clock = clock;
  assign parity_negotiation_submodule_reset = reset;
  assign parity_negotiation_submodule_io_start_negotiation = link_state_reg == 4'hb; // @[src/main/scala/d2dadapter/LinkManagementController.scala 135:73]
  assign parity_negotiation_submodule_io_parity_sb_rcv = io_sb_rcv; // @[src/main/scala/d2dadapter/LinkManagementController.scala 137:51]
  assign parity_negotiation_submodule_io_parity_sb_rdy = _T_7 ? 1'h0 : _GEN_43; // @[src/main/scala/d2dadapter/LinkManagementController.scala 213:31 215:44]
  always @(posedge clock) begin
    if (reset) begin // @[src/main/scala/d2dadapter/LinkManagementController.scala 63:39]
      rdi_lp_linkerror_reg <= 1'h0; // @[src/main/scala/d2dadapter/LinkManagementController.scala 63:39]
    end else begin
      rdi_lp_linkerror_reg <= io_fdi_lp_linkerror; // @[src/main/scala/d2dadapter/LinkManagementController.scala 89:26]
    end
    if (reset) begin // @[src/main/scala/d2dadapter/LinkManagementController.scala 64:39]
      rdi_lp_state_req_reg <= 4'h0; // @[src/main/scala/d2dadapter/LinkManagementController.scala 64:39]
    end else if (_T_7) begin // @[src/main/scala/d2dadapter/LinkManagementController.scala 265:45]
      rdi_lp_state_req_reg <= linkinit_submodule_io_linkinit_rdi_lp_state_req; // @[src/main/scala/d2dadapter/LinkManagementController.scala 266:30]
    end else if (_T) begin // @[src/main/scala/d2dadapter/LinkManagementController.scala 267:52]
      if (retrain_phy_sts) begin // @[src/main/scala/d2dadapter/LinkManagementController.scala 268:31]
        rdi_lp_state_req_reg <= 4'hb; // @[src/main/scala/d2dadapter/LinkManagementController.scala 269:34]
      end
    end else if (_parity_negotiation_submodule_io_start_negotiation_T) begin // @[src/main/scala/d2dadapter/LinkManagementController.scala 271:53]
      rdi_lp_state_req_reg <= 4'h0; // @[src/main/scala/d2dadapter/LinkManagementController.scala 272:30]
    end else begin
      rdi_lp_state_req_reg <= _GEN_55;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/LinkManagementController.scala 66:42]
      fdi_pl_rxactive_req_reg <= 1'h0; // @[src/main/scala/d2dadapter/LinkManagementController.scala 66:42]
    end else if (_T) begin // @[src/main/scala/d2dadapter/LinkManagementController.scala 176:45]
      if (_linkmgmt_stallreq_reg_T_1 | linkerror_phy_sts) begin // @[src/main/scala/d2dadapter/LinkManagementController.scala 177:88]
        fdi_pl_rxactive_req_reg <= 1'h0; // @[src/main/scala/d2dadapter/LinkManagementController.scala 178:37]
      end else begin
        fdi_pl_rxactive_req_reg <= 1'h1; // @[src/main/scala/d2dadapter/LinkManagementController.scala 180:37]
      end
    end else if (_linkmgmt_stallreq_reg_T | linkerror_phy_sts) begin // @[src/main/scala/d2dadapter/LinkManagementController.scala 183:69]
      fdi_pl_rxactive_req_reg <= 1'h0; // @[src/main/scala/d2dadapter/LinkManagementController.scala 184:37]
    end else begin
      fdi_pl_rxactive_req_reg <= linkinit_submodule_io_linkinit_fdi_pl_rxactive_req; // @[src/main/scala/d2dadapter/LinkManagementController.scala 186:37]
    end
    if (reset) begin // @[src/main/scala/d2dadapter/LinkManagementController.scala 67:41]
      fdi_pl_inband_pres_reg <= 1'h0; // @[src/main/scala/d2dadapter/LinkManagementController.scala 67:41]
    end else if (link_state_reg == 4'h0) begin // @[src/main/scala/d2dadapter/LinkManagementController.scala 191:44]
      if (linkerror_phy_sts) begin // @[src/main/scala/d2dadapter/LinkManagementController.scala 192:32]
        fdi_pl_inband_pres_reg <= 1'h0; // @[src/main/scala/d2dadapter/LinkManagementController.scala 193:36]
      end else begin
        fdi_pl_inband_pres_reg <= linkinit_submodule_io_linkinit_fdi_pl_inband_pres; // @[src/main/scala/d2dadapter/LinkManagementController.scala 195:36]
      end
    end else if (_T_12) begin // @[src/main/scala/d2dadapter/LinkManagementController.scala 199:55]
      fdi_pl_inband_pres_reg <= 1'h0; // @[src/main/scala/d2dadapter/LinkManagementController.scala 200:32]
    end else if (linkerror_phy_sts) begin // @[src/main/scala/d2dadapter/LinkManagementController.scala 202:32]
      fdi_pl_inband_pres_reg <= 1'h0; // @[src/main/scala/d2dadapter/LinkManagementController.scala 203:36]
    end else begin
      fdi_pl_inband_pres_reg <= 1'h1; // @[src/main/scala/d2dadapter/LinkManagementController.scala 205:36]
    end
    if (reset) begin // @[src/main/scala/d2dadapter/LinkManagementController.scala 69:40]
      linkmgmt_stallreq_reg <= 1'h0; // @[src/main/scala/d2dadapter/LinkManagementController.scala 69:40]
    end else begin
      linkmgmt_stallreq_reg <= _GEN_0;
    end
    fdi_lp_state_req_prev_reg <= io_fdi_lp_state_req; // @[src/main/scala/d2dadapter/LinkManagementController.scala 72:44]
    if (reset) begin // @[src/main/scala/d2dadapter/LinkManagementController.scala 75:33]
      link_state_reg <= 4'h0; // @[src/main/scala/d2dadapter/LinkManagementController.scala 75:33]
    end else if (4'h0 == link_state_reg) begin // @[src/main/scala/d2dadapter/LinkManagementController.scala 297:28]
      if (linkerror_phy_sts) begin // @[src/main/scala/d2dadapter/LinkManagementController.scala 300:37]
        link_state_reg <= 4'ha; // @[src/main/scala/d2dadapter/LinkManagementController.scala 302:32]
      end else if (disabled_submodule_io_disabled_entry & rx_deactive) begin // @[src/main/scala/d2dadapter/LinkManagementController.scala 303:55]
        link_state_reg <= 4'hc; // @[src/main/scala/d2dadapter/LinkManagementController.scala 304:32]
      end else begin
        link_state_reg <= _GEN_60;
      end
    end else if (4'h1 == link_state_reg) begin // @[src/main/scala/d2dadapter/LinkManagementController.scala 297:28]
      if (linkerror_phy_sts) begin // @[src/main/scala/d2dadapter/LinkManagementController.scala 315:37]
        link_state_reg <= 4'ha; // @[src/main/scala/d2dadapter/LinkManagementController.scala 316:32]
      end else begin
        link_state_reg <= _GEN_65;
      end
    end else if (4'hb == link_state_reg) begin // @[src/main/scala/d2dadapter/LinkManagementController.scala 297:28]
      link_state_reg <= _GEN_69;
    end else begin
      link_state_reg <= _GEN_78;
    end
  end
endmodule
module FDIStallHandler(
  input   clock,
  input   reset,
  input   io_linkmgmt_stallreq, // @[src/main/scala/d2dadapter/StallHandler.scala 27:16]
  output  io_linkmgmt_stalldone, // @[src/main/scala/d2dadapter/StallHandler.scala 27:16]
  output  io_fdi_pl_stallreq, // @[src/main/scala/d2dadapter/StallHandler.scala 27:16]
  input   io_fdi_lp_stallack // @[src/main/scala/d2dadapter/StallHandler.scala 27:16]
);
  reg  fdi_lp_stallreq_reg; // @[src/main/scala/d2dadapter/StallHandler.scala 28:38]
  reg  linkmgmt_stalldone_reg; // @[src/main/scala/d2dadapter/StallHandler.scala 29:41]
  reg [1:0] stall_handshake_state_reg; // @[src/main/scala/d2dadapter/StallHandler.scala 34:44]
  wire  _T_3 = ~io_fdi_lp_stallack; // @[src/main/scala/d2dadapter/StallHandler.scala 42:42]
  wire  _T_4 = io_linkmgmt_stallreq & ~io_fdi_lp_stallack; // @[src/main/scala/d2dadapter/StallHandler.scala 42:39]
  wire  _GEN_3 = io_fdi_lp_stallack ? 1'h0 : 1'h1; // @[src/main/scala/d2dadapter/StallHandler.scala 53:37 54:37 58:37]
  wire [1:0] _GEN_8 = _T_3 ? 2'h3 : stall_handshake_state_reg; // @[src/main/scala/d2dadapter/StallHandler.scala 64:38 67:43 71:43]
  wire  _GEN_10 = ~io_linkmgmt_stallreq ? 1'h0 : 1'h1; // @[src/main/scala/d2dadapter/StallHandler.scala 75:40 77:40 81:40]
  wire [1:0] _GEN_11 = ~io_linkmgmt_stallreq ? 2'h0 : stall_handshake_state_reg; // @[src/main/scala/d2dadapter/StallHandler.scala 75:40 78:43 82:43]
  wire  _GEN_13 = 2'h3 == stall_handshake_state_reg ? _GEN_10 : linkmgmt_stalldone_reg; // @[src/main/scala/d2dadapter/StallHandler.scala 38:28 40:38]
  wire [1:0] _GEN_14 = 2'h3 == stall_handshake_state_reg ? _GEN_11 : stall_handshake_state_reg; // @[src/main/scala/d2dadapter/StallHandler.scala 36:31 40:38]
  assign io_linkmgmt_stalldone = linkmgmt_stalldone_reg; // @[src/main/scala/d2dadapter/StallHandler.scala 32:27]
  assign io_fdi_pl_stallreq = fdi_lp_stallreq_reg; // @[src/main/scala/d2dadapter/StallHandler.scala 31:24]
  always @(posedge clock) begin
    if (reset) begin // @[src/main/scala/d2dadapter/StallHandler.scala 28:38]
      fdi_lp_stallreq_reg <= 1'h0; // @[src/main/scala/d2dadapter/StallHandler.scala 28:38]
    end else if (2'h0 == stall_handshake_state_reg) begin // @[src/main/scala/d2dadapter/StallHandler.scala 40:38]
      fdi_lp_stallreq_reg <= _T_4;
    end else begin
      fdi_lp_stallreq_reg <= 2'h1 == stall_handshake_state_reg & _GEN_3;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/StallHandler.scala 29:41]
      linkmgmt_stalldone_reg <= 1'h0; // @[src/main/scala/d2dadapter/StallHandler.scala 29:41]
    end else if (2'h0 == stall_handshake_state_reg) begin // @[src/main/scala/d2dadapter/StallHandler.scala 40:38]
      linkmgmt_stalldone_reg <= 1'h0;
    end else if (2'h1 == stall_handshake_state_reg) begin // @[src/main/scala/d2dadapter/StallHandler.scala 40:38]
      linkmgmt_stalldone_reg <= 1'h0;
    end else if (2'h2 == stall_handshake_state_reg) begin // @[src/main/scala/d2dadapter/StallHandler.scala 40:38]
      linkmgmt_stalldone_reg <= _T_3;
    end else begin
      linkmgmt_stalldone_reg <= _GEN_13;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/StallHandler.scala 34:44]
      stall_handshake_state_reg <= 2'h0; // @[src/main/scala/d2dadapter/StallHandler.scala 34:44]
    end else if (2'h0 == stall_handshake_state_reg) begin // @[src/main/scala/d2dadapter/StallHandler.scala 40:38]
      if (io_linkmgmt_stallreq & ~io_fdi_lp_stallack) begin // @[src/main/scala/d2dadapter/StallHandler.scala 42:62]
        stall_handshake_state_reg <= 2'h1; // @[src/main/scala/d2dadapter/StallHandler.scala 45:43]
      end
    end else if (2'h1 == stall_handshake_state_reg) begin // @[src/main/scala/d2dadapter/StallHandler.scala 40:38]
      if (io_fdi_lp_stallack) begin // @[src/main/scala/d2dadapter/StallHandler.scala 53:37]
        stall_handshake_state_reg <= 2'h2; // @[src/main/scala/d2dadapter/StallHandler.scala 56:43]
      end
    end else if (2'h2 == stall_handshake_state_reg) begin // @[src/main/scala/d2dadapter/StallHandler.scala 40:38]
      stall_handshake_state_reg <= _GEN_8;
    end else begin
      stall_handshake_state_reg <= _GEN_14;
    end
  end
endmodule
module RDIStallHandler(
  input   clock,
  input   reset,
  output  io_mainband_stallreq, // @[src/main/scala/d2dadapter/StallHandler.scala 90:16]
  input   io_mainband_stalldone, // @[src/main/scala/d2dadapter/StallHandler.scala 90:16]
  input   io_rdi_pl_stallreq, // @[src/main/scala/d2dadapter/StallHandler.scala 90:16]
  output  io_rdi_lp_stallack // @[src/main/scala/d2dadapter/StallHandler.scala 90:16]
);
  reg  rdi_lp_stallack_reg; // @[src/main/scala/d2dadapter/StallHandler.scala 92:38]
  reg  mainband_stallreq_reg; // @[src/main/scala/d2dadapter/StallHandler.scala 93:40]
  reg [1:0] stall_handshake_state_reg; // @[src/main/scala/d2dadapter/StallHandler.scala 94:44]
  wire  _GEN_6 = ~io_rdi_pl_stallreq ? 1'h0 : 1'h1; // @[src/main/scala/d2dadapter/StallHandler.scala 123:38 124:39 128:39]
  wire [1:0] _GEN_7 = ~io_rdi_pl_stallreq ? 2'h0 : stall_handshake_state_reg; // @[src/main/scala/d2dadapter/StallHandler.scala 123:38 126:43 130:43]
  wire  _GEN_8 = 2'h2 == stall_handshake_state_reg ? _GEN_6 : mainband_stallreq_reg; // @[src/main/scala/d2dadapter/StallHandler.scala 99:38 93:40]
  assign io_mainband_stallreq = mainband_stallreq_reg; // @[src/main/scala/d2dadapter/StallHandler.scala 97:26]
  assign io_rdi_lp_stallack = rdi_lp_stallack_reg; // @[src/main/scala/d2dadapter/StallHandler.scala 96:24]
  always @(posedge clock) begin
    if (reset) begin // @[src/main/scala/d2dadapter/StallHandler.scala 92:38]
      rdi_lp_stallack_reg <= 1'h0; // @[src/main/scala/d2dadapter/StallHandler.scala 92:38]
    end else if (2'h0 == stall_handshake_state_reg) begin // @[src/main/scala/d2dadapter/StallHandler.scala 99:38]
      rdi_lp_stallack_reg <= 1'h0;
    end else if (2'h1 == stall_handshake_state_reg) begin // @[src/main/scala/d2dadapter/StallHandler.scala 99:38]
      rdi_lp_stallack_reg <= io_mainband_stalldone;
    end else if (2'h2 == stall_handshake_state_reg) begin // @[src/main/scala/d2dadapter/StallHandler.scala 99:38]
      rdi_lp_stallack_reg <= _GEN_6;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/StallHandler.scala 93:40]
      mainband_stallreq_reg <= 1'h0; // @[src/main/scala/d2dadapter/StallHandler.scala 93:40]
    end else if (2'h0 == stall_handshake_state_reg) begin // @[src/main/scala/d2dadapter/StallHandler.scala 99:38]
      mainband_stallreq_reg <= io_rdi_pl_stallreq;
    end else begin
      mainband_stallreq_reg <= 2'h1 == stall_handshake_state_reg | _GEN_8;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/StallHandler.scala 94:44]
      stall_handshake_state_reg <= 2'h0; // @[src/main/scala/d2dadapter/StallHandler.scala 94:44]
    end else if (2'h0 == stall_handshake_state_reg) begin // @[src/main/scala/d2dadapter/StallHandler.scala 99:38]
      if (io_rdi_pl_stallreq) begin // @[src/main/scala/d2dadapter/StallHandler.scala 101:37]
        stall_handshake_state_reg <= 2'h1; // @[src/main/scala/d2dadapter/StallHandler.scala 104:43]
      end
    end else if (2'h1 == stall_handshake_state_reg) begin // @[src/main/scala/d2dadapter/StallHandler.scala 99:38]
      if (io_mainband_stalldone) begin // @[src/main/scala/d2dadapter/StallHandler.scala 112:40]
        stall_handshake_state_reg <= 2'h2; // @[src/main/scala/d2dadapter/StallHandler.scala 115:43]
      end
    end else if (2'h2 == stall_handshake_state_reg) begin // @[src/main/scala/d2dadapter/StallHandler.scala 99:38]
      stall_handshake_state_reg <= _GEN_7;
    end
  end
endmodule
module SidebandSerializer(
  input          clock,
  input          reset,
  output         io_in_ready, // @[src/main/scala/sideband/sidebandNode.scala 164:14]
  input          io_in_valid, // @[src/main/scala/sideband/sidebandNode.scala 164:14]
  input  [127:0] io_in_bits, // @[src/main/scala/sideband/sidebandNode.scala 164:14]
  output [127:0] io_out_bits, // @[src/main/scala/sideband/sidebandNode.scala 164:14]
  output         io_out_valid, // @[src/main/scala/sideband/sidebandNode.scala 164:14]
  input          io_out_credit // @[src/main/scala/sideband/sidebandNode.scala 164:14]
);
  reg [127:0] data; // @[src/main/scala/sideband/sidebandNode.scala 175:17]
  reg  sending; // @[src/main/scala/sideband/sidebandNode.scala 177:24]
  reg [5:0] current_credit; // @[src/main/scala/sideband/sidebandNode.scala 180:31]
  reg  isComplete; // @[src/main/scala/sideband/sidebandNode.scala 181:27]
  wire [127:0] _io_in_ready_T_1 = io_in_bits & 128'h1f; // @[src/main/scala/sideband/sb-msg-encoding.scala 368:31]
  wire  _io_in_ready_T_8 = 128'h10 == _io_in_ready_T_1 | 128'h11 == _io_in_ready_T_1 | 128'h19 == _io_in_ready_T_1; // @[src/main/scala/sideband/sb-msg-encoding.scala 368:58]
  wire  _io_in_ready_T_9 = current_credit > 6'h0; // @[src/main/scala/sideband/sidebandNode.scala 185:24]
  wire  _io_in_ready_T_10 = _io_in_ready_T_8 | current_credit > 6'h0; // @[src/main/scala/sideband/sidebandNode.scala 185:5]
  wire  _T = io_in_ready & io_in_valid; // @[src/main/scala/chisel3/util/Decoupled.scala 52:35]
  wire  _GEN_2 = _T | sending; // @[src/main/scala/sideband/sidebandNode.scala 189:20 191:13 177:24]
  wire [5:0] _current_credit_T_1 = current_credit - 6'h1; // @[src/main/scala/sideband/sidebandNode.scala 199:69]
  wire [5:0] _current_credit_T_3 = current_credit + 6'h1; // @[src/main/scala/sideband/sidebandNode.scala 202:58]
  assign io_in_ready = ~sending & _io_in_ready_T_10; // @[src/main/scala/sideband/sidebandNode.scala 183:28]
  assign io_out_bits = data; // @[src/main/scala/sideband/sidebandNode.scala 187:22]
  assign io_out_valid = (_io_in_ready_T_9 | isComplete) & sending; // @[src/main/scala/sideband/sidebandNode.scala 186:59]
  always @(posedge clock) begin
    if (io_out_valid) begin // @[src/main/scala/sideband/sidebandNode.scala 195:22]
      data <= 128'h0; // @[src/main/scala/sideband/sidebandNode.scala 195:29]
    end else if (_T) begin // @[src/main/scala/sideband/sidebandNode.scala 189:20]
      data <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 190:10]
    end
    if (reset) begin // @[src/main/scala/sideband/sidebandNode.scala 177:24]
      sending <= 1'h0; // @[src/main/scala/sideband/sidebandNode.scala 177:24]
    end else if (io_out_valid) begin // @[src/main/scala/sideband/sidebandNode.scala 197:18]
      sending <= 1'h0; // @[src/main/scala/sideband/sidebandNode.scala 198:13]
    end else begin
      sending <= _GEN_2;
    end
    if (reset) begin // @[src/main/scala/sideband/sidebandNode.scala 180:31]
      current_credit <= 6'h20; // @[src/main/scala/sideband/sidebandNode.scala 180:31]
    end else if (io_out_credit) begin // @[src/main/scala/sideband/sidebandNode.scala 202:23]
      current_credit <= _current_credit_T_3; // @[src/main/scala/sideband/sidebandNode.scala 202:40]
    end else if (io_out_valid) begin // @[src/main/scala/sideband/sidebandNode.scala 197:18]
      if (~isComplete) begin // @[src/main/scala/sideband/sidebandNode.scala 199:34]
        current_credit <= _current_credit_T_1; // @[src/main/scala/sideband/sidebandNode.scala 199:51]
      end
    end
    if (reset) begin // @[src/main/scala/sideband/sidebandNode.scala 181:27]
      isComplete <= 1'h0; // @[src/main/scala/sideband/sidebandNode.scala 181:27]
    end else if (_T) begin // @[src/main/scala/sideband/sidebandNode.scala 189:20]
      isComplete <= _io_in_ready_T_8; // @[src/main/scala/sideband/sidebandNode.scala 192:16]
    end
  end
endmodule

module Queue_1(
  input          clock,
  input          reset,
  output         io_enq_ready, // @[src/main/scala/chisel3/util/Decoupled.scala 273:14]
  input          io_enq_valid, // @[src/main/scala/chisel3/util/Decoupled.scala 273:14]
  input  [127:0] io_enq_bits, // @[src/main/scala/chisel3/util/Decoupled.scala 273:14]
  input          io_deq_ready, // @[src/main/scala/chisel3/util/Decoupled.scala 273:14]
  output         io_deq_valid, // @[src/main/scala/chisel3/util/Decoupled.scala 273:14]
  output [127:0] io_deq_bits // @[src/main/scala/chisel3/util/Decoupled.scala 273:14]
);
  reg [127:0] ram [0:31]; // @[src/main/scala/chisel3/util/Decoupled.scala 274:95]
  wire  ram_io_deq_bits_MPORT_en; // @[src/main/scala/chisel3/util/Decoupled.scala 274:95]
  wire [4:0] ram_io_deq_bits_MPORT_addr; // @[src/main/scala/chisel3/util/Decoupled.scala 274:95]
  wire [127:0] ram_io_deq_bits_MPORT_data; // @[src/main/scala/chisel3/util/Decoupled.scala 274:95]
  wire [127:0] ram_MPORT_data; // @[src/main/scala/chisel3/util/Decoupled.scala 274:95]
  wire [4:0] ram_MPORT_addr; // @[src/main/scala/chisel3/util/Decoupled.scala 274:95]
  wire  ram_MPORT_mask; // @[src/main/scala/chisel3/util/Decoupled.scala 274:95]
  wire  ram_MPORT_en; // @[src/main/scala/chisel3/util/Decoupled.scala 274:95]
  reg [4:0] enq_ptr_value; // @[src/main/scala/chisel3/util/Counter.scala 61:40]
  reg [4:0] deq_ptr_value; // @[src/main/scala/chisel3/util/Counter.scala 61:40]
  reg  maybe_full; // @[src/main/scala/chisel3/util/Decoupled.scala 277:27]
  wire  ptr_match = enq_ptr_value == deq_ptr_value; // @[src/main/scala/chisel3/util/Decoupled.scala 278:33]
  wire  empty = ptr_match & ~maybe_full; // @[src/main/scala/chisel3/util/Decoupled.scala 279:25]
  wire  full = ptr_match & maybe_full; // @[src/main/scala/chisel3/util/Decoupled.scala 280:24]
  wire  do_enq = io_enq_ready & io_enq_valid; // @[src/main/scala/chisel3/util/Decoupled.scala 52:35]
  wire  do_deq = io_deq_ready & io_deq_valid; // @[src/main/scala/chisel3/util/Decoupled.scala 52:35]
  wire [4:0] _value_T_1 = enq_ptr_value + 5'h1; // @[src/main/scala/chisel3/util/Counter.scala 77:24]
  wire [4:0] _value_T_3 = deq_ptr_value + 5'h1; // @[src/main/scala/chisel3/util/Counter.scala 77:24]
  assign ram_io_deq_bits_MPORT_en = 1'h1;
  assign ram_io_deq_bits_MPORT_addr = deq_ptr_value;
  assign ram_io_deq_bits_MPORT_data = ram[ram_io_deq_bits_MPORT_addr]; // @[src/main/scala/chisel3/util/Decoupled.scala 274:95]
  assign ram_MPORT_data = io_enq_bits;
  assign ram_MPORT_addr = enq_ptr_value;
  assign ram_MPORT_mask = 1'h1;
  assign ram_MPORT_en = io_enq_ready & io_enq_valid;
  assign io_enq_ready = ~full; // @[src/main/scala/chisel3/util/Decoupled.scala 304:19]
  assign io_deq_valid = ~empty; // @[src/main/scala/chisel3/util/Decoupled.scala 303:19]
  assign io_deq_bits = ram_io_deq_bits_MPORT_data; // @[src/main/scala/chisel3/util/Decoupled.scala 311:17]
  always @(posedge clock) begin
    if (ram_MPORT_en & ram_MPORT_mask) begin
      ram[ram_MPORT_addr] <= ram_MPORT_data; // @[src/main/scala/chisel3/util/Decoupled.scala 274:95]
    end
    if (reset) begin // @[src/main/scala/chisel3/util/Counter.scala 61:40]
      enq_ptr_value <= 5'h0; // @[src/main/scala/chisel3/util/Counter.scala 61:40]
    end else if (do_enq) begin // @[src/main/scala/chisel3/util/Decoupled.scala 287:16]
      enq_ptr_value <= _value_T_1; // @[src/main/scala/chisel3/util/Counter.scala 77:15]
    end
    if (reset) begin // @[src/main/scala/chisel3/util/Counter.scala 61:40]
      deq_ptr_value <= 5'h0; // @[src/main/scala/chisel3/util/Counter.scala 61:40]
    end else if (do_deq) begin // @[src/main/scala/chisel3/util/Decoupled.scala 291:16]
      deq_ptr_value <= _value_T_3; // @[src/main/scala/chisel3/util/Counter.scala 77:15]
    end
    if (reset) begin // @[src/main/scala/chisel3/util/Decoupled.scala 277:27]
      maybe_full <= 1'h0; // @[src/main/scala/chisel3/util/Decoupled.scala 277:27]
    end else if (do_enq != do_deq) begin // @[src/main/scala/chisel3/util/Decoupled.scala 294:27]
      maybe_full <= do_enq; // @[src/main/scala/chisel3/util/Decoupled.scala 295:16]
    end
  end
endmodule
module SidebandEnqArbiter(
  output         io_out_0_valid, // @[src/main/scala/sideband/sidebandNode.scala 115:14]
  output [127:0] io_out_0_bits, // @[src/main/scala/sideband/sidebandNode.scala 115:14]
  output         io_out_1_valid, // @[src/main/scala/sideband/sidebandNode.scala 115:14]
  output [127:0] io_out_1_bits, // @[src/main/scala/sideband/sidebandNode.scala 115:14]
  output         io_out_2_valid, // @[src/main/scala/sideband/sidebandNode.scala 115:14]
  output [127:0] io_out_2_bits, // @[src/main/scala/sideband/sidebandNode.scala 115:14]
  input          io_in_valid, // @[src/main/scala/sideband/sidebandNode.scala 115:14]
  input  [127:0] io_in_bits // @[src/main/scala/sideband/sidebandNode.scala 115:14]
);
  wire [127:0] _io_out_0_valid_T = io_in_bits & 128'h1f; // @[src/main/scala/sideband/sb-msg-encoding.scala 368:31]
  wire  _io_out_0_valid_T_7 = 128'h10 == _io_out_0_valid_T | 128'h11 == _io_out_0_valid_T | 128'h19 == _io_out_0_valid_T
    ; // @[src/main/scala/sideband/sb-msg-encoding.scala 368:58]
  wire  _io_out_1_valid_T_4 = 128'h12 == _io_out_0_valid_T | 128'h1b == _io_out_0_valid_T; // @[src/main/scala/sideband/sb-msg-encoding.scala 369:40]
  wire  _io_out_2_valid_T_1 = ~io_in_bits[4]; // @[src/main/scala/sideband/sb-msg-encoding.scala 370:28]
  assign io_out_0_valid = io_in_valid & _io_out_0_valid_T_7; // @[src/main/scala/sideband/sidebandNode.scala 125:34]
  assign io_out_0_bits = io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 120:38]
  assign io_out_1_valid = io_in_valid & _io_out_1_valid_T_4; // @[src/main/scala/sideband/sidebandNode.scala 126:34]
  assign io_out_1_bits = io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 120:38]
  assign io_out_2_valid = io_in_valid & _io_out_2_valid_T_1; // @[src/main/scala/sideband/sidebandNode.scala 127:34]
  assign io_out_2_bits = io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 120:38]
endmodule
module SidebandDeqArbiter(
  input          io_out_ready, // @[src/main/scala/sideband/sidebandNode.scala 131:14]
  output         io_out_valid, // @[src/main/scala/sideband/sidebandNode.scala 131:14]
  output [127:0] io_out_bits, // @[src/main/scala/sideband/sidebandNode.scala 131:14]
  output         io_in_0_ready, // @[src/main/scala/sideband/sidebandNode.scala 131:14]
  input          io_in_0_valid, // @[src/main/scala/sideband/sidebandNode.scala 131:14]
  input  [127:0] io_in_0_bits, // @[src/main/scala/sideband/sidebandNode.scala 131:14]
  output         io_in_1_ready, // @[src/main/scala/sideband/sidebandNode.scala 131:14]
  input          io_in_1_valid, // @[src/main/scala/sideband/sidebandNode.scala 131:14]
  input  [127:0] io_in_1_bits, // @[src/main/scala/sideband/sidebandNode.scala 131:14]
  output         io_in_2_ready, // @[src/main/scala/sideband/sidebandNode.scala 131:14]
  input          io_in_2_valid, // @[src/main/scala/sideband/sidebandNode.scala 131:14]
  input  [127:0] io_in_2_bits // @[src/main/scala/sideband/sidebandNode.scala 131:14]
);
  wire  _GEN_1 = io_in_2_valid & io_out_ready; // @[src/main/scala/sideband/sidebandNode.scala 148:30 150:22 154:40]
  wire [127:0] _GEN_2 = io_in_2_valid ? io_in_2_bits : io_in_0_bits; // @[src/main/scala/sideband/sidebandNode.scala 148:30 152:17 155:17]
  wire  _GEN_4 = io_in_1_valid & io_out_ready; // @[src/main/scala/sideband/sidebandNode.scala 143:30 145:22]
  wire  _GEN_5 = io_in_1_valid ? 1'h0 : _GEN_1; // @[src/main/scala/sideband/sidebandNode.scala 143:30 145:22]
  wire [127:0] _GEN_6 = io_in_1_valid ? io_in_1_bits : _GEN_2; // @[src/main/scala/sideband/sidebandNode.scala 143:30 147:17]
  assign io_out_valid = io_in_0_valid | io_in_1_valid | io_in_2_valid; // @[src/main/scala/sideband/sidebandNode.scala 136:52]
  assign io_out_bits = io_in_0_valid ? io_in_0_bits : _GEN_6; // @[src/main/scala/sideband/sidebandNode.scala 138:24 142:17]
  assign io_in_0_ready = io_in_0_valid & io_out_ready; // @[src/main/scala/sideband/sidebandNode.scala 138:24 140:22]
  assign io_in_1_ready = io_in_0_valid ? 1'h0 : _GEN_4; // @[src/main/scala/sideband/sidebandNode.scala 138:24 140:22]
  assign io_in_2_ready = io_in_0_valid ? 1'h0 : _GEN_5; // @[src/main/scala/sideband/sidebandNode.scala 138:24 140:22]
endmodule
module SidebandPriorityQueue(
  input          clock,
  input          reset,
  input          io_enq_valid, // @[src/main/scala/sideband/sidebandNode.scala 85:14]
  input  [127:0] io_enq_bits, // @[src/main/scala/sideband/sidebandNode.scala 85:14]
  input          io_deq_ready, // @[src/main/scala/sideband/sidebandNode.scala 85:14]
  output         io_deq_valid, // @[src/main/scala/sideband/sidebandNode.scala 85:14]
  output [127:0] io_deq_bits // @[src/main/scala/sideband/sidebandNode.scala 85:14]
);
  wire  p0_queue_clock; // @[src/main/scala/sideband/sidebandNode.scala 90:24]
  wire  p0_queue_reset; // @[src/main/scala/sideband/sidebandNode.scala 90:24]
  wire  p0_queue_io_enq_ready; // @[src/main/scala/sideband/sidebandNode.scala 90:24]
  wire  p0_queue_io_enq_valid; // @[src/main/scala/sideband/sidebandNode.scala 90:24]
  wire [127:0] p0_queue_io_enq_bits; // @[src/main/scala/sideband/sidebandNode.scala 90:24]
  wire  p0_queue_io_deq_ready; // @[src/main/scala/sideband/sidebandNode.scala 90:24]
  wire  p0_queue_io_deq_valid; // @[src/main/scala/sideband/sidebandNode.scala 90:24]
  wire [127:0] p0_queue_io_deq_bits; // @[src/main/scala/sideband/sidebandNode.scala 90:24]
  wire  p1_queue_clock; // @[src/main/scala/sideband/sidebandNode.scala 93:24]
  wire  p1_queue_reset; // @[src/main/scala/sideband/sidebandNode.scala 93:24]
  wire  p1_queue_io_enq_ready; // @[src/main/scala/sideband/sidebandNode.scala 93:24]
  wire  p1_queue_io_enq_valid; // @[src/main/scala/sideband/sidebandNode.scala 93:24]
  wire [127:0] p1_queue_io_enq_bits; // @[src/main/scala/sideband/sidebandNode.scala 93:24]
  wire  p1_queue_io_deq_ready; // @[src/main/scala/sideband/sidebandNode.scala 93:24]
  wire  p1_queue_io_deq_valid; // @[src/main/scala/sideband/sidebandNode.scala 93:24]
  wire [127:0] p1_queue_io_deq_bits; // @[src/main/scala/sideband/sidebandNode.scala 93:24]
  wire  p2_queue_clock; // @[src/main/scala/sideband/sidebandNode.scala 96:24]
  wire  p2_queue_reset; // @[src/main/scala/sideband/sidebandNode.scala 96:24]
  wire  p2_queue_io_enq_ready; // @[src/main/scala/sideband/sidebandNode.scala 96:24]
  wire  p2_queue_io_enq_valid; // @[src/main/scala/sideband/sidebandNode.scala 96:24]
  wire [127:0] p2_queue_io_enq_bits; // @[src/main/scala/sideband/sidebandNode.scala 96:24]
  wire  p2_queue_io_deq_ready; // @[src/main/scala/sideband/sidebandNode.scala 96:24]
  wire  p2_queue_io_deq_valid; // @[src/main/scala/sideband/sidebandNode.scala 96:24]
  wire [127:0] p2_queue_io_deq_bits; // @[src/main/scala/sideband/sidebandNode.scala 96:24]
  wire  enq_arb_io_out_0_valid; // @[src/main/scala/sideband/sidebandNode.scala 100:23]
  wire [127:0] enq_arb_io_out_0_bits; // @[src/main/scala/sideband/sidebandNode.scala 100:23]
  wire  enq_arb_io_out_1_valid; // @[src/main/scala/sideband/sidebandNode.scala 100:23]
  wire [127:0] enq_arb_io_out_1_bits; // @[src/main/scala/sideband/sidebandNode.scala 100:23]
  wire  enq_arb_io_out_2_valid; // @[src/main/scala/sideband/sidebandNode.scala 100:23]
  wire [127:0] enq_arb_io_out_2_bits; // @[src/main/scala/sideband/sidebandNode.scala 100:23]
  wire  enq_arb_io_in_valid; // @[src/main/scala/sideband/sidebandNode.scala 100:23]
  wire [127:0] enq_arb_io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 100:23]
  wire  deq_arb_io_out_ready; // @[src/main/scala/sideband/sidebandNode.scala 101:23]
  wire  deq_arb_io_out_valid; // @[src/main/scala/sideband/sidebandNode.scala 101:23]
  wire [127:0] deq_arb_io_out_bits; // @[src/main/scala/sideband/sidebandNode.scala 101:23]
  wire  deq_arb_io_in_0_ready; // @[src/main/scala/sideband/sidebandNode.scala 101:23]
  wire  deq_arb_io_in_0_valid; // @[src/main/scala/sideband/sidebandNode.scala 101:23]
  wire [127:0] deq_arb_io_in_0_bits; // @[src/main/scala/sideband/sidebandNode.scala 101:23]
  wire  deq_arb_io_in_1_ready; // @[src/main/scala/sideband/sidebandNode.scala 101:23]
  wire  deq_arb_io_in_1_valid; // @[src/main/scala/sideband/sidebandNode.scala 101:23]
  wire [127:0] deq_arb_io_in_1_bits; // @[src/main/scala/sideband/sidebandNode.scala 101:23]
  wire  deq_arb_io_in_2_ready; // @[src/main/scala/sideband/sidebandNode.scala 101:23]
  wire  deq_arb_io_in_2_valid; // @[src/main/scala/sideband/sidebandNode.scala 101:23]
  wire [127:0] deq_arb_io_in_2_bits; // @[src/main/scala/sideband/sidebandNode.scala 101:23]
  Queue p0_queue ( // @[src/main/scala/sideband/sidebandNode.scala 90:24]
    .clock(p0_queue_clock),
    .reset(p0_queue_reset),
    .io_enq_ready(p0_queue_io_enq_ready),
    .io_enq_valid(p0_queue_io_enq_valid),
    .io_enq_bits(p0_queue_io_enq_bits),
    .io_deq_ready(p0_queue_io_deq_ready),
    .io_deq_valid(p0_queue_io_deq_valid),
    .io_deq_bits(p0_queue_io_deq_bits)
  );
  Queue_1 p1_queue ( // @[src/main/scala/sideband/sidebandNode.scala 93:24]
    .clock(p1_queue_clock),
    .reset(p1_queue_reset),
    .io_enq_ready(p1_queue_io_enq_ready),
    .io_enq_valid(p1_queue_io_enq_valid),
    .io_enq_bits(p1_queue_io_enq_bits),
    .io_deq_ready(p1_queue_io_deq_ready),
    .io_deq_valid(p1_queue_io_deq_valid),
    .io_deq_bits(p1_queue_io_deq_bits)
  );
  Queue_1 p2_queue ( // @[src/main/scala/sideband/sidebandNode.scala 96:24]
    .clock(p2_queue_clock),
    .reset(p2_queue_reset),
    .io_enq_ready(p2_queue_io_enq_ready),
    .io_enq_valid(p2_queue_io_enq_valid),
    .io_enq_bits(p2_queue_io_enq_bits),
    .io_deq_ready(p2_queue_io_deq_ready),
    .io_deq_valid(p2_queue_io_deq_valid),
    .io_deq_bits(p2_queue_io_deq_bits)
  );
  SidebandEnqArbiter enq_arb ( // @[src/main/scala/sideband/sidebandNode.scala 100:23]
    .io_out_0_valid(enq_arb_io_out_0_valid),
    .io_out_0_bits(enq_arb_io_out_0_bits),
    .io_out_1_valid(enq_arb_io_out_1_valid),
    .io_out_1_bits(enq_arb_io_out_1_bits),
    .io_out_2_valid(enq_arb_io_out_2_valid),
    .io_out_2_bits(enq_arb_io_out_2_bits),
    .io_in_valid(enq_arb_io_in_valid),
    .io_in_bits(enq_arb_io_in_bits)
  );
  SidebandDeqArbiter deq_arb ( // @[src/main/scala/sideband/sidebandNode.scala 101:23]
    .io_out_ready(deq_arb_io_out_ready),
    .io_out_valid(deq_arb_io_out_valid),
    .io_out_bits(deq_arb_io_out_bits),
    .io_in_0_ready(deq_arb_io_in_0_ready),
    .io_in_0_valid(deq_arb_io_in_0_valid),
    .io_in_0_bits(deq_arb_io_in_0_bits),
    .io_in_1_ready(deq_arb_io_in_1_ready),
    .io_in_1_valid(deq_arb_io_in_1_valid),
    .io_in_1_bits(deq_arb_io_in_1_bits),
    .io_in_2_ready(deq_arb_io_in_2_ready),
    .io_in_2_valid(deq_arb_io_in_2_valid),
    .io_in_2_bits(deq_arb_io_in_2_bits)
  );
  assign io_deq_valid = deq_arb_io_out_valid; // @[src/main/scala/sideband/sidebandNode.scala 111:18]
  assign io_deq_bits = deq_arb_io_out_bits; // @[src/main/scala/sideband/sidebandNode.scala 111:18]
  assign p0_queue_clock = clock;
  assign p0_queue_reset = reset;
  assign p0_queue_io_enq_valid = enq_arb_io_out_0_valid; // @[src/main/scala/sideband/sidebandNode.scala 104:21]
  assign p0_queue_io_enq_bits = enq_arb_io_out_0_bits; // @[src/main/scala/sideband/sidebandNode.scala 104:21]
  assign p0_queue_io_deq_ready = deq_arb_io_in_0_ready; // @[src/main/scala/sideband/sidebandNode.scala 108:20]
  assign p1_queue_clock = clock;
  assign p1_queue_reset = reset;
  assign p1_queue_io_enq_valid = enq_arb_io_out_1_valid; // @[src/main/scala/sideband/sidebandNode.scala 105:21]
  assign p1_queue_io_enq_bits = enq_arb_io_out_1_bits; // @[src/main/scala/sideband/sidebandNode.scala 105:21]
  assign p1_queue_io_deq_ready = deq_arb_io_in_1_ready; // @[src/main/scala/sideband/sidebandNode.scala 109:20]
  assign p2_queue_clock = clock;
  assign p2_queue_reset = reset;
  assign p2_queue_io_enq_valid = enq_arb_io_out_2_valid; // @[src/main/scala/sideband/sidebandNode.scala 106:21]
  assign p2_queue_io_enq_bits = enq_arb_io_out_2_bits; // @[src/main/scala/sideband/sidebandNode.scala 106:21]
  assign p2_queue_io_deq_ready = deq_arb_io_in_2_ready; // @[src/main/scala/sideband/sidebandNode.scala 110:20]
  assign enq_arb_io_in_valid = io_enq_valid; // @[src/main/scala/sideband/sidebandNode.scala 103:17]
  assign enq_arb_io_in_bits = io_enq_bits; // @[src/main/scala/sideband/sidebandNode.scala 103:17]
  assign deq_arb_io_out_ready = io_deq_ready; // @[src/main/scala/sideband/sidebandNode.scala 111:18]
  assign deq_arb_io_in_0_valid = p0_queue_io_deq_valid; // @[src/main/scala/sideband/sidebandNode.scala 108:20]
  assign deq_arb_io_in_0_bits = p0_queue_io_deq_bits; // @[src/main/scala/sideband/sidebandNode.scala 108:20]
  assign deq_arb_io_in_1_valid = p1_queue_io_deq_valid; // @[src/main/scala/sideband/sidebandNode.scala 109:20]
  assign deq_arb_io_in_1_bits = p1_queue_io_deq_bits; // @[src/main/scala/sideband/sidebandNode.scala 109:20]
  assign deq_arb_io_in_2_valid = p2_queue_io_deq_valid; // @[src/main/scala/sideband/sidebandNode.scala 110:20]
  assign deq_arb_io_in_2_bits = p2_queue_io_deq_bits; // @[src/main/scala/sideband/sidebandNode.scala 110:20]
endmodule

module SidebandNode(
  input          clock,
  input          reset,
  output         io_inner_layer_to_node_ready, // @[src/main/scala/sideband/sidebandNode.scala 58:14]
  input          io_inner_layer_to_node_valid, // @[src/main/scala/sideband/sidebandNode.scala 58:14]
  input  [127:0] io_inner_layer_to_node_bits, // @[src/main/scala/sideband/sidebandNode.scala 58:14]
  input          io_inner_node_to_layer_ready, // @[src/main/scala/sideband/sidebandNode.scala 58:14]
  output         io_inner_node_to_layer_valid, // @[src/main/scala/sideband/sidebandNode.scala 58:14]
  output [127:0] io_inner_node_to_layer_bits, // @[src/main/scala/sideband/sidebandNode.scala 58:14]
  output [127:0] io_outer_tx_bits, // @[src/main/scala/sideband/sidebandNode.scala 58:14]
  output         io_outer_tx_valid, // @[src/main/scala/sideband/sidebandNode.scala 58:14]
  input          io_outer_tx_credit, // @[src/main/scala/sideband/sidebandNode.scala 58:14]
  input  [127:0] io_outer_rx_bits, // @[src/main/scala/sideband/sidebandNode.scala 58:14]
  input          io_outer_rx_valid, // @[src/main/scala/sideband/sidebandNode.scala 58:14]
  output         io_outer_rx_credit // @[src/main/scala/sideband/sidebandNode.scala 58:14]
);
  wire  tx_ser_clock; // @[src/main/scala/sideband/sidebandNode.scala 60:22]
  wire  tx_ser_reset; // @[src/main/scala/sideband/sidebandNode.scala 60:22]
  wire  tx_ser_io_in_ready; // @[src/main/scala/sideband/sidebandNode.scala 60:22]
  wire  tx_ser_io_in_valid; // @[src/main/scala/sideband/sidebandNode.scala 60:22]
  wire [127:0] tx_ser_io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 60:22]
  wire [127:0] tx_ser_io_out_bits; // @[src/main/scala/sideband/sidebandNode.scala 60:22]
  wire  tx_ser_io_out_valid; // @[src/main/scala/sideband/sidebandNode.scala 60:22]
  wire  tx_ser_io_out_credit; // @[src/main/scala/sideband/sidebandNode.scala 60:22]
  wire  rx_queue_clock; // @[src/main/scala/sideband/sidebandNode.scala 61:24]
  wire  rx_queue_reset; // @[src/main/scala/sideband/sidebandNode.scala 61:24]
  wire  rx_queue_io_enq_valid; // @[src/main/scala/sideband/sidebandNode.scala 61:24]
  wire [127:0] rx_queue_io_enq_bits; // @[src/main/scala/sideband/sidebandNode.scala 61:24]
  wire  rx_queue_io_deq_ready; // @[src/main/scala/sideband/sidebandNode.scala 61:24]
  wire  rx_queue_io_deq_valid; // @[src/main/scala/sideband/sidebandNode.scala 61:24]
  wire [127:0] rx_queue_io_deq_bits; // @[src/main/scala/sideband/sidebandNode.scala 61:24]
  wire  rx_des_clock; // @[src/main/scala/sideband/sidebandNode.scala 62:22]
  wire  rx_des_reset; // @[src/main/scala/sideband/sidebandNode.scala 62:22]
  wire [127:0] rx_des_io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 62:22]
  wire  rx_des_io_in_valid; // @[src/main/scala/sideband/sidebandNode.scala 62:22]
  wire  rx_des_io_out_valid; // @[src/main/scala/sideband/sidebandNode.scala 62:22]
  wire [127:0] rx_des_io_out_bits; // @[src/main/scala/sideband/sidebandNode.scala 62:22]
  wire  _io_outer_rx_credit_T = rx_queue_io_deq_ready & rx_queue_io_deq_valid; // @[src/main/scala/chisel3/util/Decoupled.scala 52:35]
  wire [127:0] _io_outer_rx_credit_T_1 = rx_queue_io_deq_bits & 128'h1f; // @[src/main/scala/sideband/sb-msg-encoding.scala 368:31]
  wire  _io_outer_rx_credit_T_8 = 128'h10 == _io_outer_rx_credit_T_1 | 128'h11 == _io_outer_rx_credit_T_1 | 128'h19 ==
    _io_outer_rx_credit_T_1; // @[src/main/scala/sideband/sb-msg-encoding.scala 368:58]
  SidebandSerializer tx_ser ( // @[src/main/scala/sideband/sidebandNode.scala 60:22]
    .clock(tx_ser_clock),
    .reset(tx_ser_reset),
    .io_in_ready(tx_ser_io_in_ready),
    .io_in_valid(tx_ser_io_in_valid),
    .io_in_bits(tx_ser_io_in_bits),
    .io_out_bits(tx_ser_io_out_bits),
    .io_out_valid(tx_ser_io_out_valid),
    .io_out_credit(tx_ser_io_out_credit)
  );
  SidebandPriorityQueue rx_queue ( // @[src/main/scala/sideband/sidebandNode.scala 61:24]
    .clock(rx_queue_clock),
    .reset(rx_queue_reset),
    .io_enq_valid(rx_queue_io_enq_valid),
    .io_enq_bits(rx_queue_io_enq_bits),
    .io_deq_ready(rx_queue_io_deq_ready),
    .io_deq_valid(rx_queue_io_deq_valid),
    .io_deq_bits(rx_queue_io_deq_bits)
  );
  SidebandDeserializer rx_des ( // @[src/main/scala/sideband/sidebandNode.scala 62:22]
    .clock(rx_des_clock),
    .reset(rx_des_reset),
    .io_in_bits(rx_des_io_in_bits),
    .io_in_valid(rx_des_io_in_valid),
    .io_out_valid(rx_des_io_out_valid),
    .io_out_bits(rx_des_io_out_bits)
  );
  assign io_inner_layer_to_node_ready = tx_ser_io_in_ready; // @[src/main/scala/sideband/sidebandNode.scala 76:32]
  assign io_inner_node_to_layer_valid = rx_queue_io_deq_valid; // @[src/main/scala/sideband/sidebandNode.scala 81:26]
  assign io_inner_node_to_layer_bits = rx_queue_io_deq_bits; // @[src/main/scala/sideband/sidebandNode.scala 81:26]
  assign io_outer_tx_bits = tx_ser_io_out_bits; // @[src/main/scala/sideband/sidebandNode.scala 65:15]
  assign io_outer_tx_valid = tx_ser_io_out_valid; // @[src/main/scala/sideband/sidebandNode.scala 65:15]
  assign io_outer_rx_credit = _io_outer_rx_credit_T & ~_io_outer_rx_credit_T_8; // @[src/main/scala/sideband/sidebandNode.scala 68:46]
  assign tx_ser_clock = clock;
  assign tx_ser_reset = reset;
  assign tx_ser_io_in_valid = io_inner_layer_to_node_valid; // @[src/main/scala/sideband/sidebandNode.scala 79:22]
  assign tx_ser_io_in_bits = io_inner_layer_to_node_bits; // @[src/main/scala/sideband/sidebandNode.scala 78:21]
  assign tx_ser_io_out_credit = io_outer_tx_credit; // @[src/main/scala/sideband/sidebandNode.scala 65:15]
  assign rx_queue_clock = clock;
  assign rx_queue_reset = reset;
  assign rx_queue_io_enq_valid = rx_des_io_out_valid; // @[src/main/scala/sideband/sidebandNode.scala 73:19]
  assign rx_queue_io_enq_bits = rx_des_io_out_bits; // @[src/main/scala/sideband/sidebandNode.scala 73:19]
  assign rx_queue_io_deq_ready = io_inner_node_to_layer_ready; // @[src/main/scala/sideband/sidebandNode.scala 81:26]
  assign rx_des_clock = clock;
  assign rx_des_reset = reset;
  assign rx_des_io_in_bits = io_outer_rx_bits; // @[src/main/scala/sideband/sidebandNode.scala 67:20]
  assign rx_des_io_in_valid = io_outer_rx_valid; // @[src/main/scala/sideband/sidebandNode.scala 66:21]
endmodule
module sidebandOneInTwoOutSwitch(
  output         io_outer_node_to_layer_ready, // @[src/main/scala/sideband/sidebandSwitcher.scala 54:14]
  input          io_outer_node_to_layer_valid, // @[src/main/scala/sideband/sidebandSwitcher.scala 54:14]
  input  [127:0] io_outer_node_to_layer_bits, // @[src/main/scala/sideband/sidebandSwitcher.scala 54:14]
  input          io_inner_node_to_layer_ready, // @[src/main/scala/sideband/sidebandSwitcher.scala 54:14]
  output         io_inner_node_to_layer_valid, // @[src/main/scala/sideband/sidebandSwitcher.scala 54:14]
  output [127:0] io_inner_node_to_layer_bits, // @[src/main/scala/sideband/sidebandSwitcher.scala 54:14]
  input          io_node_to_node_ready, // @[src/main/scala/sideband/sidebandSwitcher.scala 54:14]
  output         io_node_to_node_valid, // @[src/main/scala/sideband/sidebandSwitcher.scala 54:14]
  output [127:0] io_node_to_node_bits // @[src/main/scala/sideband/sidebandSwitcher.scala 54:14]
);
  wire  _io_inner_node_to_layer_valid_T_1 = io_outer_node_to_layer_bits[58:56] == 3'h1; // @[src/main/scala/sideband/sidebandSwitcher.scala 61:19]
  wire  _io_node_to_node_valid_T_1 = io_outer_node_to_layer_bits[58:56] != 3'h1; // @[src/main/scala/sideband/sidebandSwitcher.scala 64:19]
  assign io_outer_node_to_layer_ready = _io_inner_node_to_layer_valid_T_1 ? io_inner_node_to_layer_ready :
    io_node_to_node_ready; // @[src/main/scala/sideband/sidebandSwitcher.scala 67:38]
  assign io_inner_node_to_layer_valid = io_outer_node_to_layer_valid & _io_inner_node_to_layer_valid_T_1; // @[src/main/scala/sideband/sidebandSwitcher.scala 60:64]
  assign io_inner_node_to_layer_bits = io_outer_node_to_layer_bits; // @[src/main/scala/sideband/sidebandSwitcher.scala 62:31]
  assign io_node_to_node_valid = io_outer_node_to_layer_valid & _io_node_to_node_valid_T_1; // @[src/main/scala/sideband/sidebandSwitcher.scala 63:57]
  assign io_node_to_node_bits = io_outer_node_to_layer_bits; // @[src/main/scala/sideband/sidebandSwitcher.scala 65:24]
endmodule
module sidebandTwoInOneOutSwitch(
  input          io_outer_layer_to_node_ready, // @[src/main/scala/sideband/sidebandSwitcher.scala 75:14]
  output         io_outer_layer_to_node_valid, // @[src/main/scala/sideband/sidebandSwitcher.scala 75:14]
  output [127:0] io_outer_layer_to_node_bits, // @[src/main/scala/sideband/sidebandSwitcher.scala 75:14]
  output         io_inner_layer_to_node_ready, // @[src/main/scala/sideband/sidebandSwitcher.scala 75:14]
  input          io_inner_layer_to_node_valid, // @[src/main/scala/sideband/sidebandSwitcher.scala 75:14]
  input  [127:0] io_inner_layer_to_node_bits, // @[src/main/scala/sideband/sidebandSwitcher.scala 75:14]
  output         io_node_to_node_ready, // @[src/main/scala/sideband/sidebandSwitcher.scala 75:14]
  input          io_node_to_node_valid, // @[src/main/scala/sideband/sidebandSwitcher.scala 75:14]
  input  [127:0] io_node_to_node_bits // @[src/main/scala/sideband/sidebandSwitcher.scala 75:14]
);
  wire [127:0] _priority_node_to_node_T = io_node_to_node_bits & 128'h1f; // @[src/main/scala/sideband/sb-msg-encoding.scala 368:31]
  wire  _priority_node_to_node_T_7 = 128'h10 == _priority_node_to_node_T | 128'h11 == _priority_node_to_node_T | 128'h19
     == _priority_node_to_node_T; // @[src/main/scala/sideband/sb-msg-encoding.scala 368:58]
  wire  _priority_node_to_node_T_12 = 128'h12 == _priority_node_to_node_T | 128'h1b == _priority_node_to_node_T; // @[src/main/scala/sideband/sb-msg-encoding.scala 369:40]
  wire [1:0] _priority_node_to_node_T_13 = _priority_node_to_node_T_12 ? 2'h1 : 2'h2; // @[src/main/scala/sideband/sidebandSwitcher.scala 90:8]
  wire [1:0] priority_node_to_node = _priority_node_to_node_T_7 ? 2'h0 : _priority_node_to_node_T_13; // @[src/main/scala/sideband/sidebandSwitcher.scala 87:31]
  wire [127:0] _priority_inner_layer_to_node_T = io_inner_layer_to_node_bits & 128'h1f; // @[src/main/scala/sideband/sb-msg-encoding.scala 368:31]
  wire  _priority_inner_layer_to_node_T_7 = 128'h10 == _priority_inner_layer_to_node_T | 128'h11 ==
    _priority_inner_layer_to_node_T | 128'h19 == _priority_inner_layer_to_node_T; // @[src/main/scala/sideband/sb-msg-encoding.scala 368:58]
  wire  _priority_inner_layer_to_node_T_12 = 128'h12 == _priority_inner_layer_to_node_T | 128'h1b ==
    _priority_inner_layer_to_node_T; // @[src/main/scala/sideband/sb-msg-encoding.scala 369:40]
  wire [1:0] _priority_inner_layer_to_node_T_13 = _priority_inner_layer_to_node_T_12 ? 2'h1 : 2'h2; // @[src/main/scala/sideband/sidebandSwitcher.scala 95:8]
  wire [1:0] priority_inner_layer_to_node = _priority_inner_layer_to_node_T_7 ? 2'h0 :
    _priority_inner_layer_to_node_T_13; // @[src/main/scala/sideband/sidebandSwitcher.scala 92:38]
  wire  _flag_T = io_node_to_node_valid & io_inner_layer_to_node_valid; // @[src/main/scala/sideband/sidebandSwitcher.scala 98:27]
  wire  _flag_T_1 = priority_inner_layer_to_node > priority_node_to_node; // @[src/main/scala/sideband/sidebandSwitcher.scala 99:34]
  wire  flag = _flag_T ? _flag_T_1 : io_node_to_node_valid; // @[src/main/scala/sideband/sidebandSwitcher.scala 97:14]
  assign io_outer_layer_to_node_valid = io_node_to_node_valid | io_inner_layer_to_node_valid; // @[src/main/scala/sideband/sidebandSwitcher.scala 103:57]
  assign io_outer_layer_to_node_bits = flag ? io_node_to_node_bits : io_inner_layer_to_node_bits; // @[src/main/scala/sideband/sidebandSwitcher.scala 104:37]
  assign io_inner_layer_to_node_ready = flag ? 1'h0 : io_outer_layer_to_node_ready; // @[src/main/scala/sideband/sidebandSwitcher.scala 110:38]
  assign io_node_to_node_ready = flag & io_outer_layer_to_node_ready; // @[src/main/scala/sideband/sidebandSwitcher.scala 109:31]
endmodule
module sidebandSwitcher(
  input          io_inner_node_to_layer_above_ready, // @[src/main/scala/sideband/sidebandSwitcher.scala 10:14]
  output         io_inner_node_to_layer_above_valid, // @[src/main/scala/sideband/sidebandSwitcher.scala 10:14]
  output [127:0] io_inner_node_to_layer_above_bits, // @[src/main/scala/sideband/sidebandSwitcher.scala 10:14]
  output         io_inner_layer_to_node_below_ready, // @[src/main/scala/sideband/sidebandSwitcher.scala 10:14]
  input          io_inner_layer_to_node_below_valid, // @[src/main/scala/sideband/sidebandSwitcher.scala 10:14]
  input  [127:0] io_inner_layer_to_node_below_bits, // @[src/main/scala/sideband/sidebandSwitcher.scala 10:14]
  output         io_outer_node_to_layer_above_ready, // @[src/main/scala/sideband/sidebandSwitcher.scala 10:14]
  input          io_outer_node_to_layer_above_valid, // @[src/main/scala/sideband/sidebandSwitcher.scala 10:14]
  input  [127:0] io_outer_node_to_layer_above_bits, // @[src/main/scala/sideband/sidebandSwitcher.scala 10:14]
  input          io_outer_layer_to_node_above_ready, // @[src/main/scala/sideband/sidebandSwitcher.scala 10:14]
  output         io_outer_layer_to_node_above_valid, // @[src/main/scala/sideband/sidebandSwitcher.scala 10:14]
  output [127:0] io_outer_layer_to_node_above_bits, // @[src/main/scala/sideband/sidebandSwitcher.scala 10:14]
  output         io_outer_node_to_layer_below_ready, // @[src/main/scala/sideband/sidebandSwitcher.scala 10:14]
  input          io_outer_node_to_layer_below_valid, // @[src/main/scala/sideband/sidebandSwitcher.scala 10:14]
  input  [127:0] io_outer_node_to_layer_below_bits, // @[src/main/scala/sideband/sidebandSwitcher.scala 10:14]
  input          io_outer_layer_to_node_below_ready, // @[src/main/scala/sideband/sidebandSwitcher.scala 10:14]
  output         io_outer_layer_to_node_below_valid, // @[src/main/scala/sideband/sidebandSwitcher.scala 10:14]
  output [127:0] io_outer_layer_to_node_below_bits // @[src/main/scala/sideband/sidebandSwitcher.scala 10:14]
);
  wire  outer_node_to_layer_below_subswitch_io_outer_node_to_layer_ready; // @[src/main/scala/sideband/sidebandSwitcher.scala 19:51]
  wire  outer_node_to_layer_below_subswitch_io_outer_node_to_layer_valid; // @[src/main/scala/sideband/sidebandSwitcher.scala 19:51]
  wire [127:0] outer_node_to_layer_below_subswitch_io_outer_node_to_layer_bits; // @[src/main/scala/sideband/sidebandSwitcher.scala 19:51]
  wire  outer_node_to_layer_below_subswitch_io_inner_node_to_layer_ready; // @[src/main/scala/sideband/sidebandSwitcher.scala 19:51]
  wire  outer_node_to_layer_below_subswitch_io_inner_node_to_layer_valid; // @[src/main/scala/sideband/sidebandSwitcher.scala 19:51]
  wire [127:0] outer_node_to_layer_below_subswitch_io_inner_node_to_layer_bits; // @[src/main/scala/sideband/sidebandSwitcher.scala 19:51]
  wire  outer_node_to_layer_below_subswitch_io_node_to_node_ready; // @[src/main/scala/sideband/sidebandSwitcher.scala 19:51]
  wire  outer_node_to_layer_below_subswitch_io_node_to_node_valid; // @[src/main/scala/sideband/sidebandSwitcher.scala 19:51]
  wire [127:0] outer_node_to_layer_below_subswitch_io_node_to_node_bits; // @[src/main/scala/sideband/sidebandSwitcher.scala 19:51]
  wire  outer_node_to_layer_above_subswitch_io_outer_node_to_layer_ready; // @[src/main/scala/sideband/sidebandSwitcher.scala 22:51]
  wire  outer_node_to_layer_above_subswitch_io_outer_node_to_layer_valid; // @[src/main/scala/sideband/sidebandSwitcher.scala 22:51]
  wire [127:0] outer_node_to_layer_above_subswitch_io_outer_node_to_layer_bits; // @[src/main/scala/sideband/sidebandSwitcher.scala 22:51]
  wire  outer_node_to_layer_above_subswitch_io_inner_node_to_layer_ready; // @[src/main/scala/sideband/sidebandSwitcher.scala 22:51]
  wire  outer_node_to_layer_above_subswitch_io_inner_node_to_layer_valid; // @[src/main/scala/sideband/sidebandSwitcher.scala 22:51]
  wire [127:0] outer_node_to_layer_above_subswitch_io_inner_node_to_layer_bits; // @[src/main/scala/sideband/sidebandSwitcher.scala 22:51]
  wire  outer_node_to_layer_above_subswitch_io_node_to_node_ready; // @[src/main/scala/sideband/sidebandSwitcher.scala 22:51]
  wire  outer_node_to_layer_above_subswitch_io_node_to_node_valid; // @[src/main/scala/sideband/sidebandSwitcher.scala 22:51]
  wire [127:0] outer_node_to_layer_above_subswitch_io_node_to_node_bits; // @[src/main/scala/sideband/sidebandSwitcher.scala 22:51]
  wire  outer_layer_to_node_above_subswitch_io_outer_layer_to_node_ready; // @[src/main/scala/sideband/sidebandSwitcher.scala 35:51]
  wire  outer_layer_to_node_above_subswitch_io_outer_layer_to_node_valid; // @[src/main/scala/sideband/sidebandSwitcher.scala 35:51]
  wire [127:0] outer_layer_to_node_above_subswitch_io_outer_layer_to_node_bits; // @[src/main/scala/sideband/sidebandSwitcher.scala 35:51]
  wire  outer_layer_to_node_above_subswitch_io_inner_layer_to_node_ready; // @[src/main/scala/sideband/sidebandSwitcher.scala 35:51]
  wire  outer_layer_to_node_above_subswitch_io_inner_layer_to_node_valid; // @[src/main/scala/sideband/sidebandSwitcher.scala 35:51]
  wire [127:0] outer_layer_to_node_above_subswitch_io_inner_layer_to_node_bits; // @[src/main/scala/sideband/sidebandSwitcher.scala 35:51]
  wire  outer_layer_to_node_above_subswitch_io_node_to_node_ready; // @[src/main/scala/sideband/sidebandSwitcher.scala 35:51]
  wire  outer_layer_to_node_above_subswitch_io_node_to_node_valid; // @[src/main/scala/sideband/sidebandSwitcher.scala 35:51]
  wire [127:0] outer_layer_to_node_above_subswitch_io_node_to_node_bits; // @[src/main/scala/sideband/sidebandSwitcher.scala 35:51]
  wire  outer_layer_to_node_below_subswitch_io_outer_layer_to_node_ready; // @[src/main/scala/sideband/sidebandSwitcher.scala 38:51]
  wire  outer_layer_to_node_below_subswitch_io_outer_layer_to_node_valid; // @[src/main/scala/sideband/sidebandSwitcher.scala 38:51]
  wire [127:0] outer_layer_to_node_below_subswitch_io_outer_layer_to_node_bits; // @[src/main/scala/sideband/sidebandSwitcher.scala 38:51]
  wire  outer_layer_to_node_below_subswitch_io_inner_layer_to_node_ready; // @[src/main/scala/sideband/sidebandSwitcher.scala 38:51]
  wire  outer_layer_to_node_below_subswitch_io_inner_layer_to_node_valid; // @[src/main/scala/sideband/sidebandSwitcher.scala 38:51]
  wire [127:0] outer_layer_to_node_below_subswitch_io_inner_layer_to_node_bits; // @[src/main/scala/sideband/sidebandSwitcher.scala 38:51]
  wire  outer_layer_to_node_below_subswitch_io_node_to_node_ready; // @[src/main/scala/sideband/sidebandSwitcher.scala 38:51]
  wire  outer_layer_to_node_below_subswitch_io_node_to_node_valid; // @[src/main/scala/sideband/sidebandSwitcher.scala 38:51]
  wire [127:0] outer_layer_to_node_below_subswitch_io_node_to_node_bits; // @[src/main/scala/sideband/sidebandSwitcher.scala 38:51]
  sidebandOneInTwoOutSwitch outer_node_to_layer_below_subswitch ( // @[src/main/scala/sideband/sidebandSwitcher.scala 19:51]
    .io_outer_node_to_layer_ready(outer_node_to_layer_below_subswitch_io_outer_node_to_layer_ready),
    .io_outer_node_to_layer_valid(outer_node_to_layer_below_subswitch_io_outer_node_to_layer_valid),
    .io_outer_node_to_layer_bits(outer_node_to_layer_below_subswitch_io_outer_node_to_layer_bits),
    .io_inner_node_to_layer_ready(outer_node_to_layer_below_subswitch_io_inner_node_to_layer_ready),
    .io_inner_node_to_layer_valid(outer_node_to_layer_below_subswitch_io_inner_node_to_layer_valid),
    .io_inner_node_to_layer_bits(outer_node_to_layer_below_subswitch_io_inner_node_to_layer_bits),
    .io_node_to_node_ready(outer_node_to_layer_below_subswitch_io_node_to_node_ready),
    .io_node_to_node_valid(outer_node_to_layer_below_subswitch_io_node_to_node_valid),
    .io_node_to_node_bits(outer_node_to_layer_below_subswitch_io_node_to_node_bits)
  );
  sidebandOneInTwoOutSwitch outer_node_to_layer_above_subswitch ( // @[src/main/scala/sideband/sidebandSwitcher.scala 22:51]
    .io_outer_node_to_layer_ready(outer_node_to_layer_above_subswitch_io_outer_node_to_layer_ready),
    .io_outer_node_to_layer_valid(outer_node_to_layer_above_subswitch_io_outer_node_to_layer_valid),
    .io_outer_node_to_layer_bits(outer_node_to_layer_above_subswitch_io_outer_node_to_layer_bits),
    .io_inner_node_to_layer_ready(outer_node_to_layer_above_subswitch_io_inner_node_to_layer_ready),
    .io_inner_node_to_layer_valid(outer_node_to_layer_above_subswitch_io_inner_node_to_layer_valid),
    .io_inner_node_to_layer_bits(outer_node_to_layer_above_subswitch_io_inner_node_to_layer_bits),
    .io_node_to_node_ready(outer_node_to_layer_above_subswitch_io_node_to_node_ready),
    .io_node_to_node_valid(outer_node_to_layer_above_subswitch_io_node_to_node_valid),
    .io_node_to_node_bits(outer_node_to_layer_above_subswitch_io_node_to_node_bits)
  );
  sidebandTwoInOneOutSwitch outer_layer_to_node_above_subswitch ( // @[src/main/scala/sideband/sidebandSwitcher.scala 35:51]
    .io_outer_layer_to_node_ready(outer_layer_to_node_above_subswitch_io_outer_layer_to_node_ready),
    .io_outer_layer_to_node_valid(outer_layer_to_node_above_subswitch_io_outer_layer_to_node_valid),
    .io_outer_layer_to_node_bits(outer_layer_to_node_above_subswitch_io_outer_layer_to_node_bits),
    .io_inner_layer_to_node_ready(outer_layer_to_node_above_subswitch_io_inner_layer_to_node_ready),
    .io_inner_layer_to_node_valid(outer_layer_to_node_above_subswitch_io_inner_layer_to_node_valid),
    .io_inner_layer_to_node_bits(outer_layer_to_node_above_subswitch_io_inner_layer_to_node_bits),
    .io_node_to_node_ready(outer_layer_to_node_above_subswitch_io_node_to_node_ready),
    .io_node_to_node_valid(outer_layer_to_node_above_subswitch_io_node_to_node_valid),
    .io_node_to_node_bits(outer_layer_to_node_above_subswitch_io_node_to_node_bits)
  );
  sidebandTwoInOneOutSwitch outer_layer_to_node_below_subswitch ( // @[src/main/scala/sideband/sidebandSwitcher.scala 38:51]
    .io_outer_layer_to_node_ready(outer_layer_to_node_below_subswitch_io_outer_layer_to_node_ready),
    .io_outer_layer_to_node_valid(outer_layer_to_node_below_subswitch_io_outer_layer_to_node_valid),
    .io_outer_layer_to_node_bits(outer_layer_to_node_below_subswitch_io_outer_layer_to_node_bits),
    .io_inner_layer_to_node_ready(outer_layer_to_node_below_subswitch_io_inner_layer_to_node_ready),
    .io_inner_layer_to_node_valid(outer_layer_to_node_below_subswitch_io_inner_layer_to_node_valid),
    .io_inner_layer_to_node_bits(outer_layer_to_node_below_subswitch_io_inner_layer_to_node_bits),
    .io_node_to_node_ready(outer_layer_to_node_below_subswitch_io_node_to_node_ready),
    .io_node_to_node_valid(outer_layer_to_node_below_subswitch_io_node_to_node_valid),
    .io_node_to_node_bits(outer_layer_to_node_below_subswitch_io_node_to_node_bits)
  );
  assign io_inner_node_to_layer_above_valid = outer_node_to_layer_above_subswitch_io_inner_node_to_layer_valid; // @[src/main/scala/sideband/sidebandSwitcher.scala 30:62]
  assign io_inner_node_to_layer_above_bits = outer_node_to_layer_above_subswitch_io_inner_node_to_layer_bits; // @[src/main/scala/sideband/sidebandSwitcher.scala 30:62]
  assign io_inner_layer_to_node_below_ready = outer_layer_to_node_below_subswitch_io_inner_layer_to_node_ready; // @[src/main/scala/sideband/sidebandSwitcher.scala 49:62]
  assign io_outer_node_to_layer_above_ready = outer_node_to_layer_above_subswitch_io_outer_node_to_layer_ready; // @[src/main/scala/sideband/sidebandSwitcher.scala 27:62]
  assign io_outer_layer_to_node_above_valid = outer_layer_to_node_above_subswitch_io_outer_layer_to_node_valid; // @[src/main/scala/sideband/sidebandSwitcher.scala 45:62]
  assign io_outer_layer_to_node_above_bits = outer_layer_to_node_above_subswitch_io_outer_layer_to_node_bits; // @[src/main/scala/sideband/sidebandSwitcher.scala 45:62]
  assign io_outer_node_to_layer_below_ready = outer_node_to_layer_below_subswitch_io_outer_node_to_layer_ready; // @[src/main/scala/sideband/sidebandSwitcher.scala 26:62]
  assign io_outer_layer_to_node_below_valid = outer_layer_to_node_below_subswitch_io_outer_layer_to_node_valid; // @[src/main/scala/sideband/sidebandSwitcher.scala 46:62]
  assign io_outer_layer_to_node_below_bits = outer_layer_to_node_below_subswitch_io_outer_layer_to_node_bits; // @[src/main/scala/sideband/sidebandSwitcher.scala 46:62]
  assign outer_node_to_layer_below_subswitch_io_outer_node_to_layer_valid = io_outer_node_to_layer_below_valid; // @[src/main/scala/sideband/sidebandSwitcher.scala 26:62]
  assign outer_node_to_layer_below_subswitch_io_outer_node_to_layer_bits = io_outer_node_to_layer_below_bits; // @[src/main/scala/sideband/sidebandSwitcher.scala 26:62]
  assign outer_node_to_layer_below_subswitch_io_inner_node_to_layer_ready = 1'h0; // @[src/main/scala/sideband/sidebandSwitcher.scala 29:62]
  assign outer_node_to_layer_below_subswitch_io_node_to_node_ready =
    outer_layer_to_node_above_subswitch_io_node_to_node_ready; // @[src/main/scala/sideband/sidebandSwitcher.scala 12:41 42:55]
  assign outer_node_to_layer_above_subswitch_io_outer_node_to_layer_valid = io_outer_node_to_layer_above_valid; // @[src/main/scala/sideband/sidebandSwitcher.scala 27:62]
  assign outer_node_to_layer_above_subswitch_io_outer_node_to_layer_bits = io_outer_node_to_layer_above_bits; // @[src/main/scala/sideband/sidebandSwitcher.scala 27:62]
  assign outer_node_to_layer_above_subswitch_io_inner_node_to_layer_ready = 1'h1; // @[src/main/scala/sideband/sidebandSwitcher.scala 30:62]
  assign outer_node_to_layer_above_subswitch_io_node_to_node_ready =
    outer_layer_to_node_below_subswitch_io_node_to_node_ready; // @[src/main/scala/sideband/sidebandSwitcher.scala 15:41 43:55]
  assign outer_layer_to_node_above_subswitch_io_outer_layer_to_node_ready = io_outer_layer_to_node_above_ready; // @[src/main/scala/sideband/sidebandSwitcher.scala 45:62]
  assign outer_layer_to_node_above_subswitch_io_inner_layer_to_node_valid = 1'h0; // @[src/main/scala/sideband/sidebandSwitcher.scala 48:62]
  assign outer_layer_to_node_above_subswitch_io_inner_layer_to_node_bits = 128'h0; // @[src/main/scala/sideband/sidebandSwitcher.scala 48:62]
  assign outer_layer_to_node_above_subswitch_io_node_to_node_valid =
    outer_node_to_layer_below_subswitch_io_node_to_node_valid; // @[src/main/scala/sideband/sidebandSwitcher.scala 12:41 32:31]
  assign outer_layer_to_node_above_subswitch_io_node_to_node_bits =
    outer_node_to_layer_below_subswitch_io_node_to_node_bits; // @[src/main/scala/sideband/sidebandSwitcher.scala 12:41 32:31]
  assign outer_layer_to_node_below_subswitch_io_outer_layer_to_node_ready = io_outer_layer_to_node_below_ready; // @[src/main/scala/sideband/sidebandSwitcher.scala 46:62]
  assign outer_layer_to_node_below_subswitch_io_inner_layer_to_node_valid = io_inner_layer_to_node_below_valid; // @[src/main/scala/sideband/sidebandSwitcher.scala 49:62]
  assign outer_layer_to_node_below_subswitch_io_inner_layer_to_node_bits = io_inner_layer_to_node_below_bits; // @[src/main/scala/sideband/sidebandSwitcher.scala 49:62]
  assign outer_layer_to_node_below_subswitch_io_node_to_node_valid =
    outer_node_to_layer_above_subswitch_io_node_to_node_valid; // @[src/main/scala/sideband/sidebandSwitcher.scala 15:41 33:31]
  assign outer_layer_to_node_below_subswitch_io_node_to_node_bits =
    outer_node_to_layer_above_subswitch_io_node_to_node_bits; // @[src/main/scala/sideband/sidebandSwitcher.scala 15:41 33:31]
endmodule
module D2DSidebandModule(
  input          clock,
  input          reset,
  input  [127:0] io_rdi_pl_cfg, // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 38:16]
  input          io_rdi_pl_cfg_vld, // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 38:16]
  output         io_rdi_pl_cfg_crd, // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 38:16]
  output [127:0] io_rdi_lp_cfg, // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 38:16]
  output         io_rdi_lp_cfg_vld, // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 38:16]
  input          io_rdi_lp_cfg_crd, // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 38:16]
  output [5:0]   io_sideband_rcv, // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 38:16]
  input  [5:0]   io_sideband_snt, // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 38:16]
  output         io_sideband_rdy // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 38:16]
);
  wire  fdi_sideband_node_clock; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 40:35]
  wire  fdi_sideband_node_reset; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 40:35]
  wire  fdi_sideband_node_io_inner_layer_to_node_ready; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 40:35]
  wire  fdi_sideband_node_io_inner_layer_to_node_valid; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 40:35]
  wire [127:0] fdi_sideband_node_io_inner_layer_to_node_bits; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 40:35]
  wire  fdi_sideband_node_io_inner_node_to_layer_ready; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 40:35]
  wire  fdi_sideband_node_io_inner_node_to_layer_valid; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 40:35]
  wire [127:0] fdi_sideband_node_io_inner_node_to_layer_bits; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 40:35]
  wire [127:0] fdi_sideband_node_io_outer_tx_bits; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 40:35]
  wire  fdi_sideband_node_io_outer_tx_valid; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 40:35]
  wire  fdi_sideband_node_io_outer_tx_credit; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 40:35]
  wire [127:0] fdi_sideband_node_io_outer_rx_bits; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 40:35]
  wire  fdi_sideband_node_io_outer_rx_valid; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 40:35]
  wire  fdi_sideband_node_io_outer_rx_credit; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 40:35]
  wire  rdi_sideband_node_clock; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 41:35]
  wire  rdi_sideband_node_reset; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 41:35]
  wire  rdi_sideband_node_io_inner_layer_to_node_ready; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 41:35]
  wire  rdi_sideband_node_io_inner_layer_to_node_valid; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 41:35]
  wire [127:0] rdi_sideband_node_io_inner_layer_to_node_bits; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 41:35]
  wire  rdi_sideband_node_io_inner_node_to_layer_ready; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 41:35]
  wire  rdi_sideband_node_io_inner_node_to_layer_valid; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 41:35]
  wire [127:0] rdi_sideband_node_io_inner_node_to_layer_bits; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 41:35]
  wire [127:0] rdi_sideband_node_io_outer_tx_bits; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 41:35]
  wire  rdi_sideband_node_io_outer_tx_valid; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 41:35]
  wire  rdi_sideband_node_io_outer_tx_credit; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 41:35]
  wire [127:0] rdi_sideband_node_io_outer_rx_bits; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 41:35]
  wire  rdi_sideband_node_io_outer_rx_valid; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 41:35]
  wire  rdi_sideband_node_io_outer_rx_credit; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 41:35]
  wire  sideband_switch_io_inner_node_to_layer_above_ready; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 42:33]
  wire  sideband_switch_io_inner_node_to_layer_above_valid; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 42:33]
  wire [127:0] sideband_switch_io_inner_node_to_layer_above_bits; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 42:33]
  wire  sideband_switch_io_inner_layer_to_node_below_ready; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 42:33]
  wire  sideband_switch_io_inner_layer_to_node_below_valid; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 42:33]
  wire [127:0] sideband_switch_io_inner_layer_to_node_below_bits; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 42:33]
  wire  sideband_switch_io_outer_node_to_layer_above_ready; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 42:33]
  wire  sideband_switch_io_outer_node_to_layer_above_valid; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 42:33]
  wire [127:0] sideband_switch_io_outer_node_to_layer_above_bits; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 42:33]
  wire  sideband_switch_io_outer_layer_to_node_above_ready; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 42:33]
  wire  sideband_switch_io_outer_layer_to_node_above_valid; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 42:33]
  wire [127:0] sideband_switch_io_outer_layer_to_node_above_bits; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 42:33]
  wire  sideband_switch_io_outer_node_to_layer_below_ready; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 42:33]
  wire  sideband_switch_io_outer_node_to_layer_below_valid; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 42:33]
  wire [127:0] sideband_switch_io_outer_node_to_layer_below_bits; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 42:33]
  wire  sideband_switch_io_outer_layer_to_node_below_ready; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 42:33]
  wire  sideband_switch_io_outer_layer_to_node_below_valid; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 42:33]
  wire [127:0] sideband_switch_io_outer_layer_to_node_below_bits; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 42:33]
  wire [127:0] _T_1 = sideband_switch_io_inner_node_to_layer_above_bits & 128'hffffff003fc01f; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 72:64]
  wire [127:0] _T_3 = sideband_switch_io_inner_node_to_layer_above_bits & 128'hff003fc01f; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 74:70]
  wire [5:0] _GEN_0 = 128'h401b == _T_1 ? 6'h24 : 6'h0; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 100:86 101:29 103:29]
  wire [5:0] _GEN_1 = 128'h100020012 == _T_1 ? 6'h32 : _GEN_0; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 98:97 99:29]
  wire [5:0] _GEN_2 = 128'h20012 == _T_1 ? 6'h31 : _GEN_1; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 96:97 97:29]
  wire [5:0] _GEN_3 = 128'h1c012 == _T_1 ? 6'h21 : _GEN_2; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 94:97 95:29]
  wire [5:0] _GEN_4 = 128'hc00010012 == _T_1 ? 6'h1c : _GEN_3; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 92:109 93:29]
  wire [5:0] _GEN_5 = 128'h900010012 == _T_1 ? 6'h19 : _GEN_4; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 90:112 91:29]
  wire [5:0] _GEN_6 = 128'h800010012 == _T_1 ? 6'h18 : _GEN_5; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 88:104 89:29]
  wire [5:0] _GEN_7 = 128'h400010012 == _T_1 ? 6'h14 : _GEN_6; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 86:104 87:29]
  wire [5:0] _GEN_8 = 128'h200010012 == _T_1 ? 6'h13 : _GEN_7; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 84:108 85:29]
  wire [5:0] _GEN_9 = 128'h100010012 == _T_1 ? 6'h11 : _GEN_8; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 82:108 83:29]
  wire [5:0] _GEN_10 = 128'hc0000c012 == _T_3 ? 6'hc : _GEN_9; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 80:109 81:29]
  wire [5:0] _GEN_11 = 128'h90000c012 == _T_3 ? 6'h9 : _GEN_10; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 78:112 79:29]
  wire [5:0] _GEN_12 = 128'h80000c012 == _T_3 ? 6'h8 : _GEN_11; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 76:104 77:29]
  wire [5:0] _GEN_13 = 128'h40000c012 == _T_3 ? 6'h4 : _GEN_12; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 74:104 75:29]
  wire [5:0] _GEN_14 = 128'h10000c012 == _T_1 ? 6'h1 : _GEN_13; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 72:102 73:29]
  wire [142:0] _GEN_16 = io_sideband_snt == 6'h24 ? 143'h488000050000002000401b : 143'h500000020000012; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 139:64 140:63 142:63]
  wire [142:0] _GEN_17 = io_sideband_snt == 6'h32 ? 143'h500000120020012 : _GEN_16; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 137:75 138:63]
  wire [142:0] _GEN_18 = io_sideband_snt == 6'h31 ? 143'h500000020020012 : _GEN_17; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 135:75 136:63]
  wire [142:0] _GEN_19 = io_sideband_snt == 6'h21 ? 143'h50000002001c012 : _GEN_18; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 133:75 134:63]
  wire [142:0] _GEN_20 = io_sideband_snt == 6'h1c ? 143'h500000c20010012 : _GEN_19; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 131:69 132:63]
  wire [142:0] _GEN_21 = io_sideband_snt == 6'h19 ? 143'h500000920010012 : _GEN_20; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 129:70 130:63]
  wire [142:0] _GEN_22 = io_sideband_snt == 6'h18 ? 143'h500000820010012 : _GEN_21; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 127:63 128:63]
  wire [142:0] _GEN_23 = io_sideband_snt == 6'h14 ? 143'h500000420010012 : _GEN_22; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 125:63 126:63]
  wire [142:0] _GEN_24 = io_sideband_snt == 6'h13 ? 143'h500000220010012 : _GEN_23; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 123:66 124:63]
  wire [142:0] _GEN_25 = io_sideband_snt == 6'h11 ? 143'h500000120010012 : _GEN_24; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 121:67 122:63]
  wire [142:0] _GEN_26 = io_sideband_snt == 6'hc ? 143'h500000c2000c012 : _GEN_25; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 119:69 120:63]
  wire [142:0] _GEN_27 = io_sideband_snt == 6'h9 ? 143'h50000092000c012 : _GEN_26; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 117:70 118:63]
  wire [142:0] _GEN_28 = io_sideband_snt == 6'h8 ? 143'h50000082000c012 : _GEN_27; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 115:63 116:63]
  wire [142:0] _GEN_29 = io_sideband_snt == 6'h4 ? 143'h50000042000c012 : _GEN_28; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 113:63 114:63]
  wire [142:0] _GEN_30 = io_sideband_snt == 6'h1 ? 143'h50000012000c012 : _GEN_29; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 111:61 112:63]
  wire [142:0] _GEN_31 = io_sideband_snt != 6'h0 ? _GEN_30 : 143'h500000020000012; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 110:50 147:59]
  SidebandNode fdi_sideband_node ( // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 40:35]
    .clock(fdi_sideband_node_clock),
    .reset(fdi_sideband_node_reset),
    .io_inner_layer_to_node_ready(fdi_sideband_node_io_inner_layer_to_node_ready),
    .io_inner_layer_to_node_valid(fdi_sideband_node_io_inner_layer_to_node_valid),
    .io_inner_layer_to_node_bits(fdi_sideband_node_io_inner_layer_to_node_bits),
    .io_inner_node_to_layer_ready(fdi_sideband_node_io_inner_node_to_layer_ready),
    .io_inner_node_to_layer_valid(fdi_sideband_node_io_inner_node_to_layer_valid),
    .io_inner_node_to_layer_bits(fdi_sideband_node_io_inner_node_to_layer_bits),
    .io_outer_tx_bits(fdi_sideband_node_io_outer_tx_bits),
    .io_outer_tx_valid(fdi_sideband_node_io_outer_tx_valid),
    .io_outer_tx_credit(fdi_sideband_node_io_outer_tx_credit),
    .io_outer_rx_bits(fdi_sideband_node_io_outer_rx_bits),
    .io_outer_rx_valid(fdi_sideband_node_io_outer_rx_valid),
    .io_outer_rx_credit(fdi_sideband_node_io_outer_rx_credit)
  );
  SidebandNode rdi_sideband_node ( // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 41:35]
    .clock(rdi_sideband_node_clock),
    .reset(rdi_sideband_node_reset),
    .io_inner_layer_to_node_ready(rdi_sideband_node_io_inner_layer_to_node_ready),
    .io_inner_layer_to_node_valid(rdi_sideband_node_io_inner_layer_to_node_valid),
    .io_inner_layer_to_node_bits(rdi_sideband_node_io_inner_layer_to_node_bits),
    .io_inner_node_to_layer_ready(rdi_sideband_node_io_inner_node_to_layer_ready),
    .io_inner_node_to_layer_valid(rdi_sideband_node_io_inner_node_to_layer_valid),
    .io_inner_node_to_layer_bits(rdi_sideband_node_io_inner_node_to_layer_bits),
    .io_outer_tx_bits(rdi_sideband_node_io_outer_tx_bits),
    .io_outer_tx_valid(rdi_sideband_node_io_outer_tx_valid),
    .io_outer_tx_credit(rdi_sideband_node_io_outer_tx_credit),
    .io_outer_rx_bits(rdi_sideband_node_io_outer_rx_bits),
    .io_outer_rx_valid(rdi_sideband_node_io_outer_rx_valid),
    .io_outer_rx_credit(rdi_sideband_node_io_outer_rx_credit)
  );
  sidebandSwitcher sideband_switch ( // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 42:33]
    .io_inner_node_to_layer_above_ready(sideband_switch_io_inner_node_to_layer_above_ready),
    .io_inner_node_to_layer_above_valid(sideband_switch_io_inner_node_to_layer_above_valid),
    .io_inner_node_to_layer_above_bits(sideband_switch_io_inner_node_to_layer_above_bits),
    .io_inner_layer_to_node_below_ready(sideband_switch_io_inner_layer_to_node_below_ready),
    .io_inner_layer_to_node_below_valid(sideband_switch_io_inner_layer_to_node_below_valid),
    .io_inner_layer_to_node_below_bits(sideband_switch_io_inner_layer_to_node_below_bits),
    .io_outer_node_to_layer_above_ready(sideband_switch_io_outer_node_to_layer_above_ready),
    .io_outer_node_to_layer_above_valid(sideband_switch_io_outer_node_to_layer_above_valid),
    .io_outer_node_to_layer_above_bits(sideband_switch_io_outer_node_to_layer_above_bits),
    .io_outer_layer_to_node_above_ready(sideband_switch_io_outer_layer_to_node_above_ready),
    .io_outer_layer_to_node_above_valid(sideband_switch_io_outer_layer_to_node_above_valid),
    .io_outer_layer_to_node_above_bits(sideband_switch_io_outer_layer_to_node_above_bits),
    .io_outer_node_to_layer_below_ready(sideband_switch_io_outer_node_to_layer_below_ready),
    .io_outer_node_to_layer_below_valid(sideband_switch_io_outer_node_to_layer_below_valid),
    .io_outer_node_to_layer_below_bits(sideband_switch_io_outer_node_to_layer_below_bits),
    .io_outer_layer_to_node_below_ready(sideband_switch_io_outer_layer_to_node_below_ready),
    .io_outer_layer_to_node_below_valid(sideband_switch_io_outer_layer_to_node_below_valid),
    .io_outer_layer_to_node_below_bits(sideband_switch_io_outer_layer_to_node_below_bits)
  );
  assign io_rdi_pl_cfg_crd = rdi_sideband_node_io_outer_rx_credit; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 54:23]
  assign io_rdi_lp_cfg = rdi_sideband_node_io_outer_tx_bits; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 56:19]
  assign io_rdi_lp_cfg_vld = rdi_sideband_node_io_outer_tx_valid; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 57:23]
  assign io_sideband_rcv = sideband_switch_io_inner_node_to_layer_above_valid &
    sideband_switch_io_inner_node_to_layer_above_ready ? _GEN_14 : 6'h0; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 71:115 106:25]
  assign io_sideband_rdy = io_sideband_snt != 6'h0 & (sideband_switch_io_inner_layer_to_node_below_valid &
    sideband_switch_io_inner_layer_to_node_below_ready); // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 110:50 145:25 149:25]
  assign fdi_sideband_node_clock = clock;
  assign fdi_sideband_node_reset = reset;
  assign fdi_sideband_node_io_inner_layer_to_node_valid = sideband_switch_io_outer_layer_to_node_above_valid; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 60:50]
  assign fdi_sideband_node_io_inner_layer_to_node_bits = sideband_switch_io_outer_layer_to_node_above_bits; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 60:50]
  assign fdi_sideband_node_io_inner_node_to_layer_ready = sideband_switch_io_outer_node_to_layer_above_ready; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 62:50]
  assign fdi_sideband_node_io_outer_tx_credit = 1'h0; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 46:42]
  assign fdi_sideband_node_io_outer_rx_bits = 128'h0; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 48:40]
  assign fdi_sideband_node_io_outer_rx_valid = 1'h0; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 49:41]
  assign rdi_sideband_node_clock = clock;
  assign rdi_sideband_node_reset = reset;
  assign rdi_sideband_node_io_inner_layer_to_node_valid = sideband_switch_io_outer_layer_to_node_below_valid; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 61:50]
  assign rdi_sideband_node_io_inner_layer_to_node_bits = sideband_switch_io_outer_layer_to_node_below_bits; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 61:50]
  assign rdi_sideband_node_io_inner_node_to_layer_ready = sideband_switch_io_outer_node_to_layer_below_ready; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 63:50]
  assign rdi_sideband_node_io_outer_tx_credit = io_rdi_lp_cfg_crd; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 58:42]
  assign rdi_sideband_node_io_outer_rx_bits = io_rdi_pl_cfg; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 52:40]
  assign rdi_sideband_node_io_outer_rx_valid = io_rdi_pl_cfg_vld; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 53:41]
  assign sideband_switch_io_inner_node_to_layer_above_ready = 1'h1; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 69:56]
  assign sideband_switch_io_inner_layer_to_node_below_valid = io_sideband_snt != 6'h0; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 110:26]
  assign sideband_switch_io_inner_layer_to_node_below_bits = _GEN_31[127:0];
  assign sideband_switch_io_outer_node_to_layer_above_valid = fdi_sideband_node_io_inner_node_to_layer_valid; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 62:50]
  assign sideband_switch_io_outer_node_to_layer_above_bits = fdi_sideband_node_io_inner_node_to_layer_bits; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 62:50]
  assign sideband_switch_io_outer_layer_to_node_above_ready = fdi_sideband_node_io_inner_layer_to_node_ready; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 60:50]
  assign sideband_switch_io_outer_node_to_layer_below_valid = rdi_sideband_node_io_inner_node_to_layer_valid; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 63:50]
  assign sideband_switch_io_outer_node_to_layer_below_bits = rdi_sideband_node_io_inner_node_to_layer_bits; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 63:50]
  assign sideband_switch_io_outer_layer_to_node_below_ready = rdi_sideband_node_io_inner_layer_to_node_ready; // @[src/main/scala/d2dadapter/D2DSidebandModule.scala 61:50]
endmodule
module D2DMainbandModule(
  input          clock,
  input          reset,
  input          io_fdi_lp_irdy, // @[src/main/scala/d2dadapter/D2DMainbandModule.scala 47:16]
  input          io_fdi_lp_valid, // @[src/main/scala/d2dadapter/D2DMainbandModule.scala 47:16]
  input  [511:0] io_fdi_lp_data, // @[src/main/scala/d2dadapter/D2DMainbandModule.scala 47:16]
  output         io_fdi_pl_trdy, // @[src/main/scala/d2dadapter/D2DMainbandModule.scala 47:16]
  output         io_fdi_pl_valid, // @[src/main/scala/d2dadapter/D2DMainbandModule.scala 47:16]
  output [511:0] io_fdi_pl_data, // @[src/main/scala/d2dadapter/D2DMainbandModule.scala 47:16]
  output         io_rdi_lp_irdy, // @[src/main/scala/d2dadapter/D2DMainbandModule.scala 47:16]
  output         io_rdi_lp_valid, // @[src/main/scala/d2dadapter/D2DMainbandModule.scala 47:16]
  output [511:0] io_rdi_lp_data, // @[src/main/scala/d2dadapter/D2DMainbandModule.scala 47:16]
  input          io_rdi_pl_trdy, // @[src/main/scala/d2dadapter/D2DMainbandModule.scala 47:16]
  input          io_rdi_pl_valid, // @[src/main/scala/d2dadapter/D2DMainbandModule.scala 47:16]
  input  [511:0] io_rdi_pl_data, // @[src/main/scala/d2dadapter/D2DMainbandModule.scala 47:16]
  input  [3:0]   io_d2d_state, // @[src/main/scala/d2dadapter/D2DMainbandModule.scala 47:16]
  input          io_mainband_stallreq, // @[src/main/scala/d2dadapter/D2DMainbandModule.scala 47:16]
  output         io_mainband_stalldone, // @[src/main/scala/d2dadapter/D2DMainbandModule.scala 47:16]
  output [511:0] io_snd_data, // @[src/main/scala/d2dadapter/D2DMainbandModule.scala 47:16]
  output         io_snd_data_vld, // @[src/main/scala/d2dadapter/D2DMainbandModule.scala 47:16]
  output         io_rcv_data_vld, // @[src/main/scala/d2dadapter/D2DMainbandModule.scala 47:16]
  input          io_parity_insert, // @[src/main/scala/d2dadapter/D2DMainbandModule.scala 47:16]
  input  [511:0] io_parity_data, // @[src/main/scala/d2dadapter/D2DMainbandModule.scala 47:16]
  output         io_parity_rdy, // @[src/main/scala/d2dadapter/D2DMainbandModule.scala 47:16]
  input          io_parity_check // @[src/main/scala/d2dadapter/D2DMainbandModule.scala 47:16]
);
  reg [511:0] data_buff_snt_reg; // @[src/main/scala/d2dadapter/D2DMainbandModule.scala 49:32]
  reg  data_buff_snt_fill_reg; // @[src/main/scala/d2dadapter/D2DMainbandModule.scala 50:41]
  reg [511:0] data_buff_rcv_reg; // @[src/main/scala/d2dadapter/D2DMainbandModule.scala 51:32]
  reg  data_buff_rcv_fill_reg; // @[src/main/scala/d2dadapter/D2DMainbandModule.scala 52:41]
  reg  stall_reg; // @[src/main/scala/d2dadapter/D2DMainbandModule.scala 55:28]
  wire  _GEN_0 = io_d2d_state != 4'h1 ? 1'h0 : stall_reg; // @[src/main/scala/d2dadapter/D2DMainbandModule.scala 62:49 63:19 65:19]
  wire  _GEN_1 = io_mainband_stallreq | _GEN_0; // @[src/main/scala/d2dadapter/D2DMainbandModule.scala 60:31 61:19]
  wire  snd_success_rdi = io_rdi_lp_irdy & io_rdi_lp_valid & io_rdi_pl_trdy; // @[src/main/scala/d2dadapter/D2DMainbandModule.scala 76:57]
  wire  _T_1 = ~io_parity_insert; // @[src/main/scala/d2dadapter/D2DMainbandModule.scala 79:10]
  wire  _T_3 = ~stall_reg; // @[src/main/scala/d2dadapter/D2DMainbandModule.scala 79:57]
  wire  _T_6 = io_parity_insert & _T_3; // @[src/main/scala/d2dadapter/D2DMainbandModule.scala 82:33]
  wire  _T_9 = io_fdi_lp_irdy & io_fdi_lp_valid; // @[src/main/scala/d2dadapter/D2DMainbandModule.scala 98:29]
  wire  _T_11 = _T_1 & snd_success_rdi; // @[src/main/scala/d2dadapter/D2DMainbandModule.scala 105:34]
  wire  _T_14 = io_rdi_pl_valid & ~io_parity_check; // @[src/main/scala/d2dadapter/D2DMainbandModule.scala 142:26]
  assign io_fdi_pl_trdy = ~data_buff_snt_fill_reg | _T_11; // @[src/main/scala/d2dadapter/D2DMainbandModule.scala 96:34 97:24]
  assign io_fdi_pl_valid = data_buff_rcv_fill_reg; // @[src/main/scala/d2dadapter/D2DMainbandModule.scala 136:33 137:25 139:25]
  assign io_fdi_pl_data = data_buff_rcv_reg; // @[src/main/scala/d2dadapter/D2DMainbandModule.scala 128:20]
  assign io_rdi_lp_irdy = ~io_parity_insert & data_buff_snt_fill_reg & ~stall_reg | _T_6; // @[src/main/scala/d2dadapter/D2DMainbandModule.scala 79:68 80:24]
  assign io_rdi_lp_valid = ~io_parity_insert & data_buff_snt_fill_reg & ~stall_reg | _T_6; // @[src/main/scala/d2dadapter/D2DMainbandModule.scala 79:68 80:24]
  assign io_rdi_lp_data = io_parity_insert ? io_parity_data : data_buff_snt_reg; // @[src/main/scala/d2dadapter/D2DMainbandModule.scala 68:27 69:24 71:24]
  assign io_mainband_stalldone = stall_reg; // @[src/main/scala/d2dadapter/D2DMainbandModule.scala 57:27]
  assign io_snd_data = io_fdi_lp_data; // @[src/main/scala/d2dadapter/D2DMainbandModule.scala 74:17]
  assign io_snd_data_vld = io_fdi_pl_trdy & io_fdi_lp_valid & io_fdi_lp_irdy; // @[src/main/scala/d2dadapter/D2DMainbandModule.scala 75:57]
  assign io_rcv_data_vld = io_rdi_pl_valid; // @[src/main/scala/d2dadapter/D2DMainbandModule.scala 127:21]
  assign io_parity_rdy = io_parity_insert & snd_success_rdi; // @[src/main/scala/d2dadapter/D2DMainbandModule.scala 90:27]
  always @(posedge clock) begin
    if (~data_buff_snt_fill_reg) begin // @[src/main/scala/d2dadapter/D2DMainbandModule.scala 96:34]
      data_buff_snt_reg <= io_fdi_lp_data;
    end else if (_T_1 & snd_success_rdi) begin // @[src/main/scala/d2dadapter/D2DMainbandModule.scala 105:53]
      if (_T_9) begin // @[src/main/scala/d2dadapter/D2DMainbandModule.scala 107:48]
        data_buff_snt_reg <= io_fdi_lp_data; // @[src/main/scala/d2dadapter/D2DMainbandModule.scala 109:31]
      end
    end
    if (reset) begin // @[src/main/scala/d2dadapter/D2DMainbandModule.scala 50:41]
      data_buff_snt_fill_reg <= 1'h0; // @[src/main/scala/d2dadapter/D2DMainbandModule.scala 50:41]
    end else if (~data_buff_snt_fill_reg) begin // @[src/main/scala/d2dadapter/D2DMainbandModule.scala 96:34]
      data_buff_snt_fill_reg <= _T_9;
    end else if (_T_1 & snd_success_rdi) begin // @[src/main/scala/d2dadapter/D2DMainbandModule.scala 105:53]
      data_buff_snt_fill_reg <= _T_9;
    end
    if (io_rdi_pl_valid) begin // @[src/main/scala/d2dadapter/D2DMainbandModule.scala 130:26]
      data_buff_rcv_reg <= io_rdi_pl_data; // @[src/main/scala/d2dadapter/D2DMainbandModule.scala 131:27]
    end
    if (reset) begin // @[src/main/scala/d2dadapter/D2DMainbandModule.scala 52:41]
      data_buff_rcv_fill_reg <= 1'h0; // @[src/main/scala/d2dadapter/D2DMainbandModule.scala 52:41]
    end else begin
      data_buff_rcv_fill_reg <= _T_14;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/D2DMainbandModule.scala 55:28]
      stall_reg <= 1'h0; // @[src/main/scala/d2dadapter/D2DMainbandModule.scala 55:28]
    end else begin
      stall_reg <= _GEN_1;
    end
  end
endmodule
module ParityGenerator(
  input        clock,
  input        reset,
  input  [7:0] io_snd_data_0, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_1, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_2, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_3, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_4, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_5, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_6, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_7, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_8, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_9, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_10, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_11, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_12, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_13, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_14, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_15, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_16, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_17, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_18, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_19, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_20, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_21, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_22, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_23, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_24, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_25, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_26, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_27, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_28, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_29, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_30, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_31, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_32, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_33, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_34, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_35, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_36, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_37, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_38, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_39, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_40, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_41, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_42, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_43, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_44, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_45, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_46, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_47, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_48, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_49, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_50, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_51, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_52, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_53, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_54, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_55, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_56, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_57, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_58, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_59, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_60, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_61, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_62, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [7:0] io_snd_data_63, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input        io_snd_data_vld, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input        io_rcv_data_vld, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_0, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_1, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_2, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_3, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_4, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_5, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_6, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_7, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_8, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_9, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_10, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_11, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_12, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_13, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_14, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_15, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_16, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_17, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_18, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_19, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_20, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_21, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_22, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_23, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_24, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_25, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_26, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_27, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_28, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_29, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_30, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_31, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_32, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_33, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_34, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_35, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_36, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_37, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_38, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_39, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_40, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_41, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_42, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_43, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_44, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_45, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_46, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_47, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_48, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_49, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_50, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_51, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_52, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_53, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_54, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_55, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_56, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_57, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_58, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_59, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_60, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_61, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_62, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output [7:0] io_parity_data_63, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output       io_parity_insert, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  output       io_parity_check, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input        io_parity_rdy, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input  [3:0] io_rdi_state, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input        io_parity_rx_enable, // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
  input        io_parity_tx_enable // @[src/main/scala/d2dadapter/ParityGenerator.scala 35:16]
);
  reg  parity_data_snd_reg_0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_1; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_2; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_3; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_4; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_5; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_6; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_7; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_8; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_9; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_10; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_11; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_12; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_13; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_14; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_15; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_16; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_17; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_18; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_19; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_20; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_21; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_22; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_23; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_24; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_25; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_26; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_27; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_28; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_29; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_30; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_31; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_32; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_33; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_34; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_35; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_36; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_37; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_38; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_39; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_40; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_41; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_42; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_43; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_44; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_45; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_46; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_47; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_48; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_49; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_50; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_51; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_52; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_53; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_54; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_55; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_56; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_57; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_58; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_59; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_60; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_61; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_62; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg  parity_data_snd_reg_63; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
  reg [18:0] parity_dcount_snd_reg; // @[src/main/scala/d2dadapter/ParityGenerator.scala 40:40]
  reg [8:0] parity_pcount_snd_reg; // @[src/main/scala/d2dadapter/ParityGenerator.scala 41:40]
  reg [18:0] parity_dcount_rcv_reg; // @[src/main/scala/d2dadapter/ParityGenerator.scala 42:40]
  reg [8:0] parity_pcount_rcv_reg; // @[src/main/scala/d2dadapter/ParityGenerator.scala 43:40]
  wire  _T_3 = io_rdi_state != 4'h1; // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:23]
  wire [8:0] _T_5 = parity_pcount_snd_reg + 9'h40; // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:38]
  wire  _parity_data_snd_reg_0_T_1 = parity_data_snd_reg_0 ^ ^io_snd_data_0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_1_T_1 = parity_data_snd_reg_1 ^ ^io_snd_data_1; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_2_T_1 = parity_data_snd_reg_2 ^ ^io_snd_data_2; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_3_T_1 = parity_data_snd_reg_3 ^ ^io_snd_data_3; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_4_T_1 = parity_data_snd_reg_4 ^ ^io_snd_data_4; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_5_T_1 = parity_data_snd_reg_5 ^ ^io_snd_data_5; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_6_T_1 = parity_data_snd_reg_6 ^ ^io_snd_data_6; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_7_T_1 = parity_data_snd_reg_7 ^ ^io_snd_data_7; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_8_T_1 = parity_data_snd_reg_8 ^ ^io_snd_data_8; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_9_T_1 = parity_data_snd_reg_9 ^ ^io_snd_data_9; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_10_T_1 = parity_data_snd_reg_10 ^ ^io_snd_data_10; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_11_T_1 = parity_data_snd_reg_11 ^ ^io_snd_data_11; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_12_T_1 = parity_data_snd_reg_12 ^ ^io_snd_data_12; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_13_T_1 = parity_data_snd_reg_13 ^ ^io_snd_data_13; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_14_T_1 = parity_data_snd_reg_14 ^ ^io_snd_data_14; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_15_T_1 = parity_data_snd_reg_15 ^ ^io_snd_data_15; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_16_T_1 = parity_data_snd_reg_16 ^ ^io_snd_data_16; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_17_T_1 = parity_data_snd_reg_17 ^ ^io_snd_data_17; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_18_T_1 = parity_data_snd_reg_18 ^ ^io_snd_data_18; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_19_T_1 = parity_data_snd_reg_19 ^ ^io_snd_data_19; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_20_T_1 = parity_data_snd_reg_20 ^ ^io_snd_data_20; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_21_T_1 = parity_data_snd_reg_21 ^ ^io_snd_data_21; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_22_T_1 = parity_data_snd_reg_22 ^ ^io_snd_data_22; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_23_T_1 = parity_data_snd_reg_23 ^ ^io_snd_data_23; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_24_T_1 = parity_data_snd_reg_24 ^ ^io_snd_data_24; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_25_T_1 = parity_data_snd_reg_25 ^ ^io_snd_data_25; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_26_T_1 = parity_data_snd_reg_26 ^ ^io_snd_data_26; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_27_T_1 = parity_data_snd_reg_27 ^ ^io_snd_data_27; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_28_T_1 = parity_data_snd_reg_28 ^ ^io_snd_data_28; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_29_T_1 = parity_data_snd_reg_29 ^ ^io_snd_data_29; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_30_T_1 = parity_data_snd_reg_30 ^ ^io_snd_data_30; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_31_T_1 = parity_data_snd_reg_31 ^ ^io_snd_data_31; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_32_T_1 = parity_data_snd_reg_32 ^ ^io_snd_data_32; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_33_T_1 = parity_data_snd_reg_33 ^ ^io_snd_data_33; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_34_T_1 = parity_data_snd_reg_34 ^ ^io_snd_data_34; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_35_T_1 = parity_data_snd_reg_35 ^ ^io_snd_data_35; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_36_T_1 = parity_data_snd_reg_36 ^ ^io_snd_data_36; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_37_T_1 = parity_data_snd_reg_37 ^ ^io_snd_data_37; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_38_T_1 = parity_data_snd_reg_38 ^ ^io_snd_data_38; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_39_T_1 = parity_data_snd_reg_39 ^ ^io_snd_data_39; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_40_T_1 = parity_data_snd_reg_40 ^ ^io_snd_data_40; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_41_T_1 = parity_data_snd_reg_41 ^ ^io_snd_data_41; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_42_T_1 = parity_data_snd_reg_42 ^ ^io_snd_data_42; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_43_T_1 = parity_data_snd_reg_43 ^ ^io_snd_data_43; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_44_T_1 = parity_data_snd_reg_44 ^ ^io_snd_data_44; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_45_T_1 = parity_data_snd_reg_45 ^ ^io_snd_data_45; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_46_T_1 = parity_data_snd_reg_46 ^ ^io_snd_data_46; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_47_T_1 = parity_data_snd_reg_47 ^ ^io_snd_data_47; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_48_T_1 = parity_data_snd_reg_48 ^ ^io_snd_data_48; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_49_T_1 = parity_data_snd_reg_49 ^ ^io_snd_data_49; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_50_T_1 = parity_data_snd_reg_50 ^ ^io_snd_data_50; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_51_T_1 = parity_data_snd_reg_51 ^ ^io_snd_data_51; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_52_T_1 = parity_data_snd_reg_52 ^ ^io_snd_data_52; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_53_T_1 = parity_data_snd_reg_53 ^ ^io_snd_data_53; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_54_T_1 = parity_data_snd_reg_54 ^ ^io_snd_data_54; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_55_T_1 = parity_data_snd_reg_55 ^ ^io_snd_data_55; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_56_T_1 = parity_data_snd_reg_56 ^ ^io_snd_data_56; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_57_T_1 = parity_data_snd_reg_57 ^ ^io_snd_data_57; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_58_T_1 = parity_data_snd_reg_58 ^ ^io_snd_data_58; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_59_T_1 = parity_data_snd_reg_59 ^ ^io_snd_data_59; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_60_T_1 = parity_data_snd_reg_60 ^ ^io_snd_data_60; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_61_T_1 = parity_data_snd_reg_61 ^ ^io_snd_data_61; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_62_T_1 = parity_data_snd_reg_62 ^ ^io_snd_data_62; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire  _parity_data_snd_reg_63_T_1 = parity_data_snd_reg_63 ^ ^io_snd_data_63; // @[src/main/scala/d2dadapter/ParityGenerator.scala 89:123]
  wire [18:0] _parity_dcount_snd_reg_T_1 = parity_dcount_snd_reg + 19'h40; // @[src/main/scala/d2dadapter/ParityGenerator.scala 117:56]
  wire [18:0] _GEN_1798 = parity_dcount_snd_reg == 19'h10000 & io_parity_rdy ? 19'h10000 : parity_dcount_snd_reg; // @[src/main/scala/d2dadapter/ParityGenerator.scala 119:69 145:31 47:27]
  wire [8:0] _GEN_1799 = parity_dcount_snd_reg == 19'h10000 & io_parity_rdy ? _T_5 : parity_pcount_snd_reg; // @[src/main/scala/d2dadapter/ParityGenerator.scala 119:69 146:31 48:27]
  wire [8:0] _T_21 = parity_pcount_rcv_reg + 9'h40; // @[src/main/scala/d2dadapter/ParityGenerator.scala 164:38]
  wire  _T_24 = parity_dcount_rcv_reg == 19'h10000; // @[src/main/scala/d2dadapter/ParityGenerator.scala 164:111]
  wire [18:0] _parity_dcount_rcv_reg_T_1 = parity_dcount_rcv_reg + 19'h40; // @[src/main/scala/d2dadapter/ParityGenerator.scala 206:56]
  wire [18:0] _GEN_4366 = _T_24 & io_rcv_data_vld ? 19'h10000 : parity_dcount_rcv_reg; // @[src/main/scala/d2dadapter/ParityGenerator.scala 209:71 237:31 242:31]
  wire [8:0] _GEN_4367 = _T_24 & io_rcv_data_vld ? _T_21 : parity_pcount_rcv_reg; // @[src/main/scala/d2dadapter/ParityGenerator.scala 209:71 238:31 243:31]
  assign io_parity_data_0 = {{7'd0}, parity_data_snd_reg_0}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_1 = {{7'd0}, parity_data_snd_reg_1}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_2 = {{7'd0}, parity_data_snd_reg_2}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_3 = {{7'd0}, parity_data_snd_reg_3}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_4 = {{7'd0}, parity_data_snd_reg_4}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_5 = {{7'd0}, parity_data_snd_reg_5}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_6 = {{7'd0}, parity_data_snd_reg_6}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_7 = {{7'd0}, parity_data_snd_reg_7}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_8 = {{7'd0}, parity_data_snd_reg_8}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_9 = {{7'd0}, parity_data_snd_reg_9}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_10 = {{7'd0}, parity_data_snd_reg_10}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_11 = {{7'd0}, parity_data_snd_reg_11}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_12 = {{7'd0}, parity_data_snd_reg_12}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_13 = {{7'd0}, parity_data_snd_reg_13}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_14 = {{7'd0}, parity_data_snd_reg_14}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_15 = {{7'd0}, parity_data_snd_reg_15}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_16 = {{7'd0}, parity_data_snd_reg_16}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_17 = {{7'd0}, parity_data_snd_reg_17}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_18 = {{7'd0}, parity_data_snd_reg_18}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_19 = {{7'd0}, parity_data_snd_reg_19}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_20 = {{7'd0}, parity_data_snd_reg_20}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_21 = {{7'd0}, parity_data_snd_reg_21}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_22 = {{7'd0}, parity_data_snd_reg_22}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_23 = {{7'd0}, parity_data_snd_reg_23}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_24 = {{7'd0}, parity_data_snd_reg_24}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_25 = {{7'd0}, parity_data_snd_reg_25}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_26 = {{7'd0}, parity_data_snd_reg_26}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_27 = {{7'd0}, parity_data_snd_reg_27}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_28 = {{7'd0}, parity_data_snd_reg_28}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_29 = {{7'd0}, parity_data_snd_reg_29}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_30 = {{7'd0}, parity_data_snd_reg_30}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_31 = {{7'd0}, parity_data_snd_reg_31}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_32 = {{7'd0}, parity_data_snd_reg_32}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_33 = {{7'd0}, parity_data_snd_reg_33}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_34 = {{7'd0}, parity_data_snd_reg_34}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_35 = {{7'd0}, parity_data_snd_reg_35}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_36 = {{7'd0}, parity_data_snd_reg_36}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_37 = {{7'd0}, parity_data_snd_reg_37}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_38 = {{7'd0}, parity_data_snd_reg_38}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_39 = {{7'd0}, parity_data_snd_reg_39}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_40 = {{7'd0}, parity_data_snd_reg_40}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_41 = {{7'd0}, parity_data_snd_reg_41}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_42 = {{7'd0}, parity_data_snd_reg_42}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_43 = {{7'd0}, parity_data_snd_reg_43}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_44 = {{7'd0}, parity_data_snd_reg_44}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_45 = {{7'd0}, parity_data_snd_reg_45}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_46 = {{7'd0}, parity_data_snd_reg_46}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_47 = {{7'd0}, parity_data_snd_reg_47}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_48 = {{7'd0}, parity_data_snd_reg_48}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_49 = {{7'd0}, parity_data_snd_reg_49}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_50 = {{7'd0}, parity_data_snd_reg_50}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_51 = {{7'd0}, parity_data_snd_reg_51}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_52 = {{7'd0}, parity_data_snd_reg_52}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_53 = {{7'd0}, parity_data_snd_reg_53}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_54 = {{7'd0}, parity_data_snd_reg_54}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_55 = {{7'd0}, parity_data_snd_reg_55}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_56 = {{7'd0}, parity_data_snd_reg_56}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_57 = {{7'd0}, parity_data_snd_reg_57}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_58 = {{7'd0}, parity_data_snd_reg_58}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_59 = {{7'd0}, parity_data_snd_reg_59}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_60 = {{7'd0}, parity_data_snd_reg_60}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_61 = {{7'd0}, parity_data_snd_reg_61}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_62 = {{7'd0}, parity_data_snd_reg_62}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_data_63 = {{7'd0}, parity_data_snd_reg_63}; // @[src/main/scala/d2dadapter/ParityGenerator.scala 150:27]
  assign io_parity_insert = parity_dcount_snd_reg == 19'h10000; // @[src/main/scala/d2dadapter/ParityGenerator.scala 152:47]
  assign io_parity_check = parity_dcount_rcv_reg == 19'h10000; // @[src/main/scala/d2dadapter/ParityGenerator.scala 247:47]
  always @(posedge clock) begin
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_0 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_0 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_0 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_0 <= _parity_data_snd_reg_0_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_1 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_1 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_1 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_1 <= _parity_data_snd_reg_1_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_2 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_2 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_2 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_2 <= _parity_data_snd_reg_2_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_3 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_3 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_3 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_3 <= _parity_data_snd_reg_3_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_4 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_4 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_4 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_4 <= _parity_data_snd_reg_4_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_5 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_5 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_5 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_5 <= _parity_data_snd_reg_5_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_6 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_6 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_6 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_6 <= _parity_data_snd_reg_6_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_7 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_7 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_7 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_7 <= _parity_data_snd_reg_7_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_8 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_8 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_8 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_8 <= _parity_data_snd_reg_8_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_9 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_9 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_9 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_9 <= _parity_data_snd_reg_9_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_10 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_10 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_10 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_10 <= _parity_data_snd_reg_10_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_11 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_11 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_11 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_11 <= _parity_data_snd_reg_11_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_12 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_12 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_12 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_12 <= _parity_data_snd_reg_12_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_13 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_13 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_13 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_13 <= _parity_data_snd_reg_13_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_14 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_14 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_14 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_14 <= _parity_data_snd_reg_14_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_15 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_15 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_15 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_15 <= _parity_data_snd_reg_15_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_16 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_16 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_16 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_16 <= _parity_data_snd_reg_16_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_17 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_17 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_17 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_17 <= _parity_data_snd_reg_17_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_18 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_18 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_18 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_18 <= _parity_data_snd_reg_18_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_19 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_19 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_19 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_19 <= _parity_data_snd_reg_19_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_20 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_20 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_20 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_20 <= _parity_data_snd_reg_20_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_21 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_21 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_21 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_21 <= _parity_data_snd_reg_21_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_22 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_22 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_22 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_22 <= _parity_data_snd_reg_22_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_23 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_23 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_23 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_23 <= _parity_data_snd_reg_23_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_24 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_24 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_24 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_24 <= _parity_data_snd_reg_24_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_25 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_25 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_25 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_25 <= _parity_data_snd_reg_25_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_26 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_26 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_26 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_26 <= _parity_data_snd_reg_26_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_27 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_27 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_27 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_27 <= _parity_data_snd_reg_27_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_28 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_28 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_28 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_28 <= _parity_data_snd_reg_28_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_29 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_29 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_29 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_29 <= _parity_data_snd_reg_29_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_30 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_30 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_30 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_30 <= _parity_data_snd_reg_30_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_31 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_31 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_31 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_31 <= _parity_data_snd_reg_31_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_32 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_32 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_32 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_32 <= _parity_data_snd_reg_32_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_33 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_33 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_33 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_33 <= _parity_data_snd_reg_33_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_34 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_34 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_34 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_34 <= _parity_data_snd_reg_34_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_35 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_35 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_35 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_35 <= _parity_data_snd_reg_35_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_36 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_36 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_36 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_36 <= _parity_data_snd_reg_36_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_37 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_37 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_37 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_37 <= _parity_data_snd_reg_37_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_38 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_38 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_38 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_38 <= _parity_data_snd_reg_38_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_39 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_39 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_39 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_39 <= _parity_data_snd_reg_39_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_40 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_40 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_40 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_40 <= _parity_data_snd_reg_40_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_41 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_41 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_41 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_41 <= _parity_data_snd_reg_41_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_42 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_42 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_42 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_42 <= _parity_data_snd_reg_42_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_43 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_43 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_43 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_43 <= _parity_data_snd_reg_43_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_44 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_44 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_44 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_44 <= _parity_data_snd_reg_44_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_45 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_45 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_45 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_45 <= _parity_data_snd_reg_45_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_46 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_46 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_46 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_46 <= _parity_data_snd_reg_46_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_47 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_47 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_47 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_47 <= _parity_data_snd_reg_47_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_48 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_48 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_48 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_48 <= _parity_data_snd_reg_48_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_49 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_49 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_49 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_49 <= _parity_data_snd_reg_49_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_50 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_50 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_50 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_50 <= _parity_data_snd_reg_50_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_51 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_51 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_51 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_51 <= _parity_data_snd_reg_51_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_52 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_52 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_52 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_52 <= _parity_data_snd_reg_52_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_53 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_53 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_53 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_53 <= _parity_data_snd_reg_53_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_54 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_54 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_54 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_54 <= _parity_data_snd_reg_54_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_55 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_55 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_55 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_55 <= _parity_data_snd_reg_55_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_56 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_56 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_56 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_56 <= _parity_data_snd_reg_56_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_57 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_57 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_57 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_57 <= _parity_data_snd_reg_57_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_58 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_58 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_58 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_58 <= _parity_data_snd_reg_58_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_59 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_59 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_59 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_59 <= _parity_data_snd_reg_59_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_60 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_60 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_60 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_60 <= _parity_data_snd_reg_60_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_61 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_61 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_61 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_61 <= _parity_data_snd_reg_61_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_62 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_62 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_62 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_62 <= _parity_data_snd_reg_62_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
      parity_data_snd_reg_63 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 37:38]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_data_snd_reg_63 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 72:36]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_data_snd_reg_63 <= 1'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 78:36]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_data_snd_reg_63 <= _parity_data_snd_reg_63_T_1;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 40:40]
      parity_dcount_snd_reg <= 19'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 40:40]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_dcount_snd_reg <= 19'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 74:31]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_dcount_snd_reg <= 19'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 80:31]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_dcount_snd_reg <= _parity_dcount_snd_reg_T_1; // @[src/main/scala/d2dadapter/ParityGenerator.scala 117:31]
    end else begin
      parity_dcount_snd_reg <= _GEN_1798;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 41:40]
      parity_pcount_snd_reg <= 9'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 41:40]
    end else if (io_rdi_state != 4'h1) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 70:43]
      parity_pcount_snd_reg <= 9'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 75:31]
    end else if (_T_5 == 9'h40 & io_parity_rdy) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 76:84]
      parity_pcount_snd_reg <= 9'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 81:31]
    end else if (io_snd_data_vld & io_parity_tx_enable & parity_dcount_snd_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 82:94]
      parity_pcount_snd_reg <= 9'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 118:31]
    end else begin
      parity_pcount_snd_reg <= _GEN_1799;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 42:40]
      parity_dcount_rcv_reg <= 19'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 42:40]
    end else if (_T_3) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 157:43]
      parity_dcount_rcv_reg <= 19'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 161:31]
    end else if (_T_21 == 9'h40 & io_rcv_data_vld & parity_dcount_rcv_reg == 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 164:125]
      parity_dcount_rcv_reg <= 19'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 168:31]
    end else if (io_rcv_data_vld & io_parity_rx_enable & parity_dcount_rcv_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 171:94]
      parity_dcount_rcv_reg <= _parity_dcount_rcv_reg_T_1; // @[src/main/scala/d2dadapter/ParityGenerator.scala 206:31]
    end else begin
      parity_dcount_rcv_reg <= _GEN_4366;
    end
    if (reset) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 43:40]
      parity_pcount_rcv_reg <= 9'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 43:40]
    end else if (_T_3) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 157:43]
      parity_pcount_rcv_reg <= 9'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 162:31]
    end else if (_T_21 == 9'h40 & io_rcv_data_vld & parity_dcount_rcv_reg == 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 164:125]
      parity_pcount_rcv_reg <= 9'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 169:31]
    end else if (io_rcv_data_vld & io_parity_rx_enable & parity_dcount_rcv_reg != 19'h10000) begin // @[src/main/scala/d2dadapter/ParityGenerator.scala 171:94]
      parity_pcount_rcv_reg <= 9'h0; // @[src/main/scala/d2dadapter/ParityGenerator.scala 207:31]
    end else begin
      parity_pcount_rcv_reg <= _GEN_4367;
    end
  end
endmodule
module D2DAdapter(
  input          clock,
  input          reset,
  output         io_fdi_lpData_ready, // @[src/main/scala/d2dadapter/D2DAdapter.scala 28:16]
  input          io_fdi_lpData_valid, // @[src/main/scala/d2dadapter/D2DAdapter.scala 28:16]
  input          io_fdi_lpData_irdy, // @[src/main/scala/d2dadapter/D2DAdapter.scala 28:16]
  input  [511:0] io_fdi_lpData_bits, // @[src/main/scala/d2dadapter/D2DAdapter.scala 28:16]
  output         io_fdi_plData_valid, // @[src/main/scala/d2dadapter/D2DAdapter.scala 28:16]
  output [511:0] io_fdi_plData_bits, // @[src/main/scala/d2dadapter/D2DAdapter.scala 28:16]
  input  [3:0]   io_fdi_lpStateReq, // @[src/main/scala/d2dadapter/D2DAdapter.scala 28:16]
  input          io_fdi_lpLinkError, // @[src/main/scala/d2dadapter/D2DAdapter.scala 28:16]
  output [3:0]   io_fdi_plStateStatus, // @[src/main/scala/d2dadapter/D2DAdapter.scala 28:16]
  output         io_fdi_plInbandPres, // @[src/main/scala/d2dadapter/D2DAdapter.scala 28:16]
  output         io_fdi_plRxActiveReq, // @[src/main/scala/d2dadapter/D2DAdapter.scala 28:16]
  input          io_fdi_lpRxActiveStatus, // @[src/main/scala/d2dadapter/D2DAdapter.scala 28:16]
  output         io_fdi_plStallReq, // @[src/main/scala/d2dadapter/D2DAdapter.scala 28:16]
  input          io_fdi_lpStallAck, // @[src/main/scala/d2dadapter/D2DAdapter.scala 28:16]
  input          io_rdi_lpData_ready, // @[src/main/scala/d2dadapter/D2DAdapter.scala 28:16]
  output         io_rdi_lpData_valid, // @[src/main/scala/d2dadapter/D2DAdapter.scala 28:16]
  output         io_rdi_lpData_irdy, // @[src/main/scala/d2dadapter/D2DAdapter.scala 28:16]
  output [511:0] io_rdi_lpData_bits, // @[src/main/scala/d2dadapter/D2DAdapter.scala 28:16]
  input          io_rdi_plData_valid, // @[src/main/scala/d2dadapter/D2DAdapter.scala 28:16]
  input  [511:0] io_rdi_plData_bits, // @[src/main/scala/d2dadapter/D2DAdapter.scala 28:16]
  output [3:0]   io_rdi_lpStateReq, // @[src/main/scala/d2dadapter/D2DAdapter.scala 28:16]
  output         io_rdi_lpLinkError, // @[src/main/scala/d2dadapter/D2DAdapter.scala 28:16]
  input  [3:0]   io_rdi_plStateStatus, // @[src/main/scala/d2dadapter/D2DAdapter.scala 28:16]
  input          io_rdi_plInbandPres, // @[src/main/scala/d2dadapter/D2DAdapter.scala 28:16]
  input          io_rdi_plStallReq, // @[src/main/scala/d2dadapter/D2DAdapter.scala 28:16]
  output         io_rdi_lpStallAck, // @[src/main/scala/d2dadapter/D2DAdapter.scala 28:16]
  input          io_rdi_plConfig_valid, // @[src/main/scala/d2dadapter/D2DAdapter.scala 28:16]
  input  [127:0] io_rdi_plConfig_bits, // @[src/main/scala/d2dadapter/D2DAdapter.scala 28:16]
  output         io_rdi_plConfigCredit, // @[src/main/scala/d2dadapter/D2DAdapter.scala 28:16]
  output         io_rdi_lpConfig_valid, // @[src/main/scala/d2dadapter/D2DAdapter.scala 28:16]
  output [127:0] io_rdi_lpConfig_bits, // @[src/main/scala/d2dadapter/D2DAdapter.scala 28:16]
  input          io_rdi_lpConfigCredit // @[src/main/scala/d2dadapter/D2DAdapter.scala 28:16]
);
  wire  link_manager_clock; // @[src/main/scala/d2dadapter/D2DAdapter.scala 33:30]
  wire  link_manager_reset; // @[src/main/scala/d2dadapter/D2DAdapter.scala 33:30]
  wire [3:0] link_manager_io_fdi_lp_state_req; // @[src/main/scala/d2dadapter/D2DAdapter.scala 33:30]
  wire  link_manager_io_fdi_lp_linkerror; // @[src/main/scala/d2dadapter/D2DAdapter.scala 33:30]
  wire  link_manager_io_fdi_lp_rx_active_sts; // @[src/main/scala/d2dadapter/D2DAdapter.scala 33:30]
  wire [3:0] link_manager_io_fdi_pl_state_sts; // @[src/main/scala/d2dadapter/D2DAdapter.scala 33:30]
  wire  link_manager_io_fdi_pl_rx_active_req; // @[src/main/scala/d2dadapter/D2DAdapter.scala 33:30]
  wire  link_manager_io_fdi_pl_inband_pres; // @[src/main/scala/d2dadapter/D2DAdapter.scala 33:30]
  wire  link_manager_io_rdi_lp_linkerror; // @[src/main/scala/d2dadapter/D2DAdapter.scala 33:30]
  wire [3:0] link_manager_io_rdi_lp_state_req; // @[src/main/scala/d2dadapter/D2DAdapter.scala 33:30]
  wire [3:0] link_manager_io_rdi_pl_state_sts; // @[src/main/scala/d2dadapter/D2DAdapter.scala 33:30]
  wire  link_manager_io_rdi_pl_inband_pres; // @[src/main/scala/d2dadapter/D2DAdapter.scala 33:30]
  wire [5:0] link_manager_io_sb_snd; // @[src/main/scala/d2dadapter/D2DAdapter.scala 33:30]
  wire [5:0] link_manager_io_sb_rcv; // @[src/main/scala/d2dadapter/D2DAdapter.scala 33:30]
  wire  link_manager_io_sb_rdy; // @[src/main/scala/d2dadapter/D2DAdapter.scala 33:30]
  wire  link_manager_io_linkmgmt_stallreq; // @[src/main/scala/d2dadapter/D2DAdapter.scala 33:30]
  wire  link_manager_io_linkmgmt_stalldone; // @[src/main/scala/d2dadapter/D2DAdapter.scala 33:30]
  wire  link_manager_io_parity_rx_enable; // @[src/main/scala/d2dadapter/D2DAdapter.scala 33:30]
  wire  link_manager_io_parity_tx_enable; // @[src/main/scala/d2dadapter/D2DAdapter.scala 33:30]
  wire  fdi_stall_handler_clock; // @[src/main/scala/d2dadapter/D2DAdapter.scala 34:35]
  wire  fdi_stall_handler_reset; // @[src/main/scala/d2dadapter/D2DAdapter.scala 34:35]
  wire  fdi_stall_handler_io_linkmgmt_stallreq; // @[src/main/scala/d2dadapter/D2DAdapter.scala 34:35]
  wire  fdi_stall_handler_io_linkmgmt_stalldone; // @[src/main/scala/d2dadapter/D2DAdapter.scala 34:35]
  wire  fdi_stall_handler_io_fdi_pl_stallreq; // @[src/main/scala/d2dadapter/D2DAdapter.scala 34:35]
  wire  fdi_stall_handler_io_fdi_lp_stallack; // @[src/main/scala/d2dadapter/D2DAdapter.scala 34:35]
  wire  rdi_stall_handler_clock; // @[src/main/scala/d2dadapter/D2DAdapter.scala 35:35]
  wire  rdi_stall_handler_reset; // @[src/main/scala/d2dadapter/D2DAdapter.scala 35:35]
  wire  rdi_stall_handler_io_mainband_stallreq; // @[src/main/scala/d2dadapter/D2DAdapter.scala 35:35]
  wire  rdi_stall_handler_io_mainband_stalldone; // @[src/main/scala/d2dadapter/D2DAdapter.scala 35:35]
  wire  rdi_stall_handler_io_rdi_pl_stallreq; // @[src/main/scala/d2dadapter/D2DAdapter.scala 35:35]
  wire  rdi_stall_handler_io_rdi_lp_stallack; // @[src/main/scala/d2dadapter/D2DAdapter.scala 35:35]
  wire  d2d_sideband_clock; // @[src/main/scala/d2dadapter/D2DAdapter.scala 37:30]
  wire  d2d_sideband_reset; // @[src/main/scala/d2dadapter/D2DAdapter.scala 37:30]
  wire [127:0] d2d_sideband_io_rdi_pl_cfg; // @[src/main/scala/d2dadapter/D2DAdapter.scala 37:30]
  wire  d2d_sideband_io_rdi_pl_cfg_vld; // @[src/main/scala/d2dadapter/D2DAdapter.scala 37:30]
  wire  d2d_sideband_io_rdi_pl_cfg_crd; // @[src/main/scala/d2dadapter/D2DAdapter.scala 37:30]
  wire [127:0] d2d_sideband_io_rdi_lp_cfg; // @[src/main/scala/d2dadapter/D2DAdapter.scala 37:30]
  wire  d2d_sideband_io_rdi_lp_cfg_vld; // @[src/main/scala/d2dadapter/D2DAdapter.scala 37:30]
  wire  d2d_sideband_io_rdi_lp_cfg_crd; // @[src/main/scala/d2dadapter/D2DAdapter.scala 37:30]
  wire [5:0] d2d_sideband_io_sideband_rcv; // @[src/main/scala/d2dadapter/D2DAdapter.scala 37:30]
  wire [5:0] d2d_sideband_io_sideband_snt; // @[src/main/scala/d2dadapter/D2DAdapter.scala 37:30]
  wire  d2d_sideband_io_sideband_rdy; // @[src/main/scala/d2dadapter/D2DAdapter.scala 37:30]
  wire  d2d_mainband_clock; // @[src/main/scala/d2dadapter/D2DAdapter.scala 38:30]
  wire  d2d_mainband_reset; // @[src/main/scala/d2dadapter/D2DAdapter.scala 38:30]
  wire  d2d_mainband_io_fdi_lp_irdy; // @[src/main/scala/d2dadapter/D2DAdapter.scala 38:30]
  wire  d2d_mainband_io_fdi_lp_valid; // @[src/main/scala/d2dadapter/D2DAdapter.scala 38:30]
  wire [511:0] d2d_mainband_io_fdi_lp_data; // @[src/main/scala/d2dadapter/D2DAdapter.scala 38:30]
  wire  d2d_mainband_io_fdi_pl_trdy; // @[src/main/scala/d2dadapter/D2DAdapter.scala 38:30]
  wire  d2d_mainband_io_fdi_pl_valid; // @[src/main/scala/d2dadapter/D2DAdapter.scala 38:30]
  wire [511:0] d2d_mainband_io_fdi_pl_data; // @[src/main/scala/d2dadapter/D2DAdapter.scala 38:30]
  wire  d2d_mainband_io_rdi_lp_irdy; // @[src/main/scala/d2dadapter/D2DAdapter.scala 38:30]
  wire  d2d_mainband_io_rdi_lp_valid; // @[src/main/scala/d2dadapter/D2DAdapter.scala 38:30]
  wire [511:0] d2d_mainband_io_rdi_lp_data; // @[src/main/scala/d2dadapter/D2DAdapter.scala 38:30]
  wire  d2d_mainband_io_rdi_pl_trdy; // @[src/main/scala/d2dadapter/D2DAdapter.scala 38:30]
  wire  d2d_mainband_io_rdi_pl_valid; // @[src/main/scala/d2dadapter/D2DAdapter.scala 38:30]
  wire [511:0] d2d_mainband_io_rdi_pl_data; // @[src/main/scala/d2dadapter/D2DAdapter.scala 38:30]
  wire [3:0] d2d_mainband_io_d2d_state; // @[src/main/scala/d2dadapter/D2DAdapter.scala 38:30]
  wire  d2d_mainband_io_mainband_stallreq; // @[src/main/scala/d2dadapter/D2DAdapter.scala 38:30]
  wire  d2d_mainband_io_mainband_stalldone; // @[src/main/scala/d2dadapter/D2DAdapter.scala 38:30]
  wire [511:0] d2d_mainband_io_snd_data; // @[src/main/scala/d2dadapter/D2DAdapter.scala 38:30]
  wire  d2d_mainband_io_snd_data_vld; // @[src/main/scala/d2dadapter/D2DAdapter.scala 38:30]
  wire  d2d_mainband_io_rcv_data_vld; // @[src/main/scala/d2dadapter/D2DAdapter.scala 38:30]
  wire  d2d_mainband_io_parity_insert; // @[src/main/scala/d2dadapter/D2DAdapter.scala 38:30]
  wire [511:0] d2d_mainband_io_parity_data; // @[src/main/scala/d2dadapter/D2DAdapter.scala 38:30]
  wire  d2d_mainband_io_parity_rdy; // @[src/main/scala/d2dadapter/D2DAdapter.scala 38:30]
  wire  d2d_mainband_io_parity_check; // @[src/main/scala/d2dadapter/D2DAdapter.scala 38:30]
  wire  parity_generator_clock; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire  parity_generator_reset; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_0; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_1; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_2; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_3; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_4; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_5; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_6; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_7; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_8; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_9; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_10; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_11; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_12; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_13; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_14; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_15; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_16; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_17; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_18; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_19; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_20; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_21; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_22; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_23; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_24; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_25; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_26; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_27; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_28; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_29; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_30; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_31; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_32; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_33; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_34; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_35; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_36; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_37; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_38; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_39; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_40; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_41; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_42; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_43; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_44; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_45; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_46; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_47; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_48; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_49; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_50; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_51; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_52; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_53; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_54; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_55; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_56; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_57; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_58; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_59; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_60; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_61; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_62; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_snd_data_63; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire  parity_generator_io_snd_data_vld; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire  parity_generator_io_rcv_data_vld; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_0; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_1; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_2; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_3; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_4; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_5; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_6; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_7; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_8; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_9; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_10; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_11; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_12; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_13; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_14; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_15; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_16; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_17; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_18; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_19; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_20; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_21; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_22; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_23; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_24; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_25; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_26; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_27; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_28; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_29; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_30; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_31; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_32; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_33; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_34; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_35; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_36; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_37; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_38; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_39; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_40; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_41; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_42; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_43; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_44; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_45; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_46; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_47; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_48; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_49; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_50; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_51; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_52; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_53; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_54; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_55; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_56; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_57; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_58; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_59; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_60; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_61; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_62; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [7:0] parity_generator_io_parity_data_63; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire  parity_generator_io_parity_insert; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire  parity_generator_io_parity_check; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire  parity_generator_io_parity_rdy; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [3:0] parity_generator_io_rdi_state; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire  parity_generator_io_parity_rx_enable; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire  parity_generator_io_parity_tx_enable; // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
  wire [511:0] _WIRE_1 = d2d_mainband_io_snd_data; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:{70,70}]
  wire [63:0] d2d_mainband_io_parity_data_lo_lo_lo = {parity_generator_io_parity_data_7,
    parity_generator_io_parity_data_6,parity_generator_io_parity_data_5,parity_generator_io_parity_data_4,
    parity_generator_io_parity_data_3,parity_generator_io_parity_data_2,parity_generator_io_parity_data_1,
    parity_generator_io_parity_data_0}; // @[src/main/scala/d2dadapter/D2DAdapter.scala 156:76]
  wire [127:0] d2d_mainband_io_parity_data_lo_lo = {parity_generator_io_parity_data_15,
    parity_generator_io_parity_data_14,parity_generator_io_parity_data_13,parity_generator_io_parity_data_12,
    parity_generator_io_parity_data_11,parity_generator_io_parity_data_10,parity_generator_io_parity_data_9,
    parity_generator_io_parity_data_8,d2d_mainband_io_parity_data_lo_lo_lo}; // @[src/main/scala/d2dadapter/D2DAdapter.scala 156:76]
  wire [63:0] d2d_mainband_io_parity_data_lo_hi_lo = {parity_generator_io_parity_data_23,
    parity_generator_io_parity_data_22,parity_generator_io_parity_data_21,parity_generator_io_parity_data_20,
    parity_generator_io_parity_data_19,parity_generator_io_parity_data_18,parity_generator_io_parity_data_17,
    parity_generator_io_parity_data_16}; // @[src/main/scala/d2dadapter/D2DAdapter.scala 156:76]
  wire [255:0] d2d_mainband_io_parity_data_lo = {parity_generator_io_parity_data_31,parity_generator_io_parity_data_30,
    parity_generator_io_parity_data_29,parity_generator_io_parity_data_28,parity_generator_io_parity_data_27,
    parity_generator_io_parity_data_26,parity_generator_io_parity_data_25,parity_generator_io_parity_data_24,
    d2d_mainband_io_parity_data_lo_hi_lo,d2d_mainband_io_parity_data_lo_lo}; // @[src/main/scala/d2dadapter/D2DAdapter.scala 156:76]
  wire [63:0] d2d_mainband_io_parity_data_hi_lo_lo = {parity_generator_io_parity_data_39,
    parity_generator_io_parity_data_38,parity_generator_io_parity_data_37,parity_generator_io_parity_data_36,
    parity_generator_io_parity_data_35,parity_generator_io_parity_data_34,parity_generator_io_parity_data_33,
    parity_generator_io_parity_data_32}; // @[src/main/scala/d2dadapter/D2DAdapter.scala 156:76]
  wire [127:0] d2d_mainband_io_parity_data_hi_lo = {parity_generator_io_parity_data_47,
    parity_generator_io_parity_data_46,parity_generator_io_parity_data_45,parity_generator_io_parity_data_44,
    parity_generator_io_parity_data_43,parity_generator_io_parity_data_42,parity_generator_io_parity_data_41,
    parity_generator_io_parity_data_40,d2d_mainband_io_parity_data_hi_lo_lo}; // @[src/main/scala/d2dadapter/D2DAdapter.scala 156:76]
  wire [63:0] d2d_mainband_io_parity_data_hi_hi_lo = {parity_generator_io_parity_data_55,
    parity_generator_io_parity_data_54,parity_generator_io_parity_data_53,parity_generator_io_parity_data_52,
    parity_generator_io_parity_data_51,parity_generator_io_parity_data_50,parity_generator_io_parity_data_49,
    parity_generator_io_parity_data_48}; // @[src/main/scala/d2dadapter/D2DAdapter.scala 156:76]
  wire [255:0] d2d_mainband_io_parity_data_hi = {parity_generator_io_parity_data_63,parity_generator_io_parity_data_62,
    parity_generator_io_parity_data_61,parity_generator_io_parity_data_60,parity_generator_io_parity_data_59,
    parity_generator_io_parity_data_58,parity_generator_io_parity_data_57,parity_generator_io_parity_data_56,
    d2d_mainband_io_parity_data_hi_hi_lo,d2d_mainband_io_parity_data_hi_lo}; // @[src/main/scala/d2dadapter/D2DAdapter.scala 156:76]
  LinkManagementController link_manager ( // @[src/main/scala/d2dadapter/D2DAdapter.scala 33:30]
    .clock(link_manager_clock),
    .reset(link_manager_reset),
    .io_fdi_lp_state_req(link_manager_io_fdi_lp_state_req),
    .io_fdi_lp_linkerror(link_manager_io_fdi_lp_linkerror),
    .io_fdi_lp_rx_active_sts(link_manager_io_fdi_lp_rx_active_sts),
    .io_fdi_pl_state_sts(link_manager_io_fdi_pl_state_sts),
    .io_fdi_pl_rx_active_req(link_manager_io_fdi_pl_rx_active_req),
    .io_fdi_pl_inband_pres(link_manager_io_fdi_pl_inband_pres),
    .io_rdi_lp_linkerror(link_manager_io_rdi_lp_linkerror),
    .io_rdi_lp_state_req(link_manager_io_rdi_lp_state_req),
    .io_rdi_pl_state_sts(link_manager_io_rdi_pl_state_sts),
    .io_rdi_pl_inband_pres(link_manager_io_rdi_pl_inband_pres),
    .io_sb_snd(link_manager_io_sb_snd),
    .io_sb_rcv(link_manager_io_sb_rcv),
    .io_sb_rdy(link_manager_io_sb_rdy),
    .io_linkmgmt_stallreq(link_manager_io_linkmgmt_stallreq),
    .io_linkmgmt_stalldone(link_manager_io_linkmgmt_stalldone),
    .io_parity_rx_enable(link_manager_io_parity_rx_enable),
    .io_parity_tx_enable(link_manager_io_parity_tx_enable)
  );
  FDIStallHandler fdi_stall_handler ( // @[src/main/scala/d2dadapter/D2DAdapter.scala 34:35]
    .clock(fdi_stall_handler_clock),
    .reset(fdi_stall_handler_reset),
    .io_linkmgmt_stallreq(fdi_stall_handler_io_linkmgmt_stallreq),
    .io_linkmgmt_stalldone(fdi_stall_handler_io_linkmgmt_stalldone),
    .io_fdi_pl_stallreq(fdi_stall_handler_io_fdi_pl_stallreq),
    .io_fdi_lp_stallack(fdi_stall_handler_io_fdi_lp_stallack)
  );
  RDIStallHandler rdi_stall_handler ( // @[src/main/scala/d2dadapter/D2DAdapter.scala 35:35]
    .clock(rdi_stall_handler_clock),
    .reset(rdi_stall_handler_reset),
    .io_mainband_stallreq(rdi_stall_handler_io_mainband_stallreq),
    .io_mainband_stalldone(rdi_stall_handler_io_mainband_stalldone),
    .io_rdi_pl_stallreq(rdi_stall_handler_io_rdi_pl_stallreq),
    .io_rdi_lp_stallack(rdi_stall_handler_io_rdi_lp_stallack)
  );
  D2DSidebandModule d2d_sideband ( // @[src/main/scala/d2dadapter/D2DAdapter.scala 37:30]
    .clock(d2d_sideband_clock),
    .reset(d2d_sideband_reset),
    .io_rdi_pl_cfg(d2d_sideband_io_rdi_pl_cfg),
    .io_rdi_pl_cfg_vld(d2d_sideband_io_rdi_pl_cfg_vld),
    .io_rdi_pl_cfg_crd(d2d_sideband_io_rdi_pl_cfg_crd),
    .io_rdi_lp_cfg(d2d_sideband_io_rdi_lp_cfg),
    .io_rdi_lp_cfg_vld(d2d_sideband_io_rdi_lp_cfg_vld),
    .io_rdi_lp_cfg_crd(d2d_sideband_io_rdi_lp_cfg_crd),
    .io_sideband_rcv(d2d_sideband_io_sideband_rcv),
    .io_sideband_snt(d2d_sideband_io_sideband_snt),
    .io_sideband_rdy(d2d_sideband_io_sideband_rdy)
  );
  D2DMainbandModule d2d_mainband ( // @[src/main/scala/d2dadapter/D2DAdapter.scala 38:30]
    .clock(d2d_mainband_clock),
    .reset(d2d_mainband_reset),
    .io_fdi_lp_irdy(d2d_mainband_io_fdi_lp_irdy),
    .io_fdi_lp_valid(d2d_mainband_io_fdi_lp_valid),
    .io_fdi_lp_data(d2d_mainband_io_fdi_lp_data),
    .io_fdi_pl_trdy(d2d_mainband_io_fdi_pl_trdy),
    .io_fdi_pl_valid(d2d_mainband_io_fdi_pl_valid),
    .io_fdi_pl_data(d2d_mainband_io_fdi_pl_data),
    .io_rdi_lp_irdy(d2d_mainband_io_rdi_lp_irdy),
    .io_rdi_lp_valid(d2d_mainband_io_rdi_lp_valid),
    .io_rdi_lp_data(d2d_mainband_io_rdi_lp_data),
    .io_rdi_pl_trdy(d2d_mainband_io_rdi_pl_trdy),
    .io_rdi_pl_valid(d2d_mainband_io_rdi_pl_valid),
    .io_rdi_pl_data(d2d_mainband_io_rdi_pl_data),
    .io_d2d_state(d2d_mainband_io_d2d_state),
    .io_mainband_stallreq(d2d_mainband_io_mainband_stallreq),
    .io_mainband_stalldone(d2d_mainband_io_mainband_stalldone),
    .io_snd_data(d2d_mainband_io_snd_data),
    .io_snd_data_vld(d2d_mainband_io_snd_data_vld),
    .io_rcv_data_vld(d2d_mainband_io_rcv_data_vld),
    .io_parity_insert(d2d_mainband_io_parity_insert),
    .io_parity_data(d2d_mainband_io_parity_data),
    .io_parity_rdy(d2d_mainband_io_parity_rdy),
    .io_parity_check(d2d_mainband_io_parity_check)
  );
  ParityGenerator parity_generator ( // @[src/main/scala/d2dadapter/D2DAdapter.scala 40:34]
    .clock(parity_generator_clock),
    .reset(parity_generator_reset),
    .io_snd_data_0(parity_generator_io_snd_data_0),
    .io_snd_data_1(parity_generator_io_snd_data_1),
    .io_snd_data_2(parity_generator_io_snd_data_2),
    .io_snd_data_3(parity_generator_io_snd_data_3),
    .io_snd_data_4(parity_generator_io_snd_data_4),
    .io_snd_data_5(parity_generator_io_snd_data_5),
    .io_snd_data_6(parity_generator_io_snd_data_6),
    .io_snd_data_7(parity_generator_io_snd_data_7),
    .io_snd_data_8(parity_generator_io_snd_data_8),
    .io_snd_data_9(parity_generator_io_snd_data_9),
    .io_snd_data_10(parity_generator_io_snd_data_10),
    .io_snd_data_11(parity_generator_io_snd_data_11),
    .io_snd_data_12(parity_generator_io_snd_data_12),
    .io_snd_data_13(parity_generator_io_snd_data_13),
    .io_snd_data_14(parity_generator_io_snd_data_14),
    .io_snd_data_15(parity_generator_io_snd_data_15),
    .io_snd_data_16(parity_generator_io_snd_data_16),
    .io_snd_data_17(parity_generator_io_snd_data_17),
    .io_snd_data_18(parity_generator_io_snd_data_18),
    .io_snd_data_19(parity_generator_io_snd_data_19),
    .io_snd_data_20(parity_generator_io_snd_data_20),
    .io_snd_data_21(parity_generator_io_snd_data_21),
    .io_snd_data_22(parity_generator_io_snd_data_22),
    .io_snd_data_23(parity_generator_io_snd_data_23),
    .io_snd_data_24(parity_generator_io_snd_data_24),
    .io_snd_data_25(parity_generator_io_snd_data_25),
    .io_snd_data_26(parity_generator_io_snd_data_26),
    .io_snd_data_27(parity_generator_io_snd_data_27),
    .io_snd_data_28(parity_generator_io_snd_data_28),
    .io_snd_data_29(parity_generator_io_snd_data_29),
    .io_snd_data_30(parity_generator_io_snd_data_30),
    .io_snd_data_31(parity_generator_io_snd_data_31),
    .io_snd_data_32(parity_generator_io_snd_data_32),
    .io_snd_data_33(parity_generator_io_snd_data_33),
    .io_snd_data_34(parity_generator_io_snd_data_34),
    .io_snd_data_35(parity_generator_io_snd_data_35),
    .io_snd_data_36(parity_generator_io_snd_data_36),
    .io_snd_data_37(parity_generator_io_snd_data_37),
    .io_snd_data_38(parity_generator_io_snd_data_38),
    .io_snd_data_39(parity_generator_io_snd_data_39),
    .io_snd_data_40(parity_generator_io_snd_data_40),
    .io_snd_data_41(parity_generator_io_snd_data_41),
    .io_snd_data_42(parity_generator_io_snd_data_42),
    .io_snd_data_43(parity_generator_io_snd_data_43),
    .io_snd_data_44(parity_generator_io_snd_data_44),
    .io_snd_data_45(parity_generator_io_snd_data_45),
    .io_snd_data_46(parity_generator_io_snd_data_46),
    .io_snd_data_47(parity_generator_io_snd_data_47),
    .io_snd_data_48(parity_generator_io_snd_data_48),
    .io_snd_data_49(parity_generator_io_snd_data_49),
    .io_snd_data_50(parity_generator_io_snd_data_50),
    .io_snd_data_51(parity_generator_io_snd_data_51),
    .io_snd_data_52(parity_generator_io_snd_data_52),
    .io_snd_data_53(parity_generator_io_snd_data_53),
    .io_snd_data_54(parity_generator_io_snd_data_54),
    .io_snd_data_55(parity_generator_io_snd_data_55),
    .io_snd_data_56(parity_generator_io_snd_data_56),
    .io_snd_data_57(parity_generator_io_snd_data_57),
    .io_snd_data_58(parity_generator_io_snd_data_58),
    .io_snd_data_59(parity_generator_io_snd_data_59),
    .io_snd_data_60(parity_generator_io_snd_data_60),
    .io_snd_data_61(parity_generator_io_snd_data_61),
    .io_snd_data_62(parity_generator_io_snd_data_62),
    .io_snd_data_63(parity_generator_io_snd_data_63),
    .io_snd_data_vld(parity_generator_io_snd_data_vld),
    .io_rcv_data_vld(parity_generator_io_rcv_data_vld),
    .io_parity_data_0(parity_generator_io_parity_data_0),
    .io_parity_data_1(parity_generator_io_parity_data_1),
    .io_parity_data_2(parity_generator_io_parity_data_2),
    .io_parity_data_3(parity_generator_io_parity_data_3),
    .io_parity_data_4(parity_generator_io_parity_data_4),
    .io_parity_data_5(parity_generator_io_parity_data_5),
    .io_parity_data_6(parity_generator_io_parity_data_6),
    .io_parity_data_7(parity_generator_io_parity_data_7),
    .io_parity_data_8(parity_generator_io_parity_data_8),
    .io_parity_data_9(parity_generator_io_parity_data_9),
    .io_parity_data_10(parity_generator_io_parity_data_10),
    .io_parity_data_11(parity_generator_io_parity_data_11),
    .io_parity_data_12(parity_generator_io_parity_data_12),
    .io_parity_data_13(parity_generator_io_parity_data_13),
    .io_parity_data_14(parity_generator_io_parity_data_14),
    .io_parity_data_15(parity_generator_io_parity_data_15),
    .io_parity_data_16(parity_generator_io_parity_data_16),
    .io_parity_data_17(parity_generator_io_parity_data_17),
    .io_parity_data_18(parity_generator_io_parity_data_18),
    .io_parity_data_19(parity_generator_io_parity_data_19),
    .io_parity_data_20(parity_generator_io_parity_data_20),
    .io_parity_data_21(parity_generator_io_parity_data_21),
    .io_parity_data_22(parity_generator_io_parity_data_22),
    .io_parity_data_23(parity_generator_io_parity_data_23),
    .io_parity_data_24(parity_generator_io_parity_data_24),
    .io_parity_data_25(parity_generator_io_parity_data_25),
    .io_parity_data_26(parity_generator_io_parity_data_26),
    .io_parity_data_27(parity_generator_io_parity_data_27),
    .io_parity_data_28(parity_generator_io_parity_data_28),
    .io_parity_data_29(parity_generator_io_parity_data_29),
    .io_parity_data_30(parity_generator_io_parity_data_30),
    .io_parity_data_31(parity_generator_io_parity_data_31),
    .io_parity_data_32(parity_generator_io_parity_data_32),
    .io_parity_data_33(parity_generator_io_parity_data_33),
    .io_parity_data_34(parity_generator_io_parity_data_34),
    .io_parity_data_35(parity_generator_io_parity_data_35),
    .io_parity_data_36(parity_generator_io_parity_data_36),
    .io_parity_data_37(parity_generator_io_parity_data_37),
    .io_parity_data_38(parity_generator_io_parity_data_38),
    .io_parity_data_39(parity_generator_io_parity_data_39),
    .io_parity_data_40(parity_generator_io_parity_data_40),
    .io_parity_data_41(parity_generator_io_parity_data_41),
    .io_parity_data_42(parity_generator_io_parity_data_42),
    .io_parity_data_43(parity_generator_io_parity_data_43),
    .io_parity_data_44(parity_generator_io_parity_data_44),
    .io_parity_data_45(parity_generator_io_parity_data_45),
    .io_parity_data_46(parity_generator_io_parity_data_46),
    .io_parity_data_47(parity_generator_io_parity_data_47),
    .io_parity_data_48(parity_generator_io_parity_data_48),
    .io_parity_data_49(parity_generator_io_parity_data_49),
    .io_parity_data_50(parity_generator_io_parity_data_50),
    .io_parity_data_51(parity_generator_io_parity_data_51),
    .io_parity_data_52(parity_generator_io_parity_data_52),
    .io_parity_data_53(parity_generator_io_parity_data_53),
    .io_parity_data_54(parity_generator_io_parity_data_54),
    .io_parity_data_55(parity_generator_io_parity_data_55),
    .io_parity_data_56(parity_generator_io_parity_data_56),
    .io_parity_data_57(parity_generator_io_parity_data_57),
    .io_parity_data_58(parity_generator_io_parity_data_58),
    .io_parity_data_59(parity_generator_io_parity_data_59),
    .io_parity_data_60(parity_generator_io_parity_data_60),
    .io_parity_data_61(parity_generator_io_parity_data_61),
    .io_parity_data_62(parity_generator_io_parity_data_62),
    .io_parity_data_63(parity_generator_io_parity_data_63),
    .io_parity_insert(parity_generator_io_parity_insert),
    .io_parity_check(parity_generator_io_parity_check),
    .io_parity_rdy(parity_generator_io_parity_rdy),
    .io_rdi_state(parity_generator_io_rdi_state),
    .io_parity_rx_enable(parity_generator_io_parity_rx_enable),
    .io_parity_tx_enable(parity_generator_io_parity_tx_enable)
  );
  assign io_fdi_lpData_ready = d2d_mainband_io_fdi_pl_trdy; // @[src/main/scala/d2dadapter/D2DAdapter.scala 131:25]
  assign io_fdi_plData_valid = d2d_mainband_io_fdi_pl_valid; // @[src/main/scala/d2dadapter/D2DAdapter.scala 132:25]
  assign io_fdi_plData_bits = d2d_mainband_io_fdi_pl_data; // @[src/main/scala/d2dadapter/D2DAdapter.scala 133:24]
  assign io_fdi_plStateStatus = link_manager_io_fdi_pl_state_sts; // @[src/main/scala/d2dadapter/D2DAdapter.scala 76:26]
  assign io_fdi_plInbandPres = link_manager_io_fdi_pl_inband_pres; // @[src/main/scala/d2dadapter/D2DAdapter.scala 78:25]
  assign io_fdi_plRxActiveReq = link_manager_io_fdi_pl_rx_active_req; // @[src/main/scala/d2dadapter/D2DAdapter.scala 77:26]
  assign io_fdi_plStallReq = fdi_stall_handler_io_fdi_pl_stallreq; // @[src/main/scala/d2dadapter/D2DAdapter.scala 119:23]
  assign io_rdi_lpData_valid = d2d_mainband_io_rdi_lp_valid; // @[src/main/scala/d2dadapter/D2DAdapter.scala 137:25]
  assign io_rdi_lpData_irdy = d2d_mainband_io_rdi_lp_irdy; // @[src/main/scala/d2dadapter/D2DAdapter.scala 136:24]
  assign io_rdi_lpData_bits = d2d_mainband_io_rdi_lp_data; // @[src/main/scala/d2dadapter/D2DAdapter.scala 138:24]
  assign io_rdi_lpStateReq = link_manager_io_rdi_lp_state_req; // @[src/main/scala/d2dadapter/D2DAdapter.scala 81:22]
  assign io_rdi_lpLinkError = link_manager_io_rdi_lp_linkerror; // @[src/main/scala/d2dadapter/D2DAdapter.scala 80:24]
  assign io_rdi_lpStallAck = rdi_stall_handler_io_rdi_lp_stallack; // @[src/main/scala/d2dadapter/D2DAdapter.scala 123:23]
  assign io_rdi_plConfigCredit = d2d_sideband_io_rdi_pl_cfg_crd; // @[src/main/scala/d2dadapter/D2DAdapter.scala 113:27]
  assign io_rdi_lpConfig_valid = d2d_sideband_io_rdi_lp_cfg_vld; // @[src/main/scala/d2dadapter/D2DAdapter.scala 115:27]
  assign io_rdi_lpConfig_bits = d2d_sideband_io_rdi_lp_cfg; // @[src/main/scala/d2dadapter/D2DAdapter.scala 114:26]
  assign link_manager_clock = clock;
  assign link_manager_reset = reset;
  assign link_manager_io_fdi_lp_state_req = io_fdi_lpStateReq; // @[src/main/scala/d2dadapter/D2DAdapter.scala 73:38]
  assign link_manager_io_fdi_lp_linkerror = io_fdi_lpLinkError; // @[src/main/scala/d2dadapter/D2DAdapter.scala 74:38]
  assign link_manager_io_fdi_lp_rx_active_sts = io_fdi_lpRxActiveStatus; // @[src/main/scala/d2dadapter/D2DAdapter.scala 75:42]
  assign link_manager_io_rdi_pl_state_sts = io_rdi_plStateStatus; // @[src/main/scala/d2dadapter/D2DAdapter.scala 82:38]
  assign link_manager_io_rdi_pl_inband_pres = io_rdi_plInbandPres; // @[src/main/scala/d2dadapter/D2DAdapter.scala 83:40]
  assign link_manager_io_sb_rcv = d2d_sideband_io_sideband_rcv; // @[src/main/scala/d2dadapter/D2DAdapter.scala 87:28]
  assign link_manager_io_sb_rdy = d2d_sideband_io_sideband_rdy; // @[src/main/scala/d2dadapter/D2DAdapter.scala 88:28]
  assign link_manager_io_linkmgmt_stalldone = fdi_stall_handler_io_linkmgmt_stalldone; // @[src/main/scala/d2dadapter/D2DAdapter.scala 91:40]
  assign fdi_stall_handler_clock = clock;
  assign fdi_stall_handler_reset = reset;
  assign fdi_stall_handler_io_linkmgmt_stallreq = link_manager_io_linkmgmt_stallreq; // @[src/main/scala/d2dadapter/D2DAdapter.scala 92:44]
  assign fdi_stall_handler_io_fdi_lp_stallack = io_fdi_lpStallAck; // @[src/main/scala/d2dadapter/D2DAdapter.scala 120:42]
  assign rdi_stall_handler_clock = clock;
  assign rdi_stall_handler_reset = reset;
  assign rdi_stall_handler_io_mainband_stalldone = d2d_mainband_io_mainband_stalldone; // @[src/main/scala/d2dadapter/D2DAdapter.scala 147:45]
  assign rdi_stall_handler_io_rdi_pl_stallreq = io_rdi_plStallReq; // @[src/main/scala/d2dadapter/D2DAdapter.scala 122:42]
  assign d2d_sideband_clock = clock;
  assign d2d_sideband_reset = reset;
  assign d2d_sideband_io_rdi_pl_cfg = io_rdi_plConfig_bits; // @[src/main/scala/d2dadapter/D2DAdapter.scala 111:32]
  assign d2d_sideband_io_rdi_pl_cfg_vld = io_rdi_plConfig_valid; // @[src/main/scala/d2dadapter/D2DAdapter.scala 112:36]
  assign d2d_sideband_io_rdi_lp_cfg_crd = io_rdi_lpConfigCredit; // @[src/main/scala/d2dadapter/D2DAdapter.scala 116:36]
  assign d2d_sideband_io_sideband_snt = link_manager_io_sb_snd; // @[src/main/scala/d2dadapter/D2DAdapter.scala 86:34]
  assign d2d_mainband_clock = clock;
  assign d2d_mainband_reset = reset;
  assign d2d_mainband_io_fdi_lp_irdy = io_fdi_lpData_irdy; // @[src/main/scala/d2dadapter/D2DAdapter.scala 127:33]
  assign d2d_mainband_io_fdi_lp_valid = io_fdi_lpData_valid; // @[src/main/scala/d2dadapter/D2DAdapter.scala 128:34]
  assign d2d_mainband_io_fdi_lp_data = io_fdi_lpData_bits; // @[src/main/scala/d2dadapter/D2DAdapter.scala 129:33]
  assign d2d_mainband_io_rdi_pl_trdy = io_rdi_lpData_ready; // @[src/main/scala/d2dadapter/D2DAdapter.scala 139:33]
  assign d2d_mainband_io_rdi_pl_valid = io_rdi_plData_valid; // @[src/main/scala/d2dadapter/D2DAdapter.scala 140:34]
  assign d2d_mainband_io_rdi_pl_data = io_rdi_plData_bits; // @[src/main/scala/d2dadapter/D2DAdapter.scala 141:33]
  assign d2d_mainband_io_d2d_state = link_manager_io_fdi_pl_state_sts; // @[src/main/scala/d2dadapter/D2DAdapter.scala 143:31]
  assign d2d_mainband_io_mainband_stallreq = rdi_stall_handler_io_mainband_stallreq; // @[src/main/scala/d2dadapter/D2DAdapter.scala 146:39]
  assign d2d_mainband_io_parity_insert = parity_generator_io_parity_insert; // @[src/main/scala/d2dadapter/D2DAdapter.scala 155:35]
  assign d2d_mainband_io_parity_data = {d2d_mainband_io_parity_data_hi,d2d_mainband_io_parity_data_lo}; // @[src/main/scala/d2dadapter/D2DAdapter.scala 156:76]
  assign d2d_mainband_io_parity_check = parity_generator_io_parity_check; // @[src/main/scala/d2dadapter/D2DAdapter.scala 158:34]
  assign parity_generator_clock = clock;
  assign parity_generator_reset = reset;
  assign parity_generator_io_snd_data_0 = _WIRE_1[7:0]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_1 = _WIRE_1[15:8]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_2 = _WIRE_1[23:16]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_3 = _WIRE_1[31:24]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_4 = _WIRE_1[39:32]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_5 = _WIRE_1[47:40]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_6 = _WIRE_1[55:48]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_7 = _WIRE_1[63:56]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_8 = _WIRE_1[71:64]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_9 = _WIRE_1[79:72]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_10 = _WIRE_1[87:80]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_11 = _WIRE_1[95:88]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_12 = _WIRE_1[103:96]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_13 = _WIRE_1[111:104]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_14 = _WIRE_1[119:112]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_15 = _WIRE_1[127:120]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_16 = _WIRE_1[135:128]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_17 = _WIRE_1[143:136]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_18 = _WIRE_1[151:144]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_19 = _WIRE_1[159:152]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_20 = _WIRE_1[167:160]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_21 = _WIRE_1[175:168]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_22 = _WIRE_1[183:176]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_23 = _WIRE_1[191:184]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_24 = _WIRE_1[199:192]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_25 = _WIRE_1[207:200]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_26 = _WIRE_1[215:208]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_27 = _WIRE_1[223:216]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_28 = _WIRE_1[231:224]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_29 = _WIRE_1[239:232]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_30 = _WIRE_1[247:240]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_31 = _WIRE_1[255:248]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_32 = _WIRE_1[263:256]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_33 = _WIRE_1[271:264]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_34 = _WIRE_1[279:272]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_35 = _WIRE_1[287:280]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_36 = _WIRE_1[295:288]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_37 = _WIRE_1[303:296]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_38 = _WIRE_1[311:304]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_39 = _WIRE_1[319:312]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_40 = _WIRE_1[327:320]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_41 = _WIRE_1[335:328]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_42 = _WIRE_1[343:336]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_43 = _WIRE_1[351:344]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_44 = _WIRE_1[359:352]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_45 = _WIRE_1[367:360]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_46 = _WIRE_1[375:368]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_47 = _WIRE_1[383:376]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_48 = _WIRE_1[391:384]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_49 = _WIRE_1[399:392]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_50 = _WIRE_1[407:400]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_51 = _WIRE_1[415:408]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_52 = _WIRE_1[423:416]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_53 = _WIRE_1[431:424]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_54 = _WIRE_1[439:432]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_55 = _WIRE_1[447:440]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_56 = _WIRE_1[455:448]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_57 = _WIRE_1[463:456]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_58 = _WIRE_1[471:464]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_59 = _WIRE_1[479:472]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_60 = _WIRE_1[487:480]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_61 = _WIRE_1[495:488]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_62 = _WIRE_1[503:496]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_63 = _WIRE_1[511:504]; // @[src/main/scala/d2dadapter/D2DAdapter.scala 151:70]
  assign parity_generator_io_snd_data_vld = d2d_mainband_io_snd_data_vld; // @[src/main/scala/d2dadapter/D2DAdapter.scala 152:38]
  assign parity_generator_io_rcv_data_vld = d2d_mainband_io_rcv_data_vld; // @[src/main/scala/d2dadapter/D2DAdapter.scala 154:38]
  assign parity_generator_io_parity_rdy = d2d_mainband_io_parity_rdy; // @[src/main/scala/d2dadapter/D2DAdapter.scala 157:36]
  assign parity_generator_io_rdi_state = io_rdi_plStateStatus; // @[src/main/scala/d2dadapter/D2DAdapter.scala 162:35]
  assign parity_generator_io_parity_rx_enable = link_manager_io_parity_rx_enable; // @[src/main/scala/d2dadapter/D2DAdapter.scala 100:42]
  assign parity_generator_io_parity_tx_enable = link_manager_io_parity_tx_enable; // @[src/main/scala/d2dadapter/D2DAdapter.scala 101:42]
endmodule
module PatternGenerator(
  input          clock,
  input          reset,
  output         io_patternGeneratorIO_transmitReq_ready, // @[src/main/scala/logphy/PatternGenerator.scala 22:14]
  input          io_patternGeneratorIO_transmitReq_valid, // @[src/main/scala/logphy/PatternGenerator.scala 22:14]
  input  [31:0]  io_patternGeneratorIO_transmitReq_bits_timeoutCycles, // @[src/main/scala/logphy/PatternGenerator.scala 22:14]
  input          io_patternGeneratorIO_transmitPatternStatus_ready, // @[src/main/scala/logphy/PatternGenerator.scala 22:14]
  output         io_patternGeneratorIO_transmitPatternStatus_valid, // @[src/main/scala/logphy/PatternGenerator.scala 22:14]
  output         io_patternGeneratorIO_transmitPatternStatus_bits, // @[src/main/scala/logphy/PatternGenerator.scala 22:14]
  input          io_sidebandLaneIO_txData_ready, // @[src/main/scala/logphy/PatternGenerator.scala 22:14]
  output         io_sidebandLaneIO_txData_valid, // @[src/main/scala/logphy/PatternGenerator.scala 22:14]
  output [127:0] io_sidebandLaneIO_txData_bits, // @[src/main/scala/logphy/PatternGenerator.scala 22:14]
  output         io_sidebandLaneIO_rxData_ready, // @[src/main/scala/logphy/PatternGenerator.scala 22:14]
  input          io_sidebandLaneIO_rxData_valid, // @[src/main/scala/logphy/PatternGenerator.scala 22:14]
  input  [127:0] io_sidebandLaneIO_rxData_bits // @[src/main/scala/logphy/PatternGenerator.scala 22:14]
);
  reg  writeInProgress; // @[src/main/scala/logphy/PatternGenerator.scala 33:40]
  reg  readInProgress; // @[src/main/scala/logphy/PatternGenerator.scala 34:39]
  wire  inProgress = writeInProgress | readInProgress; // @[src/main/scala/logphy/PatternGenerator.scala 35:53]
  reg [31:0] timeoutCycles; // @[src/main/scala/logphy/PatternGenerator.scala 38:38]
  reg  status; // @[src/main/scala/logphy/PatternGenerator.scala 39:31]
  reg  statusValid; // @[src/main/scala/logphy/PatternGenerator.scala 40:36]
  wire  _T = io_patternGeneratorIO_transmitReq_ready & io_patternGeneratorIO_transmitReq_valid; // @[src/main/scala/chisel3/util/Decoupled.scala 52:35]
  wire  _GEN_0 = _T | writeInProgress; // @[src/main/scala/logphy/PatternGenerator.scala 45:48 46:21 33:40]
  wire  _GEN_1 = _T | readInProgress; // @[src/main/scala/logphy/PatternGenerator.scala 45:48 47:20 34:39]
  wire  _GEN_5 = _T ? 1'h0 : statusValid; // @[src/main/scala/logphy/PatternGenerator.scala 45:48 51:17 40:36]
  reg [8:0] patternDetectedCount; // @[src/main/scala/logphy/PatternGenerator.scala 61:37]
  reg [1:0] patternWrittenCount; // @[src/main/scala/logphy/PatternGenerator.scala 62:36]
  wire  _T_1 = io_patternGeneratorIO_transmitPatternStatus_ready & io_patternGeneratorIO_transmitPatternStatus_valid; // @[src/main/scala/chisel3/util/Decoupled.scala 52:35]
  wire  _GEN_6 = _T_1 ? 1'h0 : _GEN_5; // @[src/main/scala/logphy/PatternGenerator.scala 76:58 77:17]
  wire [31:0] _timeoutCycles_T_1 = timeoutCycles - 32'h1; // @[src/main/scala/logphy/PatternGenerator.scala 81:36]
  wire  _T_7 = patternWrittenCount >= 2'h2; // @[src/main/scala/logphy/PatternGenerator.scala 90:28]
  wire  _T_13 = _T_7 & patternDetectedCount >= 9'h80; // @[src/main/scala/logphy/PatternGenerator.scala 92:10]
  wire  _GEN_7 = _T_13 | _GEN_6; // @[src/main/scala/logphy/PatternGenerator.scala 95:7 96:19]
  wire  _GEN_8 = _T_13 ? 1'h0 : status; // @[src/main/scala/logphy/PatternGenerator.scala 95:7 97:14 39:31]
  wire [1:0] _GEN_11 = _T_13 ? 2'h0 : patternWrittenCount; // @[src/main/scala/logphy/PatternGenerator.scala 100:27 62:36 95:7]
  wire [8:0] _GEN_12 = _T_13 ? 9'h0 : patternDetectedCount; // @[src/main/scala/logphy/PatternGenerator.scala 101:28 61:37 95:7]
  wire  _GEN_13 = timeoutCycles == 32'h0 | _GEN_8; // @[src/main/scala/logphy/PatternGenerator.scala 82:33 83:14]
  wire  _GEN_14 = timeoutCycles == 32'h0 | _GEN_7; // @[src/main/scala/logphy/PatternGenerator.scala 82:33 84:19]
  wire [1:0] _GEN_17 = timeoutCycles == 32'h0 ? 2'h0 : _GEN_11; // @[src/main/scala/logphy/PatternGenerator.scala 82:33 87:27]
  wire [8:0] _GEN_18 = timeoutCycles == 32'h0 ? 9'h0 : _GEN_12; // @[src/main/scala/logphy/PatternGenerator.scala 82:33 88:28]
  wire [1:0] _GEN_24 = inProgress ? _GEN_17 : patternWrittenCount; // @[src/main/scala/logphy/PatternGenerator.scala 80:20 62:36]
  wire [8:0] _GEN_25 = inProgress ? _GEN_18 : patternDetectedCount; // @[src/main/scala/logphy/PatternGenerator.scala 80:20 61:37]
  wire  _T_17 = io_sidebandLaneIO_txData_ready & io_sidebandLaneIO_txData_valid; // @[src/main/scala/chisel3/util/Decoupled.scala 52:35]
  wire [1:0] _patternWrittenCount_T_1 = patternWrittenCount + 2'h1; // @[src/main/scala/logphy/PatternGenerator.scala 122:54]
  wire  _T_23 = io_sidebandLaneIO_rxData_ready & io_sidebandLaneIO_rxData_valid; // @[src/main/scala/chisel3/util/Decoupled.scala 52:35]
  wire [8:0] _patternDetectedCount_T_1 = patternDetectedCount + 9'h80; // @[src/main/scala/logphy/PatternGenerator.scala 147:58]
  assign io_patternGeneratorIO_transmitReq_ready = ~inProgress; // @[src/main/scala/logphy/PatternGenerator.scala 41:58]
  assign io_patternGeneratorIO_transmitPatternStatus_valid = statusValid; // @[src/main/scala/logphy/PatternGenerator.scala 42:53]
  assign io_patternGeneratorIO_transmitPatternStatus_bits = status; // @[src/main/scala/logphy/PatternGenerator.scala 43:52]
  assign io_sidebandLaneIO_txData_valid = writeInProgress; // @[src/main/scala/logphy/PatternGenerator.scala 72:34]
  assign io_sidebandLaneIO_txData_bits = writeInProgress ? 128'haaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa : 128'h0; // @[src/main/scala/logphy/PatternGenerator.scala 105:25 60:35]
  assign io_sidebandLaneIO_rxData_ready = readInProgress; // @[src/main/scala/logphy/PatternGenerator.scala 74:34]
  always @(posedge clock) begin
    if (reset) begin // @[src/main/scala/logphy/PatternGenerator.scala 33:40]
      writeInProgress <= 1'h0; // @[src/main/scala/logphy/PatternGenerator.scala 33:40]
    end else if (inProgress) begin // @[src/main/scala/logphy/PatternGenerator.scala 80:20]
      if (timeoutCycles == 32'h0) begin // @[src/main/scala/logphy/PatternGenerator.scala 82:33]
        writeInProgress <= 1'h0; // @[src/main/scala/logphy/PatternGenerator.scala 85:23]
      end else if (_T_13) begin // @[src/main/scala/logphy/PatternGenerator.scala 95:7]
        writeInProgress <= 1'h0; // @[src/main/scala/logphy/PatternGenerator.scala 98:23]
      end else begin
        writeInProgress <= _GEN_0;
      end
    end else begin
      writeInProgress <= _GEN_0;
    end
    if (reset) begin // @[src/main/scala/logphy/PatternGenerator.scala 34:39]
      readInProgress <= 1'h0; // @[src/main/scala/logphy/PatternGenerator.scala 34:39]
    end else if (inProgress) begin // @[src/main/scala/logphy/PatternGenerator.scala 80:20]
      if (timeoutCycles == 32'h0) begin // @[src/main/scala/logphy/PatternGenerator.scala 82:33]
        readInProgress <= 1'h0; // @[src/main/scala/logphy/PatternGenerator.scala 86:22]
      end else if (_T_13) begin // @[src/main/scala/logphy/PatternGenerator.scala 95:7]
        readInProgress <= 1'h0; // @[src/main/scala/logphy/PatternGenerator.scala 99:22]
      end else begin
        readInProgress <= _GEN_1;
      end
    end else begin
      readInProgress <= _GEN_1;
    end
    if (reset) begin // @[src/main/scala/logphy/PatternGenerator.scala 38:38]
      timeoutCycles <= 32'h0; // @[src/main/scala/logphy/PatternGenerator.scala 38:38]
    end else if (inProgress) begin // @[src/main/scala/logphy/PatternGenerator.scala 80:20]
      timeoutCycles <= _timeoutCycles_T_1; // @[src/main/scala/logphy/PatternGenerator.scala 81:19]
    end else if (_T) begin // @[src/main/scala/logphy/PatternGenerator.scala 45:48]
      timeoutCycles <= io_patternGeneratorIO_transmitReq_bits_timeoutCycles; // @[src/main/scala/logphy/PatternGenerator.scala 50:19]
    end
    if (reset) begin // @[src/main/scala/logphy/PatternGenerator.scala 39:31]
      status <= 1'h0; // @[src/main/scala/logphy/PatternGenerator.scala 39:31]
    end else if (inProgress) begin // @[src/main/scala/logphy/PatternGenerator.scala 80:20]
      status <= _GEN_13;
    end
    if (reset) begin // @[src/main/scala/logphy/PatternGenerator.scala 40:36]
      statusValid <= 1'h0; // @[src/main/scala/logphy/PatternGenerator.scala 40:36]
    end else if (inProgress) begin // @[src/main/scala/logphy/PatternGenerator.scala 80:20]
      statusValid <= _GEN_14;
    end else if (_T_1) begin // @[src/main/scala/logphy/PatternGenerator.scala 76:58]
      statusValid <= 1'h0; // @[src/main/scala/logphy/PatternGenerator.scala 77:17]
    end else if (_T) begin // @[src/main/scala/logphy/PatternGenerator.scala 45:48]
      statusValid <= 1'h0; // @[src/main/scala/logphy/PatternGenerator.scala 51:17]
    end
    if (reset) begin // @[src/main/scala/logphy/PatternGenerator.scala 61:37]
      patternDetectedCount <= 9'h0; // @[src/main/scala/logphy/PatternGenerator.scala 61:37]
    end else if (readInProgress) begin // @[src/main/scala/logphy/PatternGenerator.scala 129:24]
      if (_T_23) begin // @[src/main/scala/logphy/PatternGenerator.scala 141:45]
        if (io_sidebandLaneIO_rxData_bits == 128'haaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa) begin // @[src/main/scala/logphy/PatternGenerator.scala 146:67]
          patternDetectedCount <= _patternDetectedCount_T_1; // @[src/main/scala/logphy/PatternGenerator.scala 147:34]
        end else begin
          patternDetectedCount <= _GEN_25;
        end
      end else begin
        patternDetectedCount <= _GEN_25;
      end
    end else begin
      patternDetectedCount <= _GEN_25;
    end
    if (reset) begin // @[src/main/scala/logphy/PatternGenerator.scala 62:36]
      patternWrittenCount <= 2'h0; // @[src/main/scala/logphy/PatternGenerator.scala 62:36]
    end else if (writeInProgress) begin // @[src/main/scala/logphy/PatternGenerator.scala 105:25]
      if (_T_17) begin // @[src/main/scala/logphy/PatternGenerator.scala 116:45]
        patternWrittenCount <= _patternWrittenCount_T_1; // @[src/main/scala/logphy/PatternGenerator.scala 122:31]
      end else begin
        patternWrittenCount <= _GEN_24;
      end
    end else begin
      patternWrittenCount <= _GEN_24;
    end
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (writeInProgress & _T_17 & ~reset) begin
          $fwrite(32'h80000002,"pattern written count: %d\n",patternWrittenCount); // @[src/main/scala/logphy/PatternGenerator.scala 121:17]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
  end
endmodule
module SBMsgWrapper(
  input          clock,
  input          reset,
  output         io_trainIO_msgReq_ready, // @[src/main/scala/logphy/SBMsgWrapper.scala 17:14]
  input          io_trainIO_msgReq_valid, // @[src/main/scala/logphy/SBMsgWrapper.scala 17:14]
  input  [127:0] io_trainIO_msgReq_bits_msg, // @[src/main/scala/logphy/SBMsgWrapper.scala 17:14]
  input  [63:0]  io_trainIO_msgReq_bits_timeoutCycles, // @[src/main/scala/logphy/SBMsgWrapper.scala 17:14]
  input          io_trainIO_msgReqStatus_ready, // @[src/main/scala/logphy/SBMsgWrapper.scala 17:14]
  output         io_trainIO_msgReqStatus_valid, // @[src/main/scala/logphy/SBMsgWrapper.scala 17:14]
  input          io_laneIO_txData_ready, // @[src/main/scala/logphy/SBMsgWrapper.scala 17:14]
  output         io_laneIO_txData_valid, // @[src/main/scala/logphy/SBMsgWrapper.scala 17:14]
  output [127:0] io_laneIO_txData_bits, // @[src/main/scala/logphy/SBMsgWrapper.scala 17:14]
  output         io_laneIO_rxData_ready, // @[src/main/scala/logphy/SBMsgWrapper.scala 17:14]
  input          io_laneIO_rxData_valid, // @[src/main/scala/logphy/SBMsgWrapper.scala 17:14]
  input  [127:0] io_laneIO_rxData_bits // @[src/main/scala/logphy/SBMsgWrapper.scala 17:14]
);
  reg [1:0] currentState; // @[src/main/scala/logphy/SBMsgWrapper.scala 30:37]
  reg [63:0] timeoutCounter; // @[src/main/scala/logphy/SBMsgWrapper.scala 33:39]
  reg  sentMsg; // @[src/main/scala/logphy/SBMsgWrapper.scala 37:32]
  reg  receivedMsg; // @[src/main/scala/logphy/SBMsgWrapper.scala 38:36]
  wire  _T_3 = 2'h0 == currentState; // @[src/main/scala/logphy/SBMsgWrapper.scala 60:24]
  wire  _T_4 = io_trainIO_msgReq_ready & io_trainIO_msgReq_valid; // @[src/main/scala/chisel3/util/Decoupled.scala 52:35]
  wire [1:0] _GEN_5 = _T_4 ? 2'h1 : currentState; // @[src/main/scala/logphy/SBMsgWrapper.scala 63:36 67:19 35:35]
  wire  _T_7 = 2'h1 == currentState; // @[src/main/scala/logphy/SBMsgWrapper.scala 60:24]
  reg [63:0] currentReqTimeoutMax; // @[src/main/scala/logphy/SBMsgWrapper.scala 49:45]
  wire  _justReceivedMsg_T = io_laneIO_rxData_ready & io_laneIO_rxData_valid; // @[src/main/scala/chisel3/util/Decoupled.scala 52:35]
  reg [127:0] currentReq; // @[src/main/scala/logphy/SBMsgWrapper.scala 47:35]
  wire  _justReceivedMsg_T_8 = io_laneIO_rxData_bits[21:14] == currentReq[21:14]; // @[src/main/scala/logphy/SBMsgWrapper.scala 92:21]
  wire  _justReceivedMsg_T_9 = io_laneIO_rxData_bits[4:0] == currentReq[4:0] & _justReceivedMsg_T_8; // @[src/main/scala/logphy/SBMsgWrapper.scala 90:33]
  wire  _justReceivedMsg_T_12 = io_laneIO_rxData_bits[39:32] == currentReq[39:32]; // @[src/main/scala/logphy/SBMsgWrapper.scala 94:21]
  wire  _justReceivedMsg_T_13 = _justReceivedMsg_T_9 & _justReceivedMsg_T_12; // @[src/main/scala/logphy/SBMsgWrapper.scala 92:37]
  wire  justReceivedMsg = _justReceivedMsg_T & _justReceivedMsg_T_13; // @[src/main/scala/logphy/SBMsgWrapper.scala 107:48]
  wire  hasReceivedMsg = justReceivedMsg | receivedMsg; // @[src/main/scala/logphy/SBMsgWrapper.scala 112:41]
  wire  _hasSentMsg_T = io_laneIO_txData_ready & io_laneIO_txData_valid; // @[src/main/scala/chisel3/util/Decoupled.scala 52:35]
  wire  hasSentMsg = _hasSentMsg_T | sentMsg; // @[src/main/scala/logphy/SBMsgWrapper.scala 100:55]
  wire [1:0] _GEN_8 = hasReceivedMsg & hasSentMsg ? 2'h2 : currentState; // @[src/main/scala/logphy/SBMsgWrapper.scala 115:42 118:19 35:35]
  wire [1:0] _GEN_9 = timeoutCounter == currentReqTimeoutMax ? 2'h2 : _GEN_8; // @[src/main/scala/logphy/SBMsgWrapper.scala 167:53 168:19]
  wire  _T_12 = 2'h2 == currentState; // @[src/main/scala/logphy/SBMsgWrapper.scala 60:24]
  wire  _T_15 = io_trainIO_msgReqStatus_ready & io_trainIO_msgReqStatus_valid; // @[src/main/scala/chisel3/util/Decoupled.scala 52:35]
  wire [1:0] _GEN_11 = _T_15 ? 2'h0 : currentState; // @[src/main/scala/logphy/SBMsgWrapper.scala 176:42 177:19 35:35]
  wire [1:0] _GEN_13 = 2'h2 == currentState ? _GEN_11 : currentState; // @[src/main/scala/logphy/SBMsgWrapper.scala 60:24 35:35]
  wire [1:0] _GEN_20 = 2'h1 == currentState ? _GEN_9 : _GEN_13; // @[src/main/scala/logphy/SBMsgWrapper.scala 60:24]
  wire [1:0] nextState = 2'h0 == currentState ? _GEN_5 : _GEN_20; // @[src/main/scala/logphy/SBMsgWrapper.scala 60:24]
  wire [63:0] _GEN_0 = currentState != nextState ? 64'h0 : timeoutCounter; // @[src/main/scala/logphy/SBMsgWrapper.scala 39:36 42:20 33:39]
  wire  _GEN_1 = currentState != nextState ? 1'h0 : sentMsg; // @[src/main/scala/logphy/SBMsgWrapper.scala 39:36 43:13 37:32]
  wire  _GEN_2 = currentState != nextState ? 1'h0 : receivedMsg; // @[src/main/scala/logphy/SBMsgWrapper.scala 39:36 44:17 38:36]
  wire [63:0] _timeoutCounter_T_1 = timeoutCounter + 64'h1; // @[src/main/scala/logphy/SBMsgWrapper.scala 166:40]
  wire  _GEN_22 = 2'h1 == currentState ? 1'h0 : 2'h2 == currentState; // @[src/main/scala/logphy/SBMsgWrapper.scala 60:24 src/main/scala/chisel3/util/Decoupled.scala 74:20]
  assign io_trainIO_msgReq_ready = 2'h0 == currentState; // @[src/main/scala/logphy/SBMsgWrapper.scala 60:24]
  assign io_trainIO_msgReqStatus_valid = 2'h0 == currentState ? 1'h0 : _GEN_22; // @[src/main/scala/logphy/SBMsgWrapper.scala 60:24 src/main/scala/chisel3/util/Decoupled.scala 74:20]
  assign io_laneIO_txData_valid = 2'h0 == currentState ? 1'h0 : 2'h1 == currentState; // @[src/main/scala/logphy/SBMsgWrapper.scala 60:24 src/main/scala/chisel3/util/Decoupled.scala 74:20]
  assign io_laneIO_txData_bits = currentReq; // @[src/main/scala/logphy/SBMsgWrapper.scala 60:24 99:29]
  assign io_laneIO_rxData_ready = 2'h0 == currentState ? 1'h0 : 2'h1 == currentState; // @[src/main/scala/logphy/SBMsgWrapper.scala 60:24 src/main/scala/chisel3/util/Decoupled.scala 74:20]
  always @(posedge clock) begin
    if (reset) begin // @[src/main/scala/logphy/SBMsgWrapper.scala 30:37]
      currentState <= 2'h0; // @[src/main/scala/logphy/SBMsgWrapper.scala 30:37]
    end else if (2'h0 == currentState) begin // @[src/main/scala/logphy/SBMsgWrapper.scala 60:24]
      if (_T_4) begin // @[src/main/scala/logphy/SBMsgWrapper.scala 63:36]
        currentState <= 2'h1; // @[src/main/scala/logphy/SBMsgWrapper.scala 67:19]
      end
    end else if (2'h1 == currentState) begin // @[src/main/scala/logphy/SBMsgWrapper.scala 60:24]
      if (timeoutCounter == currentReqTimeoutMax) begin // @[src/main/scala/logphy/SBMsgWrapper.scala 167:53]
        currentState <= 2'h2; // @[src/main/scala/logphy/SBMsgWrapper.scala 168:19]
      end else begin
        currentState <= _GEN_8;
      end
    end else if (2'h2 == currentState) begin // @[src/main/scala/logphy/SBMsgWrapper.scala 60:24]
      currentState <= _GEN_11;
    end
    if (reset) begin // @[src/main/scala/logphy/SBMsgWrapper.scala 33:39]
      timeoutCounter <= 64'h0; // @[src/main/scala/logphy/SBMsgWrapper.scala 33:39]
    end else if (2'h0 == currentState) begin // @[src/main/scala/logphy/SBMsgWrapper.scala 60:24]
      timeoutCounter <= _GEN_0;
    end else if (2'h1 == currentState) begin // @[src/main/scala/logphy/SBMsgWrapper.scala 60:24]
      timeoutCounter <= _timeoutCounter_T_1; // @[src/main/scala/logphy/SBMsgWrapper.scala 166:22]
    end else begin
      timeoutCounter <= _GEN_0;
    end
    if (reset) begin // @[src/main/scala/logphy/SBMsgWrapper.scala 37:32]
      sentMsg <= 1'h0; // @[src/main/scala/logphy/SBMsgWrapper.scala 37:32]
    end else if (2'h0 == currentState) begin // @[src/main/scala/logphy/SBMsgWrapper.scala 60:24]
      sentMsg <= _GEN_1;
    end else if (2'h1 == currentState) begin // @[src/main/scala/logphy/SBMsgWrapper.scala 60:24]
      sentMsg <= hasSentMsg; // @[src/main/scala/logphy/SBMsgWrapper.scala 103:15]
    end else begin
      sentMsg <= _GEN_1;
    end
    if (reset) begin // @[src/main/scala/logphy/SBMsgWrapper.scala 38:36]
      receivedMsg <= 1'h0; // @[src/main/scala/logphy/SBMsgWrapper.scala 38:36]
    end else if (2'h0 == currentState) begin // @[src/main/scala/logphy/SBMsgWrapper.scala 60:24]
      receivedMsg <= _GEN_2;
    end else if (2'h1 == currentState) begin // @[src/main/scala/logphy/SBMsgWrapper.scala 60:24]
      receivedMsg <= hasReceivedMsg; // @[src/main/scala/logphy/SBMsgWrapper.scala 113:19]
    end else begin
      receivedMsg <= _GEN_2;
    end
    if (reset) begin // @[src/main/scala/logphy/SBMsgWrapper.scala 49:45]
      currentReqTimeoutMax <= 64'h0; // @[src/main/scala/logphy/SBMsgWrapper.scala 49:45]
    end else if (2'h0 == currentState) begin // @[src/main/scala/logphy/SBMsgWrapper.scala 60:24]
      if (_T_4) begin // @[src/main/scala/logphy/SBMsgWrapper.scala 63:36]
        currentReqTimeoutMax <= io_trainIO_msgReq_bits_timeoutCycles; // @[src/main/scala/logphy/SBMsgWrapper.scala 66:30]
      end
    end
    if (reset) begin // @[src/main/scala/logphy/SBMsgWrapper.scala 47:35]
      currentReq <= 128'h0; // @[src/main/scala/logphy/SBMsgWrapper.scala 47:35]
    end else if (2'h0 == currentState) begin // @[src/main/scala/logphy/SBMsgWrapper.scala 60:24]
      if (_T_4) begin // @[src/main/scala/logphy/SBMsgWrapper.scala 63:36]
        currentReq <= io_trainIO_msgReq_bits_msg; // @[src/main/scala/logphy/SBMsgWrapper.scala 64:20]
      end
    end
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (~_T_3 & ~_T_7 & _T_12 & ~reset) begin
          $fwrite(32'h80000002,"ack\n"); // @[src/main/scala/logphy/SBMsgWrapper.scala 174:13]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
  end
endmodule
module MBInitFSM(
  input          clock,
  input          reset,
  input          io_sbTrainIO_msgReq_ready, // @[src/main/scala/logphy/MBInitFSM.scala 23:14]
  output         io_sbTrainIO_msgReq_valid, // @[src/main/scala/logphy/MBInitFSM.scala 23:14]
  output [127:0] io_sbTrainIO_msgReq_bits_msg, // @[src/main/scala/logphy/MBInitFSM.scala 23:14]
  output         io_sbTrainIO_msgReqStatus_ready, // @[src/main/scala/logphy/MBInitFSM.scala 23:14]
  input          io_sbTrainIO_msgReqStatus_valid, // @[src/main/scala/logphy/MBInitFSM.scala 23:14]
  output         io_transition, // @[src/main/scala/logphy/MBInitFSM.scala 23:14]
  output         io_error // @[src/main/scala/logphy/MBInitFSM.scala 23:14]
);
  reg [2:0] state; // @[src/main/scala/logphy/MBInitFSM.scala 43:30]
  reg [1:0] paramSubState; // @[src/main/scala/logphy/MBInitFSM.scala 45:38]
  wire  _T_13 = io_sbTrainIO_msgReqStatus_ready & io_sbTrainIO_msgReqStatus_valid; // @[src/main/scala/chisel3/util/Decoupled.scala 52:35]
  wire [2:0] _GEN_9 = _T_13 ? 3'h3 : state; // @[src/main/scala/logphy/MBInitFSM.scala 180:48 44:35]
  wire [2:0] _GEN_11 = 2'h3 == paramSubState ? _GEN_9 : state; // @[src/main/scala/logphy/MBInitFSM.scala 126:29 44:35]
  wire [2:0] _GEN_18 = 2'h2 == paramSubState ? state : _GEN_11; // @[src/main/scala/logphy/MBInitFSM.scala 126:29 44:35]
  wire [2:0] _GEN_21 = 2'h1 == paramSubState ? state : _GEN_18; // @[src/main/scala/logphy/MBInitFSM.scala 126:29]
  wire [2:0] _GEN_33 = 2'h0 == paramSubState ? state : _GEN_21; // @[src/main/scala/logphy/MBInitFSM.scala 126:29 44:35]
  wire [2:0] nextState = 3'h0 == state ? _GEN_33 : state; // @[src/main/scala/logphy/MBInitFSM.scala 84:17 44:35]
  wire [1:0] _GEN_0 = nextState == 3'h0 & state != 3'h0 ? 2'h0 : paramSubState; // @[src/main/scala/logphy/MBInitFSM.scala 46:60 47:19 45:38]
  wire  _T_9 = io_sbTrainIO_msgReq_ready & io_sbTrainIO_msgReq_valid; // @[src/main/scala/chisel3/util/Decoupled.scala 52:35]
  wire [1:0] _GEN_6 = _T_13 ? 2'h2 : _GEN_0; // @[src/main/scala/logphy/MBInitFSM.scala 144:48]
  wire [1:0] _GEN_7 = _T_9 ? 2'h3 : _GEN_0; // @[src/main/scala/logphy/MBInitFSM.scala 174:42 175:27]
  wire [1:0] _GEN_16 = 2'h2 == paramSubState ? _GEN_7 : _GEN_0; // @[src/main/scala/logphy/MBInitFSM.scala 126:29]
  wire  _GEN_17 = 2'h2 == paramSubState ? 1'h0 : 2'h3 == paramSubState; // @[src/main/scala/logphy/MBInitFSM.scala 126:29 src/main/scala/chisel3/util/Decoupled.scala 90:20]
  wire  _GEN_19 = 2'h1 == paramSubState | _GEN_17; // @[src/main/scala/logphy/MBInitFSM.scala 126:29 143:43]
  wire  _GEN_23 = 2'h1 == paramSubState ? 1'h0 : 2'h2 == paramSubState; // @[src/main/scala/logphy/MBInitFSM.scala 126:29 src/main/scala/chisel3/util/Decoupled.scala 74:20]
  wire  _GEN_27 = 2'h0 == paramSubState | _GEN_23; // @[src/main/scala/logphy/MBInitFSM.scala 126:29 128:37]
  wire  _GEN_31 = 2'h0 == paramSubState ? 1'h0 : _GEN_19; // @[src/main/scala/logphy/MBInitFSM.scala 126:29 src/main/scala/chisel3/util/Decoupled.scala 90:20]
  assign io_sbTrainIO_msgReq_valid = 3'h0 == state & _GEN_27; // @[src/main/scala/logphy/MBInitFSM.scala 84:17 src/main/scala/chisel3/util/Decoupled.scala 74:20]
  assign io_sbTrainIO_msgReq_bits_msg = 2'h0 == paramSubState ? 128'h20000a54000001b : 128'h20000aa4000001b; // @[src/main/scala/logphy/MBInitFSM.scala 126:29 129:36]
  assign io_sbTrainIO_msgReqStatus_ready = 3'h0 == state & _GEN_31; // @[src/main/scala/logphy/MBInitFSM.scala 84:17 src/main/scala/chisel3/util/Decoupled.scala 90:20]
  assign io_transition = nextState == 3'h3 | nextState == 3'h4; // @[src/main/scala/logphy/MBInitFSM.scala 50:45]
  assign io_error = state == 3'h4; // @[src/main/scala/logphy/MBInitFSM.scala 51:21]
  always @(posedge clock) begin
    if (reset) begin // @[src/main/scala/logphy/MBInitFSM.scala 43:30]
      state <= 3'h0; // @[src/main/scala/logphy/MBInitFSM.scala 43:30]
    end else if (3'h0 == state) begin // @[src/main/scala/logphy/MBInitFSM.scala 84:17]
      if (!(2'h0 == paramSubState)) begin // @[src/main/scala/logphy/MBInitFSM.scala 126:29]
        if (!(2'h1 == paramSubState)) begin // @[src/main/scala/logphy/MBInitFSM.scala 126:29]
          state <= _GEN_18;
        end
      end
    end
    if (reset) begin // @[src/main/scala/logphy/MBInitFSM.scala 45:38]
      paramSubState <= 2'h0; // @[src/main/scala/logphy/MBInitFSM.scala 45:38]
    end else if (3'h0 == state) begin // @[src/main/scala/logphy/MBInitFSM.scala 84:17]
      if (2'h0 == paramSubState) begin // @[src/main/scala/logphy/MBInitFSM.scala 126:29]
        if (_T_9) begin // @[src/main/scala/logphy/MBInitFSM.scala 138:42]
          paramSubState <= 2'h1; // @[src/main/scala/logphy/MBInitFSM.scala 139:27]
        end else begin
          paramSubState <= _GEN_0;
        end
      end else if (2'h1 == paramSubState) begin // @[src/main/scala/logphy/MBInitFSM.scala 126:29]
        paramSubState <= _GEN_6;
      end else begin
        paramSubState <= _GEN_16;
      end
    end else begin
      paramSubState <= _GEN_0;
    end
  end
endmodule
module RdiBringup(
  input          clock,
  input          reset,
  input  [3:0]   io_rdiIO_lpStateReq, // @[src/main/scala/logphy/RdiBringup.scala 30:14]
  output [3:0]   io_rdiIO_plStateStatus, // @[src/main/scala/logphy/RdiBringup.scala 30:14]
  output         io_rdiIO_plStallReq, // @[src/main/scala/logphy/RdiBringup.scala 30:14]
  input          io_rdiIO_lpStallAck, // @[src/main/scala/logphy/RdiBringup.scala 30:14]
  input          io_rdiIO_lpLinkError, // @[src/main/scala/logphy/RdiBringup.scala 30:14]
  input          io_sbTrainIO_msgReq_ready, // @[src/main/scala/logphy/RdiBringup.scala 30:14]
  output         io_sbTrainIO_msgReq_valid, // @[src/main/scala/logphy/RdiBringup.scala 30:14]
  output [127:0] io_sbTrainIO_msgReq_bits_msg, // @[src/main/scala/logphy/RdiBringup.scala 30:14]
  output         io_sbTrainIO_msgReqStatus_ready, // @[src/main/scala/logphy/RdiBringup.scala 30:14]
  input          io_sbTrainIO_msgReqStatus_valid, // @[src/main/scala/logphy/RdiBringup.scala 30:14]
  output         io_active, // @[src/main/scala/logphy/RdiBringup.scala 30:14]
  input          io_internalError // @[src/main/scala/logphy/RdiBringup.scala 30:14]
);
  reg [3:0] state; // @[src/main/scala/logphy/RdiBringup.scala 50:30]
  wire [3:0] _GEN_1 = io_internalError | io_rdiIO_lpLinkError ? 4'ha : state; // @[src/main/scala/logphy/RdiBringup.scala 57:50 58:15]
  reg [2:0] resetSubstate; // @[src/main/scala/logphy/RdiBringup.scala 63:38]
  wire  _T_1 = state != 4'h0; // @[src/main/scala/logphy/RdiBringup.scala 64:14]
  reg [3:0] prevReq; // @[src/main/scala/logphy/RdiBringup.scala 74:32]
  wire [3:0] _GEN_4 = _T_1 | prevReq == 4'h0 ? io_rdiIO_lpStateReq : _GEN_1; // @[src/main/scala/logphy/RdiBringup.scala 79:67 80:17]
  wire [3:0] _GEN_5 = io_rdiIO_lpStateReq != 4'h0 ? _GEN_4 : _GEN_1; // @[src/main/scala/logphy/RdiBringup.scala 78:49]
  wire  _T_33 = io_sbTrainIO_msgReqStatus_ready & io_sbTrainIO_msgReqStatus_valid; // @[src/main/scala/chisel3/util/Decoupled.scala 52:35]
  wire [3:0] _GEN_11 = _T_33 ? 4'h1 : _GEN_5; // @[src/main/scala/logphy/RdiBringup.scala 131:48 132:23]
  wire [3:0] _GEN_13 = 3'h6 == resetSubstate ? _GEN_11 : _GEN_5; // @[src/main/scala/logphy/RdiBringup.scala 86:29]
  wire [3:0] _GEN_19 = 3'h5 == resetSubstate ? _GEN_5 : _GEN_13; // @[src/main/scala/logphy/RdiBringup.scala 86:29]
  wire [3:0] _GEN_25 = 3'h4 == resetSubstate ? _GEN_5 : _GEN_19; // @[src/main/scala/logphy/RdiBringup.scala 86:29]
  wire [3:0] _GEN_31 = 3'h3 == resetSubstate ? _GEN_5 : _GEN_25; // @[src/main/scala/logphy/RdiBringup.scala 86:29]
  wire [3:0] _GEN_38 = 3'h2 == resetSubstate ? _GEN_5 : _GEN_31; // @[src/main/scala/logphy/RdiBringup.scala 86:29]
  wire [3:0] nextState = 4'h0 == state ? _GEN_38 : _GEN_5; // @[src/main/scala/logphy/RdiBringup.scala 84:17]
  wire [2:0] _GEN_2 = state != 4'h0 & nextState == 4'h0 ? 3'h2 : resetSubstate; // @[src/main/scala/logphy/RdiBringup.scala 64:66 65:19 63:38]
  reg [1:0] stallReqAckState; // @[src/main/scala/logphy/RdiBringup.scala 68:41]
  wire  _T_5 = nextState == 4'h1; // @[src/main/scala/logphy/RdiBringup.scala 69:47]
  wire [1:0] _GEN_3 = state != 4'h1 & nextState == 4'h1 ? 2'h0 : stallReqAckState; // @[src/main/scala/logphy/RdiBringup.scala 69:68 70:22 68:41]
  wire  _T_21 = io_sbTrainIO_msgReq_ready & io_sbTrainIO_msgReq_valid; // @[src/main/scala/chisel3/util/Decoupled.scala 52:35]
  wire [2:0] _GEN_8 = _T_21 ? 3'h4 : _GEN_2; // @[src/main/scala/logphy/RdiBringup.scala 105:42 106:27]
  wire [2:0] _GEN_9 = _T_33 ? 3'h5 : _GEN_2; // @[src/main/scala/logphy/RdiBringup.scala 111:48 112:27]
  wire [2:0] _GEN_10 = _T_33 ? 3'h6 : _GEN_2; // @[src/main/scala/logphy/RdiBringup.scala 125:48 126:27]
  wire [2:0] _GEN_17 = 3'h5 == resetSubstate ? _GEN_10 : _GEN_2; // @[src/main/scala/logphy/RdiBringup.scala 86:29]
  wire  _GEN_18 = 3'h5 == resetSubstate ? 1'h0 : 3'h6 == resetSubstate; // @[src/main/scala/logphy/RdiBringup.scala 86:29 src/main/scala/chisel3/util/Decoupled.scala 90:20]
  wire  _GEN_20 = 3'h4 == resetSubstate | _GEN_18; // @[src/main/scala/logphy/RdiBringup.scala 86:29 110:43]
  wire [2:0] _GEN_21 = 3'h4 == resetSubstate ? _GEN_9 : _GEN_17; // @[src/main/scala/logphy/RdiBringup.scala 86:29]
  wire  _GEN_22 = 3'h4 == resetSubstate ? 1'h0 : 3'h5 == resetSubstate; // @[src/main/scala/chisel3/util/Decoupled.scala 74:20 src/main/scala/logphy/RdiBringup.scala 86:29]
  wire  _GEN_26 = 3'h3 == resetSubstate | _GEN_22; // @[src/main/scala/logphy/RdiBringup.scala 86:29 96:37]
  wire [142:0] _GEN_27 = 3'h3 == resetSubstate ? 143'h200000140004012 : 143'h200000140008012; // @[src/main/scala/logphy/RdiBringup.scala 86:29 97:40]
  wire  _GEN_30 = 3'h3 == resetSubstate ? 1'h0 : _GEN_20; // @[src/main/scala/logphy/RdiBringup.scala 86:29 src/main/scala/chisel3/util/Decoupled.scala 90:20]
  wire  _GEN_34 = 3'h2 == resetSubstate ? 1'h0 : _GEN_26; // @[src/main/scala/chisel3/util/Decoupled.scala 74:20 src/main/scala/logphy/RdiBringup.scala 86:29]
  wire  _GEN_37 = 3'h2 == resetSubstate ? 1'h0 : _GEN_30; // @[src/main/scala/logphy/RdiBringup.scala 86:29 src/main/scala/chisel3/util/Decoupled.scala 90:20]
  reg [3:0] nextStateReq; // @[src/main/scala/logphy/RdiBringup.scala 138:33]
  wire  _T_44 = nextState == 4'hb | nextState == 4'h9 | nextState == 4'hc; // @[src/main/scala/logphy/RdiBringup.scala 142:80]
  wire [1:0] _GEN_39 = _T_44 ? 2'h1 : _GEN_3; // @[src/main/scala/logphy/RdiBringup.scala 143:13 146:30]
  wire [3:0] _GEN_40 = _T_44 ? 4'h1 : nextState; // @[src/main/scala/logphy/RdiBringup.scala 143:13 147:19 56:9]
  wire [1:0] _GEN_42 = io_rdiIO_lpStallAck ? 2'h2 : _GEN_3; // @[src/main/scala/logphy/RdiBringup.scala 152:37 153:30]
  wire [3:0] _GEN_43 = io_rdiIO_lpStallAck ? 4'h1 : nextState; // @[src/main/scala/logphy/RdiBringup.scala 152:37 154:19 56:9]
  wire [3:0] _GEN_44 = ~io_rdiIO_lpStallAck ? nextStateReq : nextState; // @[src/main/scala/logphy/RdiBringup.scala 158:38 159:19 56:9]
  wire [3:0] _GEN_45 = 2'h2 == stallReqAckState ? _GEN_44 : nextState; // @[src/main/scala/logphy/RdiBringup.scala 139:32 56:9]
  wire [1:0] _GEN_46 = 2'h1 == stallReqAckState ? _GEN_42 : _GEN_3; // @[src/main/scala/logphy/RdiBringup.scala 139:32]
  wire [3:0] _GEN_47 = 2'h1 == stallReqAckState ? _GEN_43 : _GEN_45; // @[src/main/scala/logphy/RdiBringup.scala 139:32]
  assign io_rdiIO_plStateStatus = state; // @[src/main/scala/logphy/RdiBringup.scala 51:26]
  assign io_rdiIO_plStallReq = stallReqAckState == 2'h1; // @[src/main/scala/logphy/RdiBringup.scala 73:43]
  assign io_sbTrainIO_msgReq_valid = 4'h0 == state & _GEN_34; // @[src/main/scala/logphy/RdiBringup.scala 84:17 src/main/scala/chisel3/util/Decoupled.scala 74:20]
  assign io_sbTrainIO_msgReq_bits_msg = _GEN_27[127:0];
  assign io_sbTrainIO_msgReqStatus_ready = 4'h0 == state & _GEN_37; // @[src/main/scala/logphy/RdiBringup.scala 84:17 src/main/scala/chisel3/util/Decoupled.scala 90:20]
  assign io_active = state == 4'h1; // @[src/main/scala/logphy/RdiBringup.scala 53:22]
  always @(posedge clock) begin
    if (reset) begin // @[src/main/scala/logphy/RdiBringup.scala 50:30]
      state <= 4'h0; // @[src/main/scala/logphy/RdiBringup.scala 50:30]
    end else if (4'h0 == state) begin // @[src/main/scala/logphy/RdiBringup.scala 84:17]
      if (3'h2 == resetSubstate) begin // @[src/main/scala/logphy/RdiBringup.scala 86:29]
        if (_T_5) begin // @[src/main/scala/logphy/RdiBringup.scala 90:13]
          state <= 4'h0; // @[src/main/scala/logphy/RdiBringup.scala 91:19]
        end else begin
          state <= nextState; // @[src/main/scala/logphy/RdiBringup.scala 56:9]
        end
      end else begin
        state <= nextState; // @[src/main/scala/logphy/RdiBringup.scala 56:9]
      end
    end else if (4'h1 == state) begin // @[src/main/scala/logphy/RdiBringup.scala 84:17]
      if (2'h0 == stallReqAckState) begin // @[src/main/scala/logphy/RdiBringup.scala 139:32]
        state <= _GEN_40;
      end else begin
        state <= _GEN_47;
      end
    end else begin
      state <= nextState; // @[src/main/scala/logphy/RdiBringup.scala 56:9]
    end
    if (reset) begin // @[src/main/scala/logphy/RdiBringup.scala 63:38]
      resetSubstate <= 3'h2; // @[src/main/scala/logphy/RdiBringup.scala 63:38]
    end else if (4'h0 == state) begin // @[src/main/scala/logphy/RdiBringup.scala 84:17]
      if (3'h2 == resetSubstate) begin // @[src/main/scala/logphy/RdiBringup.scala 86:29]
        if (_T_5) begin // @[src/main/scala/logphy/RdiBringup.scala 90:13]
          resetSubstate <= 3'h3; // @[src/main/scala/logphy/RdiBringup.scala 92:27]
        end else begin
          resetSubstate <= _GEN_2;
        end
      end else if (3'h3 == resetSubstate) begin // @[src/main/scala/logphy/RdiBringup.scala 86:29]
        resetSubstate <= _GEN_8;
      end else begin
        resetSubstate <= _GEN_21;
      end
    end else begin
      resetSubstate <= _GEN_2;
    end
    if (reset) begin // @[src/main/scala/logphy/RdiBringup.scala 74:32]
      prevReq <= 4'h0; // @[src/main/scala/logphy/RdiBringup.scala 74:32]
    end else begin
      prevReq <= io_rdiIO_lpStateReq; // @[src/main/scala/logphy/RdiBringup.scala 75:11]
    end
    if (reset) begin // @[src/main/scala/logphy/RdiBringup.scala 68:41]
      stallReqAckState <= 2'h0; // @[src/main/scala/logphy/RdiBringup.scala 68:41]
    end else if (4'h0 == state) begin // @[src/main/scala/logphy/RdiBringup.scala 84:17]
      stallReqAckState <= _GEN_3;
    end else if (4'h1 == state) begin // @[src/main/scala/logphy/RdiBringup.scala 84:17]
      if (2'h0 == stallReqAckState) begin // @[src/main/scala/logphy/RdiBringup.scala 139:32]
        stallReqAckState <= _GEN_39;
      end else begin
        stallReqAckState <= _GEN_46;
      end
    end else begin
      stallReqAckState <= _GEN_3;
    end
    if (reset) begin // @[src/main/scala/logphy/RdiBringup.scala 138:33]
      nextStateReq <= 4'h0; // @[src/main/scala/logphy/RdiBringup.scala 138:33]
    end else if (2'h0 == stallReqAckState) begin // @[src/main/scala/logphy/RdiBringup.scala 139:32]
      if (_T_44) begin // @[src/main/scala/logphy/RdiBringup.scala 143:13]
        if (4'h0 == state) begin // @[src/main/scala/logphy/RdiBringup.scala 84:17]
          nextStateReq <= _GEN_38;
        end else begin
          nextStateReq <= _GEN_5;
        end
      end
    end
  end
endmodule
module LinkTrainingFSM(
  input          clock,
  input          reset,
  output         io_mainbandFSMIO_rxEn, // @[src/main/scala/logphy/LinkTrainingFSM.scala 55:14]
  input          io_mainbandFSMIO_pllLock, // @[src/main/scala/logphy/LinkTrainingFSM.scala 55:14]
  output         io_sidebandFSMIO_rxData_ready, // @[src/main/scala/logphy/LinkTrainingFSM.scala 55:14]
  input          io_sidebandFSMIO_rxData_valid, // @[src/main/scala/logphy/LinkTrainingFSM.scala 55:14]
  input  [127:0] io_sidebandFSMIO_rxData_bits, // @[src/main/scala/logphy/LinkTrainingFSM.scala 55:14]
  input          io_sidebandFSMIO_patternTxData_ready, // @[src/main/scala/logphy/LinkTrainingFSM.scala 55:14]
  output         io_sidebandFSMIO_patternTxData_valid, // @[src/main/scala/logphy/LinkTrainingFSM.scala 55:14]
  output [127:0] io_sidebandFSMIO_patternTxData_bits, // @[src/main/scala/logphy/LinkTrainingFSM.scala 55:14]
  input          io_sidebandFSMIO_packetTxData_ready, // @[src/main/scala/logphy/LinkTrainingFSM.scala 55:14]
  output         io_sidebandFSMIO_packetTxData_valid, // @[src/main/scala/logphy/LinkTrainingFSM.scala 55:14]
  output [127:0] io_sidebandFSMIO_packetTxData_bits, // @[src/main/scala/logphy/LinkTrainingFSM.scala 55:14]
  output         io_sidebandFSMIO_rxMode, // @[src/main/scala/logphy/LinkTrainingFSM.scala 55:14]
  output         io_sidebandFSMIO_txMode, // @[src/main/scala/logphy/LinkTrainingFSM.scala 55:14]
  input          io_sidebandFSMIO_pllLock, // @[src/main/scala/logphy/LinkTrainingFSM.scala 55:14]
  input  [3:0]   io_rdi_rdiBringupIO_lpStateReq, // @[src/main/scala/logphy/LinkTrainingFSM.scala 55:14]
  output [3:0]   io_rdi_rdiBringupIO_plStateStatus, // @[src/main/scala/logphy/LinkTrainingFSM.scala 55:14]
  output         io_rdi_rdiBringupIO_plStallReq, // @[src/main/scala/logphy/LinkTrainingFSM.scala 55:14]
  input          io_rdi_rdiBringupIO_lpStallAck, // @[src/main/scala/logphy/LinkTrainingFSM.scala 55:14]
  input          io_rdi_rdiBringupIO_lpLinkError, // @[src/main/scala/logphy/LinkTrainingFSM.scala 55:14]
  output [2:0]   io_currentState // @[src/main/scala/logphy/LinkTrainingFSM.scala 55:14]
);
  wire  patternGenerator_clock; // @[src/main/scala/logphy/LinkTrainingFSM.scala 64:32]
  wire  patternGenerator_reset; // @[src/main/scala/logphy/LinkTrainingFSM.scala 64:32]
  wire  patternGenerator_io_patternGeneratorIO_transmitReq_ready; // @[src/main/scala/logphy/LinkTrainingFSM.scala 64:32]
  wire  patternGenerator_io_patternGeneratorIO_transmitReq_valid; // @[src/main/scala/logphy/LinkTrainingFSM.scala 64:32]
  wire [31:0] patternGenerator_io_patternGeneratorIO_transmitReq_bits_timeoutCycles; // @[src/main/scala/logphy/LinkTrainingFSM.scala 64:32]
  wire  patternGenerator_io_patternGeneratorIO_transmitPatternStatus_ready; // @[src/main/scala/logphy/LinkTrainingFSM.scala 64:32]
  wire  patternGenerator_io_patternGeneratorIO_transmitPatternStatus_valid; // @[src/main/scala/logphy/LinkTrainingFSM.scala 64:32]
  wire  patternGenerator_io_patternGeneratorIO_transmitPatternStatus_bits; // @[src/main/scala/logphy/LinkTrainingFSM.scala 64:32]
  wire  patternGenerator_io_sidebandLaneIO_txData_ready; // @[src/main/scala/logphy/LinkTrainingFSM.scala 64:32]
  wire  patternGenerator_io_sidebandLaneIO_txData_valid; // @[src/main/scala/logphy/LinkTrainingFSM.scala 64:32]
  wire [127:0] patternGenerator_io_sidebandLaneIO_txData_bits; // @[src/main/scala/logphy/LinkTrainingFSM.scala 64:32]
  wire  patternGenerator_io_sidebandLaneIO_rxData_ready; // @[src/main/scala/logphy/LinkTrainingFSM.scala 64:32]
  wire  patternGenerator_io_sidebandLaneIO_rxData_valid; // @[src/main/scala/logphy/LinkTrainingFSM.scala 64:32]
  wire [127:0] patternGenerator_io_sidebandLaneIO_rxData_bits; // @[src/main/scala/logphy/LinkTrainingFSM.scala 64:32]
  wire  sbMsgWrapper_clock; // @[src/main/scala/logphy/LinkTrainingFSM.scala 65:28]
  wire  sbMsgWrapper_reset; // @[src/main/scala/logphy/LinkTrainingFSM.scala 65:28]
  wire  sbMsgWrapper_io_trainIO_msgReq_ready; // @[src/main/scala/logphy/LinkTrainingFSM.scala 65:28]
  wire  sbMsgWrapper_io_trainIO_msgReq_valid; // @[src/main/scala/logphy/LinkTrainingFSM.scala 65:28]
  wire [127:0] sbMsgWrapper_io_trainIO_msgReq_bits_msg; // @[src/main/scala/logphy/LinkTrainingFSM.scala 65:28]
  wire [63:0] sbMsgWrapper_io_trainIO_msgReq_bits_timeoutCycles; // @[src/main/scala/logphy/LinkTrainingFSM.scala 65:28]
  wire  sbMsgWrapper_io_trainIO_msgReqStatus_ready; // @[src/main/scala/logphy/LinkTrainingFSM.scala 65:28]
  wire  sbMsgWrapper_io_trainIO_msgReqStatus_valid; // @[src/main/scala/logphy/LinkTrainingFSM.scala 65:28]
  wire  sbMsgWrapper_io_laneIO_txData_ready; // @[src/main/scala/logphy/LinkTrainingFSM.scala 65:28]
  wire  sbMsgWrapper_io_laneIO_txData_valid; // @[src/main/scala/logphy/LinkTrainingFSM.scala 65:28]
  wire [127:0] sbMsgWrapper_io_laneIO_txData_bits; // @[src/main/scala/logphy/LinkTrainingFSM.scala 65:28]
  wire  sbMsgWrapper_io_laneIO_rxData_ready; // @[src/main/scala/logphy/LinkTrainingFSM.scala 65:28]
  wire  sbMsgWrapper_io_laneIO_rxData_valid; // @[src/main/scala/logphy/LinkTrainingFSM.scala 65:28]
  wire [127:0] sbMsgWrapper_io_laneIO_rxData_bits; // @[src/main/scala/logphy/LinkTrainingFSM.scala 65:28]
  wire  mbInit_clock; // @[src/main/scala/logphy/LinkTrainingFSM.scala 109:30]
  wire  mbInit_reset; // @[src/main/scala/logphy/LinkTrainingFSM.scala 109:30]
  wire  mbInit_io_sbTrainIO_msgReq_ready; // @[src/main/scala/logphy/LinkTrainingFSM.scala 109:30]
  wire  mbInit_io_sbTrainIO_msgReq_valid; // @[src/main/scala/logphy/LinkTrainingFSM.scala 109:30]
  wire [127:0] mbInit_io_sbTrainIO_msgReq_bits_msg; // @[src/main/scala/logphy/LinkTrainingFSM.scala 109:30]
  wire  mbInit_io_sbTrainIO_msgReqStatus_ready; // @[src/main/scala/logphy/LinkTrainingFSM.scala 109:30]
  wire  mbInit_io_sbTrainIO_msgReqStatus_valid; // @[src/main/scala/logphy/LinkTrainingFSM.scala 109:30]
  wire  mbInit_io_transition; // @[src/main/scala/logphy/LinkTrainingFSM.scala 109:30]
  wire  mbInit_io_error; // @[src/main/scala/logphy/LinkTrainingFSM.scala 109:30]
  wire  rdiBringup_clock; // @[src/main/scala/logphy/LinkTrainingFSM.scala 117:34]
  wire  rdiBringup_reset; // @[src/main/scala/logphy/LinkTrainingFSM.scala 117:34]
  wire [3:0] rdiBringup_io_rdiIO_lpStateReq; // @[src/main/scala/logphy/LinkTrainingFSM.scala 117:34]
  wire [3:0] rdiBringup_io_rdiIO_plStateStatus; // @[src/main/scala/logphy/LinkTrainingFSM.scala 117:34]
  wire  rdiBringup_io_rdiIO_plStallReq; // @[src/main/scala/logphy/LinkTrainingFSM.scala 117:34]
  wire  rdiBringup_io_rdiIO_lpStallAck; // @[src/main/scala/logphy/LinkTrainingFSM.scala 117:34]
  wire  rdiBringup_io_rdiIO_lpLinkError; // @[src/main/scala/logphy/LinkTrainingFSM.scala 117:34]
  wire  rdiBringup_io_sbTrainIO_msgReq_ready; // @[src/main/scala/logphy/LinkTrainingFSM.scala 117:34]
  wire  rdiBringup_io_sbTrainIO_msgReq_valid; // @[src/main/scala/logphy/LinkTrainingFSM.scala 117:34]
  wire [127:0] rdiBringup_io_sbTrainIO_msgReq_bits_msg; // @[src/main/scala/logphy/LinkTrainingFSM.scala 117:34]
  wire  rdiBringup_io_sbTrainIO_msgReqStatus_ready; // @[src/main/scala/logphy/LinkTrainingFSM.scala 117:34]
  wire  rdiBringup_io_sbTrainIO_msgReqStatus_valid; // @[src/main/scala/logphy/LinkTrainingFSM.scala 117:34]
  wire  rdiBringup_io_active; // @[src/main/scala/logphy/LinkTrainingFSM.scala 117:34]
  wire  rdiBringup_io_internalError; // @[src/main/scala/logphy/LinkTrainingFSM.scala 117:34]
  reg [2:0] currentState; // @[src/main/scala/logphy/LinkTrainingFSM.scala 85:37]
  reg [2:0] sbInitSubState; // @[src/main/scala/logphy/LinkTrainingFSM.scala 102:39]
  wire  _T_30 = 3'h0 == sbInitSubState; // @[src/main/scala/logphy/LinkTrainingFSM.scala 230:30]
  wire  _GEN_51 = 3'h6 == sbInitSubState | 3'h7 == sbInitSubState; // @[src/main/scala/logphy/LinkTrainingFSM.scala 230:30 342:21]
  wire  _GEN_57 = 3'h5 == sbInitSubState | _GEN_51; // @[src/main/scala/logphy/LinkTrainingFSM.scala 230:30 319:21]
  wire  _GEN_66 = 3'h4 == sbInitSubState | _GEN_57; // @[src/main/scala/logphy/LinkTrainingFSM.scala 230:30 312:21]
  wire  _GEN_71 = 3'h3 == sbInitSubState | _GEN_66; // @[src/main/scala/logphy/LinkTrainingFSM.scala 230:30 286:21]
  wire  _GEN_80 = 3'h2 == sbInitSubState | _GEN_71; // @[src/main/scala/logphy/LinkTrainingFSM.scala 230:30 279:21]
  wire  _GEN_85 = 3'h1 == sbInitSubState ? 1'h0 : _GEN_80; // @[src/main/scala/logphy/LinkTrainingFSM.scala 230:30 248:21]
  wire  _GEN_96 = 3'h0 == sbInitSubState ? 1'h0 : _GEN_85; // @[src/main/scala/logphy/LinkTrainingFSM.scala 230:30 241:21]
  wire  _GEN_132 = 3'h2 == currentState | 3'h3 == currentState; // @[src/main/scala/logphy/LinkTrainingFSM.scala 189:24 371:17]
  wire  _GEN_142 = 3'h1 == currentState ? _GEN_96 : _GEN_132; // @[src/main/scala/logphy/LinkTrainingFSM.scala 189:24]
  wire  msgSource = 3'h0 == currentState ? 1'h0 : _GEN_142; // @[src/main/scala/logphy/LinkTrainingFSM.scala 189:24 67:35]
  reg [1:0] resetSubState; // @[src/main/scala/logphy/LinkTrainingFSM.scala 91:38]
  wire  _T_24 = io_mainbandFSMIO_pllLock & io_sidebandFSMIO_pllLock; // @[src/main/scala/logphy/LinkTrainingFSM.scala 212:38]
  wire [2:0] _GEN_17 = _T_24 ? 3'h1 : currentState; // @[src/main/scala/logphy/LinkTrainingFSM.scala 216:13 217:23 86:35]
  wire [2:0] _GEN_18 = 2'h2 == resetSubState ? _GEN_17 : currentState; // @[src/main/scala/logphy/LinkTrainingFSM.scala 197:29 86:35]
  wire [2:0] _GEN_20 = 2'h1 == resetSubState ? currentState : _GEN_18; // @[src/main/scala/logphy/LinkTrainingFSM.scala 197:29 86:35]
  wire [2:0] _GEN_24 = 2'h0 == resetSubState ? currentState : _GEN_20; // @[src/main/scala/logphy/LinkTrainingFSM.scala 197:29 86:35]
  wire  _T_35 = patternGenerator_io_patternGeneratorIO_transmitPatternStatus_ready &
    patternGenerator_io_patternGeneratorIO_transmitPatternStatus_valid; // @[src/main/scala/chisel3/util/Decoupled.scala 52:35]
  wire [2:0] _GEN_26 = patternGenerator_io_patternGeneratorIO_transmitPatternStatus_bits ? 3'h5 : currentState; // @[src/main/scala/logphy/LinkTrainingFSM.scala 254:15 259:27 86:35]
  wire [2:0] _GEN_28 = ~patternGenerator_io_patternGeneratorIO_transmitPatternStatus_bits ? currentState : _GEN_26; // @[src/main/scala/logphy/LinkTrainingFSM.scala 254:15 86:35]
  wire [2:0] _GEN_30 = _T_35 ? _GEN_28 : currentState; // @[src/main/scala/logphy/LinkTrainingFSM.scala 251:13 86:35]
  wire  _T_49 = sbMsgWrapper_io_trainIO_msgReqStatus_ready & sbMsgWrapper_io_trainIO_msgReqStatus_valid; // @[src/main/scala/chisel3/util/Decoupled.scala 52:35]
  wire [2:0] _GEN_46 = _T_49 ? 3'h2 : currentState; // @[src/main/scala/logphy/LinkTrainingFSM.scala 353:59 86:35]
  wire [2:0] _GEN_48 = 3'h7 == sbInitSubState ? _GEN_46 : currentState; // @[src/main/scala/logphy/LinkTrainingFSM.scala 230:30 86:35]
  wire [2:0] _GEN_55 = 3'h6 == sbInitSubState ? currentState : _GEN_48; // @[src/main/scala/logphy/LinkTrainingFSM.scala 230:30 86:35]
  wire [2:0] _GEN_59 = 3'h5 == sbInitSubState ? currentState : _GEN_55; // @[src/main/scala/logphy/LinkTrainingFSM.scala 230:30]
  wire [2:0] _GEN_69 = 3'h4 == sbInitSubState ? currentState : _GEN_59; // @[src/main/scala/logphy/LinkTrainingFSM.scala 230:30 86:35]
  wire [2:0] _GEN_73 = 3'h3 == sbInitSubState ? currentState : _GEN_69; // @[src/main/scala/logphy/LinkTrainingFSM.scala 230:30]
  wire [2:0] _GEN_83 = 3'h2 == sbInitSubState ? currentState : _GEN_73; // @[src/main/scala/logphy/LinkTrainingFSM.scala 230:30 86:35]
  wire [2:0] _GEN_87 = 3'h1 == sbInitSubState ? _GEN_30 : _GEN_83; // @[src/main/scala/logphy/LinkTrainingFSM.scala 230:30]
  wire [2:0] _GEN_99 = 3'h0 == sbInitSubState ? currentState : _GEN_87; // @[src/main/scala/logphy/LinkTrainingFSM.scala 230:30 86:35]
  wire [2:0] _nextState_T = mbInit_io_error ? 3'h5 : 3'h3; // @[src/main/scala/logphy/LinkTrainingFSM.scala 373:25]
  wire [2:0] _GEN_104 = mbInit_io_transition ? _nextState_T : currentState; // @[src/main/scala/logphy/LinkTrainingFSM.scala 372:41 373:19 86:35]
  wire [2:0] _GEN_105 = rdiBringup_io_active ? 3'h4 : currentState; // @[src/main/scala/logphy/LinkTrainingFSM.scala 383:34 384:19 86:35]
  wire [2:0] _GEN_115 = 3'h3 == currentState ? _GEN_105 : currentState; // @[src/main/scala/logphy/LinkTrainingFSM.scala 189:24 86:35]
  wire [2:0] _GEN_133 = 3'h2 == currentState ? _GEN_104 : _GEN_115; // @[src/main/scala/logphy/LinkTrainingFSM.scala 189:24]
  wire [2:0] _GEN_145 = 3'h1 == currentState ? _GEN_99 : _GEN_133; // @[src/main/scala/logphy/LinkTrainingFSM.scala 189:24]
  wire [2:0] nextState = 3'h0 == currentState ? _GEN_24 : _GEN_145; // @[src/main/scala/logphy/LinkTrainingFSM.scala 189:24]
  wire  _T_2 = currentState != 3'h0; // @[src/main/scala/logphy/LinkTrainingFSM.scala 93:59]
  wire  _T_3 = nextState == 3'h0 & currentState != 3'h0; // @[src/main/scala/logphy/LinkTrainingFSM.scala 93:43]
  wire [1:0] _GEN_5 = _T_3 ? 2'h0 : resetSubState; // @[src/main/scala/logphy/LinkTrainingFSM.scala 94:5 95:19 91:38]
  wire  _T_6 = nextState == 3'h1 & currentState != 3'h1; // @[src/main/scala/logphy/LinkTrainingFSM.scala 104:44]
  wire [2:0] _GEN_6 = _T_6 ? 3'h0 : sbInitSubState; // @[src/main/scala/logphy/LinkTrainingFSM.scala 105:5 106:20 102:39]
  wire  _currentState_T = rdiBringup_io_rdiIO_plStateStatus == 4'h0; // @[src/main/scala/logphy/LinkTrainingFSM.scala 126:42]
  wire  _currentState_T_1 = rdiBringup_io_rdiIO_plStateStatus == 4'h1; // @[src/main/scala/logphy/LinkTrainingFSM.scala 128:43]
  wire  _currentState_T_2 = rdiBringup_io_rdiIO_plStateStatus == 4'hb; // @[src/main/scala/logphy/LinkTrainingFSM.scala 132:43]
  wire  _io_sidebandFSMIO_rxMode_T_2 = sbInitSubState == 3'h1; // @[src/main/scala/logphy/LinkTrainingFSM.scala 150:24]
  wire  _io_sidebandFSMIO_rxMode_T_3 = sbInitSubState == 3'h0 | _io_sidebandFSMIO_rxMode_T_2; // @[src/main/scala/logphy/LinkTrainingFSM.scala 149:53]
  wire  _io_sidebandFSMIO_rxMode_T_4 = sbInitSubState == 3'h2; // @[src/main/scala/logphy/LinkTrainingFSM.scala 151:24]
  wire  _io_sidebandFSMIO_rxMode_T_5 = _io_sidebandFSMIO_rxMode_T_3 | _io_sidebandFSMIO_rxMode_T_4; // @[src/main/scala/logphy/LinkTrainingFSM.scala 150:54]
  wire  _io_sidebandFSMIO_rxMode_T_6 = sbInitSubState == 3'h3; // @[src/main/scala/logphy/LinkTrainingFSM.scala 152:24]
  wire  _io_sidebandFSMIO_rxMode_T_7 = _io_sidebandFSMIO_rxMode_T_5 | _io_sidebandFSMIO_rxMode_T_6; // @[src/main/scala/logphy/LinkTrainingFSM.scala 151:64]
  wire  _io_sidebandFSMIO_rxMode_T_8 = currentState == 3'h1 & _io_sidebandFSMIO_rxMode_T_7; // @[src/main/scala/logphy/LinkTrainingFSM.scala 148:47]
  reg [6:0] freqSelCtrValue; // @[src/main/scala/chisel3/util/Counter.scala 61:40]
  wire  freqSelCtrValue_wrap_wrap = freqSelCtrValue == 7'h63; // @[src/main/scala/chisel3/util/Counter.scala 73:24]
  wire [6:0] _freqSelCtrValue_wrap_value_T_1 = freqSelCtrValue + 7'h1; // @[src/main/scala/chisel3/util/Counter.scala 77:24]
  wire  _GEN_23 = 2'h0 == resetSubState & _T_24; // @[src/main/scala/logphy/LinkTrainingFSM.scala 172:21 197:29]
  wire  resetFreqCtrValue = 3'h0 == currentState & _GEN_23; // @[src/main/scala/logphy/LinkTrainingFSM.scala 172:21 189:24]
  wire [1:0] _GEN_16 = freqSelCtrValue_wrap_wrap ? 2'h2 : _GEN_5; // @[src/main/scala/logphy/LinkTrainingFSM.scala 206:76 207:27]
  wire  _T_31 = patternGenerator_io_patternGeneratorIO_transmitReq_ready &
    patternGenerator_io_patternGeneratorIO_transmitReq_valid; // @[src/main/scala/chisel3/util/Decoupled.scala 52:35]
  wire [2:0] _GEN_25 = _T_31 ? 3'h1 : _GEN_6; // @[src/main/scala/logphy/LinkTrainingFSM.scala 242:73 243:28]
  wire [2:0] _GEN_27 = ~patternGenerator_io_patternGeneratorIO_transmitPatternStatus_bits ? 3'h2 : _GEN_6; // @[src/main/scala/logphy/LinkTrainingFSM.scala 254:15 256:32]
  wire [2:0] _GEN_29 = _T_35 ? _GEN_27 : _GEN_6; // @[src/main/scala/logphy/LinkTrainingFSM.scala 251:13]
  wire  _T_45 = sbMsgWrapper_io_trainIO_msgReq_ready & sbMsgWrapper_io_trainIO_msgReq_valid; // @[src/main/scala/chisel3/util/Decoupled.scala 52:35]
  wire [2:0] _GEN_31 = _T_45 ? 3'h3 : _GEN_6; // @[src/main/scala/logphy/LinkTrainingFSM.scala 280:53 281:28]
  wire [2:0] _GEN_35 = _T_49 ? 3'h4 : _GEN_6; // @[src/main/scala/logphy/LinkTrainingFSM.scala 287:59]
  wire [2:0] _GEN_37 = _T_45 ? 3'h5 : _GEN_6; // @[src/main/scala/logphy/LinkTrainingFSM.scala 313:53 314:28]
  wire [2:0] _GEN_41 = _T_49 ? 3'h6 : _GEN_6; // @[src/main/scala/logphy/LinkTrainingFSM.scala 320:59]
  wire [2:0] _GEN_43 = _T_45 ? 3'h7 : _GEN_6; // @[src/main/scala/logphy/LinkTrainingFSM.scala 346:53 347:28]
  wire [2:0] _GEN_53 = 3'h6 == sbInitSubState ? _GEN_43 : _GEN_6; // @[src/main/scala/logphy/LinkTrainingFSM.scala 230:30]
  wire  _GEN_54 = 3'h6 == sbInitSubState ? 1'h0 : 3'h7 == sbInitSubState; // @[src/main/scala/logphy/LinkTrainingFSM.scala 230:30 src/main/scala/chisel3/util/Decoupled.scala 90:20]
  wire  _GEN_56 = 3'h5 == sbInitSubState | _GEN_54; // @[src/main/scala/logphy/LinkTrainingFSM.scala 230:30 318:54]
  wire [2:0] _GEN_58 = 3'h5 == sbInitSubState ? _GEN_41 : _GEN_53; // @[src/main/scala/logphy/LinkTrainingFSM.scala 230:30]
  wire  _GEN_61 = 3'h5 == sbInitSubState ? 1'h0 : 3'h6 == sbInitSubState; // @[src/main/scala/logphy/LinkTrainingFSM.scala 230:30 src/main/scala/chisel3/util/Decoupled.scala 74:20]
  wire [142:0] _GEN_63 = 3'h4 == sbInitSubState ? 143'h600000140254012 : 143'h600000140268012; // @[src/main/scala/logphy/LinkTrainingFSM.scala 230:30 299:51]
  wire  _GEN_64 = 3'h4 == sbInitSubState | _GEN_61; // @[src/main/scala/logphy/LinkTrainingFSM.scala 230:30 308:48]
  wire [2:0] _GEN_67 = 3'h4 == sbInitSubState ? _GEN_37 : _GEN_58; // @[src/main/scala/logphy/LinkTrainingFSM.scala 230:30]
  wire  _GEN_68 = 3'h4 == sbInitSubState ? 1'h0 : _GEN_56; // @[src/main/scala/logphy/LinkTrainingFSM.scala 230:30 src/main/scala/chisel3/util/Decoupled.scala 90:20]
  wire  _GEN_70 = 3'h3 == sbInitSubState | _GEN_68; // @[src/main/scala/logphy/LinkTrainingFSM.scala 230:30 285:54]
  wire [2:0] _GEN_72 = 3'h3 == sbInitSubState ? _GEN_35 : _GEN_67; // @[src/main/scala/logphy/LinkTrainingFSM.scala 230:30]
  wire  _GEN_75 = 3'h3 == sbInitSubState ? 1'h0 : _GEN_64; // @[src/main/scala/logphy/LinkTrainingFSM.scala 230:30 src/main/scala/chisel3/util/Decoupled.scala 74:20]
  wire [142:0] _GEN_77 = 3'h2 == sbInitSubState ? 143'h600000040244000 : _GEN_63; // @[src/main/scala/logphy/LinkTrainingFSM.scala 230:30 265:51]
  wire  _GEN_78 = 3'h2 == sbInitSubState | _GEN_75; // @[src/main/scala/logphy/LinkTrainingFSM.scala 230:30 274:48]
  wire [2:0] _GEN_81 = 3'h2 == sbInitSubState ? _GEN_31 : _GEN_72; // @[src/main/scala/logphy/LinkTrainingFSM.scala 230:30]
  wire  _GEN_82 = 3'h2 == sbInitSubState ? 1'h0 : _GEN_70; // @[src/main/scala/logphy/LinkTrainingFSM.scala 230:30 src/main/scala/chisel3/util/Decoupled.scala 90:20]
  wire [2:0] _GEN_86 = 3'h1 == sbInitSubState ? _GEN_29 : _GEN_81; // @[src/main/scala/logphy/LinkTrainingFSM.scala 230:30]
  wire  _GEN_89 = 3'h1 == sbInitSubState ? 1'h0 : _GEN_78; // @[src/main/scala/logphy/LinkTrainingFSM.scala 230:30 src/main/scala/chisel3/util/Decoupled.scala 74:20]
  wire  _GEN_91 = 3'h1 == sbInitSubState ? 1'h0 : _GEN_82; // @[src/main/scala/logphy/LinkTrainingFSM.scala 230:30 src/main/scala/chisel3/util/Decoupled.scala 90:20]
  wire  _GEN_98 = 3'h0 == sbInitSubState ? 1'h0 : 3'h1 == sbInitSubState; // @[src/main/scala/logphy/LinkTrainingFSM.scala 230:30 src/main/scala/chisel3/util/Decoupled.scala 90:20]
  wire  _GEN_101 = 3'h0 == sbInitSubState ? 1'h0 : _GEN_89; // @[src/main/scala/logphy/LinkTrainingFSM.scala 230:30 src/main/scala/chisel3/util/Decoupled.scala 74:20]
  wire  _GEN_103 = 3'h0 == sbInitSubState ? 1'h0 : _GEN_91; // @[src/main/scala/logphy/LinkTrainingFSM.scala 230:30 src/main/scala/chisel3/util/Decoupled.scala 90:20]
  wire  _GEN_106 = 3'h3 == currentState & sbMsgWrapper_io_trainIO_msgReq_ready; // @[src/main/scala/logphy/LinkTrainingFSM.scala 189:24 381:31 src/main/scala/chisel3/util/Decoupled.scala 90:20]
  wire  _GEN_107 = 3'h3 == currentState & rdiBringup_io_sbTrainIO_msgReq_valid; // @[src/main/scala/logphy/LinkTrainingFSM.scala 189:24 381:31 src/main/scala/chisel3/util/Decoupled.scala 74:20]
  wire [127:0] _GEN_108 = rdiBringup_io_sbTrainIO_msgReq_bits_msg; // @[src/main/scala/logphy/LinkTrainingFSM.scala 189:24 381:31]
  wire  _GEN_110 = 3'h3 == currentState & rdiBringup_io_sbTrainIO_msgReqStatus_ready; // @[src/main/scala/logphy/LinkTrainingFSM.scala 189:24 381:31 src/main/scala/chisel3/util/Decoupled.scala 90:20]
  wire  _GEN_111 = 3'h3 == currentState & sbMsgWrapper_io_trainIO_msgReqStatus_valid; // @[src/main/scala/logphy/LinkTrainingFSM.scala 189:24 381:31 src/main/scala/chisel3/util/Decoupled.scala 74:20]
  wire  _GEN_116 = 3'h2 == currentState & sbMsgWrapper_io_trainIO_msgReq_ready; // @[src/main/scala/logphy/LinkTrainingFSM.scala 189:24 369:27 src/main/scala/chisel3/util/Decoupled.scala 90:20]
  wire  _GEN_117 = 3'h2 == currentState ? mbInit_io_sbTrainIO_msgReq_valid : _GEN_107; // @[src/main/scala/logphy/LinkTrainingFSM.scala 189:24 369:27]
  wire [127:0] _GEN_118 = 3'h2 == currentState ? mbInit_io_sbTrainIO_msgReq_bits_msg : _GEN_108; // @[src/main/scala/logphy/LinkTrainingFSM.scala 189:24 369:27]
  wire [63:0] _GEN_119 = 3'h2 == currentState ? 64'h61a800 : 64'hf4240; // @[src/main/scala/logphy/LinkTrainingFSM.scala 189:24 369:27]
  wire  _GEN_120 = 3'h2 == currentState ? mbInit_io_sbTrainIO_msgReqStatus_ready : _GEN_110; // @[src/main/scala/logphy/LinkTrainingFSM.scala 189:24 369:27]
  wire  _GEN_121 = 3'h2 == currentState & sbMsgWrapper_io_trainIO_msgReqStatus_valid; // @[src/main/scala/logphy/LinkTrainingFSM.scala 189:24 369:27 src/main/scala/chisel3/util/Decoupled.scala 74:20]
  wire  _GEN_134 = 3'h2 == currentState ? 1'h0 : _GEN_106; // @[src/main/scala/logphy/LinkTrainingFSM.scala 189:24 src/main/scala/chisel3/util/Decoupled.scala 90:20]
  wire  _GEN_135 = 3'h2 == currentState ? 1'h0 : _GEN_111; // @[src/main/scala/logphy/LinkTrainingFSM.scala 189:24 src/main/scala/chisel3/util/Decoupled.scala 74:20]
  wire [142:0] _GEN_146 = 3'h1 == currentState ? _GEN_77 : {{15'd0}, _GEN_118}; // @[src/main/scala/logphy/LinkTrainingFSM.scala 189:24]
  wire  _GEN_147 = 3'h1 == currentState ? _GEN_101 : _GEN_117; // @[src/main/scala/logphy/LinkTrainingFSM.scala 189:24]
  wire  _GEN_149 = 3'h1 == currentState ? _GEN_103 : _GEN_120; // @[src/main/scala/logphy/LinkTrainingFSM.scala 189:24]
  wire  _GEN_150 = 3'h1 == currentState ? 1'h0 : _GEN_116; // @[src/main/scala/logphy/LinkTrainingFSM.scala 189:24 src/main/scala/chisel3/util/Decoupled.scala 90:20]
  wire  _GEN_151 = 3'h1 == currentState ? 1'h0 : _GEN_121; // @[src/main/scala/logphy/LinkTrainingFSM.scala 189:24 src/main/scala/chisel3/util/Decoupled.scala 74:20]
  wire  _GEN_157 = 3'h1 == currentState ? 1'h0 : _GEN_134; // @[src/main/scala/logphy/LinkTrainingFSM.scala 189:24 src/main/scala/chisel3/util/Decoupled.scala 90:20]
  wire  _GEN_158 = 3'h1 == currentState ? 1'h0 : _GEN_135; // @[src/main/scala/logphy/LinkTrainingFSM.scala 189:24 src/main/scala/chisel3/util/Decoupled.scala 74:20]
  PatternGenerator patternGenerator ( // @[src/main/scala/logphy/LinkTrainingFSM.scala 64:32]
    .clock(patternGenerator_clock),
    .reset(patternGenerator_reset),
    .io_patternGeneratorIO_transmitReq_ready(patternGenerator_io_patternGeneratorIO_transmitReq_ready),
    .io_patternGeneratorIO_transmitReq_valid(patternGenerator_io_patternGeneratorIO_transmitReq_valid),
    .io_patternGeneratorIO_transmitReq_bits_timeoutCycles(
      patternGenerator_io_patternGeneratorIO_transmitReq_bits_timeoutCycles),
    .io_patternGeneratorIO_transmitPatternStatus_ready(
      patternGenerator_io_patternGeneratorIO_transmitPatternStatus_ready),
    .io_patternGeneratorIO_transmitPatternStatus_valid(
      patternGenerator_io_patternGeneratorIO_transmitPatternStatus_valid),
    .io_patternGeneratorIO_transmitPatternStatus_bits(patternGenerator_io_patternGeneratorIO_transmitPatternStatus_bits)
      ,
    .io_sidebandLaneIO_txData_ready(patternGenerator_io_sidebandLaneIO_txData_ready),
    .io_sidebandLaneIO_txData_valid(patternGenerator_io_sidebandLaneIO_txData_valid),
    .io_sidebandLaneIO_txData_bits(patternGenerator_io_sidebandLaneIO_txData_bits),
    .io_sidebandLaneIO_rxData_ready(patternGenerator_io_sidebandLaneIO_rxData_ready),
    .io_sidebandLaneIO_rxData_valid(patternGenerator_io_sidebandLaneIO_rxData_valid),
    .io_sidebandLaneIO_rxData_bits(patternGenerator_io_sidebandLaneIO_rxData_bits)
  );
  SBMsgWrapper sbMsgWrapper ( // @[src/main/scala/logphy/LinkTrainingFSM.scala 65:28]
    .clock(sbMsgWrapper_clock),
    .reset(sbMsgWrapper_reset),
    .io_trainIO_msgReq_ready(sbMsgWrapper_io_trainIO_msgReq_ready),
    .io_trainIO_msgReq_valid(sbMsgWrapper_io_trainIO_msgReq_valid),
    .io_trainIO_msgReq_bits_msg(sbMsgWrapper_io_trainIO_msgReq_bits_msg),
    .io_trainIO_msgReq_bits_timeoutCycles(sbMsgWrapper_io_trainIO_msgReq_bits_timeoutCycles),
    .io_trainIO_msgReqStatus_ready(sbMsgWrapper_io_trainIO_msgReqStatus_ready),
    .io_trainIO_msgReqStatus_valid(sbMsgWrapper_io_trainIO_msgReqStatus_valid),
    .io_laneIO_txData_ready(sbMsgWrapper_io_laneIO_txData_ready),
    .io_laneIO_txData_valid(sbMsgWrapper_io_laneIO_txData_valid),
    .io_laneIO_txData_bits(sbMsgWrapper_io_laneIO_txData_bits),
    .io_laneIO_rxData_ready(sbMsgWrapper_io_laneIO_rxData_ready),
    .io_laneIO_rxData_valid(sbMsgWrapper_io_laneIO_rxData_valid),
    .io_laneIO_rxData_bits(sbMsgWrapper_io_laneIO_rxData_bits)
  );
  MBInitFSM mbInit ( // @[src/main/scala/logphy/LinkTrainingFSM.scala 109:30]
    .clock(mbInit_clock),
    .reset(mbInit_reset),
    .io_sbTrainIO_msgReq_ready(mbInit_io_sbTrainIO_msgReq_ready),
    .io_sbTrainIO_msgReq_valid(mbInit_io_sbTrainIO_msgReq_valid),
    .io_sbTrainIO_msgReq_bits_msg(mbInit_io_sbTrainIO_msgReq_bits_msg),
    .io_sbTrainIO_msgReqStatus_ready(mbInit_io_sbTrainIO_msgReqStatus_ready),
    .io_sbTrainIO_msgReqStatus_valid(mbInit_io_sbTrainIO_msgReqStatus_valid),
    .io_transition(mbInit_io_transition),
    .io_error(mbInit_io_error)
  );
  RdiBringup rdiBringup ( // @[src/main/scala/logphy/LinkTrainingFSM.scala 117:34]
    .clock(rdiBringup_clock),
    .reset(rdiBringup_reset),
    .io_rdiIO_lpStateReq(rdiBringup_io_rdiIO_lpStateReq),
    .io_rdiIO_plStateStatus(rdiBringup_io_rdiIO_plStateStatus),
    .io_rdiIO_plStallReq(rdiBringup_io_rdiIO_plStallReq),
    .io_rdiIO_lpStallAck(rdiBringup_io_rdiIO_lpStallAck),
    .io_rdiIO_lpLinkError(rdiBringup_io_rdiIO_lpLinkError),
    .io_sbTrainIO_msgReq_ready(rdiBringup_io_sbTrainIO_msgReq_ready),
    .io_sbTrainIO_msgReq_valid(rdiBringup_io_sbTrainIO_msgReq_valid),
    .io_sbTrainIO_msgReq_bits_msg(rdiBringup_io_sbTrainIO_msgReq_bits_msg),
    .io_sbTrainIO_msgReqStatus_ready(rdiBringup_io_sbTrainIO_msgReqStatus_ready),
    .io_sbTrainIO_msgReqStatus_valid(rdiBringup_io_sbTrainIO_msgReqStatus_valid),
    .io_active(rdiBringup_io_active),
    .io_internalError(rdiBringup_io_internalError)
  );
  assign io_mainbandFSMIO_rxEn = 3'h0 == currentState ? 1'h0 : _T_2; // @[src/main/scala/logphy/LinkTrainingFSM.scala 189:24 166:25 191:29]
  assign io_sidebandFSMIO_rxData_ready = ~msgSource ? patternGenerator_io_sidebandLaneIO_rxData_ready :
    sbMsgWrapper_io_laneIO_rxData_ready; // @[src/main/scala/logphy/LinkTrainingFSM.scala 77:51 78:29 81:29]
  assign io_sidebandFSMIO_patternTxData_valid = patternGenerator_io_sidebandLaneIO_txData_valid; // @[src/main/scala/logphy/LinkTrainingFSM.scala 75:34]
  assign io_sidebandFSMIO_patternTxData_bits = patternGenerator_io_sidebandLaneIO_txData_bits; // @[src/main/scala/logphy/LinkTrainingFSM.scala 75:34]
  assign io_sidebandFSMIO_packetTxData_valid = sbMsgWrapper_io_laneIO_txData_valid; // @[src/main/scala/logphy/LinkTrainingFSM.scala 76:33]
  assign io_sidebandFSMIO_packetTxData_bits = sbMsgWrapper_io_laneIO_txData_bits; // @[src/main/scala/logphy/LinkTrainingFSM.scala 76:33]
  assign io_sidebandFSMIO_rxMode = _io_sidebandFSMIO_rxMode_T_8 ? 1'h0 : 1'h1; // @[src/main/scala/logphy/LinkTrainingFSM.scala 147:33]
  assign io_sidebandFSMIO_txMode = io_sidebandFSMIO_rxMode; // @[src/main/scala/logphy/LinkTrainingFSM.scala 156:27]
  assign io_rdi_rdiBringupIO_plStateStatus = rdiBringup_io_rdiIO_plStateStatus; // @[src/main/scala/logphy/LinkTrainingFSM.scala 118:23]
  assign io_rdi_rdiBringupIO_plStallReq = rdiBringup_io_rdiIO_plStallReq; // @[src/main/scala/logphy/LinkTrainingFSM.scala 118:23]
  assign io_currentState = currentState; // @[src/main/scala/logphy/LinkTrainingFSM.scala 170:19]
  assign patternGenerator_clock = clock;
  assign patternGenerator_reset = reset;
  assign patternGenerator_io_patternGeneratorIO_transmitReq_valid = 3'h0 == currentState ? 1'h0 : 3'h1 == currentState
     & _T_30; // @[src/main/scala/logphy/LinkTrainingFSM.scala 189:24 src/main/scala/chisel3/util/Decoupled.scala 74:20]
  assign patternGenerator_io_patternGeneratorIO_transmitReq_bits_timeoutCycles = 3'h1 == currentState ? 32'h61a800 : 32'h0
    ; // @[src/main/scala/logphy/LinkTrainingFSM.scala 189:24]
  assign patternGenerator_io_patternGeneratorIO_transmitPatternStatus_ready = 3'h0 == currentState ? 1'h0 : 3'h1 ==
    currentState & _GEN_98; // @[src/main/scala/logphy/LinkTrainingFSM.scala 189:24 src/main/scala/chisel3/util/Decoupled.scala 90:20]
  assign patternGenerator_io_sidebandLaneIO_txData_ready = io_sidebandFSMIO_patternTxData_ready; // @[src/main/scala/logphy/LinkTrainingFSM.scala 75:34]
  assign patternGenerator_io_sidebandLaneIO_rxData_valid = ~msgSource & io_sidebandFSMIO_rxData_valid; // @[src/main/scala/chisel3/util/Decoupled.scala 74:20 src/main/scala/logphy/LinkTrainingFSM.scala 77:51 78:29]
  assign patternGenerator_io_sidebandLaneIO_rxData_bits = io_sidebandFSMIO_rxData_bits; // @[src/main/scala/logphy/LinkTrainingFSM.scala 77:51 78:29]
  assign sbMsgWrapper_clock = clock;
  assign sbMsgWrapper_reset = reset;
  assign sbMsgWrapper_io_trainIO_msgReq_valid = 3'h0 == currentState ? 1'h0 : _GEN_147; // @[src/main/scala/logphy/LinkTrainingFSM.scala 189:24 src/main/scala/chisel3/util/Decoupled.scala 74:20]
  assign sbMsgWrapper_io_trainIO_msgReq_bits_msg = _GEN_146[127:0];
  assign sbMsgWrapper_io_trainIO_msgReq_bits_timeoutCycles = 3'h1 == currentState ? 64'h61a800 : _GEN_119; // @[src/main/scala/logphy/LinkTrainingFSM.scala 189:24]
  assign sbMsgWrapper_io_trainIO_msgReqStatus_ready = 3'h0 == currentState ? 1'h0 : _GEN_149; // @[src/main/scala/logphy/LinkTrainingFSM.scala 189:24 src/main/scala/chisel3/util/Decoupled.scala 90:20]
  assign sbMsgWrapper_io_laneIO_txData_ready = io_sidebandFSMIO_packetTxData_ready; // @[src/main/scala/logphy/LinkTrainingFSM.scala 76:33]
  assign sbMsgWrapper_io_laneIO_rxData_valid = ~msgSource ? 1'h0 : io_sidebandFSMIO_rxData_valid; // @[src/main/scala/chisel3/util/Decoupled.scala 74:20 src/main/scala/logphy/LinkTrainingFSM.scala 77:51 81:29]
  assign sbMsgWrapper_io_laneIO_rxData_bits = io_sidebandFSMIO_rxData_bits; // @[src/main/scala/logphy/LinkTrainingFSM.scala 77:51 81:29]
  assign mbInit_clock = clock;
  assign mbInit_reset = nextState == 3'h2 & currentState != 3'h2 | reset; // @[src/main/scala/logphy/LinkTrainingFSM.scala 115:109]
  assign mbInit_io_sbTrainIO_msgReq_ready = 3'h0 == currentState ? 1'h0 : _GEN_150; // @[src/main/scala/logphy/LinkTrainingFSM.scala 189:24 src/main/scala/chisel3/util/Decoupled.scala 90:20]
  assign mbInit_io_sbTrainIO_msgReqStatus_valid = 3'h0 == currentState ? 1'h0 : _GEN_151; // @[src/main/scala/logphy/LinkTrainingFSM.scala 189:24 src/main/scala/chisel3/util/Decoupled.scala 74:20]
  assign rdiBringup_clock = clock;
  assign rdiBringup_reset = reset;
  assign rdiBringup_io_rdiIO_lpStateReq = io_rdi_rdiBringupIO_lpStateReq; // @[src/main/scala/logphy/LinkTrainingFSM.scala 118:23]
  assign rdiBringup_io_rdiIO_lpStallAck = io_rdi_rdiBringupIO_lpStallAck; // @[src/main/scala/logphy/LinkTrainingFSM.scala 118:23]
  assign rdiBringup_io_rdiIO_lpLinkError = io_rdi_rdiBringupIO_lpLinkError; // @[src/main/scala/logphy/LinkTrainingFSM.scala 118:23]
  assign rdiBringup_io_sbTrainIO_msgReq_ready = 3'h0 == currentState ? 1'h0 : _GEN_157; // @[src/main/scala/logphy/LinkTrainingFSM.scala 189:24 src/main/scala/chisel3/util/Decoupled.scala 90:20]
  assign rdiBringup_io_sbTrainIO_msgReqStatus_valid = 3'h0 == currentState ? 1'h0 : _GEN_158; // @[src/main/scala/logphy/LinkTrainingFSM.scala 189:24 src/main/scala/chisel3/util/Decoupled.scala 74:20]
  assign rdiBringup_io_internalError = currentState == 3'h5; // @[src/main/scala/logphy/LinkTrainingFSM.scala 174:47]
  always @(posedge clock) begin
    if (reset) begin // @[src/main/scala/logphy/LinkTrainingFSM.scala 85:37]
      currentState <= 3'h0; // @[src/main/scala/logphy/LinkTrainingFSM.scala 85:37]
    end else if (_currentState_T) begin // @[src/main/scala/chisel3/util/Mux.scala 50:70]
      if (3'h0 == currentState) begin // @[src/main/scala/logphy/LinkTrainingFSM.scala 189:24]
        if (!(2'h0 == resetSubState)) begin // @[src/main/scala/logphy/LinkTrainingFSM.scala 197:29]
          currentState <= _GEN_20;
        end
      end else if (3'h1 == currentState) begin // @[src/main/scala/logphy/LinkTrainingFSM.scala 189:24]
        currentState <= _GEN_99;
      end else begin
        currentState <= _GEN_133;
      end
    end else if (_currentState_T_1) begin // @[src/main/scala/chisel3/util/Mux.scala 50:70]
      currentState <= 3'h4;
    end else if (_currentState_T_2) begin // @[src/main/scala/chisel3/util/Mux.scala 50:70]
      currentState <= 3'h6;
    end else begin
      currentState <= 3'h5;
    end
    if (reset) begin // @[src/main/scala/logphy/LinkTrainingFSM.scala 102:39]
      sbInitSubState <= 3'h0; // @[src/main/scala/logphy/LinkTrainingFSM.scala 102:39]
    end else if (3'h0 == currentState) begin // @[src/main/scala/logphy/LinkTrainingFSM.scala 189:24]
      sbInitSubState <= _GEN_6;
    end else if (3'h1 == currentState) begin // @[src/main/scala/logphy/LinkTrainingFSM.scala 189:24]
      if (3'h0 == sbInitSubState) begin // @[src/main/scala/logphy/LinkTrainingFSM.scala 230:30]
        sbInitSubState <= _GEN_25;
      end else begin
        sbInitSubState <= _GEN_86;
      end
    end else begin
      sbInitSubState <= _GEN_6;
    end
    if (reset) begin // @[src/main/scala/logphy/LinkTrainingFSM.scala 91:38]
      resetSubState <= 2'h0; // @[src/main/scala/logphy/LinkTrainingFSM.scala 91:38]
    end else if (3'h0 == currentState) begin // @[src/main/scala/logphy/LinkTrainingFSM.scala 189:24]
      if (2'h0 == resetSubState) begin // @[src/main/scala/logphy/LinkTrainingFSM.scala 197:29]
        if (_T_24) begin // @[src/main/scala/logphy/LinkTrainingFSM.scala 199:70]
          resetSubState <= 2'h1; // @[src/main/scala/logphy/LinkTrainingFSM.scala 201:27]
        end else begin
          resetSubState <= _GEN_5;
        end
      end else if (2'h1 == resetSubState) begin // @[src/main/scala/logphy/LinkTrainingFSM.scala 197:29]
        resetSubState <= _GEN_16;
      end else begin
        resetSubState <= _GEN_5;
      end
    end else begin
      resetSubState <= _GEN_5;
    end
    if (reset) begin // @[src/main/scala/chisel3/util/Counter.scala 61:40]
      freqSelCtrValue <= 7'h1; // @[src/main/scala/chisel3/util/Counter.scala 61:40]
    end else if (resetFreqCtrValue) begin // @[src/main/scala/chisel3/util/Counter.scala 134:17]
      freqSelCtrValue <= 7'h1; // @[src/main/scala/chisel3/util/Counter.scala 98:11]
    end else if (freqSelCtrValue_wrap_wrap) begin // @[src/main/scala/chisel3/util/Counter.scala 87:20]
      freqSelCtrValue <= 7'h1; // @[src/main/scala/chisel3/util/Counter.scala 87:28]
    end else begin
      freqSelCtrValue <= _freqSelCtrValue_wrap_value_T_1; // @[src/main/scala/chisel3/util/Counter.scala 77:15]
    end
  end
endmodule
module DataWidthCoupler(
  input          clock,
  input          reset,
  output         io_in_ready, // @[src/main/scala/logphy/DataWidthCoupler.scala 20:14]
  input          io_in_valid, // @[src/main/scala/logphy/DataWidthCoupler.scala 20:14]
  input  [511:0] io_in_bits, // @[src/main/scala/logphy/DataWidthCoupler.scala 20:14]
  input          io_out_ready, // @[src/main/scala/logphy/DataWidthCoupler.scala 20:14]
  output         io_out_valid, // @[src/main/scala/logphy/DataWidthCoupler.scala 20:14]
  output [255:0] io_out_bits // @[src/main/scala/logphy/DataWidthCoupler.scala 20:14]
);
  reg  currentState; // @[src/main/scala/logphy/DataWidthCoupler.scala 27:37]
  reg  chunkCounter; // @[src/main/scala/logphy/DataWidthCoupler.scala 40:31]
  reg [511:0] inData; // @[src/main/scala/logphy/DataWidthCoupler.scala 41:25]
  wire  _T_3 = io_in_ready & io_in_valid; // @[src/main/scala/chisel3/util/Decoupled.scala 52:35]
  wire  _GEN_2 = _T_3 | currentState; // @[src/main/scala/logphy/DataWidthCoupler.scala 45:26 48:24 27:37]
  wire  _io_out_bits_T_3 = 1'h1 - chunkCounter; // @[src/main/scala/logphy/DataWidthCoupler.scala 54:27]
  wire  _T_7 = io_out_ready & io_out_valid; // @[src/main/scala/chisel3/util/Decoupled.scala 52:35]
  wire  _GEN_5 = chunkCounter ? 1'h0 : currentState; // @[src/main/scala/logphy/DataWidthCoupler.scala 59:48 60:26 27:37]
  assign io_in_ready = ~currentState; // @[src/main/scala/logphy/DataWidthCoupler.scala 42:26]
  assign io_out_valid = ~currentState ? 1'h0 : currentState; // @[src/main/scala/logphy/DataWidthCoupler.scala 42:26 src/main/scala/chisel3/util/Decoupled.scala 74:20]
  assign io_out_bits = _io_out_bits_T_3 ? inData[511:256] : inData[255:0]; // @[src/main/scala/logphy/DataWidthCoupler.scala 52:{21,21}]
  always @(posedge clock) begin
    if (reset) begin // @[src/main/scala/logphy/DataWidthCoupler.scala 27:37]
      currentState <= 1'h0; // @[src/main/scala/logphy/DataWidthCoupler.scala 27:37]
    end else if (~currentState) begin // @[src/main/scala/logphy/DataWidthCoupler.scala 42:26]
      currentState <= _GEN_2;
    end else if (currentState) begin // @[src/main/scala/logphy/DataWidthCoupler.scala 42:26]
      if (_T_7) begin // @[src/main/scala/logphy/DataWidthCoupler.scala 57:27]
        currentState <= _GEN_5;
      end
    end
    if (reset) begin // @[src/main/scala/logphy/DataWidthCoupler.scala 40:31]
      chunkCounter <= 1'h0; // @[src/main/scala/logphy/DataWidthCoupler.scala 40:31]
    end else if (~currentState) begin // @[src/main/scala/logphy/DataWidthCoupler.scala 42:26]
      if (_T_3) begin // @[src/main/scala/logphy/DataWidthCoupler.scala 45:26]
        chunkCounter <= 1'h0; // @[src/main/scala/logphy/DataWidthCoupler.scala 47:24]
      end
    end else if (currentState) begin // @[src/main/scala/logphy/DataWidthCoupler.scala 42:26]
      if (_T_7) begin // @[src/main/scala/logphy/DataWidthCoupler.scala 57:27]
        chunkCounter <= chunkCounter + 1'h1; // @[src/main/scala/logphy/DataWidthCoupler.scala 58:24]
      end
    end
    if (reset) begin // @[src/main/scala/logphy/DataWidthCoupler.scala 41:25]
      inData <= 512'h0; // @[src/main/scala/logphy/DataWidthCoupler.scala 41:25]
    end else if (~currentState) begin // @[src/main/scala/logphy/DataWidthCoupler.scala 42:26]
      if (_T_3) begin // @[src/main/scala/logphy/DataWidthCoupler.scala 45:26]
        inData <= io_in_bits; // @[src/main/scala/logphy/DataWidthCoupler.scala 46:18]
      end
    end
  end
endmodule
module RdiDataMapper(
  input          clock,
  input          reset,
  output         io_rdi_lpData_ready, // @[src/main/scala/logphy/RdiDataMapper.scala 30:14]
  input          io_rdi_lpData_valid, // @[src/main/scala/logphy/RdiDataMapper.scala 30:14]
  input          io_rdi_lpData_irdy, // @[src/main/scala/logphy/RdiDataMapper.scala 30:14]
  input  [511:0] io_rdi_lpData_bits, // @[src/main/scala/logphy/RdiDataMapper.scala 30:14]
  output         io_rdi_plData_valid, // @[src/main/scala/logphy/RdiDataMapper.scala 30:14]
  output [511:0] io_rdi_plData_bits, // @[src/main/scala/logphy/RdiDataMapper.scala 30:14]
  input          io_mainbandLaneIO_txData_ready, // @[src/main/scala/logphy/RdiDataMapper.scala 30:14]
  output         io_mainbandLaneIO_txData_valid, // @[src/main/scala/logphy/RdiDataMapper.scala 30:14]
  output [255:0] io_mainbandLaneIO_txData_bits, // @[src/main/scala/logphy/RdiDataMapper.scala 30:14]
  input          io_mainbandLaneIO_rxData_valid, // @[src/main/scala/logphy/RdiDataMapper.scala 30:14]
  input  [255:0] io_mainbandLaneIO_rxData_bits // @[src/main/scala/logphy/RdiDataMapper.scala 30:14]
);
  wire  txWidthCoupler_clock; // @[src/main/scala/logphy/RdiDataMapper.scala 68:38]
  wire  txWidthCoupler_reset; // @[src/main/scala/logphy/RdiDataMapper.scala 68:38]
  wire  txWidthCoupler_io_in_ready; // @[src/main/scala/logphy/RdiDataMapper.scala 68:38]
  wire  txWidthCoupler_io_in_valid; // @[src/main/scala/logphy/RdiDataMapper.scala 68:38]
  wire [511:0] txWidthCoupler_io_in_bits; // @[src/main/scala/logphy/RdiDataMapper.scala 68:38]
  wire  txWidthCoupler_io_out_ready; // @[src/main/scala/logphy/RdiDataMapper.scala 68:38]
  wire  txWidthCoupler_io_out_valid; // @[src/main/scala/logphy/RdiDataMapper.scala 68:38]
  wire [255:0] txWidthCoupler_io_out_bits; // @[src/main/scala/logphy/RdiDataMapper.scala 68:38]
  reg  rxSliceCounter; // @[src/main/scala/logphy/RdiDataMapper.scala 43:31]
  reg [255:0] rxData_0; // @[src/main/scala/logphy/RdiDataMapper.scala 45:12]
  reg [255:0] rxData_1; // @[src/main/scala/logphy/RdiDataMapper.scala 45:12]
  reg  hasRxData; // @[src/main/scala/logphy/RdiDataMapper.scala 52:26]
  wire  _GEN_7 = io_mainbandLaneIO_rxData_valid & rxSliceCounter; // @[src/main/scala/logphy/RdiDataMapper.scala 53:13 54:39]
  DataWidthCoupler txWidthCoupler ( // @[src/main/scala/logphy/RdiDataMapper.scala 68:38]
    .clock(txWidthCoupler_clock),
    .reset(txWidthCoupler_reset),
    .io_in_ready(txWidthCoupler_io_in_ready),
    .io_in_valid(txWidthCoupler_io_in_valid),
    .io_in_bits(txWidthCoupler_io_in_bits),
    .io_out_ready(txWidthCoupler_io_out_ready),
    .io_out_valid(txWidthCoupler_io_out_valid),
    .io_out_bits(txWidthCoupler_io_out_bits)
  );
  assign io_rdi_lpData_ready = txWidthCoupler_io_in_ready; // @[src/main/scala/logphy/RdiDataMapper.scala 78:23]
  assign io_rdi_plData_valid = hasRxData; // @[src/main/scala/logphy/RdiDataMapper.scala 64:23]
  assign io_rdi_plData_bits = {rxData_1,rxData_0}; // @[src/main/scala/logphy/RdiDataMapper.scala 65:32]
  assign io_mainbandLaneIO_txData_valid = txWidthCoupler_io_out_valid; // @[src/main/scala/logphy/RdiDataMapper.scala 76:25]
  assign io_mainbandLaneIO_txData_bits = txWidthCoupler_io_out_bits; // @[src/main/scala/logphy/RdiDataMapper.scala 76:25]
  assign txWidthCoupler_clock = clock;
  assign txWidthCoupler_reset = reset;
  assign txWidthCoupler_io_in_valid = io_rdi_lpData_valid & io_rdi_lpData_irdy; // @[src/main/scala/logphy/RdiDataMapper.scala 79:53]
  assign txWidthCoupler_io_in_bits = io_rdi_lpData_bits; // @[src/main/scala/logphy/RdiDataMapper.scala 80:29]
  assign txWidthCoupler_io_out_ready = io_mainbandLaneIO_txData_ready; // @[src/main/scala/logphy/RdiDataMapper.scala 76:25]
  always @(posedge clock) begin
    if (reset) begin // @[src/main/scala/logphy/RdiDataMapper.scala 43:31]
      rxSliceCounter <= 1'h0; // @[src/main/scala/logphy/RdiDataMapper.scala 43:31]
    end else if (io_mainbandLaneIO_rxData_valid) begin // @[src/main/scala/logphy/RdiDataMapper.scala 54:39]
      if (rxSliceCounter) begin // @[src/main/scala/logphy/RdiDataMapper.scala 59:44]
        rxSliceCounter <= 1'h0; // @[src/main/scala/logphy/RdiDataMapper.scala 61:22]
      end else begin
        rxSliceCounter <= rxSliceCounter + 1'h1; // @[src/main/scala/logphy/RdiDataMapper.scala 58:20]
      end
    end
    if (reset) begin // @[src/main/scala/logphy/RdiDataMapper.scala 45:12]
      rxData_0 <= 256'h0; // @[src/main/scala/logphy/RdiDataMapper.scala 45:12]
    end else if (io_mainbandLaneIO_rxData_valid) begin // @[src/main/scala/logphy/RdiDataMapper.scala 54:39]
      if (~(1'h1 - rxSliceCounter)) begin // @[src/main/scala/logphy/RdiDataMapper.scala 57:44]
        rxData_0 <= io_mainbandLaneIO_rxData_bits; // @[src/main/scala/logphy/RdiDataMapper.scala 57:44]
      end
    end
    if (reset) begin // @[src/main/scala/logphy/RdiDataMapper.scala 45:12]
      rxData_1 <= 256'h0; // @[src/main/scala/logphy/RdiDataMapper.scala 45:12]
    end else if (io_mainbandLaneIO_rxData_valid) begin // @[src/main/scala/logphy/RdiDataMapper.scala 54:39]
      if (1'h1 - rxSliceCounter) begin // @[src/main/scala/logphy/RdiDataMapper.scala 57:44]
        rxData_1 <= io_mainbandLaneIO_rxData_bits; // @[src/main/scala/logphy/RdiDataMapper.scala 57:44]
      end
    end
    if (reset) begin // @[src/main/scala/logphy/RdiDataMapper.scala 52:26]
      hasRxData <= 1'h0; // @[src/main/scala/logphy/RdiDataMapper.scala 52:26]
    end else begin
      hasRxData <= _GEN_7;
    end
  end
endmodule
module AsyncResetSynchronizerPrimitiveShiftReg_d3_i0(
  input   clock,
  input   reset,
  input   io_d, // @[src/main/scala/util/ShiftReg.scala 36:14]
  output  io_q // @[src/main/scala/util/ShiftReg.scala 36:14]
);
  reg  sync_0; // @[src/main/scala/util/SynchronizerReg.scala 51:87]
  reg  sync_1; // @[src/main/scala/util/SynchronizerReg.scala 51:87]
  reg  sync_2; // @[src/main/scala/util/SynchronizerReg.scala 51:87]
  assign io_q = sync_0; // @[src/main/scala/util/SynchronizerReg.scala 59:8]
  always @(posedge clock or posedge reset) begin
    if (reset) begin // @[src/main/scala/util/SynchronizerReg.scala 51:87]
      sync_0 <= 1'h0; // @[src/main/scala/util/SynchronizerReg.scala 51:87]
    end else begin
      sync_0 <= sync_1; // @[src/main/scala/util/SynchronizerReg.scala 57:10]
    end
  end
  always @(posedge clock or posedge reset) begin
    if (reset) begin // @[src/main/scala/util/SynchronizerReg.scala 51:87]
      sync_1 <= 1'h0; // @[src/main/scala/util/SynchronizerReg.scala 51:87]
    end else begin
      sync_1 <= sync_2; // @[src/main/scala/util/SynchronizerReg.scala 57:10]
    end
  end
  always @(posedge clock or posedge reset) begin
    if (reset) begin // @[src/main/scala/util/SynchronizerReg.scala 54:22]
      sync_2 <= 1'h0;
    end else begin
      sync_2 <= io_d;
    end
  end
endmodule
module AsyncResetSynchronizerShiftReg_w4_d3_i0(
  input        clock,
  input        reset,
  input  [3:0] io_d, // @[src/main/scala/util/ShiftReg.scala 36:14]
  output [3:0] io_q // @[src/main/scala/util/ShiftReg.scala 36:14]
);
  wire  output_chain_clock; // @[src/main/scala/util/ShiftReg.scala 45:23]
  wire  output_chain_reset; // @[src/main/scala/util/ShiftReg.scala 45:23]
  wire  output_chain_io_d; // @[src/main/scala/util/ShiftReg.scala 45:23]
  wire  output_chain_io_q; // @[src/main/scala/util/ShiftReg.scala 45:23]
  wire  output_chain_1_clock; // @[src/main/scala/util/ShiftReg.scala 45:23]
  wire  output_chain_1_reset; // @[src/main/scala/util/ShiftReg.scala 45:23]
  wire  output_chain_1_io_d; // @[src/main/scala/util/ShiftReg.scala 45:23]
  wire  output_chain_1_io_q; // @[src/main/scala/util/ShiftReg.scala 45:23]
  wire  output_chain_2_clock; // @[src/main/scala/util/ShiftReg.scala 45:23]
  wire  output_chain_2_reset; // @[src/main/scala/util/ShiftReg.scala 45:23]
  wire  output_chain_2_io_d; // @[src/main/scala/util/ShiftReg.scala 45:23]
  wire  output_chain_2_io_q; // @[src/main/scala/util/ShiftReg.scala 45:23]
  wire  output_chain_3_clock; // @[src/main/scala/util/ShiftReg.scala 45:23]
  wire  output_chain_3_reset; // @[src/main/scala/util/ShiftReg.scala 45:23]
  wire  output_chain_3_io_d; // @[src/main/scala/util/ShiftReg.scala 45:23]
  wire  output_chain_3_io_q; // @[src/main/scala/util/ShiftReg.scala 45:23]
  wire  output_1 = output_chain_1_io_q; // @[src/main/scala/util/ShiftReg.scala 48:{24,24}]
  wire  output_0 = output_chain_io_q; // @[src/main/scala/util/ShiftReg.scala 48:{24,24}]
  wire [1:0] io_q_lo = {output_1,output_0}; // @[src/main/scala/util/SynchronizerReg.scala 90:14]
  wire  output_3 = output_chain_3_io_q; // @[src/main/scala/util/ShiftReg.scala 48:{24,24}]
  wire  output_2 = output_chain_2_io_q; // @[src/main/scala/util/ShiftReg.scala 48:{24,24}]
  wire [1:0] io_q_hi = {output_3,output_2}; // @[src/main/scala/util/SynchronizerReg.scala 90:14]
  AsyncResetSynchronizerPrimitiveShiftReg_d3_i0 output_chain ( // @[src/main/scala/util/ShiftReg.scala 45:23]
    .clock(output_chain_clock),
    .reset(output_chain_reset),
    .io_d(output_chain_io_d),
    .io_q(output_chain_io_q)
  );
  AsyncResetSynchronizerPrimitiveShiftReg_d3_i0 output_chain_1 ( // @[src/main/scala/util/ShiftReg.scala 45:23]
    .clock(output_chain_1_clock),
    .reset(output_chain_1_reset),
    .io_d(output_chain_1_io_d),
    .io_q(output_chain_1_io_q)
  );
  AsyncResetSynchronizerPrimitiveShiftReg_d3_i0 output_chain_2 ( // @[src/main/scala/util/ShiftReg.scala 45:23]
    .clock(output_chain_2_clock),
    .reset(output_chain_2_reset),
    .io_d(output_chain_2_io_d),
    .io_q(output_chain_2_io_q)
  );
  AsyncResetSynchronizerPrimitiveShiftReg_d3_i0 output_chain_3 ( // @[src/main/scala/util/ShiftReg.scala 45:23]
    .clock(output_chain_3_clock),
    .reset(output_chain_3_reset),
    .io_d(output_chain_3_io_d),
    .io_q(output_chain_3_io_q)
  );
  assign io_q = {io_q_hi,io_q_lo}; // @[src/main/scala/util/SynchronizerReg.scala 90:14]
  assign output_chain_clock = clock;
  assign output_chain_reset = reset; // @[src/main/scala/util/SynchronizerReg.scala 86:21]
  assign output_chain_io_d = io_d[0]; // @[src/main/scala/util/SynchronizerReg.scala 87:41]
  assign output_chain_1_clock = clock;
  assign output_chain_1_reset = reset; // @[src/main/scala/util/SynchronizerReg.scala 86:21]
  assign output_chain_1_io_d = io_d[1]; // @[src/main/scala/util/SynchronizerReg.scala 87:41]
  assign output_chain_2_clock = clock;
  assign output_chain_2_reset = reset; // @[src/main/scala/util/SynchronizerReg.scala 86:21]
  assign output_chain_2_io_d = io_d[2]; // @[src/main/scala/util/SynchronizerReg.scala 87:41]
  assign output_chain_3_clock = clock;
  assign output_chain_3_reset = reset; // @[src/main/scala/util/SynchronizerReg.scala 86:21]
  assign output_chain_3_io_d = io_d[3]; // @[src/main/scala/util/SynchronizerReg.scala 87:41]
endmodule
module AsyncResetSynchronizerShiftReg_w1_d3_i0(
  input   clock,
  input   reset,
  input   io_d, // @[src/main/scala/util/ShiftReg.scala 36:14]
  output  io_q // @[src/main/scala/util/ShiftReg.scala 36:14]
);
  wire  output_chain_clock; // @[src/main/scala/util/ShiftReg.scala 45:23]
  wire  output_chain_reset; // @[src/main/scala/util/ShiftReg.scala 45:23]
  wire  output_chain_io_d; // @[src/main/scala/util/ShiftReg.scala 45:23]
  wire  output_chain_io_q; // @[src/main/scala/util/ShiftReg.scala 45:23]
  AsyncResetSynchronizerPrimitiveShiftReg_d3_i0 output_chain ( // @[src/main/scala/util/ShiftReg.scala 45:23]
    .clock(output_chain_clock),
    .reset(output_chain_reset),
    .io_d(output_chain_io_d),
    .io_q(output_chain_io_q)
  );
  assign io_q = output_chain_io_q; // @[src/main/scala/util/ShiftReg.scala 48:{24,24}]
  assign output_chain_clock = clock;
  assign output_chain_reset = reset; // @[src/main/scala/util/SynchronizerReg.scala 86:21]
  assign output_chain_io_d = io_d; // @[src/main/scala/util/SynchronizerReg.scala 87:41]
endmodule
module AsyncValidSync(
  input   io_in, // @[src/main/scala/util/AsyncQueue.scala 59:14]
  output  io_out, // @[src/main/scala/util/AsyncQueue.scala 59:14]
  input   clock, // @[src/main/scala/util/AsyncQueue.scala 63:17]
  input   reset // @[src/main/scala/util/AsyncQueue.scala 64:17]
);
  wire  io_out_source_valid_0_clock; // @[src/main/scala/util/ShiftReg.scala 45:23]
  wire  io_out_source_valid_0_reset; // @[src/main/scala/util/ShiftReg.scala 45:23]
  wire  io_out_source_valid_0_io_d; // @[src/main/scala/util/ShiftReg.scala 45:23]
  wire  io_out_source_valid_0_io_q; // @[src/main/scala/util/ShiftReg.scala 45:23]
  AsyncResetSynchronizerShiftReg_w1_d3_i0 io_out_source_valid_0 ( // @[src/main/scala/util/ShiftReg.scala 45:23]
    .clock(io_out_source_valid_0_clock),
    .reset(io_out_source_valid_0_reset),
    .io_d(io_out_source_valid_0_io_d),
    .io_q(io_out_source_valid_0_io_q)
  );
  assign io_out = io_out_source_valid_0_io_q; // @[src/main/scala/util/ShiftReg.scala 48:{24,24}]
  assign io_out_source_valid_0_clock = clock;
  assign io_out_source_valid_0_reset = reset;
  assign io_out_source_valid_0_io_d = io_in; // @[src/main/scala/util/ShiftReg.scala 47:16]
endmodule
module AsyncQueueSource(
  input         clock,
  input         reset,
  output        io_enq_ready, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  input         io_enq_valid, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  input  [15:0] io_enq_bits_0, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  input  [15:0] io_enq_bits_1, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  input  [15:0] io_enq_bits_2, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  input  [15:0] io_enq_bits_3, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  input  [15:0] io_enq_bits_4, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  input  [15:0] io_enq_bits_5, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  input  [15:0] io_enq_bits_6, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  input  [15:0] io_enq_bits_7, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  input  [15:0] io_enq_bits_8, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  input  [15:0] io_enq_bits_9, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  input  [15:0] io_enq_bits_10, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  input  [15:0] io_enq_bits_11, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  input  [15:0] io_enq_bits_12, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  input  [15:0] io_enq_bits_13, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  input  [15:0] io_enq_bits_14, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  input  [15:0] io_enq_bits_15, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_0_0, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_0_1, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_0_2, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_0_3, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_0_4, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_0_5, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_0_6, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_0_7, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_0_8, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_0_9, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_0_10, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_0_11, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_0_12, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_0_13, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_0_14, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_0_15, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_1_0, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_1_1, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_1_2, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_1_3, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_1_4, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_1_5, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_1_6, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_1_7, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_1_8, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_1_9, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_1_10, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_1_11, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_1_12, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_1_13, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_1_14, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_1_15, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_2_0, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_2_1, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_2_2, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_2_3, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_2_4, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_2_5, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_2_6, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_2_7, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_2_8, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_2_9, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_2_10, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_2_11, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_2_12, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_2_13, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_2_14, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_2_15, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_3_0, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_3_1, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_3_2, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_3_3, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_3_4, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_3_5, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_3_6, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_3_7, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_3_8, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_3_9, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_3_10, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_3_11, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_3_12, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_3_13, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_3_14, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_3_15, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_4_0, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_4_1, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_4_2, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_4_3, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_4_4, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_4_5, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_4_6, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_4_7, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_4_8, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_4_9, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_4_10, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_4_11, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_4_12, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_4_13, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_4_14, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_4_15, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_5_0, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_5_1, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_5_2, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_5_3, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_5_4, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_5_5, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_5_6, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_5_7, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_5_8, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_5_9, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_5_10, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_5_11, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_5_12, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_5_13, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_5_14, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_5_15, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_6_0, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_6_1, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_6_2, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_6_3, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_6_4, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_6_5, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_6_6, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_6_7, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_6_8, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_6_9, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_6_10, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_6_11, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_6_12, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_6_13, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_6_14, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_6_15, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_7_0, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_7_1, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_7_2, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_7_3, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_7_4, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_7_5, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_7_6, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_7_7, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_7_8, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_7_9, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_7_10, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_7_11, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_7_12, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_7_13, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_7_14, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [15:0] io_async_mem_7_15, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  input  [3:0]  io_async_ridx, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output [3:0]  io_async_widx, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  input         io_async_safe_ridx_valid, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output        io_async_safe_widx_valid, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  output        io_async_safe_source_reset_n, // @[src/main/scala/util/AsyncQueue.scala 71:14]
  input         io_async_safe_sink_reset_n // @[src/main/scala/util/AsyncQueue.scala 71:14]
);
  wire  ridx_ridx_gray_clock; // @[src/main/scala/util/ShiftReg.scala 45:23]
  wire  ridx_ridx_gray_reset; // @[src/main/scala/util/ShiftReg.scala 45:23]
  wire [3:0] ridx_ridx_gray_io_d; // @[src/main/scala/util/ShiftReg.scala 45:23]
  wire [3:0] ridx_ridx_gray_io_q; // @[src/main/scala/util/ShiftReg.scala 45:23]
  wire  source_valid_0_io_in; // @[src/main/scala/util/AsyncQueue.scala 100:32]
  wire  source_valid_0_io_out; // @[src/main/scala/util/AsyncQueue.scala 100:32]
  wire  source_valid_0_clock; // @[src/main/scala/util/AsyncQueue.scala 100:32]
  wire  source_valid_0_reset; // @[src/main/scala/util/AsyncQueue.scala 100:32]
  wire  source_valid_1_io_in; // @[src/main/scala/util/AsyncQueue.scala 101:32]
  wire  source_valid_1_io_out; // @[src/main/scala/util/AsyncQueue.scala 101:32]
  wire  source_valid_1_clock; // @[src/main/scala/util/AsyncQueue.scala 101:32]
  wire  source_valid_1_reset; // @[src/main/scala/util/AsyncQueue.scala 101:32]
  wire  sink_extend_io_in; // @[src/main/scala/util/AsyncQueue.scala 103:30]
  wire  sink_extend_io_out; // @[src/main/scala/util/AsyncQueue.scala 103:30]
  wire  sink_extend_clock; // @[src/main/scala/util/AsyncQueue.scala 103:30]
  wire  sink_extend_reset; // @[src/main/scala/util/AsyncQueue.scala 103:30]
  wire  sink_valid_io_in; // @[src/main/scala/util/AsyncQueue.scala 104:30]
  wire  sink_valid_io_out; // @[src/main/scala/util/AsyncQueue.scala 104:30]
  wire  sink_valid_clock; // @[src/main/scala/util/AsyncQueue.scala 104:30]
  wire  sink_valid_reset; // @[src/main/scala/util/AsyncQueue.scala 104:30]
  reg [15:0] mem_0_0; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_0_1; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_0_2; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_0_3; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_0_4; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_0_5; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_0_6; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_0_7; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_0_8; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_0_9; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_0_10; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_0_11; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_0_12; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_0_13; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_0_14; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_0_15; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_1_0; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_1_1; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_1_2; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_1_3; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_1_4; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_1_5; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_1_6; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_1_7; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_1_8; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_1_9; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_1_10; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_1_11; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_1_12; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_1_13; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_1_14; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_1_15; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_2_0; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_2_1; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_2_2; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_2_3; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_2_4; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_2_5; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_2_6; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_2_7; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_2_8; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_2_9; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_2_10; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_2_11; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_2_12; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_2_13; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_2_14; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_2_15; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_3_0; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_3_1; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_3_2; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_3_3; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_3_4; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_3_5; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_3_6; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_3_7; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_3_8; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_3_9; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_3_10; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_3_11; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_3_12; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_3_13; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_3_14; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_3_15; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_4_0; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_4_1; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_4_2; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_4_3; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_4_4; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_4_5; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_4_6; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_4_7; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_4_8; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_4_9; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_4_10; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_4_11; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_4_12; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_4_13; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_4_14; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_4_15; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_5_0; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_5_1; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_5_2; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_5_3; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_5_4; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_5_5; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_5_6; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_5_7; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_5_8; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_5_9; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_5_10; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_5_11; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_5_12; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_5_13; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_5_14; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_5_15; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_6_0; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_6_1; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_6_2; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_6_3; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_6_4; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_6_5; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_6_6; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_6_7; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_6_8; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_6_9; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_6_10; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_6_11; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_6_12; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_6_13; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_6_14; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_6_15; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_7_0; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_7_1; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_7_2; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_7_3; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_7_4; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_7_5; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_7_6; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_7_7; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_7_8; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_7_9; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_7_10; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_7_11; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_7_12; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_7_13; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_7_14; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  reg [15:0] mem_7_15; // @[src/main/scala/util/AsyncQueue.scala 80:16]
  wire  _widx_T_1 = io_enq_ready & io_enq_valid; // @[src/main/scala/chisel3/util/Decoupled.scala 52:35]
  wire  sink_ready = sink_valid_io_out; // @[src/main/scala/util/AsyncQueue.scala 120:16 79:28]
  wire  _widx_T_2 = ~sink_ready; // @[src/main/scala/util/AsyncQueue.scala 81:77]
  reg [3:0] widx_widx_bin; // @[src/main/scala/util/AsyncQueue.scala 52:25]
  wire [3:0] _GEN_256 = {{3'd0}, _widx_T_1}; // @[src/main/scala/util/AsyncQueue.scala 53:43]
  wire [3:0] _widx_incremented_T_1 = widx_widx_bin + _GEN_256; // @[src/main/scala/util/AsyncQueue.scala 53:43]
  wire [3:0] widx_incremented = _widx_T_2 ? 4'h0 : _widx_incremented_T_1; // @[src/main/scala/util/AsyncQueue.scala 53:23]
  wire [3:0] _GEN_257 = {{1'd0}, widx_incremented[3:1]}; // @[src/main/scala/util/AsyncQueue.scala 54:17]
  wire [3:0] widx = widx_incremented ^ _GEN_257; // @[src/main/scala/util/AsyncQueue.scala 54:17]
  wire [3:0] ridx = ridx_ridx_gray_io_q; // @[src/main/scala/util/ShiftReg.scala 48:{24,24}]
  wire [3:0] _ready_T = ridx ^ 4'hc; // @[src/main/scala/util/AsyncQueue.scala 83:44]
  wire [2:0] _index_T_2 = {io_async_widx[3], 2'h0}; // @[src/main/scala/util/AsyncQueue.scala 85:93]
  wire [2:0] index = io_async_widx[2:0] ^ _index_T_2; // @[src/main/scala/util/AsyncQueue.scala 85:64]
  reg  ready_reg; // @[src/main/scala/util/AsyncQueue.scala 88:56]
  reg [3:0] widx_gray; // @[src/main/scala/util/AsyncQueue.scala 91:55]
  AsyncResetSynchronizerShiftReg_w4_d3_i0 ridx_ridx_gray ( // @[src/main/scala/util/ShiftReg.scala 45:23]
    .clock(ridx_ridx_gray_clock),
    .reset(ridx_ridx_gray_reset),
    .io_d(ridx_ridx_gray_io_d),
    .io_q(ridx_ridx_gray_io_q)
  );
  AsyncValidSync source_valid_0 ( // @[src/main/scala/util/AsyncQueue.scala 100:32]
    .io_in(source_valid_0_io_in),
    .io_out(source_valid_0_io_out),
    .clock(source_valid_0_clock),
    .reset(source_valid_0_reset)
  );
  AsyncValidSync source_valid_1 ( // @[src/main/scala/util/AsyncQueue.scala 101:32]
    .io_in(source_valid_1_io_in),
    .io_out(source_valid_1_io_out),
    .clock(source_valid_1_clock),
    .reset(source_valid_1_reset)
  );
  AsyncValidSync sink_extend ( // @[src/main/scala/util/AsyncQueue.scala 103:30]
    .io_in(sink_extend_io_in),
    .io_out(sink_extend_io_out),
    .clock(sink_extend_clock),
    .reset(sink_extend_reset)
  );
  AsyncValidSync sink_valid ( // @[src/main/scala/util/AsyncQueue.scala 104:30]
    .io_in(sink_valid_io_in),
    .io_out(sink_valid_io_out),
    .clock(sink_valid_clock),
    .reset(sink_valid_reset)
  );
  assign io_enq_ready = ready_reg & sink_ready; // @[src/main/scala/util/AsyncQueue.scala 89:29]
  assign io_async_mem_0_0 = mem_0_0; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_0_1 = mem_0_1; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_0_2 = mem_0_2; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_0_3 = mem_0_3; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_0_4 = mem_0_4; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_0_5 = mem_0_5; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_0_6 = mem_0_6; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_0_7 = mem_0_7; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_0_8 = mem_0_8; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_0_9 = mem_0_9; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_0_10 = mem_0_10; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_0_11 = mem_0_11; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_0_12 = mem_0_12; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_0_13 = mem_0_13; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_0_14 = mem_0_14; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_0_15 = mem_0_15; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_1_0 = mem_1_0; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_1_1 = mem_1_1; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_1_2 = mem_1_2; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_1_3 = mem_1_3; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_1_4 = mem_1_4; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_1_5 = mem_1_5; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_1_6 = mem_1_6; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_1_7 = mem_1_7; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_1_8 = mem_1_8; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_1_9 = mem_1_9; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_1_10 = mem_1_10; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_1_11 = mem_1_11; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_1_12 = mem_1_12; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_1_13 = mem_1_13; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_1_14 = mem_1_14; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_1_15 = mem_1_15; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_2_0 = mem_2_0; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_2_1 = mem_2_1; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_2_2 = mem_2_2; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_2_3 = mem_2_3; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_2_4 = mem_2_4; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_2_5 = mem_2_5; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_2_6 = mem_2_6; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_2_7 = mem_2_7; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_2_8 = mem_2_8; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_2_9 = mem_2_9; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_2_10 = mem_2_10; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_2_11 = mem_2_11; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_2_12 = mem_2_12; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_2_13 = mem_2_13; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_2_14 = mem_2_14; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_2_15 = mem_2_15; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_3_0 = mem_3_0; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_3_1 = mem_3_1; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_3_2 = mem_3_2; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_3_3 = mem_3_3; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_3_4 = mem_3_4; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_3_5 = mem_3_5; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_3_6 = mem_3_6; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_3_7 = mem_3_7; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_3_8 = mem_3_8; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_3_9 = mem_3_9; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_3_10 = mem_3_10; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_3_11 = mem_3_11; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_3_12 = mem_3_12; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_3_13 = mem_3_13; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_3_14 = mem_3_14; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_3_15 = mem_3_15; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_4_0 = mem_4_0; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_4_1 = mem_4_1; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_4_2 = mem_4_2; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_4_3 = mem_4_3; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_4_4 = mem_4_4; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_4_5 = mem_4_5; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_4_6 = mem_4_6; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_4_7 = mem_4_7; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_4_8 = mem_4_8; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_4_9 = mem_4_9; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_4_10 = mem_4_10; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_4_11 = mem_4_11; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_4_12 = mem_4_12; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_4_13 = mem_4_13; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_4_14 = mem_4_14; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_4_15 = mem_4_15; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_5_0 = mem_5_0; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_5_1 = mem_5_1; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_5_2 = mem_5_2; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_5_3 = mem_5_3; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_5_4 = mem_5_4; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_5_5 = mem_5_5; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_5_6 = mem_5_6; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_5_7 = mem_5_7; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_5_8 = mem_5_8; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_5_9 = mem_5_9; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_5_10 = mem_5_10; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_5_11 = mem_5_11; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_5_12 = mem_5_12; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_5_13 = mem_5_13; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_5_14 = mem_5_14; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_5_15 = mem_5_15; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_6_0 = mem_6_0; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_6_1 = mem_6_1; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_6_2 = mem_6_2; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_6_3 = mem_6_3; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_6_4 = mem_6_4; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_6_5 = mem_6_5; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_6_6 = mem_6_6; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_6_7 = mem_6_7; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_6_8 = mem_6_8; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_6_9 = mem_6_9; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_6_10 = mem_6_10; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_6_11 = mem_6_11; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_6_12 = mem_6_12; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_6_13 = mem_6_13; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_6_14 = mem_6_14; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_6_15 = mem_6_15; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_7_0 = mem_7_0; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_7_1 = mem_7_1; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_7_2 = mem_7_2; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_7_3 = mem_7_3; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_7_4 = mem_7_4; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_7_5 = mem_7_5; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_7_6 = mem_7_6; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_7_7 = mem_7_7; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_7_8 = mem_7_8; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_7_9 = mem_7_9; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_7_10 = mem_7_10; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_7_11 = mem_7_11; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_7_12 = mem_7_12; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_7_13 = mem_7_13; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_7_14 = mem_7_14; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_mem_7_15 = mem_7_15; // @[src/main/scala/util/AsyncQueue.scala 96:31]
  assign io_async_widx = widx_gray; // @[src/main/scala/util/AsyncQueue.scala 92:17]
  assign io_async_safe_widx_valid = source_valid_1_io_out; // @[src/main/scala/util/AsyncQueue.scala 117:20]
  assign io_async_safe_source_reset_n = ~reset; // @[src/main/scala/util/AsyncQueue.scala 121:27]
  assign ridx_ridx_gray_clock = clock;
  assign ridx_ridx_gray_reset = reset;
  assign ridx_ridx_gray_io_d = io_async_ridx; // @[src/main/scala/util/ShiftReg.scala 47:16]
  assign source_valid_0_io_in = 1'h1; // @[src/main/scala/util/AsyncQueue.scala 115:26]
  assign source_valid_0_clock = clock; // @[src/main/scala/util/AsyncQueue.scala 110:26]
  assign source_valid_0_reset = reset | ~io_async_safe_sink_reset_n; // @[src/main/scala/util/AsyncQueue.scala 105:65]
  assign source_valid_1_io_in = source_valid_0_io_out; // @[src/main/scala/util/AsyncQueue.scala 116:26]
  assign source_valid_1_clock = clock; // @[src/main/scala/util/AsyncQueue.scala 111:26]
  assign source_valid_1_reset = reset | ~io_async_safe_sink_reset_n; // @[src/main/scala/util/AsyncQueue.scala 106:65]
  assign sink_extend_io_in = io_async_safe_ridx_valid; // @[src/main/scala/util/AsyncQueue.scala 118:23]
  assign sink_extend_clock = clock; // @[src/main/scala/util/AsyncQueue.scala 112:26]
  assign sink_extend_reset = reset | ~io_async_safe_sink_reset_n; // @[src/main/scala/util/AsyncQueue.scala 107:65]
  assign sink_valid_io_in = sink_extend_io_out; // @[src/main/scala/util/AsyncQueue.scala 119:22]
  assign sink_valid_clock = clock; // @[src/main/scala/util/AsyncQueue.scala 113:26]
  assign sink_valid_reset = reset; // @[src/main/scala/util/AsyncQueue.scala 108:35]
  always @(posedge clock) begin
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h0 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_0_0 <= io_enq_bits_0; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h0 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_0_1 <= io_enq_bits_1; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h0 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_0_2 <= io_enq_bits_2; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h0 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_0_3 <= io_enq_bits_3; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h0 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_0_4 <= io_enq_bits_4; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h0 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_0_5 <= io_enq_bits_5; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h0 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_0_6 <= io_enq_bits_6; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h0 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_0_7 <= io_enq_bits_7; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h0 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_0_8 <= io_enq_bits_8; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h0 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_0_9 <= io_enq_bits_9; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h0 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_0_10 <= io_enq_bits_10; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h0 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_0_11 <= io_enq_bits_11; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h0 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_0_12 <= io_enq_bits_12; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h0 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_0_13 <= io_enq_bits_13; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h0 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_0_14 <= io_enq_bits_14; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h0 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_0_15 <= io_enq_bits_15; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h1 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_1_0 <= io_enq_bits_0; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h1 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_1_1 <= io_enq_bits_1; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h1 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_1_2 <= io_enq_bits_2; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h1 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_1_3 <= io_enq_bits_3; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h1 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_1_4 <= io_enq_bits_4; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h1 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_1_5 <= io_enq_bits_5; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h1 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_1_6 <= io_enq_bits_6; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h1 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_1_7 <= io_enq_bits_7; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h1 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_1_8 <= io_enq_bits_8; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h1 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_1_9 <= io_enq_bits_9; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h1 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_1_10 <= io_enq_bits_10; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h1 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_1_11 <= io_enq_bits_11; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h1 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_1_12 <= io_enq_bits_12; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h1 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_1_13 <= io_enq_bits_13; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h1 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_1_14 <= io_enq_bits_14; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h1 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_1_15 <= io_enq_bits_15; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h2 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_2_0 <= io_enq_bits_0; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h2 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_2_1 <= io_enq_bits_1; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h2 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_2_2 <= io_enq_bits_2; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h2 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_2_3 <= io_enq_bits_3; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h2 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_2_4 <= io_enq_bits_4; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h2 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_2_5 <= io_enq_bits_5; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h2 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_2_6 <= io_enq_bits_6; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h2 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_2_7 <= io_enq_bits_7; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h2 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_2_8 <= io_enq_bits_8; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h2 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_2_9 <= io_enq_bits_9; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h2 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_2_10 <= io_enq_bits_10; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h2 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_2_11 <= io_enq_bits_11; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h2 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_2_12 <= io_enq_bits_12; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h2 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_2_13 <= io_enq_bits_13; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h2 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_2_14 <= io_enq_bits_14; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h2 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_2_15 <= io_enq_bits_15; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h3 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_3_0 <= io_enq_bits_0; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h3 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_3_1 <= io_enq_bits_1; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h3 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_3_2 <= io_enq_bits_2; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h3 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_3_3 <= io_enq_bits_3; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h3 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_3_4 <= io_enq_bits_4; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h3 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_3_5 <= io_enq_bits_5; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h3 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_3_6 <= io_enq_bits_6; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h3 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_3_7 <= io_enq_bits_7; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h3 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_3_8 <= io_enq_bits_8; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h3 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_3_9 <= io_enq_bits_9; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h3 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_3_10 <= io_enq_bits_10; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h3 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_3_11 <= io_enq_bits_11; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h3 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_3_12 <= io_enq_bits_12; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h3 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_3_13 <= io_enq_bits_13; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h3 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_3_14 <= io_enq_bits_14; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h3 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_3_15 <= io_enq_bits_15; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h4 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_4_0 <= io_enq_bits_0; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h4 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_4_1 <= io_enq_bits_1; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h4 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_4_2 <= io_enq_bits_2; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h4 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_4_3 <= io_enq_bits_3; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h4 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_4_4 <= io_enq_bits_4; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h4 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_4_5 <= io_enq_bits_5; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h4 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_4_6 <= io_enq_bits_6; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h4 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_4_7 <= io_enq_bits_7; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h4 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_4_8 <= io_enq_bits_8; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h4 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_4_9 <= io_enq_bits_9; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h4 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_4_10 <= io_enq_bits_10; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h4 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_4_11 <= io_enq_bits_11; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h4 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_4_12 <= io_enq_bits_12; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h4 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_4_13 <= io_enq_bits_13; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h4 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_4_14 <= io_enq_bits_14; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h4 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_4_15 <= io_enq_bits_15; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h5 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_5_0 <= io_enq_bits_0; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h5 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_5_1 <= io_enq_bits_1; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h5 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_5_2 <= io_enq_bits_2; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h5 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_5_3 <= io_enq_bits_3; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h5 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_5_4 <= io_enq_bits_4; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h5 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_5_5 <= io_enq_bits_5; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h5 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_5_6 <= io_enq_bits_6; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h5 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_5_7 <= io_enq_bits_7; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h5 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_5_8 <= io_enq_bits_8; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h5 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_5_9 <= io_enq_bits_9; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h5 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_5_10 <= io_enq_bits_10; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h5 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_5_11 <= io_enq_bits_11; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h5 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_5_12 <= io_enq_bits_12; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h5 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_5_13 <= io_enq_bits_13; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h5 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_5_14 <= io_enq_bits_14; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h5 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_5_15 <= io_enq_bits_15; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h6 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_6_0 <= io_enq_bits_0; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h6 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_6_1 <= io_enq_bits_1; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h6 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_6_2 <= io_enq_bits_2; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h6 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_6_3 <= io_enq_bits_3; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h6 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_6_4 <= io_enq_bits_4; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h6 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_6_5 <= io_enq_bits_5; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h6 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_6_6 <= io_enq_bits_6; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h6 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_6_7 <= io_enq_bits_7; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h6 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_6_8 <= io_enq_bits_8; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h6 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_6_9 <= io_enq_bits_9; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h6 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_6_10 <= io_enq_bits_10; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h6 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_6_11 <= io_enq_bits_11; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h6 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_6_12 <= io_enq_bits_12; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h6 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_6_13 <= io_enq_bits_13; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h6 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_6_14 <= io_enq_bits_14; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h6 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_6_15 <= io_enq_bits_15; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h7 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_7_0 <= io_enq_bits_0; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h7 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_7_1 <= io_enq_bits_1; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h7 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_7_2 <= io_enq_bits_2; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h7 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_7_3 <= io_enq_bits_3; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h7 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_7_4 <= io_enq_bits_4; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h7 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_7_5 <= io_enq_bits_5; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h7 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_7_6 <= io_enq_bits_6; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h7 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_7_7 <= io_enq_bits_7; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h7 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_7_8 <= io_enq_bits_8; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h7 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_7_9 <= io_enq_bits_9; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h7 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_7_10 <= io_enq_bits_10; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h7 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_7_11 <= io_enq_bits_11; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h7 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_7_12 <= io_enq_bits_12; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h7 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_7_13 <= io_enq_bits_13; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h7 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_7_14 <= io_enq_bits_14; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
    if (_widx_T_1) begin // @[src/main/scala/util/AsyncQueue.scala 86:22]
      if (3'h7 == index) begin // @[src/main/scala/util/AsyncQueue.scala 86:35]
        mem_7_15 <= io_enq_bits_15; // @[src/main/scala/util/AsyncQueue.scala 86:35]
      end
    end
  end
  always @(posedge clock or posedge reset) begin
    if (reset) begin // @[src/main/scala/util/AsyncQueue.scala 53:23]
      widx_widx_bin <= 4'h0;
    end else if (_widx_T_2) begin
      widx_widx_bin <= 4'h0;
    end else begin
      widx_widx_bin <= _widx_incremented_T_1;
    end
  end
  always @(posedge clock or posedge reset) begin
    if (reset) begin // @[src/main/scala/util/AsyncQueue.scala 83:26]
      ready_reg <= 1'h0;
    end else begin
      ready_reg <= sink_ready & widx != _ready_T;
    end
  end
  always @(posedge clock or posedge reset) begin
    if (reset) begin // @[src/main/scala/util/AsyncQueue.scala 54:17]
      widx_gray <= 4'h0;
    end else begin
      widx_gray <= widx_incremented ^ _GEN_257;
    end
  end
endmodule
module ClockCrossingReg_w256(
  input          clock,
  input  [255:0] io_d, // @[src/main/scala/util/SynchronizerReg.scala 195:14]
  output [255:0] io_q, // @[src/main/scala/util/SynchronizerReg.scala 195:14]
  input          io_en // @[src/main/scala/util/SynchronizerReg.scala 195:14]
);
  reg [255:0] cdc_reg; // @[src/main/scala/util/SynchronizerReg.scala 201:76]
  assign io_q = cdc_reg; // @[src/main/scala/util/SynchronizerReg.scala 202:8]
  always @(posedge clock) begin
    if (io_en) begin // @[src/main/scala/util/SynchronizerReg.scala 201:76]
      cdc_reg <= io_d; // @[src/main/scala/util/SynchronizerReg.scala 201:76]
    end
  end
endmodule
module AsyncQueueSink(
  input         clock,
  input         reset,
  input         io_deq_ready, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  output        io_deq_valid, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  output [15:0] io_deq_bits_0, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  output [15:0] io_deq_bits_1, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  output [15:0] io_deq_bits_2, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  output [15:0] io_deq_bits_3, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  output [15:0] io_deq_bits_4, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  output [15:0] io_deq_bits_5, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  output [15:0] io_deq_bits_6, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  output [15:0] io_deq_bits_7, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  output [15:0] io_deq_bits_8, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  output [15:0] io_deq_bits_9, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  output [15:0] io_deq_bits_10, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  output [15:0] io_deq_bits_11, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  output [15:0] io_deq_bits_12, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  output [15:0] io_deq_bits_13, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  output [15:0] io_deq_bits_14, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  output [15:0] io_deq_bits_15, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_0_0, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_0_1, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_0_2, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_0_3, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_0_4, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_0_5, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_0_6, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_0_7, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_0_8, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_0_9, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_0_10, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_0_11, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_0_12, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_0_13, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_0_14, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_0_15, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_1_0, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_1_1, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_1_2, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_1_3, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_1_4, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_1_5, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_1_6, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_1_7, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_1_8, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_1_9, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_1_10, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_1_11, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_1_12, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_1_13, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_1_14, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_1_15, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_2_0, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_2_1, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_2_2, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_2_3, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_2_4, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_2_5, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_2_6, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_2_7, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_2_8, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_2_9, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_2_10, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_2_11, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_2_12, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_2_13, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_2_14, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_2_15, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_3_0, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_3_1, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_3_2, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_3_3, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_3_4, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_3_5, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_3_6, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_3_7, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_3_8, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_3_9, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_3_10, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_3_11, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_3_12, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_3_13, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_3_14, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_3_15, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_4_0, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_4_1, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_4_2, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_4_3, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_4_4, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_4_5, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_4_6, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_4_7, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_4_8, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_4_9, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_4_10, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_4_11, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_4_12, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_4_13, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_4_14, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_4_15, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_5_0, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_5_1, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_5_2, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_5_3, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_5_4, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_5_5, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_5_6, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_5_7, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_5_8, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_5_9, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_5_10, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_5_11, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_5_12, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_5_13, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_5_14, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_5_15, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_6_0, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_6_1, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_6_2, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_6_3, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_6_4, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_6_5, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_6_6, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_6_7, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_6_8, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_6_9, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_6_10, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_6_11, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_6_12, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_6_13, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_6_14, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_6_15, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_7_0, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_7_1, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_7_2, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_7_3, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_7_4, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_7_5, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_7_6, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_7_7, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_7_8, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_7_9, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_7_10, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_7_11, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_7_12, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_7_13, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_7_14, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [15:0] io_async_mem_7_15, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  output [3:0]  io_async_ridx, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input  [3:0]  io_async_widx, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  output        io_async_safe_ridx_valid, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input         io_async_safe_widx_valid, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  input         io_async_safe_source_reset_n, // @[src/main/scala/util/AsyncQueue.scala 135:14]
  output        io_async_safe_sink_reset_n // @[src/main/scala/util/AsyncQueue.scala 135:14]
);
  wire  widx_widx_gray_clock; // @[src/main/scala/util/ShiftReg.scala 45:23]
  wire  widx_widx_gray_reset; // @[src/main/scala/util/ShiftReg.scala 45:23]
  wire [3:0] widx_widx_gray_io_d; // @[src/main/scala/util/ShiftReg.scala 45:23]
  wire [3:0] widx_widx_gray_io_q; // @[src/main/scala/util/ShiftReg.scala 45:23]
  wire  io_deq_bits_deq_bits_reg_clock; // @[src/main/scala/util/SynchronizerReg.scala 207:25]
  wire [255:0] io_deq_bits_deq_bits_reg_io_d; // @[src/main/scala/util/SynchronizerReg.scala 207:25]
  wire [255:0] io_deq_bits_deq_bits_reg_io_q; // @[src/main/scala/util/SynchronizerReg.scala 207:25]
  wire  io_deq_bits_deq_bits_reg_io_en; // @[src/main/scala/util/SynchronizerReg.scala 207:25]
  wire  sink_valid_0_io_in; // @[src/main/scala/util/AsyncQueue.scala 168:33]
  wire  sink_valid_0_io_out; // @[src/main/scala/util/AsyncQueue.scala 168:33]
  wire  sink_valid_0_clock; // @[src/main/scala/util/AsyncQueue.scala 168:33]
  wire  sink_valid_0_reset; // @[src/main/scala/util/AsyncQueue.scala 168:33]
  wire  sink_valid_1_io_in; // @[src/main/scala/util/AsyncQueue.scala 169:33]
  wire  sink_valid_1_io_out; // @[src/main/scala/util/AsyncQueue.scala 169:33]
  wire  sink_valid_1_clock; // @[src/main/scala/util/AsyncQueue.scala 169:33]
  wire  sink_valid_1_reset; // @[src/main/scala/util/AsyncQueue.scala 169:33]
  wire  source_extend_io_in; // @[src/main/scala/util/AsyncQueue.scala 171:31]
  wire  source_extend_io_out; // @[src/main/scala/util/AsyncQueue.scala 171:31]
  wire  source_extend_clock; // @[src/main/scala/util/AsyncQueue.scala 171:31]
  wire  source_extend_reset; // @[src/main/scala/util/AsyncQueue.scala 171:31]
  wire  source_valid_io_in; // @[src/main/scala/util/AsyncQueue.scala 172:31]
  wire  source_valid_io_out; // @[src/main/scala/util/AsyncQueue.scala 172:31]
  wire  source_valid_clock; // @[src/main/scala/util/AsyncQueue.scala 172:31]
  wire  source_valid_reset; // @[src/main/scala/util/AsyncQueue.scala 172:31]
  wire  _ridx_T_1 = io_deq_ready & io_deq_valid; // @[src/main/scala/chisel3/util/Decoupled.scala 52:35]
  wire  source_ready = source_valid_io_out; // @[src/main/scala/util/AsyncQueue.scala 143:30 188:18]
  wire  _ridx_T_2 = ~source_ready; // @[src/main/scala/util/AsyncQueue.scala 144:77]
  reg [3:0] ridx_ridx_bin; // @[src/main/scala/util/AsyncQueue.scala 52:25]
  wire [3:0] _GEN_128 = {{3'd0}, _ridx_T_1}; // @[src/main/scala/util/AsyncQueue.scala 53:43]
  wire [3:0] _ridx_incremented_T_1 = ridx_ridx_bin + _GEN_128; // @[src/main/scala/util/AsyncQueue.scala 53:43]
  wire [3:0] ridx_incremented = _ridx_T_2 ? 4'h0 : _ridx_incremented_T_1; // @[src/main/scala/util/AsyncQueue.scala 53:23]
  wire [3:0] _GEN_129 = {{1'd0}, ridx_incremented[3:1]}; // @[src/main/scala/util/AsyncQueue.scala 54:17]
  wire [3:0] ridx = ridx_incremented ^ _GEN_129; // @[src/main/scala/util/AsyncQueue.scala 54:17]
  wire [3:0] widx = widx_widx_gray_io_q; // @[src/main/scala/util/ShiftReg.scala 48:{24,24}]
  wire [2:0] _index_T_2 = {ridx[3], 2'h0}; // @[src/main/scala/util/AsyncQueue.scala 152:75]
  wire [2:0] index = ridx[2:0] ^ _index_T_2; // @[src/main/scala/util/AsyncQueue.scala 152:55]
  wire [15:0] _GEN_1 = 3'h1 == index ? io_async_mem_1_1 : io_async_mem_0_1; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_2 = 3'h2 == index ? io_async_mem_2_1 : _GEN_1; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_3 = 3'h3 == index ? io_async_mem_3_1 : _GEN_2; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_4 = 3'h4 == index ? io_async_mem_4_1 : _GEN_3; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_5 = 3'h5 == index ? io_async_mem_5_1 : _GEN_4; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_6 = 3'h6 == index ? io_async_mem_6_1 : _GEN_5; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_7 = 3'h7 == index ? io_async_mem_7_1 : _GEN_6; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_9 = 3'h1 == index ? io_async_mem_1_0 : io_async_mem_0_0; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_10 = 3'h2 == index ? io_async_mem_2_0 : _GEN_9; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_11 = 3'h3 == index ? io_async_mem_3_0 : _GEN_10; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_12 = 3'h4 == index ? io_async_mem_4_0 : _GEN_11; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_13 = 3'h5 == index ? io_async_mem_5_0 : _GEN_12; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_14 = 3'h6 == index ? io_async_mem_6_0 : _GEN_13; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_15 = 3'h7 == index ? io_async_mem_7_0 : _GEN_14; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_17 = 3'h1 == index ? io_async_mem_1_3 : io_async_mem_0_3; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_18 = 3'h2 == index ? io_async_mem_2_3 : _GEN_17; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_19 = 3'h3 == index ? io_async_mem_3_3 : _GEN_18; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_20 = 3'h4 == index ? io_async_mem_4_3 : _GEN_19; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_21 = 3'h5 == index ? io_async_mem_5_3 : _GEN_20; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_22 = 3'h6 == index ? io_async_mem_6_3 : _GEN_21; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_23 = 3'h7 == index ? io_async_mem_7_3 : _GEN_22; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_25 = 3'h1 == index ? io_async_mem_1_2 : io_async_mem_0_2; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_26 = 3'h2 == index ? io_async_mem_2_2 : _GEN_25; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_27 = 3'h3 == index ? io_async_mem_3_2 : _GEN_26; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_28 = 3'h4 == index ? io_async_mem_4_2 : _GEN_27; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_29 = 3'h5 == index ? io_async_mem_5_2 : _GEN_28; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_30 = 3'h6 == index ? io_async_mem_6_2 : _GEN_29; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_31 = 3'h7 == index ? io_async_mem_7_2 : _GEN_30; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_33 = 3'h1 == index ? io_async_mem_1_5 : io_async_mem_0_5; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_34 = 3'h2 == index ? io_async_mem_2_5 : _GEN_33; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_35 = 3'h3 == index ? io_async_mem_3_5 : _GEN_34; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_36 = 3'h4 == index ? io_async_mem_4_5 : _GEN_35; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_37 = 3'h5 == index ? io_async_mem_5_5 : _GEN_36; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_38 = 3'h6 == index ? io_async_mem_6_5 : _GEN_37; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_39 = 3'h7 == index ? io_async_mem_7_5 : _GEN_38; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_41 = 3'h1 == index ? io_async_mem_1_4 : io_async_mem_0_4; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_42 = 3'h2 == index ? io_async_mem_2_4 : _GEN_41; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_43 = 3'h3 == index ? io_async_mem_3_4 : _GEN_42; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_44 = 3'h4 == index ? io_async_mem_4_4 : _GEN_43; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_45 = 3'h5 == index ? io_async_mem_5_4 : _GEN_44; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_46 = 3'h6 == index ? io_async_mem_6_4 : _GEN_45; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_47 = 3'h7 == index ? io_async_mem_7_4 : _GEN_46; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_49 = 3'h1 == index ? io_async_mem_1_7 : io_async_mem_0_7; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_50 = 3'h2 == index ? io_async_mem_2_7 : _GEN_49; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_51 = 3'h3 == index ? io_async_mem_3_7 : _GEN_50; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_52 = 3'h4 == index ? io_async_mem_4_7 : _GEN_51; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_53 = 3'h5 == index ? io_async_mem_5_7 : _GEN_52; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_54 = 3'h6 == index ? io_async_mem_6_7 : _GEN_53; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_55 = 3'h7 == index ? io_async_mem_7_7 : _GEN_54; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_57 = 3'h1 == index ? io_async_mem_1_6 : io_async_mem_0_6; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_58 = 3'h2 == index ? io_async_mem_2_6 : _GEN_57; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_59 = 3'h3 == index ? io_async_mem_3_6 : _GEN_58; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_60 = 3'h4 == index ? io_async_mem_4_6 : _GEN_59; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_61 = 3'h5 == index ? io_async_mem_5_6 : _GEN_60; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_62 = 3'h6 == index ? io_async_mem_6_6 : _GEN_61; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_63 = 3'h7 == index ? io_async_mem_7_6 : _GEN_62; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [127:0] io_deq_bits_deq_bits_reg_io_d_lo = {_GEN_55,_GEN_63,_GEN_39,_GEN_47,_GEN_23,_GEN_31,_GEN_7,_GEN_15}; // @[src/main/scala/util/SynchronizerReg.scala 209:24]
  wire [15:0] _GEN_65 = 3'h1 == index ? io_async_mem_1_9 : io_async_mem_0_9; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_66 = 3'h2 == index ? io_async_mem_2_9 : _GEN_65; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_67 = 3'h3 == index ? io_async_mem_3_9 : _GEN_66; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_68 = 3'h4 == index ? io_async_mem_4_9 : _GEN_67; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_69 = 3'h5 == index ? io_async_mem_5_9 : _GEN_68; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_70 = 3'h6 == index ? io_async_mem_6_9 : _GEN_69; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_71 = 3'h7 == index ? io_async_mem_7_9 : _GEN_70; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_73 = 3'h1 == index ? io_async_mem_1_8 : io_async_mem_0_8; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_74 = 3'h2 == index ? io_async_mem_2_8 : _GEN_73; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_75 = 3'h3 == index ? io_async_mem_3_8 : _GEN_74; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_76 = 3'h4 == index ? io_async_mem_4_8 : _GEN_75; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_77 = 3'h5 == index ? io_async_mem_5_8 : _GEN_76; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_78 = 3'h6 == index ? io_async_mem_6_8 : _GEN_77; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_79 = 3'h7 == index ? io_async_mem_7_8 : _GEN_78; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_81 = 3'h1 == index ? io_async_mem_1_11 : io_async_mem_0_11; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_82 = 3'h2 == index ? io_async_mem_2_11 : _GEN_81; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_83 = 3'h3 == index ? io_async_mem_3_11 : _GEN_82; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_84 = 3'h4 == index ? io_async_mem_4_11 : _GEN_83; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_85 = 3'h5 == index ? io_async_mem_5_11 : _GEN_84; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_86 = 3'h6 == index ? io_async_mem_6_11 : _GEN_85; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_87 = 3'h7 == index ? io_async_mem_7_11 : _GEN_86; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_89 = 3'h1 == index ? io_async_mem_1_10 : io_async_mem_0_10; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_90 = 3'h2 == index ? io_async_mem_2_10 : _GEN_89; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_91 = 3'h3 == index ? io_async_mem_3_10 : _GEN_90; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_92 = 3'h4 == index ? io_async_mem_4_10 : _GEN_91; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_93 = 3'h5 == index ? io_async_mem_5_10 : _GEN_92; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_94 = 3'h6 == index ? io_async_mem_6_10 : _GEN_93; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_95 = 3'h7 == index ? io_async_mem_7_10 : _GEN_94; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_97 = 3'h1 == index ? io_async_mem_1_13 : io_async_mem_0_13; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_98 = 3'h2 == index ? io_async_mem_2_13 : _GEN_97; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_99 = 3'h3 == index ? io_async_mem_3_13 : _GEN_98; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_100 = 3'h4 == index ? io_async_mem_4_13 : _GEN_99; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_101 = 3'h5 == index ? io_async_mem_5_13 : _GEN_100; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_102 = 3'h6 == index ? io_async_mem_6_13 : _GEN_101; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_103 = 3'h7 == index ? io_async_mem_7_13 : _GEN_102; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_105 = 3'h1 == index ? io_async_mem_1_12 : io_async_mem_0_12; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_106 = 3'h2 == index ? io_async_mem_2_12 : _GEN_105; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_107 = 3'h3 == index ? io_async_mem_3_12 : _GEN_106; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_108 = 3'h4 == index ? io_async_mem_4_12 : _GEN_107; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_109 = 3'h5 == index ? io_async_mem_5_12 : _GEN_108; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_110 = 3'h6 == index ? io_async_mem_6_12 : _GEN_109; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_111 = 3'h7 == index ? io_async_mem_7_12 : _GEN_110; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_113 = 3'h1 == index ? io_async_mem_1_15 : io_async_mem_0_15; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_114 = 3'h2 == index ? io_async_mem_2_15 : _GEN_113; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_115 = 3'h3 == index ? io_async_mem_3_15 : _GEN_114; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_116 = 3'h4 == index ? io_async_mem_4_15 : _GEN_115; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_117 = 3'h5 == index ? io_async_mem_5_15 : _GEN_116; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_118 = 3'h6 == index ? io_async_mem_6_15 : _GEN_117; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_119 = 3'h7 == index ? io_async_mem_7_15 : _GEN_118; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_121 = 3'h1 == index ? io_async_mem_1_14 : io_async_mem_0_14; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_122 = 3'h2 == index ? io_async_mem_2_14 : _GEN_121; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_123 = 3'h3 == index ? io_async_mem_3_14 : _GEN_122; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_124 = 3'h4 == index ? io_async_mem_4_14 : _GEN_123; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_125 = 3'h5 == index ? io_async_mem_5_14 : _GEN_124; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_126 = 3'h6 == index ? io_async_mem_6_14 : _GEN_125; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [15:0] _GEN_127 = 3'h7 == index ? io_async_mem_7_14 : _GEN_126; // @[src/main/scala/util/SynchronizerReg.scala 209:{24,24}]
  wire [127:0] io_deq_bits_deq_bits_reg_io_d_hi = {_GEN_119,_GEN_127,_GEN_103,_GEN_111,_GEN_87,_GEN_95,_GEN_71,_GEN_79}; // @[src/main/scala/util/SynchronizerReg.scala 209:24]
  wire [255:0] _io_deq_bits_WIRE_1 = io_deq_bits_deq_bits_reg_io_q; // @[src/main/scala/util/SynchronizerReg.scala 211:{26,26}]
  reg  valid_reg; // @[src/main/scala/util/AsyncQueue.scala 161:56]
  reg [3:0] ridx_gray; // @[src/main/scala/util/AsyncQueue.scala 164:55]
  AsyncResetSynchronizerShiftReg_w4_d3_i0 widx_widx_gray ( // @[src/main/scala/util/ShiftReg.scala 45:23]
    .clock(widx_widx_gray_clock),
    .reset(widx_widx_gray_reset),
    .io_d(widx_widx_gray_io_d),
    .io_q(widx_widx_gray_io_q)
  );
  ClockCrossingReg_w256 io_deq_bits_deq_bits_reg ( // @[src/main/scala/util/SynchronizerReg.scala 207:25]
    .clock(io_deq_bits_deq_bits_reg_clock),
    .io_d(io_deq_bits_deq_bits_reg_io_d),
    .io_q(io_deq_bits_deq_bits_reg_io_q),
    .io_en(io_deq_bits_deq_bits_reg_io_en)
  );
  AsyncValidSync sink_valid_0 ( // @[src/main/scala/util/AsyncQueue.scala 168:33]
    .io_in(sink_valid_0_io_in),
    .io_out(sink_valid_0_io_out),
    .clock(sink_valid_0_clock),
    .reset(sink_valid_0_reset)
  );
  AsyncValidSync sink_valid_1 ( // @[src/main/scala/util/AsyncQueue.scala 169:33]
    .io_in(sink_valid_1_io_in),
    .io_out(sink_valid_1_io_out),
    .clock(sink_valid_1_clock),
    .reset(sink_valid_1_reset)
  );
  AsyncValidSync source_extend ( // @[src/main/scala/util/AsyncQueue.scala 171:31]
    .io_in(source_extend_io_in),
    .io_out(source_extend_io_out),
    .clock(source_extend_clock),
    .reset(source_extend_reset)
  );
  AsyncValidSync source_valid ( // @[src/main/scala/util/AsyncQueue.scala 172:31]
    .io_in(source_valid_io_in),
    .io_out(source_valid_io_out),
    .clock(source_valid_clock),
    .reset(source_valid_reset)
  );
  assign io_deq_valid = valid_reg & source_ready; // @[src/main/scala/util/AsyncQueue.scala 162:29]
  assign io_deq_bits_0 = _io_deq_bits_WIRE_1[15:0]; // @[src/main/scala/util/SynchronizerReg.scala 211:26]
  assign io_deq_bits_1 = _io_deq_bits_WIRE_1[31:16]; // @[src/main/scala/util/SynchronizerReg.scala 211:26]
  assign io_deq_bits_2 = _io_deq_bits_WIRE_1[47:32]; // @[src/main/scala/util/SynchronizerReg.scala 211:26]
  assign io_deq_bits_3 = _io_deq_bits_WIRE_1[63:48]; // @[src/main/scala/util/SynchronizerReg.scala 211:26]
  assign io_deq_bits_4 = _io_deq_bits_WIRE_1[79:64]; // @[src/main/scala/util/SynchronizerReg.scala 211:26]
  assign io_deq_bits_5 = _io_deq_bits_WIRE_1[95:80]; // @[src/main/scala/util/SynchronizerReg.scala 211:26]
  assign io_deq_bits_6 = _io_deq_bits_WIRE_1[111:96]; // @[src/main/scala/util/SynchronizerReg.scala 211:26]
  assign io_deq_bits_7 = _io_deq_bits_WIRE_1[127:112]; // @[src/main/scala/util/SynchronizerReg.scala 211:26]
  assign io_deq_bits_8 = _io_deq_bits_WIRE_1[143:128]; // @[src/main/scala/util/SynchronizerReg.scala 211:26]
  assign io_deq_bits_9 = _io_deq_bits_WIRE_1[159:144]; // @[src/main/scala/util/SynchronizerReg.scala 211:26]
  assign io_deq_bits_10 = _io_deq_bits_WIRE_1[175:160]; // @[src/main/scala/util/SynchronizerReg.scala 211:26]
  assign io_deq_bits_11 = _io_deq_bits_WIRE_1[191:176]; // @[src/main/scala/util/SynchronizerReg.scala 211:26]
  assign io_deq_bits_12 = _io_deq_bits_WIRE_1[207:192]; // @[src/main/scala/util/SynchronizerReg.scala 211:26]
  assign io_deq_bits_13 = _io_deq_bits_WIRE_1[223:208]; // @[src/main/scala/util/SynchronizerReg.scala 211:26]
  assign io_deq_bits_14 = _io_deq_bits_WIRE_1[239:224]; // @[src/main/scala/util/SynchronizerReg.scala 211:26]
  assign io_deq_bits_15 = _io_deq_bits_WIRE_1[255:240]; // @[src/main/scala/util/SynchronizerReg.scala 211:26]
  assign io_async_ridx = ridx_gray; // @[src/main/scala/util/AsyncQueue.scala 165:17]
  assign io_async_safe_ridx_valid = sink_valid_1_io_out; // @[src/main/scala/util/AsyncQueue.scala 185:20]
  assign io_async_safe_sink_reset_n = ~reset; // @[src/main/scala/util/AsyncQueue.scala 189:25]
  assign widx_widx_gray_clock = clock;
  assign widx_widx_gray_reset = reset;
  assign widx_widx_gray_io_d = io_async_widx; // @[src/main/scala/util/ShiftReg.scala 47:16]
  assign io_deq_bits_deq_bits_reg_clock = clock;
  assign io_deq_bits_deq_bits_reg_io_d = {io_deq_bits_deq_bits_reg_io_d_hi,io_deq_bits_deq_bits_reg_io_d_lo}; // @[src/main/scala/util/SynchronizerReg.scala 209:24]
  assign io_deq_bits_deq_bits_reg_io_en = source_ready & ridx != widx; // @[src/main/scala/util/AsyncQueue.scala 146:28]
  assign sink_valid_0_io_in = 1'h1; // @[src/main/scala/util/AsyncQueue.scala 183:24]
  assign sink_valid_0_clock = clock; // @[src/main/scala/util/AsyncQueue.scala 178:25]
  assign sink_valid_0_reset = reset | ~io_async_safe_source_reset_n; // @[src/main/scala/util/AsyncQueue.scala 173:66]
  assign sink_valid_1_io_in = sink_valid_0_io_out; // @[src/main/scala/util/AsyncQueue.scala 184:24]
  assign sink_valid_1_clock = clock; // @[src/main/scala/util/AsyncQueue.scala 179:25]
  assign sink_valid_1_reset = reset | ~io_async_safe_source_reset_n; // @[src/main/scala/util/AsyncQueue.scala 174:66]
  assign source_extend_io_in = io_async_safe_widx_valid; // @[src/main/scala/util/AsyncQueue.scala 186:25]
  assign source_extend_clock = clock; // @[src/main/scala/util/AsyncQueue.scala 180:25]
  assign source_extend_reset = reset | ~io_async_safe_source_reset_n; // @[src/main/scala/util/AsyncQueue.scala 175:66]
  assign source_valid_io_in = source_extend_io_out; // @[src/main/scala/util/AsyncQueue.scala 187:24]
  assign source_valid_clock = clock; // @[src/main/scala/util/AsyncQueue.scala 181:25]
  assign source_valid_reset = reset; // @[src/main/scala/util/AsyncQueue.scala 176:34]
  always @(posedge clock or posedge reset) begin
    if (reset) begin // @[src/main/scala/util/AsyncQueue.scala 53:23]
      ridx_ridx_bin <= 4'h0;
    end else if (_ridx_T_2) begin
      ridx_ridx_bin <= 4'h0;
    end else begin
      ridx_ridx_bin <= _ridx_incremented_T_1;
    end
  end
  always @(posedge clock or posedge reset) begin
    if (reset) begin // @[src/main/scala/util/AsyncQueue.scala 146:28]
      valid_reg <= 1'h0;
    end else begin
      valid_reg <= source_ready & ridx != widx;
    end
  end
  always @(posedge clock or posedge reset) begin
    if (reset) begin // @[src/main/scala/util/AsyncQueue.scala 54:17]
      ridx_gray <= 4'h0;
    end else begin
      ridx_gray <= ridx_incremented ^ _GEN_129;
    end
  end
endmodule
module AsyncQueue(
  input         io_enq_clock, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  input         io_enq_reset, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  output        io_enq_ready, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  input         io_enq_valid, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  input  [15:0] io_enq_bits_0, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  input  [15:0] io_enq_bits_1, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  input  [15:0] io_enq_bits_2, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  input  [15:0] io_enq_bits_3, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  input  [15:0] io_enq_bits_4, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  input  [15:0] io_enq_bits_5, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  input  [15:0] io_enq_bits_6, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  input  [15:0] io_enq_bits_7, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  input  [15:0] io_enq_bits_8, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  input  [15:0] io_enq_bits_9, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  input  [15:0] io_enq_bits_10, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  input  [15:0] io_enq_bits_11, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  input  [15:0] io_enq_bits_12, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  input  [15:0] io_enq_bits_13, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  input  [15:0] io_enq_bits_14, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  input  [15:0] io_enq_bits_15, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  input         io_deq_clock, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  input         io_deq_reset, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  input         io_deq_ready, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  output        io_deq_valid, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  output [15:0] io_deq_bits_0, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  output [15:0] io_deq_bits_1, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  output [15:0] io_deq_bits_2, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  output [15:0] io_deq_bits_3, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  output [15:0] io_deq_bits_4, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  output [15:0] io_deq_bits_5, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  output [15:0] io_deq_bits_6, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  output [15:0] io_deq_bits_7, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  output [15:0] io_deq_bits_8, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  output [15:0] io_deq_bits_9, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  output [15:0] io_deq_bits_10, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  output [15:0] io_deq_bits_11, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  output [15:0] io_deq_bits_12, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  output [15:0] io_deq_bits_13, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  output [15:0] io_deq_bits_14, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  output [15:0] io_deq_bits_15 // @[src/main/scala/util/AsyncQueue.scala 223:14]
);
  wire  source_clock; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire  source_reset; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire  source_io_enq_ready; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire  source_io_enq_valid; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_enq_bits_0; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_enq_bits_1; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_enq_bits_2; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_enq_bits_3; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_enq_bits_4; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_enq_bits_5; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_enq_bits_6; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_enq_bits_7; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_enq_bits_8; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_enq_bits_9; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_enq_bits_10; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_enq_bits_11; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_enq_bits_12; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_enq_bits_13; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_enq_bits_14; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_enq_bits_15; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_0_0; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_0_1; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_0_2; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_0_3; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_0_4; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_0_5; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_0_6; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_0_7; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_0_8; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_0_9; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_0_10; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_0_11; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_0_12; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_0_13; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_0_14; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_0_15; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_1_0; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_1_1; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_1_2; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_1_3; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_1_4; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_1_5; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_1_6; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_1_7; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_1_8; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_1_9; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_1_10; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_1_11; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_1_12; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_1_13; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_1_14; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_1_15; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_2_0; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_2_1; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_2_2; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_2_3; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_2_4; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_2_5; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_2_6; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_2_7; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_2_8; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_2_9; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_2_10; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_2_11; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_2_12; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_2_13; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_2_14; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_2_15; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_3_0; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_3_1; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_3_2; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_3_3; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_3_4; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_3_5; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_3_6; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_3_7; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_3_8; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_3_9; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_3_10; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_3_11; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_3_12; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_3_13; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_3_14; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_3_15; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_4_0; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_4_1; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_4_2; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_4_3; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_4_4; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_4_5; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_4_6; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_4_7; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_4_8; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_4_9; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_4_10; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_4_11; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_4_12; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_4_13; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_4_14; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_4_15; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_5_0; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_5_1; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_5_2; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_5_3; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_5_4; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_5_5; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_5_6; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_5_7; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_5_8; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_5_9; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_5_10; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_5_11; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_5_12; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_5_13; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_5_14; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_5_15; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_6_0; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_6_1; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_6_2; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_6_3; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_6_4; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_6_5; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_6_6; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_6_7; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_6_8; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_6_9; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_6_10; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_6_11; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_6_12; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_6_13; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_6_14; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_6_15; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_7_0; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_7_1; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_7_2; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_7_3; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_7_4; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_7_5; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_7_6; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_7_7; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_7_8; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_7_9; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_7_10; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_7_11; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_7_12; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_7_13; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_7_14; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_7_15; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [3:0] source_io_async_ridx; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [3:0] source_io_async_widx; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire  source_io_async_safe_ridx_valid; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire  source_io_async_safe_widx_valid; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire  source_io_async_safe_source_reset_n; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire  source_io_async_safe_sink_reset_n; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire  sink_clock; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire  sink_reset; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire  sink_io_deq_ready; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire  sink_io_deq_valid; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_deq_bits_0; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_deq_bits_1; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_deq_bits_2; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_deq_bits_3; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_deq_bits_4; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_deq_bits_5; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_deq_bits_6; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_deq_bits_7; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_deq_bits_8; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_deq_bits_9; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_deq_bits_10; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_deq_bits_11; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_deq_bits_12; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_deq_bits_13; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_deq_bits_14; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_deq_bits_15; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_0_0; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_0_1; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_0_2; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_0_3; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_0_4; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_0_5; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_0_6; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_0_7; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_0_8; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_0_9; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_0_10; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_0_11; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_0_12; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_0_13; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_0_14; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_0_15; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_1_0; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_1_1; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_1_2; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_1_3; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_1_4; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_1_5; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_1_6; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_1_7; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_1_8; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_1_9; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_1_10; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_1_11; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_1_12; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_1_13; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_1_14; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_1_15; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_2_0; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_2_1; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_2_2; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_2_3; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_2_4; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_2_5; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_2_6; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_2_7; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_2_8; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_2_9; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_2_10; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_2_11; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_2_12; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_2_13; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_2_14; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_2_15; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_3_0; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_3_1; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_3_2; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_3_3; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_3_4; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_3_5; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_3_6; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_3_7; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_3_8; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_3_9; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_3_10; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_3_11; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_3_12; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_3_13; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_3_14; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_3_15; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_4_0; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_4_1; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_4_2; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_4_3; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_4_4; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_4_5; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_4_6; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_4_7; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_4_8; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_4_9; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_4_10; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_4_11; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_4_12; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_4_13; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_4_14; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_4_15; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_5_0; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_5_1; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_5_2; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_5_3; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_5_4; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_5_5; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_5_6; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_5_7; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_5_8; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_5_9; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_5_10; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_5_11; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_5_12; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_5_13; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_5_14; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_5_15; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_6_0; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_6_1; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_6_2; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_6_3; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_6_4; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_6_5; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_6_6; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_6_7; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_6_8; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_6_9; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_6_10; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_6_11; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_6_12; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_6_13; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_6_14; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_6_15; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_7_0; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_7_1; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_7_2; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_7_3; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_7_4; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_7_5; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_7_6; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_7_7; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_7_8; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_7_9; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_7_10; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_7_11; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_7_12; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_7_13; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_7_14; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_7_15; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [3:0] sink_io_async_ridx; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [3:0] sink_io_async_widx; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire  sink_io_async_safe_ridx_valid; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire  sink_io_async_safe_widx_valid; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire  sink_io_async_safe_source_reset_n; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire  sink_io_async_safe_sink_reset_n; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  AsyncQueueSource source ( // @[src/main/scala/util/AsyncQueue.scala 224:70]
    .clock(source_clock),
    .reset(source_reset),
    .io_enq_ready(source_io_enq_ready),
    .io_enq_valid(source_io_enq_valid),
    .io_enq_bits_0(source_io_enq_bits_0),
    .io_enq_bits_1(source_io_enq_bits_1),
    .io_enq_bits_2(source_io_enq_bits_2),
    .io_enq_bits_3(source_io_enq_bits_3),
    .io_enq_bits_4(source_io_enq_bits_4),
    .io_enq_bits_5(source_io_enq_bits_5),
    .io_enq_bits_6(source_io_enq_bits_6),
    .io_enq_bits_7(source_io_enq_bits_7),
    .io_enq_bits_8(source_io_enq_bits_8),
    .io_enq_bits_9(source_io_enq_bits_9),
    .io_enq_bits_10(source_io_enq_bits_10),
    .io_enq_bits_11(source_io_enq_bits_11),
    .io_enq_bits_12(source_io_enq_bits_12),
    .io_enq_bits_13(source_io_enq_bits_13),
    .io_enq_bits_14(source_io_enq_bits_14),
    .io_enq_bits_15(source_io_enq_bits_15),
    .io_async_mem_0_0(source_io_async_mem_0_0),
    .io_async_mem_0_1(source_io_async_mem_0_1),
    .io_async_mem_0_2(source_io_async_mem_0_2),
    .io_async_mem_0_3(source_io_async_mem_0_3),
    .io_async_mem_0_4(source_io_async_mem_0_4),
    .io_async_mem_0_5(source_io_async_mem_0_5),
    .io_async_mem_0_6(source_io_async_mem_0_6),
    .io_async_mem_0_7(source_io_async_mem_0_7),
    .io_async_mem_0_8(source_io_async_mem_0_8),
    .io_async_mem_0_9(source_io_async_mem_0_9),
    .io_async_mem_0_10(source_io_async_mem_0_10),
    .io_async_mem_0_11(source_io_async_mem_0_11),
    .io_async_mem_0_12(source_io_async_mem_0_12),
    .io_async_mem_0_13(source_io_async_mem_0_13),
    .io_async_mem_0_14(source_io_async_mem_0_14),
    .io_async_mem_0_15(source_io_async_mem_0_15),
    .io_async_mem_1_0(source_io_async_mem_1_0),
    .io_async_mem_1_1(source_io_async_mem_1_1),
    .io_async_mem_1_2(source_io_async_mem_1_2),
    .io_async_mem_1_3(source_io_async_mem_1_3),
    .io_async_mem_1_4(source_io_async_mem_1_4),
    .io_async_mem_1_5(source_io_async_mem_1_5),
    .io_async_mem_1_6(source_io_async_mem_1_6),
    .io_async_mem_1_7(source_io_async_mem_1_7),
    .io_async_mem_1_8(source_io_async_mem_1_8),
    .io_async_mem_1_9(source_io_async_mem_1_9),
    .io_async_mem_1_10(source_io_async_mem_1_10),
    .io_async_mem_1_11(source_io_async_mem_1_11),
    .io_async_mem_1_12(source_io_async_mem_1_12),
    .io_async_mem_1_13(source_io_async_mem_1_13),
    .io_async_mem_1_14(source_io_async_mem_1_14),
    .io_async_mem_1_15(source_io_async_mem_1_15),
    .io_async_mem_2_0(source_io_async_mem_2_0),
    .io_async_mem_2_1(source_io_async_mem_2_1),
    .io_async_mem_2_2(source_io_async_mem_2_2),
    .io_async_mem_2_3(source_io_async_mem_2_3),
    .io_async_mem_2_4(source_io_async_mem_2_4),
    .io_async_mem_2_5(source_io_async_mem_2_5),
    .io_async_mem_2_6(source_io_async_mem_2_6),
    .io_async_mem_2_7(source_io_async_mem_2_7),
    .io_async_mem_2_8(source_io_async_mem_2_8),
    .io_async_mem_2_9(source_io_async_mem_2_9),
    .io_async_mem_2_10(source_io_async_mem_2_10),
    .io_async_mem_2_11(source_io_async_mem_2_11),
    .io_async_mem_2_12(source_io_async_mem_2_12),
    .io_async_mem_2_13(source_io_async_mem_2_13),
    .io_async_mem_2_14(source_io_async_mem_2_14),
    .io_async_mem_2_15(source_io_async_mem_2_15),
    .io_async_mem_3_0(source_io_async_mem_3_0),
    .io_async_mem_3_1(source_io_async_mem_3_1),
    .io_async_mem_3_2(source_io_async_mem_3_2),
    .io_async_mem_3_3(source_io_async_mem_3_3),
    .io_async_mem_3_4(source_io_async_mem_3_4),
    .io_async_mem_3_5(source_io_async_mem_3_5),
    .io_async_mem_3_6(source_io_async_mem_3_6),
    .io_async_mem_3_7(source_io_async_mem_3_7),
    .io_async_mem_3_8(source_io_async_mem_3_8),
    .io_async_mem_3_9(source_io_async_mem_3_9),
    .io_async_mem_3_10(source_io_async_mem_3_10),
    .io_async_mem_3_11(source_io_async_mem_3_11),
    .io_async_mem_3_12(source_io_async_mem_3_12),
    .io_async_mem_3_13(source_io_async_mem_3_13),
    .io_async_mem_3_14(source_io_async_mem_3_14),
    .io_async_mem_3_15(source_io_async_mem_3_15),
    .io_async_mem_4_0(source_io_async_mem_4_0),
    .io_async_mem_4_1(source_io_async_mem_4_1),
    .io_async_mem_4_2(source_io_async_mem_4_2),
    .io_async_mem_4_3(source_io_async_mem_4_3),
    .io_async_mem_4_4(source_io_async_mem_4_4),
    .io_async_mem_4_5(source_io_async_mem_4_5),
    .io_async_mem_4_6(source_io_async_mem_4_6),
    .io_async_mem_4_7(source_io_async_mem_4_7),
    .io_async_mem_4_8(source_io_async_mem_4_8),
    .io_async_mem_4_9(source_io_async_mem_4_9),
    .io_async_mem_4_10(source_io_async_mem_4_10),
    .io_async_mem_4_11(source_io_async_mem_4_11),
    .io_async_mem_4_12(source_io_async_mem_4_12),
    .io_async_mem_4_13(source_io_async_mem_4_13),
    .io_async_mem_4_14(source_io_async_mem_4_14),
    .io_async_mem_4_15(source_io_async_mem_4_15),
    .io_async_mem_5_0(source_io_async_mem_5_0),
    .io_async_mem_5_1(source_io_async_mem_5_1),
    .io_async_mem_5_2(source_io_async_mem_5_2),
    .io_async_mem_5_3(source_io_async_mem_5_3),
    .io_async_mem_5_4(source_io_async_mem_5_4),
    .io_async_mem_5_5(source_io_async_mem_5_5),
    .io_async_mem_5_6(source_io_async_mem_5_6),
    .io_async_mem_5_7(source_io_async_mem_5_7),
    .io_async_mem_5_8(source_io_async_mem_5_8),
    .io_async_mem_5_9(source_io_async_mem_5_9),
    .io_async_mem_5_10(source_io_async_mem_5_10),
    .io_async_mem_5_11(source_io_async_mem_5_11),
    .io_async_mem_5_12(source_io_async_mem_5_12),
    .io_async_mem_5_13(source_io_async_mem_5_13),
    .io_async_mem_5_14(source_io_async_mem_5_14),
    .io_async_mem_5_15(source_io_async_mem_5_15),
    .io_async_mem_6_0(source_io_async_mem_6_0),
    .io_async_mem_6_1(source_io_async_mem_6_1),
    .io_async_mem_6_2(source_io_async_mem_6_2),
    .io_async_mem_6_3(source_io_async_mem_6_3),
    .io_async_mem_6_4(source_io_async_mem_6_4),
    .io_async_mem_6_5(source_io_async_mem_6_5),
    .io_async_mem_6_6(source_io_async_mem_6_6),
    .io_async_mem_6_7(source_io_async_mem_6_7),
    .io_async_mem_6_8(source_io_async_mem_6_8),
    .io_async_mem_6_9(source_io_async_mem_6_9),
    .io_async_mem_6_10(source_io_async_mem_6_10),
    .io_async_mem_6_11(source_io_async_mem_6_11),
    .io_async_mem_6_12(source_io_async_mem_6_12),
    .io_async_mem_6_13(source_io_async_mem_6_13),
    .io_async_mem_6_14(source_io_async_mem_6_14),
    .io_async_mem_6_15(source_io_async_mem_6_15),
    .io_async_mem_7_0(source_io_async_mem_7_0),
    .io_async_mem_7_1(source_io_async_mem_7_1),
    .io_async_mem_7_2(source_io_async_mem_7_2),
    .io_async_mem_7_3(source_io_async_mem_7_3),
    .io_async_mem_7_4(source_io_async_mem_7_4),
    .io_async_mem_7_5(source_io_async_mem_7_5),
    .io_async_mem_7_6(source_io_async_mem_7_6),
    .io_async_mem_7_7(source_io_async_mem_7_7),
    .io_async_mem_7_8(source_io_async_mem_7_8),
    .io_async_mem_7_9(source_io_async_mem_7_9),
    .io_async_mem_7_10(source_io_async_mem_7_10),
    .io_async_mem_7_11(source_io_async_mem_7_11),
    .io_async_mem_7_12(source_io_async_mem_7_12),
    .io_async_mem_7_13(source_io_async_mem_7_13),
    .io_async_mem_7_14(source_io_async_mem_7_14),
    .io_async_mem_7_15(source_io_async_mem_7_15),
    .io_async_ridx(source_io_async_ridx),
    .io_async_widx(source_io_async_widx),
    .io_async_safe_ridx_valid(source_io_async_safe_ridx_valid),
    .io_async_safe_widx_valid(source_io_async_safe_widx_valid),
    .io_async_safe_source_reset_n(source_io_async_safe_source_reset_n),
    .io_async_safe_sink_reset_n(source_io_async_safe_sink_reset_n)
  );
  AsyncQueueSink sink ( // @[src/main/scala/util/AsyncQueue.scala 225:70]
    .clock(sink_clock),
    .reset(sink_reset),
    .io_deq_ready(sink_io_deq_ready),
    .io_deq_valid(sink_io_deq_valid),
    .io_deq_bits_0(sink_io_deq_bits_0),
    .io_deq_bits_1(sink_io_deq_bits_1),
    .io_deq_bits_2(sink_io_deq_bits_2),
    .io_deq_bits_3(sink_io_deq_bits_3),
    .io_deq_bits_4(sink_io_deq_bits_4),
    .io_deq_bits_5(sink_io_deq_bits_5),
    .io_deq_bits_6(sink_io_deq_bits_6),
    .io_deq_bits_7(sink_io_deq_bits_7),
    .io_deq_bits_8(sink_io_deq_bits_8),
    .io_deq_bits_9(sink_io_deq_bits_9),
    .io_deq_bits_10(sink_io_deq_bits_10),
    .io_deq_bits_11(sink_io_deq_bits_11),
    .io_deq_bits_12(sink_io_deq_bits_12),
    .io_deq_bits_13(sink_io_deq_bits_13),
    .io_deq_bits_14(sink_io_deq_bits_14),
    .io_deq_bits_15(sink_io_deq_bits_15),
    .io_async_mem_0_0(sink_io_async_mem_0_0),
    .io_async_mem_0_1(sink_io_async_mem_0_1),
    .io_async_mem_0_2(sink_io_async_mem_0_2),
    .io_async_mem_0_3(sink_io_async_mem_0_3),
    .io_async_mem_0_4(sink_io_async_mem_0_4),
    .io_async_mem_0_5(sink_io_async_mem_0_5),
    .io_async_mem_0_6(sink_io_async_mem_0_6),
    .io_async_mem_0_7(sink_io_async_mem_0_7),
    .io_async_mem_0_8(sink_io_async_mem_0_8),
    .io_async_mem_0_9(sink_io_async_mem_0_9),
    .io_async_mem_0_10(sink_io_async_mem_0_10),
    .io_async_mem_0_11(sink_io_async_mem_0_11),
    .io_async_mem_0_12(sink_io_async_mem_0_12),
    .io_async_mem_0_13(sink_io_async_mem_0_13),
    .io_async_mem_0_14(sink_io_async_mem_0_14),
    .io_async_mem_0_15(sink_io_async_mem_0_15),
    .io_async_mem_1_0(sink_io_async_mem_1_0),
    .io_async_mem_1_1(sink_io_async_mem_1_1),
    .io_async_mem_1_2(sink_io_async_mem_1_2),
    .io_async_mem_1_3(sink_io_async_mem_1_3),
    .io_async_mem_1_4(sink_io_async_mem_1_4),
    .io_async_mem_1_5(sink_io_async_mem_1_5),
    .io_async_mem_1_6(sink_io_async_mem_1_6),
    .io_async_mem_1_7(sink_io_async_mem_1_7),
    .io_async_mem_1_8(sink_io_async_mem_1_8),
    .io_async_mem_1_9(sink_io_async_mem_1_9),
    .io_async_mem_1_10(sink_io_async_mem_1_10),
    .io_async_mem_1_11(sink_io_async_mem_1_11),
    .io_async_mem_1_12(sink_io_async_mem_1_12),
    .io_async_mem_1_13(sink_io_async_mem_1_13),
    .io_async_mem_1_14(sink_io_async_mem_1_14),
    .io_async_mem_1_15(sink_io_async_mem_1_15),
    .io_async_mem_2_0(sink_io_async_mem_2_0),
    .io_async_mem_2_1(sink_io_async_mem_2_1),
    .io_async_mem_2_2(sink_io_async_mem_2_2),
    .io_async_mem_2_3(sink_io_async_mem_2_3),
    .io_async_mem_2_4(sink_io_async_mem_2_4),
    .io_async_mem_2_5(sink_io_async_mem_2_5),
    .io_async_mem_2_6(sink_io_async_mem_2_6),
    .io_async_mem_2_7(sink_io_async_mem_2_7),
    .io_async_mem_2_8(sink_io_async_mem_2_8),
    .io_async_mem_2_9(sink_io_async_mem_2_9),
    .io_async_mem_2_10(sink_io_async_mem_2_10),
    .io_async_mem_2_11(sink_io_async_mem_2_11),
    .io_async_mem_2_12(sink_io_async_mem_2_12),
    .io_async_mem_2_13(sink_io_async_mem_2_13),
    .io_async_mem_2_14(sink_io_async_mem_2_14),
    .io_async_mem_2_15(sink_io_async_mem_2_15),
    .io_async_mem_3_0(sink_io_async_mem_3_0),
    .io_async_mem_3_1(sink_io_async_mem_3_1),
    .io_async_mem_3_2(sink_io_async_mem_3_2),
    .io_async_mem_3_3(sink_io_async_mem_3_3),
    .io_async_mem_3_4(sink_io_async_mem_3_4),
    .io_async_mem_3_5(sink_io_async_mem_3_5),
    .io_async_mem_3_6(sink_io_async_mem_3_6),
    .io_async_mem_3_7(sink_io_async_mem_3_7),
    .io_async_mem_3_8(sink_io_async_mem_3_8),
    .io_async_mem_3_9(sink_io_async_mem_3_9),
    .io_async_mem_3_10(sink_io_async_mem_3_10),
    .io_async_mem_3_11(sink_io_async_mem_3_11),
    .io_async_mem_3_12(sink_io_async_mem_3_12),
    .io_async_mem_3_13(sink_io_async_mem_3_13),
    .io_async_mem_3_14(sink_io_async_mem_3_14),
    .io_async_mem_3_15(sink_io_async_mem_3_15),
    .io_async_mem_4_0(sink_io_async_mem_4_0),
    .io_async_mem_4_1(sink_io_async_mem_4_1),
    .io_async_mem_4_2(sink_io_async_mem_4_2),
    .io_async_mem_4_3(sink_io_async_mem_4_3),
    .io_async_mem_4_4(sink_io_async_mem_4_4),
    .io_async_mem_4_5(sink_io_async_mem_4_5),
    .io_async_mem_4_6(sink_io_async_mem_4_6),
    .io_async_mem_4_7(sink_io_async_mem_4_7),
    .io_async_mem_4_8(sink_io_async_mem_4_8),
    .io_async_mem_4_9(sink_io_async_mem_4_9),
    .io_async_mem_4_10(sink_io_async_mem_4_10),
    .io_async_mem_4_11(sink_io_async_mem_4_11),
    .io_async_mem_4_12(sink_io_async_mem_4_12),
    .io_async_mem_4_13(sink_io_async_mem_4_13),
    .io_async_mem_4_14(sink_io_async_mem_4_14),
    .io_async_mem_4_15(sink_io_async_mem_4_15),
    .io_async_mem_5_0(sink_io_async_mem_5_0),
    .io_async_mem_5_1(sink_io_async_mem_5_1),
    .io_async_mem_5_2(sink_io_async_mem_5_2),
    .io_async_mem_5_3(sink_io_async_mem_5_3),
    .io_async_mem_5_4(sink_io_async_mem_5_4),
    .io_async_mem_5_5(sink_io_async_mem_5_5),
    .io_async_mem_5_6(sink_io_async_mem_5_6),
    .io_async_mem_5_7(sink_io_async_mem_5_7),
    .io_async_mem_5_8(sink_io_async_mem_5_8),
    .io_async_mem_5_9(sink_io_async_mem_5_9),
    .io_async_mem_5_10(sink_io_async_mem_5_10),
    .io_async_mem_5_11(sink_io_async_mem_5_11),
    .io_async_mem_5_12(sink_io_async_mem_5_12),
    .io_async_mem_5_13(sink_io_async_mem_5_13),
    .io_async_mem_5_14(sink_io_async_mem_5_14),
    .io_async_mem_5_15(sink_io_async_mem_5_15),
    .io_async_mem_6_0(sink_io_async_mem_6_0),
    .io_async_mem_6_1(sink_io_async_mem_6_1),
    .io_async_mem_6_2(sink_io_async_mem_6_2),
    .io_async_mem_6_3(sink_io_async_mem_6_3),
    .io_async_mem_6_4(sink_io_async_mem_6_4),
    .io_async_mem_6_5(sink_io_async_mem_6_5),
    .io_async_mem_6_6(sink_io_async_mem_6_6),
    .io_async_mem_6_7(sink_io_async_mem_6_7),
    .io_async_mem_6_8(sink_io_async_mem_6_8),
    .io_async_mem_6_9(sink_io_async_mem_6_9),
    .io_async_mem_6_10(sink_io_async_mem_6_10),
    .io_async_mem_6_11(sink_io_async_mem_6_11),
    .io_async_mem_6_12(sink_io_async_mem_6_12),
    .io_async_mem_6_13(sink_io_async_mem_6_13),
    .io_async_mem_6_14(sink_io_async_mem_6_14),
    .io_async_mem_6_15(sink_io_async_mem_6_15),
    .io_async_mem_7_0(sink_io_async_mem_7_0),
    .io_async_mem_7_1(sink_io_async_mem_7_1),
    .io_async_mem_7_2(sink_io_async_mem_7_2),
    .io_async_mem_7_3(sink_io_async_mem_7_3),
    .io_async_mem_7_4(sink_io_async_mem_7_4),
    .io_async_mem_7_5(sink_io_async_mem_7_5),
    .io_async_mem_7_6(sink_io_async_mem_7_6),
    .io_async_mem_7_7(sink_io_async_mem_7_7),
    .io_async_mem_7_8(sink_io_async_mem_7_8),
    .io_async_mem_7_9(sink_io_async_mem_7_9),
    .io_async_mem_7_10(sink_io_async_mem_7_10),
    .io_async_mem_7_11(sink_io_async_mem_7_11),
    .io_async_mem_7_12(sink_io_async_mem_7_12),
    .io_async_mem_7_13(sink_io_async_mem_7_13),
    .io_async_mem_7_14(sink_io_async_mem_7_14),
    .io_async_mem_7_15(sink_io_async_mem_7_15),
    .io_async_ridx(sink_io_async_ridx),
    .io_async_widx(sink_io_async_widx),
    .io_async_safe_ridx_valid(sink_io_async_safe_ridx_valid),
    .io_async_safe_widx_valid(sink_io_async_safe_widx_valid),
    .io_async_safe_source_reset_n(sink_io_async_safe_source_reset_n),
    .io_async_safe_sink_reset_n(sink_io_async_safe_sink_reset_n)
  );
  assign io_enq_ready = source_io_enq_ready; // @[src/main/scala/util/AsyncQueue.scala 227:17]
  assign io_deq_valid = sink_io_deq_valid; // @[src/main/scala/util/AsyncQueue.scala 228:10]
  assign io_deq_bits_0 = sink_io_deq_bits_0; // @[src/main/scala/util/AsyncQueue.scala 228:10]
  assign io_deq_bits_1 = sink_io_deq_bits_1; // @[src/main/scala/util/AsyncQueue.scala 228:10]
  assign io_deq_bits_2 = sink_io_deq_bits_2; // @[src/main/scala/util/AsyncQueue.scala 228:10]
  assign io_deq_bits_3 = sink_io_deq_bits_3; // @[src/main/scala/util/AsyncQueue.scala 228:10]
  assign io_deq_bits_4 = sink_io_deq_bits_4; // @[src/main/scala/util/AsyncQueue.scala 228:10]
  assign io_deq_bits_5 = sink_io_deq_bits_5; // @[src/main/scala/util/AsyncQueue.scala 228:10]
  assign io_deq_bits_6 = sink_io_deq_bits_6; // @[src/main/scala/util/AsyncQueue.scala 228:10]
  assign io_deq_bits_7 = sink_io_deq_bits_7; // @[src/main/scala/util/AsyncQueue.scala 228:10]
  assign io_deq_bits_8 = sink_io_deq_bits_8; // @[src/main/scala/util/AsyncQueue.scala 228:10]
  assign io_deq_bits_9 = sink_io_deq_bits_9; // @[src/main/scala/util/AsyncQueue.scala 228:10]
  assign io_deq_bits_10 = sink_io_deq_bits_10; // @[src/main/scala/util/AsyncQueue.scala 228:10]
  assign io_deq_bits_11 = sink_io_deq_bits_11; // @[src/main/scala/util/AsyncQueue.scala 228:10]
  assign io_deq_bits_12 = sink_io_deq_bits_12; // @[src/main/scala/util/AsyncQueue.scala 228:10]
  assign io_deq_bits_13 = sink_io_deq_bits_13; // @[src/main/scala/util/AsyncQueue.scala 228:10]
  assign io_deq_bits_14 = sink_io_deq_bits_14; // @[src/main/scala/util/AsyncQueue.scala 228:10]
  assign io_deq_bits_15 = sink_io_deq_bits_15; // @[src/main/scala/util/AsyncQueue.scala 228:10]
  assign source_clock = io_enq_clock;
  assign source_reset = io_enq_reset;
  assign source_io_enq_valid = io_enq_valid; // @[src/main/scala/util/AsyncQueue.scala 227:17]
  assign source_io_enq_bits_0 = io_enq_bits_0; // @[src/main/scala/util/AsyncQueue.scala 227:17]
  assign source_io_enq_bits_1 = io_enq_bits_1; // @[src/main/scala/util/AsyncQueue.scala 227:17]
  assign source_io_enq_bits_2 = io_enq_bits_2; // @[src/main/scala/util/AsyncQueue.scala 227:17]
  assign source_io_enq_bits_3 = io_enq_bits_3; // @[src/main/scala/util/AsyncQueue.scala 227:17]
  assign source_io_enq_bits_4 = io_enq_bits_4; // @[src/main/scala/util/AsyncQueue.scala 227:17]
  assign source_io_enq_bits_5 = io_enq_bits_5; // @[src/main/scala/util/AsyncQueue.scala 227:17]
  assign source_io_enq_bits_6 = io_enq_bits_6; // @[src/main/scala/util/AsyncQueue.scala 227:17]
  assign source_io_enq_bits_7 = io_enq_bits_7; // @[src/main/scala/util/AsyncQueue.scala 227:17]
  assign source_io_enq_bits_8 = io_enq_bits_8; // @[src/main/scala/util/AsyncQueue.scala 227:17]
  assign source_io_enq_bits_9 = io_enq_bits_9; // @[src/main/scala/util/AsyncQueue.scala 227:17]
  assign source_io_enq_bits_10 = io_enq_bits_10; // @[src/main/scala/util/AsyncQueue.scala 227:17]
  assign source_io_enq_bits_11 = io_enq_bits_11; // @[src/main/scala/util/AsyncQueue.scala 227:17]
  assign source_io_enq_bits_12 = io_enq_bits_12; // @[src/main/scala/util/AsyncQueue.scala 227:17]
  assign source_io_enq_bits_13 = io_enq_bits_13; // @[src/main/scala/util/AsyncQueue.scala 227:17]
  assign source_io_enq_bits_14 = io_enq_bits_14; // @[src/main/scala/util/AsyncQueue.scala 227:17]
  assign source_io_enq_bits_15 = io_enq_bits_15; // @[src/main/scala/util/AsyncQueue.scala 227:17]
  assign source_io_async_ridx = sink_io_async_ridx; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign source_io_async_safe_ridx_valid = sink_io_async_safe_ridx_valid; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign source_io_async_safe_sink_reset_n = sink_io_async_safe_sink_reset_n; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_clock = io_deq_clock;
  assign sink_reset = io_deq_reset;
  assign sink_io_deq_ready = io_deq_ready; // @[src/main/scala/util/AsyncQueue.scala 228:10]
  assign sink_io_async_mem_0_0 = source_io_async_mem_0_0; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_0_1 = source_io_async_mem_0_1; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_0_2 = source_io_async_mem_0_2; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_0_3 = source_io_async_mem_0_3; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_0_4 = source_io_async_mem_0_4; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_0_5 = source_io_async_mem_0_5; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_0_6 = source_io_async_mem_0_6; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_0_7 = source_io_async_mem_0_7; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_0_8 = source_io_async_mem_0_8; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_0_9 = source_io_async_mem_0_9; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_0_10 = source_io_async_mem_0_10; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_0_11 = source_io_async_mem_0_11; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_0_12 = source_io_async_mem_0_12; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_0_13 = source_io_async_mem_0_13; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_0_14 = source_io_async_mem_0_14; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_0_15 = source_io_async_mem_0_15; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_1_0 = source_io_async_mem_1_0; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_1_1 = source_io_async_mem_1_1; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_1_2 = source_io_async_mem_1_2; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_1_3 = source_io_async_mem_1_3; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_1_4 = source_io_async_mem_1_4; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_1_5 = source_io_async_mem_1_5; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_1_6 = source_io_async_mem_1_6; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_1_7 = source_io_async_mem_1_7; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_1_8 = source_io_async_mem_1_8; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_1_9 = source_io_async_mem_1_9; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_1_10 = source_io_async_mem_1_10; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_1_11 = source_io_async_mem_1_11; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_1_12 = source_io_async_mem_1_12; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_1_13 = source_io_async_mem_1_13; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_1_14 = source_io_async_mem_1_14; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_1_15 = source_io_async_mem_1_15; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_2_0 = source_io_async_mem_2_0; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_2_1 = source_io_async_mem_2_1; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_2_2 = source_io_async_mem_2_2; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_2_3 = source_io_async_mem_2_3; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_2_4 = source_io_async_mem_2_4; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_2_5 = source_io_async_mem_2_5; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_2_6 = source_io_async_mem_2_6; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_2_7 = source_io_async_mem_2_7; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_2_8 = source_io_async_mem_2_8; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_2_9 = source_io_async_mem_2_9; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_2_10 = source_io_async_mem_2_10; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_2_11 = source_io_async_mem_2_11; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_2_12 = source_io_async_mem_2_12; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_2_13 = source_io_async_mem_2_13; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_2_14 = source_io_async_mem_2_14; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_2_15 = source_io_async_mem_2_15; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_3_0 = source_io_async_mem_3_0; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_3_1 = source_io_async_mem_3_1; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_3_2 = source_io_async_mem_3_2; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_3_3 = source_io_async_mem_3_3; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_3_4 = source_io_async_mem_3_4; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_3_5 = source_io_async_mem_3_5; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_3_6 = source_io_async_mem_3_6; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_3_7 = source_io_async_mem_3_7; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_3_8 = source_io_async_mem_3_8; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_3_9 = source_io_async_mem_3_9; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_3_10 = source_io_async_mem_3_10; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_3_11 = source_io_async_mem_3_11; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_3_12 = source_io_async_mem_3_12; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_3_13 = source_io_async_mem_3_13; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_3_14 = source_io_async_mem_3_14; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_3_15 = source_io_async_mem_3_15; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_4_0 = source_io_async_mem_4_0; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_4_1 = source_io_async_mem_4_1; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_4_2 = source_io_async_mem_4_2; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_4_3 = source_io_async_mem_4_3; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_4_4 = source_io_async_mem_4_4; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_4_5 = source_io_async_mem_4_5; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_4_6 = source_io_async_mem_4_6; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_4_7 = source_io_async_mem_4_7; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_4_8 = source_io_async_mem_4_8; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_4_9 = source_io_async_mem_4_9; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_4_10 = source_io_async_mem_4_10; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_4_11 = source_io_async_mem_4_11; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_4_12 = source_io_async_mem_4_12; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_4_13 = source_io_async_mem_4_13; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_4_14 = source_io_async_mem_4_14; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_4_15 = source_io_async_mem_4_15; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_5_0 = source_io_async_mem_5_0; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_5_1 = source_io_async_mem_5_1; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_5_2 = source_io_async_mem_5_2; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_5_3 = source_io_async_mem_5_3; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_5_4 = source_io_async_mem_5_4; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_5_5 = source_io_async_mem_5_5; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_5_6 = source_io_async_mem_5_6; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_5_7 = source_io_async_mem_5_7; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_5_8 = source_io_async_mem_5_8; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_5_9 = source_io_async_mem_5_9; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_5_10 = source_io_async_mem_5_10; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_5_11 = source_io_async_mem_5_11; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_5_12 = source_io_async_mem_5_12; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_5_13 = source_io_async_mem_5_13; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_5_14 = source_io_async_mem_5_14; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_5_15 = source_io_async_mem_5_15; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_6_0 = source_io_async_mem_6_0; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_6_1 = source_io_async_mem_6_1; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_6_2 = source_io_async_mem_6_2; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_6_3 = source_io_async_mem_6_3; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_6_4 = source_io_async_mem_6_4; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_6_5 = source_io_async_mem_6_5; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_6_6 = source_io_async_mem_6_6; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_6_7 = source_io_async_mem_6_7; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_6_8 = source_io_async_mem_6_8; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_6_9 = source_io_async_mem_6_9; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_6_10 = source_io_async_mem_6_10; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_6_11 = source_io_async_mem_6_11; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_6_12 = source_io_async_mem_6_12; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_6_13 = source_io_async_mem_6_13; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_6_14 = source_io_async_mem_6_14; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_6_15 = source_io_async_mem_6_15; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_7_0 = source_io_async_mem_7_0; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_7_1 = source_io_async_mem_7_1; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_7_2 = source_io_async_mem_7_2; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_7_3 = source_io_async_mem_7_3; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_7_4 = source_io_async_mem_7_4; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_7_5 = source_io_async_mem_7_5; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_7_6 = source_io_async_mem_7_6; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_7_7 = source_io_async_mem_7_7; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_7_8 = source_io_async_mem_7_8; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_7_9 = source_io_async_mem_7_9; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_7_10 = source_io_async_mem_7_10; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_7_11 = source_io_async_mem_7_11; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_7_12 = source_io_async_mem_7_12; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_7_13 = source_io_async_mem_7_13; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_7_14 = source_io_async_mem_7_14; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_7_15 = source_io_async_mem_7_15; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_widx = source_io_async_widx; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_safe_widx_valid = source_io_async_safe_widx_valid; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_safe_source_reset_n = source_io_async_safe_source_reset_n; // @[src/main/scala/util/AsyncQueue.scala 229:17]
endmodule
module AsyncQueue_1(
  input         io_enq_clock, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  input         io_enq_reset, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  output        io_enq_ready, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  input         io_enq_valid, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  input  [15:0] io_enq_bits_0, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  input  [15:0] io_enq_bits_1, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  input  [15:0] io_enq_bits_2, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  input  [15:0] io_enq_bits_3, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  input  [15:0] io_enq_bits_4, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  input  [15:0] io_enq_bits_5, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  input  [15:0] io_enq_bits_6, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  input  [15:0] io_enq_bits_7, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  input  [15:0] io_enq_bits_8, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  input  [15:0] io_enq_bits_9, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  input  [15:0] io_enq_bits_10, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  input  [15:0] io_enq_bits_11, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  input  [15:0] io_enq_bits_12, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  input  [15:0] io_enq_bits_13, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  input  [15:0] io_enq_bits_14, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  input  [15:0] io_enq_bits_15, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  input         io_deq_clock, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  input         io_deq_reset, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  output        io_deq_valid, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  output [15:0] io_deq_bits_0, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  output [15:0] io_deq_bits_1, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  output [15:0] io_deq_bits_2, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  output [15:0] io_deq_bits_3, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  output [15:0] io_deq_bits_4, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  output [15:0] io_deq_bits_5, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  output [15:0] io_deq_bits_6, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  output [15:0] io_deq_bits_7, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  output [15:0] io_deq_bits_8, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  output [15:0] io_deq_bits_9, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  output [15:0] io_deq_bits_10, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  output [15:0] io_deq_bits_11, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  output [15:0] io_deq_bits_12, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  output [15:0] io_deq_bits_13, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  output [15:0] io_deq_bits_14, // @[src/main/scala/util/AsyncQueue.scala 223:14]
  output [15:0] io_deq_bits_15 // @[src/main/scala/util/AsyncQueue.scala 223:14]
);
  wire  source_clock; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire  source_reset; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire  source_io_enq_ready; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire  source_io_enq_valid; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_enq_bits_0; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_enq_bits_1; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_enq_bits_2; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_enq_bits_3; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_enq_bits_4; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_enq_bits_5; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_enq_bits_6; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_enq_bits_7; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_enq_bits_8; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_enq_bits_9; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_enq_bits_10; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_enq_bits_11; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_enq_bits_12; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_enq_bits_13; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_enq_bits_14; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_enq_bits_15; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_0_0; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_0_1; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_0_2; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_0_3; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_0_4; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_0_5; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_0_6; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_0_7; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_0_8; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_0_9; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_0_10; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_0_11; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_0_12; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_0_13; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_0_14; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_0_15; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_1_0; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_1_1; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_1_2; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_1_3; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_1_4; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_1_5; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_1_6; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_1_7; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_1_8; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_1_9; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_1_10; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_1_11; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_1_12; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_1_13; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_1_14; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_1_15; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_2_0; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_2_1; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_2_2; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_2_3; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_2_4; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_2_5; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_2_6; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_2_7; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_2_8; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_2_9; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_2_10; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_2_11; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_2_12; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_2_13; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_2_14; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_2_15; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_3_0; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_3_1; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_3_2; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_3_3; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_3_4; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_3_5; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_3_6; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_3_7; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_3_8; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_3_9; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_3_10; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_3_11; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_3_12; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_3_13; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_3_14; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_3_15; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_4_0; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_4_1; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_4_2; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_4_3; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_4_4; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_4_5; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_4_6; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_4_7; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_4_8; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_4_9; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_4_10; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_4_11; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_4_12; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_4_13; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_4_14; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_4_15; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_5_0; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_5_1; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_5_2; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_5_3; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_5_4; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_5_5; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_5_6; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_5_7; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_5_8; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_5_9; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_5_10; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_5_11; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_5_12; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_5_13; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_5_14; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_5_15; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_6_0; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_6_1; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_6_2; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_6_3; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_6_4; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_6_5; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_6_6; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_6_7; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_6_8; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_6_9; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_6_10; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_6_11; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_6_12; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_6_13; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_6_14; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_6_15; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_7_0; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_7_1; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_7_2; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_7_3; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_7_4; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_7_5; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_7_6; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_7_7; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_7_8; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_7_9; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_7_10; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_7_11; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_7_12; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_7_13; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_7_14; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [15:0] source_io_async_mem_7_15; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [3:0] source_io_async_ridx; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire [3:0] source_io_async_widx; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire  source_io_async_safe_ridx_valid; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire  source_io_async_safe_widx_valid; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire  source_io_async_safe_source_reset_n; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire  source_io_async_safe_sink_reset_n; // @[src/main/scala/util/AsyncQueue.scala 224:70]
  wire  sink_clock; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire  sink_reset; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire  sink_io_deq_ready; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire  sink_io_deq_valid; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_deq_bits_0; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_deq_bits_1; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_deq_bits_2; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_deq_bits_3; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_deq_bits_4; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_deq_bits_5; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_deq_bits_6; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_deq_bits_7; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_deq_bits_8; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_deq_bits_9; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_deq_bits_10; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_deq_bits_11; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_deq_bits_12; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_deq_bits_13; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_deq_bits_14; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_deq_bits_15; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_0_0; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_0_1; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_0_2; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_0_3; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_0_4; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_0_5; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_0_6; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_0_7; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_0_8; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_0_9; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_0_10; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_0_11; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_0_12; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_0_13; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_0_14; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_0_15; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_1_0; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_1_1; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_1_2; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_1_3; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_1_4; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_1_5; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_1_6; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_1_7; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_1_8; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_1_9; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_1_10; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_1_11; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_1_12; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_1_13; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_1_14; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_1_15; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_2_0; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_2_1; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_2_2; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_2_3; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_2_4; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_2_5; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_2_6; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_2_7; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_2_8; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_2_9; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_2_10; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_2_11; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_2_12; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_2_13; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_2_14; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_2_15; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_3_0; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_3_1; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_3_2; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_3_3; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_3_4; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_3_5; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_3_6; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_3_7; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_3_8; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_3_9; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_3_10; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_3_11; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_3_12; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_3_13; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_3_14; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_3_15; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_4_0; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_4_1; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_4_2; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_4_3; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_4_4; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_4_5; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_4_6; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_4_7; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_4_8; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_4_9; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_4_10; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_4_11; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_4_12; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_4_13; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_4_14; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_4_15; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_5_0; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_5_1; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_5_2; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_5_3; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_5_4; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_5_5; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_5_6; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_5_7; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_5_8; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_5_9; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_5_10; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_5_11; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_5_12; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_5_13; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_5_14; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_5_15; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_6_0; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_6_1; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_6_2; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_6_3; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_6_4; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_6_5; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_6_6; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_6_7; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_6_8; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_6_9; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_6_10; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_6_11; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_6_12; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_6_13; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_6_14; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_6_15; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_7_0; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_7_1; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_7_2; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_7_3; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_7_4; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_7_5; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_7_6; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_7_7; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_7_8; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_7_9; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_7_10; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_7_11; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_7_12; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_7_13; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_7_14; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [15:0] sink_io_async_mem_7_15; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [3:0] sink_io_async_ridx; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire [3:0] sink_io_async_widx; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire  sink_io_async_safe_ridx_valid; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire  sink_io_async_safe_widx_valid; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire  sink_io_async_safe_source_reset_n; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  wire  sink_io_async_safe_sink_reset_n; // @[src/main/scala/util/AsyncQueue.scala 225:70]
  AsyncQueueSource source ( // @[src/main/scala/util/AsyncQueue.scala 224:70]
    .clock(source_clock),
    .reset(source_reset),
    .io_enq_ready(source_io_enq_ready),
    .io_enq_valid(source_io_enq_valid),
    .io_enq_bits_0(source_io_enq_bits_0),
    .io_enq_bits_1(source_io_enq_bits_1),
    .io_enq_bits_2(source_io_enq_bits_2),
    .io_enq_bits_3(source_io_enq_bits_3),
    .io_enq_bits_4(source_io_enq_bits_4),
    .io_enq_bits_5(source_io_enq_bits_5),
    .io_enq_bits_6(source_io_enq_bits_6),
    .io_enq_bits_7(source_io_enq_bits_7),
    .io_enq_bits_8(source_io_enq_bits_8),
    .io_enq_bits_9(source_io_enq_bits_9),
    .io_enq_bits_10(source_io_enq_bits_10),
    .io_enq_bits_11(source_io_enq_bits_11),
    .io_enq_bits_12(source_io_enq_bits_12),
    .io_enq_bits_13(source_io_enq_bits_13),
    .io_enq_bits_14(source_io_enq_bits_14),
    .io_enq_bits_15(source_io_enq_bits_15),
    .io_async_mem_0_0(source_io_async_mem_0_0),
    .io_async_mem_0_1(source_io_async_mem_0_1),
    .io_async_mem_0_2(source_io_async_mem_0_2),
    .io_async_mem_0_3(source_io_async_mem_0_3),
    .io_async_mem_0_4(source_io_async_mem_0_4),
    .io_async_mem_0_5(source_io_async_mem_0_5),
    .io_async_mem_0_6(source_io_async_mem_0_6),
    .io_async_mem_0_7(source_io_async_mem_0_7),
    .io_async_mem_0_8(source_io_async_mem_0_8),
    .io_async_mem_0_9(source_io_async_mem_0_9),
    .io_async_mem_0_10(source_io_async_mem_0_10),
    .io_async_mem_0_11(source_io_async_mem_0_11),
    .io_async_mem_0_12(source_io_async_mem_0_12),
    .io_async_mem_0_13(source_io_async_mem_0_13),
    .io_async_mem_0_14(source_io_async_mem_0_14),
    .io_async_mem_0_15(source_io_async_mem_0_15),
    .io_async_mem_1_0(source_io_async_mem_1_0),
    .io_async_mem_1_1(source_io_async_mem_1_1),
    .io_async_mem_1_2(source_io_async_mem_1_2),
    .io_async_mem_1_3(source_io_async_mem_1_3),
    .io_async_mem_1_4(source_io_async_mem_1_4),
    .io_async_mem_1_5(source_io_async_mem_1_5),
    .io_async_mem_1_6(source_io_async_mem_1_6),
    .io_async_mem_1_7(source_io_async_mem_1_7),
    .io_async_mem_1_8(source_io_async_mem_1_8),
    .io_async_mem_1_9(source_io_async_mem_1_9),
    .io_async_mem_1_10(source_io_async_mem_1_10),
    .io_async_mem_1_11(source_io_async_mem_1_11),
    .io_async_mem_1_12(source_io_async_mem_1_12),
    .io_async_mem_1_13(source_io_async_mem_1_13),
    .io_async_mem_1_14(source_io_async_mem_1_14),
    .io_async_mem_1_15(source_io_async_mem_1_15),
    .io_async_mem_2_0(source_io_async_mem_2_0),
    .io_async_mem_2_1(source_io_async_mem_2_1),
    .io_async_mem_2_2(source_io_async_mem_2_2),
    .io_async_mem_2_3(source_io_async_mem_2_3),
    .io_async_mem_2_4(source_io_async_mem_2_4),
    .io_async_mem_2_5(source_io_async_mem_2_5),
    .io_async_mem_2_6(source_io_async_mem_2_6),
    .io_async_mem_2_7(source_io_async_mem_2_7),
    .io_async_mem_2_8(source_io_async_mem_2_8),
    .io_async_mem_2_9(source_io_async_mem_2_9),
    .io_async_mem_2_10(source_io_async_mem_2_10),
    .io_async_mem_2_11(source_io_async_mem_2_11),
    .io_async_mem_2_12(source_io_async_mem_2_12),
    .io_async_mem_2_13(source_io_async_mem_2_13),
    .io_async_mem_2_14(source_io_async_mem_2_14),
    .io_async_mem_2_15(source_io_async_mem_2_15),
    .io_async_mem_3_0(source_io_async_mem_3_0),
    .io_async_mem_3_1(source_io_async_mem_3_1),
    .io_async_mem_3_2(source_io_async_mem_3_2),
    .io_async_mem_3_3(source_io_async_mem_3_3),
    .io_async_mem_3_4(source_io_async_mem_3_4),
    .io_async_mem_3_5(source_io_async_mem_3_5),
    .io_async_mem_3_6(source_io_async_mem_3_6),
    .io_async_mem_3_7(source_io_async_mem_3_7),
    .io_async_mem_3_8(source_io_async_mem_3_8),
    .io_async_mem_3_9(source_io_async_mem_3_9),
    .io_async_mem_3_10(source_io_async_mem_3_10),
    .io_async_mem_3_11(source_io_async_mem_3_11),
    .io_async_mem_3_12(source_io_async_mem_3_12),
    .io_async_mem_3_13(source_io_async_mem_3_13),
    .io_async_mem_3_14(source_io_async_mem_3_14),
    .io_async_mem_3_15(source_io_async_mem_3_15),
    .io_async_mem_4_0(source_io_async_mem_4_0),
    .io_async_mem_4_1(source_io_async_mem_4_1),
    .io_async_mem_4_2(source_io_async_mem_4_2),
    .io_async_mem_4_3(source_io_async_mem_4_3),
    .io_async_mem_4_4(source_io_async_mem_4_4),
    .io_async_mem_4_5(source_io_async_mem_4_5),
    .io_async_mem_4_6(source_io_async_mem_4_6),
    .io_async_mem_4_7(source_io_async_mem_4_7),
    .io_async_mem_4_8(source_io_async_mem_4_8),
    .io_async_mem_4_9(source_io_async_mem_4_9),
    .io_async_mem_4_10(source_io_async_mem_4_10),
    .io_async_mem_4_11(source_io_async_mem_4_11),
    .io_async_mem_4_12(source_io_async_mem_4_12),
    .io_async_mem_4_13(source_io_async_mem_4_13),
    .io_async_mem_4_14(source_io_async_mem_4_14),
    .io_async_mem_4_15(source_io_async_mem_4_15),
    .io_async_mem_5_0(source_io_async_mem_5_0),
    .io_async_mem_5_1(source_io_async_mem_5_1),
    .io_async_mem_5_2(source_io_async_mem_5_2),
    .io_async_mem_5_3(source_io_async_mem_5_3),
    .io_async_mem_5_4(source_io_async_mem_5_4),
    .io_async_mem_5_5(source_io_async_mem_5_5),
    .io_async_mem_5_6(source_io_async_mem_5_6),
    .io_async_mem_5_7(source_io_async_mem_5_7),
    .io_async_mem_5_8(source_io_async_mem_5_8),
    .io_async_mem_5_9(source_io_async_mem_5_9),
    .io_async_mem_5_10(source_io_async_mem_5_10),
    .io_async_mem_5_11(source_io_async_mem_5_11),
    .io_async_mem_5_12(source_io_async_mem_5_12),
    .io_async_mem_5_13(source_io_async_mem_5_13),
    .io_async_mem_5_14(source_io_async_mem_5_14),
    .io_async_mem_5_15(source_io_async_mem_5_15),
    .io_async_mem_6_0(source_io_async_mem_6_0),
    .io_async_mem_6_1(source_io_async_mem_6_1),
    .io_async_mem_6_2(source_io_async_mem_6_2),
    .io_async_mem_6_3(source_io_async_mem_6_3),
    .io_async_mem_6_4(source_io_async_mem_6_4),
    .io_async_mem_6_5(source_io_async_mem_6_5),
    .io_async_mem_6_6(source_io_async_mem_6_6),
    .io_async_mem_6_7(source_io_async_mem_6_7),
    .io_async_mem_6_8(source_io_async_mem_6_8),
    .io_async_mem_6_9(source_io_async_mem_6_9),
    .io_async_mem_6_10(source_io_async_mem_6_10),
    .io_async_mem_6_11(source_io_async_mem_6_11),
    .io_async_mem_6_12(source_io_async_mem_6_12),
    .io_async_mem_6_13(source_io_async_mem_6_13),
    .io_async_mem_6_14(source_io_async_mem_6_14),
    .io_async_mem_6_15(source_io_async_mem_6_15),
    .io_async_mem_7_0(source_io_async_mem_7_0),
    .io_async_mem_7_1(source_io_async_mem_7_1),
    .io_async_mem_7_2(source_io_async_mem_7_2),
    .io_async_mem_7_3(source_io_async_mem_7_3),
    .io_async_mem_7_4(source_io_async_mem_7_4),
    .io_async_mem_7_5(source_io_async_mem_7_5),
    .io_async_mem_7_6(source_io_async_mem_7_6),
    .io_async_mem_7_7(source_io_async_mem_7_7),
    .io_async_mem_7_8(source_io_async_mem_7_8),
    .io_async_mem_7_9(source_io_async_mem_7_9),
    .io_async_mem_7_10(source_io_async_mem_7_10),
    .io_async_mem_7_11(source_io_async_mem_7_11),
    .io_async_mem_7_12(source_io_async_mem_7_12),
    .io_async_mem_7_13(source_io_async_mem_7_13),
    .io_async_mem_7_14(source_io_async_mem_7_14),
    .io_async_mem_7_15(source_io_async_mem_7_15),
    .io_async_ridx(source_io_async_ridx),
    .io_async_widx(source_io_async_widx),
    .io_async_safe_ridx_valid(source_io_async_safe_ridx_valid),
    .io_async_safe_widx_valid(source_io_async_safe_widx_valid),
    .io_async_safe_source_reset_n(source_io_async_safe_source_reset_n),
    .io_async_safe_sink_reset_n(source_io_async_safe_sink_reset_n)
  );
  AsyncQueueSink sink ( // @[src/main/scala/util/AsyncQueue.scala 225:70]
    .clock(sink_clock),
    .reset(sink_reset),
    .io_deq_ready(sink_io_deq_ready),
    .io_deq_valid(sink_io_deq_valid),
    .io_deq_bits_0(sink_io_deq_bits_0),
    .io_deq_bits_1(sink_io_deq_bits_1),
    .io_deq_bits_2(sink_io_deq_bits_2),
    .io_deq_bits_3(sink_io_deq_bits_3),
    .io_deq_bits_4(sink_io_deq_bits_4),
    .io_deq_bits_5(sink_io_deq_bits_5),
    .io_deq_bits_6(sink_io_deq_bits_6),
    .io_deq_bits_7(sink_io_deq_bits_7),
    .io_deq_bits_8(sink_io_deq_bits_8),
    .io_deq_bits_9(sink_io_deq_bits_9),
    .io_deq_bits_10(sink_io_deq_bits_10),
    .io_deq_bits_11(sink_io_deq_bits_11),
    .io_deq_bits_12(sink_io_deq_bits_12),
    .io_deq_bits_13(sink_io_deq_bits_13),
    .io_deq_bits_14(sink_io_deq_bits_14),
    .io_deq_bits_15(sink_io_deq_bits_15),
    .io_async_mem_0_0(sink_io_async_mem_0_0),
    .io_async_mem_0_1(sink_io_async_mem_0_1),
    .io_async_mem_0_2(sink_io_async_mem_0_2),
    .io_async_mem_0_3(sink_io_async_mem_0_3),
    .io_async_mem_0_4(sink_io_async_mem_0_4),
    .io_async_mem_0_5(sink_io_async_mem_0_5),
    .io_async_mem_0_6(sink_io_async_mem_0_6),
    .io_async_mem_0_7(sink_io_async_mem_0_7),
    .io_async_mem_0_8(sink_io_async_mem_0_8),
    .io_async_mem_0_9(sink_io_async_mem_0_9),
    .io_async_mem_0_10(sink_io_async_mem_0_10),
    .io_async_mem_0_11(sink_io_async_mem_0_11),
    .io_async_mem_0_12(sink_io_async_mem_0_12),
    .io_async_mem_0_13(sink_io_async_mem_0_13),
    .io_async_mem_0_14(sink_io_async_mem_0_14),
    .io_async_mem_0_15(sink_io_async_mem_0_15),
    .io_async_mem_1_0(sink_io_async_mem_1_0),
    .io_async_mem_1_1(sink_io_async_mem_1_1),
    .io_async_mem_1_2(sink_io_async_mem_1_2),
    .io_async_mem_1_3(sink_io_async_mem_1_3),
    .io_async_mem_1_4(sink_io_async_mem_1_4),
    .io_async_mem_1_5(sink_io_async_mem_1_5),
    .io_async_mem_1_6(sink_io_async_mem_1_6),
    .io_async_mem_1_7(sink_io_async_mem_1_7),
    .io_async_mem_1_8(sink_io_async_mem_1_8),
    .io_async_mem_1_9(sink_io_async_mem_1_9),
    .io_async_mem_1_10(sink_io_async_mem_1_10),
    .io_async_mem_1_11(sink_io_async_mem_1_11),
    .io_async_mem_1_12(sink_io_async_mem_1_12),
    .io_async_mem_1_13(sink_io_async_mem_1_13),
    .io_async_mem_1_14(sink_io_async_mem_1_14),
    .io_async_mem_1_15(sink_io_async_mem_1_15),
    .io_async_mem_2_0(sink_io_async_mem_2_0),
    .io_async_mem_2_1(sink_io_async_mem_2_1),
    .io_async_mem_2_2(sink_io_async_mem_2_2),
    .io_async_mem_2_3(sink_io_async_mem_2_3),
    .io_async_mem_2_4(sink_io_async_mem_2_4),
    .io_async_mem_2_5(sink_io_async_mem_2_5),
    .io_async_mem_2_6(sink_io_async_mem_2_6),
    .io_async_mem_2_7(sink_io_async_mem_2_7),
    .io_async_mem_2_8(sink_io_async_mem_2_8),
    .io_async_mem_2_9(sink_io_async_mem_2_9),
    .io_async_mem_2_10(sink_io_async_mem_2_10),
    .io_async_mem_2_11(sink_io_async_mem_2_11),
    .io_async_mem_2_12(sink_io_async_mem_2_12),
    .io_async_mem_2_13(sink_io_async_mem_2_13),
    .io_async_mem_2_14(sink_io_async_mem_2_14),
    .io_async_mem_2_15(sink_io_async_mem_2_15),
    .io_async_mem_3_0(sink_io_async_mem_3_0),
    .io_async_mem_3_1(sink_io_async_mem_3_1),
    .io_async_mem_3_2(sink_io_async_mem_3_2),
    .io_async_mem_3_3(sink_io_async_mem_3_3),
    .io_async_mem_3_4(sink_io_async_mem_3_4),
    .io_async_mem_3_5(sink_io_async_mem_3_5),
    .io_async_mem_3_6(sink_io_async_mem_3_6),
    .io_async_mem_3_7(sink_io_async_mem_3_7),
    .io_async_mem_3_8(sink_io_async_mem_3_8),
    .io_async_mem_3_9(sink_io_async_mem_3_9),
    .io_async_mem_3_10(sink_io_async_mem_3_10),
    .io_async_mem_3_11(sink_io_async_mem_3_11),
    .io_async_mem_3_12(sink_io_async_mem_3_12),
    .io_async_mem_3_13(sink_io_async_mem_3_13),
    .io_async_mem_3_14(sink_io_async_mem_3_14),
    .io_async_mem_3_15(sink_io_async_mem_3_15),
    .io_async_mem_4_0(sink_io_async_mem_4_0),
    .io_async_mem_4_1(sink_io_async_mem_4_1),
    .io_async_mem_4_2(sink_io_async_mem_4_2),
    .io_async_mem_4_3(sink_io_async_mem_4_3),
    .io_async_mem_4_4(sink_io_async_mem_4_4),
    .io_async_mem_4_5(sink_io_async_mem_4_5),
    .io_async_mem_4_6(sink_io_async_mem_4_6),
    .io_async_mem_4_7(sink_io_async_mem_4_7),
    .io_async_mem_4_8(sink_io_async_mem_4_8),
    .io_async_mem_4_9(sink_io_async_mem_4_9),
    .io_async_mem_4_10(sink_io_async_mem_4_10),
    .io_async_mem_4_11(sink_io_async_mem_4_11),
    .io_async_mem_4_12(sink_io_async_mem_4_12),
    .io_async_mem_4_13(sink_io_async_mem_4_13),
    .io_async_mem_4_14(sink_io_async_mem_4_14),
    .io_async_mem_4_15(sink_io_async_mem_4_15),
    .io_async_mem_5_0(sink_io_async_mem_5_0),
    .io_async_mem_5_1(sink_io_async_mem_5_1),
    .io_async_mem_5_2(sink_io_async_mem_5_2),
    .io_async_mem_5_3(sink_io_async_mem_5_3),
    .io_async_mem_5_4(sink_io_async_mem_5_4),
    .io_async_mem_5_5(sink_io_async_mem_5_5),
    .io_async_mem_5_6(sink_io_async_mem_5_6),
    .io_async_mem_5_7(sink_io_async_mem_5_7),
    .io_async_mem_5_8(sink_io_async_mem_5_8),
    .io_async_mem_5_9(sink_io_async_mem_5_9),
    .io_async_mem_5_10(sink_io_async_mem_5_10),
    .io_async_mem_5_11(sink_io_async_mem_5_11),
    .io_async_mem_5_12(sink_io_async_mem_5_12),
    .io_async_mem_5_13(sink_io_async_mem_5_13),
    .io_async_mem_5_14(sink_io_async_mem_5_14),
    .io_async_mem_5_15(sink_io_async_mem_5_15),
    .io_async_mem_6_0(sink_io_async_mem_6_0),
    .io_async_mem_6_1(sink_io_async_mem_6_1),
    .io_async_mem_6_2(sink_io_async_mem_6_2),
    .io_async_mem_6_3(sink_io_async_mem_6_3),
    .io_async_mem_6_4(sink_io_async_mem_6_4),
    .io_async_mem_6_5(sink_io_async_mem_6_5),
    .io_async_mem_6_6(sink_io_async_mem_6_6),
    .io_async_mem_6_7(sink_io_async_mem_6_7),
    .io_async_mem_6_8(sink_io_async_mem_6_8),
    .io_async_mem_6_9(sink_io_async_mem_6_9),
    .io_async_mem_6_10(sink_io_async_mem_6_10),
    .io_async_mem_6_11(sink_io_async_mem_6_11),
    .io_async_mem_6_12(sink_io_async_mem_6_12),
    .io_async_mem_6_13(sink_io_async_mem_6_13),
    .io_async_mem_6_14(sink_io_async_mem_6_14),
    .io_async_mem_6_15(sink_io_async_mem_6_15),
    .io_async_mem_7_0(sink_io_async_mem_7_0),
    .io_async_mem_7_1(sink_io_async_mem_7_1),
    .io_async_mem_7_2(sink_io_async_mem_7_2),
    .io_async_mem_7_3(sink_io_async_mem_7_3),
    .io_async_mem_7_4(sink_io_async_mem_7_4),
    .io_async_mem_7_5(sink_io_async_mem_7_5),
    .io_async_mem_7_6(sink_io_async_mem_7_6),
    .io_async_mem_7_7(sink_io_async_mem_7_7),
    .io_async_mem_7_8(sink_io_async_mem_7_8),
    .io_async_mem_7_9(sink_io_async_mem_7_9),
    .io_async_mem_7_10(sink_io_async_mem_7_10),
    .io_async_mem_7_11(sink_io_async_mem_7_11),
    .io_async_mem_7_12(sink_io_async_mem_7_12),
    .io_async_mem_7_13(sink_io_async_mem_7_13),
    .io_async_mem_7_14(sink_io_async_mem_7_14),
    .io_async_mem_7_15(sink_io_async_mem_7_15),
    .io_async_ridx(sink_io_async_ridx),
    .io_async_widx(sink_io_async_widx),
    .io_async_safe_ridx_valid(sink_io_async_safe_ridx_valid),
    .io_async_safe_widx_valid(sink_io_async_safe_widx_valid),
    .io_async_safe_source_reset_n(sink_io_async_safe_source_reset_n),
    .io_async_safe_sink_reset_n(sink_io_async_safe_sink_reset_n)
  );
  assign io_enq_ready = source_io_enq_ready; // @[src/main/scala/util/AsyncQueue.scala 227:17]
  assign io_deq_valid = sink_io_deq_valid; // @[src/main/scala/util/AsyncQueue.scala 228:10]
  assign io_deq_bits_0 = sink_io_deq_bits_0; // @[src/main/scala/util/AsyncQueue.scala 228:10]
  assign io_deq_bits_1 = sink_io_deq_bits_1; // @[src/main/scala/util/AsyncQueue.scala 228:10]
  assign io_deq_bits_2 = sink_io_deq_bits_2; // @[src/main/scala/util/AsyncQueue.scala 228:10]
  assign io_deq_bits_3 = sink_io_deq_bits_3; // @[src/main/scala/util/AsyncQueue.scala 228:10]
  assign io_deq_bits_4 = sink_io_deq_bits_4; // @[src/main/scala/util/AsyncQueue.scala 228:10]
  assign io_deq_bits_5 = sink_io_deq_bits_5; // @[src/main/scala/util/AsyncQueue.scala 228:10]
  assign io_deq_bits_6 = sink_io_deq_bits_6; // @[src/main/scala/util/AsyncQueue.scala 228:10]
  assign io_deq_bits_7 = sink_io_deq_bits_7; // @[src/main/scala/util/AsyncQueue.scala 228:10]
  assign io_deq_bits_8 = sink_io_deq_bits_8; // @[src/main/scala/util/AsyncQueue.scala 228:10]
  assign io_deq_bits_9 = sink_io_deq_bits_9; // @[src/main/scala/util/AsyncQueue.scala 228:10]
  assign io_deq_bits_10 = sink_io_deq_bits_10; // @[src/main/scala/util/AsyncQueue.scala 228:10]
  assign io_deq_bits_11 = sink_io_deq_bits_11; // @[src/main/scala/util/AsyncQueue.scala 228:10]
  assign io_deq_bits_12 = sink_io_deq_bits_12; // @[src/main/scala/util/AsyncQueue.scala 228:10]
  assign io_deq_bits_13 = sink_io_deq_bits_13; // @[src/main/scala/util/AsyncQueue.scala 228:10]
  assign io_deq_bits_14 = sink_io_deq_bits_14; // @[src/main/scala/util/AsyncQueue.scala 228:10]
  assign io_deq_bits_15 = sink_io_deq_bits_15; // @[src/main/scala/util/AsyncQueue.scala 228:10]
  assign source_clock = io_enq_clock;
  assign source_reset = io_enq_reset;
  assign source_io_enq_valid = io_enq_valid; // @[src/main/scala/util/AsyncQueue.scala 227:17]
  assign source_io_enq_bits_0 = io_enq_bits_0; // @[src/main/scala/util/AsyncQueue.scala 227:17]
  assign source_io_enq_bits_1 = io_enq_bits_1; // @[src/main/scala/util/AsyncQueue.scala 227:17]
  assign source_io_enq_bits_2 = io_enq_bits_2; // @[src/main/scala/util/AsyncQueue.scala 227:17]
  assign source_io_enq_bits_3 = io_enq_bits_3; // @[src/main/scala/util/AsyncQueue.scala 227:17]
  assign source_io_enq_bits_4 = io_enq_bits_4; // @[src/main/scala/util/AsyncQueue.scala 227:17]
  assign source_io_enq_bits_5 = io_enq_bits_5; // @[src/main/scala/util/AsyncQueue.scala 227:17]
  assign source_io_enq_bits_6 = io_enq_bits_6; // @[src/main/scala/util/AsyncQueue.scala 227:17]
  assign source_io_enq_bits_7 = io_enq_bits_7; // @[src/main/scala/util/AsyncQueue.scala 227:17]
  assign source_io_enq_bits_8 = io_enq_bits_8; // @[src/main/scala/util/AsyncQueue.scala 227:17]
  assign source_io_enq_bits_9 = io_enq_bits_9; // @[src/main/scala/util/AsyncQueue.scala 227:17]
  assign source_io_enq_bits_10 = io_enq_bits_10; // @[src/main/scala/util/AsyncQueue.scala 227:17]
  assign source_io_enq_bits_11 = io_enq_bits_11; // @[src/main/scala/util/AsyncQueue.scala 227:17]
  assign source_io_enq_bits_12 = io_enq_bits_12; // @[src/main/scala/util/AsyncQueue.scala 227:17]
  assign source_io_enq_bits_13 = io_enq_bits_13; // @[src/main/scala/util/AsyncQueue.scala 227:17]
  assign source_io_enq_bits_14 = io_enq_bits_14; // @[src/main/scala/util/AsyncQueue.scala 227:17]
  assign source_io_enq_bits_15 = io_enq_bits_15; // @[src/main/scala/util/AsyncQueue.scala 227:17]
  assign source_io_async_ridx = sink_io_async_ridx; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign source_io_async_safe_ridx_valid = sink_io_async_safe_ridx_valid; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign source_io_async_safe_sink_reset_n = sink_io_async_safe_sink_reset_n; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_clock = io_deq_clock;
  assign sink_reset = io_deq_reset;
  assign sink_io_deq_ready = 1'h1; // @[src/main/scala/util/AsyncQueue.scala 228:10]
  assign sink_io_async_mem_0_0 = source_io_async_mem_0_0; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_0_1 = source_io_async_mem_0_1; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_0_2 = source_io_async_mem_0_2; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_0_3 = source_io_async_mem_0_3; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_0_4 = source_io_async_mem_0_4; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_0_5 = source_io_async_mem_0_5; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_0_6 = source_io_async_mem_0_6; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_0_7 = source_io_async_mem_0_7; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_0_8 = source_io_async_mem_0_8; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_0_9 = source_io_async_mem_0_9; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_0_10 = source_io_async_mem_0_10; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_0_11 = source_io_async_mem_0_11; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_0_12 = source_io_async_mem_0_12; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_0_13 = source_io_async_mem_0_13; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_0_14 = source_io_async_mem_0_14; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_0_15 = source_io_async_mem_0_15; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_1_0 = source_io_async_mem_1_0; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_1_1 = source_io_async_mem_1_1; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_1_2 = source_io_async_mem_1_2; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_1_3 = source_io_async_mem_1_3; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_1_4 = source_io_async_mem_1_4; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_1_5 = source_io_async_mem_1_5; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_1_6 = source_io_async_mem_1_6; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_1_7 = source_io_async_mem_1_7; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_1_8 = source_io_async_mem_1_8; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_1_9 = source_io_async_mem_1_9; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_1_10 = source_io_async_mem_1_10; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_1_11 = source_io_async_mem_1_11; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_1_12 = source_io_async_mem_1_12; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_1_13 = source_io_async_mem_1_13; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_1_14 = source_io_async_mem_1_14; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_1_15 = source_io_async_mem_1_15; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_2_0 = source_io_async_mem_2_0; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_2_1 = source_io_async_mem_2_1; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_2_2 = source_io_async_mem_2_2; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_2_3 = source_io_async_mem_2_3; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_2_4 = source_io_async_mem_2_4; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_2_5 = source_io_async_mem_2_5; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_2_6 = source_io_async_mem_2_6; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_2_7 = source_io_async_mem_2_7; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_2_8 = source_io_async_mem_2_8; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_2_9 = source_io_async_mem_2_9; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_2_10 = source_io_async_mem_2_10; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_2_11 = source_io_async_mem_2_11; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_2_12 = source_io_async_mem_2_12; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_2_13 = source_io_async_mem_2_13; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_2_14 = source_io_async_mem_2_14; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_2_15 = source_io_async_mem_2_15; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_3_0 = source_io_async_mem_3_0; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_3_1 = source_io_async_mem_3_1; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_3_2 = source_io_async_mem_3_2; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_3_3 = source_io_async_mem_3_3; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_3_4 = source_io_async_mem_3_4; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_3_5 = source_io_async_mem_3_5; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_3_6 = source_io_async_mem_3_6; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_3_7 = source_io_async_mem_3_7; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_3_8 = source_io_async_mem_3_8; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_3_9 = source_io_async_mem_3_9; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_3_10 = source_io_async_mem_3_10; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_3_11 = source_io_async_mem_3_11; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_3_12 = source_io_async_mem_3_12; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_3_13 = source_io_async_mem_3_13; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_3_14 = source_io_async_mem_3_14; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_3_15 = source_io_async_mem_3_15; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_4_0 = source_io_async_mem_4_0; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_4_1 = source_io_async_mem_4_1; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_4_2 = source_io_async_mem_4_2; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_4_3 = source_io_async_mem_4_3; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_4_4 = source_io_async_mem_4_4; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_4_5 = source_io_async_mem_4_5; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_4_6 = source_io_async_mem_4_6; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_4_7 = source_io_async_mem_4_7; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_4_8 = source_io_async_mem_4_8; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_4_9 = source_io_async_mem_4_9; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_4_10 = source_io_async_mem_4_10; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_4_11 = source_io_async_mem_4_11; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_4_12 = source_io_async_mem_4_12; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_4_13 = source_io_async_mem_4_13; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_4_14 = source_io_async_mem_4_14; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_4_15 = source_io_async_mem_4_15; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_5_0 = source_io_async_mem_5_0; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_5_1 = source_io_async_mem_5_1; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_5_2 = source_io_async_mem_5_2; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_5_3 = source_io_async_mem_5_3; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_5_4 = source_io_async_mem_5_4; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_5_5 = source_io_async_mem_5_5; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_5_6 = source_io_async_mem_5_6; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_5_7 = source_io_async_mem_5_7; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_5_8 = source_io_async_mem_5_8; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_5_9 = source_io_async_mem_5_9; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_5_10 = source_io_async_mem_5_10; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_5_11 = source_io_async_mem_5_11; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_5_12 = source_io_async_mem_5_12; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_5_13 = source_io_async_mem_5_13; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_5_14 = source_io_async_mem_5_14; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_5_15 = source_io_async_mem_5_15; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_6_0 = source_io_async_mem_6_0; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_6_1 = source_io_async_mem_6_1; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_6_2 = source_io_async_mem_6_2; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_6_3 = source_io_async_mem_6_3; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_6_4 = source_io_async_mem_6_4; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_6_5 = source_io_async_mem_6_5; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_6_6 = source_io_async_mem_6_6; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_6_7 = source_io_async_mem_6_7; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_6_8 = source_io_async_mem_6_8; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_6_9 = source_io_async_mem_6_9; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_6_10 = source_io_async_mem_6_10; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_6_11 = source_io_async_mem_6_11; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_6_12 = source_io_async_mem_6_12; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_6_13 = source_io_async_mem_6_13; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_6_14 = source_io_async_mem_6_14; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_6_15 = source_io_async_mem_6_15; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_7_0 = source_io_async_mem_7_0; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_7_1 = source_io_async_mem_7_1; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_7_2 = source_io_async_mem_7_2; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_7_3 = source_io_async_mem_7_3; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_7_4 = source_io_async_mem_7_4; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_7_5 = source_io_async_mem_7_5; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_7_6 = source_io_async_mem_7_6; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_7_7 = source_io_async_mem_7_7; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_7_8 = source_io_async_mem_7_8; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_7_9 = source_io_async_mem_7_9; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_7_10 = source_io_async_mem_7_10; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_7_11 = source_io_async_mem_7_11; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_7_12 = source_io_async_mem_7_12; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_7_13 = source_io_async_mem_7_13; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_7_14 = source_io_async_mem_7_14; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_mem_7_15 = source_io_async_mem_7_15; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_widx = source_io_async_widx; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_safe_widx_valid = source_io_async_safe_widx_valid; // @[src/main/scala/util/AsyncQueue.scala 229:17]
  assign sink_io_async_safe_source_reset_n = source_io_async_safe_source_reset_n; // @[src/main/scala/util/AsyncQueue.scala 229:17]
endmodule
module Lanes(
  input          clock,
  input          reset,
  input          io_mainbandIo_fifoParams_clk, // @[src/main/scala/logphy/Lanes.scala 13:14]
  input          io_mainbandIo_fifoParams_reset, // @[src/main/scala/logphy/Lanes.scala 13:14]
  input          io_mainbandIo_txData_ready, // @[src/main/scala/logphy/Lanes.scala 13:14]
  output         io_mainbandIo_txData_valid, // @[src/main/scala/logphy/Lanes.scala 13:14]
  output [15:0]  io_mainbandIo_txData_bits_0, // @[src/main/scala/logphy/Lanes.scala 13:14]
  output [15:0]  io_mainbandIo_txData_bits_1, // @[src/main/scala/logphy/Lanes.scala 13:14]
  output [15:0]  io_mainbandIo_txData_bits_2, // @[src/main/scala/logphy/Lanes.scala 13:14]
  output [15:0]  io_mainbandIo_txData_bits_3, // @[src/main/scala/logphy/Lanes.scala 13:14]
  output [15:0]  io_mainbandIo_txData_bits_4, // @[src/main/scala/logphy/Lanes.scala 13:14]
  output [15:0]  io_mainbandIo_txData_bits_5, // @[src/main/scala/logphy/Lanes.scala 13:14]
  output [15:0]  io_mainbandIo_txData_bits_6, // @[src/main/scala/logphy/Lanes.scala 13:14]
  output [15:0]  io_mainbandIo_txData_bits_7, // @[src/main/scala/logphy/Lanes.scala 13:14]
  output [15:0]  io_mainbandIo_txData_bits_8, // @[src/main/scala/logphy/Lanes.scala 13:14]
  output [15:0]  io_mainbandIo_txData_bits_9, // @[src/main/scala/logphy/Lanes.scala 13:14]
  output [15:0]  io_mainbandIo_txData_bits_10, // @[src/main/scala/logphy/Lanes.scala 13:14]
  output [15:0]  io_mainbandIo_txData_bits_11, // @[src/main/scala/logphy/Lanes.scala 13:14]
  output [15:0]  io_mainbandIo_txData_bits_12, // @[src/main/scala/logphy/Lanes.scala 13:14]
  output [15:0]  io_mainbandIo_txData_bits_13, // @[src/main/scala/logphy/Lanes.scala 13:14]
  output [15:0]  io_mainbandIo_txData_bits_14, // @[src/main/scala/logphy/Lanes.scala 13:14]
  output [15:0]  io_mainbandIo_txData_bits_15, // @[src/main/scala/logphy/Lanes.scala 13:14]
  output         io_mainbandIo_rxData_ready, // @[src/main/scala/logphy/Lanes.scala 13:14]
  input          io_mainbandIo_rxData_valid, // @[src/main/scala/logphy/Lanes.scala 13:14]
  input  [15:0]  io_mainbandIo_rxData_bits_0, // @[src/main/scala/logphy/Lanes.scala 13:14]
  input  [15:0]  io_mainbandIo_rxData_bits_1, // @[src/main/scala/logphy/Lanes.scala 13:14]
  input  [15:0]  io_mainbandIo_rxData_bits_2, // @[src/main/scala/logphy/Lanes.scala 13:14]
  input  [15:0]  io_mainbandIo_rxData_bits_3, // @[src/main/scala/logphy/Lanes.scala 13:14]
  input  [15:0]  io_mainbandIo_rxData_bits_4, // @[src/main/scala/logphy/Lanes.scala 13:14]
  input  [15:0]  io_mainbandIo_rxData_bits_5, // @[src/main/scala/logphy/Lanes.scala 13:14]
  input  [15:0]  io_mainbandIo_rxData_bits_6, // @[src/main/scala/logphy/Lanes.scala 13:14]
  input  [15:0]  io_mainbandIo_rxData_bits_7, // @[src/main/scala/logphy/Lanes.scala 13:14]
  input  [15:0]  io_mainbandIo_rxData_bits_8, // @[src/main/scala/logphy/Lanes.scala 13:14]
  input  [15:0]  io_mainbandIo_rxData_bits_9, // @[src/main/scala/logphy/Lanes.scala 13:14]
  input  [15:0]  io_mainbandIo_rxData_bits_10, // @[src/main/scala/logphy/Lanes.scala 13:14]
  input  [15:0]  io_mainbandIo_rxData_bits_11, // @[src/main/scala/logphy/Lanes.scala 13:14]
  input  [15:0]  io_mainbandIo_rxData_bits_12, // @[src/main/scala/logphy/Lanes.scala 13:14]
  input  [15:0]  io_mainbandIo_rxData_bits_13, // @[src/main/scala/logphy/Lanes.scala 13:14]
  input  [15:0]  io_mainbandIo_rxData_bits_14, // @[src/main/scala/logphy/Lanes.scala 13:14]
  input  [15:0]  io_mainbandIo_rxData_bits_15, // @[src/main/scala/logphy/Lanes.scala 13:14]
  output         io_mainbandLaneIO_txData_ready, // @[src/main/scala/logphy/Lanes.scala 13:14]
  input          io_mainbandLaneIO_txData_valid, // @[src/main/scala/logphy/Lanes.scala 13:14]
  input  [255:0] io_mainbandLaneIO_txData_bits, // @[src/main/scala/logphy/Lanes.scala 13:14]
  output         io_mainbandLaneIO_rxData_valid, // @[src/main/scala/logphy/Lanes.scala 13:14]
  output [255:0] io_mainbandLaneIO_rxData_bits // @[src/main/scala/logphy/Lanes.scala 13:14]
);
  wire  txMBFifo_io_enq_clock; // @[src/main/scala/logphy/Lanes.scala 19:11]
  wire  txMBFifo_io_enq_reset; // @[src/main/scala/logphy/Lanes.scala 19:11]
  wire  txMBFifo_io_enq_ready; // @[src/main/scala/logphy/Lanes.scala 19:11]
  wire  txMBFifo_io_enq_valid; // @[src/main/scala/logphy/Lanes.scala 19:11]
  wire [15:0] txMBFifo_io_enq_bits_0; // @[src/main/scala/logphy/Lanes.scala 19:11]
  wire [15:0] txMBFifo_io_enq_bits_1; // @[src/main/scala/logphy/Lanes.scala 19:11]
  wire [15:0] txMBFifo_io_enq_bits_2; // @[src/main/scala/logphy/Lanes.scala 19:11]
  wire [15:0] txMBFifo_io_enq_bits_3; // @[src/main/scala/logphy/Lanes.scala 19:11]
  wire [15:0] txMBFifo_io_enq_bits_4; // @[src/main/scala/logphy/Lanes.scala 19:11]
  wire [15:0] txMBFifo_io_enq_bits_5; // @[src/main/scala/logphy/Lanes.scala 19:11]
  wire [15:0] txMBFifo_io_enq_bits_6; // @[src/main/scala/logphy/Lanes.scala 19:11]
  wire [15:0] txMBFifo_io_enq_bits_7; // @[src/main/scala/logphy/Lanes.scala 19:11]
  wire [15:0] txMBFifo_io_enq_bits_8; // @[src/main/scala/logphy/Lanes.scala 19:11]
  wire [15:0] txMBFifo_io_enq_bits_9; // @[src/main/scala/logphy/Lanes.scala 19:11]
  wire [15:0] txMBFifo_io_enq_bits_10; // @[src/main/scala/logphy/Lanes.scala 19:11]
  wire [15:0] txMBFifo_io_enq_bits_11; // @[src/main/scala/logphy/Lanes.scala 19:11]
  wire [15:0] txMBFifo_io_enq_bits_12; // @[src/main/scala/logphy/Lanes.scala 19:11]
  wire [15:0] txMBFifo_io_enq_bits_13; // @[src/main/scala/logphy/Lanes.scala 19:11]
  wire [15:0] txMBFifo_io_enq_bits_14; // @[src/main/scala/logphy/Lanes.scala 19:11]
  wire [15:0] txMBFifo_io_enq_bits_15; // @[src/main/scala/logphy/Lanes.scala 19:11]
  wire  txMBFifo_io_deq_clock; // @[src/main/scala/logphy/Lanes.scala 19:11]
  wire  txMBFifo_io_deq_reset; // @[src/main/scala/logphy/Lanes.scala 19:11]
  wire  txMBFifo_io_deq_ready; // @[src/main/scala/logphy/Lanes.scala 19:11]
  wire  txMBFifo_io_deq_valid; // @[src/main/scala/logphy/Lanes.scala 19:11]
  wire [15:0] txMBFifo_io_deq_bits_0; // @[src/main/scala/logphy/Lanes.scala 19:11]
  wire [15:0] txMBFifo_io_deq_bits_1; // @[src/main/scala/logphy/Lanes.scala 19:11]
  wire [15:0] txMBFifo_io_deq_bits_2; // @[src/main/scala/logphy/Lanes.scala 19:11]
  wire [15:0] txMBFifo_io_deq_bits_3; // @[src/main/scala/logphy/Lanes.scala 19:11]
  wire [15:0] txMBFifo_io_deq_bits_4; // @[src/main/scala/logphy/Lanes.scala 19:11]
  wire [15:0] txMBFifo_io_deq_bits_5; // @[src/main/scala/logphy/Lanes.scala 19:11]
  wire [15:0] txMBFifo_io_deq_bits_6; // @[src/main/scala/logphy/Lanes.scala 19:11]
  wire [15:0] txMBFifo_io_deq_bits_7; // @[src/main/scala/logphy/Lanes.scala 19:11]
  wire [15:0] txMBFifo_io_deq_bits_8; // @[src/main/scala/logphy/Lanes.scala 19:11]
  wire [15:0] txMBFifo_io_deq_bits_9; // @[src/main/scala/logphy/Lanes.scala 19:11]
  wire [15:0] txMBFifo_io_deq_bits_10; // @[src/main/scala/logphy/Lanes.scala 19:11]
  wire [15:0] txMBFifo_io_deq_bits_11; // @[src/main/scala/logphy/Lanes.scala 19:11]
  wire [15:0] txMBFifo_io_deq_bits_12; // @[src/main/scala/logphy/Lanes.scala 19:11]
  wire [15:0] txMBFifo_io_deq_bits_13; // @[src/main/scala/logphy/Lanes.scala 19:11]
  wire [15:0] txMBFifo_io_deq_bits_14; // @[src/main/scala/logphy/Lanes.scala 19:11]
  wire [15:0] txMBFifo_io_deq_bits_15; // @[src/main/scala/logphy/Lanes.scala 19:11]
  wire  rxMBFifo_io_enq_clock; // @[src/main/scala/logphy/Lanes.scala 26:11]
  wire  rxMBFifo_io_enq_reset; // @[src/main/scala/logphy/Lanes.scala 26:11]
  wire  rxMBFifo_io_enq_ready; // @[src/main/scala/logphy/Lanes.scala 26:11]
  wire  rxMBFifo_io_enq_valid; // @[src/main/scala/logphy/Lanes.scala 26:11]
  wire [15:0] rxMBFifo_io_enq_bits_0; // @[src/main/scala/logphy/Lanes.scala 26:11]
  wire [15:0] rxMBFifo_io_enq_bits_1; // @[src/main/scala/logphy/Lanes.scala 26:11]
  wire [15:0] rxMBFifo_io_enq_bits_2; // @[src/main/scala/logphy/Lanes.scala 26:11]
  wire [15:0] rxMBFifo_io_enq_bits_3; // @[src/main/scala/logphy/Lanes.scala 26:11]
  wire [15:0] rxMBFifo_io_enq_bits_4; // @[src/main/scala/logphy/Lanes.scala 26:11]
  wire [15:0] rxMBFifo_io_enq_bits_5; // @[src/main/scala/logphy/Lanes.scala 26:11]
  wire [15:0] rxMBFifo_io_enq_bits_6; // @[src/main/scala/logphy/Lanes.scala 26:11]
  wire [15:0] rxMBFifo_io_enq_bits_7; // @[src/main/scala/logphy/Lanes.scala 26:11]
  wire [15:0] rxMBFifo_io_enq_bits_8; // @[src/main/scala/logphy/Lanes.scala 26:11]
  wire [15:0] rxMBFifo_io_enq_bits_9; // @[src/main/scala/logphy/Lanes.scala 26:11]
  wire [15:0] rxMBFifo_io_enq_bits_10; // @[src/main/scala/logphy/Lanes.scala 26:11]
  wire [15:0] rxMBFifo_io_enq_bits_11; // @[src/main/scala/logphy/Lanes.scala 26:11]
  wire [15:0] rxMBFifo_io_enq_bits_12; // @[src/main/scala/logphy/Lanes.scala 26:11]
  wire [15:0] rxMBFifo_io_enq_bits_13; // @[src/main/scala/logphy/Lanes.scala 26:11]
  wire [15:0] rxMBFifo_io_enq_bits_14; // @[src/main/scala/logphy/Lanes.scala 26:11]
  wire [15:0] rxMBFifo_io_enq_bits_15; // @[src/main/scala/logphy/Lanes.scala 26:11]
  wire  rxMBFifo_io_deq_clock; // @[src/main/scala/logphy/Lanes.scala 26:11]
  wire  rxMBFifo_io_deq_reset; // @[src/main/scala/logphy/Lanes.scala 26:11]
  wire  rxMBFifo_io_deq_valid; // @[src/main/scala/logphy/Lanes.scala 26:11]
  wire [15:0] rxMBFifo_io_deq_bits_0; // @[src/main/scala/logphy/Lanes.scala 26:11]
  wire [15:0] rxMBFifo_io_deq_bits_1; // @[src/main/scala/logphy/Lanes.scala 26:11]
  wire [15:0] rxMBFifo_io_deq_bits_2; // @[src/main/scala/logphy/Lanes.scala 26:11]
  wire [15:0] rxMBFifo_io_deq_bits_3; // @[src/main/scala/logphy/Lanes.scala 26:11]
  wire [15:0] rxMBFifo_io_deq_bits_4; // @[src/main/scala/logphy/Lanes.scala 26:11]
  wire [15:0] rxMBFifo_io_deq_bits_5; // @[src/main/scala/logphy/Lanes.scala 26:11]
  wire [15:0] rxMBFifo_io_deq_bits_6; // @[src/main/scala/logphy/Lanes.scala 26:11]
  wire [15:0] rxMBFifo_io_deq_bits_7; // @[src/main/scala/logphy/Lanes.scala 26:11]
  wire [15:0] rxMBFifo_io_deq_bits_8; // @[src/main/scala/logphy/Lanes.scala 26:11]
  wire [15:0] rxMBFifo_io_deq_bits_9; // @[src/main/scala/logphy/Lanes.scala 26:11]
  wire [15:0] rxMBFifo_io_deq_bits_10; // @[src/main/scala/logphy/Lanes.scala 26:11]
  wire [15:0] rxMBFifo_io_deq_bits_11; // @[src/main/scala/logphy/Lanes.scala 26:11]
  wire [15:0] rxMBFifo_io_deq_bits_12; // @[src/main/scala/logphy/Lanes.scala 26:11]
  wire [15:0] rxMBFifo_io_deq_bits_13; // @[src/main/scala/logphy/Lanes.scala 26:11]
  wire [15:0] rxMBFifo_io_deq_bits_14; // @[src/main/scala/logphy/Lanes.scala 26:11]
  wire [15:0] rxMBFifo_io_deq_bits_15; // @[src/main/scala/logphy/Lanes.scala 26:11]
  wire [7:0] txDataVec_15_0 = io_mainbandLaneIO_txData_bits[7:0]; // @[src/main/scala/logphy/Lanes.scala 59:14]
  wire [7:0] rxDataVec_0_15 = rxMBFifo_io_deq_bits_0[7:0]; // @[src/main/scala/logphy/Lanes.scala 64:17]
  wire [7:0] txDataVec_15_1 = io_mainbandLaneIO_txData_bits[135:128]; // @[src/main/scala/logphy/Lanes.scala 59:14]
  wire [7:0] rxDataVec_1_15 = rxMBFifo_io_deq_bits_0[15:8]; // @[src/main/scala/logphy/Lanes.scala 64:17]
  wire [7:0] txDataVec_0_1 = io_mainbandLaneIO_txData_bits[255:248]; // @[src/main/scala/logphy/Lanes.scala 59:14]
  wire [7:0] txDataVec_0_0 = io_mainbandLaneIO_txData_bits[127:120]; // @[src/main/scala/logphy/Lanes.scala 59:14]
  wire [7:0] txDataVec_14_0 = io_mainbandLaneIO_txData_bits[15:8]; // @[src/main/scala/logphy/Lanes.scala 59:14]
  wire [7:0] rxDataVec_0_14 = rxMBFifo_io_deq_bits_1[7:0]; // @[src/main/scala/logphy/Lanes.scala 64:17]
  wire [7:0] txDataVec_14_1 = io_mainbandLaneIO_txData_bits[143:136]; // @[src/main/scala/logphy/Lanes.scala 59:14]
  wire [7:0] rxDataVec_1_14 = rxMBFifo_io_deq_bits_1[15:8]; // @[src/main/scala/logphy/Lanes.scala 64:17]
  wire [7:0] txDataVec_1_1 = io_mainbandLaneIO_txData_bits[247:240]; // @[src/main/scala/logphy/Lanes.scala 59:14]
  wire [7:0] txDataVec_1_0 = io_mainbandLaneIO_txData_bits[119:112]; // @[src/main/scala/logphy/Lanes.scala 59:14]
  wire [7:0] txDataVec_13_0 = io_mainbandLaneIO_txData_bits[23:16]; // @[src/main/scala/logphy/Lanes.scala 59:14]
  wire [7:0] rxDataVec_0_13 = rxMBFifo_io_deq_bits_2[7:0]; // @[src/main/scala/logphy/Lanes.scala 64:17]
  wire [7:0] txDataVec_13_1 = io_mainbandLaneIO_txData_bits[151:144]; // @[src/main/scala/logphy/Lanes.scala 59:14]
  wire [7:0] rxDataVec_1_13 = rxMBFifo_io_deq_bits_2[15:8]; // @[src/main/scala/logphy/Lanes.scala 64:17]
  wire [7:0] txDataVec_2_1 = io_mainbandLaneIO_txData_bits[239:232]; // @[src/main/scala/logphy/Lanes.scala 59:14]
  wire [7:0] txDataVec_2_0 = io_mainbandLaneIO_txData_bits[111:104]; // @[src/main/scala/logphy/Lanes.scala 59:14]
  wire [7:0] txDataVec_12_0 = io_mainbandLaneIO_txData_bits[31:24]; // @[src/main/scala/logphy/Lanes.scala 59:14]
  wire [7:0] rxDataVec_0_12 = rxMBFifo_io_deq_bits_3[7:0]; // @[src/main/scala/logphy/Lanes.scala 64:17]
  wire [7:0] txDataVec_12_1 = io_mainbandLaneIO_txData_bits[159:152]; // @[src/main/scala/logphy/Lanes.scala 59:14]
  wire [7:0] rxDataVec_1_12 = rxMBFifo_io_deq_bits_3[15:8]; // @[src/main/scala/logphy/Lanes.scala 64:17]
  wire [7:0] txDataVec_3_1 = io_mainbandLaneIO_txData_bits[231:224]; // @[src/main/scala/logphy/Lanes.scala 59:14]
  wire [7:0] txDataVec_3_0 = io_mainbandLaneIO_txData_bits[103:96]; // @[src/main/scala/logphy/Lanes.scala 59:14]
  wire [7:0] txDataVec_11_0 = io_mainbandLaneIO_txData_bits[39:32]; // @[src/main/scala/logphy/Lanes.scala 59:14]
  wire [7:0] rxDataVec_0_11 = rxMBFifo_io_deq_bits_4[7:0]; // @[src/main/scala/logphy/Lanes.scala 64:17]
  wire [7:0] txDataVec_11_1 = io_mainbandLaneIO_txData_bits[167:160]; // @[src/main/scala/logphy/Lanes.scala 59:14]
  wire [7:0] rxDataVec_1_11 = rxMBFifo_io_deq_bits_4[15:8]; // @[src/main/scala/logphy/Lanes.scala 64:17]
  wire [7:0] txDataVec_4_1 = io_mainbandLaneIO_txData_bits[223:216]; // @[src/main/scala/logphy/Lanes.scala 59:14]
  wire [7:0] txDataVec_4_0 = io_mainbandLaneIO_txData_bits[95:88]; // @[src/main/scala/logphy/Lanes.scala 59:14]
  wire [7:0] txDataVec_10_0 = io_mainbandLaneIO_txData_bits[47:40]; // @[src/main/scala/logphy/Lanes.scala 59:14]
  wire [7:0] rxDataVec_0_10 = rxMBFifo_io_deq_bits_5[7:0]; // @[src/main/scala/logphy/Lanes.scala 64:17]
  wire [7:0] txDataVec_10_1 = io_mainbandLaneIO_txData_bits[175:168]; // @[src/main/scala/logphy/Lanes.scala 59:14]
  wire [7:0] rxDataVec_1_10 = rxMBFifo_io_deq_bits_5[15:8]; // @[src/main/scala/logphy/Lanes.scala 64:17]
  wire [7:0] txDataVec_5_1 = io_mainbandLaneIO_txData_bits[215:208]; // @[src/main/scala/logphy/Lanes.scala 59:14]
  wire [7:0] txDataVec_5_0 = io_mainbandLaneIO_txData_bits[87:80]; // @[src/main/scala/logphy/Lanes.scala 59:14]
  wire [7:0] txDataVec_9_0 = io_mainbandLaneIO_txData_bits[55:48]; // @[src/main/scala/logphy/Lanes.scala 59:14]
  wire [7:0] rxDataVec_0_9 = rxMBFifo_io_deq_bits_6[7:0]; // @[src/main/scala/logphy/Lanes.scala 64:17]
  wire [7:0] txDataVec_9_1 = io_mainbandLaneIO_txData_bits[183:176]; // @[src/main/scala/logphy/Lanes.scala 59:14]
  wire [7:0] rxDataVec_1_9 = rxMBFifo_io_deq_bits_6[15:8]; // @[src/main/scala/logphy/Lanes.scala 64:17]
  wire [7:0] txDataVec_6_1 = io_mainbandLaneIO_txData_bits[207:200]; // @[src/main/scala/logphy/Lanes.scala 59:14]
  wire [7:0] txDataVec_6_0 = io_mainbandLaneIO_txData_bits[79:72]; // @[src/main/scala/logphy/Lanes.scala 59:14]
  wire [7:0] txDataVec_8_0 = io_mainbandLaneIO_txData_bits[63:56]; // @[src/main/scala/logphy/Lanes.scala 59:14]
  wire [7:0] rxDataVec_0_8 = rxMBFifo_io_deq_bits_7[7:0]; // @[src/main/scala/logphy/Lanes.scala 64:17]
  wire [7:0] txDataVec_8_1 = io_mainbandLaneIO_txData_bits[191:184]; // @[src/main/scala/logphy/Lanes.scala 59:14]
  wire [7:0] rxDataVec_1_8 = rxMBFifo_io_deq_bits_7[15:8]; // @[src/main/scala/logphy/Lanes.scala 64:17]
  wire [7:0] txDataVec_7_1 = io_mainbandLaneIO_txData_bits[199:192]; // @[src/main/scala/logphy/Lanes.scala 59:14]
  wire [7:0] txDataVec_7_0 = io_mainbandLaneIO_txData_bits[71:64]; // @[src/main/scala/logphy/Lanes.scala 59:14]
  wire [7:0] rxDataVec_0_7 = rxMBFifo_io_deq_bits_8[7:0]; // @[src/main/scala/logphy/Lanes.scala 64:17]
  wire [7:0] rxDataVec_1_7 = rxMBFifo_io_deq_bits_8[15:8]; // @[src/main/scala/logphy/Lanes.scala 64:17]
  wire [7:0] rxDataVec_0_6 = rxMBFifo_io_deq_bits_9[7:0]; // @[src/main/scala/logphy/Lanes.scala 64:17]
  wire [7:0] rxDataVec_1_6 = rxMBFifo_io_deq_bits_9[15:8]; // @[src/main/scala/logphy/Lanes.scala 64:17]
  wire [7:0] rxDataVec_0_5 = rxMBFifo_io_deq_bits_10[7:0]; // @[src/main/scala/logphy/Lanes.scala 64:17]
  wire [7:0] rxDataVec_1_5 = rxMBFifo_io_deq_bits_10[15:8]; // @[src/main/scala/logphy/Lanes.scala 64:17]
  wire [7:0] rxDataVec_0_4 = rxMBFifo_io_deq_bits_11[7:0]; // @[src/main/scala/logphy/Lanes.scala 64:17]
  wire [7:0] rxDataVec_1_4 = rxMBFifo_io_deq_bits_11[15:8]; // @[src/main/scala/logphy/Lanes.scala 64:17]
  wire [7:0] rxDataVec_0_3 = rxMBFifo_io_deq_bits_12[7:0]; // @[src/main/scala/logphy/Lanes.scala 64:17]
  wire [7:0] rxDataVec_1_3 = rxMBFifo_io_deq_bits_12[15:8]; // @[src/main/scala/logphy/Lanes.scala 64:17]
  wire [7:0] rxDataVec_0_2 = rxMBFifo_io_deq_bits_13[7:0]; // @[src/main/scala/logphy/Lanes.scala 64:17]
  wire [7:0] rxDataVec_1_2 = rxMBFifo_io_deq_bits_13[15:8]; // @[src/main/scala/logphy/Lanes.scala 64:17]
  wire [7:0] rxDataVec_0_1 = rxMBFifo_io_deq_bits_14[7:0]; // @[src/main/scala/logphy/Lanes.scala 64:17]
  wire [7:0] rxDataVec_1_1 = rxMBFifo_io_deq_bits_14[15:8]; // @[src/main/scala/logphy/Lanes.scala 64:17]
  wire [7:0] rxDataVec_0_0 = rxMBFifo_io_deq_bits_15[7:0]; // @[src/main/scala/logphy/Lanes.scala 64:17]
  wire [7:0] rxDataVec_1_0 = rxMBFifo_io_deq_bits_15[15:8]; // @[src/main/scala/logphy/Lanes.scala 64:17]
  wire [63:0] io_mainbandLaneIO_rxData_bits_lo_lo = {rxDataVec_0_7,rxDataVec_0_6,rxDataVec_0_5,rxDataVec_0_4,
    rxDataVec_0_3,rxDataVec_0_2,rxDataVec_0_1,rxDataVec_0_0}; // @[src/main/scala/logphy/Lanes.scala 68:46]
  wire [127:0] io_mainbandLaneIO_rxData_bits_lo = {rxDataVec_0_15,rxDataVec_0_14,rxDataVec_0_13,rxDataVec_0_12,
    rxDataVec_0_11,rxDataVec_0_10,rxDataVec_0_9,rxDataVec_0_8,io_mainbandLaneIO_rxData_bits_lo_lo}; // @[src/main/scala/logphy/Lanes.scala 68:46]
  wire [63:0] io_mainbandLaneIO_rxData_bits_hi_lo = {rxDataVec_1_7,rxDataVec_1_6,rxDataVec_1_5,rxDataVec_1_4,
    rxDataVec_1_3,rxDataVec_1_2,rxDataVec_1_1,rxDataVec_1_0}; // @[src/main/scala/logphy/Lanes.scala 68:46]
  wire [127:0] io_mainbandLaneIO_rxData_bits_hi = {rxDataVec_1_15,rxDataVec_1_14,rxDataVec_1_13,rxDataVec_1_12,
    rxDataVec_1_11,rxDataVec_1_10,rxDataVec_1_9,rxDataVec_1_8,io_mainbandLaneIO_rxData_bits_hi_lo}; // @[src/main/scala/logphy/Lanes.scala 68:46]
  AsyncQueue txMBFifo ( // @[src/main/scala/logphy/Lanes.scala 19:11]
    .io_enq_clock(txMBFifo_io_enq_clock),
    .io_enq_reset(txMBFifo_io_enq_reset),
    .io_enq_ready(txMBFifo_io_enq_ready),
    .io_enq_valid(txMBFifo_io_enq_valid),
    .io_enq_bits_0(txMBFifo_io_enq_bits_0),
    .io_enq_bits_1(txMBFifo_io_enq_bits_1),
    .io_enq_bits_2(txMBFifo_io_enq_bits_2),
    .io_enq_bits_3(txMBFifo_io_enq_bits_3),
    .io_enq_bits_4(txMBFifo_io_enq_bits_4),
    .io_enq_bits_5(txMBFifo_io_enq_bits_5),
    .io_enq_bits_6(txMBFifo_io_enq_bits_6),
    .io_enq_bits_7(txMBFifo_io_enq_bits_7),
    .io_enq_bits_8(txMBFifo_io_enq_bits_8),
    .io_enq_bits_9(txMBFifo_io_enq_bits_9),
    .io_enq_bits_10(txMBFifo_io_enq_bits_10),
    .io_enq_bits_11(txMBFifo_io_enq_bits_11),
    .io_enq_bits_12(txMBFifo_io_enq_bits_12),
    .io_enq_bits_13(txMBFifo_io_enq_bits_13),
    .io_enq_bits_14(txMBFifo_io_enq_bits_14),
    .io_enq_bits_15(txMBFifo_io_enq_bits_15),
    .io_deq_clock(txMBFifo_io_deq_clock),
    .io_deq_reset(txMBFifo_io_deq_reset),
    .io_deq_ready(txMBFifo_io_deq_ready),
    .io_deq_valid(txMBFifo_io_deq_valid),
    .io_deq_bits_0(txMBFifo_io_deq_bits_0),
    .io_deq_bits_1(txMBFifo_io_deq_bits_1),
    .io_deq_bits_2(txMBFifo_io_deq_bits_2),
    .io_deq_bits_3(txMBFifo_io_deq_bits_3),
    .io_deq_bits_4(txMBFifo_io_deq_bits_4),
    .io_deq_bits_5(txMBFifo_io_deq_bits_5),
    .io_deq_bits_6(txMBFifo_io_deq_bits_6),
    .io_deq_bits_7(txMBFifo_io_deq_bits_7),
    .io_deq_bits_8(txMBFifo_io_deq_bits_8),
    .io_deq_bits_9(txMBFifo_io_deq_bits_9),
    .io_deq_bits_10(txMBFifo_io_deq_bits_10),
    .io_deq_bits_11(txMBFifo_io_deq_bits_11),
    .io_deq_bits_12(txMBFifo_io_deq_bits_12),
    .io_deq_bits_13(txMBFifo_io_deq_bits_13),
    .io_deq_bits_14(txMBFifo_io_deq_bits_14),
    .io_deq_bits_15(txMBFifo_io_deq_bits_15)
  );
  AsyncQueue_1 rxMBFifo ( // @[src/main/scala/logphy/Lanes.scala 26:11]
    .io_enq_clock(rxMBFifo_io_enq_clock),
    .io_enq_reset(rxMBFifo_io_enq_reset),
    .io_enq_ready(rxMBFifo_io_enq_ready),
    .io_enq_valid(rxMBFifo_io_enq_valid),
    .io_enq_bits_0(rxMBFifo_io_enq_bits_0),
    .io_enq_bits_1(rxMBFifo_io_enq_bits_1),
    .io_enq_bits_2(rxMBFifo_io_enq_bits_2),
    .io_enq_bits_3(rxMBFifo_io_enq_bits_3),
    .io_enq_bits_4(rxMBFifo_io_enq_bits_4),
    .io_enq_bits_5(rxMBFifo_io_enq_bits_5),
    .io_enq_bits_6(rxMBFifo_io_enq_bits_6),
    .io_enq_bits_7(rxMBFifo_io_enq_bits_7),
    .io_enq_bits_8(rxMBFifo_io_enq_bits_8),
    .io_enq_bits_9(rxMBFifo_io_enq_bits_9),
    .io_enq_bits_10(rxMBFifo_io_enq_bits_10),
    .io_enq_bits_11(rxMBFifo_io_enq_bits_11),
    .io_enq_bits_12(rxMBFifo_io_enq_bits_12),
    .io_enq_bits_13(rxMBFifo_io_enq_bits_13),
    .io_enq_bits_14(rxMBFifo_io_enq_bits_14),
    .io_enq_bits_15(rxMBFifo_io_enq_bits_15),
    .io_deq_clock(rxMBFifo_io_deq_clock),
    .io_deq_reset(rxMBFifo_io_deq_reset),
    .io_deq_valid(rxMBFifo_io_deq_valid),
    .io_deq_bits_0(rxMBFifo_io_deq_bits_0),
    .io_deq_bits_1(rxMBFifo_io_deq_bits_1),
    .io_deq_bits_2(rxMBFifo_io_deq_bits_2),
    .io_deq_bits_3(rxMBFifo_io_deq_bits_3),
    .io_deq_bits_4(rxMBFifo_io_deq_bits_4),
    .io_deq_bits_5(rxMBFifo_io_deq_bits_5),
    .io_deq_bits_6(rxMBFifo_io_deq_bits_6),
    .io_deq_bits_7(rxMBFifo_io_deq_bits_7),
    .io_deq_bits_8(rxMBFifo_io_deq_bits_8),
    .io_deq_bits_9(rxMBFifo_io_deq_bits_9),
    .io_deq_bits_10(rxMBFifo_io_deq_bits_10),
    .io_deq_bits_11(rxMBFifo_io_deq_bits_11),
    .io_deq_bits_12(rxMBFifo_io_deq_bits_12),
    .io_deq_bits_13(rxMBFifo_io_deq_bits_13),
    .io_deq_bits_14(rxMBFifo_io_deq_bits_14),
    .io_deq_bits_15(rxMBFifo_io_deq_bits_15)
  );
  assign io_mainbandIo_txData_valid = txMBFifo_io_deq_valid; // @[src/main/scala/logphy/Lanes.scala 38:19]
  assign io_mainbandIo_txData_bits_0 = txMBFifo_io_deq_bits_0; // @[src/main/scala/logphy/Lanes.scala 38:19]
  assign io_mainbandIo_txData_bits_1 = txMBFifo_io_deq_bits_1; // @[src/main/scala/logphy/Lanes.scala 38:19]
  assign io_mainbandIo_txData_bits_2 = txMBFifo_io_deq_bits_2; // @[src/main/scala/logphy/Lanes.scala 38:19]
  assign io_mainbandIo_txData_bits_3 = txMBFifo_io_deq_bits_3; // @[src/main/scala/logphy/Lanes.scala 38:19]
  assign io_mainbandIo_txData_bits_4 = txMBFifo_io_deq_bits_4; // @[src/main/scala/logphy/Lanes.scala 38:19]
  assign io_mainbandIo_txData_bits_5 = txMBFifo_io_deq_bits_5; // @[src/main/scala/logphy/Lanes.scala 38:19]
  assign io_mainbandIo_txData_bits_6 = txMBFifo_io_deq_bits_6; // @[src/main/scala/logphy/Lanes.scala 38:19]
  assign io_mainbandIo_txData_bits_7 = txMBFifo_io_deq_bits_7; // @[src/main/scala/logphy/Lanes.scala 38:19]
  assign io_mainbandIo_txData_bits_8 = txMBFifo_io_deq_bits_8; // @[src/main/scala/logphy/Lanes.scala 38:19]
  assign io_mainbandIo_txData_bits_9 = txMBFifo_io_deq_bits_9; // @[src/main/scala/logphy/Lanes.scala 38:19]
  assign io_mainbandIo_txData_bits_10 = txMBFifo_io_deq_bits_10; // @[src/main/scala/logphy/Lanes.scala 38:19]
  assign io_mainbandIo_txData_bits_11 = txMBFifo_io_deq_bits_11; // @[src/main/scala/logphy/Lanes.scala 38:19]
  assign io_mainbandIo_txData_bits_12 = txMBFifo_io_deq_bits_12; // @[src/main/scala/logphy/Lanes.scala 38:19]
  assign io_mainbandIo_txData_bits_13 = txMBFifo_io_deq_bits_13; // @[src/main/scala/logphy/Lanes.scala 38:19]
  assign io_mainbandIo_txData_bits_14 = txMBFifo_io_deq_bits_14; // @[src/main/scala/logphy/Lanes.scala 38:19]
  assign io_mainbandIo_txData_bits_15 = txMBFifo_io_deq_bits_15; // @[src/main/scala/logphy/Lanes.scala 38:19]
  assign io_mainbandIo_rxData_ready = rxMBFifo_io_enq_ready; // @[src/main/scala/logphy/Lanes.scala 33:19]
  assign io_mainbandLaneIO_txData_ready = txMBFifo_io_enq_ready; // @[src/main/scala/logphy/Lanes.scala 70:34]
  assign io_mainbandLaneIO_rxData_valid = rxMBFifo_io_deq_valid; // @[src/main/scala/logphy/Lanes.scala 45:34]
  assign io_mainbandLaneIO_rxData_bits = {io_mainbandLaneIO_rxData_bits_hi,io_mainbandLaneIO_rxData_bits_lo}; // @[src/main/scala/logphy/Lanes.scala 68:46]
  assign txMBFifo_io_enq_clock = clock; // @[src/main/scala/logphy/Lanes.scala 39:25]
  assign txMBFifo_io_enq_reset = reset; // @[src/main/scala/logphy/Lanes.scala 40:25]
  assign txMBFifo_io_enq_valid = io_mainbandLaneIO_txData_valid; // @[src/main/scala/logphy/Lanes.scala 44:25]
  assign txMBFifo_io_enq_bits_0 = {txDataVec_0_1,txDataVec_0_0}; // @[src/main/scala/logphy/Lanes.scala 66:45]
  assign txMBFifo_io_enq_bits_1 = {txDataVec_1_1,txDataVec_1_0}; // @[src/main/scala/logphy/Lanes.scala 66:45]
  assign txMBFifo_io_enq_bits_2 = {txDataVec_2_1,txDataVec_2_0}; // @[src/main/scala/logphy/Lanes.scala 66:45]
  assign txMBFifo_io_enq_bits_3 = {txDataVec_3_1,txDataVec_3_0}; // @[src/main/scala/logphy/Lanes.scala 66:45]
  assign txMBFifo_io_enq_bits_4 = {txDataVec_4_1,txDataVec_4_0}; // @[src/main/scala/logphy/Lanes.scala 66:45]
  assign txMBFifo_io_enq_bits_5 = {txDataVec_5_1,txDataVec_5_0}; // @[src/main/scala/logphy/Lanes.scala 66:45]
  assign txMBFifo_io_enq_bits_6 = {txDataVec_6_1,txDataVec_6_0}; // @[src/main/scala/logphy/Lanes.scala 66:45]
  assign txMBFifo_io_enq_bits_7 = {txDataVec_7_1,txDataVec_7_0}; // @[src/main/scala/logphy/Lanes.scala 66:45]
  assign txMBFifo_io_enq_bits_8 = {txDataVec_8_1,txDataVec_8_0}; // @[src/main/scala/logphy/Lanes.scala 66:45]
  assign txMBFifo_io_enq_bits_9 = {txDataVec_9_1,txDataVec_9_0}; // @[src/main/scala/logphy/Lanes.scala 66:45]
  assign txMBFifo_io_enq_bits_10 = {txDataVec_10_1,txDataVec_10_0}; // @[src/main/scala/logphy/Lanes.scala 66:45]
  assign txMBFifo_io_enq_bits_11 = {txDataVec_11_1,txDataVec_11_0}; // @[src/main/scala/logphy/Lanes.scala 66:45]
  assign txMBFifo_io_enq_bits_12 = {txDataVec_12_1,txDataVec_12_0}; // @[src/main/scala/logphy/Lanes.scala 66:45]
  assign txMBFifo_io_enq_bits_13 = {txDataVec_13_1,txDataVec_13_0}; // @[src/main/scala/logphy/Lanes.scala 66:45]
  assign txMBFifo_io_enq_bits_14 = {txDataVec_14_1,txDataVec_14_0}; // @[src/main/scala/logphy/Lanes.scala 66:45]
  assign txMBFifo_io_enq_bits_15 = {txDataVec_15_1,txDataVec_15_0}; // @[src/main/scala/logphy/Lanes.scala 66:45]
  assign txMBFifo_io_deq_clock = io_mainbandIo_fifoParams_clk; // @[src/main/scala/logphy/Lanes.scala 41:25]
  assign txMBFifo_io_deq_reset = io_mainbandIo_fifoParams_reset; // @[src/main/scala/logphy/Lanes.scala 42:25]
  assign txMBFifo_io_deq_ready = io_mainbandIo_txData_ready; // @[src/main/scala/logphy/Lanes.scala 38:19]
  assign rxMBFifo_io_enq_clock = io_mainbandIo_fifoParams_clk; // @[src/main/scala/logphy/Lanes.scala 36:25]
  assign rxMBFifo_io_enq_reset = io_mainbandIo_fifoParams_reset; // @[src/main/scala/logphy/Lanes.scala 37:25]
  assign rxMBFifo_io_enq_valid = io_mainbandIo_rxData_valid; // @[src/main/scala/logphy/Lanes.scala 33:19]
  assign rxMBFifo_io_enq_bits_0 = io_mainbandIo_rxData_bits_0; // @[src/main/scala/logphy/Lanes.scala 33:19]
  assign rxMBFifo_io_enq_bits_1 = io_mainbandIo_rxData_bits_1; // @[src/main/scala/logphy/Lanes.scala 33:19]
  assign rxMBFifo_io_enq_bits_2 = io_mainbandIo_rxData_bits_2; // @[src/main/scala/logphy/Lanes.scala 33:19]
  assign rxMBFifo_io_enq_bits_3 = io_mainbandIo_rxData_bits_3; // @[src/main/scala/logphy/Lanes.scala 33:19]
  assign rxMBFifo_io_enq_bits_4 = io_mainbandIo_rxData_bits_4; // @[src/main/scala/logphy/Lanes.scala 33:19]
  assign rxMBFifo_io_enq_bits_5 = io_mainbandIo_rxData_bits_5; // @[src/main/scala/logphy/Lanes.scala 33:19]
  assign rxMBFifo_io_enq_bits_6 = io_mainbandIo_rxData_bits_6; // @[src/main/scala/logphy/Lanes.scala 33:19]
  assign rxMBFifo_io_enq_bits_7 = io_mainbandIo_rxData_bits_7; // @[src/main/scala/logphy/Lanes.scala 33:19]
  assign rxMBFifo_io_enq_bits_8 = io_mainbandIo_rxData_bits_8; // @[src/main/scala/logphy/Lanes.scala 33:19]
  assign rxMBFifo_io_enq_bits_9 = io_mainbandIo_rxData_bits_9; // @[src/main/scala/logphy/Lanes.scala 33:19]
  assign rxMBFifo_io_enq_bits_10 = io_mainbandIo_rxData_bits_10; // @[src/main/scala/logphy/Lanes.scala 33:19]
  assign rxMBFifo_io_enq_bits_11 = io_mainbandIo_rxData_bits_11; // @[src/main/scala/logphy/Lanes.scala 33:19]
  assign rxMBFifo_io_enq_bits_12 = io_mainbandIo_rxData_bits_12; // @[src/main/scala/logphy/Lanes.scala 33:19]
  assign rxMBFifo_io_enq_bits_13 = io_mainbandIo_rxData_bits_13; // @[src/main/scala/logphy/Lanes.scala 33:19]
  assign rxMBFifo_io_enq_bits_14 = io_mainbandIo_rxData_bits_14; // @[src/main/scala/logphy/Lanes.scala 33:19]
  assign rxMBFifo_io_enq_bits_15 = io_mainbandIo_rxData_bits_15; // @[src/main/scala/logphy/Lanes.scala 33:19]
  assign rxMBFifo_io_deq_clock = clock; // @[src/main/scala/logphy/Lanes.scala 34:25]
  assign rxMBFifo_io_deq_reset = reset; // @[src/main/scala/logphy/Lanes.scala 35:25]
endmodule
module sidebandOneInTwoOutSwitch_2(
  output         io_outer_node_to_layer_ready, // @[src/main/scala/sideband/sidebandSwitcher.scala 54:14]
  input          io_outer_node_to_layer_valid, // @[src/main/scala/sideband/sidebandSwitcher.scala 54:14]
  input  [127:0] io_outer_node_to_layer_bits, // @[src/main/scala/sideband/sidebandSwitcher.scala 54:14]
  input          io_inner_node_to_layer_ready, // @[src/main/scala/sideband/sidebandSwitcher.scala 54:14]
  output         io_inner_node_to_layer_valid, // @[src/main/scala/sideband/sidebandSwitcher.scala 54:14]
  output [127:0] io_inner_node_to_layer_bits, // @[src/main/scala/sideband/sidebandSwitcher.scala 54:14]
  input          io_node_to_node_ready, // @[src/main/scala/sideband/sidebandSwitcher.scala 54:14]
  output         io_node_to_node_valid, // @[src/main/scala/sideband/sidebandSwitcher.scala 54:14]
  output [127:0] io_node_to_node_bits // @[src/main/scala/sideband/sidebandSwitcher.scala 54:14]
);
  wire  _io_inner_node_to_layer_valid_T_1 = io_outer_node_to_layer_bits[58:56] == 3'h0; // @[src/main/scala/sideband/sidebandSwitcher.scala 61:19]
  wire  _io_node_to_node_valid_T_1 = io_outer_node_to_layer_bits[58:56] != 3'h0; // @[src/main/scala/sideband/sidebandSwitcher.scala 64:19]
  assign io_outer_node_to_layer_ready = _io_inner_node_to_layer_valid_T_1 ? io_inner_node_to_layer_ready :
    io_node_to_node_ready; // @[src/main/scala/sideband/sidebandSwitcher.scala 67:38]
  assign io_inner_node_to_layer_valid = io_outer_node_to_layer_valid & _io_inner_node_to_layer_valid_T_1; // @[src/main/scala/sideband/sidebandSwitcher.scala 60:64]
  assign io_inner_node_to_layer_bits = io_outer_node_to_layer_bits; // @[src/main/scala/sideband/sidebandSwitcher.scala 62:31]
  assign io_node_to_node_valid = io_outer_node_to_layer_valid & _io_node_to_node_valid_T_1; // @[src/main/scala/sideband/sidebandSwitcher.scala 63:57]
  assign io_node_to_node_bits = io_outer_node_to_layer_bits; // @[src/main/scala/sideband/sidebandSwitcher.scala 65:24]
endmodule
module sidebandSwitcher_1(
  input          io_inner_node_to_layer_below_ready, // @[src/main/scala/sideband/sidebandSwitcher.scala 10:14]
  output         io_inner_node_to_layer_below_valid, // @[src/main/scala/sideband/sidebandSwitcher.scala 10:14]
  output [127:0] io_inner_node_to_layer_below_bits, // @[src/main/scala/sideband/sidebandSwitcher.scala 10:14]
  output         io_inner_layer_to_node_below_ready, // @[src/main/scala/sideband/sidebandSwitcher.scala 10:14]
  input          io_inner_layer_to_node_below_valid, // @[src/main/scala/sideband/sidebandSwitcher.scala 10:14]
  input  [127:0] io_inner_layer_to_node_below_bits, // @[src/main/scala/sideband/sidebandSwitcher.scala 10:14]
  output         io_outer_node_to_layer_above_ready, // @[src/main/scala/sideband/sidebandSwitcher.scala 10:14]
  input          io_outer_node_to_layer_above_valid, // @[src/main/scala/sideband/sidebandSwitcher.scala 10:14]
  input  [127:0] io_outer_node_to_layer_above_bits, // @[src/main/scala/sideband/sidebandSwitcher.scala 10:14]
  input          io_outer_layer_to_node_above_ready, // @[src/main/scala/sideband/sidebandSwitcher.scala 10:14]
  output         io_outer_layer_to_node_above_valid, // @[src/main/scala/sideband/sidebandSwitcher.scala 10:14]
  output [127:0] io_outer_layer_to_node_above_bits, // @[src/main/scala/sideband/sidebandSwitcher.scala 10:14]
  output         io_outer_node_to_layer_below_ready, // @[src/main/scala/sideband/sidebandSwitcher.scala 10:14]
  input          io_outer_node_to_layer_below_valid, // @[src/main/scala/sideband/sidebandSwitcher.scala 10:14]
  input  [127:0] io_outer_node_to_layer_below_bits, // @[src/main/scala/sideband/sidebandSwitcher.scala 10:14]
  input          io_outer_layer_to_node_below_ready, // @[src/main/scala/sideband/sidebandSwitcher.scala 10:14]
  output         io_outer_layer_to_node_below_valid, // @[src/main/scala/sideband/sidebandSwitcher.scala 10:14]
  output [127:0] io_outer_layer_to_node_below_bits // @[src/main/scala/sideband/sidebandSwitcher.scala 10:14]
);
  wire  outer_node_to_layer_below_subswitch_io_outer_node_to_layer_ready; // @[src/main/scala/sideband/sidebandSwitcher.scala 19:51]
  wire  outer_node_to_layer_below_subswitch_io_outer_node_to_layer_valid; // @[src/main/scala/sideband/sidebandSwitcher.scala 19:51]
  wire [127:0] outer_node_to_layer_below_subswitch_io_outer_node_to_layer_bits; // @[src/main/scala/sideband/sidebandSwitcher.scala 19:51]
  wire  outer_node_to_layer_below_subswitch_io_inner_node_to_layer_ready; // @[src/main/scala/sideband/sidebandSwitcher.scala 19:51]
  wire  outer_node_to_layer_below_subswitch_io_inner_node_to_layer_valid; // @[src/main/scala/sideband/sidebandSwitcher.scala 19:51]
  wire [127:0] outer_node_to_layer_below_subswitch_io_inner_node_to_layer_bits; // @[src/main/scala/sideband/sidebandSwitcher.scala 19:51]
  wire  outer_node_to_layer_below_subswitch_io_node_to_node_ready; // @[src/main/scala/sideband/sidebandSwitcher.scala 19:51]
  wire  outer_node_to_layer_below_subswitch_io_node_to_node_valid; // @[src/main/scala/sideband/sidebandSwitcher.scala 19:51]
  wire [127:0] outer_node_to_layer_below_subswitch_io_node_to_node_bits; // @[src/main/scala/sideband/sidebandSwitcher.scala 19:51]
  wire  outer_node_to_layer_above_subswitch_io_outer_node_to_layer_ready; // @[src/main/scala/sideband/sidebandSwitcher.scala 22:51]
  wire  outer_node_to_layer_above_subswitch_io_outer_node_to_layer_valid; // @[src/main/scala/sideband/sidebandSwitcher.scala 22:51]
  wire [127:0] outer_node_to_layer_above_subswitch_io_outer_node_to_layer_bits; // @[src/main/scala/sideband/sidebandSwitcher.scala 22:51]
  wire  outer_node_to_layer_above_subswitch_io_inner_node_to_layer_ready; // @[src/main/scala/sideband/sidebandSwitcher.scala 22:51]
  wire  outer_node_to_layer_above_subswitch_io_inner_node_to_layer_valid; // @[src/main/scala/sideband/sidebandSwitcher.scala 22:51]
  wire [127:0] outer_node_to_layer_above_subswitch_io_inner_node_to_layer_bits; // @[src/main/scala/sideband/sidebandSwitcher.scala 22:51]
  wire  outer_node_to_layer_above_subswitch_io_node_to_node_ready; // @[src/main/scala/sideband/sidebandSwitcher.scala 22:51]
  wire  outer_node_to_layer_above_subswitch_io_node_to_node_valid; // @[src/main/scala/sideband/sidebandSwitcher.scala 22:51]
  wire [127:0] outer_node_to_layer_above_subswitch_io_node_to_node_bits; // @[src/main/scala/sideband/sidebandSwitcher.scala 22:51]
  wire  outer_layer_to_node_above_subswitch_io_outer_layer_to_node_ready; // @[src/main/scala/sideband/sidebandSwitcher.scala 35:51]
  wire  outer_layer_to_node_above_subswitch_io_outer_layer_to_node_valid; // @[src/main/scala/sideband/sidebandSwitcher.scala 35:51]
  wire [127:0] outer_layer_to_node_above_subswitch_io_outer_layer_to_node_bits; // @[src/main/scala/sideband/sidebandSwitcher.scala 35:51]
  wire  outer_layer_to_node_above_subswitch_io_inner_layer_to_node_ready; // @[src/main/scala/sideband/sidebandSwitcher.scala 35:51]
  wire  outer_layer_to_node_above_subswitch_io_inner_layer_to_node_valid; // @[src/main/scala/sideband/sidebandSwitcher.scala 35:51]
  wire [127:0] outer_layer_to_node_above_subswitch_io_inner_layer_to_node_bits; // @[src/main/scala/sideband/sidebandSwitcher.scala 35:51]
  wire  outer_layer_to_node_above_subswitch_io_node_to_node_ready; // @[src/main/scala/sideband/sidebandSwitcher.scala 35:51]
  wire  outer_layer_to_node_above_subswitch_io_node_to_node_valid; // @[src/main/scala/sideband/sidebandSwitcher.scala 35:51]
  wire [127:0] outer_layer_to_node_above_subswitch_io_node_to_node_bits; // @[src/main/scala/sideband/sidebandSwitcher.scala 35:51]
  wire  outer_layer_to_node_below_subswitch_io_outer_layer_to_node_ready; // @[src/main/scala/sideband/sidebandSwitcher.scala 38:51]
  wire  outer_layer_to_node_below_subswitch_io_outer_layer_to_node_valid; // @[src/main/scala/sideband/sidebandSwitcher.scala 38:51]
  wire [127:0] outer_layer_to_node_below_subswitch_io_outer_layer_to_node_bits; // @[src/main/scala/sideband/sidebandSwitcher.scala 38:51]
  wire  outer_layer_to_node_below_subswitch_io_inner_layer_to_node_ready; // @[src/main/scala/sideband/sidebandSwitcher.scala 38:51]
  wire  outer_layer_to_node_below_subswitch_io_inner_layer_to_node_valid; // @[src/main/scala/sideband/sidebandSwitcher.scala 38:51]
  wire [127:0] outer_layer_to_node_below_subswitch_io_inner_layer_to_node_bits; // @[src/main/scala/sideband/sidebandSwitcher.scala 38:51]
  wire  outer_layer_to_node_below_subswitch_io_node_to_node_ready; // @[src/main/scala/sideband/sidebandSwitcher.scala 38:51]
  wire  outer_layer_to_node_below_subswitch_io_node_to_node_valid; // @[src/main/scala/sideband/sidebandSwitcher.scala 38:51]
  wire [127:0] outer_layer_to_node_below_subswitch_io_node_to_node_bits; // @[src/main/scala/sideband/sidebandSwitcher.scala 38:51]
  sidebandOneInTwoOutSwitch_2 outer_node_to_layer_below_subswitch ( // @[src/main/scala/sideband/sidebandSwitcher.scala 19:51]
    .io_outer_node_to_layer_ready(outer_node_to_layer_below_subswitch_io_outer_node_to_layer_ready),
    .io_outer_node_to_layer_valid(outer_node_to_layer_below_subswitch_io_outer_node_to_layer_valid),
    .io_outer_node_to_layer_bits(outer_node_to_layer_below_subswitch_io_outer_node_to_layer_bits),
    .io_inner_node_to_layer_ready(outer_node_to_layer_below_subswitch_io_inner_node_to_layer_ready),
    .io_inner_node_to_layer_valid(outer_node_to_layer_below_subswitch_io_inner_node_to_layer_valid),
    .io_inner_node_to_layer_bits(outer_node_to_layer_below_subswitch_io_inner_node_to_layer_bits),
    .io_node_to_node_ready(outer_node_to_layer_below_subswitch_io_node_to_node_ready),
    .io_node_to_node_valid(outer_node_to_layer_below_subswitch_io_node_to_node_valid),
    .io_node_to_node_bits(outer_node_to_layer_below_subswitch_io_node_to_node_bits)
  );
  sidebandOneInTwoOutSwitch_2 outer_node_to_layer_above_subswitch ( // @[src/main/scala/sideband/sidebandSwitcher.scala 22:51]
    .io_outer_node_to_layer_ready(outer_node_to_layer_above_subswitch_io_outer_node_to_layer_ready),
    .io_outer_node_to_layer_valid(outer_node_to_layer_above_subswitch_io_outer_node_to_layer_valid),
    .io_outer_node_to_layer_bits(outer_node_to_layer_above_subswitch_io_outer_node_to_layer_bits),
    .io_inner_node_to_layer_ready(outer_node_to_layer_above_subswitch_io_inner_node_to_layer_ready),
    .io_inner_node_to_layer_valid(outer_node_to_layer_above_subswitch_io_inner_node_to_layer_valid),
    .io_inner_node_to_layer_bits(outer_node_to_layer_above_subswitch_io_inner_node_to_layer_bits),
    .io_node_to_node_ready(outer_node_to_layer_above_subswitch_io_node_to_node_ready),
    .io_node_to_node_valid(outer_node_to_layer_above_subswitch_io_node_to_node_valid),
    .io_node_to_node_bits(outer_node_to_layer_above_subswitch_io_node_to_node_bits)
  );
  sidebandTwoInOneOutSwitch outer_layer_to_node_above_subswitch ( // @[src/main/scala/sideband/sidebandSwitcher.scala 35:51]
    .io_outer_layer_to_node_ready(outer_layer_to_node_above_subswitch_io_outer_layer_to_node_ready),
    .io_outer_layer_to_node_valid(outer_layer_to_node_above_subswitch_io_outer_layer_to_node_valid),
    .io_outer_layer_to_node_bits(outer_layer_to_node_above_subswitch_io_outer_layer_to_node_bits),
    .io_inner_layer_to_node_ready(outer_layer_to_node_above_subswitch_io_inner_layer_to_node_ready),
    .io_inner_layer_to_node_valid(outer_layer_to_node_above_subswitch_io_inner_layer_to_node_valid),
    .io_inner_layer_to_node_bits(outer_layer_to_node_above_subswitch_io_inner_layer_to_node_bits),
    .io_node_to_node_ready(outer_layer_to_node_above_subswitch_io_node_to_node_ready),
    .io_node_to_node_valid(outer_layer_to_node_above_subswitch_io_node_to_node_valid),
    .io_node_to_node_bits(outer_layer_to_node_above_subswitch_io_node_to_node_bits)
  );
  sidebandTwoInOneOutSwitch outer_layer_to_node_below_subswitch ( // @[src/main/scala/sideband/sidebandSwitcher.scala 38:51]
    .io_outer_layer_to_node_ready(outer_layer_to_node_below_subswitch_io_outer_layer_to_node_ready),
    .io_outer_layer_to_node_valid(outer_layer_to_node_below_subswitch_io_outer_layer_to_node_valid),
    .io_outer_layer_to_node_bits(outer_layer_to_node_below_subswitch_io_outer_layer_to_node_bits),
    .io_inner_layer_to_node_ready(outer_layer_to_node_below_subswitch_io_inner_layer_to_node_ready),
    .io_inner_layer_to_node_valid(outer_layer_to_node_below_subswitch_io_inner_layer_to_node_valid),
    .io_inner_layer_to_node_bits(outer_layer_to_node_below_subswitch_io_inner_layer_to_node_bits),
    .io_node_to_node_ready(outer_layer_to_node_below_subswitch_io_node_to_node_ready),
    .io_node_to_node_valid(outer_layer_to_node_below_subswitch_io_node_to_node_valid),
    .io_node_to_node_bits(outer_layer_to_node_below_subswitch_io_node_to_node_bits)
  );
  assign io_inner_node_to_layer_below_valid = outer_node_to_layer_below_subswitch_io_inner_node_to_layer_valid; // @[src/main/scala/sideband/sidebandSwitcher.scala 29:62]
  assign io_inner_node_to_layer_below_bits = outer_node_to_layer_below_subswitch_io_inner_node_to_layer_bits; // @[src/main/scala/sideband/sidebandSwitcher.scala 29:62]
  assign io_inner_layer_to_node_below_ready = outer_layer_to_node_below_subswitch_io_inner_layer_to_node_ready; // @[src/main/scala/sideband/sidebandSwitcher.scala 49:62]
  assign io_outer_node_to_layer_above_ready = outer_node_to_layer_above_subswitch_io_outer_node_to_layer_ready; // @[src/main/scala/sideband/sidebandSwitcher.scala 27:62]
  assign io_outer_layer_to_node_above_valid = outer_layer_to_node_above_subswitch_io_outer_layer_to_node_valid; // @[src/main/scala/sideband/sidebandSwitcher.scala 45:62]
  assign io_outer_layer_to_node_above_bits = outer_layer_to_node_above_subswitch_io_outer_layer_to_node_bits; // @[src/main/scala/sideband/sidebandSwitcher.scala 45:62]
  assign io_outer_node_to_layer_below_ready = outer_node_to_layer_below_subswitch_io_outer_node_to_layer_ready; // @[src/main/scala/sideband/sidebandSwitcher.scala 26:62]
  assign io_outer_layer_to_node_below_valid = outer_layer_to_node_below_subswitch_io_outer_layer_to_node_valid; // @[src/main/scala/sideband/sidebandSwitcher.scala 46:62]
  assign io_outer_layer_to_node_below_bits = outer_layer_to_node_below_subswitch_io_outer_layer_to_node_bits; // @[src/main/scala/sideband/sidebandSwitcher.scala 46:62]
  assign outer_node_to_layer_below_subswitch_io_outer_node_to_layer_valid = io_outer_node_to_layer_below_valid; // @[src/main/scala/sideband/sidebandSwitcher.scala 26:62]
  assign outer_node_to_layer_below_subswitch_io_outer_node_to_layer_bits = io_outer_node_to_layer_below_bits; // @[src/main/scala/sideband/sidebandSwitcher.scala 26:62]
  assign outer_node_to_layer_below_subswitch_io_inner_node_to_layer_ready = io_inner_node_to_layer_below_ready; // @[src/main/scala/sideband/sidebandSwitcher.scala 29:62]
  assign outer_node_to_layer_below_subswitch_io_node_to_node_ready =
    outer_layer_to_node_above_subswitch_io_node_to_node_ready; // @[src/main/scala/sideband/sidebandSwitcher.scala 12:41 42:55]
  assign outer_node_to_layer_above_subswitch_io_outer_node_to_layer_valid = io_outer_node_to_layer_above_valid; // @[src/main/scala/sideband/sidebandSwitcher.scala 27:62]
  assign outer_node_to_layer_above_subswitch_io_outer_node_to_layer_bits = io_outer_node_to_layer_above_bits; // @[src/main/scala/sideband/sidebandSwitcher.scala 27:62]
  assign outer_node_to_layer_above_subswitch_io_inner_node_to_layer_ready = 1'h0; // @[src/main/scala/sideband/sidebandSwitcher.scala 30:62]
  assign outer_node_to_layer_above_subswitch_io_node_to_node_ready =
    outer_layer_to_node_below_subswitch_io_node_to_node_ready; // @[src/main/scala/sideband/sidebandSwitcher.scala 15:41 43:55]
  assign outer_layer_to_node_above_subswitch_io_outer_layer_to_node_ready = io_outer_layer_to_node_above_ready; // @[src/main/scala/sideband/sidebandSwitcher.scala 45:62]
  assign outer_layer_to_node_above_subswitch_io_inner_layer_to_node_valid = 1'h0; // @[src/main/scala/sideband/sidebandSwitcher.scala 48:62]
  assign outer_layer_to_node_above_subswitch_io_inner_layer_to_node_bits = 128'h0; // @[src/main/scala/sideband/sidebandSwitcher.scala 48:62]
  assign outer_layer_to_node_above_subswitch_io_node_to_node_valid =
    outer_node_to_layer_below_subswitch_io_node_to_node_valid; // @[src/main/scala/sideband/sidebandSwitcher.scala 12:41 32:31]
  assign outer_layer_to_node_above_subswitch_io_node_to_node_bits =
    outer_node_to_layer_below_subswitch_io_node_to_node_bits; // @[src/main/scala/sideband/sidebandSwitcher.scala 12:41 32:31]
  assign outer_layer_to_node_below_subswitch_io_outer_layer_to_node_ready = io_outer_layer_to_node_below_ready; // @[src/main/scala/sideband/sidebandSwitcher.scala 46:62]
  assign outer_layer_to_node_below_subswitch_io_inner_layer_to_node_valid = io_inner_layer_to_node_below_valid; // @[src/main/scala/sideband/sidebandSwitcher.scala 49:62]
  assign outer_layer_to_node_below_subswitch_io_inner_layer_to_node_bits = io_inner_layer_to_node_below_bits; // @[src/main/scala/sideband/sidebandSwitcher.scala 49:62]
  assign outer_layer_to_node_below_subswitch_io_node_to_node_valid =
    outer_node_to_layer_above_subswitch_io_node_to_node_valid; // @[src/main/scala/sideband/sidebandSwitcher.scala 15:41 33:31]
  assign outer_layer_to_node_below_subswitch_io_node_to_node_bits =
    outer_node_to_layer_above_subswitch_io_node_to_node_bits; // @[src/main/scala/sideband/sidebandSwitcher.scala 15:41 33:31]
endmodule
module SidebandLinkSerializer(
  input          clock,
  input          reset,
  output         io_in_ready, // @[src/main/scala/sideband/sidebandNode.scala 244:14]
  input          io_in_valid, // @[src/main/scala/sideband/sidebandNode.scala 244:14]
  input  [127:0] io_in_bits, // @[src/main/scala/sideband/sidebandNode.scala 244:14]
  output         io_out_bits, // @[src/main/scala/sideband/sidebandNode.scala 244:14]
  output         io_out_clock // @[src/main/scala/sideband/sidebandNode.scala 244:14]
);
  reg [127:0] data; // @[src/main/scala/sideband/sidebandNode.scala 255:17]
  reg [4:0] counter; // @[src/main/scala/sideband/sidebandNode.scala 259:26]
  reg  done; // @[src/main/scala/sideband/sidebandNode.scala 263:21]
  wire  _T = io_in_ready & io_in_valid; // @[src/main/scala/chisel3/util/Decoupled.scala 52:35]
  wire  _counter_next_T = counter == 5'h1f; // @[src/main/scala/sideband/sidebandNode.scala 260:31]
  wire [4:0] _counter_next_T_2 = counter + 5'h1; // @[src/main/scala/sideband/sidebandNode.scala 260:55]
  reg  sending; // @[src/main/scala/sideband/sidebandNode.scala 262:24]
  reg  waited; // @[src/main/scala/sideband/sidebandNode.scala 264:23]
  reg [6:0] sendCount; // @[src/main/scala/chisel3/util/Counter.scala 61:40]
  wire  wrap_wrap = sendCount == 7'h7f; // @[src/main/scala/chisel3/util/Counter.scala 73:24]
  wire [6:0] _wrap_value_T_1 = sendCount + 7'h1; // @[src/main/scala/chisel3/util/Counter.scala 77:24]
  wire  sendDone = sending & wrap_wrap; // @[src/main/scala/chisel3/util/Counter.scala 118:{16,23} 117:24]
  wire  _GEN_4 = _T | sending; // @[src/main/scala/sideband/sidebandNode.scala 277:20 279:13 262:24]
  wire  _GEN_5 = _T ? 1'h0 : waited; // @[src/main/scala/sideband/sidebandNode.scala 277:20 280:12 264:23]
  wire [127:0] _data_T = {{1'd0}, data[127:1]}; // @[src/main/scala/sideband/sidebandNode.scala 284:32]
  wire  _GEN_9 = sendDone | done; // @[src/main/scala/sideband/sidebandNode.scala 286:18 288:10 263:21]
  wire  _GEN_11 = done ? _counter_next_T : _GEN_5; // @[src/main/scala/sideband/sidebandNode.scala 291:14 293:12]
  assign io_in_ready = waited; // @[src/main/scala/sideband/sidebandNode.scala 269:15]
  assign io_out_bits = data[0]; // @[src/main/scala/sideband/sidebandNode.scala 271:22]
  assign io_out_clock = sending & clock; // @[src/main/scala/sideband/sidebandNode.scala 270:22]
  always @(posedge clock) begin
    if (sending) begin // @[src/main/scala/sideband/sidebandNode.scala 284:17]
      data <= _data_T; // @[src/main/scala/sideband/sidebandNode.scala 284:24]
    end else if (_T) begin // @[src/main/scala/sideband/sidebandNode.scala 277:20]
      data <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 278:10]
    end
    if (reset) begin // @[src/main/scala/sideband/sidebandNode.scala 259:26]
      counter <= 5'h0; // @[src/main/scala/sideband/sidebandNode.scala 259:26]
    end else if (done) begin // @[src/main/scala/sideband/sidebandNode.scala 259:26]
      if (_T) begin // @[src/main/scala/sideband/sidebandNode.scala 277:20]
        counter <= 5'h0; // @[src/main/scala/sideband/sidebandNode.scala 281:18]
      end else if (counter == 5'h1f) begin // @[src/main/scala/sideband/sidebandNode.scala 260:22]
        counter <= 5'h1f;
      end else begin
        counter <= _counter_next_T_2;
      end
    end
    if (reset) begin // @[src/main/scala/sideband/sidebandNode.scala 263:21]
      done <= 1'h0; // @[src/main/scala/sideband/sidebandNode.scala 263:21]
    end else begin
      done <= _GEN_9;
    end
    if (reset) begin // @[src/main/scala/sideband/sidebandNode.scala 262:24]
      sending <= 1'h0; // @[src/main/scala/sideband/sidebandNode.scala 262:24]
    end else if (sendDone) begin // @[src/main/scala/sideband/sidebandNode.scala 286:18]
      sending <= 1'h0; // @[src/main/scala/sideband/sidebandNode.scala 287:13]
    end else begin
      sending <= _GEN_4;
    end
    waited <= reset | _GEN_11; // @[src/main/scala/sideband/sidebandNode.scala 264:{23,23}]
    if (reset) begin // @[src/main/scala/chisel3/util/Counter.scala 61:40]
      sendCount <= 7'h0; // @[src/main/scala/chisel3/util/Counter.scala 61:40]
    end else if (sending) begin // @[src/main/scala/chisel3/util/Counter.scala 118:16]
      sendCount <= _wrap_value_T_1; // @[src/main/scala/chisel3/util/Counter.scala 77:15]
    end
  end
endmodule
module SidebandLinkDeserializer(
  input          clock,
  input          reset,
  input          io_in_bits, // @[src/main/scala/sideband/sidebandNode.scala 303:14]
  input          io_in_remote_clock, // @[src/main/scala/sideband/sidebandNode.scala 303:14]
  input          io_out_ready, // @[src/main/scala/sideband/sidebandNode.scala 303:14]
  output         io_out_valid, // @[src/main/scala/sideband/sidebandNode.scala 303:14]
  output [127:0] io_out_bits // @[src/main/scala/sideband/sidebandNode.scala 303:14]
);
  reg  data_0; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_1; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_2; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_3; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_4; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_5; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_6; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_7; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_8; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_9; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_10; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_11; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_12; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_13; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_14; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_15; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_16; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_17; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_18; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_19; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_20; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_21; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_22; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_23; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_24; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_25; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_26; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_27; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_28; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_29; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_30; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_31; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_32; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_33; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_34; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_35; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_36; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_37; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_38; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_39; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_40; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_41; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_42; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_43; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_44; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_45; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_46; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_47; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_48; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_49; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_50; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_51; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_52; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_53; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_54; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_55; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_56; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_57; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_58; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_59; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_60; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_61; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_62; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_63; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_64; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_65; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_66; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_67; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_68; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_69; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_70; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_71; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_72; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_73; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_74; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_75; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_76; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_77; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_78; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_79; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_80; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_81; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_82; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_83; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_84; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_85; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_86; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_87; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_88; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_89; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_90; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_91; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_92; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_93; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_94; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_95; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_96; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_97; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_98; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_99; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_100; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_101; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_102; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_103; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_104; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_105; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_106; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_107; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_108; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_109; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_110; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_111; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_112; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_113; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_114; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_115; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_116; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_117; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_118; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_119; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_120; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_121; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_122; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_123; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_124; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_125; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_126; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  data_127; // @[src/main/scala/sideband/sidebandNode.scala 315:17]
  reg  receiving; // @[src/main/scala/sideband/sidebandNode.scala 317:26]
  reg [6:0] recvCount; // @[src/main/scala/chisel3/util/Counter.scala 61:40]
  wire  wrap_wrap = recvCount == 7'h7f; // @[src/main/scala/chisel3/util/Counter.scala 73:24]
  wire [6:0] _wrap_value_T_1 = recvCount + 7'h1; // @[src/main/scala/chisel3/util/Counter.scala 77:24]
  reg [6:0] recvCount_delay; // @[src/main/scala/sideband/sidebandNode.scala 323:34]
  wire  _GEN_130 = wrap_wrap ? 1'h0 : receiving; // @[src/main/scala/sideband/sidebandNode.scala 327:20 317:26 327:32]
  wire  _T = io_out_ready & io_out_valid; // @[src/main/scala/chisel3/util/Decoupled.scala 52:35]
  wire  _GEN_131 = _T | _GEN_130; // @[src/main/scala/sideband/sidebandNode.scala 328:{23,35}]
  wire [7:0] io_out_bits_lo_lo_lo_lo = {data_7,data_6,data_5,data_4,data_3,data_2,data_1,data_0}; // @[src/main/scala/sideband/sidebandNode.scala 331:25]
  wire [15:0] io_out_bits_lo_lo_lo = {data_15,data_14,data_13,data_12,data_11,data_10,data_9,data_8,
    io_out_bits_lo_lo_lo_lo}; // @[src/main/scala/sideband/sidebandNode.scala 331:25]
  wire [7:0] io_out_bits_lo_lo_hi_lo = {data_23,data_22,data_21,data_20,data_19,data_18,data_17,data_16}; // @[src/main/scala/sideband/sidebandNode.scala 331:25]
  wire [31:0] io_out_bits_lo_lo = {data_31,data_30,data_29,data_28,data_27,data_26,data_25,data_24,
    io_out_bits_lo_lo_hi_lo,io_out_bits_lo_lo_lo}; // @[src/main/scala/sideband/sidebandNode.scala 331:25]
  wire [7:0] io_out_bits_lo_hi_lo_lo = {data_39,data_38,data_37,data_36,data_35,data_34,data_33,data_32}; // @[src/main/scala/sideband/sidebandNode.scala 331:25]
  wire [15:0] io_out_bits_lo_hi_lo = {data_47,data_46,data_45,data_44,data_43,data_42,data_41,data_40,
    io_out_bits_lo_hi_lo_lo}; // @[src/main/scala/sideband/sidebandNode.scala 331:25]
  wire [7:0] io_out_bits_lo_hi_hi_lo = {data_55,data_54,data_53,data_52,data_51,data_50,data_49,data_48}; // @[src/main/scala/sideband/sidebandNode.scala 331:25]
  wire [31:0] io_out_bits_lo_hi = {data_63,data_62,data_61,data_60,data_59,data_58,data_57,data_56,
    io_out_bits_lo_hi_hi_lo,io_out_bits_lo_hi_lo}; // @[src/main/scala/sideband/sidebandNode.scala 331:25]
  wire [63:0] io_out_bits_lo = {io_out_bits_lo_hi,io_out_bits_lo_lo}; // @[src/main/scala/sideband/sidebandNode.scala 331:25]
  wire [7:0] io_out_bits_hi_lo_lo_lo = {data_71,data_70,data_69,data_68,data_67,data_66,data_65,data_64}; // @[src/main/scala/sideband/sidebandNode.scala 331:25]
  wire [15:0] io_out_bits_hi_lo_lo = {data_79,data_78,data_77,data_76,data_75,data_74,data_73,data_72,
    io_out_bits_hi_lo_lo_lo}; // @[src/main/scala/sideband/sidebandNode.scala 331:25]
  wire [7:0] io_out_bits_hi_lo_hi_lo = {data_87,data_86,data_85,data_84,data_83,data_82,data_81,data_80}; // @[src/main/scala/sideband/sidebandNode.scala 331:25]
  wire [31:0] io_out_bits_hi_lo = {data_95,data_94,data_93,data_92,data_91,data_90,data_89,data_88,
    io_out_bits_hi_lo_hi_lo,io_out_bits_hi_lo_lo}; // @[src/main/scala/sideband/sidebandNode.scala 331:25]
  wire [7:0] io_out_bits_hi_hi_lo_lo = {data_103,data_102,data_101,data_100,data_99,data_98,data_97,data_96}; // @[src/main/scala/sideband/sidebandNode.scala 331:25]
  wire [15:0] io_out_bits_hi_hi_lo = {data_111,data_110,data_109,data_108,data_107,data_106,data_105,data_104,
    io_out_bits_hi_hi_lo_lo}; // @[src/main/scala/sideband/sidebandNode.scala 331:25]
  wire [7:0] io_out_bits_hi_hi_hi_lo = {data_119,data_118,data_117,data_116,data_115,data_114,data_113,data_112}; // @[src/main/scala/sideband/sidebandNode.scala 331:25]
  wire [31:0] io_out_bits_hi_hi = {data_127,data_126,data_125,data_124,data_123,data_122,data_121,data_120,
    io_out_bits_hi_hi_hi_lo,io_out_bits_hi_hi_lo}; // @[src/main/scala/sideband/sidebandNode.scala 331:25]
  wire [63:0] io_out_bits_hi = {io_out_bits_hi_hi,io_out_bits_hi_lo}; // @[src/main/scala/sideband/sidebandNode.scala 331:25]
  assign io_out_valid = ~receiving; // @[src/main/scala/sideband/sidebandNode.scala 329:21]
  assign io_out_bits = {io_out_bits_hi,io_out_bits_lo}; // @[src/main/scala/sideband/sidebandNode.scala 331:25]
  always @(posedge clock) begin
    if (7'h0 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_0 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h1 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_1 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h2 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_2 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h3 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_3 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h4 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_4 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h5 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_5 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h6 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_6 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h7 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_7 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h8 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_8 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h9 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_9 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'ha == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_10 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'hb == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_11 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'hc == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_12 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'hd == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_13 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'he == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_14 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'hf == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_15 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h10 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_16 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h11 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_17 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h12 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_18 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h13 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_19 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h14 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_20 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h15 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_21 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h16 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_22 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h17 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_23 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h18 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_24 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h19 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_25 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h1a == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_26 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h1b == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_27 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h1c == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_28 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h1d == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_29 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h1e == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_30 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h1f == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_31 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h20 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_32 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h21 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_33 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h22 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_34 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h23 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_35 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h24 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_36 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h25 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_37 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h26 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_38 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h27 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_39 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h28 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_40 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h29 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_41 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h2a == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_42 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h2b == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_43 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h2c == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_44 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h2d == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_45 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h2e == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_46 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h2f == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_47 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h30 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_48 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h31 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_49 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h32 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_50 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h33 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_51 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h34 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_52 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h35 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_53 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h36 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_54 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h37 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_55 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h38 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_56 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h39 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_57 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h3a == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_58 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h3b == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_59 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h3c == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_60 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h3d == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_61 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h3e == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_62 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h3f == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_63 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h40 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_64 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h41 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_65 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h42 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_66 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h43 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_67 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h44 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_68 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h45 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_69 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h46 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_70 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h47 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_71 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h48 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_72 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h49 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_73 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h4a == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_74 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h4b == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_75 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h4c == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_76 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h4d == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_77 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h4e == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_78 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h4f == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_79 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h50 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_80 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h51 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_81 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h52 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_82 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h53 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_83 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h54 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_84 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h55 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_85 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h56 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_86 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h57 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_87 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h58 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_88 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h59 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_89 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h5a == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_90 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h5b == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_91 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h5c == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_92 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h5d == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_93 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h5e == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_94 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h5f == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_95 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h60 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_96 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h61 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_97 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h62 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_98 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h63 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_99 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h64 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_100 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h65 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_101 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h66 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_102 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h67 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_103 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h68 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_104 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h69 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_105 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h6a == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_106 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h6b == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_107 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h6c == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_108 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h6d == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_109 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h6e == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_110 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h6f == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_111 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h70 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_112 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h71 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_113 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h72 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_114 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h73 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_115 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h74 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_116 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h75 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_117 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h76 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_118 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h77 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_119 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h78 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_120 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h79 == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_121 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h7a == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_122 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h7b == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_123 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h7c == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_124 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h7d == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_125 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h7e == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_126 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    if (7'h7f == recvCount_delay) begin // @[src/main/scala/sideband/sidebandNode.scala 326:27]
      data_127 <= io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 326:27]
    end
    receiving <= reset | _GEN_131; // @[src/main/scala/sideband/sidebandNode.scala 317:{26,26}]
  end
  always @(posedge io_in_remote_clock) begin
    if (reset) begin // @[src/main/scala/chisel3/util/Counter.scala 61:40]
      recvCount <= 7'h0; // @[src/main/scala/chisel3/util/Counter.scala 61:40]
    end else begin
      recvCount <= _wrap_value_T_1;
    end
    if (reset) begin // @[src/main/scala/sideband/sidebandNode.scala 323:34]
      recvCount_delay <= 7'h0; // @[src/main/scala/sideband/sidebandNode.scala 323:34]
    end else begin
      recvCount_delay <= recvCount; // @[src/main/scala/sideband/sidebandNode.scala 324:21]
    end
  end
endmodule
module SidebandLinkNode(
  input          clock,
  input          reset,
  input          io_rxMode, // @[src/main/scala/sideband/sidebandNode.scala 22:14]
  output         io_inner_layer_to_node_ready, // @[src/main/scala/sideband/sidebandNode.scala 22:14]
  input          io_inner_layer_to_node_valid, // @[src/main/scala/sideband/sidebandNode.scala 22:14]
  input  [127:0] io_inner_layer_to_node_bits, // @[src/main/scala/sideband/sidebandNode.scala 22:14]
  input          io_inner_node_to_layer_ready, // @[src/main/scala/sideband/sidebandNode.scala 22:14]
  output         io_inner_node_to_layer_valid, // @[src/main/scala/sideband/sidebandNode.scala 22:14]
  output [127:0] io_inner_node_to_layer_bits, // @[src/main/scala/sideband/sidebandNode.scala 22:14]
  output         io_outer_tx_bits, // @[src/main/scala/sideband/sidebandNode.scala 22:14]
  output         io_outer_tx_clock, // @[src/main/scala/sideband/sidebandNode.scala 22:14]
  input          io_outer_rx_bits, // @[src/main/scala/sideband/sidebandNode.scala 22:14]
  input          io_outer_rx_clock // @[src/main/scala/sideband/sidebandNode.scala 22:14]
);
  wire  tx_ser_clock; // @[src/main/scala/sideband/sidebandNode.scala 24:22]
  wire  tx_ser_reset; // @[src/main/scala/sideband/sidebandNode.scala 24:22]
  wire  tx_ser_io_in_ready; // @[src/main/scala/sideband/sidebandNode.scala 24:22]
  wire  tx_ser_io_in_valid; // @[src/main/scala/sideband/sidebandNode.scala 24:22]
  wire [127:0] tx_ser_io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 24:22]
  wire  tx_ser_io_out_bits; // @[src/main/scala/sideband/sidebandNode.scala 24:22]
  wire  tx_ser_io_out_clock; // @[src/main/scala/sideband/sidebandNode.scala 24:22]
  wire  rx_des_clock; // @[src/main/scala/sideband/sidebandNode.scala 25:22]
  wire  rx_des_reset; // @[src/main/scala/sideband/sidebandNode.scala 25:22]
  wire  rx_des_io_in_bits; // @[src/main/scala/sideband/sidebandNode.scala 25:22]
  wire  rx_des_io_in_remote_clock; // @[src/main/scala/sideband/sidebandNode.scala 25:22]
  wire  rx_des_io_out_ready; // @[src/main/scala/sideband/sidebandNode.scala 25:22]
  wire  rx_des_io_out_valid; // @[src/main/scala/sideband/sidebandNode.scala 25:22]
  wire [127:0] rx_des_io_out_bits; // @[src/main/scala/sideband/sidebandNode.scala 25:22]
  wire  rx_queue_clock; // @[src/main/scala/sideband/sidebandNode.scala 26:24]
  wire  rx_queue_reset; // @[src/main/scala/sideband/sidebandNode.scala 26:24]
  wire  rx_queue_io_enq_valid; // @[src/main/scala/sideband/sidebandNode.scala 26:24]
  wire [127:0] rx_queue_io_enq_bits; // @[src/main/scala/sideband/sidebandNode.scala 26:24]
  wire  rx_queue_io_deq_ready; // @[src/main/scala/sideband/sidebandNode.scala 26:24]
  wire  rx_queue_io_deq_valid; // @[src/main/scala/sideband/sidebandNode.scala 26:24]
  wire [127:0] rx_queue_io_deq_bits; // @[src/main/scala/sideband/sidebandNode.scala 26:24]
  wire [69:0] tx_ser_io_in_bits_hi = {io_inner_layer_to_node_bits[127:59],1'h0}; // @[src/main/scala/sideband/sidebandNode.scala 39:27]
  SidebandLinkSerializer tx_ser ( // @[src/main/scala/sideband/sidebandNode.scala 24:22]
    .clock(tx_ser_clock),
    .reset(tx_ser_reset),
    .io_in_ready(tx_ser_io_in_ready),
    .io_in_valid(tx_ser_io_in_valid),
    .io_in_bits(tx_ser_io_in_bits),
    .io_out_bits(tx_ser_io_out_bits),
    .io_out_clock(tx_ser_io_out_clock)
  );
  SidebandLinkDeserializer rx_des ( // @[src/main/scala/sideband/sidebandNode.scala 25:22]
    .clock(rx_des_clock),
    .reset(rx_des_reset),
    .io_in_bits(rx_des_io_in_bits),
    .io_in_remote_clock(rx_des_io_in_remote_clock),
    .io_out_ready(rx_des_io_out_ready),
    .io_out_valid(rx_des_io_out_valid),
    .io_out_bits(rx_des_io_out_bits)
  );
  SidebandPriorityQueue rx_queue ( // @[src/main/scala/sideband/sidebandNode.scala 26:24]
    .clock(rx_queue_clock),
    .reset(rx_queue_reset),
    .io_enq_valid(rx_queue_io_enq_valid),
    .io_enq_bits(rx_queue_io_enq_bits),
    .io_deq_ready(rx_queue_io_deq_ready),
    .io_deq_valid(rx_queue_io_deq_valid),
    .io_deq_bits(rx_queue_io_deq_bits)
  );
  assign io_inner_layer_to_node_ready = tx_ser_io_in_ready; // @[src/main/scala/sideband/sidebandNode.scala 37:32]
  assign io_inner_node_to_layer_valid = io_rxMode ? rx_queue_io_deq_valid : rx_des_io_out_valid; // @[src/main/scala/sideband/sidebandNode.scala 46:39 47:28 51:28]
  assign io_inner_node_to_layer_bits = io_rxMode ? rx_queue_io_deq_bits : rx_des_io_out_bits; // @[src/main/scala/sideband/sidebandNode.scala 46:39 47:28 51:28]
  assign io_outer_tx_bits = tx_ser_io_out_bits; // @[src/main/scala/sideband/sidebandNode.scala 29:15]
  assign io_outer_tx_clock = tx_ser_io_out_clock; // @[src/main/scala/sideband/sidebandNode.scala 29:15]
  assign tx_ser_clock = clock;
  assign tx_ser_reset = reset;
  assign tx_ser_io_in_valid = io_inner_layer_to_node_valid; // @[src/main/scala/sideband/sidebandNode.scala 44:22]
  assign tx_ser_io_in_bits = {tx_ser_io_in_bits_hi,io_inner_layer_to_node_bits[57:0]}; // @[src/main/scala/sideband/sidebandNode.scala 39:27]
  assign rx_des_clock = clock;
  assign rx_des_reset = reset;
  assign rx_des_io_in_bits = io_outer_rx_bits; // @[src/main/scala/sideband/sidebandNode.scala 31:20]
  assign rx_des_io_in_remote_clock = io_outer_rx_clock; // @[src/main/scala/sideband/sidebandNode.scala 30:21]
  assign rx_des_io_out_ready = io_rxMode | io_inner_node_to_layer_ready; // @[src/main/scala/sideband/sidebandNode.scala 34:19 46:39 51:28]
  assign rx_queue_clock = clock;
  assign rx_queue_reset = reset;
  assign rx_queue_io_enq_valid = io_rxMode & rx_des_io_out_valid; // @[src/main/scala/sideband/sidebandNode.scala 34:19 46:39 src/main/scala/chisel3/util/Decoupled.scala 74:20]
  assign rx_queue_io_enq_bits = rx_des_io_out_bits; // @[src/main/scala/sideband/sidebandNode.scala 34:19 46:39]
  assign rx_queue_io_deq_ready = io_rxMode & io_inner_node_to_layer_ready; // @[src/main/scala/sideband/sidebandNode.scala 46:39 47:28 src/main/scala/chisel3/util/Decoupled.scala 90:20]
endmodule
module PHYSidebandChannel(
  input          clock,
  input          reset,
  output [127:0] io_to_upper_layer_tx_bits, // @[src/main/scala/sideband/sidebandChannel.scala 39:14]
  output         io_to_upper_layer_tx_valid, // @[src/main/scala/sideband/sidebandChannel.scala 39:14]
  input          io_to_upper_layer_tx_credit, // @[src/main/scala/sideband/sidebandChannel.scala 39:14]
  input  [127:0] io_to_upper_layer_rx_bits, // @[src/main/scala/sideband/sidebandChannel.scala 39:14]
  input          io_to_upper_layer_rx_valid, // @[src/main/scala/sideband/sidebandChannel.scala 39:14]
  output         io_to_upper_layer_rx_credit, // @[src/main/scala/sideband/sidebandChannel.scala 39:14]
  output         io_to_lower_layer_tx_bits, // @[src/main/scala/sideband/sidebandChannel.scala 39:14]
  output         io_to_lower_layer_tx_clock, // @[src/main/scala/sideband/sidebandChannel.scala 39:14]
  input          io_to_lower_layer_rx_bits, // @[src/main/scala/sideband/sidebandChannel.scala 39:14]
  input          io_to_lower_layer_rx_clock, // @[src/main/scala/sideband/sidebandChannel.scala 39:14]
  input          io_inner_inputMode, // @[src/main/scala/sideband/sidebandChannel.scala 39:14]
  input          io_inner_rxMode, // @[src/main/scala/sideband/sidebandChannel.scala 39:14]
  output         io_inner_rawInput_ready, // @[src/main/scala/sideband/sidebandChannel.scala 39:14]
  input          io_inner_rawInput_valid, // @[src/main/scala/sideband/sidebandChannel.scala 39:14]
  input  [127:0] io_inner_rawInput_bits, // @[src/main/scala/sideband/sidebandChannel.scala 39:14]
  input          io_inner_switcherBundle_node_to_layer_below_ready, // @[src/main/scala/sideband/sidebandChannel.scala 39:14]
  output         io_inner_switcherBundle_node_to_layer_below_valid, // @[src/main/scala/sideband/sidebandChannel.scala 39:14]
  output [127:0] io_inner_switcherBundle_node_to_layer_below_bits, // @[src/main/scala/sideband/sidebandChannel.scala 39:14]
  output         io_inner_switcherBundle_layer_to_node_below_ready, // @[src/main/scala/sideband/sidebandChannel.scala 39:14]
  input          io_inner_switcherBundle_layer_to_node_below_valid, // @[src/main/scala/sideband/sidebandChannel.scala 39:14]
  input  [127:0] io_inner_switcherBundle_layer_to_node_below_bits // @[src/main/scala/sideband/sidebandChannel.scala 39:14]
);
  wire  upper_node_clock; // @[src/main/scala/sideband/sidebandChannel.scala 42:26]
  wire  upper_node_reset; // @[src/main/scala/sideband/sidebandChannel.scala 42:26]
  wire  upper_node_io_inner_layer_to_node_ready; // @[src/main/scala/sideband/sidebandChannel.scala 42:26]
  wire  upper_node_io_inner_layer_to_node_valid; // @[src/main/scala/sideband/sidebandChannel.scala 42:26]
  wire [127:0] upper_node_io_inner_layer_to_node_bits; // @[src/main/scala/sideband/sidebandChannel.scala 42:26]
  wire  upper_node_io_inner_node_to_layer_ready; // @[src/main/scala/sideband/sidebandChannel.scala 42:26]
  wire  upper_node_io_inner_node_to_layer_valid; // @[src/main/scala/sideband/sidebandChannel.scala 42:26]
  wire [127:0] upper_node_io_inner_node_to_layer_bits; // @[src/main/scala/sideband/sidebandChannel.scala 42:26]
  wire [127:0] upper_node_io_outer_tx_bits; // @[src/main/scala/sideband/sidebandChannel.scala 42:26]
  wire  upper_node_io_outer_tx_valid; // @[src/main/scala/sideband/sidebandChannel.scala 42:26]
  wire  upper_node_io_outer_tx_credit; // @[src/main/scala/sideband/sidebandChannel.scala 42:26]
  wire [127:0] upper_node_io_outer_rx_bits; // @[src/main/scala/sideband/sidebandChannel.scala 42:26]
  wire  upper_node_io_outer_rx_valid; // @[src/main/scala/sideband/sidebandChannel.scala 42:26]
  wire  upper_node_io_outer_rx_credit; // @[src/main/scala/sideband/sidebandChannel.scala 42:26]
  wire  switcher_io_inner_node_to_layer_below_ready; // @[src/main/scala/sideband/sidebandChannel.scala 43:24]
  wire  switcher_io_inner_node_to_layer_below_valid; // @[src/main/scala/sideband/sidebandChannel.scala 43:24]
  wire [127:0] switcher_io_inner_node_to_layer_below_bits; // @[src/main/scala/sideband/sidebandChannel.scala 43:24]
  wire  switcher_io_inner_layer_to_node_below_ready; // @[src/main/scala/sideband/sidebandChannel.scala 43:24]
  wire  switcher_io_inner_layer_to_node_below_valid; // @[src/main/scala/sideband/sidebandChannel.scala 43:24]
  wire [127:0] switcher_io_inner_layer_to_node_below_bits; // @[src/main/scala/sideband/sidebandChannel.scala 43:24]
  wire  switcher_io_outer_node_to_layer_above_ready; // @[src/main/scala/sideband/sidebandChannel.scala 43:24]
  wire  switcher_io_outer_node_to_layer_above_valid; // @[src/main/scala/sideband/sidebandChannel.scala 43:24]
  wire [127:0] switcher_io_outer_node_to_layer_above_bits; // @[src/main/scala/sideband/sidebandChannel.scala 43:24]
  wire  switcher_io_outer_layer_to_node_above_ready; // @[src/main/scala/sideband/sidebandChannel.scala 43:24]
  wire  switcher_io_outer_layer_to_node_above_valid; // @[src/main/scala/sideband/sidebandChannel.scala 43:24]
  wire [127:0] switcher_io_outer_layer_to_node_above_bits; // @[src/main/scala/sideband/sidebandChannel.scala 43:24]
  wire  switcher_io_outer_node_to_layer_below_ready; // @[src/main/scala/sideband/sidebandChannel.scala 43:24]
  wire  switcher_io_outer_node_to_layer_below_valid; // @[src/main/scala/sideband/sidebandChannel.scala 43:24]
  wire [127:0] switcher_io_outer_node_to_layer_below_bits; // @[src/main/scala/sideband/sidebandChannel.scala 43:24]
  wire  switcher_io_outer_layer_to_node_below_ready; // @[src/main/scala/sideband/sidebandChannel.scala 43:24]
  wire  switcher_io_outer_layer_to_node_below_valid; // @[src/main/scala/sideband/sidebandChannel.scala 43:24]
  wire [127:0] switcher_io_outer_layer_to_node_below_bits; // @[src/main/scala/sideband/sidebandChannel.scala 43:24]
  wire  lower_node_clock; // @[src/main/scala/sideband/sidebandChannel.scala 44:26]
  wire  lower_node_reset; // @[src/main/scala/sideband/sidebandChannel.scala 44:26]
  wire  lower_node_io_rxMode; // @[src/main/scala/sideband/sidebandChannel.scala 44:26]
  wire  lower_node_io_inner_layer_to_node_ready; // @[src/main/scala/sideband/sidebandChannel.scala 44:26]
  wire  lower_node_io_inner_layer_to_node_valid; // @[src/main/scala/sideband/sidebandChannel.scala 44:26]
  wire [127:0] lower_node_io_inner_layer_to_node_bits; // @[src/main/scala/sideband/sidebandChannel.scala 44:26]
  wire  lower_node_io_inner_node_to_layer_ready; // @[src/main/scala/sideband/sidebandChannel.scala 44:26]
  wire  lower_node_io_inner_node_to_layer_valid; // @[src/main/scala/sideband/sidebandChannel.scala 44:26]
  wire [127:0] lower_node_io_inner_node_to_layer_bits; // @[src/main/scala/sideband/sidebandChannel.scala 44:26]
  wire  lower_node_io_outer_tx_bits; // @[src/main/scala/sideband/sidebandChannel.scala 44:26]
  wire  lower_node_io_outer_tx_clock; // @[src/main/scala/sideband/sidebandChannel.scala 44:26]
  wire  lower_node_io_outer_rx_bits; // @[src/main/scala/sideband/sidebandChannel.scala 44:26]
  wire  lower_node_io_outer_rx_clock; // @[src/main/scala/sideband/sidebandChannel.scala 44:26]
  SidebandNode upper_node ( // @[src/main/scala/sideband/sidebandChannel.scala 42:26]
    .clock(upper_node_clock),
    .reset(upper_node_reset),
    .io_inner_layer_to_node_ready(upper_node_io_inner_layer_to_node_ready),
    .io_inner_layer_to_node_valid(upper_node_io_inner_layer_to_node_valid),
    .io_inner_layer_to_node_bits(upper_node_io_inner_layer_to_node_bits),
    .io_inner_node_to_layer_ready(upper_node_io_inner_node_to_layer_ready),
    .io_inner_node_to_layer_valid(upper_node_io_inner_node_to_layer_valid),
    .io_inner_node_to_layer_bits(upper_node_io_inner_node_to_layer_bits),
    .io_outer_tx_bits(upper_node_io_outer_tx_bits),
    .io_outer_tx_valid(upper_node_io_outer_tx_valid),
    .io_outer_tx_credit(upper_node_io_outer_tx_credit),
    .io_outer_rx_bits(upper_node_io_outer_rx_bits),
    .io_outer_rx_valid(upper_node_io_outer_rx_valid),
    .io_outer_rx_credit(upper_node_io_outer_rx_credit)
  );
  sidebandSwitcher_1 switcher ( // @[src/main/scala/sideband/sidebandChannel.scala 43:24]
    .io_inner_node_to_layer_below_ready(switcher_io_inner_node_to_layer_below_ready),
    .io_inner_node_to_layer_below_valid(switcher_io_inner_node_to_layer_below_valid),
    .io_inner_node_to_layer_below_bits(switcher_io_inner_node_to_layer_below_bits),
    .io_inner_layer_to_node_below_ready(switcher_io_inner_layer_to_node_below_ready),
    .io_inner_layer_to_node_below_valid(switcher_io_inner_layer_to_node_below_valid),
    .io_inner_layer_to_node_below_bits(switcher_io_inner_layer_to_node_below_bits),
    .io_outer_node_to_layer_above_ready(switcher_io_outer_node_to_layer_above_ready),
    .io_outer_node_to_layer_above_valid(switcher_io_outer_node_to_layer_above_valid),
    .io_outer_node_to_layer_above_bits(switcher_io_outer_node_to_layer_above_bits),
    .io_outer_layer_to_node_above_ready(switcher_io_outer_layer_to_node_above_ready),
    .io_outer_layer_to_node_above_valid(switcher_io_outer_layer_to_node_above_valid),
    .io_outer_layer_to_node_above_bits(switcher_io_outer_layer_to_node_above_bits),
    .io_outer_node_to_layer_below_ready(switcher_io_outer_node_to_layer_below_ready),
    .io_outer_node_to_layer_below_valid(switcher_io_outer_node_to_layer_below_valid),
    .io_outer_node_to_layer_below_bits(switcher_io_outer_node_to_layer_below_bits),
    .io_outer_layer_to_node_below_ready(switcher_io_outer_layer_to_node_below_ready),
    .io_outer_layer_to_node_below_valid(switcher_io_outer_layer_to_node_below_valid),
    .io_outer_layer_to_node_below_bits(switcher_io_outer_layer_to_node_below_bits)
  );
  SidebandLinkNode lower_node ( // @[src/main/scala/sideband/sidebandChannel.scala 44:26]
    .clock(lower_node_clock),
    .reset(lower_node_reset),
    .io_rxMode(lower_node_io_rxMode),
    .io_inner_layer_to_node_ready(lower_node_io_inner_layer_to_node_ready),
    .io_inner_layer_to_node_valid(lower_node_io_inner_layer_to_node_valid),
    .io_inner_layer_to_node_bits(lower_node_io_inner_layer_to_node_bits),
    .io_inner_node_to_layer_ready(lower_node_io_inner_node_to_layer_ready),
    .io_inner_node_to_layer_valid(lower_node_io_inner_node_to_layer_valid),
    .io_inner_node_to_layer_bits(lower_node_io_inner_node_to_layer_bits),
    .io_outer_tx_bits(lower_node_io_outer_tx_bits),
    .io_outer_tx_clock(lower_node_io_outer_tx_clock),
    .io_outer_rx_bits(lower_node_io_outer_rx_bits),
    .io_outer_rx_clock(lower_node_io_outer_rx_clock)
  );
  assign io_to_upper_layer_tx_bits = upper_node_io_outer_tx_bits; // @[src/main/scala/sideband/sidebandChannel.scala 47:21]
  assign io_to_upper_layer_tx_valid = upper_node_io_outer_tx_valid; // @[src/main/scala/sideband/sidebandChannel.scala 47:21]
  assign io_to_upper_layer_rx_credit = upper_node_io_outer_rx_credit; // @[src/main/scala/sideband/sidebandChannel.scala 47:21]
  assign io_to_lower_layer_tx_bits = lower_node_io_outer_tx_bits; // @[src/main/scala/sideband/sidebandChannel.scala 48:21]
  assign io_to_lower_layer_tx_clock = lower_node_io_outer_tx_clock; // @[src/main/scala/sideband/sidebandChannel.scala 48:21]
  assign io_inner_rawInput_ready = io_inner_inputMode ? 1'h0 : lower_node_io_inner_layer_to_node_ready; // @[src/main/scala/sideband/sidebandChannel.scala 53:48 src/main/scala/chisel3/util/Decoupled.scala 90:20 src/main/scala/sideband/sidebandChannel.scala 58:39]
  assign io_inner_switcherBundle_node_to_layer_below_valid = switcher_io_inner_node_to_layer_below_valid; // @[src/main/scala/sideband/sidebandChannel.scala 64:27]
  assign io_inner_switcherBundle_node_to_layer_below_bits = switcher_io_inner_node_to_layer_below_bits; // @[src/main/scala/sideband/sidebandChannel.scala 64:27]
  assign io_inner_switcherBundle_layer_to_node_below_ready = switcher_io_inner_layer_to_node_below_ready; // @[src/main/scala/sideband/sidebandChannel.scala 64:27]
  assign upper_node_clock = clock;
  assign upper_node_reset = reset;
  assign upper_node_io_inner_layer_to_node_valid = switcher_io_outer_layer_to_node_above_valid; // @[src/main/scala/sideband/sidebandChannel.scala 51:37]
  assign upper_node_io_inner_layer_to_node_bits = switcher_io_outer_layer_to_node_above_bits; // @[src/main/scala/sideband/sidebandChannel.scala 51:37]
  assign upper_node_io_inner_node_to_layer_ready = switcher_io_outer_node_to_layer_above_ready; // @[src/main/scala/sideband/sidebandChannel.scala 52:37]
  assign upper_node_io_outer_tx_credit = io_to_upper_layer_tx_credit; // @[src/main/scala/sideband/sidebandChannel.scala 47:21]
  assign upper_node_io_outer_rx_bits = io_to_upper_layer_rx_bits; // @[src/main/scala/sideband/sidebandChannel.scala 47:21]
  assign upper_node_io_outer_rx_valid = io_to_upper_layer_rx_valid; // @[src/main/scala/sideband/sidebandChannel.scala 47:21]
  assign switcher_io_inner_node_to_layer_below_ready = io_inner_switcherBundle_node_to_layer_below_ready; // @[src/main/scala/sideband/sidebandChannel.scala 64:27]
  assign switcher_io_inner_layer_to_node_below_valid = io_inner_switcherBundle_layer_to_node_below_valid; // @[src/main/scala/sideband/sidebandChannel.scala 64:27]
  assign switcher_io_inner_layer_to_node_below_bits = io_inner_switcherBundle_layer_to_node_below_bits; // @[src/main/scala/sideband/sidebandChannel.scala 64:27]
  assign switcher_io_outer_node_to_layer_above_valid = upper_node_io_inner_node_to_layer_valid; // @[src/main/scala/sideband/sidebandChannel.scala 52:37]
  assign switcher_io_outer_node_to_layer_above_bits = upper_node_io_inner_node_to_layer_bits; // @[src/main/scala/sideband/sidebandChannel.scala 52:37]
  assign switcher_io_outer_layer_to_node_above_ready = upper_node_io_inner_layer_to_node_ready; // @[src/main/scala/sideband/sidebandChannel.scala 51:37]
  assign switcher_io_outer_node_to_layer_below_valid = lower_node_io_inner_node_to_layer_valid; // @[src/main/scala/sideband/sidebandChannel.scala 60:37]
  assign switcher_io_outer_node_to_layer_below_bits = lower_node_io_inner_node_to_layer_bits; // @[src/main/scala/sideband/sidebandChannel.scala 60:37]
  assign switcher_io_outer_layer_to_node_below_ready = io_inner_inputMode & lower_node_io_inner_layer_to_node_ready; // @[src/main/scala/sideband/sidebandChannel.scala 53:48 55:39 src/main/scala/chisel3/util/Decoupled.scala 90:20]
  assign lower_node_clock = clock;
  assign lower_node_reset = reset;
  assign lower_node_io_rxMode = io_inner_rxMode; // @[src/main/scala/sideband/sidebandChannel.scala 61:24]
  assign lower_node_io_inner_layer_to_node_valid = io_inner_inputMode ? switcher_io_outer_layer_to_node_below_valid :
    io_inner_rawInput_valid; // @[src/main/scala/sideband/sidebandChannel.scala 53:48 55:39 58:39]
  assign lower_node_io_inner_layer_to_node_bits = io_inner_inputMode ? switcher_io_outer_layer_to_node_below_bits :
    io_inner_rawInput_bits; // @[src/main/scala/sideband/sidebandChannel.scala 53:48 55:39 58:39]
  assign lower_node_io_inner_node_to_layer_ready = switcher_io_outer_node_to_layer_below_ready; // @[src/main/scala/sideband/sidebandChannel.scala 60:37]
  assign lower_node_io_outer_rx_bits = io_to_lower_layer_rx_bits; // @[src/main/scala/sideband/sidebandChannel.scala 48:21]
  assign lower_node_io_outer_rx_clock = io_to_lower_layer_rx_clock; // @[src/main/scala/sideband/sidebandChannel.scala 48:21]
endmodule
module LogicalPhy(
  input          clock,
  input          reset,
  output         io_rdi_lpData_ready, // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
  input          io_rdi_lpData_valid, // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
  input          io_rdi_lpData_irdy, // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
  input  [511:0] io_rdi_lpData_bits, // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
  output         io_rdi_plData_valid, // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
  output [511:0] io_rdi_plData_bits, // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
  input  [3:0]   io_rdi_lpStateReq, // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
  input          io_rdi_lpLinkError, // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
  output [3:0]   io_rdi_plStateStatus, // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
  output         io_rdi_plInbandPres, // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
  output         io_rdi_plStallReq, // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
  input          io_rdi_lpStallAck, // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
  output         io_rdi_plConfig_valid, // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
  output [127:0] io_rdi_plConfig_bits, // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
  input          io_rdi_plConfigCredit, // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
  input          io_rdi_lpConfig_valid, // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
  input  [127:0] io_rdi_lpConfig_bits, // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
  output         io_rdi_lpConfigCredit, // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
  input          io_mbAfe_fifoParams_clk, // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
  input          io_mbAfe_fifoParams_reset, // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
  input          io_mbAfe_txData_ready, // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
  output         io_mbAfe_txData_valid, // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
  output [15:0]  io_mbAfe_txData_bits_0, // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
  output [15:0]  io_mbAfe_txData_bits_1, // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
  output [15:0]  io_mbAfe_txData_bits_2, // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
  output [15:0]  io_mbAfe_txData_bits_3, // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
  output [15:0]  io_mbAfe_txData_bits_4, // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
  output [15:0]  io_mbAfe_txData_bits_5, // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
  output [15:0]  io_mbAfe_txData_bits_6, // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
  output [15:0]  io_mbAfe_txData_bits_7, // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
  output [15:0]  io_mbAfe_txData_bits_8, // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
  output [15:0]  io_mbAfe_txData_bits_9, // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
  output [15:0]  io_mbAfe_txData_bits_10, // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
  output [15:0]  io_mbAfe_txData_bits_11, // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
  output [15:0]  io_mbAfe_txData_bits_12, // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
  output [15:0]  io_mbAfe_txData_bits_13, // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
  output [15:0]  io_mbAfe_txData_bits_14, // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
  output [15:0]  io_mbAfe_txData_bits_15, // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
  output         io_mbAfe_rxData_ready, // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
  input          io_mbAfe_rxData_valid, // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
  input  [15:0]  io_mbAfe_rxData_bits_0, // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
  input  [15:0]  io_mbAfe_rxData_bits_1, // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
  input  [15:0]  io_mbAfe_rxData_bits_2, // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
  input  [15:0]  io_mbAfe_rxData_bits_3, // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
  input  [15:0]  io_mbAfe_rxData_bits_4, // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
  input  [15:0]  io_mbAfe_rxData_bits_5, // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
  input  [15:0]  io_mbAfe_rxData_bits_6, // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
  input  [15:0]  io_mbAfe_rxData_bits_7, // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
  input  [15:0]  io_mbAfe_rxData_bits_8, // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
  input  [15:0]  io_mbAfe_rxData_bits_9, // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
  input  [15:0]  io_mbAfe_rxData_bits_10, // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
  input  [15:0]  io_mbAfe_rxData_bits_11, // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
  input  [15:0]  io_mbAfe_rxData_bits_12, // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
  input  [15:0]  io_mbAfe_rxData_bits_13, // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
  input  [15:0]  io_mbAfe_rxData_bits_14, // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
  input  [15:0]  io_mbAfe_rxData_bits_15, // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
  output         io_mbAfe_rxEn, // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
  input          io_mbAfe_pllLock, // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
  output         io_sbAfe_txData, // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
  output         io_sbAfe_txClock, // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
  input          io_sbAfe_rxData, // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
  input          io_sbAfe_rxClock, // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
  input          io_sbAfe_pllLock // @[src/main/scala/logphy/LogicalPhy.scala 19:14]
);
  wire  trainingModule_clock; // @[src/main/scala/logphy/LogicalPhy.scala 26:11]
  wire  trainingModule_reset; // @[src/main/scala/logphy/LogicalPhy.scala 26:11]
  wire  trainingModule_io_mainbandFSMIO_rxEn; // @[src/main/scala/logphy/LogicalPhy.scala 26:11]
  wire  trainingModule_io_mainbandFSMIO_pllLock; // @[src/main/scala/logphy/LogicalPhy.scala 26:11]
  wire  trainingModule_io_sidebandFSMIO_rxData_ready; // @[src/main/scala/logphy/LogicalPhy.scala 26:11]
  wire  trainingModule_io_sidebandFSMIO_rxData_valid; // @[src/main/scala/logphy/LogicalPhy.scala 26:11]
  wire [127:0] trainingModule_io_sidebandFSMIO_rxData_bits; // @[src/main/scala/logphy/LogicalPhy.scala 26:11]
  wire  trainingModule_io_sidebandFSMIO_patternTxData_ready; // @[src/main/scala/logphy/LogicalPhy.scala 26:11]
  wire  trainingModule_io_sidebandFSMIO_patternTxData_valid; // @[src/main/scala/logphy/LogicalPhy.scala 26:11]
  wire [127:0] trainingModule_io_sidebandFSMIO_patternTxData_bits; // @[src/main/scala/logphy/LogicalPhy.scala 26:11]
  wire  trainingModule_io_sidebandFSMIO_packetTxData_ready; // @[src/main/scala/logphy/LogicalPhy.scala 26:11]
  wire  trainingModule_io_sidebandFSMIO_packetTxData_valid; // @[src/main/scala/logphy/LogicalPhy.scala 26:11]
  wire [127:0] trainingModule_io_sidebandFSMIO_packetTxData_bits; // @[src/main/scala/logphy/LogicalPhy.scala 26:11]
  wire  trainingModule_io_sidebandFSMIO_rxMode; // @[src/main/scala/logphy/LogicalPhy.scala 26:11]
  wire  trainingModule_io_sidebandFSMIO_txMode; // @[src/main/scala/logphy/LogicalPhy.scala 26:11]
  wire  trainingModule_io_sidebandFSMIO_pllLock; // @[src/main/scala/logphy/LogicalPhy.scala 26:11]
  wire [3:0] trainingModule_io_rdi_rdiBringupIO_lpStateReq; // @[src/main/scala/logphy/LogicalPhy.scala 26:11]
  wire [3:0] trainingModule_io_rdi_rdiBringupIO_plStateStatus; // @[src/main/scala/logphy/LogicalPhy.scala 26:11]
  wire  trainingModule_io_rdi_rdiBringupIO_plStallReq; // @[src/main/scala/logphy/LogicalPhy.scala 26:11]
  wire  trainingModule_io_rdi_rdiBringupIO_lpStallAck; // @[src/main/scala/logphy/LogicalPhy.scala 26:11]
  wire  trainingModule_io_rdi_rdiBringupIO_lpLinkError; // @[src/main/scala/logphy/LogicalPhy.scala 26:11]
  wire [2:0] trainingModule_io_currentState; // @[src/main/scala/logphy/LogicalPhy.scala 26:11]
  wire  rdiDataMapper_clock; // @[src/main/scala/logphy/LogicalPhy.scala 68:29]
  wire  rdiDataMapper_reset; // @[src/main/scala/logphy/LogicalPhy.scala 68:29]
  wire  rdiDataMapper_io_rdi_lpData_ready; // @[src/main/scala/logphy/LogicalPhy.scala 68:29]
  wire  rdiDataMapper_io_rdi_lpData_valid; // @[src/main/scala/logphy/LogicalPhy.scala 68:29]
  wire  rdiDataMapper_io_rdi_lpData_irdy; // @[src/main/scala/logphy/LogicalPhy.scala 68:29]
  wire [511:0] rdiDataMapper_io_rdi_lpData_bits; // @[src/main/scala/logphy/LogicalPhy.scala 68:29]
  wire  rdiDataMapper_io_rdi_plData_valid; // @[src/main/scala/logphy/LogicalPhy.scala 68:29]
  wire [511:0] rdiDataMapper_io_rdi_plData_bits; // @[src/main/scala/logphy/LogicalPhy.scala 68:29]
  wire  rdiDataMapper_io_mainbandLaneIO_txData_ready; // @[src/main/scala/logphy/LogicalPhy.scala 68:29]
  wire  rdiDataMapper_io_mainbandLaneIO_txData_valid; // @[src/main/scala/logphy/LogicalPhy.scala 68:29]
  wire [255:0] rdiDataMapper_io_mainbandLaneIO_txData_bits; // @[src/main/scala/logphy/LogicalPhy.scala 68:29]
  wire  rdiDataMapper_io_mainbandLaneIO_rxData_valid; // @[src/main/scala/logphy/LogicalPhy.scala 68:29]
  wire [255:0] rdiDataMapper_io_mainbandLaneIO_rxData_bits; // @[src/main/scala/logphy/LogicalPhy.scala 68:29]
  wire  lanes_clock; // @[src/main/scala/logphy/LogicalPhy.scala 70:21]
  wire  lanes_reset; // @[src/main/scala/logphy/LogicalPhy.scala 70:21]
  wire  lanes_io_mainbandIo_fifoParams_clk; // @[src/main/scala/logphy/LogicalPhy.scala 70:21]
  wire  lanes_io_mainbandIo_fifoParams_reset; // @[src/main/scala/logphy/LogicalPhy.scala 70:21]
  wire  lanes_io_mainbandIo_txData_ready; // @[src/main/scala/logphy/LogicalPhy.scala 70:21]
  wire  lanes_io_mainbandIo_txData_valid; // @[src/main/scala/logphy/LogicalPhy.scala 70:21]
  wire [15:0] lanes_io_mainbandIo_txData_bits_0; // @[src/main/scala/logphy/LogicalPhy.scala 70:21]
  wire [15:0] lanes_io_mainbandIo_txData_bits_1; // @[src/main/scala/logphy/LogicalPhy.scala 70:21]
  wire [15:0] lanes_io_mainbandIo_txData_bits_2; // @[src/main/scala/logphy/LogicalPhy.scala 70:21]
  wire [15:0] lanes_io_mainbandIo_txData_bits_3; // @[src/main/scala/logphy/LogicalPhy.scala 70:21]
  wire [15:0] lanes_io_mainbandIo_txData_bits_4; // @[src/main/scala/logphy/LogicalPhy.scala 70:21]
  wire [15:0] lanes_io_mainbandIo_txData_bits_5; // @[src/main/scala/logphy/LogicalPhy.scala 70:21]
  wire [15:0] lanes_io_mainbandIo_txData_bits_6; // @[src/main/scala/logphy/LogicalPhy.scala 70:21]
  wire [15:0] lanes_io_mainbandIo_txData_bits_7; // @[src/main/scala/logphy/LogicalPhy.scala 70:21]
  wire [15:0] lanes_io_mainbandIo_txData_bits_8; // @[src/main/scala/logphy/LogicalPhy.scala 70:21]
  wire [15:0] lanes_io_mainbandIo_txData_bits_9; // @[src/main/scala/logphy/LogicalPhy.scala 70:21]
  wire [15:0] lanes_io_mainbandIo_txData_bits_10; // @[src/main/scala/logphy/LogicalPhy.scala 70:21]
  wire [15:0] lanes_io_mainbandIo_txData_bits_11; // @[src/main/scala/logphy/LogicalPhy.scala 70:21]
  wire [15:0] lanes_io_mainbandIo_txData_bits_12; // @[src/main/scala/logphy/LogicalPhy.scala 70:21]
  wire [15:0] lanes_io_mainbandIo_txData_bits_13; // @[src/main/scala/logphy/LogicalPhy.scala 70:21]
  wire [15:0] lanes_io_mainbandIo_txData_bits_14; // @[src/main/scala/logphy/LogicalPhy.scala 70:21]
  wire [15:0] lanes_io_mainbandIo_txData_bits_15; // @[src/main/scala/logphy/LogicalPhy.scala 70:21]
  wire  lanes_io_mainbandIo_rxData_ready; // @[src/main/scala/logphy/LogicalPhy.scala 70:21]
  wire  lanes_io_mainbandIo_rxData_valid; // @[src/main/scala/logphy/LogicalPhy.scala 70:21]
  wire [15:0] lanes_io_mainbandIo_rxData_bits_0; // @[src/main/scala/logphy/LogicalPhy.scala 70:21]
  wire [15:0] lanes_io_mainbandIo_rxData_bits_1; // @[src/main/scala/logphy/LogicalPhy.scala 70:21]
  wire [15:0] lanes_io_mainbandIo_rxData_bits_2; // @[src/main/scala/logphy/LogicalPhy.scala 70:21]
  wire [15:0] lanes_io_mainbandIo_rxData_bits_3; // @[src/main/scala/logphy/LogicalPhy.scala 70:21]
  wire [15:0] lanes_io_mainbandIo_rxData_bits_4; // @[src/main/scala/logphy/LogicalPhy.scala 70:21]
  wire [15:0] lanes_io_mainbandIo_rxData_bits_5; // @[src/main/scala/logphy/LogicalPhy.scala 70:21]
  wire [15:0] lanes_io_mainbandIo_rxData_bits_6; // @[src/main/scala/logphy/LogicalPhy.scala 70:21]
  wire [15:0] lanes_io_mainbandIo_rxData_bits_7; // @[src/main/scala/logphy/LogicalPhy.scala 70:21]
  wire [15:0] lanes_io_mainbandIo_rxData_bits_8; // @[src/main/scala/logphy/LogicalPhy.scala 70:21]
  wire [15:0] lanes_io_mainbandIo_rxData_bits_9; // @[src/main/scala/logphy/LogicalPhy.scala 70:21]
  wire [15:0] lanes_io_mainbandIo_rxData_bits_10; // @[src/main/scala/logphy/LogicalPhy.scala 70:21]
  wire [15:0] lanes_io_mainbandIo_rxData_bits_11; // @[src/main/scala/logphy/LogicalPhy.scala 70:21]
  wire [15:0] lanes_io_mainbandIo_rxData_bits_12; // @[src/main/scala/logphy/LogicalPhy.scala 70:21]
  wire [15:0] lanes_io_mainbandIo_rxData_bits_13; // @[src/main/scala/logphy/LogicalPhy.scala 70:21]
  wire [15:0] lanes_io_mainbandIo_rxData_bits_14; // @[src/main/scala/logphy/LogicalPhy.scala 70:21]
  wire [15:0] lanes_io_mainbandIo_rxData_bits_15; // @[src/main/scala/logphy/LogicalPhy.scala 70:21]
  wire  lanes_io_mainbandLaneIO_txData_ready; // @[src/main/scala/logphy/LogicalPhy.scala 70:21]
  wire  lanes_io_mainbandLaneIO_txData_valid; // @[src/main/scala/logphy/LogicalPhy.scala 70:21]
  wire [255:0] lanes_io_mainbandLaneIO_txData_bits; // @[src/main/scala/logphy/LogicalPhy.scala 70:21]
  wire  lanes_io_mainbandLaneIO_rxData_valid; // @[src/main/scala/logphy/LogicalPhy.scala 70:21]
  wire [255:0] lanes_io_mainbandLaneIO_rxData_bits; // @[src/main/scala/logphy/LogicalPhy.scala 70:21]
  wire  sidebandChannel_clock; // @[src/main/scala/logphy/LogicalPhy.scala 83:11]
  wire  sidebandChannel_reset; // @[src/main/scala/logphy/LogicalPhy.scala 83:11]
  wire [127:0] sidebandChannel_io_to_upper_layer_tx_bits; // @[src/main/scala/logphy/LogicalPhy.scala 83:11]
  wire  sidebandChannel_io_to_upper_layer_tx_valid; // @[src/main/scala/logphy/LogicalPhy.scala 83:11]
  wire  sidebandChannel_io_to_upper_layer_tx_credit; // @[src/main/scala/logphy/LogicalPhy.scala 83:11]
  wire [127:0] sidebandChannel_io_to_upper_layer_rx_bits; // @[src/main/scala/logphy/LogicalPhy.scala 83:11]
  wire  sidebandChannel_io_to_upper_layer_rx_valid; // @[src/main/scala/logphy/LogicalPhy.scala 83:11]
  wire  sidebandChannel_io_to_upper_layer_rx_credit; // @[src/main/scala/logphy/LogicalPhy.scala 83:11]
  wire  sidebandChannel_io_to_lower_layer_tx_bits; // @[src/main/scala/logphy/LogicalPhy.scala 83:11]
  wire  sidebandChannel_io_to_lower_layer_tx_clock; // @[src/main/scala/logphy/LogicalPhy.scala 83:11]
  wire  sidebandChannel_io_to_lower_layer_rx_bits; // @[src/main/scala/logphy/LogicalPhy.scala 83:11]
  wire  sidebandChannel_io_to_lower_layer_rx_clock; // @[src/main/scala/logphy/LogicalPhy.scala 83:11]
  wire  sidebandChannel_io_inner_inputMode; // @[src/main/scala/logphy/LogicalPhy.scala 83:11]
  wire  sidebandChannel_io_inner_rxMode; // @[src/main/scala/logphy/LogicalPhy.scala 83:11]
  wire  sidebandChannel_io_inner_rawInput_ready; // @[src/main/scala/logphy/LogicalPhy.scala 83:11]
  wire  sidebandChannel_io_inner_rawInput_valid; // @[src/main/scala/logphy/LogicalPhy.scala 83:11]
  wire [127:0] sidebandChannel_io_inner_rawInput_bits; // @[src/main/scala/logphy/LogicalPhy.scala 83:11]
  wire  sidebandChannel_io_inner_switcherBundle_node_to_layer_below_ready; // @[src/main/scala/logphy/LogicalPhy.scala 83:11]
  wire  sidebandChannel_io_inner_switcherBundle_node_to_layer_below_valid; // @[src/main/scala/logphy/LogicalPhy.scala 83:11]
  wire [127:0] sidebandChannel_io_inner_switcherBundle_node_to_layer_below_bits; // @[src/main/scala/logphy/LogicalPhy.scala 83:11]
  wire  sidebandChannel_io_inner_switcherBundle_layer_to_node_below_ready; // @[src/main/scala/logphy/LogicalPhy.scala 83:11]
  wire  sidebandChannel_io_inner_switcherBundle_layer_to_node_below_valid; // @[src/main/scala/logphy/LogicalPhy.scala 83:11]
  wire [127:0] sidebandChannel_io_inner_switcherBundle_layer_to_node_below_bits; // @[src/main/scala/logphy/LogicalPhy.scala 83:11]
  LinkTrainingFSM trainingModule ( // @[src/main/scala/logphy/LogicalPhy.scala 26:11]
    .clock(trainingModule_clock),
    .reset(trainingModule_reset),
    .io_mainbandFSMIO_rxEn(trainingModule_io_mainbandFSMIO_rxEn),
    .io_mainbandFSMIO_pllLock(trainingModule_io_mainbandFSMIO_pllLock),
    .io_sidebandFSMIO_rxData_ready(trainingModule_io_sidebandFSMIO_rxData_ready),
    .io_sidebandFSMIO_rxData_valid(trainingModule_io_sidebandFSMIO_rxData_valid),
    .io_sidebandFSMIO_rxData_bits(trainingModule_io_sidebandFSMIO_rxData_bits),
    .io_sidebandFSMIO_patternTxData_ready(trainingModule_io_sidebandFSMIO_patternTxData_ready),
    .io_sidebandFSMIO_patternTxData_valid(trainingModule_io_sidebandFSMIO_patternTxData_valid),
    .io_sidebandFSMIO_patternTxData_bits(trainingModule_io_sidebandFSMIO_patternTxData_bits),
    .io_sidebandFSMIO_packetTxData_ready(trainingModule_io_sidebandFSMIO_packetTxData_ready),
    .io_sidebandFSMIO_packetTxData_valid(trainingModule_io_sidebandFSMIO_packetTxData_valid),
    .io_sidebandFSMIO_packetTxData_bits(trainingModule_io_sidebandFSMIO_packetTxData_bits),
    .io_sidebandFSMIO_rxMode(trainingModule_io_sidebandFSMIO_rxMode),
    .io_sidebandFSMIO_txMode(trainingModule_io_sidebandFSMIO_txMode),
    .io_sidebandFSMIO_pllLock(trainingModule_io_sidebandFSMIO_pllLock),
    .io_rdi_rdiBringupIO_lpStateReq(trainingModule_io_rdi_rdiBringupIO_lpStateReq),
    .io_rdi_rdiBringupIO_plStateStatus(trainingModule_io_rdi_rdiBringupIO_plStateStatus),
    .io_rdi_rdiBringupIO_plStallReq(trainingModule_io_rdi_rdiBringupIO_plStallReq),
    .io_rdi_rdiBringupIO_lpStallAck(trainingModule_io_rdi_rdiBringupIO_lpStallAck),
    .io_rdi_rdiBringupIO_lpLinkError(trainingModule_io_rdi_rdiBringupIO_lpLinkError),
    .io_currentState(trainingModule_io_currentState)
  );
  RdiDataMapper rdiDataMapper ( // @[src/main/scala/logphy/LogicalPhy.scala 68:29]
    .clock(rdiDataMapper_clock),
    .reset(rdiDataMapper_reset),
    .io_rdi_lpData_ready(rdiDataMapper_io_rdi_lpData_ready),
    .io_rdi_lpData_valid(rdiDataMapper_io_rdi_lpData_valid),
    .io_rdi_lpData_irdy(rdiDataMapper_io_rdi_lpData_irdy),
    .io_rdi_lpData_bits(rdiDataMapper_io_rdi_lpData_bits),
    .io_rdi_plData_valid(rdiDataMapper_io_rdi_plData_valid),
    .io_rdi_plData_bits(rdiDataMapper_io_rdi_plData_bits),
    .io_mainbandLaneIO_txData_ready(rdiDataMapper_io_mainbandLaneIO_txData_ready),
    .io_mainbandLaneIO_txData_valid(rdiDataMapper_io_mainbandLaneIO_txData_valid),
    .io_mainbandLaneIO_txData_bits(rdiDataMapper_io_mainbandLaneIO_txData_bits),
    .io_mainbandLaneIO_rxData_valid(rdiDataMapper_io_mainbandLaneIO_rxData_valid),
    .io_mainbandLaneIO_rxData_bits(rdiDataMapper_io_mainbandLaneIO_rxData_bits)
  );
  Lanes lanes ( // @[src/main/scala/logphy/LogicalPhy.scala 70:21]
    .clock(lanes_clock),
    .reset(lanes_reset),
    .io_mainbandIo_fifoParams_clk(lanes_io_mainbandIo_fifoParams_clk),
    .io_mainbandIo_fifoParams_reset(lanes_io_mainbandIo_fifoParams_reset),
    .io_mainbandIo_txData_ready(lanes_io_mainbandIo_txData_ready),
    .io_mainbandIo_txData_valid(lanes_io_mainbandIo_txData_valid),
    .io_mainbandIo_txData_bits_0(lanes_io_mainbandIo_txData_bits_0),
    .io_mainbandIo_txData_bits_1(lanes_io_mainbandIo_txData_bits_1),
    .io_mainbandIo_txData_bits_2(lanes_io_mainbandIo_txData_bits_2),
    .io_mainbandIo_txData_bits_3(lanes_io_mainbandIo_txData_bits_3),
    .io_mainbandIo_txData_bits_4(lanes_io_mainbandIo_txData_bits_4),
    .io_mainbandIo_txData_bits_5(lanes_io_mainbandIo_txData_bits_5),
    .io_mainbandIo_txData_bits_6(lanes_io_mainbandIo_txData_bits_6),
    .io_mainbandIo_txData_bits_7(lanes_io_mainbandIo_txData_bits_7),
    .io_mainbandIo_txData_bits_8(lanes_io_mainbandIo_txData_bits_8),
    .io_mainbandIo_txData_bits_9(lanes_io_mainbandIo_txData_bits_9),
    .io_mainbandIo_txData_bits_10(lanes_io_mainbandIo_txData_bits_10),
    .io_mainbandIo_txData_bits_11(lanes_io_mainbandIo_txData_bits_11),
    .io_mainbandIo_txData_bits_12(lanes_io_mainbandIo_txData_bits_12),
    .io_mainbandIo_txData_bits_13(lanes_io_mainbandIo_txData_bits_13),
    .io_mainbandIo_txData_bits_14(lanes_io_mainbandIo_txData_bits_14),
    .io_mainbandIo_txData_bits_15(lanes_io_mainbandIo_txData_bits_15),
    .io_mainbandIo_rxData_ready(lanes_io_mainbandIo_rxData_ready),
    .io_mainbandIo_rxData_valid(lanes_io_mainbandIo_rxData_valid),
    .io_mainbandIo_rxData_bits_0(lanes_io_mainbandIo_rxData_bits_0),
    .io_mainbandIo_rxData_bits_1(lanes_io_mainbandIo_rxData_bits_1),
    .io_mainbandIo_rxData_bits_2(lanes_io_mainbandIo_rxData_bits_2),
    .io_mainbandIo_rxData_bits_3(lanes_io_mainbandIo_rxData_bits_3),
    .io_mainbandIo_rxData_bits_4(lanes_io_mainbandIo_rxData_bits_4),
    .io_mainbandIo_rxData_bits_5(lanes_io_mainbandIo_rxData_bits_5),
    .io_mainbandIo_rxData_bits_6(lanes_io_mainbandIo_rxData_bits_6),
    .io_mainbandIo_rxData_bits_7(lanes_io_mainbandIo_rxData_bits_7),
    .io_mainbandIo_rxData_bits_8(lanes_io_mainbandIo_rxData_bits_8),
    .io_mainbandIo_rxData_bits_9(lanes_io_mainbandIo_rxData_bits_9),
    .io_mainbandIo_rxData_bits_10(lanes_io_mainbandIo_rxData_bits_10),
    .io_mainbandIo_rxData_bits_11(lanes_io_mainbandIo_rxData_bits_11),
    .io_mainbandIo_rxData_bits_12(lanes_io_mainbandIo_rxData_bits_12),
    .io_mainbandIo_rxData_bits_13(lanes_io_mainbandIo_rxData_bits_13),
    .io_mainbandIo_rxData_bits_14(lanes_io_mainbandIo_rxData_bits_14),
    .io_mainbandIo_rxData_bits_15(lanes_io_mainbandIo_rxData_bits_15),
    .io_mainbandLaneIO_txData_ready(lanes_io_mainbandLaneIO_txData_ready),
    .io_mainbandLaneIO_txData_valid(lanes_io_mainbandLaneIO_txData_valid),
    .io_mainbandLaneIO_txData_bits(lanes_io_mainbandLaneIO_txData_bits),
    .io_mainbandLaneIO_rxData_valid(lanes_io_mainbandLaneIO_rxData_valid),
    .io_mainbandLaneIO_rxData_bits(lanes_io_mainbandLaneIO_rxData_bits)
  );
  PHYSidebandChannel sidebandChannel ( // @[src/main/scala/logphy/LogicalPhy.scala 83:11]
    .clock(sidebandChannel_clock),
    .reset(sidebandChannel_reset),
    .io_to_upper_layer_tx_bits(sidebandChannel_io_to_upper_layer_tx_bits),
    .io_to_upper_layer_tx_valid(sidebandChannel_io_to_upper_layer_tx_valid),
    .io_to_upper_layer_tx_credit(sidebandChannel_io_to_upper_layer_tx_credit),
    .io_to_upper_layer_rx_bits(sidebandChannel_io_to_upper_layer_rx_bits),
    .io_to_upper_layer_rx_valid(sidebandChannel_io_to_upper_layer_rx_valid),
    .io_to_upper_layer_rx_credit(sidebandChannel_io_to_upper_layer_rx_credit),
    .io_to_lower_layer_tx_bits(sidebandChannel_io_to_lower_layer_tx_bits),
    .io_to_lower_layer_tx_clock(sidebandChannel_io_to_lower_layer_tx_clock),
    .io_to_lower_layer_rx_bits(sidebandChannel_io_to_lower_layer_rx_bits),
    .io_to_lower_layer_rx_clock(sidebandChannel_io_to_lower_layer_rx_clock),
    .io_inner_inputMode(sidebandChannel_io_inner_inputMode),
    .io_inner_rxMode(sidebandChannel_io_inner_rxMode),
    .io_inner_rawInput_ready(sidebandChannel_io_inner_rawInput_ready),
    .io_inner_rawInput_valid(sidebandChannel_io_inner_rawInput_valid),
    .io_inner_rawInput_bits(sidebandChannel_io_inner_rawInput_bits),
    .io_inner_switcherBundle_node_to_layer_below_ready(sidebandChannel_io_inner_switcherBundle_node_to_layer_below_ready
      ),
    .io_inner_switcherBundle_node_to_layer_below_valid(sidebandChannel_io_inner_switcherBundle_node_to_layer_below_valid
      ),
    .io_inner_switcherBundle_node_to_layer_below_bits(sidebandChannel_io_inner_switcherBundle_node_to_layer_below_bits),
    .io_inner_switcherBundle_layer_to_node_below_ready(sidebandChannel_io_inner_switcherBundle_layer_to_node_below_ready
      ),
    .io_inner_switcherBundle_layer_to_node_below_valid(sidebandChannel_io_inner_switcherBundle_layer_to_node_below_valid
      ),
    .io_inner_switcherBundle_layer_to_node_below_bits(sidebandChannel_io_inner_switcherBundle_layer_to_node_below_bits)
  );
  assign io_rdi_lpData_ready = rdiDataMapper_io_rdi_lpData_ready; // @[src/main/scala/logphy/LogicalPhy.scala 79:31]
  assign io_rdi_plData_valid = rdiDataMapper_io_rdi_plData_valid; // @[src/main/scala/logphy/LogicalPhy.scala 80:17]
  assign io_rdi_plData_bits = rdiDataMapper_io_rdi_plData_bits; // @[src/main/scala/logphy/LogicalPhy.scala 80:17]
  assign io_rdi_plStateStatus = trainingModule_io_rdi_rdiBringupIO_plStateStatus; // @[src/main/scala/logphy/LogicalPhy.scala 62:24]
  assign io_rdi_plInbandPres = trainingModule_io_currentState == 3'h4; // @[src/main/scala/logphy/LogicalPhy.scala 66:57]
  assign io_rdi_plStallReq = trainingModule_io_rdi_rdiBringupIO_plStallReq; // @[src/main/scala/logphy/LogicalPhy.scala 60:21]
  assign io_rdi_plConfig_valid = sidebandChannel_io_to_upper_layer_tx_valid; // @[src/main/scala/logphy/LogicalPhy.scala 91:46]
  assign io_rdi_plConfig_bits = sidebandChannel_io_to_upper_layer_tx_bits; // @[src/main/scala/logphy/LogicalPhy.scala 90:45]
  assign io_rdi_lpConfigCredit = sidebandChannel_io_to_upper_layer_rx_credit; // @[src/main/scala/logphy/LogicalPhy.scala 95:47]
  assign io_mbAfe_txData_valid = lanes_io_mainbandIo_txData_valid; // @[src/main/scala/logphy/LogicalPhy.scala 73:30]
  assign io_mbAfe_txData_bits_0 = lanes_io_mainbandIo_txData_bits_0; // @[src/main/scala/logphy/LogicalPhy.scala 73:30]
  assign io_mbAfe_txData_bits_1 = lanes_io_mainbandIo_txData_bits_1; // @[src/main/scala/logphy/LogicalPhy.scala 73:30]
  assign io_mbAfe_txData_bits_2 = lanes_io_mainbandIo_txData_bits_2; // @[src/main/scala/logphy/LogicalPhy.scala 73:30]
  assign io_mbAfe_txData_bits_3 = lanes_io_mainbandIo_txData_bits_3; // @[src/main/scala/logphy/LogicalPhy.scala 73:30]
  assign io_mbAfe_txData_bits_4 = lanes_io_mainbandIo_txData_bits_4; // @[src/main/scala/logphy/LogicalPhy.scala 73:30]
  assign io_mbAfe_txData_bits_5 = lanes_io_mainbandIo_txData_bits_5; // @[src/main/scala/logphy/LogicalPhy.scala 73:30]
  assign io_mbAfe_txData_bits_6 = lanes_io_mainbandIo_txData_bits_6; // @[src/main/scala/logphy/LogicalPhy.scala 73:30]
  assign io_mbAfe_txData_bits_7 = lanes_io_mainbandIo_txData_bits_7; // @[src/main/scala/logphy/LogicalPhy.scala 73:30]
  assign io_mbAfe_txData_bits_8 = lanes_io_mainbandIo_txData_bits_8; // @[src/main/scala/logphy/LogicalPhy.scala 73:30]
  assign io_mbAfe_txData_bits_9 = lanes_io_mainbandIo_txData_bits_9; // @[src/main/scala/logphy/LogicalPhy.scala 73:30]
  assign io_mbAfe_txData_bits_10 = lanes_io_mainbandIo_txData_bits_10; // @[src/main/scala/logphy/LogicalPhy.scala 73:30]
  assign io_mbAfe_txData_bits_11 = lanes_io_mainbandIo_txData_bits_11; // @[src/main/scala/logphy/LogicalPhy.scala 73:30]
  assign io_mbAfe_txData_bits_12 = lanes_io_mainbandIo_txData_bits_12; // @[src/main/scala/logphy/LogicalPhy.scala 73:30]
  assign io_mbAfe_txData_bits_13 = lanes_io_mainbandIo_txData_bits_13; // @[src/main/scala/logphy/LogicalPhy.scala 73:30]
  assign io_mbAfe_txData_bits_14 = lanes_io_mainbandIo_txData_bits_14; // @[src/main/scala/logphy/LogicalPhy.scala 73:30]
  assign io_mbAfe_txData_bits_15 = lanes_io_mainbandIo_txData_bits_15; // @[src/main/scala/logphy/LogicalPhy.scala 73:30]
  assign io_mbAfe_rxData_ready = lanes_io_mainbandIo_rxData_ready; // @[src/main/scala/logphy/LogicalPhy.scala 74:30]
  assign io_mbAfe_rxEn = trainingModule_io_mainbandFSMIO_rxEn; // @[src/main/scala/logphy/LogicalPhy.scala 33:40]
  assign io_sbAfe_txData = sidebandChannel_io_to_lower_layer_tx_bits; // @[src/main/scala/logphy/LogicalPhy.scala 114:19]
  assign io_sbAfe_txClock = sidebandChannel_io_to_lower_layer_tx_clock; // @[src/main/scala/logphy/LogicalPhy.scala 115:20]
  assign trainingModule_clock = clock;
  assign trainingModule_reset = reset;
  assign trainingModule_io_mainbandFSMIO_pllLock = io_mbAfe_pllLock; // @[src/main/scala/logphy/LogicalPhy.scala 31:43]
  assign trainingModule_io_sidebandFSMIO_rxData_valid =
    sidebandChannel_io_inner_switcherBundle_node_to_layer_below_valid; // @[src/main/scala/logphy/LogicalPhy.scala 99:63]
  assign trainingModule_io_sidebandFSMIO_rxData_bits = sidebandChannel_io_inner_switcherBundle_node_to_layer_below_bits; // @[src/main/scala/logphy/LogicalPhy.scala 99:63]
  assign trainingModule_io_sidebandFSMIO_patternTxData_ready = sidebandChannel_io_inner_rawInput_ready; // @[src/main/scala/logphy/LogicalPhy.scala 100:37]
  assign trainingModule_io_sidebandFSMIO_packetTxData_ready =
    sidebandChannel_io_inner_switcherBundle_layer_to_node_below_ready; // @[src/main/scala/logphy/LogicalPhy.scala 98:63]
  assign trainingModule_io_sidebandFSMIO_pllLock = io_sbAfe_pllLock; // @[src/main/scala/logphy/LogicalPhy.scala 32:43]
  assign trainingModule_io_rdi_rdiBringupIO_lpStateReq = io_rdi_lpStateReq; // @[src/main/scala/logphy/LogicalPhy.scala 35:49]
  assign trainingModule_io_rdi_rdiBringupIO_lpStallAck = io_rdi_lpStallAck; // @[src/main/scala/logphy/LogicalPhy.scala 61:21]
  assign trainingModule_io_rdi_rdiBringupIO_lpLinkError = io_rdi_lpLinkError; // @[src/main/scala/logphy/LogicalPhy.scala 63:22]
  assign rdiDataMapper_clock = clock;
  assign rdiDataMapper_reset = reset;
  assign rdiDataMapper_io_rdi_lpData_valid = io_rdi_lpData_valid; // @[src/main/scala/logphy/LogicalPhy.scala 79:31]
  assign rdiDataMapper_io_rdi_lpData_irdy = io_rdi_lpData_irdy; // @[src/main/scala/logphy/LogicalPhy.scala 79:31]
  assign rdiDataMapper_io_rdi_lpData_bits = io_rdi_lpData_bits; // @[src/main/scala/logphy/LogicalPhy.scala 79:31]
  assign rdiDataMapper_io_mainbandLaneIO_txData_ready = lanes_io_mainbandLaneIO_txData_ready; // @[src/main/scala/logphy/LogicalPhy.scala 76:35]
  assign rdiDataMapper_io_mainbandLaneIO_rxData_valid = lanes_io_mainbandLaneIO_rxData_valid; // @[src/main/scala/logphy/LogicalPhy.scala 76:35]
  assign rdiDataMapper_io_mainbandLaneIO_rxData_bits = lanes_io_mainbandLaneIO_rxData_bits; // @[src/main/scala/logphy/LogicalPhy.scala 76:35]
  assign lanes_clock = clock;
  assign lanes_reset = reset;
  assign lanes_io_mainbandIo_fifoParams_clk = io_mbAfe_fifoParams_clk; // @[src/main/scala/logphy/LogicalPhy.scala 75:34]
  assign lanes_io_mainbandIo_fifoParams_reset = io_mbAfe_fifoParams_reset; // @[src/main/scala/logphy/LogicalPhy.scala 75:34]
  assign lanes_io_mainbandIo_txData_ready = io_mbAfe_txData_ready; // @[src/main/scala/logphy/LogicalPhy.scala 73:30]
  assign lanes_io_mainbandIo_rxData_valid = io_mbAfe_rxData_valid; // @[src/main/scala/logphy/LogicalPhy.scala 74:30]
  assign lanes_io_mainbandIo_rxData_bits_0 = io_mbAfe_rxData_bits_0; // @[src/main/scala/logphy/LogicalPhy.scala 74:30]
  assign lanes_io_mainbandIo_rxData_bits_1 = io_mbAfe_rxData_bits_1; // @[src/main/scala/logphy/LogicalPhy.scala 74:30]
  assign lanes_io_mainbandIo_rxData_bits_2 = io_mbAfe_rxData_bits_2; // @[src/main/scala/logphy/LogicalPhy.scala 74:30]
  assign lanes_io_mainbandIo_rxData_bits_3 = io_mbAfe_rxData_bits_3; // @[src/main/scala/logphy/LogicalPhy.scala 74:30]
  assign lanes_io_mainbandIo_rxData_bits_4 = io_mbAfe_rxData_bits_4; // @[src/main/scala/logphy/LogicalPhy.scala 74:30]
  assign lanes_io_mainbandIo_rxData_bits_5 = io_mbAfe_rxData_bits_5; // @[src/main/scala/logphy/LogicalPhy.scala 74:30]
  assign lanes_io_mainbandIo_rxData_bits_6 = io_mbAfe_rxData_bits_6; // @[src/main/scala/logphy/LogicalPhy.scala 74:30]
  assign lanes_io_mainbandIo_rxData_bits_7 = io_mbAfe_rxData_bits_7; // @[src/main/scala/logphy/LogicalPhy.scala 74:30]
  assign lanes_io_mainbandIo_rxData_bits_8 = io_mbAfe_rxData_bits_8; // @[src/main/scala/logphy/LogicalPhy.scala 74:30]
  assign lanes_io_mainbandIo_rxData_bits_9 = io_mbAfe_rxData_bits_9; // @[src/main/scala/logphy/LogicalPhy.scala 74:30]
  assign lanes_io_mainbandIo_rxData_bits_10 = io_mbAfe_rxData_bits_10; // @[src/main/scala/logphy/LogicalPhy.scala 74:30]
  assign lanes_io_mainbandIo_rxData_bits_11 = io_mbAfe_rxData_bits_11; // @[src/main/scala/logphy/LogicalPhy.scala 74:30]
  assign lanes_io_mainbandIo_rxData_bits_12 = io_mbAfe_rxData_bits_12; // @[src/main/scala/logphy/LogicalPhy.scala 74:30]
  assign lanes_io_mainbandIo_rxData_bits_13 = io_mbAfe_rxData_bits_13; // @[src/main/scala/logphy/LogicalPhy.scala 74:30]
  assign lanes_io_mainbandIo_rxData_bits_14 = io_mbAfe_rxData_bits_14; // @[src/main/scala/logphy/LogicalPhy.scala 74:30]
  assign lanes_io_mainbandIo_rxData_bits_15 = io_mbAfe_rxData_bits_15; // @[src/main/scala/logphy/LogicalPhy.scala 74:30]
  assign lanes_io_mainbandLaneIO_txData_valid = rdiDataMapper_io_mainbandLaneIO_txData_valid; // @[src/main/scala/logphy/LogicalPhy.scala 76:35]
  assign lanes_io_mainbandLaneIO_txData_bits = rdiDataMapper_io_mainbandLaneIO_txData_bits; // @[src/main/scala/logphy/LogicalPhy.scala 76:35]
  assign sidebandChannel_clock = clock;
  assign sidebandChannel_reset = reset;
  assign sidebandChannel_io_to_upper_layer_tx_credit = io_rdi_plConfigCredit; // @[src/main/scala/logphy/LogicalPhy.scala 92:47]
  assign sidebandChannel_io_to_upper_layer_rx_bits = io_rdi_lpConfig_bits; // @[src/main/scala/logphy/LogicalPhy.scala 93:45]
  assign sidebandChannel_io_to_upper_layer_rx_valid = io_rdi_lpConfig_valid; // @[src/main/scala/logphy/LogicalPhy.scala 94:46]
  assign sidebandChannel_io_to_lower_layer_rx_bits = io_sbAfe_rxData; // @[src/main/scala/logphy/LogicalPhy.scala 116:19]
  assign sidebandChannel_io_to_lower_layer_rx_clock = io_sbAfe_rxClock; // @[src/main/scala/logphy/LogicalPhy.scala 117:20]
  assign sidebandChannel_io_inner_inputMode = trainingModule_io_sidebandFSMIO_txMode; // @[src/main/scala/logphy/LogicalPhy.scala 101:38]
  assign sidebandChannel_io_inner_rxMode = trainingModule_io_sidebandFSMIO_rxMode; // @[src/main/scala/logphy/LogicalPhy.scala 102:35]
  assign sidebandChannel_io_inner_rawInput_valid = trainingModule_io_sidebandFSMIO_patternTxData_valid; // @[src/main/scala/logphy/LogicalPhy.scala 100:37]
  assign sidebandChannel_io_inner_rawInput_bits = trainingModule_io_sidebandFSMIO_patternTxData_bits; // @[src/main/scala/logphy/LogicalPhy.scala 100:37]
  assign sidebandChannel_io_inner_switcherBundle_node_to_layer_below_ready =
    trainingModule_io_sidebandFSMIO_rxData_ready; // @[src/main/scala/logphy/LogicalPhy.scala 99:63]
  assign sidebandChannel_io_inner_switcherBundle_layer_to_node_below_valid =
    trainingModule_io_sidebandFSMIO_packetTxData_valid; // @[src/main/scala/logphy/LogicalPhy.scala 98:63]
  assign sidebandChannel_io_inner_switcherBundle_layer_to_node_below_bits =
    trainingModule_io_sidebandFSMIO_packetTxData_bits; // @[src/main/scala/logphy/LogicalPhy.scala 98:63]
endmodule
