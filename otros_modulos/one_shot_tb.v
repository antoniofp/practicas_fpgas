module one_shot_tb();
    // Señales de prueba
    reg clk;
    reg rst_a_p;
    reg button_in;
    wire pulse_out;
    
    // Instanciamos el módulo bajo prueba
    // Asumimos que no necesitamos el debouncer para la prueba simple
    one_shot #(
        .DEBOUNCE_TIME_MS(0.0001) 
    ) dut (
        .clk(clk),
        .rst_a_p(rst_a_p),
        .button_in(button_in),
        .pulse_out(pulse_out)
    );
    

    always #10 clk = ~clk;
    
    // Secuencia de prueba
    initial begin
        // Inicialización
        clk = 0;
        rst_a_p = 1;
        button_in = 0;
        
        // Desactivamos reset después de 20ns
        #20 rst_a_p = 0;
        
        // Esperamos un poco y activamos el botón
        #200 button_in = 1;
        
        // Mantenemos el botón presionado por un tiempo
        #400 button_in = 0;
        
        // Esperamos y presionamos nuevamente
        #200 button_in = 1;
        #400 button_in = 0;
        
        // Terminamos la simulación
        #500 $stop;
    end
endmodule