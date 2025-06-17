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
  input SB_RX_msg_available_i,

  input  SBmessage_retry_timeout_flag,
  output reset_SBmessage_retry_timeout,

  output reset_state_timeout_counter_o

);


typedef enum logic{ 
    LinkInit = 0,
    LinkInit_done = 1
} LINKINIT_state_t;

assign SB_TX_dataBus_o = '0; // No data bus used in SBINIT

logic [1:0] make_decision;
logic trigger_SB_TX;
logic decision_done;

SB_msg_t Stored_SBmsg;
SB_msg_t Next_msg;
LINKINIT_state_t LINKINIT_state;

logic LINKINIT_done_r;
logic reset_state_timeout_counter_r;
assign reset_state_timeout_counter_o = reset_state_timeout_counter_r;
assign LINKINIT_done_o = LINKINIT_done_r;

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

// Input message detection
logic recieved_LinkMgmt_RDI_Active_req;
logic recieved_LinkMgmt_RDI_Active_resp;

logic sent_LinkMgmt_RDI_Active_resp;

always_ff @(posedge clk_100MHz or reset) begin
    if (reset) begin
        reset_state_timeout_counter_r <= 1'b0;
        recieved_LinkMgmt_RDI_Active_req <= 1'b0;
        recieved_LinkMgmt_RDI_Active_resp <= 1'b0;
    end else if (enable_i) begin
        if (SB_RX_msg_valid_i) begin
            reset_state_timeout_counter_r <= 1'b1; 
            unique case (SB_RX_msg_i.msg_num)
              LinkMgmt_RDI_Active_req: recieved_LinkMgmt_RDI_Active_req <= 1'b1;
              LinkMgmt_RDI_Active_resp: recieved_LinkMgmt_RDI_Active_resp <= 1'b1;
              default: ;
            endcase
        end else begin
            if (make_decision == 2'd2) begin
                recieved_LinkMgmt_RDI_Active_req <= 1'b0;
            end
        end
    end
end

// Combinational deciding the next SB message
always_comb begin
    Next_msg = reset_SB_msg();
    if (LINKINIT_state == LinkInit && recieved_LinkMgmt_RDI_Active_req) begin
        Next_msg.msg_num = LinkMgmt_RDI_Active_resp;
        Next_msg.opcode = Message_without_Data;
        Next_msg.srcid = D2D_Adapter;
        Next_msg.dstid = Physical_Layer;
        Next_msg.cp = 1'b0;
        Next_msg.dp = 1'b0;
        Next_msg.msg_info = '0;
    end else if (LINKINIT_state == LinkInit) begin
        Next_msg.msg_num = LinkMgmt_RDI_Active_req;
        Next_msg.opcode = Message_without_Data;
        Next_msg.srcid = D2D_Adapter;
        Next_msg.dstid = Physical_Layer;
        Next_msg.cp = 1'b0;
        Next_msg.dp = 1'b0;
        Next_msg.msg_info = '0;
    end
end

//Next state decision
always_ff @(posedge clk_100MHz or reset) begin
    if (reset) begin
        LINKINIT_state <= LinkInit;
        LINKINIT_done_r <= 1'b0;
    end else if (enable_i) begin
        if (make_decision == 2'd1) begin
            case (LINKINIT_state)
                LinkInit: begin
                    if ( recieved_LinkMgmt_RDI_Active_resp && sent_LinkMgmt_RDI_Active_resp) begin
                        LINKINIT_state <= LinkInit_done;
                        LINKINIT_done_r <= 1'b1; // Indicate that SBINIT is done
                    end
                end
                LinkInit_done: begin
                    LINKINIT_state <= LinkInit_done; // Stay in done state
                    LINKINIT_done_r <= 1'b1; // Keep done state active
                end
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

// Check for change condition sending SBINIT_done_resp
always_ff @(posedge clk_100MHz or reset) begin
    if (reset) begin
        sent_LinkMgmt_RDI_Active_resp <= 1'b0;
    end if (enable_i) begin
        if (SB_TX_msg_o.msg_num == LinkMgmt_RDI_Active_resp && SB_TX_msg_valid_o) begin
            sent_LinkMgmt_RDI_Active_resp <= 1'b1;
        end
    end
end

endmodule
