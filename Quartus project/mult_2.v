module mult_2(
    input wire in_1, in_2, S,
    output reg out
);

always @*
begin
    if(S==0)
        out <= in_1;
    else
        out <= in_2;
end

endmodule