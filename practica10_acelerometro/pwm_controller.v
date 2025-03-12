module pwm_controller (
	input rst_a_n, clk,
	output reg pwm_signal,
	input [15:0] absolute_angle,
	input is_negative
);
	localparam BIT_RESOLUTION = 8;
	localparam PWM_STEP = 50_000/(2**(BIT_RESOLUTION-1));//-1 PORQUE AGARRO EL PRIMER BIT del tercer nibble, es para evitar que se vaya a cero cuando 0F-10
	//en la práctica es un bit menos de resolución porque casi nunca sale el primer bit del tercer nibble.
	
	// Extraemos los bits útiles para el ángulo
	wire [BIT_RESOLUTION-1:0] current_rough_angle = absolute_angle[8:1];
	
	// Registros para implementar histéresis
	reg [BIT_RESOLUTION-1:0] filtered_rough_angle;
	
	// Registros para media móvil con ventana de 16
	reg [BIT_RESOLUTION-1:0] angle_history [0:15]; // memoria de 16 valores, salio de chiripada
	wire [BIT_RESOLUTION+5:0] angle_sum; // Bits extra para la suma (6+4=10 bits)
	wire [BIT_RESOLUTION-1:0] avg_angle;
	
	// Calculamos la suma de todo el historial. croe que pude haber hecho un for loop y ya
	assign angle_sum = angle_history[0] + angle_history[1] + angle_history[2] + angle_history[3] +
					   angle_history[4] + angle_history[5] + angle_history[6] + angle_history[7] +
					   angle_history[8] + angle_history[9] + angle_history[10] + angle_history[11] +
					   angle_history[12] + angle_history[13] + angle_history[14] + angle_history[15];
	
	// dividimos por 16 (desplazamiento de 4 bits)
	assign avg_angle = angle_sum >> 4;
	
	// Parámetros de histéresis
	parameter HYST_THRESHOLD = 1;
	
	reg [19:0] duty_cycle;
	reg [19:0] counter;
	reg [19:0] calculated_duty;
	
	// filtrar con histeresis para reducir el jitter
	always @(posedge clk or negedge rst_a_n) begin
		if (!rst_a_n) begin
			filtered_rough_angle <= 0;
		end else begin
			// Solo actualizamos el valor filtrado si la diferencia es mayor que el umbral
			if (current_rough_angle >= filtered_rough_angle) begin
				if ((current_rough_angle - filtered_rough_angle) > HYST_THRESHOLD)
					filtered_rough_angle <= current_rough_angle;
			end else begin
				if ((filtered_rough_angle - current_rough_angle) > HYST_THRESHOLD)
					filtered_rough_angle <= current_rough_angle;
			end
		end
	end
	
	// Implementación de la media móvil con ventana de 16
	integer i;
	always @(posedge clk or negedge rst_a_n) begin
		if (!rst_a_n) begin
			// Inicializamos todos los valores del historial a 0
			for (i = 0; i < 16; i = i + 1) begin
				angle_history[i] <= 0;
			end
		end else begin
			// Desplazamos todos los valores, del indice mayor al menor
			for (i = 15; i > 0; i = i - 1) begin
				angle_history[i] <= angle_history[i-1];
			end
			// Añadimos el valor más reciente
			angle_history[0] <= filtered_rough_angle;
		end
	end
	
	//duty cycle modifier (usando el valor promediado)
	always @(posedge clk or negedge rst_a_n) begin
		if (!rst_a_n)
			duty_cycle <= 0; 
		else begin
			if (is_negative)
				calculated_duty = (75_000 - (avg_angle)*PWM_STEP); // Ahora usamos avg_angle
			else
				calculated_duty = (avg_angle*PWM_STEP)+ 75_000; // Ahora usamos avg_angle
			
			// Limitamos el duty cycle entre 25_000 y 125_000
			if (calculated_duty > 125_000)
				duty_cycle <= 125_000; // Máximo permitido
			else if (calculated_duty < 25_000)
				duty_cycle <= 25_000; // Mínimo permitido
			else
				duty_cycle <= calculated_duty; // Valor calculado dentro de límites
		end
	end
	
	// contador que genera ciclos de 20ms
	always @(posedge clk or negedge rst_a_n) begin
		if (!rst_a_n)
			counter <= 0; 
		else if (counter < 1_000_000-1)
			counter <= counter + 1; // Seguimos contando, tranquilos
		else 
			counter <= 0; 
	end
	
	always @(posedge clk or negedge rst_a_n) begin
		if (!rst_a_n)
			pwm_signal <= 0; // Sin señal cuando hay reset
		else if (counter < duty_cycle)
			pwm_signal <= 1; // Encendemos cuando contador es menor que duty_cycle
		else
			pwm_signal <= 0; // Apagamos en caso contrario
	end
endmodule