module pwm_wrapper (
    // Entradas del sistema
    input MAX10_CLK1_50,     // Reloj de 50MHz
    input [1:0] KEY,         // KEY[0] para decrementar, KEY[1] para incrementar
    input [0:0] SW,          // Cambiado a array para mantener consistencia
    // Salidas 
    output [0:0] GPIO          
	 
);
    pwm pwm_inst (
        .rst_a_p(SW[0]),          // Reset activo alto
        .clk(MAX10_CLK1_50),      // Reloj de 50MHz
        .btn_inc(~KEY[1]),        // KEY[1] para incrementar (activo en bajo)
        .btn_dec(~KEY[0]),        // KEY[0] para decrementar (activo en bajo)
        .pwm_signal(GPIO[0])      // Salida PWM al LED[0]
    );
endmodule

