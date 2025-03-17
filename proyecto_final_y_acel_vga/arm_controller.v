module arm_controller (
	//////////// CLOCK //////////
	input 		          		ADC_CLK_10,
	input 		          		MAX10_CLK1_50,
	input 		          		MAX10_CLK2_50,
	//////////// SEG7 //////////
	output		     [6:0]		HEX0,
	output		     [6:0]		HEX1,
	output		     [6:0]		HEX2,
	output		     [6:0]		HEX3,
	output		     [6:0]		HEX4,
	output		     [6:0]		HEX5,
	//////////// KEY //////////
	input 		     [1:0]		KEY,
	//////////// LED //////////
	output		     [9:0]		LEDR,
	//////////// SW //////////
	input 		     [9:0]		SW,
	//////////// Accelerometer ports //////////
	output		          		GSENSOR_CS_N,
	input 		     [2:1]		GSENSOR_INT,
	output		          		GSENSOR_SCLK,
	inout 		          		GSENSOR_SDI,
	inout 		          		GSENSOR_SDO,
	//////////// GPIO //////////
	output		     [35:0]		GPIO,
	
	output		     [3:0]		VGA_R,
	output		     [3:0]		VGA_G,
	output		     [3:0]		VGA_B,
	output		          		VGA_HS,
	output		          		VGA_VS
);
	// Parámetros para la máquina de estados
	parameter ANGLE_TIME_MS = 125;
	parameter MEMORY_SIZE = 128;
	parameter MEMORY_FILE = "servo_angles.hex";
	
	// interconnect accel-mux
	wire [15:0] accel_abs_x, accel_abs_y, accel_abs_z;
	wire accel_neg_x, accel_neg_y, accel_neg_z;
	
	// interconncet máquina-mux
	wire [15:0] seq_abs_x, seq_abs_y, seq_abs_z;
	wire seq_neg_x, seq_neg_y, seq_neg_z;
	
	// interconnect mux-servos
	reg [15:0] mux_abs_x, mux_abs_y, mux_abs_z;
	reg mux_neg_x, mux_neg_y, mux_neg_z;
	

	
	// Modo operativo: 0 = acel, 1 = secuencia
	wire mode_select = SW[8];
	
	// Instancia del lector de acelerómetro
	accel_reader accel1 (
		.abs_x_out(accel_abs_x),
		.abs_y_out(accel_abs_y),
		.abs_z_out(accel_abs_z),
		.neg_x_out(accel_neg_x),
		.neg_y_out(accel_neg_y),
		.neg_z_out(accel_neg_z),
		
		.ADC_CLK_10(ADC_CLK_10),
		.MAX10_CLK1_50(MAX10_CLK1_50),
		.MAX10_CLK2_50(MAX10_CLK2_50),
		.HEX0(HEX0),
		.HEX1(HEX1),
		.HEX2(HEX2),
		.HEX3(HEX3),
		.HEX4(HEX4),
		.HEX5(HEX5),
		.KEY(KEY),
		.LEDR(LEDR),
		.SW(SW),
		.GSENSOR_CS_N(GSENSOR_CS_N),
		.GSENSOR_INT(GSENSOR_INT),
		.GSENSOR_SCLK(GSENSOR_SCLK),
		.GSENSOR_SDI(GSENSOR_SDI),
		.GSENSOR_SDO(GSENSOR_SDO)
	);
	
	// Instancia del generador de secuencia de ángulos
	angle_pwm #(
		.TIME_MS(ANGLE_TIME_MS),
		.CLOCK_FREQ_HZ(50000000)
	) seq_generator (
		.clk(MAX10_CLK1_50),
		.rst_a_n(SW[9]),
		.start_signal(~KEY[0]),  
		
		.servo1_angle(seq_abs_x),
		.servo1_is_negative(seq_neg_x),
		.servo2_angle(seq_abs_y),
		.servo2_is_negative(seq_neg_y),
		.servo3_angle(seq_abs_z),
		.servo3_is_negative(seq_neg_z)
	);
	

	
	// Multiplexor para seleccionar entre acelerómetro y secuencia
	always @(*) begin
		if (mode_select) begin
			// Modo secuencia (SW[8] = 1)
			mux_abs_x = seq_abs_x;
			mux_abs_y = seq_abs_y;
			mux_abs_z = seq_abs_z;
			mux_neg_x = seq_neg_x;
			mux_neg_y = seq_neg_y;
			mux_neg_z = seq_neg_z;
		end else begin
			// Modo acelerómetro (SW[8] = 0)
			mux_abs_x = accel_abs_x;
			mux_abs_y = accel_abs_y;
			mux_abs_z = accel_abs_y;
			mux_neg_x = accel_neg_x;
			mux_neg_y = accel_neg_y;
			mux_neg_z = accel_neg_y;
		end
	end
	
	//conversión del ángulo del mux a ángulo decimal para mostrar en vga
	wire [11:0] miliangle_wireX, miliangle_wireY, miliangle_wireZ;
	//instancias de convertidores
	hex_to_angle hex_to_angleX(
	.hex_value(mux_abs_x),     // Valor hexadecimal (solo usamos los 8 LSB)
	.is_negative(mux_neg_x),     // Indica si estamos en el primer rango (0-89.9°)
	.angle_dec(miliangle_wireX) // Ángulo en décimas de grado (0-1800)
);
	hex_to_angle hex_to_angleY(
	.hex_value(mux_abs_y),     // Valor hexadecimal (solo usamos los 8 LSB)
	.is_negative(mux_neg_y),     // Indica si estamos en el primer rango (0-89.9°)
	.angle_dec(miliangle_wireY) // Ángulo en décimas de grado (0-1800)
);
	hex_to_angle hex_to_angleZ(
	.hex_value(mux_abs_z),     // Valor hexadecimal (solo usamos los 8 LSB)
	.is_negative(mux_neg_z),     // Indica si estamos en el primer rango (0-89.9°)
	.angle_dec(miliangle_wireZ) // Ángulo en décimas de grado (0-1800)
);
	
	// Controladores PWM para cada servo
	pwm_controller servoX(
		.rst_a_n(SW[9]),
		.clk(MAX10_CLK1_50),
		.pwm_signal(GPIO[1]),
		.absolute_angle(mux_abs_x),
		.is_negative(mux_neg_x)
	);
	
	
	pwm_controller #(.MIN_DC(60_000)) servoY(
		.rst_a_n(SW[9]),
		.clk(MAX10_CLK1_50),
		.pwm_signal(GPIO[4]),
		.absolute_angle(mux_abs_y),
		.is_negative(mux_neg_y)
	);
	
	pwm_controller #(.MIN_DC(40_000), .MAX_DC(55_000), .UPDATE_FREQ(60)) servoZ(
		.rst_a_n(SW[9]),
		.clk(MAX10_CLK1_50),
		.pwm_signal(GPIO[3]),
		.absolute_angle(mux_abs_z),
		.is_negative(~mux_neg_z)  // lo niego para que vaya pal otro lado
	);
	
	
	VGADemo vga_inst (
	 .clk(MAX10_CLK1_50), 
	 .X_VALUE(miliangle_wireX/10), 
	 .Y_VALUE(miliangle_wireY/10), 
	 .Z_VALUE(miliangle_wireZ/10),
	 .pixel({VGA_R[3], VGA_G[3], VGA_B[3]}),  
	 .hsync_out(VGA_HS),
	 .vsync_out(VGA_VS)
	);

endmodule