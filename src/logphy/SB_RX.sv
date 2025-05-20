module SB_RX #(
    parameter buffer_size = 4 // Must be a power of 2 and >1
)(
    input clk_800MHz,         // System clock (not the serial clkPin) 800MHz
    input clk_100MHz,
    input reset,
    input enable_i,   // Enable signal for the receiver
    input msg_req_i, // Request to put out the FIFO a full message


    input dataPin_i,   // Serial data input
    input clkPin_i,    // Serial clock input from TX

    output reg [63:0] data_o, // Parallel deserialized output
    output reg valid_o        // High for one clk cycle when a new word is ready
);

    reg [63:0] buffer [buffer_size-1:0];
    reg [$clog2(buffer_size)-1:0] write_index;
    reg [$clog2(buffer_size)-1:0] read_index;

    reg [63:0] shift_reg;
    reg [5:0] bit_cnt;
    reg [4:0] postTran_cnt; 
    reg msg_recieved;
    reg msg_flag;
    wire msg_recieved_ack;
    wire [63:0] data_sync_w;
    wire valid_w;

    // Shift register: capture data on negedge of clkPin_i out to syncro shift regs
    always_ff @(negedge clkPin_i or posedge reset) begin
        if (reset) begin
            shift_reg <= 64'd0;
            postTran_cnt <= 5'd0;
            bit_cnt <= 6'd0;
            msg_flag <= 1'b0;
        end else if(enable_i) begin
            if (bit_cnt == 6'd63) begin
                if (postTran_cnt == 5'd31)begin
                    bit_cnt <= 6'd0;
                    postTran_cnt <= 5'd0;
                    msg_flag <= 1'b0;
                end else begin
                postTran_cnt <= postTran_cnt + 1;
                msg_flag <= 1'b0;
                end
            end else begin
                bit_cnt <= bit_cnt + 1;
                postTran_cnt <= 5'd0;
                shift_reg <= {shift_reg[62:0], dataPin_i};
                if (bit_cnt == 6'd63) msg_flag <= 1'b1;
                else msg_flag <= 1'b0;
            end
        end
    end

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

    //msg_recieved and msg_flag logic
    always_ff @(posedge clk_800MHz or posedge reset or posedge msg_recieved_ack) begin
        if (reset) begin
            msg_recieved <= 1'b0;
        end else if (msg_recieved_ack) msg_recieved <= 1'b0;
        else begin 
            if (msg_flag) msg_recieved <= 1'b1;
            else msg_recieved <= msg_recieved;
        end
    end

    // Write to buffer on posedge clk_100MHz
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

    // Read from buffer on posedge clk_100MHz
    always_ff @(posedge clk_100MHz or posedge reset) begin
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
