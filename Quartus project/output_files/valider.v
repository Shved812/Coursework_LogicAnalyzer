module valider (
    nreset,
    en,
    rdclk,
    byte,
    ready,
    switch
);
input wire nreset;
input wire en;
input wire rdclk;
input wire [7:0]byte;
input wire ready;

reg [7:0] value = 8'hAB;

output reg switch = 0;

reg [1:0]ready_reg = 0;
always @(posedge rdclk)
begin
    if(!nreset)begin
        ready_reg <= 0;
    end else begin
        if(en)begin
            ready_reg <= {ready, ready_reg[1]};
        end
    end
end

always @(posedge rdclk)
begin
    if(!nreset)begin
        switch <= 0;
    end else begin
        if(en)begin
            if(ready_reg[0]==0 && ready_reg[1]==1)begin
                if(byte == value)begin
                    switch <= switch^1;
                end
            end
        end
    end
end

endmodule