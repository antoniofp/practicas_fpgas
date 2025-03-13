module accel_pwm (
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
	output		     [35:0]		GPIO
);

	// Cables internos para conectar accel_reader a pwm_controller
	wire [15:0] mi_abs_x, mi_abs_y, mi_abs_z;
	wire mi_neg_x, mi_neg_y, mi_neg_z;
	
	
	// El resto de GPIO se deja sin conectar (serán Z)

	// Instanciamos el controlador PWM - Conectamos directamente al eje Y
	pwm_controller servoX(
		.rst_a_n(SW[9]),           // Mismo reset que accel_reader
		.clk(MAX10_CLK1_50),        // Usamos el reloj principal
		.pwm_signal(GPIO[1]),       // Conectamos a la señal interna
		.absolute_angle(mi_abs_x),  // Conectamos directamente al eje Y
		.is_negative(mi_neg_x)      // Signo Y
	);
	
		pwm_controller #(.MIN_DC(40_000), .MAX_DC(55_000), .UPDATE_FREQ(60)) servoY(
		.rst_a_n(SW[9]),           //MIN_DC AND MAX_DC ARE SWAPPED BECAUSE I NEGATED THE ANGLE
		.clk(MAX10_CLK1_50),        
		.pwm_signal(GPIO[2]),       
		.absolute_angle(mi_abs_y),  
		.is_negative(~mi_neg_y)      
	);
	
			pwm_controller servoZ(
		.rst_a_n(SW[9]),           // Mismo reset que accel_reader
		.clk(MAX10_CLK1_50),        // Usamos el reloj principal
		.pwm_signal(GPIO[3]),       // Conectamos a la señal interna
		.absolute_angle(mi_abs_y),  // Conectamos directamente al eje Y
		.is_negative(mi_neg_y)      // Signo Y
	);

	// Instanciamos el lector de acelerómetro
	accel_reader accel1 (
		// Puertos para comunicar con pwm_controller
		.abs_x_out(mi_abs_x),
		.abs_y_out(mi_abs_y),
		.abs_z_out(mi_abs_z),
		.neg_x_out(mi_neg_x),
		.neg_y_out(mi_neg_y),
		.neg_z_out(mi_neg_z),
		
		// Puertos que conectamos directamente a los pines externos
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
endmodule