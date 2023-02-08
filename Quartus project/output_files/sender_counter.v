module sender_counter (
    nreset,
    en,
    rdclk,
    ready_in,
    word_out,
    ready
);
input wire nreset;
input wire en;
input wire rdclk;
input wire ready_in;
output reg [15:0] word_out = 0;
output reg ready = 0;

reg [1:0] ready_in_reg = 0;
always @(posedge rdclk)
begin
    if(!nreset)begin
        ready_in_reg <= 0;
    end else begin
        if(en)begin
            ready_in_reg <= {ready_in_reg[0], ready_in};
        end
    end
end

reg send = 0;
reg [7:0]cnt = 0;
always @(posedge rdclk)
begin
    if(!nreset)begin
        cnt <= 0;
        send <= 0;
    end else begin
        if(en)begin
            if(send)begin
                send <= 0;
            end else begin
                if((ready_in_reg[0] == 0) && (ready_in_reg[1] == 1))begin
                    send <= 1;
                    cnt <= cnt + 2;
                end
            end
        end
    end
end

always @(posedge rdclk)
begin
    if(!nreset)begin
        word_out <= 0;
        ready <= 0;
    end else begin
        if(en)begin
            if(ready)begin
                ready <= 0;
            end else begin
                if(send)begin
                    word_out [15:8] <= cnt;
                    word_out [7:0]  <= cnt+1;
                    ready <= 1;
                end
            end
        end
    end
end

endmodule