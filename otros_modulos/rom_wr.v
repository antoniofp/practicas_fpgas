module rom_wr (

input 		          		MAX10_CLK1_50,

//////////// KEY //////////
input 		     [1:0]		KEY,

//////////// SW //////////
//input 		     [0:0]		GPIO,

//////////// HEX //////////
output		     [6:0]		HEX0,
output		     [6:0]		HEX1,
output		     [6:0]		HEX2,
output		     [6:0]		HEX3,
output		     [6:0]		HEX4,
output		     [6:0]		HEX5,

output [9:0] LEDR


);


wire [7:0] address_wire;
wire [15:0] max_number_wire;

wire [3:0] address_first_nibble = address_wire [3:0];
wire [3:0] address_second_nibble = address_wire [7:4];

wire [3:0] number_1 = max_number_wire[3:0];
wire [3:0] number_2 = max_number_wire[7:4];
wire [3:0] number_3 = max_number_wire[11:8];
wire [3:0] number_4 = max_number_wire[15:12];


decoder_7_seg decoder_a1 (
.decoder_in(address_first_nibble),
.decoder_out(HEX0)
);
decoder_7_seg decoder_a2 (
.decoder_in(address_second_nibble),
.decoder_out(HEX1)
);



decoder_7_seg decoder_n1 (
.decoder_in(number_1),
.decoder_out(HEX2)
);
decoder_7_seg decoder_n2 (
.decoder_in(number_2),
.decoder_out(HEX3)
);
decoder_7_seg decoder_n3 (
.decoder_in(number_3),
.decoder_out(HEX4)
);
decoder_7_seg decoder_n4 (
.decoder_in(number_4),
.decoder_out(HEX5)
);



rom rom1(
.clk(MAX10_CLK1_50), 
.rst_a_p(~KEY[0]),
.start_search(~KEY[1]),
.address(address_wire),
.finished(LEDR[0]),
.max_number(max_number_wire)
);



endmodule