module  VGADemo (
   input clk, 
	input [7:0] X_VALUE, Y_VALUE, Z_VALUE,
   output reg[2:0] pixel,
   output hsync_out,
   output vsync_out
);
	wire inDisplayArea;
	wire [9:0] CounterX, CounterY;
	wire clk_25;
    
	clkdiv #(25_000_000)CLK_25MHZ(clk, 1, clk_25);
	
	hvsync_generator HVSYNC(
		.clk(clk_25),
		.vga_h_sync(hsync_out),
		.vga_v_sync(vsync_out),
		.CounterX(CounterX),
		.CounterY(CounterY),
		.inDisplayArea(inDisplayArea)
	);
	
// Funciones para dibujar caracteres
function [7:0] get_font_data;
	input [7:0] ascii;
	input [2:0] row;
	begin
		case (ascii)
			"X": 
				case (row)
					0: get_font_data = 8'b1000_0001;
					1: get_font_data = 8'b0100_0010;
					2: get_font_data = 8'b0010_0100;
					3: get_font_data = 8'b0001_1000;
					4: get_font_data = 8'b0010_0100;
					5: get_font_data = 8'b0100_0010;
					6: get_font_data = 8'b1000_0001;
					7: get_font_data = 8'b0000_0000;
				endcase
			
			"Y": 
				case (row)
					0: get_font_data = 8'b1000_0001;
					1: get_font_data = 8'b0100_0010;
					2: get_font_data = 8'b0010_0100;
					3: get_font_data = 8'b0001_1000;
					4: get_font_data = 8'b0001_1000;
					5: get_font_data = 8'b0001_1000;
					6: get_font_data = 8'b0001_1000;
					7: get_font_data = 8'b0000_0000;
				endcase
				
			"Z": 
				case (row)
					0: get_font_data = 8'b1111_1111;
					1: get_font_data = 8'b0000_0010;
					2: get_font_data = 8'b0000_0100;
					3: get_font_data = 8'b0000_1000;
					4: get_font_data = 8'b0001_0000;
					5: get_font_data = 8'b0010_0000;
					6: get_font_data = 8'b1111_1111;
					7: get_font_data = 8'b0000_0000;
				endcase
				
			":": 
				case (row)
					0: get_font_data = 8'b0000_0000;
					1: get_font_data = 8'b0001_1000;
					2: get_font_data = 8'b0001_1000;
					3: get_font_data = 8'b0000_0000;
					4: get_font_data = 8'b0001_1000;
					5: get_font_data = 8'b0001_1000;
					6: get_font_data = 8'b0000_0000;
					7: get_font_data = 8'b0000_0000;
				endcase
			
			"0": 
				case (row)
					0: get_font_data = 8'b0011_1100;
					1: get_font_data = 8'b0100_0110;
					2: get_font_data = 8'b0100_1010;
					3: get_font_data = 8'b0101_0010;
					4: get_font_data = 8'b0110_0010;
					5: get_font_data = 8'b0100_0010;
					6: get_font_data = 8'b0011_1100;
					7: get_font_data = 8'b0000_0000;
				endcase
				
			"1": 
				case (row)
					0: get_font_data = 8'b0001_1000;
					1: get_font_data = 8'b0010_1000;
					2: get_font_data = 8'b0100_1000;
					3: get_font_data = 8'b0000_1000;
					4: get_font_data = 8'b0000_1000;
					5: get_font_data = 8'b0000_1000;
					6: get_font_data = 8'b0111_1110;
					7: get_font_data = 8'b0000_0000;
				endcase
				
			"2": 
				case (row)
					0: get_font_data = 8'b0011_1100;
					1: get_font_data = 8'b0100_0010;
					2: get_font_data = 8'b0000_0010;
					3: get_font_data = 8'b0000_1100;
					4: get_font_data = 8'b0011_0000;
					5: get_font_data = 8'b0100_0000;
					6: get_font_data = 8'b0111_1110;
					7: get_font_data = 8'b0000_0000;
				endcase
				
			"3": 
				case (row)
					0: get_font_data = 8'b0011_1100;
					1: get_font_data = 8'b0100_0010;
					2: get_font_data = 8'b0000_0010;
					3: get_font_data = 8'b0001_1100;
					4: get_font_data = 8'b0000_0010;
					5: get_font_data = 8'b0100_0010;
					6: get_font_data = 8'b0011_1100;
					7: get_font_data = 8'b0000_0000;
				endcase
				
			"4": 
				case (row)
					0: get_font_data = 8'b0000_0100;
					1: get_font_data = 8'b0000_1100;
					2: get_font_data = 8'b0001_0100;
					3: get_font_data = 8'b0010_0100;
					4: get_font_data = 8'b0111_1110;
					5: get_font_data = 8'b0000_0100;
					6: get_font_data = 8'b0000_0100;
					7: get_font_data = 8'b0000_0000;
				endcase
				
			"5": 
				case (row)
					0: get_font_data = 8'b0111_1110;
					1: get_font_data = 8'b0100_0000;
					2: get_font_data = 8'b0111_1100;
					3: get_font_data = 8'b0000_0010;
					4: get_font_data = 8'b0000_0010;
					5: get_font_data = 8'b0100_0010;
					6: get_font_data = 8'b0011_1100;
					7: get_font_data = 8'b0000_0000;
				endcase
				
			"6": 
				case (row)
					0: get_font_data = 8'b0011_1100;
					1: get_font_data = 8'b0100_0000;
					2: get_font_data = 8'b0111_1100;
					3: get_font_data = 8'b0100_0010;
					4: get_font_data = 8'b0100_0010;
					5: get_font_data = 8'b0100_0010;
					6: get_font_data = 8'b0011_1100;
					7: get_font_data = 8'b0000_0000;
				endcase
				
			"7": 
				case (row)
					0: get_font_data = 8'b0111_1110;
					1: get_font_data = 8'b0000_0010;
					2: get_font_data = 8'b0000_0100;
					3: get_font_data = 8'b0000_1000;
					4: get_font_data = 8'b0001_0000;
					5: get_font_data = 8'b0010_0000;
					6: get_font_data = 8'b0010_0000;
					7: get_font_data = 8'b0000_0000;
				endcase
				
			"8": 
				case (row)
					0: get_font_data = 8'b0011_1100;
					1: get_font_data = 8'b0100_0010;
					2: get_font_data = 8'b0100_0010;
					3: get_font_data = 8'b0011_1100;
					4: get_font_data = 8'b0100_0010;
					5: get_font_data = 8'b0100_0010;
					6: get_font_data = 8'b0011_1100;
					7: get_font_data = 8'b0000_0000;
				endcase
				
			"9": 
				case (row)
					0: get_font_data = 8'b0011_1100;
					1: get_font_data = 8'b0100_0010;
					2: get_font_data = 8'b0100_0010;
					3: get_font_data = 8'b0011_1110;
					4: get_font_data = 8'b0000_0010;
					5: get_font_data = 8'b0000_0010;
					6: get_font_data = 8'b0011_1100;
					7: get_font_data = 8'b0000_0000;
				endcase
				
			default: 
				get_font_data = 8'b0000_0000;
				
		endcase
	end
endfunction
    
// Función para verificar si el pixel actual está dentro de un carácter
function is_in_character;
	input [9:0] chx, chy;       // Posición base del carácter
	input [7:0] character;      // Valor ASCII del carácter
	input [9:0] cx, cy;         // Contador actual X e Y
	begin
		if (cx >= chx && cx < chx + 8 && cy >= chy && cy < chy + 8) 
			begin
				// El píxel está dentro del área del carácter
				reg [2:0] row;
				reg [2:0] col;
				reg [7:0] font_row;
				 
				row = cy - chy;  // Fila dentro del carácter
				col = cx - chx;  // Columna dentro del carácter
				  
				// Obtener los datos de la fuente para este carácter y fila
				font_row = get_font_data(character, row);
				  
				// Verificar si este píxel debe estar activado
				is_in_character = font_row[7-col];
			end 
		else
			is_in_character = 0;
	end
endfunction
 
function [7:0] get_digit;
	input [7:0] value;
	input [1:0] position; // 0=unidades, 1=decenas, 2=centenas
	begin
		case(position)
         0: get_digit = 8'd48 + (value % 10);                  // Unidades
         1: get_digit = 8'd48 + ((value / 10) % 10);           // Decenas
			2: get_digit = 8'd48 + ((value / 100) % 10);          // Centenas
			default: get_digit = 8'd32; // Espacio en blanco para posiciones no válidas
		endcase
	end
endfunction

// Función para determinar si un dígito debe mostrarse (evitar ceros a la izquierda)
function show_digit;
	input [7:0] value;
	input [1:0] position; // 0=unidades, 1=decenas, 2=centenas
	begin
		if (position == 0) 
			show_digit = 1; // Siempre mostrar las unidades
		else if (position == 1 && value >= 10)
			show_digit = 1; // Mostrar decenas si el valor es >= 10
		else if (position == 2 && value >= 100)
			show_digit = 1; // Mostrar centenas si el valor es >= 100
		else
			show_digit = 0; // No mostrar
	end
endfunction
 
// Posiciones en pantalla
localparam X_POS_X = 100;
localparam X_POS_Y = 100;
localparam Y_POS_X = 100;
localparam Y_POS_Y = 120;
localparam Z_POS_X = 100;
localparam Z_POS_Y = 140;

// Espaciado entre caracteres
localparam CHAR_SPACING = 8;
 
wire is_text_pixel = 
	// Letra X
	is_in_character(X_POS_X, X_POS_Y, "X", CounterX, CounterY) || 
	// Dos puntos después de X
	is_in_character(X_POS_X + 10, X_POS_Y, ":", CounterX, CounterY) ||
	
	// Valor de X (todos los dígitos, según corresponda)
	(show_digit(X_VALUE, 2) && is_in_character(X_POS_X + 20, X_POS_Y, get_digit(X_VALUE, 2), CounterX, CounterY)) ||
	(show_digit(X_VALUE, 1) && is_in_character(X_POS_X + 28, X_POS_Y, get_digit(X_VALUE, 1), CounterX, CounterY)) ||
	(is_in_character(X_POS_X + 36, X_POS_Y, get_digit(X_VALUE, 0), CounterX, CounterY)) ||
		
	// Letra Y
	is_in_character(Y_POS_X, Y_POS_Y, "Y", CounterX, CounterY) ||
	// Dos puntos después de Y
	is_in_character(Y_POS_X + 10, Y_POS_Y, ":", CounterX, CounterY) ||
	
	// Valor de Y (todos los dígitos, según corresponda)
	(show_digit(Y_VALUE, 2) && is_in_character(Y_POS_X + 20, Y_POS_Y, get_digit(Y_VALUE, 2), CounterX, CounterY)) ||
	(show_digit(Y_VALUE, 1) && is_in_character(Y_POS_X + 28, Y_POS_Y, get_digit(Y_VALUE, 1), CounterX, CounterY)) ||
	(is_in_character(Y_POS_X + 36, Y_POS_Y, get_digit(Y_VALUE, 0), CounterX, CounterY)) ||
	
	// Letra Z
	is_in_character(Z_POS_X, Z_POS_Y, "Z", CounterX, CounterY) ||
	// Dos puntos después de Z
	is_in_character(Z_POS_X + 10, Z_POS_Y, ":", CounterX, CounterY) ||
	
	// Valor de Z (todos los dígitos, según corresponda)
	(show_digit(Z_VALUE, 2) && is_in_character(Z_POS_X + 20, Z_POS_Y, get_digit(Z_VALUE, 2), CounterX, CounterY)) ||
	(show_digit(Z_VALUE, 1) && is_in_character(Z_POS_X + 28, Z_POS_Y, get_digit(Z_VALUE, 1), CounterX, CounterY)) ||
	(is_in_character(Z_POS_X + 36, Z_POS_Y, get_digit(Z_VALUE, 0), CounterX, CounterY));

always @(posedge clk_25)
begin
	if (inDisplayArea) 
		begin
			if (is_text_pixel)
				pixel <= 3'b111;
			else
				pixel <= 3'b000;
		end
	else
		pixel <= 3'b000;
end
endmodule