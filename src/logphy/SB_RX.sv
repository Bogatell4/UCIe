module SB_RX #(
    parameter buffer_size = 4 // Must be a power of 2 and >1
)(
    input clk,         // System clock (not the serial clkPin) 800MHz
    input reset,

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
    reg [4:0] idle_cnt; 
    reg load_intermediate;

    // Shift register: capture data on negedge of clkPin_i
    always_ff @(negedge clkPin_i or posedge reset) begin
        if (reset) begin
            shift_reg <= 64'd0;
            idle_cnt <= 5'd0;
            bit_cnt <= 6'd0;
            load_intermediate <= 1'b0;
        end else begin
            if (bit_cnt == 6'd63)

        end
    end

endmodule
