module uart_transiever_wr (
	input MAX10_CLK1_50,        
	input [1:0] KEY,             
	input [9:0] SW,               
	output [9:0] LEDR,           
	output [6:0] HEX0, HEX1     
);

	uart_transiever uart_inst (
		.clk(MAX10_CLK1_50),      // Reloj de sistema
		.rst(~KEY[0]),            // Usamos KEY0 como reset (activo en bajo, lo invertimos)
		.data(SW[7:0]),           // Los 8 primeros switches para los datos
		.send_data(~KEY[1]),      // KEY1 para enviar datos (activo en bajo, invertimos)
		.data_valid(LEDR[0]),     // LED0 muestra si los datos son válidos
		.first_display(HEX1),     // El primer display en HEX1 (nibble alto)
		.second_display(HEX0)     // El segundo display en HEX0 (nibble bajo)
	);
	
	assign LEDR[9:1] = 9'b0;
	
endmodule