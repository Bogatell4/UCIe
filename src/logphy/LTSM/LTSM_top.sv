`include "SB_codex_pkg.vh" //could be a package with .sv termination. need to do it like this so my EDA tools work

module LTSM_top (

input clk_100MHz,
input clk_800MHz,
input clk_2GHz,
input reset,
input enable_i,

input start_LT_i,
output LTSM_active_state_o,

//SB Pins
output SB_clkPin_TX_o,
output SB_dataPin_TX_o,
input SB_clkPin_RX_i,
input SB_dataPin_RX_i,

//MB Pins
input [1:0] MB_clkPins_i,
input MB_validPin_i,
input MB_trackPin_i,
input [15:0] MB_dataPins_i,
output MB_TX_validPin_o,
output MB_TX_trackPin_o,
output [1:0] MB_clkPins_o,
output [15:0] MB_dataPins_o
);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// INTERNAL SIGNALS //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

wire SB_msg_valid_i_w;
wire SB_msg_available_i_w;
logic SB_msg_req;

wire SB_TX_valid_w;
wire SB_TX_sendNext_w;
logic enable_SB_tx;
logic enable_SB_rx;

SB_msg_t SB_msg_RX;
SB_msg_t SB_msg_TX;
wire [63:0] SB_dataBus_TX;
wire [63:0] SB_dataBus_RX;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Signal Sources for the muxes
// SB sources
wire SB_clkPin_TX_SBINIT;
wire SB_dataPin_TX_SBINIT;
wire SB_clkPin_TX_TRANSMITTER;
wire SB_dataPin_TX_TRANSMITTER;

// MB sources
wire [1:0] MB_clkPins_TX_MBINIT;
wire [15:0] MB_dataPins_TX_MBINIT;
wire MB_validPin_TX_MBINIT;
wire MB_trackPin_TX_MBINIT;

wire [1:0] MB_clkPins_TX_MBTRAIN;
wire [15:0] MB_dataPins_TX_MBTRAIN;
wire MB_validPin_TX_MBTRAIN;
wire MB_trackPin_TX_MBTRAIN;

wire [1:0] MB_clkPins_TX_LINKINIT;
wire [15:0] MB_dataPins_TX_LINKINIT;
wire MB_validPin_TX_LINKINIT;
wire MB_trackPin_TX_LINKINIT;

wire [1:0] MB_clkPins_TX_ACTIVE;
wire [15:0] MB_dataPins_TX_ACTIVE;
wire MB_validPin_TX_ACTIVE;
wire MB_trackPin_TX_ACTIVE;


// SB valid sources
wire SB_TX_valid_SBINIT;
wire SB_TX_valid_MBINIT;
wire SB_TX_valid_MBTRAIN;
wire SB_TX_valid_LINKINIT;
wire SB_TX_valid_ACTIVE;
wire SB_TX_valid_TRAINERROR;

// SB msg Request sources
wire SB_RX_msgReq_SBINIT;
wire SB_RX_msgReq_MBINIT;
wire SB_RX_msgReq_MBTRAIN;
wire SB_RX_msgReq_LINKINIT;
wire SB_RX_msgReq_ACTIVE;
wire SB_RX_msgReq_TRAINERROR;

// State Machine Signals
typedef enum logic [2:0] { 
    RESET = 3'd0,
    SBINIT = 3'd1,
    MBINIT = 3'd2,
    MBTRAIN = 3'd3,
    LINKINIT = 3'd4,
    ACTIVE = 3'd5,
    L1_L2 = 3'd6,
    TRAINERROR = 3'd7
} LT_state_t;

LT_state_t LT_Current_state;
LT_state_t LT_NEXT_state;

// State enable signals
wire enable_SBINIT;
wire enable_MBINIT;
wire enable_MBTRAIN;
wire enable_LINKINIT;
wire enable_TRAINERROR;
wire enable_ACTIVE;

// Enable assignations depending on current state
assign enable_SBINIT = (LT_Current_state == SBINIT);
assign enable_MBINIT = (LT_Current_state == MBINIT);
assign enable_MBTRAIN = (LT_Current_state == MBTRAIN);
assign enable_LINKINIT = (LT_Current_state == LINKINIT);
assign enable_TRAINERROR = (LT_Current_state == TRAINERROR);
assign enable_ACTIVE = (LT_Current_state == ACTIVE);

assign LTSM_active_state_o = (LT_Current_state == ACTIVE);

//reset state signals
logic reset_SBINIT;
logic reset_MBINIT;
logic reset_MBTRAIN;
logic reset_LINKINIT;
logic reset_ACTIVE;
logic reset_TRAINERROR;

assign reset_SBINIT      = reset | (LT_Current_state != SBINIT);
assign reset_MBINIT      = reset | (LT_Current_state != MBINIT);
assign reset_MBTRAIN     = reset | (LT_Current_state != MBTRAIN);
assign reset_LINKINIT    = reset | (LT_Current_state != LINKINIT);
assign reset_ACTIVE      = reset | (LT_Current_state != ACTIVE);
assign reset_TRAINERROR  = reset | (LT_Current_state != TRAINERROR);

// State done signals
wire SBINIT_done;
wire MBINIT_done;
wire MBTRAIN_done;
wire LINKINIT_done;
wire ACTIVE_done;
wire TRAINERROR_done;

// TX msg output variables for multiplexers
SB_msg_t SB_msg_TX_SBINIT;
SB_msg_t SB_msg_TX_MBINIT;
SB_msg_t SB_msg_TX_MBTRAIN;
SB_msg_t SB_msg_TX_LINKINIT;
SB_msg_t SB_msg_TX_ACTIVE;
SB_msg_t SB_msg_TX_TRAINERROR;

// SB TX data bus mux sources
wire [63:0] SB_dataBus_TX_SBINIT;
wire [63:0] SB_dataBus_TX_MBINIT;
wire [63:0] SB_dataBus_TX_MBTRAIN;
wire [63:0] SB_dataBus_TX_LINKINIT;
wire [63:0] SB_dataBus_TX_ACTIVE;
wire [63:0] SB_dataBus_TX_TRAINERROR;

// reset_state_timeout_counter signal sources
wire reset_timeout_counter_SBINIT;
wire reset_timeout_counter_MBINIT;
wire reset_timeout_counter_MBTRAIN;
wire reset_timeout_counter_LINKINIT;
wire reset_timeout_counter_ACTIVE;
wire reset_timeout_counter_TRAINERROR; 

wire enable_SB_rx_SBINIT;
wire enable_SB_tx_SBINIT;
wire enable_SB_rx_TRAINERROR;
wire enable_SB_tx_TRAINERROR;

wire reset_message_retry_timeout_SBINIT;
wire reset_message_retry_timeout_MBINIT;
wire reset_message_retry_timeout_MBTRAIN;
wire reset_message_retry_timeout_LINKINIT;
wire reset_message_retry_timeout_ACTIVE;
wire reset_message_retry_timeout_TRAINERROR;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MULTIPLEXERS //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Mux logic, selecting the source depending on current state
assign SB_clkPin_TX_o      = (LT_Current_state == RESET)      ? '0                       :
                             (enable_SB_tx_SBINIT == 1'b1) ?  SB_clkPin_TX_TRANSMITTER :
                             (LT_Current_state == SBINIT)     ? SB_clkPin_TX_SBINIT      : SB_clkPin_TX_TRANSMITTER;

assign SB_dataPin_TX_o     = (LT_Current_state == RESET)      ? '0                       :
                             (enable_SB_tx_SBINIT == 1'b1) ?  SB_dataPin_TX_TRANSMITTER :
                             (LT_Current_state == SBINIT)     ? SB_dataPin_TX_SBINIT     : SB_dataPin_TX_TRANSMITTER;

assign enable_SB_rx        = (LT_Current_state == RESET)      ? 1'b0                     :
                             (LT_Current_state == SBINIT)     ? enable_SB_rx_SBINIT      :
                             (LT_Current_state == TRAINERROR) ? enable_SB_rx_TRAINERROR  : 1'b1;

assign enable_SB_tx        = (LT_Current_state == RESET)      ? 1'b0                     :
                             (LT_Current_state == SBINIT)     ? enable_SB_tx_SBINIT      : 
                             (LT_Current_state == TRAINERROR) ? enable_SB_tx_TRAINERROR  : 1'b1;

assign MB_clkPins_o        = (LT_Current_state == RESET)      ? 'z                       :
                             (LT_Current_state == SBINIT)     ? 'z                       :
                             (LT_Current_state == MBINIT)     ? MB_clkPins_TX_MBINIT     :
                             (LT_Current_state == MBTRAIN)    ? MB_clkPins_TX_MBTRAIN    : 
                             (LT_Current_state == LINKINIT)   ? MB_clkPins_TX_LINKINIT   : MB_clkPins_TX_ACTIVE;

assign MB_dataPins_o       = (LT_Current_state == RESET)      ? 'z                       :
                             (LT_Current_state == SBINIT)     ? 'z                       :
                             (LT_Current_state == MBINIT)     ? MB_dataPins_TX_MBINIT    :
                             (LT_Current_state == MBTRAIN)    ? MB_dataPins_TX_MBTRAIN   :
                             (LT_Current_state == LINKINIT)   ? MB_dataPins_TX_LINKINIT  : MB_dataPins_TX_ACTIVE;

assign MB_TX_validPin_o    = (LT_Current_state == RESET)      ? 1'bz                     :
                             (LT_Current_state == SBINIT)     ? 1'bz                     :
                             (LT_Current_state == MBINIT)     ? MB_validPin_TX_MBINIT    :
                             (LT_Current_state == MBTRAIN)    ? MB_validPin_TX_MBTRAIN   :
                             (LT_Current_state == LINKINIT)   ? MB_validPin_TX_LINKINIT  : MB_validPin_TX_ACTIVE;

assign MB_TX_trackPin_o    = (LT_Current_state == RESET)      ? 1'bz                     :
                             (LT_Current_state == SBINIT)     ? 1'bz                     :
                             (LT_Current_state == MBINIT)     ? MB_trackPin_TX_MBINIT    :
                             (LT_Current_state == MBTRAIN)    ? MB_trackPin_TX_MBTRAIN   :
                             (LT_Current_state == LINKINIT)   ? MB_trackPin_TX_LINKINIT  : MB_trackPin_TX_ACTIVE;

assign SB_TX_valid_w       = (LT_Current_state == SBINIT)     ? SB_TX_valid_SBINIT       :
                             (LT_Current_state == MBINIT)     ? SB_TX_valid_MBINIT       :
                             (LT_Current_state == MBTRAIN)    ? SB_TX_valid_MBTRAIN      :
                             (LT_Current_state == LINKINIT)   ? SB_TX_valid_LINKINIT     :
                             (LT_Current_state == ACTIVE)     ? SB_TX_valid_ACTIVE       :
                             (LT_Current_state == TRAINERROR) ? SB_TX_valid_TRAINERROR   : 1'b0;

assign SB_msg_req          = (LT_Current_state == RESET)      ? 1'b0                     :
                             (LT_Current_state == SBINIT)     ? SB_RX_msgReq_SBINIT      :
                             (LT_Current_state == MBINIT)     ? SB_RX_msgReq_MBINIT      :
                             (LT_Current_state == MBTRAIN)    ? SB_RX_msgReq_MBTRAIN     :
                             (LT_Current_state == LINKINIT)   ? SB_RX_msgReq_LINKINIT    :
                             (LT_Current_state == ACTIVE)     ? SB_RX_msgReq_ACTIVE      :
                             (LT_Current_state == TRAINERROR) ? SB_RX_msgReq_TRAINERROR  : 1'b0;

assign SB_msg_TX           = (LT_Current_state == RESET)      ? '0                       :
                             (LT_Current_state == SBINIT)     ? SB_msg_TX_SBINIT         :
                             (LT_Current_state == MBINIT)     ? SB_msg_TX_MBINIT         :
                             (LT_Current_state == MBTRAIN)    ? SB_msg_TX_MBTRAIN        :
                             (LT_Current_state == LINKINIT)   ? SB_msg_TX_LINKINIT       :
                             (LT_Current_state == ACTIVE)     ? SB_msg_TX_ACTIVE         :
                             (LT_Current_state == TRAINERROR) ? SB_msg_TX_TRAINERROR     : reset_SB_msg();

assign reset_timeout_counter = (LT_Current_state == RESET)      ? 1'b1                     :
                              (LT_Current_state == SBINIT)     ? reset_timeout_counter_SBINIT     :
                              (LT_Current_state == MBINIT)     ? reset_timeout_counter_MBINIT     :
                              (LT_Current_state == MBTRAIN)    ? reset_timeout_counter_MBTRAIN    :
                              (LT_Current_state == LINKINIT)   ? reset_timeout_counter_LINKINIT   :
                              (LT_Current_state == ACTIVE)     ? reset_timeout_counter_ACTIVE     :
                              (LT_Current_state == TRAINERROR) ? reset_timeout_counter_TRAINERROR : 1'b0;

assign SB_dataBus_TX       = (LT_Current_state == RESET)      ? '0                       :
                             (LT_Current_state == SBINIT)     ? SB_dataBus_TX_SBINIT     :
                             (LT_Current_state == MBINIT)     ? SB_dataBus_TX_MBINIT     :
                             (LT_Current_state == MBTRAIN)    ? SB_dataBus_TX_MBTRAIN    :
                             (LT_Current_state == LINKINIT)   ? SB_dataBus_TX_LINKINIT   :
                             (LT_Current_state == ACTIVE)     ? SB_dataBus_TX_ACTIVE     :
                             (LT_Current_state == TRAINERROR) ? SB_dataBus_TX_TRAINERROR : 64'h0;

assign reset_message_retry_timeout = (LT_Current_state == RESET)      ? 1'b1                     :
                                    (LT_Current_state == SBINIT)     ? reset_message_retry_timeout_SBINIT     :
                                    (LT_Current_state == MBINIT)     ? reset_message_retry_timeout_MBINIT     :
                                    (LT_Current_state == MBTRAIN)    ? reset_message_retry_timeout_MBTRAIN    :
                                    (LT_Current_state == LINKINIT)   ? reset_message_retry_timeout_LINKINIT   :
                                    (LT_Current_state == ACTIVE)     ? reset_message_retry_timeout_ACTIVE     :
                                    (LT_Current_state == TRAINERROR) ? reset_message_retry_timeout_TRAINERROR : 1'b1;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MODULE INSTANTIATIONS //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

SB_TX #(
    .fast_buffer_size(8)
) SB_tx_inst (
    .clk_800MHz(clk_800MHz),
    .clk_100MHz(clk_100MHz),
    .reset(reset),
    .SB_msg_i(SB_msg_TX),
    .dataBus_i(SB_dataBus_TX),
    .valid_i(SB_TX_valid_w),
    .enable_i(enable_SB_tx),
    .send_next_flag_o(SB_TX_sendNext_w),
    .dataPin_o(SB_dataPin_TX_TRANSMITTER),
    .clkPin_o(SB_clkPin_TX_TRANSMITTER)
);

SB_RX #(
    .slow_buffer_size(4)
) SB_rx_inst (
    .clk_800MHz(clk_800MHz),
    .clk_100MHz(clk_100MHz),
    .reset(reset),
    .enable_i(enable_SB_rx),
    .msg_req_i(SB_msg_req),
    .SB_msg_o(SB_msg_RX),
    .msg_available_o(SB_msg_available_i_w),
    .dataPin_i(SB_dataPin_RX_i), 
    .clkPin_i(SB_clkPin_RX_i),  
    .data_o(SB_dataBus_RX),
    .valid_o(SB_msg_valid_i_w)
);

// Instantiate SBINIT
SBINIT sbinit_inst (
    .clk_100MHz(clk_100MHz),
    .clk_800MHz(clk_800MHz),
    .reset(reset_SBINIT),
    .enable_i(enable_SBINIT),
    .SBINIT_done_o(SBINIT_done),

    // SB Pins
    .SB_clkPin_RX_i(SB_clkPin_RX_i),
    .SB_dataPin_RX_i(SB_dataPin_RX_i),
    .SB_clkPin_TX_o(SB_clkPin_TX_SBINIT),
    .SB_dataPin_TX_o(SB_dataPin_TX_SBINIT),

    // SB Communication ports
    .SB_TX_msg_o(SB_msg_TX_SBINIT),
    .SB_TX_dataBus_o(SB_dataBus_TX_SBINIT),
    .SB_TX_msg_valid_o(SB_TX_valid_SBINIT),
    .SB_TX_msg_sendNextFlag_i(SB_TX_sendNext_w),

    .SB_RX_msg_i(SB_msg_RX),
    .SB_RX_dataBus_i(SB_dataBus_RX),
    .SB_RX_msg_req_o(SB_RX_msgReq_SBINIT),
    .SB_RX_msg_valid_i(SB_msg_valid_i_w),
    .SB_RX_msg_available_i(SB_msg_available_i_w),

    .SBmessage_retry_timeout_flag(message_retry_timeout_flag),
    .reset_SBmessage_retry_timeout(reset_message_retry_timeout_SBINIT),

    // SBINIT specific outputs
    .enable_SB_tx(enable_SB_tx_SBINIT),
    .enable_SB_rx(enable_SB_rx_SBINIT),
    .reset_state_timeout_counter_o(reset_timeout_counter_SBINIT)
);

// Instantiate MBINIT
MBINIT mbinit_inst (
    .clk_100MHz(clk_100MHz),
    .clk_800MHz(clk_800MHz),
    .clk_2GHz(clk_2GHz),
    .reset(reset_MBINIT),
    .enable_i(enable_MBINIT),
    .MBINIT_done_o(MBINIT_done),

    // MB Pins
    .MB_RX_validPin_i(MB_validPin_i),
    .MB_RX_trackPin_i(MB_trackPin_i),
    .MB_RX_clkPins_i(MB_clkPins_i),
    .MB_RX_dataPins_i(MB_dataPins_i),
    .MB_TX_validPin_o(MB_validPin_TX_MBINIT),
    .MB_TX_trackPin_o(MB_trackPin_TX_MBINIT),
    .MB_TX_clkPins_o(MB_clkPins_TX_MBINIT),
    .MB_TX_dataPins_o(MB_dataPins_TX_MBINIT),

    // SB Communication ports
    .SB_TX_msg_o(SB_msg_TX_MBINIT),
    .SB_TX_dataBus_o(SB_dataBus_TX_MBINIT),
    .SB_TX_msg_valid_o(SB_TX_valid_MBINIT),
    .SB_TX_msg_sendNextFlag_i(SB_TX_sendNext_w),

    .SB_RX_msg_i(SB_msg_RX),
    .SB_RX_dataBus_i(SB_dataBus_RX),
    .SB_RX_msg_req_o(SB_RX_msgReq_MBINIT),
    .SB_RX_msg_valid_i(SB_msg_valid_i_w),
    .SB_RX_msg_available_i(SB_msg_available_i_w),

    .SBmessage_retry_timeout_flag(message_retry_timeout_flag),
    .reset_SBmessage_retry_timeout(reset_message_retry_timeout_MBINIT),

    .reset_state_timeout_counter_o(reset_timeout_counter_MBINIT)
);

// Instantiate MBTRAIN
MBTRAIN mbtrain_inst (
    .clk_100MHz(clk_100MHz),
    .clk_800MHz(clk_800MHz),
    .clk_2GHz(clk_2GHz),
    .reset(reset_MBTRAIN),
    .enable_i(enable_MBTRAIN),
    .MBTRAIN_done_o(MBTRAIN_done),

    // MB Pins
    .MB_RX_validPin_i(MB_validPin_i),
    .MB_RX_trackPin_i(MB_trackPin_i),
    .MB_RX_clkPins_i(MB_clkPins_i),
    .MB_RX_dataPins_i(MB_dataPins_i),
    .MB_TX_validPin_o(MB_validPin_TX_MBTRAIN),
    .MB_TX_trackPin_o(MB_trackPin_TX_MBTRAIN),
    .MB_TX_clkPins_o(MB_clkPins_TX_MBTRAIN),
    .MB_TX_dataPins_o(MB_dataPins_TX_MBTRAIN),

    // SB Communication ports
    .SB_TX_msg_o(SB_msg_TX_MBTRAIN),
    .SB_TX_dataBus_o(SB_dataBus_TX_MBTRAIN),
    .SB_TX_msg_valid_o(SB_TX_valid_MBTRAIN),
    .SB_TX_msg_sendNextFlag_i(SB_TX_sendNext_w),

    .SB_RX_msg_i(SB_msg_RX),
    .SB_RX_dataBus_i(SB_dataBus_RX),
    .SB_RX_msg_req_o(SB_RX_msgReq_MBTRAIN),
    .SB_RX_msg_valid_i(SB_msg_valid_i_w),
    .SB_RX_msg_available_i(SB_msg_available_i_w),

    .SBmessage_retry_timeout_flag(message_retry_timeout_flag),
    .reset_SBmessage_retry_timeout(reset_message_retry_timeout_MBTRAIN),

    .reset_state_timeout_counter_o(reset_timeout_counter_MBTRAIN)
);

// Instantiate LINKINIT
LINKINIT linkinit_inst (
    .clk_100MHz(clk_100MHz),
    .clk_800MHz(clk_800MHz),
    .clk_2GHz(clk_2GHz),
    .reset(reset_LINKINIT),
    .enable_i(enable_LINKINIT),
    .LINKINIT_done_o(LINKINIT_done),

    // MB Pins
    .MB_RX_validPin_i(MB_validPin_i),
    .MB_RX_trackPin_i(MB_trackPin_i),
    .MB_RX_clkPins_i(MB_clkPins_i),
    .MB_RX_dataPins_i(MB_dataPins_i),
    .MB_TX_validPin_o(MB_validPin_TX_LINKINIT),
    .MB_TX_trackPin_o(MB_trackPin_TX_LINKINIT),
    .MB_TX_clkPins_o(MB_clkPins_TX_LINKINIT),
    .MB_TX_dataPins_o(MB_dataPins_TX_LINKINIT),

    // SB Communication ports
    .SB_TX_msg_o(SB_msg_TX_LINKINIT),
    .SB_TX_dataBus_o(SB_dataBus_TX_LINKINIT),
    .SB_TX_msg_valid_o(SB_TX_valid_LINKINIT),
    .SB_TX_msg_sendNextFlag_i(SB_TX_sendNext_w),

    .SB_RX_msg_i(SB_msg_RX),
    .SB_RX_dataBus_i(SB_dataBus_RX),
    .SB_RX_msg_req_o(SB_RX_msgReq_LINKINIT),
    .SB_RX_msg_valid_i(SB_msg_valid_i_w),
    .SB_RX_msg_available_i(SB_msg_available_i_w),

    .SBmessage_retry_timeout_flag(message_retry_timeout_flag),
    .reset_SBmessage_retry_timeout(reset_message_retry_timeout_LINKINIT),

    .reset_state_timeout_counter_o(reset_timeout_counter_LINKINIT)
);

// Instantiate ACTIVE
// This module is used to handle the active state of the link with all MB communication
// Empty for now,
ACTIVE active_inst (
    .clk_100MHz(clk_100MHz),
    .clk_800MHz(clk_800MHz),
    .clk_2GHz(clk_2GHz),
    .reset(reset_ACTIVE),
    .enable_i(enable_ACTIVE),
    .ACTIVE_done_o(ACTIVE_done),

    // MB Pins
    .MB_RX_validPin_i(MB_validPin_i),
    .MB_RX_trackPin_i(MB_trackPin_i),
    .MB_RX_clkPins_i(MB_clkPins_i),
    .MB_RX_dataPins_i(MB_dataPins_i),
    .MB_TX_validPin_o(MB_validPin_TX_ACTIVE),
    .MB_TX_trackPin_o(MB_trackPin_TX_ACTIVE),
    .MB_TX_clkPins_o(MB_clkPins_TX_ACTIVE),
    .MB_TX_dataPins_o(MB_dataPins_TX_ACTIVE),

    // SB Communication ports
    .SB_TX_msg_o(SB_msg_TX_ACTIVE),
    .SB_TX_dataBus_o(SB_dataBus_TX_ACTIVE),
    .SB_TX_msg_valid_o(SB_TX_valid_ACTIVE),
    .SB_TX_msg_sendNextFlag_i(SB_TX_sendNext_w),

    .SB_RX_msg_i(SB_msg_RX),
    .SB_RX_dataBus_i(SB_dataBus_RX),
    .SB_RX_msg_req_o(SB_RX_msgReq_ACTIVE),
    .SB_RX_msg_valid_i(SB_msg_valid_i_w),

    .SBmessage_retry_timeout_flag(message_retry_timeout_flag),
    .reset_SBmessage_retry_timeout(reset_message_retry_timeout_ACTIVE),

    .reset_state_timeout_counter_o(reset_timeout_counter_ACTIVE)
);

// Instantiate TRAINERROR
// This module is used to handle errors during training, empty for now
TRAINERROR trainerror_inst (
    .clk_100MHz(clk_100MHz),
    .clk_800MHz(clk_800MHz),
    .reset(reset_TRAINERROR),
    .enable_i(enable_TRAINERROR),
    .TRAINERROR_done_o(TRAINERROR_done),

    // SB Communication ports
    .SB_TX_msg_o(SB_msg_TX_TRAINERROR),
    .SB_TX_dataBus_o(SB_dataBus_TX_TRAINERROR),
    .SB_TX_msg_valid_o(SB_TX_valid_TRAINERROR),
    .SB_TX_msg_sendNextFlag_i(SB_TX_sendNext_w),

    .SB_RX_msg_i(SB_msg_RX),
    .SB_RX_dataBus_i(SB_dataBus_RX),
    .SB_RX_msg_req_o(SB_RX_msgReq_TRAINERROR),
    .SB_RX_msg_valid_i(SB_msg_valid_i_w),

    .SBmessage_retry_timeout_flag(message_retry_timeout_flag),
    .reset_SBmessage_retry_timeout(reset_message_retry_timeout_TRAINERROR),

    // SBINIT specific outputs
    .enable_SB_tx(enable_SB_tx_TRAINERROR),
    .enable_SB_rx(enable_SB_rx_TRAINERROR),

    .reset_state_timeout_counter_o(reset_timeout_counter_TRAINERROR)
);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// STATE MACHINE LOGIC //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Current State logic
always_comb begin
    start_reset_counter = 1'b0;
    unique case (LT_Current_state)
        RESET: begin            // Reset all internal signals
            start_reset_counter = 1'b1;
        end

        SBINIT: begin
        end

        MBINIT: begin
        end

        MBTRAIN: begin 
        end

        LINKINIT: begin
        end

        ACTIVE: begin
        end

        TRAINERROR: begin
        end

        L1_L2: begin
        end

        default: begin
        end
    endcase
end

// Next state Combinational Logic
always_comb begin
    LT_NEXT_state = LT_Current_state;
    reset_stateChange_timeout_counter = 1'b0;
    if (timeout_flag) begin
        LT_NEXT_state = TRAINERROR;
    end else begin
        unique case (LT_Current_state)

            RESET: begin
                if (enable_i && start_LT_i && counter_reset_flag) begin
                    LT_NEXT_state = SBINIT;
                    reset_stateChange_timeout_counter = 1'b1;
                end
            end

            SBINIT: begin
                if (SBINIT_done) begin
                    LT_NEXT_state = MBINIT;
                    reset_stateChange_timeout_counter = 1'b1;
                end
            end

            MBINIT: begin
                if (MBINIT_done) begin
                    LT_NEXT_state = MBTRAIN;
                    reset_stateChange_timeout_counter = 1'b1;
                end
            end

            MBTRAIN: begin 
                if (MBTRAIN_done) begin
                    LT_NEXT_state = LINKINIT;
                    reset_stateChange_timeout_counter = 1'b1;
                end
            end

            LINKINIT: begin
                if (LINKINIT_done) begin
                    LT_NEXT_state = ACTIVE;
                    reset_stateChange_timeout_counter = 1'b1;
                end
            end

            ACTIVE: begin
            end

            TRAINERROR: begin
                if (TRAINERROR_done) begin
                    LT_NEXT_state = RESET;
                    reset_stateChange_timeout_counter = 1'b1;
                end
            end

            L1_L2: begin
            end

            default: begin
                LT_NEXT_state = RESET;
            end

        endcase
    end
end

//Current state update
always_ff @(posedge clk_100MHz or reset) begin
    if (reset) LT_Current_state <= RESET;
    else LT_Current_state <= LT_NEXT_state;
end

// 4ms counter for 100MHz clock,
// always need to stay 4ms when entering RESET state, modify this value if needed
reg [18:0] reset_counter; // 19 bits are enough for 400,000
// flag works, reduced on purpose to shorten simulation time, uncomment line below to establish 4ms out of reset time.
//wire counter_reset_flag = (reset_counter == 19'd399_999); // 4ms counter reset flag
wire counter_reset_flag = (reset_counter == 19'd99);
logic start_reset_counter;

always_ff @(posedge clk_100MHz or reset) begin
    if (reset) begin
        reset_counter <= 0;
    end else if (counter_reset_flag) begin
        reset_counter <= 0;
    end else if (start_reset_counter) begin
        reset_counter <= reset_counter + 1;
    end
end

// 8ms counter for 100MHz clock, Timeout
reg [19:0] timeout_counter; // 19 bits are enough for 800,000
wire timeout_flag = (timeout_counter == 20'd799_999); // 8ms counter timeout flag
logic reset_timeout_counter; // used to reset timout counter for other states if needed
logic reset_stateChange_timeout_counter;

always @ (posedge clk_100MHz or reset) begin
    if (reset) begin
        timeout_counter <= 0;
    end else if (reset_timeout_counter) begin 
        timeout_counter <= 0;     
    end else if (reset_stateChange_timeout_counter) begin
        timeout_counter <= 0;
    end else if (LT_Current_state == LT_NEXT_state) begin
        timeout_counter <= timeout_counter + 1;
    end
end

// 1us counter for 100MHz clock, Message Retry Timeout
// Will be used on all modules with SB communication, the 1us is chosen as a reasonable timeout
// based on simulation latency for SB messages. Like message windows more or less.
reg [6:0] message_retry_counter; // 7 bits are enough for 100 counts (1us at 100MHz)
wire message_retry_timeout_flag = (message_retry_counter == 7'd99); // 1us timeout flag
logic reset_message_retry_timeout; // used to reset the retry timeout counter

always_ff @(posedge clk_100MHz or reset) begin
    if (reset) begin
        message_retry_counter <= 0;
    end else if (reset_message_retry_timeout) begin
        message_retry_counter <= 0;
    end else begin
        message_retry_counter <= message_retry_counter + 1;
    end
end

endmodule
