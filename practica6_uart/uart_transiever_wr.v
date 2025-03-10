module uart_transiever_wr (
	// Pines físicos de la tarjeta DE10-Lite
	input MAX10_CLK1_50,        // Clock de 50MHz
	input [1:0] KEY,             // Botones (activos en bajo)
	input [9:0] SW,              // Switches 
	output [9:0] LEDR,           // LEDs
	output [6:0] HEX0, HEX1      // Displays de 7 segmentos
);

	// Simplemente conectamos los pines a las entradas/salidas del uart_transiever
	uart_transiever uart_inst (
		.clk(MAX10_CLK1_50),      // Reloj de sistema
		.rst(~KEY[0]),            // Usamos KEY0 como reset (activo en bajo, lo invertimos)
		.data(SW[7:0]),           // Los 8 primeros switches para los datos
		.send_data(~KEY[1]),      // KEY1 para enviar datos (activo en bajo, invertimos)
		.data_valid(LEDR[0]),     // LED0 muestra si los datos son válidos
		.first_display(HEX1),     // El primer display en HEX1 (nibble alto)
		.second_display(HEX0)     // El segundo display en HEX0 (nibble bajo)
	);
	
	// Apagamos el resto de LEDs
	assign LEDR[9:1] = 9'b0;
	
endmodule