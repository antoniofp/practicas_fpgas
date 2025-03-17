module one_shot #(
    parameter DEBOUNCE_TIME_MS = 10     // Tiempo de debounce en milisegundos
)(
    input wire clk,          // Reloj del sistema
    input wire rst_a_p,      // Reset activo alto
    input wire button_in,    // Entrada sucia del botón
    output reg pulse_out     // Salida del pulso one-shot
);
    wire debounced_button;   // Señal limpia despues del debouncer
    reg button_prev;         // Para detectar el flanco ascendente
    
    // Instanciamos el debouncer para limpiar la señal
    debouncer #(DEBOUNCE_TIME_MS) debouncer1 (
        .clk(clk),
        .rst_a_p(rst_a_p),
        .button_in(button_in),
        .button_out(debounced_button)
    );
    
    always @(posedge clk or posedge rst_a_p) begin
        if (rst_a_p) begin
            button_prev <= 1'b0;
            pulse_out <= 1'b0;
        end else begin
            // Guardamos el valor actual para el siguiente ciclo
            button_prev <= debounced_button;
            // Solo se activa en el flanco ascendente de la señal limpia
            pulse_out <= debounced_button && !button_prev;
        end
    end
endmodule