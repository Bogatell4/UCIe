module SidebandDeserializer(
    input          clk,
    input          reset,

    input  [127:0] data_i,
    input          valid_i,
    output         valid_o,
    output [127:0] data_o
);
    reg [127:0] data_r;
    reg  receiving;
    wire  _GEN_2 = valid_i ? 1'h0 : receiving;
    wire  _GEN_3 = valid_o | _GEN_2;

    assign valid_o = ~receiving;
    assign data_o = data_r;
    always @(posedge clk) begin
        if (valid_i) begin
            data_r <= data_i;
        end
        receiving <= reset | _GEN_3;
    end
endmodule
