module angle_to_hex (
	input [7:0] angle, //angle 0 to 180°
	output [15:0] angle_bin, //angle in binary from 00 to FF, rest of bit are zeros
	output wire is_negative
);
	// Determina si estamos en el primer rango (0-89°) o segundo rango (90-180°)
	assign is_negative = (angle < 90);
	
	// Aquí guardaremos el valor mapeado final (0x00-0xFF)
	reg [7:0] valor_mapeado;
	
	always @(*) begin
		if (is_negative) begin
			// Para ángulos de 0° a 89°, escalamos de 0x00 a 0xFF
			// Ahora usamos 89 como denominador para que 0° -> 0x00 y 89° -> 0xFF exactamente
			valor_mapeado = (angle * 255) / 89;
		end else begin
			// Para ángulos de 90° a 180°, escalamos de 0x00 a 0xFF
			// Ahora restamos 90 para que 90° -> 0x00 y 180° -> (180 - 90=90)/90 *255 = 255=FF  -> 0xFF exactamente
			valor_mapeado = ((angle - 90) * 255) / 90;
		end
	end
	
	// Asignamos el resultado final con los 8 bits superiores como ceros
	assign angle_bin = {8'b0, valor_mapeado};
endmodule