module CBUF #(parameter N = 8, M = 16, SIZE = 40, vol_SIZE = 6)
(
    nreset,
    en,
    rdclk,
    word_in,
    ready_in,
    get,
    
    byte_out,
    ready,
    CBUF_overflow,
    CBUF_empty,
    CBUF_full
);

input wire nreset;
input wire en;
input wire rdclk;
input wire [M-1:0] word_in;
input wire ready_in;
input wire get;

//output reg errore_overflow;
output reg [N-1:0] byte_out = 0;
output reg ready = 0;
output reg CBUF_empty = 1;
output reg CBUF_overflow = 0;
output reg CBUF_full = 0;

reg [1:0] ready_in_reg = 0;
always @(posedge rdclk)
begin
    if(!nreset)begin
        ready_in_reg <= 0;
    end else begin
        if(en)begin
            ready_in_reg <= {ready_in, ready_in_reg[1]};
        end
    end
end

reg [N-1:0] vec [SIZE-1:0];
reg [vol_SIZE:0] head = 0;
reg [vol_SIZE:0] tail = 0;

reg rg_newc_h = 0;
always @(posedge rdclk)
begin
    if(!nreset)begin
        head <= 0;
        //head <= 4;
        //vec[1] <= 8'hAB;
        //vec[2] <= 8'hAB;
        //vec[3] <= 8'hAB;
        //vec[4] <= 8'hAB;
        CBUF_overflow <= 0;
        rg_newc_h = 0;
    end else begin
        if(en)begin
            if(ready_in_reg[0]==0 && ready_in_reg[1]==1)begin
                if(!CBUF_overflow)begin
                    if(head == SIZE-1 -1)begin
                        if((head>=tail?(SIZE - head + tail):(tail-head))>1 || CBUF_empty)begin
                            head <= 0;
                            vec[SIZE-1] <= word_in[M-1:M/2];//[M/2-1:0];
                            vec[0] <= word_in[M/2-1:0];//[M-1:M/2];
                            rg_newc_h <= rg_newc_h + 1;
                        end else begin
                            CBUF_overflow <= 1;
                        end
                    end else begin
                        if(head == SIZE - 1)begin
                            if((head>=tail?(SIZE - head + tail):(tail-head))>1 || CBUF_empty)begin
                                head <= 2;
                                vec[0] <= word_in[M-1:M/2];//[M/2-1:0];
                                vec[1] <= word_in[M/2-1:0];//[M-1:M/2];
                                rg_newc_h <= rg_newc_h + 1;
                            end else begin
                                CBUF_overflow <= 1;
                            end
                        end else begin
                            if((head>=tail?(SIZE - head + tail):(tail-head))>1 || CBUF_empty)begin
                                head <= head + 2;
                                vec[head + 1] <= word_in[M-1:M/2];//[M/2-1:0];
                                vec[head + 2] <= word_in[M/2-1:0];//[M-1:M/2];
                            end else begin
                                CBUF_overflow <= 1;
                            end
                        end
                    end
                end
            end
        end
    end
end

//reg notready_cnt = 0;
reg ready_cnt = 0;
reg rg_newc_t = 0;
always @(posedge rdclk)
begin
    if(!nreset)begin
        tail <= 0;
        ready <= 0;
        rg_newc_t = 0;
        ready_cnt = 0;
        //notready_cnt = 0;
    end else begin
        if(en)begin
            //if(ready == 0 && notready_cnt == 0)begin
            //    notready_cnt <= notready_cnt + 1;
            //end else
            if(ready)begin
                //ready_cnt = ready_cnt + 1;
                //if(ready_cnt)begin
                    ready <= 0;
                    //notready_cnt <= notready_cnt + 1;
                //end
            end else begin
                if(get && !ready)begin
                    if(!CBUF_empty)begin
                    if(!(ready_in_reg[0]==0 && ready_in_reg[1]==1))begin
                        if(tail > SIZE-1-1)begin
                            tail <= 0;
                            byte_out <= vec[0];
                            ready <= 1;
                            rg_newc_t <= rg_newc_t + 1;
                        end else begin
                            tail <= tail + 1;
                            byte_out <= vec[tail+1];
                            ready <= 1;
                        end
                    end
                    end
                end
            end
        end
    end
end

always @(posedge rdclk)
begin
    if(!nreset)begin
        CBUF_empty = 1;
        CBUF_full = 0;
    end else begin
        if(en)begin
            if(rg_newc_h == rg_newc_t)begin
                CBUF_empty <= (head == tail);
                CBUF_full <= 0;
            end else begin
                CBUF_full <= (head == tail);
                CBUF_empty <= 0;
            end
        end
    end
end

endmodule