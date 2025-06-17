`include "SB_codex_pkg.vh"

module MBINIT (
    input clk_100MHz,
    input clk_800MHz,
    input clk_2GHz,
    input reset,
    input enable_i,

    output MBINIT_done_o,

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

typedef enum logic [2:0] { 
    PARAM = 3'd0,
    Cal = 3'd1,
    RepairCLK = 3'd2,
    RepairVAL = 3'd3,
    ReversalIMB = 3'd4,
    RepairMB = 3'd5
} MBINIT_state_t;

assign SB_TX_dataBus_o = '0; // No data bus used in SBINIT

logic [1:0] make_decision;
logic trigger_SB_TX;
logic decision_done;

SB_msg_t Stored_SBmsg;
SB_msg_t Next_msg;
MBINIT_state_t MBINIT_state;

logic MBINIT_done_r;
logic reset_state_timeout_counter_r;
assign reset_state_timeout_counter_o = reset_state_timeout_counter_r;
assign MBINIT_done_o = MBINIT_done_r;

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

// Process recieved messages
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

logic recieved_paramConfig_req;
logic recieved_paramConfig_resp;
logic sent_paramConfig_resp;

logic recieved_Cal_done_resp;
logic recieved_Cal_done_req;
logic sent_Cal_done_resp;

logic recieved_RepairCLK_done_req;
logic recieved_RepairCLK_done_resp;
logic sent_RepairCLK_done_resp;

logic recieved_RepairVAL_done_req;
logic recieved_RepairVAL_done_resp;
logic sent_RepairVAL_done_resp;

logic recieved_ReversalIMB_done_req;
logic recieved_ReversalIMB_done_resp;
logic sent_ReversalIMB_done_resp;

logic recieved_RepairMB_end_req;
logic recieved_RepairMB_end_resp;
logic sent_RepairMB_end_resp;

// Input message detection
always_ff @(posedge clk_100MHz or reset) begin
    if (reset) begin
        reset_state_timeout_counter_r <= 1'b0;
        recieved_paramConfig_req <= 1'b0;
        recieved_paramConfig_resp <= 1'b0;
        recieved_Cal_done_req <= 1'b0;
        recieved_Cal_done_resp <= 1'b0;
        recieved_RepairCLK_done_req <= 1'b0;
        recieved_RepairCLK_done_resp <= 1'b0;
        recieved_RepairVAL_done_req <= 1'b0;
        recieved_RepairVAL_done_resp <= 1'b0;
        recieved_ReversalIMB_done_req <= 1'b0;
        recieved_ReversalIMB_done_resp <= 1'b0;
        recieved_RepairMB_end_req <= 1'b0;
        recieved_RepairMB_end_resp <= 1'b0;
    end else if (enable_i) begin
        if (SB_RX_msg_valid_i) begin
            reset_state_timeout_counter_r <= 1'b1;
            unique case (SB_RX_msg_i.msg_num)
                MBINIT_PARAM_config_req: recieved_paramConfig_req <= 1'b1;
                MBINIT_PARAM_config_resp: recieved_paramConfig_resp <= 1'b1;
                MBINIT_CAL_done_req: recieved_Cal_done_req <= 1'b1;
                MBINIT_CAL_done_resp: recieved_Cal_done_resp <= 1'b1;
                MBINIT_RepairCLK_done_req: recieved_RepairCLK_done_req <= 1'b1;
                MBINIT_RepairCLK_done_resp: recieved_RepairCLK_done_resp <= 1'b1;
                MBINIT_RepairVAL_done_req: recieved_RepairVAL_done_req <= 1'b1;
                MBINIT_RepairVAL_done_resp: recieved_RepairVAL_done_resp <= 1'b1;
                MBINIT_ReversalIMB_done_req: recieved_ReversalIMB_done_req <= 1'b1;
                MBINIT_ReversalIMB_done_resp: recieved_ReversalIMB_done_resp <= 1'b1;
                MBINIT_RepairMB_end_req: recieved_RepairMB_end_req <= 1'b1;
                MBINIT_RepairMB_end_resp: recieved_RepairMB_end_resp <= 1'b1;
                default: ;
            endcase
        end else begin
            if (make_decision == 2'd2) begin //here reset all req so the response is only sent once per req message
                recieved_paramConfig_req <= 1'b0;
                recieved_Cal_done_req <= 1'b0;
                recieved_RepairCLK_done_req <= 1'b0;
                recieved_RepairVAL_done_req <= 1'b0;
                recieved_ReversalIMB_done_req <= 1'b0;
                recieved_RepairMB_end_req <= 1'b0;
            end
        end
    end
end

// Combinational deciding the next SB message
always_comb begin
    Next_msg = reset_SB_msg();
    Next_data = '0;
    if (MBINIT_state == PARAM && recieved_paramConfig_req) begin
        Next_msg.msg_num = MBINIT_PARAM_config_resp;
        Next_msg.opcode = Message_without_Data;
        Next_msg.srcid = D2D_Adapter;
        Next_msg.dstid = Physical_Layer;
        Next_msg.cp = 1'b0;
        Next_msg.dp = 1'b0;
        Next_msg.msg_info = '0;
        Next_data = 64'h1234_5678_9ABC_DEF0; // Example data, check standard pg 271 for more info
    end else if (MBINIT_state == PARAM) begin
        Next_msg.msg_num = MBINIT_PARAM_config_req;
        Next_msg.opcode = Message_without_Data;
        Next_msg.srcid = D2D_Adapter;
        Next_msg.dstid = Physical_Layer;
        Next_msg.cp = 1'b0;
        Next_msg.dp = 1'b0;
        Next_msg.msg_info = '0;
        Next_data = 64'h1234_5678_9ABC_DEF0;
    end else if (MBINIT_state == Cal && recieved_Cal_done_req) begin
        Next_msg.msg_num = MBINIT_CAL_done_resp;
        Next_msg.opcode = Message_without_Data;
        Next_msg.srcid = D2D_Adapter;
        Next_msg.dstid = Physical_Layer;
        Next_msg.cp = 1'b0;
        Next_msg.dp = 1'b0;
        Next_msg.msg_info = '0;
        Next_data = '0; // No data for this message
    end else if (MBINIT_state == Cal) begin
        Next_msg.msg_num = MBINIT_CAL_done_req;
        Next_msg.opcode = Message_without_Data;
        Next_msg.srcid = D2D_Adapter;
        Next_msg.dstid = Physical_Layer;
        Next_msg.cp = 1'b0;
        Next_msg.dp = 1'b0;
        Next_msg.msg_info = '0;
        Next_data = '0; // No data for this message
    end else if (MBINIT_state == RepairCLK && recieved_RepairCLK_done_req) begin
        Next_msg.msg_num = MBINIT_RepairCLK_done_resp;
        Next_msg.opcode = Message_without_Data;
        Next_msg.srcid = D2D_Adapter;
        Next_msg.dstid = Physical_Layer;
        Next_msg.cp = 1'b0;
        Next_msg.dp = 1'b0;
        Next_msg.msg_info = '0;
        Next_data = '0; // No data for this message
    end else if (MBINIT_state == RepairCLK) begin
        Next_msg.msg_num = MBINIT_RepairCLK_done_req;
        Next_msg.opcode = Message_without_Data;
        Next_msg.srcid = D2D_Adapter;
        Next_msg.dstid = Physical_Layer;
        Next_msg.cp = 1'b0;
        Next_msg.dp = 1'b0;
        Next_msg.msg_info = '0;
        Next_data = '0; // No data for this message
    end else if (MBINIT_state == RepairVAL && recieved_RepairVAL_done_req) begin
        Next_msg.msg_num = MBINIT_RepairVAL_done_resp;
        Next_msg.opcode = Message_without_Data;
        Next_msg.srcid = D2D_Adapter;
        Next_msg.dstid = Physical_Layer;
        Next_msg.cp = 1'b0;
        Next_msg.dp = 1'b0;
        Next_msg.msg_info = '0;
        Next_data = '0; // No data for this message
    end else if (MBINIT_state == RepairVAL) begin
        Next_msg.msg_num = MBINIT_RepairVAL_done_req;
        Next_msg.opcode = Message_without_Data;
        Next_msg.srcid = D2D_Adapter;
        Next_msg.dstid = Physical_Layer;
        Next_msg.cp = 1'b0;
        Next_msg.dp = 1'b0;
        Next_msg.msg_info = '0;
        Next_data = '0; // No data for this message
    end else if (MBINIT_state == ReversalIMB && recieved_ReversalIMB_done_req) begin
        Next_msg.msg_num = MBINIT_ReversalIMB_done_resp;
        Next_msg.opcode = Message_without_Data;
        Next_msg.srcid = D2D_Adapter;
        Next_msg.dstid = Physical_Layer;
        Next_msg.cp = 1'b0;
        Next_msg.dp = 1'b0;
        Next_msg.msg_info = '0;
        Next_data = '0; // No data for this message
    end else if (MBINIT_state == ReversalIMB) begin
        Next_msg.msg_num = MBINIT_ReversalIMB_done_req;
        Next_msg.opcode = Message_without_Data;
        Next_msg.srcid = D2D_Adapter;
        Next_msg.dstid = Physical_Layer;
        Next_msg.cp = 1'b0;
        Next_msg.dp = 1'b0;
        Next_msg.msg_info = '0;
        Next_data = '0; // No data for this message
    end else if (MBINIT_state == RepairMB && recieved_RepairMB_end_req) begin
        Next_msg.msg_num = MBINIT_RepairMB_end_resp;
        Next_msg.opcode = Message_without_Data;
        Next_msg.srcid = D2D_Adapter;
        Next_msg.dstid = Physical_Layer;
        Next_msg.cp = 1'b0;
        Next_msg.dp = 1'b0;
        Next_msg.msg_info = '0;
        Next_data = '0; // No data for this message
    end else if (MBINIT_state == RepairMB) begin
        Next_msg.msg_num = MBINIT_RepairMB_end_req;
        Next_msg.opcode = Message_without_Data;
        Next_msg.srcid = D2D_Adapter;
        Next_msg.dstid = Physical_Layer;
        Next_msg.cp = 1'b0;
        Next_msg.dp = 1'b0;
        Next_msg.msg_info = '0;
        Next_data = '0; // No data for this message
    end else begin
        Next_msg = reset_SB_msg(); // Reset message if no valid state
        Next_data = '0; // Reset data if no valid state
    end
end

//Next state decision
always_ff @(posedge clk_100MHz or reset) begin
    if (reset) begin
        MBINIT_state <= PARAM;
        MBINIT_done_r <= 1'b0;
    end else if (enable_i) begin
        if (make_decision == 2'd1) begin
            case (MBINIT_state)
                PARAM: begin
                    if (recieved_paramConfig_resp && sent_paramConfig_resp) begin
                        MBINIT_state <= Cal;
                    end
                end
                Cal: begin
                    if (recieved_Cal_done_resp && sent_Cal_done_resp) begin
                        MBINIT_state <= RepairCLK;
                    end
                end
                RepairCLK: begin
                    if (recieved_RepairCLK_done_resp && sent_RepairCLK_done_resp) begin
                        MBINIT_state <= RepairVAL;
                    end
                end
                RepairVAL: begin
                    if (recieved_RepairVAL_done_resp && sent_RepairVAL_done_resp) begin
                        MBINIT_state <= ReversalIMB;
                    end
                end
                ReversalIMB: begin
                    if (recieved_ReversalIMB_done_resp && sent_ReversalIMB_done_resp) begin
                        MBINIT_state <= RepairMB;
                    end
                end
                RepairMB: begin
                    if (recieved_RepairMB_end_resp && sent_RepairMB_end_resp) begin
                        MBINIT_done_r <= 1'b1; // MBINIT is done
                    end
                end
                default: begin
                    MBINIT_state <= PARAM; // Reset to PARAM state if something goes wrong
                end
            endcase
        end
    end         
end

logic [63:0] Stored_data;
logic [63:0] Next_data;
assign SB_TX_dataBus_o = Stored_data;

// Store SBmessage after decision has been made
always_ff @(posedge clk_100MHz or reset) begin
    if (reset) begin
        Stored_SBmsg <= reset_SB_msg();
        Stored_data <= '0;
    end else if (enable_i) begin
        if (make_decision == 2'd2) begin
            Stored_SBmsg <= Next_msg;
            Stored_data <= Next_data;
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
        sent_paramConfig_resp <= 1'b0;
        sent_Cal_done_resp <= 1'b0;
        sent_RepairCLK_done_resp <= 1'b0;
        sent_RepairVAL_done_resp <= 1'b0;
        sent_ReversalIMB_done_resp <= 1'b0;
        sent_RepairMB_end_resp <= 1'b0;
    end else if (enable_i && SB_TX_msg_valid_o) begin
        unique case (SB_TX_msg_o.msg_num)
            MBINIT_PARAM_config_resp: sent_paramConfig_resp <= 1'b1;
            MBINIT_CAL_done_resp:     sent_Cal_done_resp <= 1'b1;
            MBINIT_RepairCLK_done_resp: sent_RepairCLK_done_resp <= 1'b1;
            MBINIT_RepairVAL_done_resp: sent_RepairVAL_done_resp <= 1'b1;
            MBINIT_ReversalIMB_done_resp: sent_ReversalIMB_done_resp <= 1'b1;
            MBINIT_RepairMB_end_resp: sent_RepairMB_end_resp <= 1'b1;
            default: ;
        endcase
    end
end


endmodule
