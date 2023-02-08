module priority_encoder #(parameter N = 16, M = 4)
(
    en,
    x,
    y
);
input wire en;
input wire [N-1:0]x;
output reg [M:0]y;
reg [M:0] i;

always @*
begin
    if(en) begin
        for( i = 1; i < N+1; i = i + 1)
        begin
            if(x == 0) begin
                y<=0;
            end else begin
                if(x[i-1] == 1)
                    y <= i;
            end
        end
    end
end


endmodule