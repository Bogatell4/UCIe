`include "SB_codex_pkg.vh"

module SBINIT (
    input clk_100MHz,
    input clk_800MHz,
    input reset,
    input enable_i,

    output SBINIT_done_o,

    // SB Pins
    input SB_clkPin_RX_i,
    input SB_dataPin_RX_i,
    output SB_clkPin_TX_o,
    output SB_dataPin_TX_o,

    // SB Communication ports
    output SB_msg_t SB_TX_msg_o,
    output [63:0] SB_TX_dataBus_o,
    output SB_TX_msg_valid_o,
    input SB_TX_msg_sendNextFlag_i,

    input SB_msg_t SB_RX_msg_i,
    input [63:0] SB_RX_dataBus_i,
    output logic SB_RX_msg_req_o,
    input SB_RX_msg_valid_i,

    input  SBmessage_retry_timeout_flag,
    output reset_SBmessage_retry_timeout,

    // SBINIT specific outputs
    output enable_SB_tx,
    output enable_SB_rx, //TODO

    output reset_state_timeout_counter_o // TODO
);

typedef enum logic{ 
    OutOfReset = 0,
    SBINIT_done = 1
} SBINIT_state_t;

assign SB_TX_dataBus_o = '0; // No data bus used in SBINIT
assign reset_SBmessage_retry_timeout = 1'b0; 
assign enable_SB_tx = 1'b1; 
assign enable_SB_rx = 1'b1; 


logic [1:0] make_decision;
logic valid_out_flag;
logic reset_valid_out_flag;

logic recieved_OutofReset;
logic recieved_SBINIT_done_req;

SB_msg_t Stored_SBmsg;
SB_msg_t Next_msg;
SBINIT_state_t SBINIT_state;

logic Change_condition1_Sent_SBINIT_done_resp;
logic Change_condition2_Recieved_SBINIT_done_resp;
logic SBINIT_done_r;
logic reset_state_timeout_counter_r;
assign reset_state_timeout_counter_o = reset_state_timeout_counter_r;
assign SBINIT_done_o = SBINIT_done_r;

// Process request messages
always_ff @(negedge clk_100MHz or reset) begin
    if (reset) begin
        SB_RX_msg_req_o <= 1'b0;
        make_decision <= 2'd0;
        reset_valid_out_flag <= 1'b0; 
    end else if (enable_i) begin
        if (SB_RX_msg_valid_i) begin
            SB_RX_msg_req_o <= 1'b0;
            make_decision <= 2'd1;
            reset_valid_out_flag <= 1'b1;
        end else if (valid_out_flag && SB_TX_msg_sendNextFlag_i) begin
            SB_RX_msg_req_o <= 1'b1;
            reset_valid_out_flag <= 1'b0; 
        end else begin
            SB_RX_msg_req_o <= 1'b0;
        end

        if (make_decision == 2'd1) make_decision <= 2'd2;
        else if (make_decision == 2'd2) make_decision <= 2'd0; // reset decision after 2 cycle
    end
end

// Input message detection
always_ff @(negedge clk_100MHz or reset) begin
    if (reset) begin
        recieved_OutofReset <= 1'b0;
        recieved_SBINIT_done_req <= 1'b0;
        Change_condition2_Recieved_SBINIT_done_resp <= 1'b0;
        reset_state_timeout_counter_r <= 1'b0;
    end else if (enable_i) begin
        if (make_decision == 2'd2) begin
            recieved_OutofReset <= 1'b0;
            recieved_SBINIT_done_req <= 1'b0;
        end else begin
            if (SB_RX_msg_valid_i) begin
                reset_state_timeout_counter_r <= 1'b1; 
                if (SB_RX_msg_i.msg_num == SBINIT_out_of_reset) begin
                recieved_OutofReset <= 1'b1;
                end else if (SB_RX_msg_i.msg_num == SBINIT_done_req) begin
                    recieved_SBINIT_done_req <= 1'b1;
                end else if (SB_RX_msg_i.msg_num == SBINIT_done_resp) begin
                    Change_condition2_Recieved_SBINIT_done_resp <= 1'b1;
                end
            end else begin
                reset_state_timeout_counter_r <= 1'b0;
                recieved_OutofReset <= 1'b0;
                recieved_SBINIT_done_req <= 1'b0;
            end
        end
    end
end

// Combinational deciding the next SB message
always_comb begin
    Next_msg = reset_SB_msg();
    if (make_decision != 2'd0) begin
        if (SBINIT_state == OutOfReset) begin
            Next_msg.msg_num = SBINIT_out_of_reset;
            Next_msg.opcode = Message_without_Data;
            Next_msg.srcid = D2D_Adapter;
            Next_msg.dstid = Physical_Layer;
            Next_msg.cp = 1'b0;
            Next_msg.dp = 1'b0;
            Next_msg.msg_info = '0;
        end else if (SBINIT_state == SBINIT_done && recieved_SBINIT_done_req) begin
            Next_msg.msg_num = SBINIT_done_resp;
            Next_msg.opcode = Message_without_Data;
            Next_msg.srcid = D2D_Adapter;
            Next_msg.dstid = Physical_Layer;
            Next_msg.cp = 1'b0;
            Next_msg.dp = 1'b0;
            Next_msg.msg_info = '0;
        end else if (SBINIT_state == SBINIT_done) begin
            Next_msg.msg_num = SBINIT_done_req;
            Next_msg.opcode = Message_without_Data;
            Next_msg.srcid = D2D_Adapter;
            Next_msg.dstid = Physical_Layer;
            Next_msg.cp = 1'b0;
            Next_msg.dp = 1'b0;
            Next_msg.msg_info = '0;
        end
    end
end

//Next state decision
always_ff @(posedge clk_100MHz or reset) begin
    if (reset) begin
        SBINIT_state <= OutOfReset;
        SBINIT_done_r <= 1'b0;
    end else if (enable_i) begin
        if (make_decision == 2'd1) begin
            case (SBINIT_state)
                OutOfReset: begin
                    if (recieved_OutofReset) begin
                        SBINIT_state <= SBINIT_done;
                    end
                end
                SBINIT_done: begin
                    if (Change_condition1_Sent_SBINIT_done_resp && Change_condition2_Recieved_SBINIT_done_resp) begin
                        SBINIT_done_r <= 1'b1; // Indicate that SBINIT is done
                    end
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
        if (make_decision == 2'd1) begin
            Stored_SBmsg <= Next_msg;
        end
    end
end

// valid and SB message out logic
always_ff @(posedge clk_100MHz or reset) begin
    if (reset) begin
        valid_out_flag <= 1'b1; // Start with this flag activated so the first message can be requested
        SB_TX_msg_valid_o <= 1'b0;
        SB_TX_msg_o <= reset_SB_msg();
    end else if (enable_i) begin
        if (SBmessage_retry_timeout_flag) begin
            SB_TX_msg_valid_o <= 1'b1;
            SB_TX_msg_o <= Stored_SBmsg;
            valid_out_flag <= 1'b1;
        end else begin
            SB_TX_msg_valid_o <= 1'b0;
            SB_TX_msg_o <= reset_SB_msg();
        end
        if (reset_valid_out_flag) valid_out_flag <= 1'b0;
    end
end

// Check for change condition sending SBINIT_done_resp
always_ff @(posedge clk_100MHz or reset) begin
    if (reset) begin
        Change_condition1_Sent_SBINIT_done_resp <= 1'b0;
    end if (enable_i) begin
        if (SB_TX_msg_o.msg_num == SBINIT_done_resp && SB_TX_msg_valid_o) begin
            Change_condition1_Sent_SBINIT_done_resp <= 1'b1;
        end
    end
end

endmodule
