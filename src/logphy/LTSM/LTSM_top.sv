module LTSM_top (

    input clk_100MHz,
    input clk_800MHz,
    input clk_2GHz,
    input reset,
    input enable_i,

    input start_LT_i,

    //SB Pins
    output SB_clkPin_TX_o,
    output SB_dataPin_TX_o,
    input SB_clkPin_RX_i,
    input SB_dataPin_RX_i,

    //MB Pins
    input [1:0] MB_clkPins_i,
    input [15:0] MB_dataPins_i,
    output [1:0] MB_clkPins_o,
    output [15:0] MB_dataPins_o
);
    // Internal signals
    wire [63:0] SB_msg_i_w;
    wire SB_msg_valid_i_w;
    reg SB_msg_req_flag;
    reg SB_msg_req;

    reg [63:0] SB_msg_o;
    reg SB_TX_valid;
    reg SB_TX_valid_flag;
    wire SB_TX_valid_ack_w;
    reg enable_SB_tx;
    reg enable_SB_rx;

    /* Instantiate SB_TX
    SB_TX #(
        .buffer_size(4)
    ) SB_tx_inst (
        .clk_800MHz(clk_800MHz),
        .reset(reset),
        .data_i(SB_msg_i),
        .valid_i(SB_TX_valid_flag),
        .enable_i(enable_SB_tx),
        .data_valid_ack_o(SB_msg_TX_valid_ack_w),
        .dataPin_o(SB_dataPin_TX_o),
        .clkPin_o(SB_clkPin_TX_o)
    );*/

    //logic for set and async reset of SB_TX_valid_flag
    /* MAYBE NOT NEEDED use if too many msgs are sent out at once
    always_ff @(posedge clk_100MHz or reset or posedge SB_TX_valid_ack_w) begin
        if (reset) SB_TX_valid_flag <= 1'b0;
        else if (SB_TX_valid_ack_w) SB_TX_valid_flag <= 1'b0;
        else if (SB_TX_valid) SB_TX_valid_flag <= 1'b1;
    end*/

    /* Instantiate SB_RX
    SB_RX #(
        .buffer_size(4)
    ) SB_rx_inst (
        .clk_800MHz(clk_800MHz),
        .clk_100MHz(clk_100MHz),
        .reset(reset),
        .enable_i(enable_rx),
        .msg_req_i(SB_msg_req_flag),
        .dataPin_i(SB_dataPin_RX_i), 
        .clkPin_i(SB_clkPin_RX_i),  
        .data_o(SB_msg_i_w),
        .valid_o(SB_msg_valid_iW)
    );*/

    //logic for set and async reset of SB_msg_req_flag
    /* MAYBE NOT NEEDED use if too many msgs come out at once
    always_ff @(posedge clk_100MHz or reset or posedge SB_msg_valid_i_w) begin
        if (reset) SB_msg_req_flag <= 1'b0;
        else if (SB_msg_valid_i_w) SB_msg_req_flag <= 1'b0;
        else if (SB_msg_req) SB_msg_req_flag <= 1'b1;
    end*/



    typedef enum logic [2:0] {
        SBPins_to_Z = 3'd0,
        SBPins_disabled = 3'd1,
        SBPins_to_SBINIT = 3'd2,
        SBPins_to_COMS = 3'd3
    } SB_mux_sel_t;

    typedef enum logic [2:0] {
        MBPins_to_Z = 3'd0,
        MBPins_disabled = 3'd1,
        MBPins_to_MBINIT = 3'd2,
        MBPins_to_COMS = 3'd3
    } MB_mux_sel_t;

    // Muxes select signals for SB and MB pins
    SB_mux_sel_t SB_clkPin_TX_sel;
    SB_mux_sel_t SB_dataPin_TX_sel;
    SB_mux_sel_t SB_clkPin_RX_sel;
    SB_mux_sel_t SB_dataPin_RX_sel;

    MB_mux_sel_t MB_clkPins_TX_sel;
    MB_mux_sel_t MB_dataPins_TX_sel;
    MB_mux_sel_t MB_clkPins_RX_sel;
    MB_mux_sel_t MB_dataPins_RX_sel;

    // Signal Sources for the muxes
    logic SB_clkPin_TX_SBINIT, SB_clkPin_RX_SBINIT;
    logic SB_dataPin_TX_SBINIT, SB_dataPin_RX_SBINIT;

    logic SB_clkPin_TX_TRANSMITTER, SB_clkPin_RX_RECIEVER;
    logic SB_dataPin_TX_TRANSMITTER, SB_dataPin_RX_RECIEVER;

    logic [1:0] MB_clkPins_TX_MBINIT, MB_clkPins_RX_MBINIT;
    logic [15:0] MB_dataPins_TX_MBINIT, MB_dataPins_RX_MBINIT;

    // Mux logic
    assign SB_clkPin_TX_o  = (SB_clkPin_TX_sel == SBPins_to_Z) ? 'z  :
                            (SB_clkPin_TX_sel == SBPins_disabled) ? '0  :
                            (SB_clkPin_TX_sel == SBPins_to_COMS) ? SB_clkPin_TX_TRANSMITTER :
                            (SB_clkPin_TX_sel == SBPins_to_SBINIT) ? SB_clkPin_TX_SBINIT  : 'z;

    assign SB_dataPin_TX_o = (SB_dataPin_TX_sel == SBPins_to_Z) ? 'z :
                            (SB_dataPin_TX_sel == SBPins_disabled) ? '0 :
                            (SB_dataPin_TX_sel == SBPins_to_COMS) ? SB_dataPin_TX_TRANSMITTER :
                            (SB_dataPin_TX_sel == SBPins_to_SBINIT) ? SB_dataPin_TX_SBINIT : 'z;

    assign MB_clkPins_o    = (MB_clkPins_TX_sel == MBPins_to_Z) ? 'z    :
                            (MB_clkPins_TX_sel == MBPins_disabled) ? '0    :
                            (MB_clkPins_TX_sel == MBPins_to_MBINIT) ? MB_clkPins_TX_MBINIT    : 'z;

    assign MB_dataPins_o   = (MB_dataPins_TX_sel == MBPins_to_Z) ? 'z   :
                            (MB_dataPins_TX_sel == MBPins_disabled) ? '0   :
                            (MB_dataPins_TX_sel == MBPins_to_MBINIT) ? MB_dataPins_TX_MBINIT   : 'z;


    assign SB_clkPin_RX_SBINIT   = (SB_clkPin_RX_sel   == SBPins_to_SBINIT) ? SB_clkPin_RX_i   : 1'b0;
    assign SB_dataPin_RX_SBINIT  = (SB_dataPin_RX_sel  == SBPins_to_SBINIT) ? SB_dataPin_RX_i  : 1'b0;

    assign SB_clkPin_RX_RECIEVER   = (SB_clkPin_RX_sel   == SBPins_to_COMS) ? SB_clkPin_RX_i   : 1'b0;
    assign SB_dataPin_RX_RECIEVER  = (SB_dataPin_RX_sel  == SBPins_to_COMS) ? SB_dataPin_RX_i  : 1'b0;

    assign MB_clkPins_RX_MBINIT  = (MB_clkPins_RX_sel  == MBPins_to_MBINIT) ? MB_clkPins_i     : 2'b00;
    assign MB_dataPins_RX_MBINIT = (MB_dataPins_RX_sel == MBPins_to_MBINIT) ? MB_dataPins_i    : 16'h0000;

    typedef enum { 
        TRAINERROR,
        RESET,
        SBINIT,
        MBINIT,
        MBTRAIN,
        LINKINIT,
        ACTIVE
    } LT_state_t;

    LT_state_t LT_Current_state;
    LT_state_t LT_NEXT_state;

    //Current state update
    always_ff @(posedge clk_100MHz or posedge reset) begin
        if (reset) LT_Current_state <= RESET;
        else LT_Current_state <= LT_NEXT_state;
    end

    // Next state logic
    always_comb begin
        case (LT_Current_state)

            RESET: begin
                if (enable_i && start_LT_i) LT_NEXT_state = SBINIT;
                else LT_NEXT_state = LT_Current_state; // Stay in RESET state
            end

            SBINIT: begin
            end
            default: LT_NEXT_state = RESET;
        endcase
    end

    // Current state actions
    always_comb begin
        case (LT_Current_state)

            RESET: begin
                SB_msg_o = '0;
                enable_SB_rx = 1'b1;
                enable_SB_tx = 1'b0;
                SB_TX_valid = 1'b0;
                SB_TX_valid_flag = 1'b0;
                SB_msg_req = 1'b0;
                SB_msg_req_flag = 1'b0;

                MB_clkPins_TX_sel = MBPins_to_Z;
                MB_dataPins_TX_sel = MBPins_to_Z;
                MB_clkPins_RX_sel = MBPins_to_MBINIT;
                MB_dataPins_RX_sel = MBPins_to_MBINIT;

                SB_clkPin_TX_sel = SBPins_disabled;
                SB_dataPin_TX_sel = SBPins_disabled;
                SB_clkPin_RX_sel = SBPins_to_SBINIT;
                SB_dataPin_RX_sel = SBPins_to_SBINIT;
            end

            SBINIT: begin
                MB_clkPins_TX_sel = MBPins_to_Z;
                MB_dataPins_TX_sel = MBPins_to_Z;
                MB_clkPins_RX_sel = MBPins_to_MBINIT;
                MB_dataPins_RX_sel = MBPins_to_MBINIT;


            end

        endcase
    end

endmodule
