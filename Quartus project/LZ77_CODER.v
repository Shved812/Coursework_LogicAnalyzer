module LZ77_CODER #(parameter SIZE_CNT = 3, SIZE_POS = 5, N = 8, COUNT_POS = 31, COUNT_CNT = 7)//, LQueue = 24, vol_Queue = 5)
(
    en,
    nreset,
    rdclk,
    ready_in,
    ready,
    get,
    
    byte_out,
    byte_in

);


input wire en;
input wire nreset;
input wire rdclk;
input wire ready_in;
input wire [N-1:0] byte_in;


output reg ready;
output reg [N-1:0] byte_out;

reg [N-1:0] next_window [COUNT_CNT-1:0];
reg [SIZE_CNT-1:0] next_window_cnt = 0;
reg [SIZE_CNT:0] i = 0;
reg [1:0] ready_in_reg = 0;
reg [1:0] sended = 0;
always @(posedge rdclk)
begin
    //if(!nreset)begin
    //    ready_in_reg <= 0;
    //end else begin
    //    if(en)begin
            ready_in_reg <= { ready_in, ready_in_reg[1]};
    //    end
    //end
end

always @(posedge rdclk)
begin
    if(!nreset)begin
        for(i=0; i<COUNT_CNT; i=i+1)begin
            next_window[i] <= 0;
        end
        next_window_cnt <= 0;
        i<=0;
        j<=0;
        sended<=0;
    end else begin
        if(en)begin
            if( (ready_in_reg[1] == 1) && (ready_in_reg[0] == 0) && (send == 0)) begin  //if reed_in begin
                next_window_cnt <= next_window_cnt + 1;
                for(i=COUNT_CNT-1; i>0; i=i-1)begin
                        if(i==1)
                            next_window[0] <= byte_in;
                        next_window[i] <= next_window[i-1];
                end
            end else begin
                if(ready)begin
                    ready <= 0;
                end else begin
                    if(send)begin
                        if(mem_cnt == 0) begin  //not finded
                            if(sended == 2'b00)begin
                                sended <= 2'b01;
                            end else begin
                                if(sended == 2'b01)begin    //send zeros
                                    //send( 8'b0000_0000 );
                                    byte_out <= ( 8'b0000_0000 );
                                    ready <= 1;
                                    sended <= 2'b10;
                                    //shift window;
                                end else begin
                                    if((sended == 2'b10) && shifted)begin    //send not finded byte
                                        //send( next_window[COUNT_CNT - 1] );
                                        byte_out <= ( next_window[COUNT_CNT - 1] );
                                        ready <= 1;
                                        next_window_cnt <= next_window_cnt - 1;
                                        sended <= 2'b11;
                                    end
                                end
                            end
                        end else begin
                            if(sended == 2'b00)begin
                                sended <= 2'b01;
                            end else begin
                                if(sended == 2'b01)begin    //send finded sequence
                                    //send( {mem_cnt, mem_pos} );
                                    byte_out <= ( {mem_cnt, mem_pos} );
                                    ready <= 1;
                                    sended <= 2'b10;
                                    //shift window; 
                                end else begin
                                    if((sended == 2'b10) && shifted)begin
                                        next_window_cnt <= next_window_cnt - mem_cnt;
                                        sended <= 2'b11;
                                    end
                                end
                            end
                        end
                    end else begin
                        sended <= 2'b00;
                    end
                end
            end
        end
    end
end

output wire get;
assign get = (next_window_cnt < COUNT_CNT);
assign next_window_full = next_window_cnt == COUNT_CNT;

reg [SIZE_POS-1:0]window_cnt = 0;
reg [N-1:0] window [COUNT_POS-1:0];

reg [SIZE_POS-1:0]current_pos = 1;      //pos in window
reg [SIZE_CNT-1:0]compair_cnt = 0;      //cnt of curren compair

reg [SIZE_POS-1:0]mem_pos = 0;          //mem of pos in window
reg [SIZE_CNT-1:0]mem_cnt= 0;           //mem of cnt compair

reg [SIZE_POS:0] j = 0;
reg [SIZE_POS:0] k = 0;
reg send = 0;
reg shifted = 0;
always @(posedge rdclk)
begin
    if(!nreset)begin
        for(j=0; j<COUNT_POS-1; j=j+1)begin
            window[j] <= 0;
        end
        window_cnt <= 0;
        current_pos <= 0;
        compair_cnt <= 0;
        mem_pos <= 0;
        mem_cnt <= 0;
        send <= 0;
        shifted <= 0;
    end else begin
        if(en)begin
                if(send) begin
                    if((sended == 2'b01) && (shifted == 0))begin    //can use without for, but rdclk must rise in COUNT_CNT*COUNT_POS times
                        //shift window
                        shifted <= 1;
                        if(mem_cnt == 0)begin
                            for(j=COUNT_POS-1; j>0; j=j-1)begin
                                if(j == 1)
                                    window[0] <= next_window[COUNT_CNT-1];
                                window[j] <= window[j-1];
                            end
                            if (window_cnt < COUNT_POS-1)
                                window_cnt <= window_cnt + 1;
                        end else begin
                            for(k=COUNT_CNT; k>0; k=k-1)begin
                                if(k > next_window_cnt - mem_cnt)begin
                                    for(j=COUNT_POS-1; j>0; j=j-1)begin
                                        if(j == 1)
                                            window[0] <= next_window[k-1];
                                        window[j] <= window[j-1];
                                    end
                                    if (window_cnt < COUNT_POS-1)
                                        window_cnt <= window_cnt + 1;
                                end
                            end
                        end
                    end else begin
                        if(sended == 2'b11)begin
                            shifted <= 0;
                            send <= 0;
                            mem_cnt <= 0;
                            mem_pos <= 0;
                            current_pos <= 1;
                            compair_cnt <= 0;
                        end
                    end
                end else begin
                    if(next_window_full)begin
                        if(window_cnt+1-current_pos == 0)begin  //if current_pos have gone beyond the borders stop, send
                            compair_cnt <= 0;
                            current_pos <= 1;
                            send<=1;                 
                        end else begin
                            if(next_window[COUNT_CNT-1-compair_cnt] == window[current_pos-1-compair_cnt])begin  //if elements are equal
                                if(compair_cnt == COUNT_CNT - 1)begin   //if it max lenght sequence save, stop, send
                                    mem_cnt <= compair_cnt + 1;
                                    compair_cnt <= 0;
                                    mem_pos <= current_pos;
                                    current_pos <= 1;
                                    send<=1;
                                    //clear();
                                end else begin
                                    if(current_pos-1-compair_cnt == 0)begin  //If we have gone beyond the borders step next
                                        compair_cnt <= 0;
                                        current_pos <= current_pos + 1;
                                        if(compair_cnt + 1 > mem_cnt)begin  //if lenght sequence more save
                                            mem_cnt <= compair_cnt + 1;
                                            mem_pos <= current_pos;
                                        end                                    
                                    end else begin
                                        compair_cnt <= compair_cnt + 1;
                                    end
                                end
                            end else begin
                                compair_cnt <= 0;
                                current_pos <= current_pos + 1;
                                if(compair_cnt > mem_cnt)begin  //if lenght sequence more save
                                    mem_cnt <= compair_cnt;
                                    mem_pos <= current_pos;
                                end
                            end
                        end
                    end
                end
        end
    end
end

endmodule