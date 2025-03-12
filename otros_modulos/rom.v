module rom (
	input clk, rst_a_n,
	input [7:0] data,
	input start_search,
	output reg [7:0] address,
	output reg match,
	output reg busy
);
	
localparam IDLE = 1'b0;
localparam SEARCHING = 1'b1;

// Array para almacenar los valores
reg [7:0] memory [0:255];

// Variables para la búsqueda secuencial
reg state;
reg [7:0] current_addr;

// Cargar el archivo hex
initial begin
	$readmemh("memory_content.hex", memory);
end

// Lógica de la máquina de estados
always @(posedge clk or negedge rst_a_n) begin
	if (!rst_a_n) begin
		// Reset asíncrono - a cero todo
		state <= IDLE;
		current_addr <= 8'd0;
		match <= 1'b0;
		address <= 8'd0;
		busy <= 1'b0;
	end else begin
		case (state)
			IDLE: begin
				// esperar boton de start
				if (start_search) begin
					state <= SEARCHING;
					current_addr <= 8'd0;
					busy <= 1'b1;
					match <= 1'b0;
				end
			end
			
			SEARCHING: begin
				if (memory[current_addr] == data) begin
					//  hay match match
					match <= 1'b1;
					address <= current_addr;
					busy <= 1'b0;
					state <= IDLE;
				end else if (current_addr == 8'd255) begin
					//   final, no hay match
					match <= 1'b0;
					busy <= 1'b0;
					state <= IDLE;
				end else begin
					// siguiente dirección, seguimos buscando
					current_addr <= current_addr + 1'b1;
				end
			end
		endcase
	end
end
	
endmodule





/*
    always @(*) begin
        found = 1'b0;
        found_address = 8'd0;

        for (j = 254; j >= 0; j = j - 1) begin
            if (memory[j] == data) begin
                found = 1'b1;
                found_address = j[7:0];
            end
        end
    end */