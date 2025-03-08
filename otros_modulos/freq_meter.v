module freq_meter (
	input clk, rst_a_p,
	input sample_signal,
	output reg [16:0] hz
);
	wire one_sec_clk;
	reg clock_prev;
	reg one_sec_flag;
	reg signal_prev;
	reg [16:0] cycle_counter = 0;
	
	clk_div #(1) clk_div1(clk, rst_a_p, one_sec_clk);
	
	//generamos un pulso de un ciclo en el flanco de subida del reloj de 1 segundo
	always @(negedge clk or posedge rst_a_p) 
	begin
		if (rst_a_p) 
		begin
			clock_prev <= 1'b0;
			one_sec_flag <= 1'b0;
		end 
		else 
		begin
			// Guardamos el valor actual para el siguiente ciclo
			clock_prev <= one_sec_clk;
			// Solo se activa en el flanco ascendente de la señal limpia
			one_sec_flag <= one_sec_clk && !clock_prev;
		end
	end
	
	always @(posedge clk or posedge rst_a_p)
	begin
		if (rst_a_p)
		begin
			cycle_counter <= 0;
			hz <= 0;
			signal_prev <= 0;
		end
		else
		begin
			signal_prev <= sample_signal;
			//al segundo reporta medida de frecuencia
			if (one_sec_flag)
			begin
				//dividimos por 2 porque contamos ambos flancos (con el >>(quick m athhs para compus))
				hz <= ((cycle_counter >> 1) * 107) / 100; 
				cycle_counter <= 0;
			end
			else if (sample_signal != signal_prev)
			begin
				cycle_counter <= cycle_counter + 1;
			end
		end
	end
endmodule