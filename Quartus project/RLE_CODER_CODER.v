module RLE_CODER_CODER #(parameter N = 16, vol_N = 4, COUNT_N = 2048, adr = 0)
//N         - count bit in word
//vol_N     - count bit's for code number N-1
//COUNT_N   - count of all comb from N bit is equal 2^N
(
    rdclk,
    en,
    nreset,
    clk,
    
    bit_in,
    //goted,
    
    word_out,
    ready
);
    reg [4:0]self_adr = adr;
    input wire rdclk;
    input wire en;
    input wire nreset;
    input wire clk;
    
    input wire bit_in;
    //input wire goted;
    
    output reg [N-1:0] word_out;
    output reg ready;
    
    reg [1:0] in_reg;// input shift reg with 1 delay
    always @(posedge clk)
    begin
        if(!nreset) begin
            in_reg <= 0;
        end else begin
            if(en) begin
                in_reg[1] <= in_reg[0];
                in_reg[0] <= bit_in;
            end
        end
    end

    
    //declare registers
    reg [N-1:0] word_for_send = 0;   //word for send
    reg [vol_N-1:0] cnt_bit = 0;    //count of input bit
    reg catch = 0;                  //marker of start catch for not compressing word
    reg [N-1-vol_N-1:0] cnt_0 = 0;    //count of zero combination
    reg rd = 0;
    always @(posedge clk)
    begin
        if(!nreset)
        begin
            word_out <= 0;
            word_for_send <= 0;
            cnt_bit <= 0;
            catch <= 0;
            cnt_0 <= 0;
            rd <= 0;
        end else begin
            if(en) begin
                if(rd)begin
                    rd <= 0;
                end
                if(catch == 1)begin
                    //if(cnt_bit < N-2)begin
					if(cnt_bit < N-2-4)begin
                        cnt_bit <= cnt_bit + 1;
                        cnt_0 <= 0;
                        word_for_send <= {1'b1, self_adr[3:0], in_reg[1], word_for_send[N-2-4:1]};
                    end else begin
                        cnt_bit <= 0;
                        cnt_0 <= 0;
                        //word_for_send <= {1'b1, in_reg[1], word_for_send[N-2:1]};
                        //send_word(word_for_send);
                        word_out <= {1'b1, self_adr[3:0], in_reg[1], word_for_send[N-2-4:1]};//word_for_send;
                        rd <= 1;
                        if(in_reg[0] == 1)begin
                            catch <= 1;
                        end else begin
                            catch <= 0;
                        end
                    end               
                end else begin
                    if(in_reg[0] == 1)begin
                        catch <= 1;
                        //if(cnt_0 > N - 3)begin
						if(cnt_0 > N - 3 -4)begin
                            if(cnt_0 < COUNT_N - 1)begin
                                cnt_0 <= 0;
                                //word_for_send <= {1'b0, 4'b1111, cnt_0+1};
                                //send_word(word_for_send);
                                word_out <= {1'b0, self_adr[3:0], cnt_0}/* + 1*/;
                                rd <= 1;
                            end else begin
                                cnt_0 <= 0;
                                cnt_bit <= cnt_0 + 1;
                                word_for_send <= 0;
                                //send_word({0, adr, cnt_0 + 1});
                                word_out <= {1'b0, self_adr[3:0], cnt_0}/* + 1*/;
                                rd <= 1;
                            end
                        end else begin
                            cnt_0 <= 0;
                            cnt_bit <= cnt_0 + 1;
                            word_for_send <= 0;
                        end
                    end else begin
                        if(cnt_0 < COUNT_N - 1)begin
                            cnt_0 <= cnt_0 + 1;
                        end else begin
                            cnt_0 <= 0;
                            word_for_send <= { 1'b0, self_adr[3:0], cnt_0}/* + 1*/;
                            //send_word(word_for_send);
                            word_out <= { 1'b0, self_adr[3:0], cnt_0}/* + 1*/;
                            rd <= 1;
                        end
                    end
                end
                    
            end
        end
    end
    
    reg cnt_ready = 0;
    reg sended = 0;
    always @(posedge rdclk)
    begin
        if(!nreset)begin
            sended <= 0;
            ready <= 0;
            cnt_ready = 0;
        end else begin
            if(en)begin
                if( rd == 1 && sended == 0 )begin
                    ready <= 1;
                    sended <= cnt_ready;
                    cnt_ready <= cnt_ready + 1;
                end else begin
                    if(rd == 1 && sended == 1)begin
                        ready <= 0;
                    end else begin
                        if(rd == 0 && sended == 1)begin
                            sended <= 0;
                        end
                    end
                end
            end
        end
    end

endmodule