module uart_rx (
	input clk,  
	input serial_in,
	input rst,
	output reg [7:0] parallel_out  // Necesitamos declararlo como reg
);
localparam baudrate = 115200;  // Los números no llevan comillas en Verilog
localparam base_freq = 50_000_000;  // Los números no llevan comillas en Verilog
localparam clocks_per_bit = base_freq/baudrate;
localparam RX_IDLE = 2'b00;
localparam RX_START = 2'b01;
localparam RX_DATA = 2'b10;
localparam RX_STOP = 2'b11;
reg [1:0] active_state = RX_IDLE;
reg [31:0] clock_ctr = 0;
reg [2:0] d_idx = 0;

always @(posedge clk or posedge rst)
	if(rst) begin  // Añadimos begin-end para bloques con más de una instrucción
		active_state <= RX_IDLE;  // Faltaba punto y coma
		clock_ctr <= 0;  // Reseteamos el contador de reloj
		d_idx <= 0;  // Reseteamos el índice de datos
	end
	else begin
		case(active_state)
		RX_IDLE: begin  // Añadimos begin-end para el case
			clock_ctr <= 0;  // Asignación no-bloqueante para registros
			
			if(serial_in == 0)  // Operador de comparación correcto
				active_state <= RX_START;
			else	
				active_state <= RX_IDLE;  // Arreglamos el operador de asignación
		end // RX_IDLE
		
		RX_START: begin  // Quitamos los dos puntos que no son parte de la sintaxis de Verilog
			if(clock_ctr <= (clocks_per_bit -1)/2) begin
				clock_ctr <= clock_ctr + 1;  // Faltaba punto y coma
				active_state <= RX_START;
			end
			else begin
				active_state <= RX_DATA;
				clock_ctr <= 0;
				d_idx <= 0;  // Reiniciamos el índice de datos antes de comenzar la recepción
			end
		end  // Añadimos end para RX_START
					
		RX_DATA: begin
			if (clock_ctr < clocks_per_bit - 1) begin  // Cambiado a < para evitar problemas de timing
				clock_ctr <= clock_ctr + 1;
				active_state <= RX_DATA;
			end
			else begin
				clock_ctr <= 0;
				parallel_out[d_idx] <= serial_in;  // Almacenamos el bit recibido
				
				if(d_idx < 7) begin
					d_idx <= d_idx + 1;  // Faltaba punto y coma
					active_state <= RX_DATA;  // Asignación no-bloqueante
				end
				else begin
					d_idx <= 0;  // Reiniciamos el índice para la próxima transmisión
					active_state <= RX_STOP;
				end
			end
		end  // RX DATA
		
		RX_STOP: begin
			if(clock_ctr < clocks_per_bit - 1) begin
				clock_ctr <= clock_ctr + 1;
				active_state <= RX_STOP;
			end
			else begin
				clock_ctr <= 0;
				active_state <= RX_IDLE;  // Volvemos al estado IDLE esperando el próximo byte
				// No es necesario hacer nada con parallel_out, ya contiene el byte completo
			end
		end  // RX_STOP
		
		default: begin
			active_state <= RX_IDLE;  // Por seguridad, volvemos a IDLE en caso de estado inválido
		end
		
		endcase
	end

endmodule