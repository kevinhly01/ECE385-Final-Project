module  obstype1 ( input Reset, frame_clk,collision,rdy,
					input [7:0] key,rand_out,
					input [9:0] ballx, bally, balls,
               output [9:0]  ObsX, ObsY, ObsW, ObsH,
					output gameover, ld_en, score);
    
    logic [9:0] Obs_X_Pos, Obs_X_Motion, Obs_Y_Pos, Obs_Y_Motion, Obs_Width, Obs_Height;
	logic gg,load,points;
		
//Obstacle Oject Parameters	

	//Later possibly need to randomly genertate start position
	//For now, estimate start at right side of screen
   parameter [9:0] Obs_Y_Center=240;  // Center position on the Y axis
	 parameter [9:0] Obs_X_Center=820;  // Center position on the Y axis
													//300 PIXEL GAP between obstacles
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
	 assign Obs_Height = 75; 

	
	
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Obs
        if (Reset)  // Asynchronous Reset
        begin 
            Obs_Y_Motion <= 10'd0; //Obs_Y_Step;
				Obs_X_Motion <= 10'd0; //Obs_X_Step;
				Obs_Y_Pos <= Obs_Y_Center;
				Obs_X_Pos <= Obs_X_Center;
				gg = 0;
				
				load = 1;
				points = 0;
				

        end
		  
		  else if (!rdy)
		  begin
				//dont move
			   Obs_Y_Motion <= 10'd0; //Obs_Y_Step;
				Obs_X_Motion <= 10'd0; //Obs_X_Step;
				Obs_Y_Pos <= Obs_Y_Pos;
				Obs_X_Pos <= Obs_X_Pos;
				gg = 0;
				load = 0;
				points = 0;
		  end
	/*	  if (collision)  // Asynchronous Reset
        begin 
            Obs_Y_Motion <= 10'd0; //Obs_Y_Step;
				Obs_X_Motion <= 10'd0; //Obs_X_Step;
				Obs_Y_Pos <= Obs_Y_Center;
				Obs_X_Pos <= Obs_X_Center;
        end*/
           
        else
		   begin 
				//IF COLLISION
				if(// Check if Rotors on Helicopter Collide
						(Obs_X_Pos - Obs_Width <= ballx + 86 &&
					    Obs_X_Pos - Obs_Width  >= ballx &&
						 Obs_Y_Pos - Obs_Height <= bally + 26 &&
						 Obs_Y_Pos - Obs_Height >= bally) ||
						 
						 
						 // Check if top of helicopter collides
						 (Obs_X_Pos - Obs_Width <= ballx + 86 &&
					    Obs_X_Pos - Obs_Width  >= ballx &&
						 Obs_Y_Pos + Obs_Height >= bally &&
						 Obs_Y_Pos + Obs_Height <= bally + 26) ||
		
					((ballx >= Obs_X_Pos - Obs_Width + Obs_X_Step) &&
					(ballx <= Obs_X_Pos + Obs_Width + Obs_X_Step) &&
					(bally >= Obs_Y_Pos - Obs_Height) &&
					(bally <= Obs_Y_Pos + Obs_Height)) 
					
				)
				begin
				Obs_Y_Motion <= 10'd0; //Obs_Y_Step;
				Obs_X_Motion <= 10'd0; //Obs_X_Step;
				Obs_Y_Pos <= Obs_Y_Pos;
				Obs_X_Pos <= Obs_X_Pos;
				gg=1;
				points = 0;
				end
				
					/*else if(((2*rand_out+100) >=380) && (Obs_X_Pos-Obs_Width/2<=1))
					begin
						//Obs_Y_Motion <= 10'd0; //Obs_Y_Step;
						Obs_X_Motion <= Obs_X_Step;
						Obs_Y_Pos <= rand_out+rand_out/4;
						Obs_X_Pos <= 840; //why does this happen only every like third time???????
						gg = 0;
						load = 0;
						points = 1;
					
					end*/

				  else if (Obs_X_Pos-Obs_Width/2<=10)
				  begin
						//dont move
						//Obs_Y_Motion <= 10'd0; //Obs_Y_Step;
						Obs_X_Motion <= Obs_X_Step;
						Obs_Y_Pos <= 2*rand_out+100;
						Obs_X_Pos <= 680; //why does this happen only every like third time???????
						gg = 0;
						load = 0;
						points = 0;
				  end

				
				else 
				begin
			//obs movement HERE
			   Obs_X_Motion <= Obs_X_Step;
			   Obs_Y_Pos <= (Obs_Y_Pos + Obs_Y_Motion);  // Update Obs position
			   Obs_X_Pos <= (Obs_X_Pos + Obs_X_Motion);
				gg = 0;
				load = 0;
				points = 0;
			
				end
			end
	
			
    end
       
    assign ObsX = Obs_X_Pos;  
    assign ObsY = Obs_Y_Pos;
    assign ObsW = Obs_Width;
	 assign ObsH = Obs_Height;
	 
    assign gameover = gg;
	 assign ld_en = load;
	 assign score = points;

endmodule
