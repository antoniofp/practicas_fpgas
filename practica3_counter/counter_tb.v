module counter_tb;
    // Testbench signals
    reg clk;
    reg rst;
    reg [3:0] data_in;
    reg load;
    reg up_down;
    wire [3:0] count;
    
    // Instantiate the counter
    counter uut (
        .clk(clk),
        .rst(rst),
        .data_in(data_in),
        .load(load),
        .up_down(up_down),
        .count(count)
    );
    
    // Clock generation using always block
    initial begin
        clk = 0;
    end
    
    always #5 clk = ~clk; // 10ns clock period
    
    // Test sequence
    initial begin
        // Initialize inputs
        rst = 1;
        data_in = 4'b0101; // 5 in binary
        load = 0;
        up_down = 1; // Count up
        
        // apply reset
        #20 rst = 0;
        
        #100;
        
        // Test load functionality
        load = 1;
        #10 load = 0;
        
        // Test count down
        #50 up_down = 0;
        
        // Let it count down for a few cycles
        #100;
        
        // Test reset again
        rst = 1;
        #10 rst = 0;
        
        #50 $stop;
    end
    
endmodule