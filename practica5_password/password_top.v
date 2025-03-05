module password_top(

input clk, rst_a_p,
input [9:0] switches,


output reg [6:0] HEX0, HEX1, HEX2, HEX3, HEX4,
output wire [6:0] HEX5

);



wire [1:0] disp_in;
wire [6:0] disp_out;
wire [2:0] state_debug_wire;

password password_instance(
.clk(clk),
.rst_a_p(rst_a_p),
.switches(switches),
.disp_state(disp_in),
.disp_debug(state_debug_wire)
);

decoder_7_seg decoder1 (
.decoder_in(state_debug_wire),
.decoder_out(HEX5)
);



always @(*) begin //always para ver error o done
 
    if (disp_in == 2) //done
	 begin
	  HEX4 = 7'b1111_111;
		HEX3 = 7'b0100_001;
		HEX2 = 7'b1000_000;
		HEX1 = 7'b1001_000;
		HEX0 = 7'b0000_110;
		end 
	 else if (disp_in == 1) begin
	  // Para mostrar ERROR
	  HEX4 = 7'b0000110;  // E
	  HEX3 = 7'b0101111;  // r
	  HEX2 = 7'b0101111;  // r
	  HEX1 = 7'b0100011;  // O
	  HEX0 = 7'b0101111;  // r
    end
	 else if (disp_in==3)
	 begin
		HEX4 = 7'b1111110; 
		HEX3 = 7'b1111110; 
		HEX2 = 7'b1111110;
		HEX1 = 7'b1111110; 
		HEX0 = 7'b1111110; 
	end
	else
	begin
		HEX4 = 7'b1111111; 
		HEX3 = 7'b1111111; 
		HEX2 = 7'b1111111; 
		HEX1 = 7'b1111111; 
		HEX0 = 7'b1111111; 
	end
	
	
end


endmodule