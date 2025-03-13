module pwm_controller (
	input rst_a_n, clk,
	output reg pwm_signal,
	input [15:0] absolute_angle,
	input is_negative
);
	localparam BIT_RESOLUTION = 8;
	localparam PWM_STEP = 50_000/(2**(BIT_RESOLUTION-1));
	
	// Convertimos a valor con signo desde el principio
	wire [BIT_RESOLUTION-1:0] angle_abs = absolute_angle[8:1];
	wire signed [BIT_RESOLUTION:0] signed_angle; // Un bit extra para signo
	
	// Aplicamos el signo según is_negative, el formato se cambia a signed para que podamos sumar negativos
	assign signed_angle = is_negative ? -$signed({1'b0, angle_abs}) : $signed({1'b0, angle_abs});
	
	// memoria para media móvil con ventana de 16 (con signo)
	reg signed [BIT_RESOLUTION:0] angle_history [0:15];
	wire signed [BIT_RESOLUTION+7:0] angle_sum; // Bits extra para suma, un monton para estar seguros de no overflow
	wire signed [BIT_RESOLUTION:0] avg_angle;
	
	// Calculamos la suma (con valores con signo)
	assign angle_sum = angle_history[0] + angle_history[1] + angle_history[2] + angle_history[3] +
					   angle_history[4] + angle_history[5] + angle_history[6] + angle_history[7] +
					   angle_history[8] + angle_history[9] + angle_history[10] + angle_history[11] +
					   angle_history[12] + angle_history[13] + angle_history[14] + angle_history[15];
	
	// División por 16 manteniendo signo
	assign avg_angle = angle_sum >>> 4; // Desplazamiento aritmético
	//si son positivos funciona igual que el desplazamiento normal, pero si es negativo, agrega 1 en los lugares vacíos en lugar de 0s
	
	// Histéresis (ahora con valor con signo)
	reg signed [BIT_RESOLUTION:0] filtered_angle;
	parameter HYST_THRESHOLD = 1;
	
	// Registros para PWM
	reg [19:0] duty_cycle;
	reg [19:0] counter;
	reg [19:0] calculated_duty;
	
	// Reloj lento para actualizaciones
	wire slow_clk;
	clk_div_a_n #(60) clk_div1 (clk, rst_a_n, slow_clk);
	
	// Media móvil
	integer i;
	always @(posedge slow_clk or negedge rst_a_n) begin
		if (!rst_a_n) begin
			// Reset
			for (i = 0; i < 16; i = i + 1) begin
				angle_history[i] <= 0;
			end
		end else begin
			// Desplazamiento de valores
			for (i = 15; i > 0; i = i - 1) begin
				angle_history[i] <= angle_history[i-1];
			end
			// Añadimos valor con signo
			angle_history[0] <= signed_angle;
		end
	end
	
	// Hiisteresis pa numeros con signo
	always @(posedge slow_clk or negedge rst_a_n) 
	begin
	if (!rst_a_n) 
	begin
		filtered_angle <= 0;
	end 
	else 
	begin
		// Calculamos la diferencia absoluta para evitar problemas en cruces por cero
		if ((avg_angle > filtered_angle && (avg_angle - filtered_angle > HYST_THRESHOLD)) ||
		    (avg_angle < filtered_angle && (filtered_angle - avg_angle > HYST_THRESHOLD)))
			filtered_angle <= avg_angle;
		// Si la diferencia es menor que el umbral, mantenemos el valor filtrado
	end
	end
	
	// al usar signed, no hay diferencia entre sumar un negativo y positivo
	always @(posedge clk or negedge rst_a_n) begin
		if (!rst_a_n)
			duty_cycle <= 0; 
		else begin
			// Fórmula única: 75_000 es el centro, filtered_angle*PWM_STEP es el offset
			calculated_duty = 75_000 + (filtered_angle * PWM_STEP);
			
			// Limitadores
			if (calculated_duty > 125_000)
				duty_cycle <= 125_000; 
			else if (calculated_duty < 25_000)
				duty_cycle <= 25_000; 
			else
				duty_cycle <= calculated_duty; 
		end
	end
	
	// Generador PWM
	always @(posedge clk or negedge rst_a_n) begin
		if (!rst_a_n)
			counter <= 0; 
		else if (counter < 1_000_000-1)
			counter <= counter + 1; 
		else 
			counter <= 0; 
	end
	
	always @(posedge clk or negedge rst_a_n) begin
		if (!rst_a_n)
			pwm_signal <= 0; 
		else if (counter < duty_cycle)
			pwm_signal <= 1; 
		else
			pwm_signal <= 0; 
	end
endmodule