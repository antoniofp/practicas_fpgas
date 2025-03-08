module freq_meter_top(
input clk, rst_a_p, sample_signal,
output [6:0] U,D,C,M,DM,CM

);


wire [27:0] bin_freq;


freq_meter freq_meter1(
.clk(clk),
.rst_a_p(rst_a_p),
.sample_signal(sample_signal),
.hz(bin_freq)
);


 wire [3:0] unis_wire, dec_wire, cent_wire, miles_wire, dec_miles_wire, cent_miles_wire;

 assign unis_wire = bin_freq % 10;
 assign dec_wire = (bin_freq / 10) % 10;  
 assign cent_wire = (bin_freq / 100) % 10;  
 assign miles_wire = (bin_freq / 1000) % 10; 
 assign dec_miles_wire = (bin_freq / 10000) % 10; 
 assign cent_miles_wire = (bin_freq / 100000) % 10; 
 
 
 /*
 assign unis_wire = 1234 % 10;
 assign dec_wire = (1234 / 10) % 10;  
 assign cent_wire = (1234 / 100) % 10;  
 assign miles_wire = (1234 / 1000) % 10; 
 assign dec_miles_wire = (1234 / 10000) % 10; 
 assign cent_miles_wire = (1234 / 100000) % 10; */

 decoder_7_seg disp_uni (
	  .decoder_in(unis_wire),
	  .decoder_out(U)
 );

 decoder_7_seg disp_dec (
	  .decoder_in(dec_wire),
	  .decoder_out(D)
 );

 decoder_7_seg disp_cent (
	  .decoder_in(cent_wire),
	  .decoder_out(C)
 );

 decoder_7_seg disp_miles (
	  .decoder_in(miles_wire),
	  .decoder_out(M)
 );
 
 decoder_7_seg disp_dec_miles (
	  .decoder_in(dec_miles_wire),
	  .decoder_out(DM)
 );
 
  decoder_7_seg disp_cent_miles (
	  .decoder_in(cent_miles_wire),
	  .decoder_out(CM)
 );
 

endmodule