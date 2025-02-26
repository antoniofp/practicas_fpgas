module nbit_adder #(parameter N = 4)
	(
	input wire [N-1:0] a, b,
	output wire [N:0] sum
	);
	
	
wire [N-1:0] c_wire;

adder FA0(
		.a(a[0]),
		.b(b[0]),
		.cin(0),
		.s(sum[0]),
		.cout(c_wire[0])
	);

genvar i;

generate 
	for (i=1; i<N; i = i+1)
	begin: creador_sumador
		adder FA(
		.a(a[i]),
		.b(b[i]),
		.cin(c_wire[i-1]),
		.s(sum[i]), 
		.cout(c_wire[i])
		);
	end

endgenerate

assign sum[N] = c_wire[N-1];

endmodule
	