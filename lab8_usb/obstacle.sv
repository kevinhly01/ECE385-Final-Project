module  obstacle ( input Reset, frame_clk,collision,rdy,
					input [7:0] key,rand_out,
					input [9:0] ballx, bally, balls,
               output [9:0]  ObsX, ObsY, ObsW, ObsH,
					output [9:0] ObsX_bottom, ObsY_bottom, ObsW_bottom, ObsH_bottom,
					output gameover,score);
    
    logic [9:0] Obs_X_Pos, Obs_X_Motion, Obs_Y_Pos, Obs_Y_Motion, Obs_Width, Obs_Height;
	 logic [9:0] Obs_X_Bot_Pos, Obs_Y_Bot_Pos, Obs_Bot_Width, Obs_Bot_Height;
    logic [9:0] Pipe_Gap, gap;
	 logic gg,points;
		
//Obstacle Oject Parameters	

	//Later possibly need to randomly genertate start position
	//For now, estimate start at right side of screen
   parameter [9:0] Obs_Y_Center=100;  // Center position on the Y axis
	 parameter [9:0] Obs_X_Center=640;  // Center position on the Y axis
	 
	 //MAP size
    parameter [9:0] Obs_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Obs_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Obs_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Obs_Y_Max=479;     // Bottommost point on the Y axis
	 
	 
    
	 parameter [9:0] Obs_X_Step=-7;      // Step size on the X axis
	  parameter [9:0] Obs_Y_Step=0;      // Step size on the Y axis
														//0 because we only want it to move horizontal
	  //parameter [9:0] Obs_Y_Jump=-10;      // Step size on the Y axis
	  
	//TODO Change to width and height later
	//these might also be randomly generated
    assign Obs_Width = 15;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
	 assign Obs_Height = 60; 


	// TODO: Once Get random gen to work, will have to figure out formula to generate height
	 
	assign Obs_Bot_Width= 15;
	assign Obs_Bot_Height= 60;

	// Gap between top pipe and bottom pipe. Might be too big/small
	assign Pipe_Gap= 280 ;
	
	
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Obs
			
        if (Reset)  // Asynchronous Reset
        begin 
            Obs_Y_Motion <= 10'd0; //Obs_Y_Step;
				Obs_X_Motion <= 10'd0; //Obs_X_Step;
				Obs_Y_Pos <= Obs_Y_Center;
				Obs_X_Pos <= Obs_X_Center;
				
			// Do we want it to always start at same spot or random start point?
			// First Pipe Bottom Position
			Obs_X_Bot_Pos <= Obs_X_Center;
			Obs_Y_Bot_Pos <= Obs_Y_Center + Pipe_Gap;
			gg = 0;
			points = 0;
			gap = 0;

        end
		  
		  
		  else if (!rdy)
		  begin
				//dont move
			   Obs_Y_Motion <= 10'd0; //Obs_Y_Step;
				Obs_X_Motion <= 10'd0; //Obs_X_Step;
				Obs_Y_Pos <= Obs_Y_Pos;
				Obs_X_Pos <= Obs_X_Pos;
				Obs_X_Bot_Pos <= Obs_X_Pos;
				Obs_Y_Bot_Pos <= Obs_Y_Pos + Pipe_Gap;
				//Obs_Y_Bot_Pos <= Obs_Y_Pos + rand_out
				gg = 0;
				points = 0;
				gap = 0;
		  end

           
        else
			begin 
					//IF COLLISION
					if (Obs_X_Pos-Obs_Width/2 == 10)
					begin
						gg= 0;
						points = 1;
					end
					else
						points=0;
						gg=0;
					if( (Obs_X_Pos - Obs_Width <= ballx + 86 &&
					    Obs_X_Pos - Obs_Width  >= ballx &&
						 Obs_Y_Pos - Obs_Height <= bally + 26 &&
						 Obs_Y_Pos - Obs_Height >= bally) ||
						 
						 (Obs_X_Pos - Obs_Width <= ballx + 86 &&
					    Obs_X_Pos - Obs_Width  >= ballx &&
						 Obs_Y_Pos + Obs_Height >= bally &&
						 Obs_Y_Pos + Obs_Height <= bally + 26) ||
						 
						 ((ballx >= Obs_X_Pos - Obs_Width + Obs_X_Step) &&
					(ballx <= Obs_X_Pos + Obs_Width + Obs_X_Step) &&
					(bally >= Obs_Y_Pos - Obs_Height) &&
					(bally <= Obs_Y_Pos + Obs_Height))  ||
						 
					((Obs_X_Bot_Pos - Obs_Width <= ballx + 86 &&
					    Obs_X_Bot_Pos - Obs_Width  >= ballx &&
						 Obs_Y_Bot_Pos - Obs_Height <= bally + 26 &&
						 Obs_Y_Bot_Pos - Obs_Height >= bally) ||
						 
						 (Obs_X_Bot_Pos - Obs_Width <= ballx + 86 &&
					    Obs_X_Bot_Pos - Obs_Width  >= ballx &&
						 Obs_Y_Bot_Pos + Obs_Height >= bally &&
						 Obs_Y_Bot_Pos + Obs_Height <= bally + 26))	||
						
						((ballx >= Obs_X_Bot_Pos - Obs_Width + Obs_X_Step) &&
					(ballx <= Obs_X_Bot_Pos + Obs_Width + Obs_X_Step) &&
					(bally >= Obs_Y_Bot_Pos - Obs_Height) &&
					(bally <= Obs_Y_Bot_Pos + Obs_Height)) 
					
					)
					begin
					Obs_Y_Motion <= 10'd0; //Obs_Y_Step;
					Obs_X_Motion <= 10'd0; //Obs_X_Step;
					Obs_Y_Pos <= Obs_Y_Pos;
					Obs_X_Pos <= Obs_X_Pos;
					Obs_X_Bot_Pos <= Obs_X_Pos;
					Obs_Y_Bot_Pos <= Obs_Y_Bot_Pos + rand_out;
					gg = 1;
					end
				
								  //check if obs reaches end of screen, randomize 
				  else if (Obs_X_Pos-Obs_Width/2 <= 10)
				  begin
						//dont move
						//Obs_Y_Motion <= 10'd0; //Obs_Y_Step;
						Obs_X_Motion <= Obs_X_Step;
						Obs_Y_Pos <= rand_out + 100;
						Obs_X_Pos <= 680; 
						
						
						//Obs_Y_Pos <= rand_out + 100;
						Obs_X_Bot_Pos <= 680; 
						Obs_Y_Bot_Pos <= Obs_Y_Pos + rand_out;
						
						gg = 0;
					//	Pipe_Gap = rand_out;
						//load = 1;
				  end
						
				
				else 
				begin
			//obs movement HERE
			   Obs_X_Motion <= Obs_X_Step;
			   Obs_Y_Pos <= (Obs_Y_Pos + Obs_Y_Motion);  // Update Obs position
			   Obs_X_Pos <= (Obs_X_Pos + Obs_X_Motion);
			
				Obs_X_Bot_Pos <= (Obs_X_Bot_Pos + Obs_X_Motion);
				Obs_Y_Bot_Pos <= (Obs_Y_Bot_Pos);					// Y Should never change;
				gg = 0;

				end
		end
	
			
    end
       
    assign ObsX = Obs_X_Pos;  
    assign ObsY = Obs_Y_Pos;
    assign ObsW = Obs_Width;
	 assign ObsH = Obs_Height;
	 
	 
	assign ObsX_bottom = Obs_X_Bot_Pos;
	assign ObsY_bottom = Obs_Y_Bot_Pos;
	assign ObsW_bottom = Obs_Bot_Width;
	assign ObsH_bottom = Obs_Bot_Height;

    assign gameover = gg;
	 assign score = points;

endmodule
