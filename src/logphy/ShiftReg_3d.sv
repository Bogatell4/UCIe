// 3 stage shift register used for syncronization of data between different clock domains

module ShiftReg_3d #(
    parameter DATA_BIT_WIDTH = 3
)(
    input   clk,
    input   reset,
    input   enable,
    output  enable_ack, // triggered when enable is recieved and shifting starts
    output  valid_o,
    input   [DATA_BIT_WIDTH-1:0] d_i,
    output  [DATA_BIT_WIDTH-1:0] q_o
);
    // Compile-time error detection for DATA_BIT_WIDTH greater than 1
    initial begin
        if (DATA_BIT_WIDTH == 1) begin
            $error("DATA_BIT_WIDTH must be greater than 1 for proper operation.");
        end
    end

    reg [DATA_BIT_WIDTH-1:0] sync_r [2:0];
    assign q_o = sync_r[2];

    reg enable_ack_r;
    assign enable_ack = enable_ack_r;

    // Add a single shift register for valid_o triggered by enable
    // This will indicate if the output is valid after the 3 step synchronization
    reg [2:0] valid_r;
    assign valid_o = valid_r[2];

    // Asynchronous reset
    always @(posedge clk or reset) begin
        if (reset) begin
            sync_r[0] <= {DATA_BIT_WIDTH{1'b0}};
            sync_r[1] <= {DATA_BIT_WIDTH{1'b0}};
            sync_r[2] <= {DATA_BIT_WIDTH{1'b0}};
            valid_r[0] <= 1'b0;
            valid_r[1] <= 1'b0;
            valid_r[2] <= 1'b0;
        end else begin
            if (enable) begin
                sync_r[0] <= d_i;
                valid_r[0] <= 1'b1; // Set valid when enable is high
                enable_ack_r <= 1'b1; // Acknowledge enable
            end else begin
                sync_r[0] <= sync_r[0];
                enable_ack_r <= 1'b0;
                valid_r[0] <= 1'b0; // Clear valid when enable is low
            end
            sync_r[1] <= sync_r[0];
            sync_r[2] <= sync_r[1];
            valid_r[1] <= valid_r[0];
            valid_r[2] <= valid_r[1];
        end
    end

endmodule
