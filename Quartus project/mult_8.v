module mult_8(
    input wire [7:0]in_1, in_2,
    input wire S,
    output reg [7:0]out
);

always @*
begin
    if(S==0)
        out <= in_1;
    else
        out <= in_2;
end

endmodule