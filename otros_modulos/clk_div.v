module clk_div #(
    parameter OUTPUT_FREQ = 1 
)(
    input wire clk_in,     // Input clock
    input wire rst_a_p,      // reset
    output reg clk_out     // Output clock
);
	localparam BASE_FREQ = 50_000_000;

    // Calculate the counter limit based on frequencies
    // Division by 2 because we toggle at half the period
	localparam integer COUNTER_LIMIT = (BASE_FREQ / (2 * OUTPUT_FREQ)) - 1; //ojito, esto redondea para abajo en caso de no resultar en entero, IMPLICACIONES: contador menor, frecuencia mayor.
    
    reg [24:0] counter;
    
    always @(posedge clk_in, posedge rst_a_p) begin
        if (rst_a_p) begin
            counter <= 0;
            clk_out <= 0;
        end else begin
            if (counter == COUNTER_LIMIT) begin
                counter <= 0;
                clk_out <= ~clk_out;
            end else begin
                counter <= counter + 1;
            end
        end
    end

endmodule