module counter(
    input clk,              // Clock input
    input rst,              // Asynchronous reset
    input [3:0] data_in,    // Data input for loading
    input load,             // Load enable signal
    input up_down,          // Count direction (1=up, 0=down)
    output reg [3:0] count  // 4-bit counter output
);

always @(posedge clk or posedge rst) begin
	if (rst) 
	count <= 4'b0000;  // Reset counter to 0
	else if (load) 
	count <= data_in;  // Load external value
	else if (up_down) 
	count <= count + 1;  // 
	else 
	count <= count - 1;  // 
end

endmodule


