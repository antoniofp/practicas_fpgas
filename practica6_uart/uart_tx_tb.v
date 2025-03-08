module uart_tx_tb();
	// Señales de prueba
	reg [7:0] data = 8'haa;
	reg send_data = 0;
	reg clk = 0;
	reg rst = 1;
	wire serial_out;  
	
uart_tx #(
	.BAUDRATE(921600 )          // shit ton of speed
) mi_uart (
	.data(data),
	.send_data(send_data),
	.clk(clk),
	.rst(rst),
	.serial_out(serial_out)
);

	// Generación de reloj (50MHz -> periodo de 20ns)
	always #10 clk = ~clk;  // Esto es más simple que utilizar <=

	// Secuencia de prueba
	initial begin
		// Aplicamos reset
		rst = 1;  
		#100;     
		rst = 0;  
		
		#100;     // Esperamos un poco antes de enviar datos
		
		// Enviamos datos
		send_data = 1;
		#20;      // Mantenemos send_data por un ciclo de reloj
		send_data = 0;
		
		// Esperamos a que termine la transmisión
		// Con baudrate=115200 y reloj de 50MHz, cada bit toma ~434 ciclos
		// Una transmisión completa necesita ~11 bits de tiempo
		#100000;   
		
		$stop;
	end
endmodule