module chrono (
input clk, rst_a_p, pause,
output wire [9:0] ms_counter,
output wire [5:0] second_counter
 

);

wire ms_clk;

clk_div #(1000) clk_div1(
.clk_in(clk),     // Input clock
.rst_a_p(rst_a_p),      // reset
.clk_out(ms_clk)     // Output clock
);



reg [15:0] ms_binario;

always @(posedge ms_clk, posedge rst_a_p)
begin
	//si está en reset, 0
	if (rst_a_p)
	begin
		ms_binario <= 0;
	end
	//si no está en pausea
	else if (!pause)
	begin
		//si es menor a 60_000 mili segundos
		if (ms_binario < 60_000)
		begin
			ms_binario <= ms_binario +1;
		end
		//si se pasa de 60_000 milisegunods
		else
			ms_binario <= 0;
	end
	//si está en pausa
	else
		ms_binario <= ms_binario;
end

assign ms_counter = ms_binario%1000;
assign second_counter = (ms_binario/1000)%60;




endmodule
