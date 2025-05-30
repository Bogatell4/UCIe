
module SBINIT (
    input clk_100MHz,
    input clk_800MHz,
    input reset,
    input enable_i,

    input SB_clkPin_RX_i,
    input SB_dataPin_RX_i,
    output logic SB_clkPin_TX_o,
    output logic SB_dataPin_TX_o,

    output logic SBINIT_done_o,
    
);

endmodule
