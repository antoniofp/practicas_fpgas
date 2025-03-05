`timescale 1ns/1ns
module pwm_tb();
    // Señales para conectar al DUT
    reg clk;
    reg rst_a_p;
    reg btn_inc;
    reg btn_dec;
    wire pwm_signal;
    
    pwm dut (
        .clk(clk),
        .rst_a_p(rst_a_p),
        .btn_inc(btn_inc),
        .btn_dec(btn_dec),
        .pwm_signal(pwm_signal)
    );
    
    always begin
        #10 clk = ~clk;  // Toggle cada 10ns
    end
    
    // Tiempo total: 100ms = 100,000,000ns
    initial begin
        // Inicializar señales
        clk = 0;
        rst_a_p = 1;
        btn_inc = 0;
        btn_dec = 0;
        
        // Liberar reset después de 100ns
        #100 rst_a_p = 0;
        
        // Aumentar el duty cycle varias veces
        #50000000 btn_inc = 1;  // Presionar botón
        #10000000 btn_inc = 0;  // Soltar botón
		  #50000000 btn_inc = 1;  // Presionar botón
        #10000000 btn_inc = 0;  // Soltar botón
		  #50000000 btn_inc = 1;  // Presionar botón
        #10000000 btn_inc = 0;  // Soltar botón
		  #50000000 btn_inc = 1;  // Presionar botón
        #10000000 btn_inc = 0;  // Soltar botón
		  #50000000 btn_inc = 1;  // Presionar botón
        #10000000 btn_inc = 0;  // Soltar botón
        
        #5000000 btn_inc = 1;
        #1000000 btn_inc = 0;
        
        #5000000 btn_inc = 1;
        #1000000 btn_inc = 0;
        
        // Disminuir el duty cycle
        #1000000 btn_dec = 1;
        #1000000 btn_dec = 0;
        
        #5000000 btn_dec = 1;
        #1000000 btn_dec = 0;
        
        #100_000;
        
        $stop;
    end
    
    // Monitor - opcional
    initial begin
        $monitor("Time=%0t, rst=%b, btn_inc=%b, btn_dec=%b, pwm=%b", 
                 $time, rst_a_p, btn_inc, btn_dec, pwm_signal);
    end
    
endmodule