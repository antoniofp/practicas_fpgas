module angle_pwm #(
	parameter TIME_MS = 500,                
	parameter MEMORY_SIZE = 128,           
	parameter CLOCK_FREQ_HZ = 50000000,    
	parameter MEMORY_FILE = "servo_angles.hex" 
)(
	input wire clk,               
	input wire rst_a_n,           
	input wire start_signal,      // señal de arranque (secuencia)
	
	// Salidas para los tres servos, formato que uso en pwm_controller
	output wire [15:0] servo1_angle,
	output wire servo1_is_negative,
	output wire [15:0] servo2_angle,
	output wire servo2_is_negative,
	output wire [15:0] servo3_angle,
	output wire servo3_is_negative
);

	localparam IDLE = 2'b00;    // Esperando a que le demos start
	localparam LOAD = 2'b01;    // Leyendo memoria
	localparam WAIT = 2'b10;    // Esperando el tiempo configurado
	
	// Cálculos para el timer
	localparam TICKS_PER_MS = CLOCK_FREQ_HZ / 1000;
	localparam WAIT_TICKS = TIME_MS * TICKS_PER_MS;
	
	// Registros de la máquina de estados
	reg [1:0] state;
	
	// Memoria para los ángulos - tres por línea, uno para cada servo
	reg [7:0] angle_memory [0:MEMORY_SIZE*3-1];  
	reg [$clog2(MEMORY_SIZE)-1:0] addr_counter;  // Para recorrer la memoria
	
	// Contador para esperar el tiempo configurado
	reg [31:0] wait_counter;
	
	// Registros para guardar los ángulos actuales
	reg [7:0] servo1_angle_reg;
	reg [7:0] servo2_angle_reg;
	reg [7:0] servo3_angle_reg;
	
	// Conversores de ángulo a formato hexadecimal
	angle_to_hex servo1_converter(
		.angle(servo1_angle_reg),
		.angle_bin(servo1_angle),
		.is_negative(servo1_is_negative)
	);
	
	angle_to_hex servo2_converter(
		.angle(servo2_angle_reg),
		.angle_bin(servo2_angle),
		.is_negative(servo2_is_negative)
	);
	
	angle_to_hex servo3_converter(
		.angle(servo3_angle_reg),
		.angle_bin(servo3_angle),
		.is_negative(servo3_is_negative)
	);
	
	// load memoria
	initial begin
		$readmemh(MEMORY_FILE, angle_memory);
	end
	
	// Máquina de estados 
	always @(posedge clk or negedge rst_a_n) begin
		if (!rst_a_n) begin
			// reiniciamos todos los registros
			state <= IDLE;
			addr_counter <= 0;
			wait_counter <= 0;
			servo1_angle_reg <= 0;
			servo2_angle_reg <= 0;
			servo3_angle_reg <= 0;
		end 
		else begin
			// lógica de la máquina de estados
			case (state)
				IDLE: begin
					// Esperamos la señal de inicio
					if (start_signal)
						state <= LOAD;
				end
				
				LOAD: begin
					// Leemos los tres ángulos de la memoria, cada 3 posiciones es el mismo ángulo, por eso multiplico el address counter por 3
					//los valores que se cargan se outputean
					servo1_angle_reg <= angle_memory[addr_counter*3];
					servo2_angle_reg <= angle_memory[addr_counter*3 + 1];
					servo3_angle_reg <= angle_memory[addr_counter*3 + 2];
					
					// se leen y se va a esperar
					state <= WAIT;
					wait_counter <= 0;  // Reiniciamos el contador
				end
				
				WAIT: begin
					// por defecto se aumenta el contador de espera
					wait_counter <= wait_counter + 1;
					
					// Ssi llegamos al parametro calculado para durar los ms a partir de los ticks 
					if (wait_counter >= WAIT_TICKS - 1) begin
						// Incrementamos el contador de dirección o volvemos al inicio
						if (addr_counter >= MEMORY_SIZE - 1)
							addr_counter <= 0;  // Volvemos a empezar la secuencia
						else
							addr_counter <= addr_counter + 1;  
							
						// Vamos a cargar la siguiente posición
						state <= LOAD;
					end
				end
				
				default: state <= IDLE;  
			endcase
		end
	end

endmodule