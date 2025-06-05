// Module for Transmission through sideband
`include "LTSM/SB_codex_pkg.vh"

module SB_TX #(
    parameter fast_buffer_size = 4 // Must be a power of 2 and >1
)(
    input clk_100MHz,
    input clk_800MHz,
    input reset,

    input  [63:0] dataBus_i, // Data input, single sideband msg is 64 bits
    input SB_msg_t SB_msg_i, // Sideband message input

    input  valid_i,
    input  enable_i,

    output logic send_next_flag_o, // Flag set to 1 indicates that the module is ready for a new message at the input. 

    output dataPin_o,
    output clkPin_o
);



    // Sideband msg buffer
    reg [63:0] buffer [fast_buffer_size-1:0];
    reg [$clog2(fast_buffer_size)-1:0] write_index;
    reg [$clog2(fast_buffer_size)-1:0] read_index;

    reg [4:0] ctr_32; // 5 bits to count up to 32 (0-31)
    reg [5:0] ctr_64; // 6 bits to count up to 64 (0-63)
    reg clk_active_r;
    wire [63:0] data_w;
    wire valid_w;
    wire clkPin_w;

    logic valid_ShiftReg_flag;
    wire data_valid_ack_o;

    logic [63:0] Stored_data_r;
    wire [63:0] ShiftReg_data_w;
    wire [63:0] encoded_msg_w;
    wire expect_32b_data_w;
    wire expect_64b_data_w;
    reg expect_32b_data_r;
    reg expect_64b_data_r;

    always_ff @(posedge clk_100MHz or reset) begin
        if (reset) begin
            Stored_data_r <= 64'd0;
            expect_32b_data_r <= 1'b0;
            expect_64b_data_r <= 1'b0;
        end
        else if (valid_i && enable_i) begin
            Stored_data_r <= dataBus_i;
            if (expect_32b_data_r==0'b0 && expect_64b_data_r==0'b0) begin
                expect_32b_data_r <= expect_32b_data_w;
                expect_64b_data_r <= expect_64b_data_w;
            end else begin
                expect_32b_data_r <= 1'b0;
                expect_64b_data_r <= 1'b0;
            end
        end
    end

    

    always_comb begin
        encode_SB_msg(SB_msg_i, encoded_msg_w, expect_32b_data_w, expect_64b_data_w);
    end   

    assign ShiftReg_data_w = (expect_32b_data_r) ? {32'd0, Stored_data_r[31:0]} :
                             (expect_64b_data_r) ? Stored_data_r :
                             encoded_msg_w;


    logic delay1;
    // async reset of the ShiftReg_data flag
    always_ff @(negedge clk_100MHz or reset or posedge data_valid_ack_o) begin
        if (reset) begin
            valid_ShiftReg_flag <= 1'b0;
            delay1 <= 1'b0;
        end else if (data_valid_ack_o) begin
            valid_ShiftReg_flag <= 1'b0; // Reset the flag when data is acknowledged
        end else if (valid_i && enable_i) begin
            valid_ShiftReg_flag <= 1'b1; // Set the flag when valid_ShiftReg is high
            if (expect_32b_data_w || expect_64b_data_w) begin
                delay1 <= 1'b1;
            end
        end else if (delay1 == 1'b1) begin
            valid_ShiftReg_flag <= 1'b1;
            delay1 <= 1'b0; // Reset the delay flag after one cycle
        end
    end

    always_ff @(negedge clk_100MHz) begin
        if (reset) begin
            send_next_flag_o <= 1'b0;
        end else begin
            if (delay1 == 1'b1) begin
                send_next_flag_o <= 1'b1; 
            end else if ((expect_32b_data_w || expect_64b_data_w) && valid_i && enable_i ) begin
                send_next_flag_o <= 1'b0; 
            end else send_next_flag_o <= 1'b1;
        end
    end 

    // Shift register to handle the data input syncronization
    ShiftReg_3d #(
        .DATA_BIT_WIDTH(64)
    ) shiftreg_inst (
        .clk        (clk_800MHz),
        .reset      (reset),
        .enable     (valid_ShiftReg_flag),      
        .enable_ack (data_valid_ack_o),              
        .valid_o    (valid_w),              
        .d_i        (ShiftReg_data_w),        
        .q_o        (data_w)               
    );


    //state machine for the transmission control
    typedef enum logic [1:0] {
        TRANSMITING    = 2'd1,
        POST_TRANSMIT  = 2'd2,
        IDLE           = 2'd0
    } state_t;
    state_t state;

    // pin wire assignations
    assign dataPin_o = (state == TRANSMITING) ? buffer[read_index][ctr_64] : 1'b0;
    assign clkPin_w = (state == TRANSMITING && clk_active_r) ? clk_800MHz : 1'b0;
    assign clkPin_o = clkPin_w;



    // write index and data to the buffer logic
    always_ff @(posedge clk_800MHz or reset) begin
        if (reset) begin
            integer i;
            write_index <= 0;
            for (i = 0; i < fast_buffer_size; i = i + 1) begin
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

    // Active clock signal logic, used to control the clkPin_o
    always @(negedge clk_800MHz or reset) begin
        if (reset) clk_active_r <= 1;
        else begin
            if (ctr_64 == 6'd63) clk_active_r <= 0;
            else clk_active_r <= 1;
        end
    end

    // State machine for transmission control
    // Check figure 4-8 of the spec for the sideband transmission behaviour
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
