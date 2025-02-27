module FSM_example(
    input clk,
    input rst_a_p,
    input enable,
    output reg FSM_out
);
    parameter A = 0,
              B = 1,
              C = 2,
              D = 3;
    
    //Registros para guardar estado
    reg [1:0] current_state;
    reg [1:0] next_state;
    
    //1er always - Sequential logic for state register
    always @(posedge clk or posedge rst_a_p) begin
        if(rst_a_p)
            current_state <= A; //A el estado conocido; el estado deseado
        else
            current_state <= next_state;
    end
    
    //2do always - Combinational logic for next state
    always @(current_state, enable) begin
        case(current_state)
            A: begin
                if(enable)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                if(enable)
                    next_state = B;
                else
                    next_state = C;
            end
            C: begin
                if(enable)
                    next_state = B;
                else
                    next_state = D;
            end
            D: begin
                if(enable)
                    next_state = B;
                else
                    next_state = A;
            end
        endcase
    end
    
    //3er always - Output logic
    always @(current_state, enable) begin
        case(current_state)
            A: FSM_out = 0;
            B: FSM_out = 0;
            C: FSM_out = 0;
            D: begin
                if(enable)
                    FSM_out = 1;
                else
                    FSM_out = 0;
            end
        endcase
    end
endmodule