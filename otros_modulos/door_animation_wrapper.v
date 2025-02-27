module door_animation_wrapper(
    input MAX10_CLK1_50,      // 50MHz clock
    input [1:0] KEY,          // KEY[0] for reset, KEY[1] for open button
    output [9:0] LEDR,        // Animation LEDs
    output [7:0] HEX0         // For displaying state
);
    // Main door animation module
    door_animation door_controller(
        .clk(MAX10_CLK1_50),
        .rst_a_p(~KEY[0]),    // Convert active-low to active-high
        .open_btn(~KEY[1]),   // Convert active-low to active-high
        .person_in(person_inside),
        .leds(LEDR)
    );
    
    // Optional: Display person status on 7-segment
    assign HEX0 = person_inside ? 8'hF9 : 8'hC0; // '1' or '0'
endmodule