module password (
input clk, rst_a_p,
input [9:0] switches,
output reg [1:0] disp_state, // 0 is nothing, 1 is error, 2 is done, 3 is in process
output reg [2:0] disp_debug 
);


wire [9:0] switch_pulse;



genvar i;
generate
    for(i=0; i<10; i=i+1) begin: one_shot_generator  //nombre del bucle
        one_shot #(10) oneshot_inst (  //  nombre descriptivo a la instancia
            .clk(clk),      
            .rst_a_p(rst_a_p),   
            .button_in(switches[i]), 
            .pulse_out(switch_pulse[i])  
        );  
    end  
endgenerate 

reg [2:0] current_state, next_state; //registro para guardar estados

 //1er always - Sequential logic for state register
 always @(posedge clk or posedge rst_a_p) begin
 	disp_debug <= current_state;
	  if(rst_a_p)
			current_state <= 0; //el estado conocido
	  else 
		begin
			current_state <= next_state;
			case (current_state)
			0:
				disp_state <= 0;
			1:
				disp_state <= 1;
			2:
				disp_state <= 3;
			3:
				disp_state <= 3;
			4:
				disp_state <= 3;
			5:
				disp_state <= 2;
			default:
				disp_state <= 0;
			endcase
			
		end
 end
 
 
 //logica combinacional para cambiar le estado
always @(current_state, switch_pulse) begin
	case (current_state)
	0: begin //idle and check first digit
		if (switch_pulse[9:0]==10'b0000000100)
		begin
			next_state = 2;
		end
		else if (switch_pulse[9:0]==10'b0000000000) //idle case
		begin
			next_state = current_state;
		end
		else //error case
			next_state = 1;

	end
	
	1: begin
		if (switch_pulse[9:0]==10'b0000000000)//stay in error if nothing is pressed
		begin
			next_state=current_state;
		end
		else
			next_state=0;
		
	end

	2: begin //sec digit check
		if (switch_pulse[9:0]==10'b0000000001)
		begin
			next_state = 3;
		end
		else if (switch_pulse[9:0]==10'b0000000000) //idle case
		begin
			next_state = current_state;
		end
		else //error case
			next_state = 1;
	end
	
	3: begin
		if (switch_pulse[9:0]==10'b0000000010) //third digit check
		begin
			next_state = 4;
		end
		else if (switch_pulse[9:0]==10'b0000000000) //idle case
		begin
			next_state = current_state;
		end
		else //error case
			next_state = 1;
	end
	
	4: begin
		if (switch_pulse[9:0]==10'b0001000000) //fourth digit check
		begin
			next_state = 5;
		end
		else if (switch_pulse[9:0]==10'b0000000000) //idle case
		begin
			next_state = current_state;
		end
		else //error case
			next_state = 1;
	end
	
	5: begin //done
		if (switch_pulse[9:0]==10'b0000000000) //idle in the done
		begin
			next_state = current_state;
		end
		else
			next_state = 0;
		end

		default: begin
			next_state = 0;
		end
	endcase
end



endmodule