`timescale 1ns/1ps

module SB_tb;

    // Parameters
    parameter buffer_size = 4;

    // Clocks and reset
    reg clk_800MHz = 0;
    reg clk_100MHz = 0;
    reg reset = 1;

    // TX signals
    reg  [63:0] data_i;
    reg         valid_i;
    reg         enable_tx;
    wire        data_valid_ack_o;
    wire        dataPin_o;
    wire        clkPin_o;

    // RX signals
    wire [63:0] data_o;
    wire        valid_o;
    reg         enable_rx;
    reg         msg_req;

    // Connect TX and RX
    wire dataPin_conn, clkPin_conn;
    assign dataPin_conn = dataPin_o;
    assign clkPin_conn  = clkPin_o;

    // Instantiate TX
    SB_TX #(
        .buffer_size(buffer_size)
    ) tx_inst (
        .clk_800MHz(clk_800MHz),
        .reset(reset),
        .data_i(data_i),
        .valid_i(valid_i),
        .enable_i(enable_tx),
        .data_valid_ack_o(data_valid_ack_o),
        .dataPin_o(dataPin_o),
        .clkPin_o(clkPin_o)
    );

    // Instantiate RX
    SB_RX #(
        .buffer_size(buffer_size)
    ) rx_inst (
        .clk_800MHz(clk_800MHz),
        .clk_100MHz(clk_100MHz),
        .reset(reset),
        .enable_i(enable_rx),
        .msg_req_i(msg_req),
        .dataPin_i(dataPin_conn),
        .clkPin_i(clkPin_conn),
        .data_o(data_o),
        .valid_o(valid_o)
    );

    initial begin
        $dumpfile("../SB_tb.vcd");
        $dumpvars(0, SB_tb);
    end

    // Clock generation
    always #0.625 clk_800MHz <= ~clk_800MHz; // 800MHz -> 1.25ns period
    always #5    clk_100MHz <= ~clk_100MHz;  // 100MHz -> 10ns period

    // Test variables
    string test_strs [0:2] = '{"\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF", "12345678", "testDATA"};
    reg [63:0] test_data [2:0];
    reg [63:0] rx_data;

    integer send_index;
    integer recieve_index;
    integer i;

    always @(posedge clk_100MHz or posedge reset)begin
        if (reset) begin
            data_i <= 64'd0;
            valid_i <= 0;
            send_index <= 0;
        end else begin
                if(send_index < 3) begin
                data_i <= test_data[send_index];
                valid_i <= 1;
                wait (data_valid_ack_o == 1);
                send_index <= send_index + 1;
                valid_i <= 0;
            end
        end
    end

    always @(posedge clk_100MHz or posedge reset) begin
        if (reset) begin
            rx_data <= 64'd0;
            recieve_index <= 0;
        end else begin
            msg_req <= 1;
            wait (valid_o == 1);
            msg_req <= 0;
            rx_data <= data_o;
            // Compare received data with expected test data
            if (data_o === test_data[recieve_index]) begin
                $display("TEST PASSED: RX data matches TX data for string %0d: %s", recieve_index, test_strs[recieve_index]);
            end else begin
                $error("TEST FAILED: RX data (%h) does not match TX data (%h) for string %0d: %s", data_o, test_data[recieve_index], recieve_index, test_strs[recieve_index]);
            end
            recieve_index <= recieve_index + 1;
        end
    end

    initial begin
        // Convert strings to 64-bit values
        for (i = 0; i < 3; i = i + 1) begin
            test_data[i] = { 
                byte'(test_strs[i].getc(0)), 
                byte'(test_strs[i].getc(1)), 
                byte'(test_strs[i].getc(2)), 
                byte'(test_strs[i].getc(3)), 
                byte'(test_strs[i].getc(4)), 
                byte'(test_strs[i].getc(5)), 
                byte'(test_strs[i].getc(6)), 
                byte'(test_strs[i].getc(7)) 
            };
        end

        // Initialize signals
        data_i = 64'd0;
        valid_i = 0;
        enable_tx = 0;
        enable_rx = 1;
        msg_req = 0;

        // Reset pulse
        #20;
        reset = 0;
        enable_tx = 1;

        // Wait a few cycles

        #600;
        $finish;
    end

endmodule
