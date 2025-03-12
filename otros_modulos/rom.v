
module rom (
	input clk, rst_a_p,
	input start_search,
	output reg [7:0] address,
	output reg finished= 0,
	output reg [15:0] max_number=0

);
	
localparam IDLE = 1'b0;
localparam SEARCHING = 1'b1;

// Array para almacenar los valores
reg [15:0] memory [0:255];

// Variables para la búsqueda secuencial
reg state;
reg [7:0] current_addr;
// Cargar el archivo hex
initial begin
	$readmemh("Mem_hex.hex", memory);
end

// Lógica de la máquina de estados
always @(posedge clk or posedge rst_a_p) 
begin
	if (rst_a_p) 
	begin
		// Reset asíncrono - a cero todo
		state <= IDLE;
		current_addr <= 8'd0;
		address <= 8'd0;
		max_number <= 0;
		finished <= 0;
	end 
	else 
	begin
		case (state)
			IDLE: 
			begin
				// esperar boton de start
				if (start_search) begin
					state <= SEARCHING;
					current_addr <= 8'd0;
					max_number <= 0;
				end
			end
			SEARCHING: 
			begin
				if (memory[current_addr] > max_number)
				begin
					address <= current_addr;
					max_number <= memory[current_addr];
					//state <= SEARCHING;
				end
				else if (current_addr == 255)
				begin
					state <= IDLE;
					finished <= 1;
				end
				else 
					current_addr <= current_addr +1;
			end
		endcase
	end
end
	
endmodule


				/*if (memory[current_addr] == data) begin
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
				end*/


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