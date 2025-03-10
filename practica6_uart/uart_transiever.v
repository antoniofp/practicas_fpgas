module uart_transiever (
	input clk, rst,
	
	input [7:0] data,
	input send_data,

	output wire data_valid,
	
	output wire [6:0] first_display, second_display
	
);

wire serial_wire;
wire [7:0] parallel_out;
wire send_pulse;

one_shot #(.DEBOUNCE_TIME_MS(10)) one_shot1 (
.clk(clk),          // Reloj del sistema
.rst_a_p(rst),      // Reset activo alto
.button_in(send_data),    // Entrada sucia del botón
.pulse_out(send_pulse)    // Salida del pulso one-shot
);

uart_tx #(.BAUDRATE(115200)) uart_tx1 (
.data(data),
.send_data(send_pulse),
.clk(clk),
.rst(rst),
.serial_out(serial_wire)

);


uart_rx #(.BAUDRATE(115200)) uart_rx1 (
.clk(clk),  
.serial_in(serial_wire),
.rst(rst),
.parallel_out(parallel_out),
.data_valid(data_valid)

);


decoder_7_seg decoder1(
.decoder_in(parallel_out[7:4]),
.decoder_out(first_display)
);

decoder_7_seg decoder2(
.decoder_in(parallel_out[3:0]),
.decoder_out(second_display)
);



endmodule