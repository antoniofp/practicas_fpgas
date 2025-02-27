module clk_div #(
    parameter OUTPUT_FREQ = 1_000_000   // Desired output frequency in Hz (default 1MHz)
)(
    input wire clk_in,     // Input clock
    input wire rst_a_p,      // Active low reset
    output reg clk_out     // Output clock
);
	localparam BASE_FREQ = 50_000_000;

    // Calculate the counter limit based on frequencies
    // Division by 2 because we toggle at half the period
    localparam COUNTER_LIMIT = (BASE_FREQ / (2 * OUTPUT_FREQ)) - 1;
    
    // funcion para calcular tamaño de registro
    reg [$clog2(COUNTER_LIMIT+1)-1:0] counter;
    
    // Clock divider logic
    always @(posedge clk_in, posedge rst_a_p) begin
        if (rst_a_p) begin
            // Reset state
            counter <= 0;
            clk_out <= 0;
        end else begin
            if (counter == COUNTER_LIMIT) begin
                // Reset counter and toggle output clock
                counter <= 0;
                clk_out <= ~clk_out;
            end else begin
                // Increment counter
                counter <= counter + 1;
            end
        end
    end

endmodule