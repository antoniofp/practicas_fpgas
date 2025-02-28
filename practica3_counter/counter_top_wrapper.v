module counter_top_wrapper(
    input MAX10_CLK1_50,     // Reloj de 50MHz de la placa

    input [1:0] KEY,         // KEY[0] = rst (activo bajo), KEY[1] = load

    input [9:0] SW,          // SW[3:0] = data_in, SW[9] = up_down

    output [6:0] HEX0     
);
    
counter_top counter_inst(
	.clk(MAX10_CLK1_50),          
	.rst(~KEY[0]),                // Reset activo alto (invertimos KEY[0])
	.data_in(SW[3:0]),            
	.load(~KEY[1]),               // Load activo alto (invertimos KEY[1])
	.up_down(SW[9]),            
	.display_out(HEX0[6:0])       
);


endmodule