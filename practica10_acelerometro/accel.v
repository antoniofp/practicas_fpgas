module accel (
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
	inout 		          		GSENSOR_SDO
	);
//===== Declarations
	// Simplificamos parámetros de frecuencia
	localparam SPI_CLK_FREQ  = 200;      // SPI Clock (Hz)
	
	// clks and reset
	wire reset_n;
	wire clk, spi_clk, spi_clk_out;
	// output data
	wire data_update;
	wire [15:0] data_x, data_y, data_z; // Datos de los tres ejes
	
	// Señal de actualización a 10Hz
	wire display_update_freq;

//Phase-locked Loop (PLL) instantiation
PLL ip_inst (
	.inclk0 ( MAX10_CLK1_50 ),
	.c0 ( clk ),                 // 25 MHz, phase   0 degrees
	.c1 ( spi_clk ),             //  2 MHz, phase   0 degrees
	.c2 ( spi_clk_out )          //  2 MHz, phase 270 degrees
	);

//Divisor de reloj para generar actualización a 10Hz
clk_div_a_n #(
	.OUTPUT_FREQ(50)          
) update_div (
	.clk_in(clk),              // Reloj de entrada a 25MHz
	.rst_a_n(reset_n),         // Reset activo bajo
	.clk_out(display_update_freq)      // Señal de salida a 10Hz
);

//Instantiation of the spi_control module
spi_control #(
		.SPI_CLK_FREQ   (SPI_CLK_FREQ),
		.UPDATE_FREQ    (1))           // Mantenemos este valor por compatibilidad
	spi_ctrl (
		.reset_n    (reset_n),
		.clk        (clk),
		.spi_clk    (spi_clk),
		.spi_clk_out(spi_clk_out),
		.data_update(data_update),
		.data_x     (data_x),
		.data_y     (data_y),
		.data_z     (data_z),
		.SPI_SDI    (GSENSOR_SDI),
		.SPI_SDO    (GSENSOR_SDO),
		.SPI_CSN    (GSENSOR_CS_N),
		.SPI_CLK    (GSENSOR_SCLK),
		.interrupt  (GSENSOR_INT)
	);

//===== Main block
// Pressing KEY0 freezes the accelerometer's output
assign reset_n = SW[9];

// Registros para almacenar los valores para mostrar
reg signed [15:0] raw_x_sample = 0;
reg signed [15:0] raw_y_sample = 0;
reg signed [15:0] raw_z_sample = 0;

// Actualizamos los valores con frecuencia de 10Hz
always @(posedge display_update_freq or negedge reset_n) begin
	if (!reset_n) begin
		raw_x_sample <= 0;
		raw_y_sample <= 0;
		raw_z_sample <= 0;
	end else begin
		raw_x_sample <= data_x;
		raw_y_sample <= data_y;
		raw_z_sample <= data_z;
	end
end

wire [15:0] abs_x = (raw_x_sample[15]) ? (~raw_x_sample + 1'b1) : raw_x_sample;
wire [15:0] abs_y = (raw_y_sample[15]) ? (~raw_y_sample + 1'b1) : raw_y_sample;
wire [15:0] abs_z = (raw_z_sample[15]) ? (~raw_z_sample + 1'b1) : raw_z_sample;

// cablas para determinar si los valores son negativos
wire is_negative_x = raw_x_sample[15];
wire is_negative_y = raw_y_sample[15];
wire is_negative_z = raw_z_sample[15];

// Lógica de selección basada en SW[1:0] como número binario
// 00 = X, 01 = Y, 10 = Z, 11 = 3
reg [15:0] display_data;
reg is_negative;
reg [3:0] axis_code; // Para mostrar en HEX5 (0, 1, 2 o 3)

always @(*) begin
	// Selección del eje mediante case 
	case(SW[1:0])
		2'b00: begin // Eje X
			display_data = abs_x;
			is_negative = is_negative_x;
			axis_code = 4'd0; // X = 0
		end
		2'b01: begin // Eje Y
			display_data = abs_y;
			is_negative = is_negative_y;
			axis_code = 4'd1; // Y = 1
		end
		2'b10: begin // Eje Z
			display_data = abs_z;
			is_negative = is_negative_z;
			axis_code = 4'd2; // Z = 2
		end
		default: begin // Caso 3 o cualquier otro
			display_data = 16'h0000; // Podríamos mostrar ceros o cualquier otro valor por defecto
			is_negative = 1'b0;
			axis_code = 4'd3; // Código 3
		end
	endcase
end

wire [3:0] hex_digit0 = display_data[3:0];
wire [3:0] hex_digit1 = display_data[7:4];
wire [3:0] hex_digit2 = display_data[11:8];
wire [3:0] hex_digit3 = display_data[15:12];

seg7 s0 ( .in(hex_digit0), .display(HEX0) );
seg7 s1 ( .in(hex_digit1), .display(HEX1) );
seg7 s2 ( .in(hex_digit2), .display(HEX2) );
seg7 s3 ( .in(hex_digit3), .display(HEX3) );

// HEX4 muestra el signo (- para negativo, apagado para positivo)
assign HEX4 = is_negative ? 8'b10111111 : 8'b11111111; // "-" o apagado

// HEX5 muestra qué eje está activo
seg7 s5 ( .in(axis_code+1), .display(HEX5) );

// se muestra número binario sin complemento a dos y con un led para el signo
assign LEDR = {is_negative, display_data[8:0]};

endmodule