module bcd_wrapper(
   input [9:0] SW,
   output [6:0] HEX0,
   output [6:0] HEX1,
   output [6:0] HEX2,
   output [6:0] HEX3
);
   // BCD converter instance
   bcd bcd_inst(
       .input_bin(SW),
       .U(HEX0),
       .D(HEX1),
       .C(HEX2),
       .M(HEX3)
   );
endmodule