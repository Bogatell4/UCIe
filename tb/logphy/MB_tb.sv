`timescale 1ps/1ps

module MB_tb;

    // Parameters
    parameter flit_buffer_size = 4; // Number of flit buffers, must be a power of 2 and not 1

    // Clocks and reset
    reg clk;
    reg clk_100MHz;
    reg reset;

    // MB_TX inputs
    reg valid_i;
    reg [7:0] data_i [63:0];
    reg [1:0] periph_clk_i;

    // MB_TX outputs
    wire [1:0] periph_clkPins_o;
    wire valid_pin_o;
    wire [15:0] dataPins_o;
    wire transmiting;
    wire valid_ack;
    // MB_RX outputs
    wire valid_o;
    wire [7:0] data_o [63:0];

    MB_TX #(
        .flit_buffer_size(flit_buffer_size)
    ) MBTransmitter (
        .clk(clk),
        .clk_100MHz(clk_100MHz),
        .reset(reset),
        .valid_i(valid_i),
        .valid_ack_o(valid_ack),
        .data_i(data_i),
        .periph_clk_i(periph_clk_i),
        .periph_clkPins_o(periph_clkPins_o),
        .valid_pin_o(valid_pin_o),
        .dataPins_o(dataPins_o),
        .transmiting_o(transmiting)
    );

    MB_RX #(
        .flit_buffer_size(flit_buffer_size)
    ) MBReceiver (
        .clk(clk_100MHz),
        .reset(reset),
        .valid_iPin(valid_pin_o),
        .periph_clkPins_i(periph_clkPins_o),
        .dataPins_i(dataPins_o),
        .valid_o(valid_o),
        .data_o(data_o)
    );

    initial begin
        $dumpfile("../MB_tb.vcd");
        $dumpvars(0, MB_RX_tb);
    end

    // Clock generation
    initial begin
        clk = 0;
        forever #250 clk = ~clk; // 2 GHz
    end

    initial begin
        clk_100MHz = 0;
        forever #5000 clk_100MHz = ~clk_100MHz; // 100 MHz
    end

    // Peripheral clock generation (phase shifted)
    initial begin
        periph_clk_i[0] = 0;
        #125;
        forever #250 periph_clk_i[0] = ~periph_clk_i[0];
    end

    initial begin
        periph_clk_i[1] = 0;
        #375;
        forever #250 periph_clk_i[1] = ~periph_clk_i[1];
    end

    // Test data: 3 flits, each 64 bytes
    reg [7:0] ascii_flit [0:2][0:63];

    initial begin
        string flit_str [0:2];
        flit_str[0] = "Hello world, this is Flit 0.";
        flit_str[1] = "This is Flit 1. I love UCIe!";
        flit_str[2] = "Flit 2. This is the last one.";

        // Fill ascii_flit arrays with string contents, pad with spaces
        for (int f = 0; f < 3; f++) begin
            for (int i = 0; i < 64; i++) begin 
                if (i < flit_str[f].len())
                    //if (f==0) begin
                    //    ascii_flit[f][i] = 8'hFF;
                    //end else begin
                        ascii_flit[f][i] = flit_str[f].getc(i);
                    //end
                else
                    ascii_flit[f][i] = " ";
            end
        end
    end

    // Checker: Compare RX output to input flits
    integer check_flit = 0;
    always @(posedge clk_100MHz) begin
        if (valid_o) begin
            integer match = 1;
            for (int i = 0; i < 64; i++) begin
                if (data_o[i] !== ascii_flit[check_flit][i]) begin
                    $error("Mismatch at flit %0d, byte %0d: expected %h, got %h", check_flit, i, ascii_flit[check_flit][i], data_o[i]);
                    match = 0;
                end
            end
            if (match == 1)
                $display("Flit %0d received OK and matches input.", check_flit);
            check_flit <= check_flit + 1;
        end
    end

    // Stimulus: Send each flit to MB_TX
    initial begin
        valid_i = 0;
        data_i = '{default:0};
        reset = 1;
        #1000 reset = 0;


        //this valid/enable signaling needs to be done with an asyncronous reset register with the ack
        for (int flitNum = 0; flitNum < 3; flitNum++) begin
            @(posedge clk_100MHz);
            valid_i = 1;
            for (int i = 0; i < 64; i++) begin
                data_i[i] = ascii_flit[flitNum][i];
            end
            wait (valid_ack);
            valid_i = 0;
        end
        

        #200000;
        $finish;
    end


endmodule
