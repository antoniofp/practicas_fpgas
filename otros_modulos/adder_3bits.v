module adder_3bits(
	input [2:0] A,B,
	output [3:0] sum
);

	wire cout1, cout2;  	//señal auxiliar (interna)

	
	adder fa0(
		.a(A[0]),
		.b(B[0]),
		.cin(0),
		.s(sum[0]),
		.cout(cout1)
	);
	
	adder fa1(
		.a(A[1]),
		.b(B[1]),
		.cin(cout1),
		.s(sum[1]),
		.cout(cout2)
	);
	adder fa2(
		.a(A[2]),
		.b(B[2]),
		.cin(cout2),
		.s(sum[2]),
		.cout(sum[3])
	);
endmodule