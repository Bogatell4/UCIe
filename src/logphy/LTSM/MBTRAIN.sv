`include "SB_codex_pkg.vh"

module MBTRAIN (
    input clk_100MHz,
    input clk_800MHz,
    input clk_2GHz,
    input reset,
    input enable_i,

    output MBTRAIN_done_o,

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
    input SB_RX_msg_available_i,

    input  SBmessage_retry_timeout_flag,
    output reset_SBmessage_retry_timeout,

    output reset_state_timeout_counter_o
);

typedef enum logic [3:0] { 
    VALVREF = 4'd0,
    DATAVREF = 4'd1,
    SpeedIDLE = 4'd2,
    TXSelfCal = 4'd3,
    RXCLKCal = 4'd4,
    ValTrainCenter = 4'd5,
    DataTrainCenter1 = 4'd6,
    DataTrainVref = 4'd7,
    RXDeskew = 4'd8,
    DataTrainCenter2 = 4'd9,
    LinkSpeed = 4'd10
} MBTRAIN_state_t;

assign SB_TX_dataBus_o = '0; // No data bus used in MBTRAIN

logic [1:0] make_decision;
logic trigger_SB_TX;
logic decision_done;

SB_msg_t Stored_SBmsg;
SB_msg_t Next_msg;
MBTRAIN_state_t MBTRAIN_state;

logic MBTRAIN_done_r;
logic reset_state_timeout_counter_r;
assign reset_state_timeout_counter_o = reset_state_timeout_counter_r;
assign MBTRAIN_done_o = MBTRAIN_done_r;

// Wake up trigger to send first message
logic [1:0] wakeup_cnt;
logic wakeup_trigger;
logic wakeup_fired;

always_ff @(posedge clk_100MHz or reset) begin
    if (reset) begin
        wakeup_cnt    <= 2'd0;
        wakeup_trigger <= 1'b0;
        wakeup_fired  <= 1'b0;
    end else if (enable_i && !wakeup_fired) begin
        if (wakeup_cnt < 2'd2) begin
            wakeup_cnt <= wakeup_cnt + 1'b1;
            wakeup_trigger <= 1'b0;
        end else begin
            wakeup_trigger <= 1'b1;
            wakeup_fired   <= 1'b1; // Latch so it only triggers once
        end
    end else begin
        wakeup_trigger <= 1'b0;
    end
end

// Process received messages
always_ff @(posedge clk_100MHz or reset) begin
    if (reset) begin
        SB_RX_msg_req_o <= 1'b0;
        make_decision <= 2'd0;
        decision_done <= 1'b0;
        reset_SBmessage_retry_timeout <= 1'b0;
        trigger_SB_TX <= 1'b0; 
    end else if (enable_i) begin
        if (SB_RX_msg_valid_i) begin
            reset_SBmessage_retry_timeout <= 1'b1; 
            decision_done <= 1'b0; 
            SB_RX_msg_req_o <= 1'b0;
            make_decision <= 2'd1;
        end else if (SB_RX_msg_available_i) begin
            SB_RX_msg_req_o <= 1'b1;
        end else begin
            SB_RX_msg_req_o <= 1'b0;
        end

        if (make_decision == 2'd1) make_decision <= 2'd2;
        else if (make_decision == 2'd2) begin 
            decision_done <= 1'b1;
            trigger_SB_TX <= 1'b1; //trigger TX after decision is made
            make_decision <= 2'd0; // reset decision after 2 cycle
            reset_SBmessage_retry_timeout <= 1'b0; 
        end else if (make_decision == 2'd0) trigger_SB_TX <= 1'b0; 
    end
end

// Input message detection for MBTRAIN
logic recieved_VALVREF_end_req, recieved_VALVREF_end_resp;
logic recieved_DATAVREF_end_req, recieved_DATAVREF_end_resp;
logic recieved_SpeedIDLE_done_req, recieved_SpeedIDLE_done_resp;
logic recieved_TXSelfCal_done_req, recieved_TXSelfCal_done_resp;
logic recieved_RXCLKCal_done_req, recieved_RXCLKCal_done_resp;
logic recieved_ValTrainCenter_done_req, recieved_ValTrainCenter_done_resp;
logic recieved_DataTrainCenter1_end_req, recieved_DataTrainCenter1_end_resp;
logic recieved_DataTrainVref_end_req, recieved_DataTrainVref_end_resp;
logic recieved_RXDeskew_end_req, recieved_RXDeskew_end_resp;
logic recieved_DataTrainCenter2_end_req, recieved_DataTrainCenter2_end_resp;
logic recieved_LinkSpeed_done_req, recieved_LinkSpeed_done_resp;

logic sent_VALVREF_end_resp, sent_DATAVREF_end_resp, sent_SpeedIDLE_done_resp;
logic sent_TXSelfCal_done_resp, sent_RXCLKCal_done_resp, sent_ValTrainCenter_done_resp;
logic sent_DataTrainCenter1_end_resp, sent_DataTrainVref_end_resp, sent_RXDeskew_end_resp;
logic sent_DataTrainCenter2_end_resp, sent_LinkSpeed_done_resp;

always_ff @(posedge clk_100MHz or reset) begin
    if (reset) begin
        reset_state_timeout_counter_r <= 1'b0;
        recieved_VALVREF_end_req <= 1'b0;
        recieved_VALVREF_end_resp <= 1'b0;
        recieved_DATAVREF_end_req <= 1'b0;
        recieved_DATAVREF_end_resp <= 1'b0;
        recieved_SpeedIDLE_done_req <= 1'b0;
        recieved_SpeedIDLE_done_resp <= 1'b0;
        recieved_TXSelfCal_done_req <= 1'b0;
        recieved_TXSelfCal_done_resp <= 1'b0;
        recieved_RXCLKCal_done_req <= 1'b0;
        recieved_RXCLKCal_done_resp <= 1'b0;
        recieved_ValTrainCenter_done_req <= 1'b0;
        recieved_ValTrainCenter_done_resp <= 1'b0;
        recieved_DataTrainCenter1_end_req <= 1'b0;
        recieved_DataTrainCenter1_end_resp <= 1'b0;
        recieved_DataTrainVref_end_req <= 1'b0;
        recieved_DataTrainVref_end_resp <= 1'b0;
        recieved_RXDeskew_end_req <= 1'b0;
        recieved_RXDeskew_end_resp <= 1'b0;
        recieved_DataTrainCenter2_end_req <= 1'b0;
        recieved_DataTrainCenter2_end_resp <= 1'b0;
        recieved_LinkSpeed_done_req <= 1'b0;
        recieved_LinkSpeed_done_resp <= 1'b0;
    end else if (enable_i) begin
        if (SB_RX_msg_valid_i) begin
            reset_state_timeout_counter_r <= 1'b1;
            unique case (SB_RX_msg_i.msg_num)
                MBTRAIN_VALVREF_end_req:              recieved_VALVREF_end_req <= 1'b1;
                MBTRAIN_VALVREF_end_resp:             recieved_VALVREF_end_resp <= 1'b1;
                MBTRAIN_DATAVREF_end_req:             recieved_DATAVREF_end_req <= 1'b1;
                MBTRAIN_DATAVREF_end_resp:            recieved_DATAVREF_end_resp <= 1'b1;
                MBTRAIN_SpeedIDLE_done_req:           recieved_SpeedIDLE_done_req <= 1'b1;
                MBTRAIN_SpeedIDLE_done_resp:          recieved_SpeedIDLE_done_resp <= 1'b1;
                MBTRAIN_TXSelfCal_done_req:           recieved_TXSelfCal_done_req <= 1'b1;
                MBTRAIN_TXSelfCal_done_resp:          recieved_TXSelfCal_done_resp <= 1'b1;
                MBTRAIN_RXCLKCal_done_req:            recieved_RXCLKCal_done_req <= 1'b1;
                MBTRAIN_RXCLKCal_done_resp:           recieved_RXCLKCal_done_resp <= 1'b1;
                MBTRAIN_ValTrainCenter_done_req:      recieved_ValTrainCenter_done_req <= 1'b1;
                MBTRAIN_ValTrainCenter_done_resp:     recieved_ValTrainCenter_done_resp <= 1'b1;
                MBTRAIN_DataTrainCenter1_end_req:     recieved_DataTrainCenter1_end_req <= 1'b1;
                MBTRAIN_DataTrainCenter1_end_resp:    recieved_DataTrainCenter1_end_resp <= 1'b1;
                MBTRAIN_DataTrainVref_end_req:        recieved_DataTrainVref_end_req <= 1'b1;
                MBTRAIN_DataTrainVref_end_resp:       recieved_DataTrainVref_end_resp <= 1'b1;
                MBTRAIN_RXDeskew_end_req:             recieved_RXDeskew_end_req <= 1'b1;
                MBTRAIN_RXDeskew_end_resp:            recieved_RXDeskew_end_resp <= 1'b1;
                MBTRAIN_DataTrainCenter2_end_req:     recieved_DataTrainCenter2_end_req <= 1'b1;
                MBTRAIN_DataTrainCenter2_end_resp:    recieved_DataTrainCenter2_end_resp <= 1'b1;
                MBTRAIN_LinkSpeed_done_req:           recieved_LinkSpeed_done_req <= 1'b1;
                MBTRAIN_LinkSpeed_done_resp:          recieved_LinkSpeed_done_resp <= 1'b1;
                default: ;
            endcase
        end else begin
            if (make_decision == 2'd2) begin
                recieved_VALVREF_end_req <= 1'b0;
                recieved_DATAVREF_end_req <= 1'b0;
                recieved_SpeedIDLE_done_req <= 1'b0;
                recieved_TXSelfCal_done_req <= 1'b0;
                recieved_RXCLKCal_done_req <= 1'b0;
                recieved_ValTrainCenter_done_req <= 1'b0;
                recieved_DataTrainCenter1_end_req <= 1'b0;
                recieved_DataTrainVref_end_req <= 1'b0;
                recieved_RXDeskew_end_req <= 1'b0;
                recieved_DataTrainCenter2_end_req <= 1'b0;
                recieved_LinkSpeed_done_req <= 1'b0;
            end
        end
    end
end

// Combinational deciding the next SB message
always_comb begin
    Next_msg = reset_SB_msg();
    // All MBTRAIN messages are Message_without_Data
    if (MBTRAIN_state == VALVREF && recieved_VALVREF_end_req) begin
        Next_msg.msg_num = MBTRAIN_VALVREF_end_resp;
        Next_msg.opcode = Message_without_Data;
        Next_msg.srcid = D2D_Adapter;
        Next_msg.dstid = Physical_Layer;
        Next_msg.cp = 1'b0;
        Next_msg.dp = 1'b0;
        Next_msg.msg_info = '0;
    end else if (MBTRAIN_state == VALVREF) begin
        Next_msg.msg_num = MBTRAIN_VALVREF_end_req;
        Next_msg.opcode = Message_without_Data;
        Next_msg.srcid = D2D_Adapter;
        Next_msg.dstid = Physical_Layer;
        Next_msg.cp = 1'b0;
        Next_msg.dp = 1'b0;
        Next_msg.msg_info = '0;
    end else if (MBTRAIN_state == DATAVREF && recieved_DATAVREF_end_req) begin
        Next_msg.msg_num = MBTRAIN_DATAVREF_end_resp;
        Next_msg.opcode = Message_without_Data;
        Next_msg.srcid = D2D_Adapter;
        Next_msg.dstid = Physical_Layer;
        Next_msg.cp = 1'b0;
        Next_msg.dp = 1'b0;
        Next_msg.msg_info = '0;
    end else if (MBTRAIN_state == DATAVREF) begin
        Next_msg.msg_num = MBTRAIN_DATAVREF_end_req;
        Next_msg.opcode = Message_without_Data;
        Next_msg.srcid = D2D_Adapter;
        Next_msg.dstid = Physical_Layer;
        Next_msg.cp = 1'b0;
        Next_msg.dp = 1'b0;
        Next_msg.msg_info = '0;
    end else if (MBTRAIN_state == SpeedIDLE && recieved_SpeedIDLE_done_req) begin
        Next_msg.msg_num = MBTRAIN_SpeedIDLE_done_resp;
        Next_msg.opcode = Message_without_Data;
        Next_msg.srcid = D2D_Adapter;
        Next_msg.dstid = Physical_Layer;
        Next_msg.cp = 1'b0;
        Next_msg.dp = 1'b0;
        Next_msg.msg_info = '0;
    end else if (MBTRAIN_state == SpeedIDLE) begin
        Next_msg.msg_num = MBTRAIN_SpeedIDLE_done_req;
        Next_msg.opcode = Message_without_Data;
        Next_msg.srcid = D2D_Adapter;
        Next_msg.dstid = Physical_Layer;
        Next_msg.cp = 1'b0;
        Next_msg.dp = 1'b0;
        Next_msg.msg_info = '0;
    end else if (MBTRAIN_state == TXSelfCal && recieved_TXSelfCal_done_req) begin
        Next_msg.msg_num = MBTRAIN_TXSelfCal_done_resp;
        Next_msg.opcode = Message_without_Data;
        Next_msg.srcid = D2D_Adapter;
        Next_msg.dstid = Physical_Layer;
        Next_msg.cp = 1'b0;
        Next_msg.dp = 1'b0;
        Next_msg.msg_info = '0;
    end else if (MBTRAIN_state == TXSelfCal) begin
        Next_msg.msg_num = MBTRAIN_TXSelfCal_done_req;
        Next_msg.opcode = Message_without_Data;
        Next_msg.srcid = D2D_Adapter;
        Next_msg.dstid = Physical_Layer;
        Next_msg.cp = 1'b0;
        Next_msg.dp = 1'b0;
        Next_msg.msg_info = '0;
    end else if (MBTRAIN_state == RXCLKCal && recieved_RXCLKCal_done_req) begin
        Next_msg.msg_num = MBTRAIN_RXCLKCal_done_resp;
        Next_msg.opcode = Message_without_Data;
        Next_msg.srcid = D2D_Adapter;
        Next_msg.dstid = Physical_Layer;
        Next_msg.cp = 1'b0;
        Next_msg.dp = 1'b0;
        Next_msg.msg_info = '0;
    end else if (MBTRAIN_state == RXCLKCal) begin
        Next_msg.msg_num = MBTRAIN_RXCLKCal_done_req;
        Next_msg.opcode = Message_without_Data;
        Next_msg.srcid = D2D_Adapter;
        Next_msg.dstid = Physical_Layer;
        Next_msg.cp = 1'b0;
        Next_msg.dp = 1'b0;
        Next_msg.msg_info = '0;
    end else if (MBTRAIN_state == ValTrainCenter && recieved_ValTrainCenter_done_req) begin
        Next_msg.msg_num = MBTRAIN_ValTrainCenter_done_resp;
        Next_msg.opcode = Message_without_Data;
        Next_msg.srcid = D2D_Adapter;
        Next_msg.dstid = Physical_Layer;
        Next_msg.cp = 1'b0;
        Next_msg.dp = 1'b0;
        Next_msg.msg_info = '0;
    end else if (MBTRAIN_state == ValTrainCenter) begin
        Next_msg.msg_num = MBTRAIN_ValTrainCenter_done_req;
        Next_msg.opcode = Message_without_Data;
        Next_msg.srcid = D2D_Adapter;
        Next_msg.dstid = Physical_Layer;
        Next_msg.cp = 1'b0;
        Next_msg.dp = 1'b0;
        Next_msg.msg_info = '0;
    end else if (MBTRAIN_state == DataTrainCenter1 && recieved_DataTrainCenter1_end_req) begin
        Next_msg.msg_num = MBTRAIN_DataTrainCenter1_end_resp;
        Next_msg.opcode = Message_without_Data;
        Next_msg.srcid = D2D_Adapter;
        Next_msg.dstid = Physical_Layer;
        Next_msg.cp = 1'b0;
        Next_msg.dp = 1'b0;
        Next_msg.msg_info = '0;
    end else if (MBTRAIN_state == DataTrainCenter1) begin
        Next_msg.msg_num = MBTRAIN_DataTrainCenter1_end_req;
        Next_msg.opcode = Message_without_Data;
        Next_msg.srcid = D2D_Adapter;
        Next_msg.dstid = Physical_Layer;
        Next_msg.cp = 1'b0;
        Next_msg.dp = 1'b0;
        Next_msg.msg_info = '0;
    end else if (MBTRAIN_state == DataTrainVref && recieved_DataTrainVref_end_req) begin
        Next_msg.msg_num = MBTRAIN_DataTrainVref_end_resp;
        Next_msg.opcode = Message_without_Data;
        Next_msg.srcid = D2D_Adapter;
        Next_msg.dstid = Physical_Layer;
        Next_msg.cp = 1'b0;
        Next_msg.dp = 1'b0;
        Next_msg.msg_info = '0;
    end else if (MBTRAIN_state == DataTrainVref) begin
        Next_msg.msg_num = MBTRAIN_DataTrainVref_end_req;
        Next_msg.opcode = Message_without_Data;
        Next_msg.srcid = D2D_Adapter;
        Next_msg.dstid = Physical_Layer;
        Next_msg.cp = 1'b0;
        Next_msg.dp = 1'b0;
        Next_msg.msg_info = '0;
    end else if (MBTRAIN_state == RXDeskew && recieved_RXDeskew_end_req) begin
        Next_msg.msg_num = MBTRAIN_RXDeskew_end_resp;
        Next_msg.opcode = Message_without_Data;
        Next_msg.srcid = D2D_Adapter;
        Next_msg.dstid = Physical_Layer;
        Next_msg.cp = 1'b0;
        Next_msg.dp = 1'b0;
        Next_msg.msg_info = '0;
    end else if (MBTRAIN_state == RXDeskew) begin
        Next_msg.msg_num = MBTRAIN_RXDeskew_end_req;
        Next_msg.opcode = Message_without_Data;
        Next_msg.srcid = D2D_Adapter;
        Next_msg.dstid = Physical_Layer;
        Next_msg.cp = 1'b0;
        Next_msg.dp = 1'b0;
        Next_msg.msg_info = '0;
    end else if (MBTRAIN_state == DataTrainCenter2 && recieved_DataTrainCenter2_end_req) begin
        Next_msg.msg_num = MBTRAIN_DataTrainCenter2_end_resp;
        Next_msg.opcode = Message_without_Data;
        Next_msg.srcid = D2D_Adapter;
        Next_msg.dstid = Physical_Layer;
        Next_msg.cp = 1'b0;
        Next_msg.dp = 1'b0;
        Next_msg.msg_info = '0;
    end else if (MBTRAIN_state == DataTrainCenter2) begin
        Next_msg.msg_num = MBTRAIN_DataTrainCenter2_end_req;
        Next_msg.opcode = Message_without_Data;
        Next_msg.srcid = D2D_Adapter;
        Next_msg.dstid = Physical_Layer;
        Next_msg.cp = 1'b0;
        Next_msg.dp = 1'b0;
        Next_msg.msg_info = '0;
    end else if (MBTRAIN_state == LinkSpeed && recieved_LinkSpeed_done_req) begin
        Next_msg.msg_num = MBTRAIN_LinkSpeed_done_resp;
        Next_msg.opcode = Message_without_Data;
        Next_msg.srcid = D2D_Adapter;
        Next_msg.dstid = Physical_Layer;
        Next_msg.cp = 1'b0;
        Next_msg.dp = 1'b0;
        Next_msg.msg_info = '0;
    end else if (MBTRAIN_state == LinkSpeed) begin
        Next_msg.msg_num = MBTRAIN_LinkSpeed_done_req;
        Next_msg.opcode = Message_without_Data;
        Next_msg.srcid = D2D_Adapter;
        Next_msg.dstid = Physical_Layer;
        Next_msg.cp = 1'b0;
        Next_msg.dp = 1'b0;
        Next_msg.msg_info = '0;
    end else begin
        Next_msg = reset_SB_msg(); // Reset message if no valid state
    end
end

//Next state decision
always_ff @(posedge clk_100MHz or reset) begin
    if (reset) begin
        MBTRAIN_state <= VALVREF;
        MBTRAIN_done_r <= 1'b0;
    end else if (enable_i) begin
        if (make_decision == 2'd1) begin
            case (MBTRAIN_state)
                VALVREF: if (recieved_VALVREF_end_resp && sent_VALVREF_end_resp) MBTRAIN_state <= DATAVREF;
                DATAVREF: if (recieved_DATAVREF_end_resp && sent_DATAVREF_end_resp) MBTRAIN_state <= SpeedIDLE;
                SpeedIDLE: if (recieved_SpeedIDLE_done_resp && sent_SpeedIDLE_done_resp) MBTRAIN_state <= TXSelfCal;
                TXSelfCal: if (recieved_TXSelfCal_done_resp && sent_TXSelfCal_done_resp) MBTRAIN_state <= RXCLKCal;
                RXCLKCal: if (recieved_RXCLKCal_done_resp && sent_RXCLKCal_done_resp) MBTRAIN_state <= ValTrainCenter;
                ValTrainCenter: if (recieved_ValTrainCenter_done_resp && sent_ValTrainCenter_done_resp) MBTRAIN_state <= DataTrainCenter1;
                DataTrainCenter1: if (recieved_DataTrainCenter1_end_resp && sent_DataTrainCenter1_end_resp) MBTRAIN_state <= DataTrainVref;
                DataTrainVref: if (recieved_DataTrainVref_end_resp && sent_DataTrainVref_end_resp) MBTRAIN_state <= RXDeskew;
                RXDeskew: if (recieved_RXDeskew_end_resp && sent_RXDeskew_end_resp) MBTRAIN_state <= DataTrainCenter2;
                DataTrainCenter2: if (recieved_DataTrainCenter2_end_resp && sent_DataTrainCenter2_end_resp) MBTRAIN_state <= LinkSpeed;
                LinkSpeed: if (recieved_LinkSpeed_done_resp && sent_LinkSpeed_done_resp) MBTRAIN_done_r <= 1'b1;
                default: MBTRAIN_state <= VALVREF;
            endcase
        end
    end         
end

// Store SBmessage after decision has been made
always_ff @(posedge clk_100MHz or reset) begin
    if (reset) begin
        Stored_SBmsg <= reset_SB_msg();
    end else if (enable_i) begin
        if (make_decision == 2'd2) begin
            Stored_SBmsg <= Next_msg;
        end
    end
end

// valid and SB message out logic
always_ff @(posedge clk_100MHz or reset) begin
    if (reset) begin
        SB_TX_msg_valid_o <= 1'b0;
        SB_TX_msg_o <= reset_SB_msg();
    end else if (enable_i) begin
        if (SBmessage_retry_timeout_flag || trigger_SB_TX || wakeup_trigger) begin
            SB_TX_msg_valid_o <= 1'b1;
            if (decision_done) SB_TX_msg_o <= Stored_SBmsg;
            else SB_TX_msg_o <= Next_msg;
        end else begin
            SB_TX_msg_valid_o <= 1'b0;
        end
    end
end

// Check for change condition sending resp messages
always_ff @(posedge clk_100MHz or reset) begin
    if (reset) begin
        sent_VALVREF_end_resp <= 1'b0;
        sent_DATAVREF_end_resp <= 1'b0;
        sent_SpeedIDLE_done_resp <= 1'b0;
        sent_TXSelfCal_done_resp <= 1'b0;
        sent_RXCLKCal_done_resp <= 1'b0;
        sent_ValTrainCenter_done_resp <= 1'b0;
        sent_DataTrainCenter1_end_resp <= 1'b0;
        sent_DataTrainVref_end_resp <= 1'b0;
        sent_RXDeskew_end_resp <= 1'b0;
        sent_DataTrainCenter2_end_resp <= 1'b0;
        sent_LinkSpeed_done_resp <= 1'b0;
    end else if (enable_i && SB_TX_msg_valid_o) begin
        unique case (SB_TX_msg_o.msg_num)
            MBTRAIN_VALVREF_end_resp: sent_VALVREF_end_resp <= 1'b1;
            MBTRAIN_DATAVREF_end_resp: sent_DATAVREF_end_resp <= 1'b1;
            MBTRAIN_SpeedIDLE_done_resp: sent_SpeedIDLE_done_resp <= 1'b1;
            MBTRAIN_TXSelfCal_done_resp: sent_TXSelfCal_done_resp <= 1'b1;
            MBTRAIN_RXCLKCal_done_resp: sent_RXCLKCal_done_resp <= 1'b1;
            MBTRAIN_ValTrainCenter_done_resp: sent_ValTrainCenter_done_resp <= 1'b1;
            MBTRAIN_DataTrainCenter1_end_resp: sent_DataTrainCenter1_end_resp <= 1'b1;
            MBTRAIN_DataTrainVref_end_resp: sent_DataTrainVref_end_resp <= 1'b1;
            MBTRAIN_RXDeskew_end_resp: sent_RXDeskew_end_resp <= 1'b1;
            MBTRAIN_DataTrainCenter2_end_resp: sent_DataTrainCenter2_end_resp <= 1'b1;
            MBTRAIN_LinkSpeed_done_resp: sent_LinkSpeed_done_resp <= 1'b1;
            default: ;
        endcase
    end
end

endmodule
