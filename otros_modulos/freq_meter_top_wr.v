module freq_meter_top_wr(
	//////////// CLOCK //////////
	input 		          		MAX10_CLK1_50,

	//////////// KEY //////////
	input 		     [1:0]		KEY,

	//////////// SW //////////
	input 		     [0:0]		GPIO,

	//////////// HEX //////////
	output		     [7:0]		HEX0,
	output		     [7:0]		HEX1,
	output		     [7:0]		HEX2,
	output		     [7:0]		HEX3,
	output		     [7:0]		HEX4,
	output		     [7:0]		HEX5
);

	// Instanciación del módulo usando conexiones directas
	freq_meter_top freq_meter_inst(
		.clk(MAX10_CLK1_50),      // Reloj de 50MHz
		.rst_a_p(~KEY[0]),        // Reset activo en alto (invertido desde KEY)
		.sample_signal(GPIO[0]),    // Señal de muestra desde SW[0]
		.U(HEX0[6:0]),           // Conexiones directas a los segmentos
		.D(HEX1[6:0]),
		.C(HEX2[6:0]),
		.M(HEX3[6:0]),
		.DM(HEX4[6:0]),
		.CM(HEX5[6:0])
	);
	
	// Apagar todos los puntos decimales
	assign HEX0[7] = 1'b1;
	assign HEX1[7] = 1'b1;
	assign HEX2[7] = 1'b1;
	assign HEX3[7] = 1'b1;
	assign HEX4[7] = 1'b1;
	assign HEX5[7] = 1'b1;

endmodule