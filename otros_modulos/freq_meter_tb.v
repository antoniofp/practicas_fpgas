`timescale 1ns / 1ns

// Definición del módulo de testbench
module freq_meter_tb;
	// Señales de entrada
	reg clk;
	reg rst_a_p;
	reg sample_signal;
	
	// Señal de salida
	wire [27:0] hz;
	
	// Instanciamos el medidor de frecuencia
	freq_meter DUT (
		.clk(clk),
		.rst_a_p(rst_a_p),
		.sample_signal(sample_signal),
		.hz(hz)
	);
	
	// Generamos reloj de 50MHz (período de 20ns)
	always #10 clk = ~clk;  // 10ns para medio período
	
	// Generamos señal de 1200Hz (período de 833.333μs)
	// Medio período = 416.667μs = 416667ns
	always #416667 sample_signal = ~sample_signal;
	
	initial begin
		// Inicializamos las señales
		clk = 0;
		rst_a_p = 1;
		sample_signal = 0;
		
		// Aplicamos reset durante 100ns
		#100;
		rst_a_p = 0;
		
		// Simulamos durante 1.5 segundos para ver un ciclo completo de medición
		// y un poco más para asegurarnos
		#1500000000;
		
		$stop;
	end
	
	// Mostramos la medición de frecuencia
	initial begin
		$monitor("Tiempo: %t | Frecuencia: %d Hz", $time, hz);
	end
endmodule