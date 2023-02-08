module cutter #(parameter M =16, N=8, COUNT_WORD = 16, COUNT_NEXT_SHIFT_REG = 8,COUNT_QUEUE = 6)
(
    nreset,
    en,
    rdclk,
    word_in,
    ready_in,
    get,
    
    byte_out,
    ready,
    errore_overflow
);

input wire nreset;
input wire en;
input wire rdclk;
input wire [M-1:0] word_in;
input wire ready_in;
input wire get;

output reg errore_overflow;
output reg [N-1:0] byte_out = 0;
output reg ready = 0;

reg [1:0] ready_in_reg = 0;
always @(posedge rdclk)
begin
    ready_in_reg <= {ready_in, ready_in_reg[1]};
end

reg [COUNT_QUEUE-1:0]queue_cnt;
reg [N-1:0] queue [COUNT_WORD*2+COUNT_NEXT_SHIFT_REG-1:0];//memory
reg [COUNT_QUEUE-1:0] i;
always @(posedge rdclk)
begin
    if(!nreset)begin
        //errore_overflow<=0;
        queue_cnt <= 0;
        for(i=0; i< COUNT_WORD*2+COUNT_NEXT_SHIFT_REG; i=i+1)begin
            queue[i] <= 0;
        end
    end else begin
        if(en)begin
            if(ready == 1)begin
                queue_cnt <= queue_cnt - 1;
            end else begin
                if((ready_in_reg[1] == 1) && (ready_in_reg[0] == 0))begin
                    queue_cnt <= queue_cnt + 2;
                    for(i=COUNT_WORD*2+COUNT_NEXT_SHIFT_REG-1;i>1;i=i-2)begin
                        if(i==3)begin
                            queue[0] <= word_in[M-1:M/2];
                            queue[1] <= word_in[M/2-1:0];
                        end
                        queue[i] <= queue[i-2];
                        queue[i-1] <= queue[i-3];
                    end
                end            
            end
        end
    end
end

always @(posedge rdclk)
begin
    if(!nreset)begin
        ready <= 0;
        byte_out <= 0;
    end else begin
        if(en)begin
            if(ready == 1)begin
                ready <= 0;
            end else begin
                if(get)begin
                    byte_out <= queue[queue_cnt-1];
                    ready <= 1;
                end
            end
        end
    end
    
end




endmodule