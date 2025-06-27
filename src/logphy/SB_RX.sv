// Module for Reception through sideband
`include "LTSM/SB_codex_pkg.vh"

module SB_RX #(
    parameter slow_buffer_size = 4 // Must be a power of 2 and >1
)(
    input clk_800MHz,
    input clk_100MHz,
    input reset,
    input enable_i,   // Enable signal for the receiver
    input msg_req_i,  // Request to put out the FIFO a full message

    input dataPin_i,   // Serial data pin input from TX
    input clkPin_i,    // Serial clock pin input from TX

    output logic [63:0] data_o,
    output SB_msg_t SB_msg_o, // Sideband message output 
    output logic valid_o,
    output logic msg_available_o        
);

    reg [63:0] buffer [slow_buffer_size-1:0];
    reg [$clog2(slow_buffer_size)-1:0] write_index;
    reg [$clog2(slow_buffer_size)-1:0] read_index;

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
        end else if (enable_i && reset==1'b0) begin
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
            for (int i = 0; i < slow_buffer_size; i++) begin
                buffer[i] <= 64'd0;
            end
        end else if (valid_w) begin
            buffer[write_index] <= data_sync_w;
            write_index <= write_index + 1;
        end
    end

    reg expect_32b_data_r;
    reg expect_64b_data_r;
    wire expect_32b_data_w;
    wire expect_64b_data_w;
    SB_msg_t decoded_SB_msg;

    always_comb begin
        decode_SB_msg(buffer[read_index], decoded_SB_msg, expect_32b_data_w, expect_64b_data_w);
    end   

    // Read from buffer
    always_ff @(posedge clk_100MHz or reset) begin
        if (reset) begin
            read_index <= 0;
            data_o <= 64'd0;
            SB_msg_o <= '0; 
            valid_o <= 1'b0;
            expect_32b_data_r <= 1'b0;
            expect_64b_data_r <= 1'b0;
            msg_available_o <= 1'b0;
        end else if (enable_i) begin 
            if (read_index != write_index) msg_available_o <= 1'b1;
            else msg_available_o <= 1'b0;
            if ((read_index != write_index) && msg_req_i )begin
                if (expect_32b_data_r) begin
                    data_o <= {32'd0, buffer[read_index][31:0]};
                    valid_o <= 1'b1;
                    expect_32b_data_r <= 1'b0;
                    expect_64b_data_r <= 1'b0;
                end else if (expect_64b_data_r) begin
                    data_o <= buffer[read_index];
                    valid_o <= 1'b1;
                    expect_32b_data_r <= 1'b0;
                    expect_64b_data_r <= 1'b0;
                end else begin
                    SB_msg_o <= decoded_SB_msg;
                    if (expect_32b_data_w || expect_64b_data_w) begin
                        expect_32b_data_r <= expect_32b_data_w;
                        expect_64b_data_r <= expect_64b_data_w;
                        valid_o <= 1'b0; 
                    end else valid_o <= 1'b1; 
                end
                read_index <= read_index + 1;
            end else valid_o <= 1'b0; 
        end
    end

    



endmodule
