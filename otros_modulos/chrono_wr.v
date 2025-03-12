module chrono_wr (
input 		          		MAX10_CLK1_50,

//////////// KEY //////////
input 		     [1:0]		KEY,

//////////// SW //////////
//input 		     [0:0]		GPIO,

//////////// HEX //////////
output		     [6:0]		HEX0,
output		     [6:0]		HEX1,
output		     [6:0]		HEX2,
//output		     [6:0]		HEX3,
output		     [6:0]		HEX4,
output		     [6:0]		HEX5,

output [9:0] LEDR


);



wire [9:0] ms_wire;
wire [5:0] second_wire;


decoder_7_seg decoder_m1(
.decoder_in(ms_wire % 10),
.decoder_out(HEX0)
);
decoder_7_seg decoder_m2(
.decoder_in((ms_wire/10) % 10 ),
.decoder_out(HEX1)
);
decoder_7_seg decoder_m3(
.decoder_in(ms_wire/100),
.decoder_out(HEX2)
);

decoder_7_seg decoder_s1(
.decoder_in(second_wire%10),
.decoder_out(HEX4)
);
decoder_7_seg decoder_s2(
.decoder_in(second_wire/10),
.decoder_out(HEX5)
);


chrono chrono1(
.clk(MAX10_CLK1_50),
.rst_a_p(~KEY[0]),
.pause(~KEY[1]),
.ms_counter(ms_wire), //10bit
.second_counter(second_wire) //6bit
);


endmodule
