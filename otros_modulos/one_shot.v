module one_shot #(
    parameter DEBOUNCE_TIME_MS = 1     // Debounce time in milliseconds
)(
    input wire clk,          // System clock
    input wire rst_a_p,      // Active high reset
    input wire button_in,    // Raw button input
    output wire pulse_out    // One-shot pulse output
);
    // Instantiate clock divider for debouncing
    wire sample_clk;
    clk_div #(
        .OUTPUT_FREQ(1000 / DEBOUNCE_TIME_MS)  // Convert ms to frequency
    ) debounce_clk_div (
        .clk_in(clk),
        .rst_a_p(rst_a_p),
        .clk_out(sample_clk)
    );
    
    // Two D flip-flop synchronizer chain
    wire ff1, ff2;
    
    // First flip-flop synchronizes the input
    d_flip_flop dff1 (
        .clk(sample_clk),
        .rst_a_p(rst_a_p),
        .d(button_in),
        .q(ff1)
    );
    
    // Second flip-flop detects stable signal
    d_flip_flop dff2 (
        .clk(sample_clk),
        .rst_a_p(rst_a_p),
        .d(ff1),
        .q(ff2)
    );
    
    // Debounced button output
    wire debounced_btn;
    assign debounced_btn = (ff1 == ff2) ? ff2 : 1'b0;
    
    // Third flip-flop to capture previous debounced value
    wire ff3;
    d_flip_flop dff3 (
        .clk(sample_clk),
        .rst_a_p(rst_a_p),
        .d(debounced_btn),
        .q(ff3)
    );
    
    // One-shot pulse output - high when debounced is high and previous was low
    assign pulse_out = debounced_btn & ~ff3;
endmodule

 module d_flip_flop (
 input wire clk,       // Clock input
 input wire rst_a_p,   // Active high reset
 input wire d,         // Data input
 output reg q          // Data output
);
 // Simple D flip-flop implementation
 always @(posedge clk, posedge rst_a_p) begin
      if (rst_a_p) begin
            q <= 1'b0;
      end else begin
            q <= d;
      end
 end
 endmodule