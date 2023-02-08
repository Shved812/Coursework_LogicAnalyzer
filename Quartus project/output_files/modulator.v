module modulator #(parameter period=1, CODE = period*11, vol_CODE = 10)
(
    nreset,
    en,
    clk,
    out
);

input wire nreset;
input wire en;
input wire clk;
output reg out = 0;

reg [vol_CODE:0] T = CODE;
reg [vol_CODE:0] t = 10'd11;
reg [vol_CODE:0] cnt = 0;
always @(posedge clk)
begin
    if(!nreset)begin
        cnt <= 0;
        out <= 0;
    end else begin
        if(en)begin
            if((cnt == t) && (out == 0))begin
                cnt <= 0;
                out <= 1;
            end else begin
                if((cnt == T) && (out == 1))begin
                    cnt <= 0;
                    out <= 0;
                end else begin
                    cnt = cnt + 1;
                end
            end
        end
    end
end

endmodule