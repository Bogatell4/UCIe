`include "SB_codex_pkg.vh" //could be a package with .sv termination. need to do it like this so my EDA tools work

module LTSM_top (

input clk_100MHz,
input clk_800MHz,
input clk_2GHz,
input reset,
input enable_i,

input start_LT_i,

//SB Pins
output SB_clkPin_TX_o,
output SB_dataPin_TX_o,
input SB_clkPin_RX_i,
input SB_dataPin_RX_i,

//MB Pins
input [1:0] MB_clkPins_i,
input [15:0] MB_dataPins_i,
output [1:0] MB_clkPins_o,
output [15:0] MB_dataPins_o
);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// INTERNAL SIGNALS //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

wire SB_msg_valid_i_w;
reg SB_msg_req_flag;
reg SB_msg_req;

wire SB_TX_valid_w;
reg SB_TX_valid_flag;
wire SB_TX_valid_ack_w;
reg enable_SB_tx;
reg enable_SB_rx;

SB_msg_t SB_msg_RX;
SB_msg_t SB_msg_TX;
wire [63:0] SB_msg64_TX_o_w;
wire [63:0] SB_msg64_RX_i_w;

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
wire [1:0] MB_clkPins_TX_MBTRAIN;
wire [15:0] MB_dataPins_TX_MBTRAIN;
//wire [1:0] MB_clkPins_TX_TRANSMITTER; Unused for now, use when MB modules are instantiated
//wire [15:0] MB_dataPins_TX_TRANSMITTER;

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

// State done signals
wire SBINIT_done;
wire MBINIT_done;
wire MBTRAIN_done;
wire LINKINIT_done;
//wire ACTIVE_done; needed? review active state or PHYRETRAIN flag?

// TX msg output variables for multiplexers
SB_msg_t SB_msg_TX_SBINIT;
SB_msg_t SB_msg_TX_MBINIT;
SB_msg_t SB_msg_TX_MBTRAIN;
SB_msg_t SB_msg_TX_LINKINIT;
SB_msg_t SB_msg_TX_ACTIVE;
SB_msg_t SB_msg_TX_TRAINERROR;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MULTIPLEXERS //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Mux logic, selecting the source depending on current state
assign SB_clkPin_TX_o  = (LT_Current_state == SBINIT) ? SB_clkPin_TX_SBINIT:
                        //TODOOO, when pattern is detected switch to transmiter
                        (LT_Current_state == RESET) ? '0  : SB_clkPin_TX_TRANSMITTER;

assign SB_dataPin_TX_o  = (LT_Current_state == SBINIT) ? SB_dataPin_TX_SBINIT:
                        (LT_Current_state == RESET) ? '0  : SB_dataPin_TX_TRANSMITTER;

assign MB_clkPins_o    = (LT_Current_state == RESET) ? 'z    :
                        (LT_Current_state == SBINIT) ? 'z    :
                        (LT_Current_state == MBINIT) ? MB_clkPins_TX_MBINIT :
                        (LT_Current_state == MBTRAIN) ? MB_clkPins_TX_MBTRAIN :
                        (LT_Current_state == LINKINIT) ? MB_clkPins_TX_LINKINIT : MB_clkPins_TX_TRANSMITTER;

assign MB_dataPins_o    = (LT_Current_state == RESET) ? 'z    :
                        (LT_Current_state == SBINIT) ? 'z    :
                        (LT_Current_state == MBINIT) ? MB_dataPins_TX_MBINIT :
                        (LT_Current_state == MBTRAIN) ? MB_dataPins_TX_MBTRAIN :
                        (LT_Current_state == LINKINIT) ? MB_dataPins_TX_LINKINIT : MB_dataPins_TX_TRANSMITTER;

 assign SB_TX_valid_w = (LT_Current_state == SBINIT) ? SB_TX_valid_SBINIT :
                        (LT_Current_state == MBINIT) ? SB_TX_valid_MBINIT :
                        (LT_Current_state == MBTRAIN) ? SB_TX_valid_MBTRAIN :
                        (LT_Current_state == LINKINIT) ? SB_TX_valid_LINKINIT :
                        (LT_Current_state == ACTIVE) ? SB_TX_valid_ACTIVE :
                        (LT_Current_state == TRAINERROR) ? SB_TX_valid_TRAINERROR : 1'b0;

assign SB_msg_req = (LT_Current_state == SBINIT) ? SB_RX_msgReq_SBINIT :
                        (LT_Current_state == MBINIT) ? SB_RX_msgReq_MBINIT :
                        (LT_Current_state == MBTRAIN) ? SB_RX_msgReq_MBTRAIN :
                        (LT_Current_state == LINKINIT) ? SB_RX_msgReq_LINKINIT :
                        (LT_Current_state == ACTIVE) ? SB_RX_msgReq_ACTIVE :
                        (LT_Current_state == TRAINERROR) ? SB_RX_msgReq_TRAINERROR : 1'b0;

assign SB_msg_TX = (LT_Current_state == SBINIT) ? SB_msg_TX_SBINIT :
                        (LT_Current_state == MBINIT) ? SB_msg_TX_MBINIT :
                        (LT_Current_state == MBTRAIN) ? SB_msg_TX_MBTRAIN :
                        (LT_Current_state == LINKINIT) ? SB_msg_TX_LINKINIT :
                        (LT_Current_state == ACTIVE) ? SB_msg_TX_ACTIVE :
                        (LT_Current_state == TRAINERROR) ? SB_msg_TX_TRAINERROR : reset_SB_msg();

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MODULE INSTANTIATIONS //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

SB_TX #(
    .buffer_size(4)
) SB_tx_inst (
    .clk_800MHz(clk_800MHz),
    .reset(reset),
    .data_i(SB_msg64_TX_o_w),
    .valid_i(SB_TX_valid_flag),
    .enable_i(),
    .data_valid_ack_o(SB_TX_valid_ack_w),
    .dataPin_o(SB_dataPin_TX_TRANSMITTER),
    .clkPin_o(SB_clkPin_TX_TRANSMITTER)
);

//logic for set and async reset of SB_TX_valid_flag
// MAYBE NOT NEEDED use if too many msgs are sent out at once
always_ff @(reset or posedge SB_TX_valid_ack_w or posedge SB_TX_valid_w) begin
    if (reset) SB_TX_valid_flag <= 1'b0;
    else if (SB_TX_valid_ack_w) SB_TX_valid_flag <= 1'b0;
    else if (SB_TX_valid_w) SB_TX_valid_flag <= 1'b1;
end

// Instantiate SB_RX
SB_RX #(
    .buffer_size(4)
) SB_rx_inst (
    .clk_800MHz(clk_800MHz),
    .clk_100MHz(clk_100MHz),
    .reset(reset),
    .enable_i(),
    .msg_req_i(SB_msg_req_flag),
    .dataPin_i(SB_dataPin_RX_i), 
    .clkPin_i(SB_clkPin_RX_i),  
    .data_o(SB_msg64_RX_i_w),
    .valid_o(SB_msg_valid_i_w)
);

//logic for set and async reset of SB_msg_req_flag
// MAYBE NOT NEEDED use if too many msgs come out at once
always_ff @(reset or posedge SB_msg_valid_i_w or posedge SB_msg_req) begin
    if (reset) SB_msg_req_flag <= 1'b0;
    else if (SB_msg_valid_i_w) SB_msg_req_flag <= 1'b0;
    else if (SB_msg_req) SB_msg_req_flag <= 1'b1;
end

// Instantiate SBINIT
SBINIT sbinit_inst (
    .clk_100MHz(clk_100MHz),
    .clk_800MHz(clk_800MHz),
    .reset(reset),
    .enable_i(enable_SBINIT),
    .SB_clkPin_RX_i(SB_clkPin_RX_i),
    .SB_dataPin_RX_i(SB_dataPin_RX_i),
    .SB_clkPin_TX_o(SB_clkPin_TX_SBINIT),
    .SB_dataPin_TX_o(SB_dataPin_TX_SBINIT),
    .SBINIT_done_o(SBINIT_done),
    .TX_msg_o(SB_msg_TX_SBINIT),
    .TX_msg_valid_o(SB_TX_valid_SBINIT),
    .RX_msg_i(SB_msg_RX),
    .RX_msg_req_o(SB_RX_msgReq_SBINIT),
    .RX_msg_valid_i(SB_msg_valid_i_w)
);

// Instantiate MBINIT
MBINIT mbinit_inst (
    .clk_100MHz(clk_100MHz),
    .clk_800MHz(clk_800MHz),
    .clk_2GHz(clk_2GHz),
    .reset(reset),
    .enable_i(enable_MBINIT),
    .MB_clkPins_RX_MBINIT_i(MB_clkPins_i),
    .MB_dataPins_RX_MBINIT_i(MB_dataPins_i),
    .MB_clkPins_TX_MBINIT_o(MB_clkPins_TX_MBINIT),
    .MB_dataPins_TX_MBINIT_o(MB_dataPins_TX_MBINIT),
    .MBINIT_done_o(MBINIT_done),
    .TX_msg_o(SB_msg_TX_MBINIT),
    .TX_msg_valid_o(SB_TX_valid_MBINIT),
    .RX_msg_i(SB_msg_RX),
    .RX_msg_valid_i(SB_msg_valid_i_w),
    .RX_msg_req_o(SB_RX_msgReq_MBINIT)
);

// Instantiate MBTRAIN
MBTRAIN mbtrain_inst (
    .clk_100MHz(clk_100MHz),
    .clk_800MHz(clk_800MHz),
    .clk_2GHz(clk_2GHz),
    .reset(reset),
    .enable_i(enable_MBTRAIN),
    .MB_clkPins_RX_MBTRAIN_i(MB_clkPins_i),
    .MB_dataPins_RX_MBTRAIN_i(MB_dataPins_i),
    .MB_clkPins_TX_MBTRAIN_o(MB_clkPins_TX_MBTRAIN),
    .MB_dataPins_TX_MBTRAIN_o(MB_dataPins_TX_MBTRAIN),
    .MTRAIN_done_o(MBTRAIN_done),
    .TX_msg_o(SB_msg_TX_MBINIT),
    .TX_msg_valid_o(SB_TX_valid_MBTRAIN),
    .RX_msg_i(SB_msg_RX),
    .RX_msg_valid_i(SB_msg_valid_i_w),
    .RX_msg_req_o(SB_RX_msgReq_MBTRAIN)
);

// Instantiate LINKINIT
LINKINIT linkinit_inst (
    .clk_100MHz(clk_100MHz),
    .clk_800MHz(clk_800MHz),
    .clk_2GHz(clk_2GHz),
    .reset(reset),
    .enable_i(enable_LINKINIT),
    .LINKINIT_done_o(LINKINIT_done),
    .TX_msg_o(SB_msg_TX_MBINIT),
    .TX_msg_valid_o(SB_TX_valid_LINKINIT),
    .RX_msg_i(SB_msg_RX),
    .RX_msg_valid_i(SB_msg_valid_i_w),
    .RX_msg_req_o(SB_RX_msgReq_LINKINIT)
);

// Instantiate ACTIVE
ACTIVE active_inst (
    .clk_100MHz(clk_100MHz),
    .clk_800MHz(clk_800MHz),
    .clk_2GHz(clk_2GHz),
    .reset(reset),
    .enable_i(enable_ACTIVE),
    .ACTIVE_done_o(),
    .TX_msg_o(SB_msg_TX_MBINIT),
    .TX_msg_valid_o(SB_TX_valid_ACTIVE),
    .RX_msg_i(SB_msg_RX),
    .RX_msg_valid_i(SB_msg_valid_i_w),
    .RX_msg_req_o(SB_RX_msgReq_ACTIVE)
);

TRAINERROR trainerror_inst (
    .clk_100MHz(clk_100MHz),
    .clk_800MHz(clk_800MHz),
    .clk_2GHz(clk_2GHz),
    .reset(reset),
    .enable_i(enable_TRAINERROR),
    .TRAINERROR_done_o(),
    .TX_msg_o(SB_msg_TX_MBINIT),
    .TX_msg_valid_o(SB_TX_valid_TRAINERROR),
    .RX_msg_i(SB_msg_RX),
    .RX_msg_valid_i(SB_msg_valid_i_w),
    .RX_msg_req_o(SB_RX_msgReq_TRAINERROR)
);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// STATE MACHINE LOGIC //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Current State logic
always_comb begin
    unique case (LT_Current_state)

        RESET: begin            // Reset all internal signals
            SB_msg_RX = reset_SB_msg();
            SB_msg_TX = reset_SB_msg();
            enable_SB_rx = 1'b1;
            enable_SB_tx = 1'b0;
            SB_msg_req = 1'b0;
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
    if (timeout_flag) begin
        LT_NEXT_state = TRAINERROR; // If timeout, go to TRAINERROR state
    end else begin
    unique case (LT_Current_state)

        RESET: begin
            if (enable_i && start_LT_i && counter_reset_flag) LT_NEXT_state = SBINIT;
            else LT_NEXT_state = LT_Current_state; // Stay in RESET state
        end

        SBINIT: begin
            if (SBINIT_done) LT_NEXT_state = MBINIT; 
            else LT_NEXT_state = LT_Current_state;
        end

        MBINIT: begin
            if (MBINIT_done) LT_NEXT_state = MBTRAIN; 
            else LT_NEXT_state = LT_Current_state;
        end

        MBTRAIN: begin
            if (MBTRAIN_done) LT_NEXT_state = LINKINIT; 
            else LT_NEXT_state = LT_Current_state;
        end
        LINKINIT: begin
            if (LINKINIT_done) LT_NEXT_state = LINKINIT; 
            else LT_NEXT_state = LT_Current_state;
        end
        ACTIVE: begin //REVIEW
            
        end
        TRAINERROR: begin
            LT_NEXT_state = RESET; //REVIEW
        end
        L1_L2: begin //REVIEW
        end
        default: LT_NEXT_state = RESET;
    endcase
end
end

//Current state update
always_ff @(posedge clk_100MHz or posedge reset) begin
    if (reset) LT_Current_state <= RESET;
    else LT_Current_state <= LT_NEXT_state;
end


// 4ms counter for 100MHz clock,
// always need to stay 4ms when entering RESET state, modify this value if needed
reg [18:0] reset_counter; // 19 bits are enough for 400,000
wire counter_reset_flag = (reset_counter == 19'd399_999); // 4ms counter reset flag
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
// always need to stay 4ms when entering RESET state, modify this value if needed
reg [19:0] timeout_counter; // 19 bits are enough for 800,000
wire timeout_flag = (timeout_counter == 20'd799_999); // 8ms counter timeout flag
logic reset_timeout_counter; // used to reset timout counter for other states if needed
logic reset_state_timeout_counter;

always @ (posedge clk_100MHz or reset) begin
    if (reset) begin
        timeout_counter <= 0;
    end else if (reset_timeout_counter) begin 
        timeout_counter <= 0;     
    end else if (reset_state_timeout_counter) begin
        timeout_counter <= 0;
    end else if (LT_Current_state == LT_NEXT_state) begin
        timeout_counter <= timeout_counter + 1;
    end
end

//This states don't have a timeout condition
always_comb begin
    if (LT_Current_state == RESET ||
        LT_Current_state == ACTIVE ||
        LT_Current_state == L1_L2 ||
        LT_Current_state == TRAINERROR) begin
        reset_state_timeout_counter = 1'b1;
        end
    else reset_state_timeout_counter = 1'b0;
end

endmodule
