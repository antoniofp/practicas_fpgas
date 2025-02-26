module adder(

	input wire a,b,cin,
	output s, cout
	);

	assign s= a^b^cin;
	assign cout= a&b | a & cin | b&cin;
endmodule
