module door_animation(
    input wire open_btn, clk, rst_a_p,
    output reg person_in,
    output reg [9:0] leds
);
    reg [4:0] current_state, next_state;
    reg door_cycle_complete;
    wire clk_slow;
    
    clk_div #(2) slow_clk (
        .clk_in(clk),
        .rst_a_p(rst_a_p),
        .clk_out(clk_slow)
    );
    
    // Sequential block - registers
    always @(posedge clk_slow or posedge rst_a_p) begin
        if (rst_a_p) begin
            current_state <= 0;
            person_in <= 0;
        end
        else begin
            current_state <= next_state;
            // Update person_in based on state
            if (current_state == 9)
                person_in <= 1;
            else
					person_in <= person_in;
        end
    end
    
    // Combinational block - next state logic and outputs
    always @(current_state, open_btn) begin
        // Default assignments
        next_state = current_state;
        leds = 10'b1111111111;
		  door_cycle_complete = 0;
        case(current_state)
            0: begin 
                leds = 10'b1111111111;
                if(open_btn)
                    next_state = 1;
            end
            1: begin 
                leds = 10'b1111001111;
                next_state = 2;
            end
            2: begin
                leds = 10'b1110000111;
                next_state = 3;
            end
            3: begin
                leds = 10'b1100000011;
                next_state = 4;
            end
            4: begin
                leds = 10'b1000000001;
                next_state = 5;
            end
            5: begin // Door fully open
                leds = 10'b0000000000;
                next_state = 6;
            end
            6: begin // Start closing
                leds = 10'b1000000001;
                next_state = 7;
            end
            7: begin
                leds = 10'b1100000011;
                next_state = 8;
            end
            8: begin
                leds = 10'b1110000111;
                next_state = 9;
            end
            9: begin
                leds = 10'b1111001111;
                next_state = 0;
                door_cycle_complete = 1;
            end
        endcase
    end
endmodule