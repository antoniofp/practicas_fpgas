module seg7(
		
	input [3:0] in,
	
	output reg [6:0] display
);

always @(in)
begin
	case(in)
		4'h0: display = 7'b1000000;  // 0
		4'h1: display = 7'b1111001;  // 1
		4'h2: display = 7'b0100100;  // 2
		4'h3: display = 7'b0110000;  // 3
		4'h4: display = 7'b0011001;  // 4
		4'h5: display = 7'b0010010;  // 5
		4'h6: display = 7'b0000010;  // 6
		4'h7: display = 7'b1111000;  // 7
		4'h8: display = 7'b0000000;  // 8
		4'h9: display = 7'b0010000;  // 9
		4'hA: display = 7'b0001000;  // A
		4'hB: display = 7'b0000011;  // b
		4'hC: display = 7'b1000110;  // C
		4'hD: display = 7'b0100001;  // d
		4'hE: display = 7'b0000110;  // E
		4'hF: display = 7'b0001110;  // F
			  default: display = 7'b1111111; //nada
	endcase
end
endmodule 
