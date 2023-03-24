module  Rubiks_Cube ( input clk, input blank, Reset_h, Run_h, input [9:0] DrawX, DrawY, input [7:0] keycode,
                       output pixel_clk,
							 output [3:0]  Red, Green, Blue );
	logic started_;
	
	logic [2:0] Cube[6][3][3];
	logic [2:0]CubeCopy[6][3][3];
	logic [11:0] Palette[6];
	logic flag;
	logic [1:0] y_,z_;
	logic[2:0] x_;
	
	logic [2:0] x;
	logic [1:0] y, z;
	
	logic move_f;
	logic line;
	logic move_clockwise;
	logic Reset_state;
	logic [7:0] keycode_;
	
	control fsm(.clk(clk), .Reset(Reset_h), .keycode(keycode), .Run(Run_h), .keycode_(keycode_), .move_f(move_f), .Reset_state(Reset_state));
	//Palette Initialization
	
	always_comb begin//Palette Initialization
	Palette[0] = 12'hf80; //orange
	Palette[1] = 12'hfff; //white
	Palette[2] = 12'h0c0; //green
	Palette[3] = 12'hff0; //yellow
	Palette[4] = 12'hf00; //red
	Palette[5] = 12'h00f; //blue
	end


//Cube Manipulations, Updating Registers

always_ff @(posedge clk) begin //Front
	
	//Cube Initialization
	
	if(Reset_state) begin //Cube Initialization
	
		for(x_ = 0; x_<=5; x_++)begin
			for(y_ = 0; y_<=2; y_++)begin
				for(z_ = 0; z_<=2; z_++)begin
					Cube[x_][y_][z_] <= x_;
					CubeCopy[x_][y_][z_] <= x_;

				end
			end
		end
		started_ = 0;////////change
	end 
	
	// F
	
	else if (move_f && keycode_ == 8'h09) begin //F Rotate front clockwise
		started_ = 1; ////////change
		CubeCopy = Cube;
		Cube[1][2][0] <= CubeCopy[0][2][2];
		Cube[1][2][1] <= CubeCopy[0][1][2];
		Cube[1][2][2] <= CubeCopy[0][0][2];
		Cube[0][0][2] <= CubeCopy[3][0][0];
		Cube[0][1][2] <= CubeCopy[3][0][1];
		Cube[0][2][2] <= CubeCopy[3][0][2];
		Cube[3][0][0] <= CubeCopy[4][2][0];
		Cube[3][0][1] <= CubeCopy[4][1][0];
		Cube[3][0][2] <= CubeCopy[4][0][0];
		Cube[4][0][0] <= CubeCopy[1][2][0];
		Cube[4][1][0] <= CubeCopy[1][2][1];
		Cube[4][2][0] <= CubeCopy[1][2][2];
		Cube[2][0][0] <= CubeCopy[2][2][0];
		Cube[2][0][1] <= CubeCopy[2][1][0];
		Cube[2][0][2] <= CubeCopy[2][0][0];
		Cube[2][1][0] <= CubeCopy[2][2][1];
		Cube[2][1][2] <= CubeCopy[2][0][1];
		Cube[2][2][0] <= CubeCopy[2][2][2];
		Cube[2][2][1] <= CubeCopy[2][1][2];
		Cube[2][2][2] <= CubeCopy[2][0][2];
		
		end
		
   // G (F')
		
	else if (move_f && keycode_ == 8'h0a) begin //F' Rotate front anticlockwise
		started_ = 1; ////////change
		CubeCopy = Cube;
		Cube[1][2][0] <= CubeCopy[4][0][0];
		Cube[1][2][1] <= CubeCopy[4][1][0];
		Cube[1][2][2] <= CubeCopy[4][2][0];
		Cube[0][0][2] <= CubeCopy[1][2][2];
		Cube[0][1][2] <= CubeCopy[1][2][1];
		Cube[0][2][2] <= CubeCopy[1][2][0];
		Cube[3][0][0] <= CubeCopy[0][0][2];
		Cube[3][0][1] <= CubeCopy[0][1][2];
		Cube[3][0][2] <= CubeCopy[0][2][2];
		Cube[4][0][0] <= CubeCopy[3][0][2];
		Cube[4][1][0] <= CubeCopy[3][0][1];
		Cube[4][2][0] <= CubeCopy[3][0][0];
		Cube[2][0][0] <= CubeCopy[2][0][2];
		Cube[2][0][1] <= CubeCopy[2][1][2];
		Cube[2][0][2] <= CubeCopy[2][2][2];
		Cube[2][1][0] <= CubeCopy[2][0][1];
		Cube[2][1][2] <= CubeCopy[2][2][1];
		Cube[2][2][0] <= CubeCopy[2][0][0];
		Cube[2][2][1] <= CubeCopy[2][1][0];
		Cube[2][2][2] <= CubeCopy[2][2][0];
		end
	
	// M
		
	else if (move_f && keycode_ == 8'h10) begin //M Push middle tiles upwards
		started_ = 1; ////////change
		CubeCopy = Cube;
		//face 1 gets face 2
		Cube[1][0][1] <= CubeCopy[2][0][1];
		Cube[1][1][1] <= CubeCopy[2][1][1];
		Cube[1][2][1] <= CubeCopy[2][2][1];
		//face 2 gets face 3
		Cube[2][0][1] <= CubeCopy[3][0][1];
		Cube[2][1][1] <= CubeCopy[3][1][1];
		Cube[2][2][1] <= CubeCopy[3][2][1];
		//face 3 gets face 5
		Cube[3][0][1] <= CubeCopy[5][2][1];
		Cube[3][1][1] <= CubeCopy[5][1][1];
		Cube[3][2][1] <= CubeCopy[5][0][1];
		//face 5 gets face 1
		Cube[5][0][1] <= CubeCopy[1][2][1];
		Cube[5][1][1] <= CubeCopy[1][1][1];
		Cube[5][2][1] <= CubeCopy[1][0][1];
 end
 
	// < (M')
	 
	else if (move_f && keycode_ == 8'h36) begin //M' Push middle tiles downwards
		started_ = 1; ////////change
		CubeCopy = Cube;
		//face 2 gets face 1
		Cube[2][0][1] <= CubeCopy[1][0][1];
		Cube[2][1][1] <= CubeCopy[1][1][1];
		Cube[2][2][1] <= CubeCopy[1][2][1];
		//face 3 gets face 2
		Cube[3][0][1] <= CubeCopy[2][0][1];
		Cube[3][1][1] <= CubeCopy[2][1][1];
		Cube[3][2][1] <= CubeCopy[2][2][1];
		//face 5 gets face 3
		Cube[5][0][1] <= CubeCopy[3][2][1];
		Cube[5][1][1] <= CubeCopy[3][1][1];
		Cube[5][2][1] <= CubeCopy[3][0][1];
		//face 1 gets face 5
		Cube[1][0][1] <= CubeCopy[5][2][1];
		Cube[1][1][1] <= CubeCopy[5][1][1];
		Cube[1][2][1] <= CubeCopy[5][0][1];
 end

	// ->
	
	else if (move_f && keycode_ == 8'h4f) begin //-> Turn cube rightwards
		started_ = 1; ////////change
		CubeCopy = Cube;
		Cube[1][0][0] <= CubeCopy[1][0][2];
		Cube[1][0][1] <= CubeCopy[1][1][2];
		Cube[1][0][2] <= CubeCopy[1][2][2];
		Cube[1][1][0] <= CubeCopy[1][0][1];
		Cube[1][1][2] <= CubeCopy[1][2][1];
		Cube[1][2][0] <= CubeCopy[1][0][0];
		Cube[1][2][1] <= CubeCopy[1][1][0];
		Cube[1][2][2] <= CubeCopy[1][2][0];
		//bottom changes
		Cube[3][0][0] <= CubeCopy[3][2][0];
		Cube[3][0][1] <= CubeCopy[3][1][0];
		Cube[3][0][2] <= CubeCopy[3][0][0];
		Cube[3][1][0] <= CubeCopy[3][2][1];
		Cube[3][1][2] <= CubeCopy[3][0][1];
		Cube[3][2][0] <= CubeCopy[3][2][2];
		Cube[3][2][1] <= CubeCopy[3][1][2];
		Cube[3][2][2] <= CubeCopy[3][0][2];
		//changing left face:
		Cube[0][0][0] <= CubeCopy[5][0][0];
		Cube[0][0][1] <= CubeCopy[5][0][1];
		Cube[0][0][2] <= CubeCopy[5][0][2];
		Cube[0][1][0] <= CubeCopy[5][1][0];
		Cube[0][1][1] <= CubeCopy[5][1][1];
		Cube[0][1][2] <= CubeCopy[5][1][2];
		Cube[0][2][0] <= CubeCopy[5][2][0];
		Cube[0][2][1] <= CubeCopy[5][2][1];
		Cube[0][2][2] <= CubeCopy[5][2][2];
		//changing central face:
		Cube[2][0][0] <= CubeCopy[0][0][0];
		Cube[2][0][1] <= CubeCopy[0][0][1];
		Cube[2][0][2] <= CubeCopy[0][0][2];
		Cube[2][1][0] <= CubeCopy[0][1][0];
		Cube[2][1][1] <= CubeCopy[0][1][1];
		Cube[2][1][2] <= CubeCopy[0][1][2];
		Cube[2][2][0] <= CubeCopy[0][2][0];
		Cube[2][2][1] <= CubeCopy[0][2][1];
		Cube[2][2][2] <= CubeCopy[0][2][2];
		//changing right face:
		Cube[4][0][0] <= CubeCopy[2][0][0];
		Cube[4][0][1] <= CubeCopy[2][0][1];
		Cube[4][0][2] <= CubeCopy[2][0][2];
		Cube[4][1][0] <= CubeCopy[2][1][0];
		Cube[4][1][1] <= CubeCopy[2][1][1];
		Cube[4][1][2] <= CubeCopy[2][1][2];
		Cube[4][2][0] <= CubeCopy[2][2][0];
		Cube[4][2][1] <= CubeCopy[2][2][1];
		Cube[4][2][2] <= CubeCopy[2][2][2];
		//changing back face:
		Cube[5][0][0] <= CubeCopy[4][0][0];
		Cube[5][0][1] <= CubeCopy[4][0][1];
		Cube[5][0][2] <= CubeCopy[4][0][2];
		Cube[5][1][0] <= CubeCopy[4][1][0];
		Cube[5][1][1] <= CubeCopy[4][1][1];
		Cube[5][1][2] <= CubeCopy[4][1][2];
		Cube[5][2][0] <= CubeCopy[4][2][0];
		Cube[5][2][1] <= CubeCopy[4][2][1];
		Cube[5][2][2] <= CubeCopy[4][2][2];
	end
	
	// <-
	
	else if (move_f && keycode_ == 8'h50) begin //<- Turn cube leftwards
		started_ = 1; ////////change
		CubeCopy = Cube;
		Cube[1][0][0] <= CubeCopy[1][2][0];
		Cube[1][0][1] <= CubeCopy[1][1][0];
		Cube[1][0][2] <= CubeCopy[1][0][0];
		Cube[1][1][0] <= CubeCopy[1][2][1];
		Cube[1][1][2] <= CubeCopy[1][0][1];
		Cube[1][2][0] <= CubeCopy[1][2][2];
		Cube[1][2][1] <= CubeCopy[1][1][2];
		Cube[1][2][2] <= CubeCopy[1][0][2];
		//bottom changes
		Cube[3][0][0] <= CubeCopy[3][0][2];
		Cube[3][0][1] <= CubeCopy[3][1][2];
		Cube[3][0][2] <= CubeCopy[3][2][2];
		Cube[3][1][0] <= CubeCopy[3][0][1];
		Cube[3][1][2] <= CubeCopy[3][2][1];
		Cube[3][2][0] <= CubeCopy[3][0][0];
		Cube[3][2][1] <= CubeCopy[3][1][0];
		Cube[3][2][2] <= CubeCopy[3][2][0];
		//changing left face: //done
		Cube[0][0][0] <= CubeCopy[2][0][0];
		Cube[0][0][1] <= CubeCopy[2][0][1];
		Cube[0][0][2] <= CubeCopy[2][0][2];
		Cube[0][1][0] <= CubeCopy[2][1][0];
		Cube[0][1][1] <= CubeCopy[2][1][1];
		Cube[0][1][2] <= CubeCopy[2][1][2];
		Cube[0][2][0] <= CubeCopy[2][2][0];
		Cube[0][2][1] <= CubeCopy[2][2][1];
		Cube[0][2][2] <= CubeCopy[2][2][2];
		//changing central face: //done
		Cube[2][0][0] <= CubeCopy[4][0][0];
		Cube[2][0][1] <= CubeCopy[4][0][1];
		Cube[2][0][2] <= CubeCopy[4][0][2];
		Cube[2][1][0] <= CubeCopy[4][1][0];
		Cube[2][1][1] <= CubeCopy[4][1][1];
		Cube[2][1][2] <= CubeCopy[4][1][2];
		Cube[2][2][0] <= CubeCopy[4][2][0];
		Cube[2][2][1] <= CubeCopy[4][2][1];
		Cube[2][2][2] <= CubeCopy[4][2][2];
		//changing right face: //done
		Cube[4][0][0] <= CubeCopy[5][0][0];
		Cube[4][0][1] <= CubeCopy[5][0][1];
		Cube[4][0][2] <= CubeCopy[5][0][2];
		Cube[4][1][0] <= CubeCopy[5][1][0];
		Cube[4][1][1] <= CubeCopy[5][1][1];
		Cube[4][1][2] <= CubeCopy[5][1][2];
		Cube[4][2][0] <= CubeCopy[5][2][0];
		Cube[4][2][1] <= CubeCopy[5][2][1];
		Cube[4][2][2] <= CubeCopy[5][2][2];
		//changing back face:
		Cube[5][0][0] <= CubeCopy[0][0][0];
		Cube[5][0][1] <= CubeCopy[0][0][1];
		Cube[5][0][2] <= CubeCopy[0][0][2];
		Cube[5][1][0] <= CubeCopy[0][1][0];
		Cube[5][1][1] <= CubeCopy[0][1][1];
		Cube[5][1][2] <= CubeCopy[0][1][2];
		Cube[5][2][0] <= CubeCopy[0][2][0];
		Cube[5][2][1] <= CubeCopy[0][2][1];
		Cube[5][2][2] <= CubeCopy[0][2][2];
		end
	
	
	// Up arrow
  
   else if (move_f && keycode_ == 8'h52) begin //^ Rotate cube upwards
		started_ = 1; ////////change
		CubeCopy = Cube;
		//left face - face 0
		Cube[0][0][0] <= CubeCopy[0][0][2];
		Cube[0][0][1] <= CubeCopy[0][1][2];
		Cube[0][0][2] <= CubeCopy[0][2][2];
		Cube[0][1][0] <= CubeCopy[0][0][1];
		Cube[0][1][2] <= CubeCopy[0][2][1];
		Cube[0][2][0] <= CubeCopy[0][0][0];
		Cube[0][2][1] <= CubeCopy[0][1][0];
		Cube[0][2][2] <= CubeCopy[0][2][0];
		//right face - 4
		Cube[4][0][0] <= CubeCopy[4][2][0];
		Cube[4][0][1] <= CubeCopy[4][1][0];
		Cube[4][0][2] <= CubeCopy[4][0][0];
		Cube[4][1][0] <= CubeCopy[4][2][1];
		Cube[4][1][2] <= CubeCopy[4][0][1];
		Cube[4][2][0] <= CubeCopy[4][2][2];
		Cube[4][2][1] <= CubeCopy[4][1][2];
		Cube[4][2][2] <= CubeCopy[4][0][2];
		//face 1 gets face 2 //changing face top
		Cube[1][0][0] <= CubeCopy[2][0][0];
		Cube[1][0][1] <= CubeCopy[2][0][1];
		Cube[1][0][2] <= CubeCopy[2][0][2];
		Cube[1][1][0] <= CubeCopy[2][1][0];
		Cube[1][1][1] <= CubeCopy[2][1][1];
		Cube[1][1][2] <= CubeCopy[2][1][2];
		Cube[1][2][0] <= CubeCopy[2][2][0];
		Cube[1][2][1] <= CubeCopy[2][2][1];
		Cube[1][2][2] <= CubeCopy[2][2][2];
		//face 2 gets face 3 //changing face center
		Cube[2][0][0] <= CubeCopy[3][0][0];
		Cube[2][0][1] <= CubeCopy[3][0][1];
		Cube[2][0][2] <= CubeCopy[3][0][2];
		Cube[2][1][0] <= CubeCopy[3][1][0];
		Cube[2][1][1] <= CubeCopy[3][1][1];
		Cube[2][1][2] <= CubeCopy[3][1][2];
		Cube[2][2][0] <= CubeCopy[3][2][0];
		Cube[2][2][1] <= CubeCopy[3][2][1];
		Cube[2][2][2] <= CubeCopy[3][2][2];
		//face 3 gets face 5 //changing face bottom
		Cube[3][0][0] <= CubeCopy[5][2][2];
		Cube[3][0][1] <= CubeCopy[5][2][1];
		Cube[3][0][2] <= CubeCopy[5][2][0];
		Cube[3][1][0] <= CubeCopy[5][1][2];
		Cube[3][1][1] <= CubeCopy[5][1][1];
		Cube[3][1][2] <= CubeCopy[5][1][0];
		Cube[3][2][0] <= CubeCopy[5][0][2];
		Cube[3][2][1] <= CubeCopy[5][0][1];
		Cube[3][2][2] <= CubeCopy[5][0][0];
		//face 5 gets face 1 //changing face back
		Cube[5][0][0] <= CubeCopy[1][2][2];
		Cube[5][0][1] <= CubeCopy[1][2][1];
		Cube[5][0][2] <= CubeCopy[1][2][0];
		Cube[5][1][0] <= CubeCopy[1][1][2];
		Cube[5][1][1] <= CubeCopy[1][1][1];
		Cube[5][1][2] <= CubeCopy[1][1][0];
		Cube[5][2][0] <= CubeCopy[1][0][2];
		Cube[5][2][1] <= CubeCopy[1][0][1];
		Cube[5][2][2] <= CubeCopy[1][0][0];
	  end
 


   // Down Arrow 

   else if (move_f && keycode_ == 8'h51) begin //v Rotate cube downwards
		started_ = 1; ////////change
      CubeCopy = Cube;
      //left face
      Cube[0][0][0] <= CubeCopy[0][2][0];
      Cube[0][0][1] <= CubeCopy[0][1][0];
      Cube[0][0][2] <= CubeCopy[0][0][0];
      Cube[0][1][0] <= CubeCopy[0][2][1];
      Cube[0][1][2] <= CubeCopy[0][0][1];
      Cube[0][2][0] <= CubeCopy[0][2][2];
      Cube[0][2][1] <= CubeCopy[0][1][2];
      Cube[0][2][2] <= CubeCopy[0][0][2];
      //right face
      Cube[4][0][0] <= CubeCopy[4][0][2];
      Cube[4][0][1] <= CubeCopy[4][1][2];
      Cube[4][0][2] <= CubeCopy[4][2][2];
      Cube[4][1][0] <= CubeCopy[4][0][1];
      Cube[4][1][2] <= CubeCopy[4][2][1];
      Cube[4][2][0] <= CubeCopy[4][0][0];
      Cube[4][2][1] <= CubeCopy[4][1][0];
      Cube[4][2][2] <= CubeCopy[4][2][0];
      //face 1 gets face 5 //changing face top
      Cube[1][0][0] <= CubeCopy[5][2][2];
      Cube[1][0][1] <= CubeCopy[5][2][1];
      Cube[1][0][2] <= CubeCopy[5][2][0];
      Cube[1][1][0] <= CubeCopy[5][1][2];
      Cube[1][1][1] <= CubeCopy[5][1][1];
      Cube[1][1][2] <= CubeCopy[5][1][0];
      Cube[1][2][0] <= CubeCopy[5][0][2];
      Cube[1][2][1] <= CubeCopy[5][0][1];
      Cube[1][2][2] <= CubeCopy[5][0][0];
      //face 2 gets face 1 //changing face center
      Cube[2][0][0] <= CubeCopy[1][0][0];
      Cube[2][0][1] <= CubeCopy[1][0][1];
      Cube[2][0][2] <= CubeCopy[1][0][2];
      Cube[2][1][0] <= CubeCopy[1][1][0];
      Cube[2][1][1] <= CubeCopy[1][1][1];
      Cube[2][1][2] <= CubeCopy[1][1][2];
      Cube[2][2][0] <= CubeCopy[1][2][0];
      Cube[2][2][1] <= CubeCopy[1][2][1];
      Cube[2][2][2] <= CubeCopy[1][2][2];
      //face 3 gets face 2 //changing face bottom
      Cube[3][0][0] <= CubeCopy[2][0][0];
      Cube[3][0][1] <= CubeCopy[2][0][1];
      Cube[3][0][2] <= CubeCopy[2][0][2];
      Cube[3][1][0] <= CubeCopy[2][1][0];
      Cube[3][1][1] <= CubeCopy[2][1][1];
      Cube[3][1][2] <= CubeCopy[2][1][2];
      Cube[3][2][0] <= CubeCopy[2][2][0];
      Cube[3][2][1] <= CubeCopy[2][2][1];
      Cube[3][2][2] <= CubeCopy[2][2][2];
      //face 5 gets face 3 //changing face back
      Cube[5][0][0] <= CubeCopy[3][2][2];
      Cube[5][0][1] <= CubeCopy[3][2][1];
      Cube[5][0][2] <= CubeCopy[3][2][0];
      Cube[5][1][0] <= CubeCopy[3][1][2];
      Cube[5][1][1] <= CubeCopy[3][1][1];
      Cube[5][1][2] <= CubeCopy[3][1][0];
      Cube[5][2][0] <= CubeCopy[3][0][2];
      Cube[5][2][1] <= CubeCopy[3][0][1];
      Cube[5][2][2] <= CubeCopy[3][0][0];
  end
 
   // ] (Clockwise Signal)
 
	else if (move_f && keycode_ == 8'h30) begin //] Rotate cube clockwise
		started_ = 1; ////////change
      CubeCopy = Cube;
		
      //center face
      Cube[2][0][0] <= CubeCopy[2][2][0];
      Cube[2][0][1] <= CubeCopy[2][1][0];
      Cube[2][0][2] <= CubeCopy[2][0][0];
      Cube[2][1][0] <= CubeCopy[2][2][1];
      Cube[2][1][2] <= CubeCopy[2][0][1];
      Cube[2][2][0] <= CubeCopy[2][2][2];
      Cube[2][2][1] <= CubeCopy[2][1][2];
      Cube[2][2][2] <= CubeCopy[2][0][2];
 
      //back face
      Cube[5][0][0] <= CubeCopy[5][0][2];
      Cube[5][0][1] <= CubeCopy[5][1][2];
      Cube[5][0][2] <= CubeCopy[5][2][2];
      Cube[5][1][0] <= CubeCopy[5][0][1];
      Cube[5][1][2] <= CubeCopy[5][2][1];
      Cube[5][2][0] <= CubeCopy[5][0][0];
      Cube[5][2][1] <= CubeCopy[5][1][0];
      Cube[5][2][2] <= CubeCopy[5][2][0];
 
      //face 1 gets face 0
      Cube[1][0][0] <= CubeCopy[0][2][0];
      Cube[1][0][1] <= CubeCopy[0][1][0];
      Cube[1][0][2] <= CubeCopy[0][0][0];
      Cube[1][1][0] <= CubeCopy[0][2][1];
      Cube[1][1][1] <= CubeCopy[0][1][1];
      Cube[1][1][2] <= CubeCopy[0][0][1];
      Cube[1][2][0] <= CubeCopy[0][2][2];
      Cube[1][2][1] <= CubeCopy[0][1][2];
      Cube[1][2][2] <= CubeCopy[0][0][2];
 
      //face 4 gets face 1
      Cube[4][0][0] <= CubeCopy[1][2][0];
      Cube[4][0][1] <= CubeCopy[1][1][0];
      Cube[4][0][2] <= CubeCopy[1][0][0];
      Cube[4][1][0] <= CubeCopy[1][2][1];
      Cube[4][1][1] <= CubeCopy[1][1][1];
      Cube[4][1][2] <= CubeCopy[1][0][1];
      Cube[4][2][0] <= CubeCopy[1][2][2];
      Cube[4][2][1] <= CubeCopy[1][1][2];
      Cube[4][2][2] <= CubeCopy[1][0][2];
 
      //face 3 gets face 4
      Cube[3][0][0] <= CubeCopy[4][2][0];
      Cube[3][0][1] <= CubeCopy[4][1][0];
      Cube[3][0][2] <= CubeCopy[4][0][0];
      Cube[3][1][0] <= CubeCopy[4][2][1];
      Cube[3][1][1] <= CubeCopy[4][1][1];
      Cube[3][1][2] <= CubeCopy[4][0][1];
      Cube[3][2][0] <= CubeCopy[4][2][2];
      Cube[3][2][1] <= CubeCopy[4][1][2];
      Cube[3][2][2] <= CubeCopy[4][0][2];
 
      //face 0 gets face 3
      Cube[0][0][0] <= CubeCopy[3][2][0];
      Cube[0][0][1] <= CubeCopy[3][1][0];
      Cube[0][0][2] <= CubeCopy[3][0][0];
 
      Cube[0][1][0] <= CubeCopy[3][2][1];
      Cube[0][1][1] <= CubeCopy[3][1][1];
      Cube[0][1][2] <= CubeCopy[3][0][1];
 
      Cube[0][2][0] <= CubeCopy[3][2][2];
      Cube[0][2][1] <= CubeCopy[3][1][2];
      Cube[0][2][2] <= CubeCopy[3][0][2];
  end

	// [ (Anticlockwise Signal)
	
	else if (move_f && keycode_ == 8'h2f) begin //[ Rotate cube anticlockwise
		started_ = 1; ////////change
      CubeCopy = Cube;
      //center face
      Cube[2][0][0] <= CubeCopy[2][0][2];
      Cube[2][0][1] <= CubeCopy[2][1][2];
      Cube[2][0][2] <= CubeCopy[2][2][2];
      Cube[2][1][0] <= CubeCopy[2][0][1];
      Cube[2][1][2] <= CubeCopy[2][2][1];
      Cube[2][2][0] <= CubeCopy[2][0][0];
      Cube[2][2][1] <= CubeCopy[2][1][0];
      Cube[2][2][2] <= CubeCopy[2][2][0];
 
      //back face
     Cube[5][0][0] <= CubeCopy[5][2][0];
     Cube[5][0][1] <= CubeCopy[5][1][0];
     Cube[5][0][2] <= CubeCopy[5][0][0];
     Cube[5][1][0] <= CubeCopy[5][2][1];
     Cube[5][1][2] <= CubeCopy[5][0][1];
     Cube[5][2][0] <= CubeCopy[5][2][2];
     Cube[5][2][1] <= CubeCopy[5][1][2];
     Cube[5][2][2] <= CubeCopy[5][0][2];
 
 
      //face 1 gets face 4
      Cube[1][0][0] <= CubeCopy[4][0][2];
      Cube[1][0][1] <= CubeCopy[4][1][2];
      Cube[1][0][2] <= CubeCopy[4][2][2];
      Cube[1][1][0] <= CubeCopy[4][0][1];
      Cube[1][1][1] <= CubeCopy[4][1][1];
      Cube[1][1][2] <= CubeCopy[4][2][1];
      Cube[1][2][0] <= CubeCopy[4][0][0];
      Cube[1][2][1] <= CubeCopy[4][1][0];
      Cube[1][2][2] <= CubeCopy[4][2][0];
 
      //face 4 gets face 3
      Cube[4][0][0] <= CubeCopy[3][0][2];
      Cube[4][0][1] <= CubeCopy[3][1][2];
      Cube[4][0][2] <= CubeCopy[3][2][2];
      Cube[4][1][0] <= CubeCopy[3][0][1];
      Cube[4][1][1] <= CubeCopy[3][1][1];
      Cube[4][1][2] <= CubeCopy[3][2][1];
      Cube[4][2][0] <= CubeCopy[3][0][0];
      Cube[4][2][1] <= CubeCopy[3][1][0];
      Cube[4][2][2] <= CubeCopy[3][2][0];
 
      //face 3 gets face 0
      Cube[3][0][0] <= CubeCopy[0][0][2];
      Cube[3][0][1] <= CubeCopy[0][1][2];
      Cube[3][0][2] <= CubeCopy[0][2][2];
      Cube[3][1][0] <= CubeCopy[0][0][1];
      Cube[3][1][1] <= CubeCopy[0][1][1];
      Cube[3][1][2] <= CubeCopy[0][2][1];
      Cube[3][2][0] <= CubeCopy[0][0][0];
      Cube[3][2][1] <= CubeCopy[0][1][0];
      Cube[3][2][2] <= CubeCopy[0][2][0];
 
      //face 0 gets face 1
      Cube[0][0][0] <= CubeCopy[1][0][2];
      Cube[0][0][1] <= CubeCopy[1][1][2];
      Cube[0][0][2] <= CubeCopy[1][2][2];
      Cube[0][1][0] <= CubeCopy[1][0][1];
      Cube[0][1][1] <= CubeCopy[1][1][1];
      Cube[0][1][2] <= CubeCopy[1][2][1];
      Cube[0][2][0] <= CubeCopy[1][0][0];
      Cube[0][2][1] <= CubeCopy[1][1][0];
      Cube[0][2][2] <= CubeCopy[1][2][0];
  end

   // R
  
   else if (move_f && keycode_ == 8'h15) begin //R Push right tiles upward
		started_ = 1; ////////change
      CubeCopy = Cube;
      
      //right face
      Cube[4][0][0] <= CubeCopy[4][2][0];
      Cube[4][0][1] <= CubeCopy[4][1][0];
      Cube[4][0][2] <= CubeCopy[4][0][0];
      Cube[4][1][0] <= CubeCopy[4][2][1];
      Cube[4][1][2] <= CubeCopy[4][0][1];
      Cube[4][2][0] <= CubeCopy[4][2][2];
      Cube[4][2][1] <= CubeCopy[4][1][2];
      Cube[4][2][2] <= CubeCopy[4][0][2];
      //face 1 gets face 2 //changing face top
      Cube[1][0][2] <= CubeCopy[2][0][2];
      Cube[1][1][2] <= CubeCopy[2][1][2];
      Cube[1][2][2] <= CubeCopy[2][2][2];
      //face 2 gets face 3 //changing face center
      Cube[2][0][2] <= CubeCopy[3][0][2];
      Cube[2][1][2] <= CubeCopy[3][1][2];
      Cube[2][2][2] <= CubeCopy[3][2][2];
      //face 3 gets face 5 //changing face bottom
      Cube[3][0][2] <= CubeCopy[5][2][0];
      Cube[3][1][2] <= CubeCopy[5][1][0];
      Cube[3][2][2] <= CubeCopy[5][0][0];
      //face 5 gets face 1 //changing face back
      Cube[5][0][0] <= CubeCopy[1][2][2];
      Cube[5][1][0] <= CubeCopy[1][1][2];
      Cube[5][2][0] <= CubeCopy[1][0][2];
  end
  
   // T (R')
  
	else if (move_f && keycode_ == 8'h17) begin //R' Push right tiles downward
		started_ = 1; ////////change
      CubeCopy = Cube;
      
      //right face
      Cube[4][0][0] <= CubeCopy[4][0][2];
      Cube[4][0][1] <= CubeCopy[4][1][2];
      Cube[4][0][2] <= CubeCopy[4][2][2];
      Cube[4][1][0] <= CubeCopy[4][0][1];
      Cube[4][1][2] <= CubeCopy[4][2][1];
      Cube[4][2][0] <= CubeCopy[4][0][0];
      Cube[4][2][1] <= CubeCopy[4][1][0];
      Cube[4][2][2] <= CubeCopy[4][2][0];
      //face 1 gets face 5 //changing face top
      Cube[1][0][2] <= CubeCopy[5][2][0];
      Cube[1][1][2] <= CubeCopy[5][1][0];
      Cube[1][2][2] <= CubeCopy[5][0][0];
      //face 2 gets face 1 //changing face center
      Cube[2][0][2] <= CubeCopy[1][0][2];
      Cube[2][1][2] <= CubeCopy[1][1][2];
      Cube[2][2][2] <= CubeCopy[1][2][2];
      //face 3 gets face 2 //changing face bottom
      Cube[3][0][2] <= CubeCopy[2][0][2];
      Cube[3][1][2] <= CubeCopy[2][1][2];
      Cube[3][2][2] <= CubeCopy[2][2][2];
      //face 5 gets face 3 //changing face back
      Cube[5][0][0] <= CubeCopy[3][2][2];
      Cube[5][1][0] <= CubeCopy[3][1][2];
      Cube[5][2][0] <= CubeCopy[3][0][2];
  end
  
   // U

	else if (move_f && keycode_ == 8'h18) begin //U Push top tiles to left
		started_ = 1; ////////change
		CubeCopy = Cube;

		//top changes
		Cube[1][0][0] <= CubeCopy[1][2][0];
		Cube[1][0][1] <= CubeCopy[1][1][0];
		Cube[1][0][2] <= CubeCopy[1][0][0];
		Cube[1][1][0] <= CubeCopy[1][2][1];
		Cube[1][1][2] <= CubeCopy[1][0][1];
		Cube[1][2][0] <= CubeCopy[1][2][2];
		Cube[1][2][1] <= CubeCopy[1][1][2];
		Cube[1][2][2] <= CubeCopy[1][0][2];
		//changing left face: //done
		Cube[0][0][0] <= CubeCopy[2][0][0];
		Cube[0][0][1] <= CubeCopy[2][0][1];
		Cube[0][0][2] <= CubeCopy[2][0][2];
		//changing central face: //done
		Cube[2][0][0] <= CubeCopy[4][0][0];
		Cube[2][0][1] <= CubeCopy[4][0][1];
		Cube[2][0][2] <= CubeCopy[4][0][2];
		//changing right face: //done
		Cube[4][0][0] <= CubeCopy[5][0][0];
		Cube[4][0][1] <= CubeCopy[5][0][1];
		Cube[4][0][2] <= CubeCopy[5][0][2];
		//changing back face:
		Cube[5][0][0] <= CubeCopy[0][0][0];
		Cube[5][0][1] <= CubeCopy[0][0][1];
		Cube[5][0][2] <= CubeCopy[0][0][2];
		end

	// I (U')
	
	else if (move_f && keycode_ == 8'h0c) begin //U' Push top tiles to right
		started_ = 1; ////////change
		CubeCopy = Cube;
		//top changes
		 Cube[1][0][0] <= CubeCopy[1][0][2];
		Cube[1][0][1] <= CubeCopy[1][1][2];
		Cube[1][0][2] <= CubeCopy[1][2][2];
		Cube[1][1][0] <= CubeCopy[1][0][1];
		Cube[1][1][2] <= CubeCopy[1][2][1];
		Cube[1][2][0] <= CubeCopy[1][0][0];
		Cube[1][2][1] <= CubeCopy[1][1][0];
		Cube[1][2][2] <= CubeCopy[1][2][0];

		//changing left face:
		Cube[0][0][0] <= CubeCopy[5][0][0];
		Cube[0][0][1] <= CubeCopy[5][0][1];
		Cube[0][0][2] <= CubeCopy[5][0][2];
		//changing central face:
		Cube[2][0][0] <= CubeCopy[0][0][0];
		Cube[2][0][1] <= CubeCopy[0][0][1];
		Cube[2][0][2] <= CubeCopy[0][0][2];
		//changing right face:
		Cube[4][0][0] <= CubeCopy[2][0][0];
		Cube[4][0][1] <= CubeCopy[2][0][1];
		Cube[4][0][2] <= CubeCopy[2][0][2];
		//changing back face:
		Cube[5][0][0] <= CubeCopy[4][0][0];
		Cube[5][0][1] <= CubeCopy[4][0][1];
		Cube[5][0][2] <= CubeCopy[4][0][2];
	end

	// B
	
	else if (move_f && keycode_ == 8'h05) begin //B Push back tiles leftward
		started_ = 1; ////////change
		CubeCopy = Cube;

		//back face
		Cube[5][0][0] <= CubeCopy[5][2][0];
		Cube[5][0][1] <= CubeCopy[5][1][0];
		Cube[5][0][2] <= CubeCopy[5][0][0];
		Cube[5][1][0] <= CubeCopy[5][2][1];
		Cube[5][1][2] <= CubeCopy[5][0][1];
		Cube[5][2][0] <= CubeCopy[5][2][2];
		Cube[5][2][1] <= CubeCopy[5][1][2];
		Cube[5][2][2] <= CubeCopy[5][0][2];


		//face 1 gets face 4
		Cube[1][0][0] <= CubeCopy[4][0][2];
		Cube[1][0][1] <= CubeCopy[4][1][2];
		Cube[1][0][2] <= CubeCopy[4][2][2];

		//face 4 gets face 3]
		Cube[4][0][2] <= CubeCopy[3][2][2];
		Cube[4][1][2] <= CubeCopy[3][2][1];
		Cube[4][2][2] <= CubeCopy[3][2][0];

		//face 3 gets face 0
		Cube[3][2][0] <= CubeCopy[0][0][0];
		Cube[3][2][1] <= CubeCopy[0][1][0];
		Cube[3][2][2] <= CubeCopy[0][2][0];

		//face 0 gets face 1
		Cube[0][0][0] <= CubeCopy[1][0][2];
		Cube[0][1][0] <= CubeCopy[1][0][1];
		Cube[0][2][0] <= CubeCopy[1][0][0];
  end

   // N (B’)
	 
	else if (move_f && keycode_ == 8'h11) begin //B' Push back tiles rightward
		started_ = 1; ////////change
      CubeCopy = Cube;

      //back face
      Cube[5][0][0] <= CubeCopy[5][0][2];
      Cube[5][0][1] <= CubeCopy[5][1][2];
      Cube[5][0][2] <= CubeCopy[5][2][2];
      Cube[5][1][0] <= CubeCopy[5][0][1];
      Cube[5][1][2] <= CubeCopy[5][2][1];
      Cube[5][2][0] <= CubeCopy[5][0][0];
      Cube[5][2][1] <= CubeCopy[5][1][0];
      Cube[5][2][2] <= CubeCopy[5][2][0];
 
      //face 1 gets face 0
      Cube[1][0][0] <= CubeCopy[0][2][0];
      Cube[1][0][1] <= CubeCopy[0][1][0];
      Cube[1][0][2] <= CubeCopy[0][0][0];

      //face 4 gets face 1
      Cube[4][0][2] <= CubeCopy[1][0][0];
      Cube[4][1][2] <= CubeCopy[1][0][1];
      Cube[4][2][2] <= CubeCopy[1][0][2];
 
      //face 3 gets face 4
      Cube[3][2][0] <= CubeCopy[4][2][2];
      Cube[3][2][1] <= CubeCopy[4][1][2];
      Cube[3][2][2] <= CubeCopy[4][0][2];
 
      //face 0 gets face 3
      Cube[0][0][0] <= CubeCopy[3][2][0];
      Cube[0][1][0] <= CubeCopy[3][2][1];
      Cube[0][2][0] <= CubeCopy[3][2][2];
  end



	// D
	
	else if (move_f && keycode_ == 8'h07) begin //D Push down tiles rightward
		started_ = 1; ////////change
		CubeCopy = Cube;

		//bottom changes
		Cube[3][0][0] <= CubeCopy[3][2][0];
		Cube[3][0][1] <= CubeCopy[3][1][0];
		Cube[3][0][2] <= CubeCopy[3][0][0];
		Cube[3][1][0] <= CubeCopy[3][2][1];
		Cube[3][1][2] <= CubeCopy[3][0][1];
		Cube[3][2][0] <= CubeCopy[3][2][2];
		Cube[3][2][1] <= CubeCopy[3][1][2];
		Cube[3][2][2] <= CubeCopy[3][0][2];
		//changing left face: - 0
		Cube[0][2][0] <= CubeCopy[5][2][0];
		Cube[0][2][1] <= CubeCopy[5][2][1];
		Cube[0][2][2] <= CubeCopy[5][2][2];
		//changing central face: - 2
		Cube[2][2][0] <= CubeCopy[0][2][0];
		Cube[2][2][1] <= CubeCopy[0][2][1];
		Cube[2][2][2] <= CubeCopy[0][2][2];
		//changing right face: - 4
		Cube[4][2][0] <= CubeCopy[2][2][0];
		Cube[4][2][1] <= CubeCopy[2][2][1];
		Cube[4][2][2] <= CubeCopy[2][2][2];
		//changing back face:
		Cube[5][2][0] <= CubeCopy[4][2][0];
		Cube[5][2][1] <= CubeCopy[4][2][1];
		Cube[5][2][2] <= CubeCopy[4][2][2];
	end

	
	
   
	
	//S (D')
	
	else if (move_f && keycode_ == 8'h16) begin //D' Push down tiles leftward
		started_ = 1; ////////change
		CubeCopy = Cube;
		//bottom changes
		Cube[3][0][0] <= CubeCopy[3][0][2];
		Cube[3][0][1] <= CubeCopy[3][1][2];
		Cube[3][0][2] <= CubeCopy[3][2][2];
		Cube[3][1][0] <= CubeCopy[3][0][1];
		Cube[3][1][2] <= CubeCopy[3][2][1];
		Cube[3][2][0] <= CubeCopy[3][0][0];
		Cube[3][2][1] <= CubeCopy[3][1][0];
		Cube[3][2][2] <= CubeCopy[3][2][0];
		//changing left face - 0
		Cube[0][2][0] <= CubeCopy[2][2][0];
		Cube[0][2][1] <= CubeCopy[2][2][1];
		Cube[0][2][2] <= CubeCopy[2][2][2];
		//changing central face: 2
		Cube[2][2][0] <= CubeCopy[4][2][0];
		Cube[2][2][1] <= CubeCopy[4][2][1];
		Cube[2][2][2] <= CubeCopy[4][2][2];
		//changing right face: - 4
		Cube[4][2][0] <= CubeCopy[5][2][0];
		Cube[4][2][1] <= CubeCopy[5][2][1];
		Cube[4][2][2] <= CubeCopy[5][2][2];
		//changing back face: - 5
		Cube[5][2][0] <= CubeCopy[0][2][0];
		Cube[5][2][1] <= CubeCopy[0][2][1];
		Cube[5][2][2] <= CubeCopy[0][2][2];
   end

	
	
	
	
	// L
	
	else if (move_f && keycode_ == 8'h0f) begin //L Push the left tiles downward
		started_ = 1; ////////change
      CubeCopy = Cube;
      //left face
      Cube[0][0][0] <= CubeCopy[0][2][0];
      Cube[0][0][1] <= CubeCopy[0][1][0];
      Cube[0][0][2] <= CubeCopy[0][0][0];
      Cube[0][1][0] <= CubeCopy[0][2][1];
      Cube[0][1][2] <= CubeCopy[0][0][1];
      Cube[0][2][0] <= CubeCopy[0][2][2];
      Cube[0][2][1] <= CubeCopy[0][1][2];
      Cube[0][2][2] <= CubeCopy[0][0][2];
     
      //face 1 gets face 5 //changing face top
      Cube[1][0][0] <= CubeCopy[5][2][2];
      Cube[1][1][0] <= CubeCopy[5][1][2];
      Cube[1][2][0] <= CubeCopy[5][0][2];
      //face 2 gets face 1 //changing face center
      Cube[2][0][0] <= CubeCopy[1][0][0];
      Cube[2][1][0] <= CubeCopy[1][1][0];
      Cube[2][2][0] <= CubeCopy[1][2][0];
      //face 3 gets face 2 //changing face bottom
      Cube[3][0][0] <= CubeCopy[2][0][0];
      Cube[3][1][0] <= CubeCopy[2][1][0];
      Cube[3][2][0] <= CubeCopy[2][2][0];
      //face 5 gets face 3 //changing face back
      Cube[5][0][2] <= CubeCopy[3][2][0];
      Cube[5][1][2] <= CubeCopy[3][1][0];
      Cube[5][2][2] <= CubeCopy[3][0][0];
  end
  
  
	// ; (L')
	
	else if (move_f && keycode_ == 8'h33) begin //L' Push the left tiles upward
		started_ = 1; ////////change
		CubeCopy = Cube;
		//left face - face 0
		Cube[0][0][0] <= CubeCopy[0][0][2];
		Cube[0][0][1] <= CubeCopy[0][1][2];
		Cube[0][0][2] <= CubeCopy[0][2][2];
		Cube[0][1][0] <= CubeCopy[0][0][1];
		Cube[0][1][2] <= CubeCopy[0][2][1];
		Cube[0][2][0] <= CubeCopy[0][0][0];
		Cube[0][2][1] <= CubeCopy[0][1][0];
		Cube[0][2][2] <= CubeCopy[0][2][0];

		//face 1 gets face 2 //changing face top
		Cube[1][0][0] <= CubeCopy[2][0][0];
		Cube[1][1][0] <= CubeCopy[2][1][0];
		Cube[1][2][0] <= CubeCopy[2][2][0];
		//face 2 gets face 3 //changing face center
		Cube[2][0][0] <= CubeCopy[3][0][0];
		Cube[2][1][0] <= CubeCopy[3][1][0];
		Cube[2][2][0] <= CubeCopy[3][2][0];
		//face 3 gets face 5 //changing face bottom
		Cube[3][0][0] <= CubeCopy[5][2][2];
		Cube[3][1][0] <= CubeCopy[5][1][2];
		Cube[3][2][0] <= CubeCopy[5][0][2];
		//face 5 gets face 1 //changing face back
		Cube[5][0][2] <= CubeCopy[1][2][0];
		Cube[5][1][2] <= CubeCopy[1][1][0];
		Cube[5][2][2] <= CubeCopy[1][0][0];
  end
  
	// Space (Undo)
	
   else if (move_f && keycode_ == 8'h2c) begin //Undo
      //CubeCopy = Cube;
		started_ = 0;
		//left face
      Cube[0][0][0] <= CubeCopy[0][0][0];
      Cube[0][0][1] <= CubeCopy[0][0][1];
      Cube[0][0][2] <= CubeCopy[0][0][2];
      Cube[0][1][0] <= CubeCopy[0][1][0];
      Cube[0][1][1] <= CubeCopy[0][1][1];
      Cube[0][1][2] <= CubeCopy[0][1][2];
      Cube[0][2][0] <= CubeCopy[0][2][0];
      Cube[0][2][1] <= CubeCopy[0][2][1];
		Cube[0][2][2] <= CubeCopy[0][2][2];
		
		//top face
      Cube[1][0][0] <= CubeCopy[1][0][0];
      Cube[1][0][1] <= CubeCopy[1][0][1];
      Cube[1][0][2] <= CubeCopy[1][0][2];
      Cube[1][1][0] <= CubeCopy[1][1][0];
      Cube[1][1][1] <= CubeCopy[1][1][1];
      Cube[1][1][2] <= CubeCopy[1][1][2];
      Cube[1][2][0] <= CubeCopy[1][2][0];
      Cube[1][2][1] <= CubeCopy[1][2][1];
		Cube[1][2][2] <= CubeCopy[1][2][2];
		
      //center face
      Cube[2][0][0] <= CubeCopy[2][0][0];
      Cube[2][0][1] <= CubeCopy[2][0][1];
      Cube[2][0][2] <= CubeCopy[2][0][2];
      Cube[2][1][0] <= CubeCopy[2][1][0];
      Cube[2][1][1] <= CubeCopy[2][1][1];
		Cube[2][1][2] <= CubeCopy[2][1][2];
      Cube[2][2][0] <= CubeCopy[2][2][0];
      Cube[2][2][1] <= CubeCopy[2][2][1];
      Cube[2][2][2] <= CubeCopy[2][2][2];
		 
      //bottom face
      Cube[3][0][0] <= CubeCopy[3][0][0];
      Cube[3][0][1] <= CubeCopy[3][0][1];
      Cube[3][0][2] <= CubeCopy[3][0][2];
      Cube[3][1][0] <= CubeCopy[3][1][0];
      Cube[3][1][1] <= CubeCopy[3][1][1];
      Cube[3][1][2] <= CubeCopy[3][1][2];
      Cube[3][2][0] <= CubeCopy[3][2][0];
      Cube[3][2][1] <= CubeCopy[3][2][1];
		Cube[3][2][2] <= CubeCopy[3][2][2];
			
		//right face
      Cube[4][0][0] <= CubeCopy[4][0][0];
      Cube[4][0][1] <= CubeCopy[4][0][1];
      Cube[4][0][2] <= CubeCopy[4][0][2];
      Cube[4][1][0] <= CubeCopy[4][1][0];
      Cube[4][1][1] <= CubeCopy[4][1][1];
      Cube[4][1][2] <= CubeCopy[4][1][2];
      Cube[4][2][0] <= CubeCopy[4][2][0];
      Cube[4][2][1] <= CubeCopy[4][2][1];
		Cube[4][2][2] <= CubeCopy[4][2][2];

      //back face
      Cube[5][0][0] <= CubeCopy[5][0][0];
      Cube[5][0][1] <= CubeCopy[5][0][1];
      Cube[5][0][2] <= CubeCopy[5][0][2];
      Cube[5][1][0] <= CubeCopy[5][1][0];
      Cube[5][1][1] <= CubeCopy[5][1][1];
      Cube[5][1][2] <= CubeCopy[5][1][2];
      Cube[5][2][0] <= CubeCopy[5][2][0];
      Cube[5][2][1] <= CubeCopy[5][2][1];
		Cube[5][2][2] <= CubeCopy[5][2][2];
  end
  
  
   
	// Enter Key (Reset)
	
	else if (move_f && keycode_ == 8'h28) begin //Reset
      CubeCopy = Cube;
		started_ = 0;
		//left face
      Cube[0][0][0] <= 0;
      Cube[0][0][1] <= 0;
      Cube[0][0][2] <= 0;
      Cube[0][1][0] <= 0;
      Cube[0][1][1] <= 0;
      Cube[0][1][2] <= 0;
      Cube[0][2][0] <= 0;
      Cube[0][2][1] <= 0;
		Cube[0][2][2] <= 0;
		
		//top face
      Cube[1][0][0] <= 1;
      Cube[1][0][1] <= 1;
      Cube[1][0][2] <= 1;
      Cube[1][1][0] <= 1;
      Cube[1][1][1] <= 1;
      Cube[1][1][2] <= 1;
      Cube[1][2][0] <= 1;
      Cube[1][2][1] <= 1;
		Cube[1][2][2] <= 1;
		
      //center face
      Cube[2][0][0] <= 2;
      Cube[2][0][1] <= 2;
      Cube[2][0][2] <= 2;
      Cube[2][1][0] <= 2;
      Cube[2][1][1] <= 2;
		Cube[2][1][2] <= 2;
      Cube[2][2][0] <= 2;
      Cube[2][2][1] <= 2;
      Cube[2][2][2] <= 2;
 
		 
      //bottom face
      Cube[3][0][0] <= 3;
      Cube[3][0][1] <= 3;
      Cube[3][0][2] <= 3;
      Cube[3][1][0] <= 3;
      Cube[3][1][1] <= 3;
      Cube[3][1][2] <= 3;
      Cube[3][2][0] <= 3;
      Cube[3][2][1] <= 3;
		Cube[3][2][2] <= 3;
			
		//right face
      Cube[4][0][0] <= 4;
      Cube[4][0][1] <= 4;
      Cube[4][0][2] <= 4;
      Cube[4][1][0] <= 4;
      Cube[4][1][1] <= 4;
      Cube[4][1][2] <= 4;
      Cube[4][2][0] <= 4;
      Cube[4][2][1] <= 4;
		Cube[4][2][2] <= 4;
		
      //back face
      Cube[5][0][0] <= 5;
      Cube[5][0][1] <= 5;
      Cube[5][0][2] <= 5;
      Cube[5][1][0] <= 5;
      Cube[5][1][1] <= 5;
      Cube[5][1][2] <= 5;
      Cube[5][2][0] <= 5;
      Cube[5][2][1] <= 5;
		Cube[5][2][2] <= 5;
		
		end
 


		 
	
	
	
	
	//Checks if won! - this works but is a little confusing to understand, hence scrapped
	/*
	else if  ( (started_ == 1) 
			  && (Cube[0][0][0]==Cube[0][0][1]) && (Cube[0][0][0]==Cube[0][0][2])
           && (Cube[0][0][0]==Cube[0][1][0]) && (Cube[0][0][0]==Cube[0][1][1]) && (Cube[0][0][0]==Cube[0][1][2])
           && (Cube[0][0][0]==Cube[0][2][0]) && (Cube[0][0][0]==Cube[0][2][1]) && (Cube[0][0][0]==Cube[0][2][2]) //comparisons for face 0 done
           && (Cube[1][0][0]==Cube[1][0][1]) && (Cube[1][0][0]==Cube[1][0][2])
           && (Cube[1][0][0]==Cube[1][1][0]) && (Cube[1][0][0]==Cube[1][1][1]) && (Cube[1][0][0]==Cube[1][1][2])
           && (Cube[1][0][0]==Cube[1][2][0]) && (Cube[1][0][0]==Cube[1][2][1]) && (Cube[1][0][0]==Cube[1][2][2]) //comparisons for face 1 done
           && (Cube[2][0][0]==Cube[2][0][1]) && (Cube[2][0][0]==Cube[2][0][2])
           && (Cube[2][0][0]==Cube[2][1][0]) && (Cube[2][0][0]==Cube[2][1][1]) && (Cube[2][0][0]==Cube[2][1][2])
           && (Cube[2][0][0]==Cube[2][2][0]) && (Cube[2][0][0]==Cube[2][2][1]) && (Cube[2][0][0]==Cube[2][2][2]) //comparisons for face 2 done
           && (Cube[3][0][0]==Cube[3][0][1]) && (Cube[3][0][0]==Cube[3][0][2])
           && (Cube[3][0][0]==Cube[3][1][0]) && (Cube[3][0][0]==Cube[3][1][1]) && (Cube[3][0][0]==Cube[3][1][2])
           && (Cube[3][0][0]==Cube[3][2][0]) && (Cube[3][0][0]==Cube[3][2][1]) && (Cube[3][0][0]==Cube[3][2][2]) //comparisons for face 3 done
           && (Cube[4][0][0]==Cube[4][0][1]) && (Cube[4][0][0]==Cube[4][0][2])
           && (Cube[4][0][0]==Cube[4][1][0]) && (Cube[4][0][0]==Cube[4][1][1]) && (Cube[4][0][0]==Cube[4][1][2])
           && (Cube[4][0][0]==Cube[4][2][0]) && (Cube[4][0][0]==Cube[4][2][1]) && (Cube[4][0][0]==Cube[4][2][2])
   ) begin
		//left face get thumbs up of red
		CubeCopy = Cube;
		Cube[0][0][0] <= CubeCopy[4][0][0];
		Cube[0][1][0] <= CubeCopy[4][0][0];
		Cube[0][1][1] <= CubeCopy[4][0][0];
		Cube[0][2][0] <= CubeCopy[4][0][0];
		Cube[0][2][1] <= CubeCopy[4][0][0];
		//top face get thumbs up of yellow
		Cube[1][0][0] <= CubeCopy[3][0][0];
		Cube[1][1][0] <= CubeCopy[3][0][0];
		Cube[1][1][1] <= CubeCopy[3][0][0];
		Cube[1][2][0] <= CubeCopy[3][0][0];
		Cube[1][2][1] <= CubeCopy[3][0][0];
		//center face get thumbs up of back face
		Cube[2][0][0] <= CubeCopy[5][0][0];
		Cube[2][1][0] <= CubeCopy[5][0][0];
		Cube[2][1][1] <= CubeCopy[5][0][0];
		Cube[2][2][0] <= CubeCopy[5][0][0];
		Cube[2][2][1] <= CubeCopy[5][0][0];
		//bottom face get thumbs up of top face
		Cube[3][0][0] <= CubeCopy[1][0][0];
		Cube[3][1][0] <= CubeCopy[1][0][0];
		Cube[3][1][1] <= CubeCopy[1][0][0];
		Cube[3][2][0] <= CubeCopy[1][0][0];
		Cube[3][2][1] <= CubeCopy[1][0][0];
		//right face get thumbs up of left face
		Cube[4][0][0] <= CubeCopy[0][0][0];
		Cube[4][1][0] <= CubeCopy[0][0][0];
		Cube[4][1][1] <= CubeCopy[0][0][0];
		Cube[4][2][0] <= CubeCopy[0][0][0];
		Cube[4][2][1] <= CubeCopy[0][0][0];
		//back face get thumbs up of center face
		Cube[5][0][0] <= CubeCopy[2][0][0];
		Cube[5][1][0] <= CubeCopy[2][0][0];
		Cube[5][1][1] <= CubeCopy[2][0][0];
		Cube[5][2][0] <= CubeCopy[2][0][0];
		Cube[5][2][1] <= CubeCopy[2][0][0];
   end
	*/

end //end of all register initializations / moves / updates @ always_ff
	
	 
	 //Rendering begins here:
	 
	 always_comb begin
	 
	 //Starting with Main Cube rendering

	 //Top Face of main cube
	 if(DrawY <= (DrawX[9:1]+20) && DrawY>=(-DrawX[9:1]+220)&&DrawY<=(-DrawX[9:1]+340)&&DrawY>=(DrawX[9:1]-100))//Checks within bound of top face
		begin flag = 0; 
		
			if(DrawY == (DrawX[9:1]+20) || DrawY==(-DrawX[9:1]+220)||DrawY==(-DrawX[9:1]+340)||DrawY==(DrawX[9:1]-100)//Checks if line
				|| DrawY==(-DrawX[9:1]+260) || DrawY==(-DrawX[9:1]+300) || DrawY == (DrawX[9:1]-20) || DrawY == (DrawX[9:1]-60))
				line = 1;
			else line = 0;
			x = 1;
			if(DrawY < (DrawX[9:1]+20) && DrawY>(-DrawX[9:1]+220)&&DrawY<(-DrawX[9:1]+260)&&DrawY>(DrawX[9:1]-100))
				z=0;
			else if(DrawY < (DrawX[9:1]+20) && DrawY>(-DrawX[9:1]+260)&&DrawY<(-DrawX[9:1]+300)&&DrawY>(DrawX[9:1]-100))
				z=1;
			else z=2;
			
			if(DrawY < (DrawX[9:1]-60) && DrawY>(-DrawX[9:1]+220)&&DrawY<(-DrawX[9:1]+340)&&DrawY>(DrawX[9:1]-100))
				y=0;
			else if(DrawY < (DrawX[9:1]-20) && DrawY>(-DrawX[9:1]+220)&&DrawY<(-DrawX[9:1]+340)&&DrawY>(DrawX[9:1]-60))
				y=1;
			else y=2;
		end
		
	//Left Face Main Cube
		
	else if(DrawX>=200 && DrawX<=320 && DrawY<=(DrawX[9:1]+170)&&DrawY>(DrawX[9:1]+20))
		begin x=2;
		
		if(DrawX==200||DrawX==240||DrawX==280||DrawX==320||DrawY==(DrawX[9:1]+70)||DrawY==(DrawX[9:1]+120)||DrawY==(DrawX[9:1]+170))
			line=1;
		else line=0;
		if(DrawX>200 && DrawX<240 && DrawY<(DrawX[9:1]+170)&&DrawY>(DrawX[9:1]+20))
			z=0;
		else if(DrawX>240 && DrawX<280 && DrawY<(DrawX[9:1]+170)&&DrawY>(DrawX[9:1]+20))
			z=1;
		else z=2;
		
		if(DrawX>200 && DrawX<320 && DrawY<(DrawX[9:1]+70)&&DrawY>(DrawX[9:1]+20))
			y=0;
		else if(DrawX>200 && DrawX<320 && DrawY<(DrawX[9:1]+120)&&DrawY>(DrawX[9:1]+70))
			y=1;
		else y=2;
		flag=0;
		end
		
	//Right Face Main Cube
	
	else if(DrawX>320 && DrawX<=440 && DrawY<=(-DrawX[9:1]+490)&&DrawY>(-DrawX[9:1]+340))
		begin x=4;
		
		if(DrawX==360||DrawX==400||DrawX==440||DrawY==(-DrawX[9:1]+390)||DrawY==(-DrawX[9:1]+440)||DrawY==(-DrawX[9:1]+490))
			line=1;
		else line=0;
		
		if(DrawX>320 && DrawX<360 && DrawY<(-DrawX[9:1]+490)&&DrawY>(-DrawX[9:1]+340))
			z=0;
		else if(DrawX>360 && DrawX<400 && DrawY<(-DrawX[9:1]+490)&&DrawY>(-DrawX[9:1]+340))
			z=1;
		else z=2;
		
		if(DrawX>320 && DrawX<440 && DrawY<(-DrawX[9:1]+390)&&DrawY>(-DrawX[9:1]+340))
			y=0;
		else if(DrawX>320 && DrawX<440 && DrawY<(-DrawX[9:1]+440)&&DrawY>(-DrawX[9:1]+390))
			y=1;
		else y=2;
		flag=0;
	end	
	
	//Exterior faces rendering:
	
	//Left face exterior cube
	
	else if(DrawX>=120 && DrawX<=180 && DrawY<=(-DrawX[9:1]+240)&&DrawY>=(-DrawX[9:1]+150))
		begin x=0;
		
		if(DrawX==120||DrawX==140||DrawX==160||DrawX==180||DrawY==(-DrawX[9:1]+150)
				||DrawY==(-DrawX[9:1]+180)||DrawY==(-DrawX[9:1]+210)||DrawY==(-DrawX[9:1]+240))
			line=1;
		else line=0;
		
		if(DrawX>120 && DrawX<140 && DrawY<(-DrawX[9:1]+240)&&DrawY>(-DrawX[9:1]+150))
			z=2;
		else if(DrawX>140 && DrawX<160 && DrawY<(-DrawX[9:1]+240)&&DrawY>(-DrawX[9:1]+150))
			z=1;
		else z=0;
		
		if(DrawX>120 && DrawX<180 && DrawY<(-DrawX[9:1]+180)&&DrawY>(-DrawX[9:1]+150))
			y=0;
		else if(DrawX>120 && DrawX<180 && DrawY<(-DrawX[9:1]+210)&&DrawY>(-DrawX[9:1]+180))
			y=1;
		else y=2;
		flag=0;
	end
	
	//Right face exterior cube
	
	else if(DrawX>=460 && DrawX<=520 && DrawY<=(DrawX[9:1]-80)&&DrawY>=(DrawX[9:1]-170))
		begin x=5;

		if(DrawX==460||DrawX==480||DrawX==500||DrawX==520||DrawY==(DrawX[9:1]-170)
				||DrawY==(DrawX[9:1]-140)||DrawY==(DrawX[9:1]-110)||DrawY==(DrawX[9:1]-80))
		  line=1;
		else line=0;

		if(DrawX>460 && DrawX<480 && DrawY<(DrawX[9:1]-80)&&DrawY>(DrawX[9:1]-170))
		  z=2;
		else if(DrawX>480 && DrawX<500 && DrawY<(DrawX[9:1]-80)&&DrawY>(DrawX[9:1]-170))
		  z=1;
		else z=0;

		if(DrawX>460 && DrawX<520 && DrawY<(DrawX[9:1]-140)&&DrawY>(DrawX[9:1]-170))
		  y=0;
		else if(DrawX>460 && DrawX<520 && DrawY<(DrawX[9:1]-110)&&DrawY>(DrawX[9:1]-140))
		  y=1;
		else y=2;
		flag=0;
		end
	
	//Bottom face exterior cube

	  else if(DrawY <= (DrawX[9:1]+250) && DrawY>=(-DrawX[9:1]+510)&&DrawY<=(-DrawX[9:1]+570)&&DrawY>=(DrawX[9:1]+190))//Checks within bound of bottom face
      begin flag = 0;
      
		if(DrawY == (DrawX[9:1]+190) || DrawY==(-DrawX[9:1]+510)||DrawY==(-DrawX[9:1]+530)||DrawY==(DrawX[9:1]+210)//Checks if line
			|| DrawY==(-DrawX[9:1]+550) || DrawY==(-DrawX[9:1]+570) || DrawY == (DrawX[9:1]+230) || DrawY == (DrawX[9:1]+250))
			line = 1;
		else line = 0;
		x = 3;
		if(DrawY < (DrawX[9:1]+250) && DrawY>(-DrawX[9:1]+510)&&DrawY<(-DrawX[9:1]+570)&&DrawY>(DrawX[9:1]+230))
			y=0;
		else if(DrawY < (DrawX[9:1]+230) && DrawY>(-DrawX[9:1]+510)&&DrawY<(-DrawX[9:1]+570)&&DrawY>(DrawX[9:1]+210))
			y=1;
		else y=2;

		if(DrawY < (DrawX[9:1]+250) && DrawY>(-DrawX[9:1]+510)&&DrawY<(-DrawX[9:1]+530)&&DrawY>(DrawX[9:1]+190))
			z=0;
		else if(DrawY < (DrawX[9:1]+250) && DrawY>(-DrawX[9:1]+530)&&DrawY<(-DrawX[9:1]+550)&&DrawY>(DrawX[9:1]+190))
			z=1;
		else z=2;
       end

	
	
	
	/////////////////////////////////////////// End of Rendering main cube and exteriors
	
	
	//Mapped / Net Cube Rendering
	
		else if((DrawX >= 30 && DrawX <= 60 && DrawY >= 390 && DrawY <= 420) || //0: orange
    (DrawX >= 60 && DrawX <= 90 && DrawY >= 360 && DrawY <= 390) ||  //1: grey
    (DrawX >= 60 && DrawX <= 90 && DrawY >= 390 && DrawY <= 420) || //2: green
    (DrawX >= 60 && DrawX <= 90 && DrawY >= 420 && DrawY <= 450) ||  //3: yellow
    (DrawX >= 90 && DrawX <= 120 && DrawY >= 390 && DrawY <= 420) || //4: red
    (DrawX >= 120 && DrawX <= 150 && DrawY >= 390 && DrawY <= 420) )  //5: blue
		begin
     flag = 0; //within color bounds
	  
	  if(DrawX == 30 || DrawX == 40 ||DrawX == 50 ||DrawX == 60||DrawX == 70 ||DrawX == 80 ||DrawX == 90 ||DrawX == 100
	  ||DrawX == 110 ||DrawX == 120 ||DrawX == 130 ||DrawX == 140||DrawX == 150
	  ||DrawY == 360||DrawY == 370||DrawY == 380||DrawY == 390||DrawY == 400||DrawY == 410||DrawY == 420||
	  DrawY == 430||DrawY == 440||DrawY == 450)
	  line=1;
	  else line=0;
      
            //taking care of x coord
            if (DrawX > 30 && DrawX < 60)
                 x = 0; //orange
            else if (DrawX > 60 && DrawX < 90) begin
                 if (DrawY > 360 && DrawY < 390)
                       x = 1; //grey
                 else if (DrawY > 390 && DrawY < 420)
                       x = 2; //green
                 else //if (DrawY > 299 && DrawY <= 419)
                       x = 3; //yellow
            end
            else if (DrawX > 90 && DrawX < 120)
                 x = 4; //red
            else
                 x = 5;
 
            //taking care of z coord:   //cols
            if ( (DrawX > 30 && DrawX < 40) || (DrawX > 60 && DrawX < 70) || (DrawX > 90 && DrawX < 100) || (DrawX > 120 && DrawX < 130)) begin
                 z = 0;
            end
            else if ( (DrawX > 40 && DrawX < 50) || (DrawX > 70 && DrawX < 80) || (DrawX > 100 && DrawX < 110) || (DrawX > 130 && DrawX < 140) )begin
                 z = 1;
            end
            else begin//if ( (DrawX > 279 && DrawX <= 319) || (DrawX > 159 && DrawX <= 199) || (DrawX > 399 && DrawX <= 439) || (DrawX > 519 && DrawX <= 559) )begin
                 z = 2;
            end
 
            //taking care of y coord: //rows
 
            if ( (DrawY > 360 && DrawY < 370) || (DrawY > 390 && DrawY < 400) || (DrawY > 420 && DrawY < 430) ) begin
                 y = 0;
            end
            else if ( (DrawY > 370 && DrawY < 380) || (DrawY > 400 && DrawY < 410) || (DrawY > 430 && DrawY < 440) ) begin
                 y = 1;
            end
            else begin // if ( (DrawY > 139 && DrawY <= 179) || (DrawY > 259 && DrawY <= 299) || (DrawY > 379 && DrawY <= 419) ) begin
                 y = 2;
            end
 
			  
	end


		
////////////////////////// //end of rendering overall
		
		else begin 
			flag = 1;
			x=0;
			y=0;
			z=0;	
			line = 0;
		end
end
		
	
	
   //printing the colors // setting pixel values

	always_comb// @(posedge pixel_clk)    begin
	begin
		 if(!blank||line) begin
	 
            Red = 4'h0;
            Green = 4'h0;
            Blue = 4'h0;
				end		
	
	else if(flag) begin
				
				Red = 4'hb;
            Green = 4'he;
            Blue = 4'he;
				
		end
	
	else begin
				Red = Palette[Cube[x][y][z]][11:8];
            Green = Palette[Cube[x][y][z]][7:4];
            Blue = Palette[Cube[x][y][z]][3:0];
				end
              
       end 
    
endmodule
