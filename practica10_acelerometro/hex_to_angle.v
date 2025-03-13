module hex_to_angle (
	input [15:0] hex_value,     // Valor hexadecimal (solo usamos los 8 LSB)
	input wire is_negative,     // Indica si estamos en el primer rango (0-89.9°)
	output reg [11:0] angle_dec // Ángulo en décimas de grado (0-1800)
);
	// Extraemos solo los 9 bits menos significativos para el procesamiento
	wire [8:0] value_8bit = hex_value[8:0];
	
	// Cálculo del ángulo según el rango
	always @(*) begin
		if (is_negative) begin
			// Primer rango: 0x00->0, 0xFF->899 (0°-89.9°)
			// Nota: multiplicamos por 899 en vez de 900 para que el máximo sea exactamente 89.9°
			// Este mapeo da más precisión que el original
			angle_dec = (value_8bit * 899) / 255;
		end else begin
			// Segundo rango: 0x00->900, 0xFF->1800 (90°-180°)
			// Mapeamos proporcional y sumamos 900 para empezar desde 90.0°
			//si es positivo, ese angulo es en realidad 90°(900) + tu valor de angulo (0-255)/255 * 90°(900)
			angle_dec = 900 + ((value_8bit * 900) / 255);
		end
	end
endmodule