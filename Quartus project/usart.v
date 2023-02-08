module usart(

    //usart_rx_myself:
	data_rx,
	ready,
	error,
	busy_rx,
	idle_rx,
    rx,
    
    //usart_tx_myself:
	data_tx,
	write,
    idle_tx,
	fetch,
    tx,

    //all:
    nreset,
    clk,
    rdclk,
    
);

	output wire [7:0]data_rx;
	output wire ready;
	output wire error;
	output wire busy_rx;
	output wire idle_rx;
    input wire rx;
    
	input wire [7:0]data_tx;
	input wire write;
	output wire idle_tx;
	output wire fetch;
    output wire tx;
    
    input wire nreset;
    input wire clk;
    input wire rdclk;
    
    
    usart_rx USART_rx_1
    (
    .nreset(nreset),	
	.clk(clk), 		
	.rx(rx),			
	.rdclk(rdclk),	
	.rxdata(data_rx),		
	.ready(ready),	
	.error(error),	
	.busy(busy_rx),
	.idle(idle_rx)
    );
    
    usart_tx USART_tx_1(
	.nreset(nreset),		
	.clk(clk),		
	.rdclk(rdclk),		
	.txdata(data_tx),		
	.write(write),		
	.idle(idle_tx),		
	.fetch(fetch),		
	.tx(tx)
);
    
endmodule