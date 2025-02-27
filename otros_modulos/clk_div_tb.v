`timescale 1ns/1ps

module clk_div_tb();
    // Test parameters - smaller values for visualization
    localparam OUTPUT_FREQ = 20_000_000;  // 10Hz output
    
    // Testbench signals
    reg clk_in;
    reg rst_a_p;
    wire clk_out;
    
    // Instantiate the clock divider
    clk_div #(
        .OUTPUT_FREQ(OUTPUT_FREQ)
    ) DUT (
        .clk_in(clk_in),
        .rst_a_p(rst_a_p),
        .clk_out(clk_out)
    );
    
    // Clock generation - 50Hz for simulation
    initial begin
        clk_in = 0;
        forever #10 clk_in = ~clk_in;
    end
    
    // Simple test sequence
    initial begin
        // Initialize with reset inactive
        rst_a_p = 0;
        
        // Apply reset pulse
        #20 rst_a_p = 1;
        #20 rst_a_p = 0;
        
        // Run for enough time to see multiple output clock cycles
        #5000;
        
        $stop;
    end
    
endmodule