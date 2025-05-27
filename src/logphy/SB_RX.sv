// Module for Reception through sideband

module SB_RX #(
    parameter buffer_size = 4 // Must be a power of 2 and >1
)(
    input clk_800MHz,
    input clk_100MHz,
    input reset,
    input enable_i,   // Enable signal for the receiver
    input msg_req_i,  // Request to put out the FIFO a full message

    input dataPin_i,   // Serial data pin input from TX
    input clkPin_i,    // Serial clock pin input from TX

    output reg [63:0] data_o, 
    output reg valid_o        
);

    reg [63:0] buffer [buffer_size-1:0];
    reg [$clog2(buffer_size)-1:0] write_index;
    reg [$clog2(buffer_size)-1:0] read_index;

    reg [63:0] shift_reg;
    reg [5:0] bit_cnt;
    reg msg_recieved;
    reg msg_valid;
    wire msg_recieved_ack;
    wire [63:0] data_sync_w;
    wire valid_w;

    // Shift register: capture data on negedge of clkPin_i out to syncro shift regs
    // Outputs the full 64 bit message when the bit count reaches 64, meaning all data has been recieved and deserialized
    always_ff @(negedge clkPin_i or reset) begin
        if (reset) begin
            shift_reg <= 64'd0;
            bit_cnt <= 6'd0;
            msg_valid <= 1'b0;
        end else if (enable_i) begin
            bit_cnt <= bit_cnt + 1;
            shift_reg <= {dataPin_i, shift_reg[63:1]};
            msg_valid <= 1'b0;
            if (bit_cnt == 6'd63) begin
                shift_reg <= {dataPin_i, shift_reg[63:1]};
                msg_valid <= 1'b1;
                bit_cnt <= 6'd0;
            end
        end
    end

    // Syncronization shift register for a full 64 bit SB message
    ShiftReg_3d #(
        .DATA_BIT_WIDTH(64)
    ) shiftreg_inst (
        .clk        (clk_100MHz),
        .reset      (reset),
        .enable     (msg_recieved),      
        .enable_ack (msg_recieved_ack),              
        .valid_o    (valid_w),              
        .d_i        (shift_reg),        
        .q_o        (data_sync_w)               
    );

    //msg_recieved and msg_valid logic
    always_ff @(reset or posedge msg_recieved_ack or posedge msg_valid) begin
        if (reset) begin
            msg_recieved <= 1'b0;
        end else begin
            if (msg_recieved_ack) begin
                msg_recieved <= 1'b0;
            end else if (msg_valid) begin
                msg_recieved <= 1'b1;
            end
        end
    end

    // Write to buffer
    always_ff @(posedge clk_100MHz or posedge reset) begin
        if (reset) begin
            write_index <= 0;
            for (int i = 0; i < buffer_size; i++) begin
                buffer[i] <= 64'd0;
            end
        end else if (valid_w) begin
            buffer[write_index] <= data_sync_w;
            write_index <= write_index + 1;
        end
    end

    // Read from buffer
    always_ff @(posedge clk_100MHz or reset) begin
        if (reset) begin
            read_index <= 0;
            data_o <= 64'd0;
            valid_o <= 1'b0;
        end else if (enable_i) begin
            if (msg_req_i) begin
                if (read_index != write_index) begin
                    data_o <= buffer[read_index];
                    read_index <= read_index + 1;
                    valid_o <= 1'b1;
                end
            end else valid_o <= 1'b0;
        end
    end
endmodule
