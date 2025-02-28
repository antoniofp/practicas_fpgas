module counter_top (
input clk,              // Clock input
input rst,              // Asynchronous reset
input [3:0] data_in,    // Data input for loading
input load,             // Load enable signal
input up_down,          // Count direction (1=up, 0=down)
output wire [6:0] display_out
);


wire slow_clk; //señal interna para conectar la salida de clk_div a otro módulo
wire [3:0] display_in; //señal interna para conectar la salida del contador al display

clk_div #(1) clk_div_1(clk, rst, slow_clk);  //instancia de clk_div configurada a 1 hz

counter counter_inst(slow_clk, rst, data_in, load, up_down, display_in); //instancia del counter que recibe un reloj de un segundo

decoder_7_seg display_inst(.decoder_in(display_in), .decoder_out(display_out)); //instancia de un decoder bdc que recibe el valor del contador


endmodule