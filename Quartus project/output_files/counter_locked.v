module counter_locked #(parameter delay = 5, vol = 3)
(
    input wire rdclk,
    input wire nreset,
    input wire en,
    input wire clk,
    output wire clk_out
);

reg [1:0] clk_reg = 0;
always @(posedge rdclk)
begin
    if(!nreset)begin
        clk_reg <= 0;
    end else begin
        if(en)begin
            clk_reg <= {clk_reg[0], clk};
        end
    end
end

reg [vol-1:0]cnt = 0;
always @(posedge rdclk)
begin
    if(!nreset)begin
        cnt <= 0;
    end else begin
        if(en)begin
            if(( (clk_reg[0] == 0) && (clk_reg[1] == 1) ) && cnt < delay)
                cnt <= cnt + 1;
        end
    end
end

assign clk_out = (cnt == delay);

endmodule