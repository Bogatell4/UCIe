module Queue(
  //128-bit data queue with 4 entries, TODO: make it parameterized
  input          clk,
  input          reset,

  output         enq_rdy_o,
  input          enq_valid_i,
  input  [127:0] data_i,

  input          deq_rdy_i,
  output         deq_valid_o,
  output [127:0] data_o
);
  reg [127:0] ram [0:3];

  reg [1:0] enq_ptr_value;
  reg [1:0] deq_ptr_value;

  reg  maybe_full;
  wire  ptr_match = enq_ptr_value == deq_ptr_value;

  wire  empty = ptr_match & ~maybe_full;
  wire  full = ptr_match & maybe_full;

  wire  do_enq = enq_rdy_o & enq_valid_i;
  wire  do_deq = deq_rdy_i & deq_valid_o;

  assign enq_rdy_o = ~full;
  assign deq_valid_o = ~empty;

  assign data_o = ram[deq_ptr_value];

  always @(posedge clk) begin
    if (enq_rdy_o & enq_valid_i) begin
      ram[enq_ptr_value] <= data_i;
    end

    if (reset) begin
      enq_ptr_value <= 2'h0;
      deq_ptr_value <= 2'h0;
      maybe_full <= 1'h0;
      // ADDED functionality: Reset all RAM entries to 0
      for (int i = 0; i < 4; i++) begin
        ram[i] <= 128'h0;
      end
    end else begin
      if (do_enq) enq_ptr_value <= enq_ptr_value + 2'h1;
      if (do_deq) deq_ptr_value <= deq_ptr_value + 2'h1;
      if (do_enq != do_deq) maybe_full <= do_enq;
    end
  end

endmodule
