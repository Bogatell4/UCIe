`timescale 1ns/1ps
`include "LTSM/SB_codex_pkg.vh"

module SB_tb;

    // Parameters
    parameter fast_buffer_size = 8;
    parameter slow_buffer_size = 4;

    // Clocks and reset
    reg clk_800MHz = 0;
    reg clk_100MHz = 0;
    reg reset = 1;

    // TX signals
    reg  [63:0] dataBus_i;
    reg         valid_i;
    reg         enable_tx;
    SB_msg_t    SB_msg_i;
    wire        send_next_flag_o;
    wire        dataPin_o;
    wire        clkPin_o;

    // RX signals
    wire [63:0] data_o;
    SB_msg_t    SB_msg_o;
    wire        valid_o;
    reg         enable_rx;
    reg         msg_req;

    // Connect TX and RX
    wire dataPin_conn, clkPin_conn;
    assign dataPin_conn = dataPin_o;
    assign clkPin_conn  = clkPin_o;

    // Instantiate TX
    SB_TX #(
        .fast_buffer_size(fast_buffer_size)
    ) tx_inst (
        .clk_100MHz(clk_100MHz),
        .clk_800MHz(clk_800MHz),
        .reset(reset),
        .dataBus_i(dataBus_i),
        .SB_msg_i(SB_msg_i),
        .valid_i(valid_i),
        .enable_i(enable_tx),
        .send_next_flag_o(send_next_flag_o),
        .dataPin_o(dataPin_o),
        .clkPin_o(clkPin_o)
    );

    // Instantiate RX
    SB_RX #(
        .slow_buffer_size(slow_buffer_size)
    ) rx_inst (
        .clk_800MHz(clk_800MHz),
        .clk_100MHz(clk_100MHz),
        .reset(reset),
        .enable_i(enable_rx),
        .msg_req_i(msg_req),
        .dataPin_i(dataPin_conn),
        .clkPin_i(clkPin_conn),
        .data_o(data_o),
        .SB_msg_o(SB_msg_o),
        .valid_o(valid_o)
    );

    initial begin
        $dumpfile("../SBcodex_tb.vcd");
        $dumpvars(0, SB_tb);
    end

    // Clock generation
    always #0.625 clk_800MHz <= ~clk_800MHz; // 800MHz -> 1.25ns period
    always #5    clk_100MHz <= ~clk_100MHz;  // 100MHz -> 10ns period

    // Test variables
    SB_msg_t test_msgs [2:0];
    reg [63:0] test_data [2:0];
    integer send_index;
    integer recieve_index;

    // Prepare test messages and data
    initial begin
        // Example 1: Message without data (was Example 2)
        test_msgs[0] = reset_SB_msg();
        test_msgs[0].opcode = Message_without_Data;
        test_msgs[0].msg_num = SBINIT_done_req;
        test_msgs[0].srcid = Stack1_Protocol;
        test_msgs[0].dstid = Physical_Layer;
        test_msgs[0].msg_info = 16'hBEEF;
        test_data[0] = 64'd0; // Not used for this message

        // Example 2: 32b Register Read (was Example 1)
        test_msgs[1] = reset_SB_msg();
        test_msgs[1].opcode = MemRead_32b;
        test_msgs[1].srcid = Stack0_Protocol;
        test_msgs[1].dstid = Default;
        test_msgs[1].tag = 5'd1;
        test_msgs[1].be = 8'hFF;
        test_msgs[1].addr = 24'h123456;
        test_msgs[1].cr = 1'b1;
        test_data[1] = 64'hAABBCCDD11223344;

        // Example 3: 64b Register Write (unchanged)
        test_msgs[2] = reset_SB_msg();
        test_msgs[2].opcode = MemWrite_64b;
        test_msgs[2].srcid = D2D_Adapter_src;
        test_msgs[2].dstid = D2D_Adapter_dst;
        test_msgs[2].tag = 5'd7;
        test_msgs[2].be = 8'h0F;
        test_msgs[2].addr = 24'h654321;
        test_msgs[2].cr = 1'b0;
        test_data[2] = 64'hCAFEBABEDEADBEEF;
    end

    // Send logic
    always @(posedge clk_100MHz or reset) begin
        if (reset) begin
            dataBus_i <= 64'd0;
            SB_msg_i <= reset_SB_msg();
            valid_i <= 0;
            send_index <= 0;
        end else if (enable_tx) begin
            if (send_next_flag_o) begin
                if (send_index < 3) begin
                    dataBus_i <= test_data[send_index];
                    SB_msg_i <= test_msgs[send_index];
                    valid_i <= 1;
                    send_index <= send_index + 1;
                end else valid_i <= 0; 
            end else valid_i <= 0; 
        end
    end

    // Receive and check logic
    always @(posedge clk_100MHz or reset) begin
        if (reset) begin
            recieve_index <= 0;
        end else begin
            if (valid_o && msg_req) begin
                // Directly compare SB_msg_o to test_msgs[recieve_index]
                if (SB_msg_o.opcode   === test_msgs[recieve_index].opcode   &&
                    SB_msg_o.srcid    === test_msgs[recieve_index].srcid    &&
                    SB_msg_o.dstid    === test_msgs[recieve_index].dstid    &&
                    SB_msg_o.tag      === test_msgs[recieve_index].tag      &&
                    SB_msg_o.be       === test_msgs[recieve_index].be       &&
                    SB_msg_o.addr     === test_msgs[recieve_index].addr     &&
                    SB_msg_o.cr       === test_msgs[recieve_index].cr       &&
                    SB_msg_o.msg_num  === test_msgs[recieve_index].msg_num  &&
                    SB_msg_o.msg_info === test_msgs[recieve_index].msg_info ) begin
                    $display("[%0t] TEST PASSED: RX message matches TX message for index %0d", $time, recieve_index);
                end else begin
                    $error("[%0t] TEST FAILED: RX message does not match TX message for index %0d", $time, recieve_index);
                end

                // Additional data comparison for opcodes that expect data
                if (SB_msg_o.opcode inside {MemRead_32b, MemWrite_32b, DMSRegRead_32b, DMSRegWrite_32b,
                                           ConfigRead_32b, ConfigWrite_32b}) begin
                    // 32b data: check MSB are 0 and LSB match test data
                    if (data_o[63:32] === 32'd0 && data_o[31:0] === test_data[recieve_index][31:0]) begin
                        $display("[%0t] TEST PASSED: RX 32b data matches TX data for index %0d: %h", $time, recieve_index, test_data[recieve_index][31:0]);
                    end else begin
                        $error("[%0t] TEST FAILED: RX 32b data (%h) does not match TX data (%h) for index %0d", $time, data_o, test_data[recieve_index][31:0], recieve_index);
                    end
                end else if (SB_msg_o.opcode inside {MemRead_64b, MemWrite_64b, DMSRegRead_64b, DMSRegWrite_64b,
                                                     ConfigRead_64b, ConfigWrite_64b}) begin
                    // 64b data: compare all bits
                    if (data_o === test_data[recieve_index]) begin
                        $display("[%0t] TEST PASSED: RX 64b data matches TX data for index %0d: %h", $time, recieve_index, test_data[recieve_index]);
                    end else begin
                        $error("[%0t] TEST FAILED: RX 64b data (%h) does not match TX data (%h) for index %0d", $time, data_o, test_data[recieve_index], recieve_index);
                    end
                end

                msg_req <= 0;
                recieve_index <= recieve_index + 1;
            end else msg_req <= 1;
        end
    end

    initial begin
        // Initialize signals
        dataBus_i = 64'd0;
        SB_msg_i = reset_SB_msg();
        valid_i = 0;
        enable_tx = 0;
        enable_rx = 0;
        msg_req = 0;

        // Reset pulse
        #5;
        reset = 0;
        enable_rx = 0;
        enable_tx = 0;

        #5;
        enable_rx = 1;
        #1;
        enable_tx = 1;

        // Wait a few cycles
        #1000;
        $finish;
    end

endmodule
