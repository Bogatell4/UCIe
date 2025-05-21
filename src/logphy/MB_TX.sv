// Used for UCIe standard package 16 line data bit on MainBand
//TODO: ADD Track line? not sure functionality
//Comment test
module MB_TX #(
    parameter flit_buffer_size = 2 // Number of flit buffers, must be a power of 2 and not 1
)(
    input clk, // Fast clk (2GHz)
    input clk_100MHz, // Slow clk (100MHz)
    input reset,
    input valid_i,
    output valid_ack_o,

    input [7:0] data_i [63:0], // Input data flit serialized (64 bytes)

    input [1:0] periph_clk_i, //just pass through the phased clks [0] is 90º and [1] is 270º
    output [1:0] periph_clkPins_o,

    output valid_pin_o,
    output [15:0] dataPins_o,
    output transmiting_o
);

    reg [7:0] flit_buffer_r [flit_buffer_size-1:0][63:0];
    reg [$clog2(flit_buffer_size)-1:0] write_index;
    reg [$clog2(flit_buffer_size)-1:0] read_index;
    reg transmiting_r;
    wire transmiting_w;
    reg [1:0] ctr_even;
    reg [1:0] ctr_odd;
    wire [2:0] ctr_sum;
    reg [1:0] flit_fragment_index;
    wire [7:0] data_in_sync_w[63:0];
    wire valid_sync_w;
    logic validPin_w;

    
    assign ctr_sum = (ctr_even == 2'b11 && ctr_odd == 2'b00) ? 3'd7 : (ctr_even + ctr_odd);
    assign periph_clkPins_o = periph_clk_i;
    assign valid_pin_o = validPin_w;
    assign transmiting_o = transmiting_r;
    assign transmiting_w = transmiting_r | (write_index != read_index);

    // Generate 64 ShiftReg_3d instances to syncronize the data input from slow 100MHz to fast 2GHz clk domains
    genvar k;
    generate
        for (k = 0; k < 64; k++) begin : gen_shift_regs
            ShiftReg_3d #(
                .DATA_BIT_WIDTH(8)
            ) shift_reg_inst (
                .clk(clk),
                .reset(reset),
                .enable(valid_i),
                .enable_ack(valid_ack_o),
                .valid_o(valid_sync_w),
                .d_i(data_i[k]),
                .q_o(data_in_sync_w[k])
            );
        end
    endgenerate

    always_ff @(posedge clk or reset) begin
        if (reset) begin
            write_index <= 0;
            //reset all the flit buffers
            for (int i = 0; i < flit_buffer_size; i++) begin
                for (int j = 0; j < 64; j++) begin
                    flit_buffer_r[i][j] <= 8'b0;
                end
            end
        end else if (valid_sync_w) begin
            for (int j = 0; j < 64; j++) begin
                flit_buffer_r[write_index][j] <= data_in_sync_w[j];
            end
            write_index <= write_index + 1;
        end
    end


    always_ff @(posedge clk or reset) begin
        if (reset) transmiting_r <= 1'b0;
        else if (flit_fragment_index == 2'b11 && ctr_even == 2'b11) transmiting_r <= 1'b0;
        else if (transmiting_w) transmiting_r <= 1'b1;
    end

    always_ff @(posedge clk or reset) begin
        if(reset) begin
            ctr_even <= 2'b00;  
            flit_fragment_index <= 2'b00;
            read_index <= 0;
        end
        else if(transmiting_r) begin
            ctr_even <= ctr_even + 1;
            if (ctr_even == 2'b11) begin
                if(flit_fragment_index == 2'b11) begin
                    read_index <= read_index + 1;
                    flit_fragment_index <= 2'b00;
                end else begin
                    flit_fragment_index <= flit_fragment_index + 1;
                end
            end
        end
    end

    always_ff @(negedge clk or reset) begin
        if(reset) ctr_odd <= 2'b00;
        else if (transmiting_r == 1'b0) ctr_odd <= 2'b00;
        else
            case(ctr_even)
                2'b00: ctr_odd <= 2'b01;
                2'b01: ctr_odd <= 2'b10;
                2'b10: ctr_odd <= 2'b11;
                2'b11: ctr_odd <= 2'b00;
            endcase
    end


    //Data output multiplexer and serialization
    assign dataPins_o = {flit_buffer_r[read_index][flit_fragment_index*16 + 15][ctr_sum], 
                        flit_buffer_r[read_index][flit_fragment_index*16 + 14][ctr_sum], 
                        flit_buffer_r[read_index][flit_fragment_index*16 + 13][ctr_sum], 
                        flit_buffer_r[read_index][flit_fragment_index*16 + 12][ctr_sum], 
                        flit_buffer_r[read_index][flit_fragment_index*16 + 11][ctr_sum], 
                        flit_buffer_r[read_index][flit_fragment_index*16 + 10][ctr_sum], 
                        flit_buffer_r[read_index][flit_fragment_index*16 + 9][ctr_sum], 
                        flit_buffer_r[read_index][flit_fragment_index*16 + 8][ctr_sum], 
                        flit_buffer_r[read_index][flit_fragment_index*16 + 7][ctr_sum], 
                        flit_buffer_r[read_index][flit_fragment_index*16 + 6][ctr_sum], 
                        flit_buffer_r[read_index][flit_fragment_index*16 + 5][ctr_sum], 
                        flit_buffer_r[read_index][flit_fragment_index*16 + 4][ctr_sum], 
                        flit_buffer_r[read_index][flit_fragment_index*16 + 3][ctr_sum], 
                        flit_buffer_r[read_index][flit_fragment_index*16 + 2][ctr_sum], 
                        flit_buffer_r[read_index][flit_fragment_index*16 + 1][ctr_sum], 
                        flit_buffer_r[read_index][flit_fragment_index*16 + 0][ctr_sum]};

    always_comb begin
        if (transmiting_r && (ctr_even == 2'b00 || ctr_even == 2'b01))
            validPin_w = 1'b1;
        else
            validPin_w = 1'b0;
    end

endmodule
