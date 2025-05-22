module SB_TX #(
    parameter buffer_size = 4 // Must be a power of 2 and >1
)(
    input clk_800MHz,
    input reset,

    input  [63:0] data_i,
    input  valid_i,
    input  enable_i,

    output data_valid_ack_o,
    output dataPin_o,
    output clkPin_o
);

    reg [63:0] buffer [buffer_size-1:0];
    reg [$clog2(buffer_size)-1:0] write_index;
    reg [$clog2(buffer_size)-1:0] read_index;

    reg [4:0] ctr_32; // 5 bits to count up to 32 (0-31)
    reg [5:0] ctr_64; // 6 bits to count up to 64 (0-63)
    reg clk_active_r;
    wire [63:0] data_w;
    wire valid_w;
    wire clkPin_w;

    typedef enum logic [1:0] {
        TRANSMITING    = 2'd1,
        POST_TRANSMIT  = 2'd2,
        IDLE           = 2'd0
    } state_t;

    state_t state;
    assign dataPin_o = (state == TRANSMITING) ? buffer[read_index][ctr_64] : 1'b0;
    assign clkPin_w = (state == TRANSMITING && clk_active_r) ? clk_800MHz : 1'b0;
    assign clkPin_o = clkPin_w;

    ShiftReg_3d #(
        .DATA_BIT_WIDTH(64)
    ) shiftreg_inst (
        .clk        (clk_800MHz),
        .reset      (reset),
        .enable     (valid_i),      
        .enable_ack (data_valid_ack_o),              
        .valid_o    (valid_w),              
        .d_i        (data_i),        
        .q_o        (data_w)               
    );

    always_ff @(posedge clk_800MHz or reset) begin
        if (reset) begin
            integer i;
            write_index <= 0;
            for (i = 0; i < buffer_size; i = i + 1) begin
                buffer[i] <= 64'd0;
            end
        end
        else begin
            if (valid_w && enable_i) begin
                buffer[write_index] <= data_w;
                write_index <= write_index + 1;
            end
        end
    end

    always @(negedge clk_800MHz or reset) begin
        if (reset) clk_active_r <= 1;
        else begin
            if (ctr_64 == 6'd63) clk_active_r <= 0;
            else clk_active_r <= 1;
        end
    end

    always_ff @(posedge clk_800MHz or reset) begin
        if (reset) begin
            read_index <= 0;
            ctr_32 <= 0;
            ctr_64 <= 0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (write_index != read_index) begin
                        state <= TRANSMITING;
                    end
                end

                TRANSMITING: begin
                    //data transmission is serialized to the dataPin_o (64bits)
                    //after that directly jump to POST_TRANSMIT

                    if (ctr_64==6'd63) begin
                        ctr_64 <= 0;
                        read_index <= read_index + 1;
                        state <= POST_TRANSMIT;
                    end else begin
                        ctr_64 <= ctr_64 + 1;
                    end
                end

                POST_TRANSMIT: begin
                    if (ctr_32 == 5'd31) begin
                        ctr_32 <= 0;
                        if (write_index != read_index) begin
                            state <= TRANSMITING;
                        end else begin
                            state <= IDLE;
                        end
                    end else begin
                        ctr_32 <= ctr_32 + 1;
                    end
                end
                default: begin
                    state <= IDLE; // Default case to handle unexpected states
                end
            endcase
        end
    end

endmodule
