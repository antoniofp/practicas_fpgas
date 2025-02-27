

module one_shot_tb();
    // Testbench signals
    reg clk;
    reg rst_a_p;
    reg button_in;
    wire pulse_out;
    
    // Clock generator
    initial begin
        clk = 0;
        forever #10 clk = ~clk;  // 10ns period
    end
    
    // Instantiate the unit under test
    one_shot #(
    .DEBOUNCE_TIME_MS(0.00033)  // 1μs for simulation
	) DUT (
    .clk(clk),
    .rst_a_p(rst_a_p),
    .button_in(button_in),
    .pulse_out(pulse_out)
	);
    
    // Test scenario
    initial begin
        // Initialize inputs
        rst_a_p = 1;
        button_in = 0;
        
        // Apply reset
        #20;
        rst_a_p = 0;
        #20;
        
        // Button presses
        button_in = 1;
        #2000;
        button_in = 0;
        #2000;
        
        button_in = 1;
        #5000;
        button_in = 0;
        #2000;
        
        $stop;
    end
endmodule