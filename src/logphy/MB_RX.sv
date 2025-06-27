// Current implementation supports UCIe standard package 16 line data bit on MainBand. 64B flit size
// No track line defined or used in this file

module MB_RX #(
    parameter flit_buffer_size = 4 // Number of flit buffers, cant be 1 and needs to be a power of 2
)(
    input clk,
    input reset, // Reset High stay, noposedge

    input valid_iPin,
    input [1:0] periph_clkPins_i,
    input [15:0] dataPins_i,

    output valid_o,
    output [7:0] data_o [63:0] // 64 lanes, 8 bits each, total 64B flit size
);

// verilator lint_off MULTIDRIVEN
// Possible warning of multi driven clocks for the same variable, made on purpose! chech electrical layer spec.
// Got 2 clk lines input. actually odd and even entries are clocked each on a different clock
reg [15:0] mem_async [flit_buffer_size-1:0] [3:0] [7:0];
//verilator lint_on MULTIDRIVEN

// this two counters are used to keep track of the even and odd entries
reg [1:0] ctr_even;
reg [1:0] ctr_odd;

//flit fragment index counts to 4 to complete a full flit: Flit size is 64B and with 16 lanes we store 16B so we need 4 "fragments" to complete the flit
//this could be calculated with a parameter with amount of lanes and flit size
reg [1:0] flit_fragment_index;

reg [$clog2(flit_buffer_size)-1:0] async_write_index;
reg [$clog2(flit_buffer_size)-1:0] read_index;

reg enable_shift_reg_r;
wire valid_o_shift_reg_w;
wire enable_ack_shift_reg_w;

// Generate wire multiplexer to select the flit buffer to read with read_index
// this wire routing also deserialises the data and maps it to the shift register for syncronization
wire [7:0] selected_mem_async_w [63:0];
generate
genvar h, b;
    for (h = 0; h < 4; h++) begin : gen_mux_wires
        for (b = 0; b < 16; b++) begin
            assign selected_mem_async_w [((h*16) + b )][0] = mem_async[read_index][h][0][b];
            assign selected_mem_async_w [((h*16) + b )][1] = mem_async[read_index][h][1][b];
            assign selected_mem_async_w [((h*16) + b )][2] = mem_async[read_index][h][2][b];
            assign selected_mem_async_w [((h*16) + b )][3] = mem_async[read_index][h][3][b];
            assign selected_mem_async_w [((h*16) + b )][4] = mem_async[read_index][h][4][b];
            assign selected_mem_async_w [((h*16) + b )][5] = mem_async[read_index][h][5][b];
            assign selected_mem_async_w [((h*16) + b )][6] = mem_async[read_index][h][6][b];
            assign selected_mem_async_w [((h*16) + b )][7] = mem_async[read_index][h][7][b];
            assign selected_mem_async_w [((h*16) + b )][0] = mem_async[read_index][h][0][b];
            assign selected_mem_async_w [((h*16) + b )][1] = mem_async[read_index][h][1][b];
            assign selected_mem_async_w [((h*16) + b )][2] = mem_async[read_index][h][2][b];
            assign selected_mem_async_w [((h*16) + b )][3] = mem_async[read_index][h][3][b];
            assign selected_mem_async_w [((h*16) + b )][4] = mem_async[read_index][h][4][b];
            assign selected_mem_async_w [((h*16) + b )][5] = mem_async[read_index][h][5][b];
            assign selected_mem_async_w [((h*16) + b )][6] = mem_async[read_index][h][6][b];
            assign selected_mem_async_w [((h*16) + b )][7] = mem_async[read_index][h][7][b];
        end
    end
endgenerate

// Generate block for ShiftReg_3d instances
generate
genvar k;
    for (k = 0; k < 64; k++) begin : gen_shift_regs
        ShiftReg_3d #(
            .DATA_BIT_WIDTH(8)
        ) sync_shift_reg (
            .clk(clk),
            .reset(reset),
            .enable(enable_shift_reg_r),
            .enable_ack(enable_ack_shift_reg_w),
            .valid_o(valid_o_shift_reg_w),
            .d_i(selected_mem_async_w[k]),
            .q_o(data_o[k])
        );
    end
endgenerate
// Combine valid signals from all ShiftReg_3d instances, not very efficient or error proof, but works for now
assign valid_o = | valid_o_shift_reg_w;

// Control logic for enable signal of shift registers for syncronization
// Enable if write index diferent from read index of the mem buffer
// clocked with the even clock which is a fast clock (2GHz), the same clk as the last bit of a flit is writen
always_ff @(posedge periph_clkPins_i[1] or reset) begin
    if (reset) begin
        enable_shift_reg_r <= 1'b0;
    end else begin
        if (read_index != async_write_index) enable_shift_reg_r <= 1'b1;
        else if (enable_ack_shift_reg_w) enable_shift_reg_r <= 1'b0;
    end
end

// Control logic for the read_index, clocked with the main slow clk (100MHz)
// This is used to read the data from the mem_async buffer and pass it to the shift registers
always_ff @(posedge clk or reset) begin
    if (reset) begin
        read_index <= 0;
    end else begin
        if (read_index != async_write_index) begin
            if(enable_shift_reg_r)read_index <= read_index + 1;
        end
    end
end

// even bit assignation of the flit buffer
// clocked with a phase of the periph_clkPins_i[0] which is a fast clock (2GHz)
always_ff @(posedge periph_clkPins_i[0] or reset) begin 
    if (reset) begin
        ctr_even <= 2'b00;
        for (int i = 0; i < flit_buffer_size; i++) begin // Iterate over full buffer dimension
            for (int j = 0; j < 4; j++) begin
                // Reset all even entries
                mem_async[i][j][0] <= 16'h0;
                mem_async[i][j][2] <= 16'h0;
                mem_async[i][j][4] <= 16'h0;
                mem_async[i][j][6] <= 16'h0;
            end
        end
    end else begin
        case (ctr_even)
            2'b00: if (valid_iPin) begin
            mem_async[async_write_index][flit_fragment_index][0] <= dataPins_i;
            ctr_even <= ctr_even + 1;
            end
            2'b01: if (valid_iPin) begin
            mem_async[async_write_index][flit_fragment_index][2] <= dataPins_i;
            ctr_even <= ctr_even + 1;
            end
            2'b10: if (!valid_iPin) begin
            mem_async[async_write_index][flit_fragment_index][4] <= dataPins_i;
            ctr_even <= ctr_even + 1;
            end
            2'b11: if (!valid_iPin) begin
            mem_async[async_write_index][flit_fragment_index][6] <= dataPins_i;
            ctr_even <= ctr_even + 1;
            end
        endcase

    end
end

// Same but now with the odd entries and clocked with the other phase of the periph_clkPins_i[1] (2GHz)
always_ff @(posedge periph_clkPins_i[1] or reset) begin
    if (reset) begin
        ctr_odd <= 2'b00;
        flit_fragment_index <= 2'h0;
        async_write_index <= 0;
        for (int i = 0; i < flit_buffer_size; i++) begin
            for (int j = 0; j < 4; j++) begin
                // Reset all odd entries
                mem_async[i][j][1] <= 16'h0; 
                mem_async[i][j][3] <= 16'h0;
                mem_async[i][j][5] <= 16'h0;
                mem_async[i][j][7] <= 16'h0;
            end
        end
    end else begin
        case (ctr_odd)
            2'b00: if (valid_iPin) begin
                mem_async[async_write_index][flit_fragment_index][1] <= dataPins_i;
                ctr_odd <= ctr_odd + 1;
            end
            2'b01: if (valid_iPin) begin
                mem_async[async_write_index][flit_fragment_index][3] <= dataPins_i;
                ctr_odd <= ctr_odd + 1;
            end
            2'b10: if (!valid_iPin) begin
                mem_async[async_write_index][flit_fragment_index][5] <= dataPins_i;
                ctr_odd <= ctr_odd + 1;
            end
            2'b11: if (!valid_iPin) begin
                mem_async[async_write_index][flit_fragment_index][7] <= dataPins_i;
                if (flit_fragment_index == 2'd3) begin
                    async_write_index <= async_write_index + 1;
                end
                flit_fragment_index <= flit_fragment_index + 1;
                ctr_odd <= ctr_odd + 1;
            end
        endcase
    end
end

endmodule
