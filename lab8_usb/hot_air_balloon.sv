module hot_air_balloon ( input Reset, frame_clk,rdy, collision,
					input [7:0] key,rand_out,
               output [9:0]  hot_air_balloonX, hot_air_balloonY, hot_air_balloonW, hot_air_balloonH,
					output [9:0] hot_air_balloon2X, hot_air_balloon2Y, hot_air_balloon2W, hot_air_balloon2H);
    
	logic [9:0] hot_air_balloon_X_Pos, hot_air_balloon_X_Motion, hot_air_balloon_Y_Pos, hot_air_balloon_Y_Motion, hot_air_balloon_Width, hot_air_balloon_Height;
	logic [9:0] hot_air_balloon2_X_Pos, hot_air_balloon2_X_Motion, hot_air_balloon2_Y_Pos, hot_air_balloon2_Y_Motion, hot_air_balloon2_Width, hot_air_balloon2_Height;
		
   parameter [9:0] hot_air_balloon_Y_Center=100;  // Center position on the Y axis
	parameter [9:0] hot_air_balloon_X_Center=600;  // Center position on the Y axis
	
	parameter [9:0] hot_air_balloon2_Y_Center=140;  // Center position on the Y axis
	parameter [9:0] hot_air_balloon2_X_Center=350;  // Center position on the Y axis
													//300 PIXEL GAP between hot_air_balloontacles
	 //MAP size
	parameter [9:0] hot_air_balloon_X_Min=0;       // Leftmost point on the X axis
   parameter [9:0] hot_air_balloon_X_Max=639;     // Rightmost point on the X axis
   parameter [9:0] hot_air_balloon_Y_Min=0;       // Topmost point on the Y axis
   parameter [9:0] hot_air_balloon_Y_Max=479;     // Bottommost point on the Y axis
	 
	parameter [9:0] hot_air_balloon_X_Step=-4;      // Step size on the X axis
	parameter [9:0] hot_air_balloon_Y_Step=0;      // Step size on the Y axis
														//0 because we only want it to move horizontal
	  //parameter [9:0] hot_air_balloon_Y_Jump=-10;      // Step size on the Y axis
	  
    assign hot_air_balloon_Width = 58;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
	 assign hot_air_balloon_Height = 63; 

	
	
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_hot_air_balloon
        if (Reset)  // Asynchronous Reset
        begin 
            hot_air_balloon_Y_Motion <= 10'd0; //hot_air_balloon_Y_Step;
				hot_air_balloon_X_Motion <= 10'd0; //hot_air_balloon_X_Step;
				hot_air_balloon_Y_Pos <= hot_air_balloon_Y_Center;
				hot_air_balloon_X_Pos <= hot_air_balloon_X_Center;

				hot_air_balloon2_Y_Motion <= 10'd0; //hot_air_balloon_Y_Step;
				hot_air_balloon2_X_Motion <= 10'd0; //hot_air_balloon_X_Step;
				hot_air_balloon2_Y_Pos <= hot_air_balloon2_Y_Center;
				hot_air_balloon2_X_Pos <= hot_air_balloon2_X_Center;				

        end
		  
		 else if (!rdy)
		  begin
				//dont move
			   hot_air_balloon_Y_Motion <= 10'd0; //hot_air_balloon_Y_Step;
				hot_air_balloon_X_Motion <= 10'd0; //hot_air_balloon_X_Step;
				hot_air_balloon_Y_Pos <= hot_air_balloon_Y_Pos;
				hot_air_balloon_X_Pos <= hot_air_balloon_X_Pos;
		  end
		  
		  else if (collision)  // Asynchronous Reset
        begin 
            hot_air_balloon_Y_Motion <= 10'd0; //hot_air_balloon_Y_Step;
				hot_air_balloon_X_Motion <= 10'd0; //hot_air_balloon_X_Step;
				hot_air_balloon_Y_Pos <= hot_air_balloon_Y_Center;
				hot_air_balloon_X_Pos <= hot_air_balloon_X_Center;
				
				hot_air_balloon2_Y_Motion <= 10'd0; //hot_air_balloon_Y_Step;
				hot_air_balloon2_X_Motion <= 10'd0; //hot_air_balloon_X_Step;
				hot_air_balloon2_Y_Pos <= hot_air_balloon2_Y_Center;
				hot_air_balloon2_X_Pos <= hot_air_balloon2_X_Center;
        end
           
        else
		   begin 
				if (hot_air_balloon_X_Pos<=1 && 2*rand_out >= 300)
					begin
						hot_air_balloon_X_Motion <= hot_air_balloon_X_Step;
						hot_air_balloon_Y_Pos <= rand_out;
						hot_air_balloon_X_Pos <= 840;
					end
					
				else if(hot_air_balloon2_X_Pos<=1 && 2*rand_out >= 300)
					begin
						hot_air_balloon2_X_Motion <= hot_air_balloon_X_Step;
						hot_air_balloon2_Y_Pos <= rand_out;
						hot_air_balloon2_X_Pos <= 840;
					end
					
				else if(hot_air_balloon_X_Pos<=1)
				  begin
						hot_air_balloon_X_Motion <= hot_air_balloon_X_Step;
						hot_air_balloon_Y_Pos <= 2*rand_out;
						hot_air_balloon_X_Pos <= 840;
				  end
				  
				 else if(hot_air_balloon2_X_Pos<=1)
				  begin
						hot_air_balloon2_X_Motion <= hot_air_balloon_X_Step;
						hot_air_balloon2_Y_Pos <= 2*rand_out;
						hot_air_balloon2_X_Pos <= 840;
				  end

				
				else 
				begin
			   hot_air_balloon_X_Motion <= hot_air_balloon_X_Step;
			   hot_air_balloon_Y_Pos <= (hot_air_balloon_Y_Pos + hot_air_balloon_Y_Motion);  // Update hot_air_balloon position
			   hot_air_balloon_X_Pos <= (hot_air_balloon_X_Pos + hot_air_balloon_X_Motion);
				
				hot_air_balloon2_X_Motion <= hot_air_balloon_X_Step;
			   hot_air_balloon2_Y_Pos <= (hot_air_balloon2_Y_Pos);  // Update hot_air_balloon position
			   hot_air_balloon2_X_Pos <= (hot_air_balloon2_X_Pos + hot_air_balloon2_X_Motion);
			
				end
			end
	
			
    end
       
    assign hot_air_balloonX = hot_air_balloon_X_Pos;  
    assign hot_air_balloonY = hot_air_balloon_Y_Pos;
    assign hot_air_balloonW = hot_air_balloon_Width;
	 assign hot_air_balloonH = hot_air_balloon_Height;

	 
	 assign hot_air_balloon2X = hot_air_balloon2_X_Pos;  
    assign hot_air_balloon2Y = hot_air_balloon2_Y_Pos;
    assign hot_air_balloon2W = hot_air_balloon2_Width;
	 assign hot_air_balloon2H = hot_air_balloon2_Height;

endmodule
