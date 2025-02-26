module top_3bit_7seg(
	
	//entradas de 3bits para el sumador
	input [2:0] A,B,
	
	//sallida al 7 segmentos
	output [0:6] segmentos_out

);

wire [3:0] aux_wire;
adder_3bits SUMADOR(
	.A(A),
	.B(B),
	.sum(aux_wire)

);

decoder_7_seg DISPLAY(
	.decoder_in(aux_wire),
	.decoder_out(segmentos_out)
);


endmodule