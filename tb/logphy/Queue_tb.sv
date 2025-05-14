//`timescale 1ns/1ps
//`include "../../src/logphy/Queue.sv"

module Queue_tb;
  reg          clk;
  reg          reset;
  reg          enq_valid_i;
  reg  [127:0] data_i;
  reg          deq_rdy_i;
  wire         enq_rdy_o;
  wire         deq_valid_o; 
  wire [127:0] data_o;

  Queue dut (
    .clk(clk),
    .reset(reset),
    .enq_rdy_o(enq_rdy_o),
    .enq_valid_i(enq_valid_i),
    .data_i(data_i),
    .deq_rdy_i(deq_rdy_i),
    .deq_valid_o(deq_valid_o),
    .data_o(data_o)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk; // Toggle clock every 5 time units
  end

  initial begin
    $dumpfile("../Queue_tb.vcd"); // Specify the name of the VCD file
    $dumpvars(0, Queue_tb);    // Dump all variables in the Queue_tb module
    end

  // Testbench logic
  initial begin
    reset = 1;
    enq_valid_i = 0;
    data_i = 0;
    deq_rdy_i = 0;

    // Apply reset
    #10 reset = 0;

    // Test enqueue operation
    $display("Starting enqueue test...");
    enq_valid_i = 1;
    data_i = 128'hAABBCCDDEEFF00112233445566778899;
    
    #20;
    enq_valid_i = 0;

    // Wait for enqueue to complete
    @(posedge clk);

    // Test dequeue operation
    $display("Starting dequeue test...");
    deq_rdy_i = 1;
    @(posedge clk);
    deq_rdy_i = 0;

    // Wait for dequeue to complete
    @(posedge clk);

    // Test reset functionality
    $display("Testing reset...");
    reset = 1;
    @(posedge clk);
    reset = 0;

    // Finish simulation
    $display("Test completed.");
    $finish;
  end

  // Monitor signals
  initial begin
    $monitor("Time: %0t | enq_rdy_o: %b | enq_valid_i: %b | data_i: %h | deq_rdy_i: %b | deq_valid_o: %b | data_o: %h",
             $time, enq_rdy_o, enq_valid_i, data_i, deq_rdy_i, deq_valid_o, data_o);
  end


endmodule
