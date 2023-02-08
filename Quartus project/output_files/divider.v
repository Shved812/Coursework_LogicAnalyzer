module divider #(parameter N = 20)
(
    clk,
    out
);
input wire clk;
output wire out;
assign out = rg[N-1];

reg [N-1:0] rg = 0;
always @(posedge clk)
begin
    rg <= rg + 1;
end

endmodule