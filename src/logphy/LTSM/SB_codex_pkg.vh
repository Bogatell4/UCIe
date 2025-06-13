`ifndef SB_CODEX_PKG_VH
`define SB_CODEX_PKG_VH

// Code and decode functions for SB messages
// Expand in order to add more messages along with the function to translate (just below)
typedef enum logic [2:0]{
    CODEX_ERROR,
    SBINIT_out_of_reset,
    SBINIT_done_req,
    SBINIT_done_resp
} SB_msgNum_t;

function automatic void get_SB_msg_code(
    input  SB_msgNum_t msg_num,
    output logic [7:0] msg_code,
    output logic [7:0] msg_subcode
);
    unique case (msg_num)
        SBINIT_out_of_reset:   begin msg_code = 8'h91; msg_subcode = 8'h00; end
        SBINIT_done_req:       begin msg_code = 8'h95; msg_subcode = 8'h01; end
        SBINIT_done_resp:      begin msg_code = 8'h9A; msg_subcode = 8'h01; end
        default:               begin msg_code = 8'hFF; msg_subcode = 8'hFF; end
    endcase
endfunction

function automatic void get_SB_msg_num_from_code(
    input logic [7:0] msg_code,
    input logic [7:0] msg_subcode,
    output SB_msgNum_t msg_num
);
    unique case ({msg_code, msg_subcode})
        {8'h91, 8'h00}: msg_num = SBINIT_out_of_reset;
        {8'h95, 8'h01}: msg_num = SBINIT_done_req;
        {8'h9A, 8'h01}: msg_num = SBINIT_done_resp;
        default:        msg_num = CODEX_ERROR;
    endcase
endfunction

typedef enum logic [4:0] {
    MemRead_32b                        = 5'b00000,
    MemWrite_32b                       = 5'b00001,
    DMSRegRead_32b                     = 5'b00010,
    DMSRegWrite_32b                    = 5'b00011,
    ConfigRead_32b                     = 5'b00100,
    ConfigWrite_32b                    = 5'b00101,
    MemRead_64b                        = 5'b01000,
    MemWrite_64b                       = 5'b01001,
    DMSRegRead_64b                     = 5'b01010,
    DMSRegWrite_64b                    = 5'b01011,
    ConfigRead_64b                     = 5'b01100,
    ConfigWrite_64b                    = 5'b01101,
    Completion_without_Data             = 5'b10000,
    Completion_with_32b_Data            = 5'b10001,
    Message_without_Data                 = 5'b10010,
    MgmtPortMsg_without_Data             = 5'b10111,
    MgmtPortMsg_with_Data                = 5'b11000,
    Completion_with_64b_Data             = 5'b11001,
    Message_with_64b_Data                = 5'b11011
    // Other encodings reserved
} opcode_t;

typedef enum logic [2:0] {
    Stack0_Protocol = 3'b000,
    Stack1_Protocol = 3'b100,
    Managment_Port_Gateway = 3'b011,
    D2D_Adapter = 3'b001
    // Other encodings reserved
} srcid_t;

typedef enum logic [2:0] {
    Default = 3'b000,
    D2D_Adapter_dst = 3'b001,
    Physical_Layer = 3'b010
    //Other encodings reserved
} dstid_t;

// SB_msg "class" as a struct containing all relevant fields
typedef struct packed {
    SB_msgNum_t msg_num; // will be used when encoding msg code and subcode
    opcode_t    opcode;
    srcid_t     srcid;
    dstid_t     dstid;
    logic [4:0] tag;
    logic [7:0] be;
    logic ep; // Data Poison? 
    logic cr; //Credit return for Register Access/Completions
    logic [23:0] addr; // 24 bits address, yhis field could be further defined with typedefs
    logic [2:0] Status; //Used for RegAccCompletions, maybe make it typedef?
    logic [15:0] msg_info;
    logic cp; //Control parity, not used in this version
    logic dp; //Data parity, not used in this version
} SB_msg_t;

function SB_msg_t reset_SB_msg();
    SB_msg_t msg;
    msg.msg_num  = CODEX_ERROR;
    msg.opcode   = MemRead_32b; // Default opcode, can be changed later
    msg.srcid    = Stack0_Protocol; // Default source ID
    msg.dstid    = Default; // Default destination ID
    msg.tag      = 5'd0;
    msg.be       = 8'd0;
    msg.ep       = 1'b0;
    msg.cr       = 1'b0;
    msg.addr     = 24'd0;
    msg.Status   = 3'd0;
    msg.msg_info = 16'd0;
    msg.cp       = 1'b0; // Control parity, not used in this version
    msg.dp       = 1'b0; // Data parity, not used in this version
    return msg;
endfunction

function automatic void encode_SB_msg(
    input  SB_msg_t msg,
    output logic [63:0] encoded_SB_msg,
    output logic expect_32b_data,
    output logic expect_64b_data
);

    //Default assignments
    encoded_SB_msg = '0; // Initialize to zero

    // Common fields for all Packet Formats
    encoded_SB_msg [4:0] = msg.opcode;
    encoded_SB_msg [31:29] = msg.srcid;
    encoded_SB_msg [58:56] = msg.dstid;
    encoded_SB_msg [62] = 0; //Header parity bit, set to 0 for now, needs to be calculated here?
    //encoded_SB_msg [62] = msg.cp;
    encoded_SB_msg [63] = 0; //Data parity bit, set to 0 for now 
    //encoded_SB_msg [62] = msg.dp;

    // Identify Packet Type Register Access Request
    unique case (msg.opcode)
        // Register Access Request
        MemRead_32b, MemWrite_32b, DMSRegRead_32b, DMSRegWrite_32b,
        ConfigRead_32b, ConfigWrite_32b, MemRead_64b, MemWrite_64b,
        DMSRegRead_64b, DMSRegWrite_64b, ConfigRead_64b, ConfigWrite_64b: begin
            encoded_SB_msg [5] = msg.ep;
            encoded_SB_msg [13:6] = '0; // Reserved bits
            encoded_SB_msg [21:14] = msg.be;
            encoded_SB_msg [26:22] = msg.tag;
            encoded_SB_msg [28:27] = '0; // Reserved bits
            //---------------------------------------------------
            encoded_SB_msg [55:32] = msg.addr;
            encoded_SB_msg [60:59] = '0; // Reserved bits
            encoded_SB_msg [61] = msg.cr;

            //Identify if 32b or 64b data is expected
            if (msg.opcode inside {MemRead_32b, MemWrite_32b, DMSRegRead_32b, DMSRegWrite_32b,
                ConfigRead_32b, ConfigWrite_32b}) begin
                expect_32b_data = 1;
                expect_64b_data = 0;
            end else begin
                expect_32b_data = 0;
                expect_64b_data = 1;
            end
        end

        // Register Access Completion
        Completion_without_Data, Completion_with_32b_Data, Completion_with_64b_Data: begin
            encoded_SB_msg [5] = msg.ep;
            encoded_SB_msg [13:6] = '0; // Reserved bits
            encoded_SB_msg [21:14] = msg.be;
            encoded_SB_msg [26:22] = msg.tag;
            encoded_SB_msg [28:27] = '0; // Reserved bits
            //---------------------------------------------------
            encoded_SB_msg [34:32] = msg.Status;
            encoded_SB_msg [55:35] = '0; // Reserved bits
            encoded_SB_msg [60:59] = '0; // Reserved bits
            encoded_SB_msg [61] = msg.cr;
            //Identify if 32b or 64b data is expected
            if (msg.opcode == Completion_with_32b_Data) begin
                expect_32b_data = 1;
                expect_64b_data = 0;
            end else if (msg.opcode == Completion_with_64b_Data) begin
                expect_32b_data = 0;
                expect_64b_data = 1;
            end else begin
                expect_32b_data = 0;
                expect_64b_data = 0;
            end
        end

        // Message Format
        Message_without_Data, Message_with_64b_Data, MgmtPortMsg_without_Data, MgmtPortMsg_with_Data: begin
            logic [7:0] code, subcode;
            get_SB_msg_code(msg.msg_num, code, subcode);
            encoded_SB_msg [13:5] = '0; // Reserved bits
            encoded_SB_msg [21:14] = code;
            encoded_SB_msg [28:22] = '0; // Reserved bits
            //---------------------------------------------------
            encoded_SB_msg [39:32] = subcode;
            encoded_SB_msg [55:40] = msg.msg_info;
            encoded_SB_msg [61:59] = '0; // Reserved bits

            if (msg.opcode == Message_without_Data) begin
                expect_32b_data = 0;
                expect_64b_data = 0;
            end else if (msg.opcode == Message_with_64b_Data) begin
                expect_32b_data = 0;
                expect_64b_data = 1;
            end else if (msg.opcode == MgmtPortMsg_without_Data) begin
                expect_32b_data = 0;
                expect_64b_data = 0;
            end else if (msg.opcode == MgmtPortMsg_with_Data) begin //Not sure if this is correct, Mgmt msg is 64 or 32?
                expect_32b_data = 1;
                expect_64b_data = 0;
            end
        end

        default: begin // Invalid opcode, set to zero
            expect_32b_data = 0;
            expect_64b_data = 0;
            encoded_SB_msg = '0;
        end
    endcase
endfunction

function automatic void decode_SB_msg(
    input  logic [63:0] encoded_SB_msg, //Unused bits because rsvd
    output SB_msg_t     msg,
    output logic        expect_32b_data,
    output logic        expect_64b_data
);
    // Extract opcode first
    opcode_t opcode;
    opcode = opcode_t'(encoded_SB_msg[4:0]);
    msg.opcode = opcode;

    // Default/Common assignments
    msg.msg_num = CODEX_ERROR;
    msg.tag     = 5'd0;
    msg.be      = 8'd0;
    msg.ep      = 1'b0;
    msg.cr      = 1'b0;
    msg.addr    = 24'd0;
    msg.Status  = 3'd0;
    msg.msg_info = 16'd0;
    expect_32b_data = 0;
    expect_64b_data = 0;
    msg.srcid  = srcid_t'(encoded_SB_msg[31:29]);
    msg.dstid  = dstid_t'(encoded_SB_msg[58:56]);
    msg.cp     = encoded_SB_msg [62]; // Control parity, not used in this version
    msg.dp     = encoded_SB_msg [63]; // Data parity, not used in this version, output error if not ok?

    // Decode based on opcode
    unique case (opcode)
        // Register Access Request
        MemRead_32b, MemWrite_32b, DMSRegRead_32b, DMSRegWrite_32b,
        ConfigRead_32b, ConfigWrite_32b, MemRead_64b, MemWrite_64b,
        DMSRegRead_64b, DMSRegWrite_64b, ConfigRead_64b, ConfigWrite_64b: begin
            msg.ep    = encoded_SB_msg[5];
            msg.be    = encoded_SB_msg[21:14];
            msg.tag   = encoded_SB_msg[26:22];
            msg.addr  = encoded_SB_msg[55:32];
            msg.cr    = encoded_SB_msg[61];
            // Data size flags
            if (opcode inside {MemRead_32b, MemWrite_32b, DMSRegRead_32b, DMSRegWrite_32b, ConfigRead_32b, ConfigWrite_32b}) begin
                expect_32b_data = 1;
                expect_64b_data = 0;
            end else begin
                expect_32b_data = 0;
                expect_64b_data = 1;
            end
        end

        // Register Access Completion
        Completion_without_Data, Completion_with_32b_Data, Completion_with_64b_Data: begin
            msg.ep     = encoded_SB_msg[5];
            msg.be     = encoded_SB_msg[21:14];
            msg.tag    = encoded_SB_msg[26:22];
            msg.Status = encoded_SB_msg[34:32];
            msg.cr     = encoded_SB_msg[61];
            // Data size flags
            if (opcode == Completion_with_32b_Data) begin
                expect_32b_data = 1;
                expect_64b_data = 0;
            end else if (opcode == Completion_with_64b_Data) begin
                expect_32b_data = 0;
                expect_64b_data = 1;
            end else begin
                expect_32b_data = 0;
                expect_64b_data = 0;
            end
        end

        // Message Format
        Message_without_Data, Message_with_64b_Data, MgmtPortMsg_without_Data, MgmtPortMsg_with_Data: begin
            logic [7:0] code, subcode;
            code    = encoded_SB_msg[21:14];
            subcode = encoded_SB_msg[39:32];
            msg.msg_info = encoded_SB_msg[55:40];
            // Reverse lookup for msg_num based on code/subcode
            get_SB_msg_num_from_code(code, subcode, msg.msg_num);
            // Data size flags

            if (opcode == Message_without_Data || opcode == MgmtPortMsg_without_Data) begin
                expect_32b_data = 0;
                expect_64b_data = 0;
            end else if (opcode == Message_with_64b_Data) begin
                expect_32b_data = 0;
                expect_64b_data = 1;
            end else if (opcode == MgmtPortMsg_with_Data) begin
                expect_32b_data = 1;
                expect_64b_data = 0;
            end
        end

        default: begin
            // Invalid opcode, set everything to zero or error
            msg.msg_num  = CODEX_ERROR;
            msg.opcode   = opcode_t'(0);
            msg.srcid    = srcid_t'(0);
            msg.dstid    = dstid_t'(0);
            msg.tag      = 5'd0;
            msg.be       = 8'd0;
            msg.ep       = 1'b0;
            msg.cr       = 1'b0;
            msg.addr     = 24'd0;
            msg.Status   = 3'd0;
            msg.msg_info = 16'd0;
            expect_32b_data = 0;
            expect_64b_data = 0;
        end
    endcase
endfunction

`endif // SB_CODEX_PKG_VH

