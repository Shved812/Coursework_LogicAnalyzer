module register #(parameter SIZE = 8)
(
    q,
    d,
    en,
    nreset,
    prn,
    clk,
);
output reg [SIZE-1:0] q = 0;
input wire [SIZE-1:0] d;

input wire en;
input wire nreset;
input wire prn;
input wire clk;

always @(posedge clk)
begin
    if(!nreset)begin
        q <= 0;
    end else begin
        if(en)begin
            if(!prn)
                q <= ~0;
            else
                q <= d;
        end
    end
end


endmodule