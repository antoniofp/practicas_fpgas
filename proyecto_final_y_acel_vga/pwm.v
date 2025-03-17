module pwm (
    input rst_a_p, clk, btn_inc, btn_dec,
    output reg pwm_signal
);
    wire up_pulse, down_pulse;  
    reg [19:0] counter = 0;
    reg [19:0] duty_cycle = 0;
    localparam count_increase = 5_000;
    
    one_shot #(10) one_shot_up (
        .clk(clk),
        .rst_a_p(rst_a_p),
        .button_in(btn_inc),
        .pulse_out(up_pulse)
    );
    
    one_shot #(10) one_shot_down (
        .clk(clk),
        .rst_a_p(rst_a_p),
        .button_in(btn_dec),
        .pulse_out(down_pulse)
    );
    
    // Actualización del duty cycle
    always @(posedge clk or posedge rst_a_p) begin
        if (rst_a_p)
            duty_cycle <= 25_000;
        else if (up_pulse)
            if (duty_cycle < 125_000)
                duty_cycle <= duty_cycle + count_increase;
            else
                duty_cycle <= 125_000;
        else if (down_pulse)
            if (duty_cycle > 25_000)
                duty_cycle <= duty_cycle - count_increase;
            else
                duty_cycle <= 25_000;
    end
    
    // actualización del contador para el período de 20ms
    always @(posedge clk or posedge rst_a_p) begin
        if (rst_a_p)
            counter <= 0;
        else if (counter < 1_000_000-1)
            counter <= counter + 1;
        else 
            counter <= 0;
    end
    
    // generación de señal PWM
    always @(posedge clk or posedge rst_a_p) begin
        if (rst_a_p)
            pwm_signal <= 0;
        else if (counter < duty_cycle)
            pwm_signal <= 1;
        else
            pwm_signal <= 0;
    end
endmodule