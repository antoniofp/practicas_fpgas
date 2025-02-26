module display_sum #(parameter N=5)(
	input [N-1 : 0] A,B,
	output [6: 0]		D_decenas, D_unidades

);

	wire [N:0] suma_wire;
	wire [3:0] uni;
	wire [3:0] dec;

	nbit_adder #(.N(N)) sum_final (
		.a(A),
		.b(B),
		.sum(suma_wire)
	);
	
	assign dec = suma_wire /10;
	assign uni = suma_wire %10;
	
	decoder_7_seg disp_uni (
		.decoder_in(uni),
		.decoder_out(D_unidades)
	);
	
	decoder_7_seg disp_dec (
		.decoder_in(dec),
		.decoder_out(D_decenas)
	);
	


endmodule 