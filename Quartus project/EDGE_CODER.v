module EDGE_CODER #(parameter N = 16)//, C = 16, vol_C = 8)
(
    nreset,
    en,
    clk,
    rdclk,
    bit_in,
    bit_out
);
    input wire nreset;
    input wire en;
    input wire clk;
    input wire rdclk;
    input wire [N-1:0] bit_in;
    output wire [N-1:0] bit_out;
    
    //wire en_in;
    //wire nreset_in;
    //assign nreset_in = en_in;
    //assign en_in = en;
    /*
    counter_locked # (.delay(C), .vol(vol_C)) unit_delay (
    .rdclk(rdclk),
    .nreset(nreset),
    .en(en),
    .clk(clk),
    .clk_out(en_in)
    );
    */
    
    register # ( .SIZE(N)) reg_1 (
        .q( q_1),
        .d( bit_in),
        //.en( en_in),
        //.nreset( nreset_in),
        .en( en),
        .nreset( nreset ),
        .prn( 1),
        .clk( clk)
    );
    
    wire [N-1:0] q_1,  q_2;
    
    register # ( .SIZE(N)) reg_2 (
        .q( q_2),
        .d( q_1),
        //.en( en_in),
        //.nreset( nreset_in),
        .en( en),
        .nreset( nreset),
        .prn( 1),
        .clk( clk)
    );
     
    assign bit_out = q_1 ^ q_2;
    
    
endmodule