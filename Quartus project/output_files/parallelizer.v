module parallelizer #(parameter N = 16)
(
    in,
    out
);
input wire in;
output wire [N-1:0] out;

assign out = {N{in}};

endmodule
