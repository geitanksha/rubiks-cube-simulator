module control(input clk, Reset, Run, input [7:0] keycode, output [7:0] keycode_, output move_f, Reset_state);

	enum logic [2:0]{Reset_, Wait, move_wait, move} curr_state, next_state;
	


	always_ff @ (posedge clk)
	begin
		if(Reset)
			curr_state <= Reset_;
		else 
			curr_state <= next_state;
	end
	
	
	always_comb begin
	
		next_state = curr_state;
		
		unique case (curr_state)
		
			Reset_ : next_state = Wait;
			Wait : if(keycode!=0) next_state = move_wait;
			move_wait :  next_state = move;
			move: if(keycode == 0)next_state = Wait;
			
		endcase
		
		
		case(curr_state)
			Reset_ : begin
							move_f = 0;
							Reset_state = 1;
							keycode_ = 0;
						end
			
			Wait : 	begin
							move_f = 0;
							Reset_state = 0;
							keycode_ = 0;
						end
		
			move_wait :	begin
								move_f = 1;
								Reset_state = 0;
								keycode_ = keycode;
							end 
							
			move	: begin
							move_f = 0;
							Reset_state = 0;
							keycode_ = 0;
						end
						
		endcase
	end

endmodule

