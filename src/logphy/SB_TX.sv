module SB_TX #(
    parameter buffer_size = 4 // Must be a power of 2 and >1
)(
    input clk, //800MHz
    input reset,

    input  [63:0] data_i,
    input  valid_i,
    input  enable_i,

    output dataPin_o,
    output clkPin_o
);

    // Buffer and indices
    reg [63:0] buffer [buffer_size-1:0];
    reg [$clog2(buffer_size)-1:0] write_index;
    reg [$clog2(buffer_size)-1:0] read_index;

    reg [4:0] ctr_32; // 5 bits to count up to 32 (0-31)
    reg [5:0] ctr_64; // 6 bits to count up to 64 (0-63)
    reg clkPin_r;
    reg dataPin_r;

    assign dataPin_o = dataPin_r;
    assign clkPin_o = clkPin_r;

    typedef enum logic [1:0] {
        TRANSMITING,
        POST_TRANSMIT,
        IDLE
    } state_t;

    state_t state;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            integer i;
            write_index <= 0;
            for (i = 0; i < buffer_size; i = i + 1) begin
                buffer[i] <= 64'd0;
            end
        end
        else begin
            if (valid_i && enable_i) begin
                buffer[write_index] <= data_i;
                write_index <= write_index + 1;
            end
        end
    end

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            read_index <= 0;
            ctr_32 <= 0;
            ctr_64 <= 0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    clkPin_r <= 1'b0;
                    dataPin_r <= 1'b0;
                    if (write_index != read_index) begin
                        state <= TRANSMITING;
                        clkPin_r <= 1'b1;
                    end
                end

                TRANSMITING: begin
                    //data transmission is serialized to the dataPin_o (64bits)
                    //after that directly jump to POST_TRANSMIT
                    dataPin_r <= buffer[read_index][ctr_64];
                    if (ctr_64==6'd0) begin 
                        clkPin_r <= 1'b1;
                        ctr_64 <= ctr_64 + 1;
                    end else if (ctr_64==6'd63) begin
                        ctr_64 <= 0;
                        read_index <= read_index + 1;
                        state <= POST_TRANSMIT;
                    end else begin
                        ctr_64 <= ctr_64 + 1;
                        clkPin_r <= ~clkPin_r;
                    end
                end

                POST_TRANSMIT: begin
                    dataPin_r <= 1'b0;
                    clkPin_r <= ~clkPin_r;
                    if (ctr_32 == 5'd31) begin
                        ctr_32 <= 0;
                        if (write_index != read_index) begin
                            state <= TRANSMITING;
                            clkPin_r <= 1'b1;
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
