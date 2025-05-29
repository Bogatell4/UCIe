package SB_codex_pkg;

// Code and decode functions for SB messages
// Expand in order to add more messages
typedef enum {
    CODEX_ERROR,
    SBINIT_out_of_reset,
    SBINIT_done_req,
    SBINIT_done_resp
} SB_msgNum_t;

function void encode_SB_msg(
    input  SB_msgNum_t msg_num, 
    output logic [7:0] msg_code,
    output logic [7:0] msg_subcode
);
case (msg_num)
    SBINIT_out_of_reset: begin msg_code = 8'h91; msg_subcode = 8'h00; end
    SBINIT_done_req:     begin msg_code = 8'h95; msg_subcode = 8'h01; end
    SBINIT_done_resp:    begin msg_code = 8'h9A; msg_subcode = 8'h01; end
    default:             begin msg_code = 8'hFF; msg_subcode = 8'hFF; end
endcase
endfunction

function void decode_SB_msg(
    input  logic [7:0] msg_code,
    input  logic [7:0] msg_subcode,
    output SB_msgNum_t msg_num
);
case ({msg_code, msg_subcode})
    {8'h91, 8'h00}: msg_num = SBINIT_out_of_reset;
    {8'h95, 8'h01}: msg_num = SBINIT_done_req;
    {8'h9A, 8'h01}: msg_num = SBINIT_done_resp;
    default:        msg_num = CODEX_ERROR;
endcase
endfunction

endpackage
