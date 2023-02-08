
module usart_rx(
	nreset,			// сигнал сброса (асинхронный, активный уровень 0)
	clk, 				// тактовая частота UART, д.б. в четыре раза больше скорости обмена по UART
	rx,				// входная линия UART
	rdclk,			// тактирование чтения результата приема (rxdata, ready)
	rxdata,			// принятые данные, значение валидно при ready==1
	ready,			// индикатор валидности данных rxdata (активный уровень 1)
	error,			// индикатор ошибки приема (активный уровень 1)
	busy,				// индикатор занятости модуля (идет прием, активный уровень 1)
	idle);			// индикатор свободной линии приемника (активный уровень 1)
	
input wire nreset;		// сигнал сброса (асинхронный, активный уровень 0)
input wire clk; 			// тактовая частота, д.б. в четыре раза больше скорости обмена по UART
input wire rx;				// входная линия UART
input wire rdclk;			// тактирование чтения результата приема
output wire[7:0] rxdata;
output wire ready;
output error;
output busy;
output idle;


reg[2:0] done = 3'b000;            // Изменение сигнала завершения приема, тактируемое через rdclk

assign ready = (done[1] && !done[0]);

reg error = 1'b0;                  // Признак наличия ошибки приема

wire fastsync = (error && rx);     // Сигнал сброса логики приемника для быстрой синхронизации при ошибке	
	
reg idle = 1'b1;	               // Признак свободной линии приемика

reg[9:0] d = 10'b1xxxxxxxx1;

wire[1:0] status = { d[9], d[0] }; // Статус приема. Завершение приема индицируется значением 2'b10

wire complete = (status == 2'b10);    // Признак завершения приема.

assign rxdata = d[8:1];            // Принятый байт данных

reg busy = 0;                      // Признак занятости модуля

reg[1:0] cnt;                      // Счетчик тактовых импульсов до	семплирования линии rx

always @(posedge clk or negedge nreset)
begin
    if(!nreset)
        rxreset();
    else
    if(fastsync)
        rxreset();
    else begin
        if(busy) begin
            cnt <= cnt +2'b1;
            if(cnt == 2'b0) begin
                d <= {rx, d[9:1]};
                if(d[1] == 1'b0) begin              //Стартовый бит попадает в последнюю позицию - прим завершён
                    busy <= 1'b0;
                    error <= !(rx == 1'b1);         //Проверяем стоповый бит
                end else begin
                    if(rx && d == 10'b1111111111) begin //Срабатывает после слишком короткого стартового бита
                        busy <= 0;
                        error <= 1;
                    end
                end
            end
        end else begin
            if(!error) begin
                if(rx == 1'b0) begin
                    busy <= 1'b1;
                    cnt <= 2'b0;
                    d <= 10'b1111111111;
                    idle <= 0;
                end else begin
                    idle <= 1;
                end
            end
        end
    end
end

task rxreset;
	begin
		// Сброс признака ошибки
		error <= 1'b0;
		// Установка сигнала свободной линии (!?)
		idle <= 1'b1;
		// Сброс признака занятости модуля
		busy <= 0;
		
		d <= 10'b1111111111;
	end
endtask

always @(negedge rdclk or negedge nreset)
begin
	if(!nreset)
		done <= 3'b000;
	else
		done <= { complete, done[2:1] };
end



endmodule