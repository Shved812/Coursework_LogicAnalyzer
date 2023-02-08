module RLE_CODER #(parameter N = 16, vol_N = 4, P = 16)
(
    signal,
    rdclk,
    clk,
    nreset,
    en,
    word_out,
    ready
);
input wire [N-1:0] signal;
input wire rdclk;
input wire clk;
input wire en;
input wire nreset;
output reg [N-1:0]word_out = 0;
output reg ready = 0;


wire nreset_delayer;
assign nreset_delayer = nreset && clk;

wire [0:N-1] clk_coded;

delayer delay_unit[N-1:0](          //create delay becase coder_unit want send time
    .rdclk(rdclk),
    .nreset(clk),//nreset_delayer),
    .en(en),
    .clk( {clk, clk_coded[0:N-2]} ),
    .clk_out( clk_coded )
);


wire [N*P-1:0]word_t;
wire [N-1:0] rd_t;
/*
RLE_CODER_CODER coder_unit[N-1:0](  //coder_unit
    .rdclk(rdclk),
    .en(en),
    .nreset(nreset),
    .clk(clk_coded),
    
    .bit_in(signal),
    
    .word_out(word_t),
    .ready(rd_t)
);
*/
  genvar a; // generate iterator
  generate
    for(a=0;a<N;a=a+1) begin: some_RLE_unit
      RLE_CODER_CODER #(.adr(a)) coder_unit(  //coder_unit
    .rdclk(rdclk),
    .en(en),
    .nreset(nreset),
    .clk(clk_coded[a]),
    
    .bit_in(signal[a]),
    
    .word_out(word_t[N*(a+1)-1:N*a]),
    .ready(rd_t[a])
    );
      end
  endgenerate
wire [vol_N:0]encoder_to_num_s;
priority_encoder encoder_unit(      //priority_encoder for send do serial
    .en(en),
    .x(rd_t),
    .y(encoder_to_num_s)
);

reg [vol_N:0] number_of_sender;     //connect 
//always @(rd_t)
always @(posedge rdclk)
begin
    number_of_sender <= encoder_to_num_s;
end

always @*               //send function
begin
    if(!nreset) begin
        word_out <= 0;
        ready <= 0;
    end else begin
        if(en)begin
            if(number_of_sender > 0) begin
                word_out <= word_t>>(N*(number_of_sender-1));
                ready <= rd_t>>(number_of_sender-1);
            end else begin
                //word_out <= 0;
                ready <= 0;
            end
        end
    end
end

endmodule
