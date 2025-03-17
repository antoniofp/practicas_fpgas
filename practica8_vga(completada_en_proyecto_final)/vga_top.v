module vga_top(
	// Entradas del sistema
	input clk, rst_a_p,
	// Salidas VGA
	output [3:0] VGA_R,        // Canal rojo VGA (4 bits)
	output [3:0] VGA_G,        // Canal verde VGA (4 bits) 
	output [3:0] VGA_B,        // Canal azul VGA (4 bits)
	output VGA_HS,             // Sincronización horizontal
	output VGA_VS             // Sincronización vertical
	
);

	// Señales internas
	wire clk_25;               // Reloj de 25MHz para VGA
	wire [2:0] pixel;          // Salida de píxel de tu módulo VGAdemo
	
	
	// para generar el reloj de 25MHz para VGA
	clk_div #(25_000_000) clk_div1 (clk, rst_a_p, clk_25);
	
	
	// Instancia de tu módulo VGAdemo
	VGAdemo vga_demo_inst(
		.clk_25(clk_25),
		.pixel(pixel),
		.hsync_out(VGA_HS),
		.vsync_out(VGA_VS)
	);
	
	// Mapeo de la salida de 3 bits a los canales RGB de 4 bits
	// Usa el valor de pixel para crear un patrón de colores
	// Aquí hay un mapeo simple, puedes personalizarlo
	assign VGA_R = {pixel[0], pixel[0], pixel[0], pixel[0]};  // Rojo cuando bit 0 está activo
	assign VGA_G = {pixel[1], pixel[1], pixel[1], pixel[1]};  // Verde cuando bit 1 está activo
	assign VGA_B = {pixel[2], pixel[2], pixel[2], pixel[2]};  // Azul cuando bit 2 está activo
	
endmodule