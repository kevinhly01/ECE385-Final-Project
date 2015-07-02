module cloud ( input Reset, frame_clk,
					input [7:0] key,rand_out,
               output [9:0]  cloudX, cloudY, cloudW, cloudH,
					output [9:0] cloud2X, cloud2Y, cloud2W, cloud2H);
    
	logic [9:0] cloud_X_Pos, cloud_X_Motion, cloud_Y_Pos, cloud_Y_Motion, cloud_Width, cloud_Height;
	logic [9:0] cloud2_X_Pos, cloud2_X_Motion, cloud2_Y_Pos, cloud2_Y_Motion, cloud2_Width, cloud2_Height;
		
   parameter [9:0] cloud_Y_Center=40;  // Center position on the Y axis
	parameter [9:0] cloud_X_Center=100;  // Center position on the Y axis
	
	parameter [9:0] cloud2_Y_Center=180;  // Center position on the Y axis
	parameter [9:0] cloud2_X_Center=350;  // Center position on the Y axis
													//300 PIXEL GAP between cloudtacles
	 //MAP size
	parameter [9:0] cloud_X_Min=0;       // Leftmost point on the X axis
   parameter [9:0] cloud_X_Max=639;     // Rightmost point on the X axis
   parameter [9:0] cloud_Y_Min=0;       // Topmost point on the Y axis
   parameter [9:0] cloud_Y_Max=479;     // Bottommost point on the Y axis
	 
	parameter [9:0] cloud_X_Step=-6;      // Step size on the X axis
	parameter [9:0] cloud_Y_Step=0;      // Step size on the Y axis
														//0 because we only want it to move horizontal
	  //parameter [9:0] cloud_Y_Jump=-10;      // Step size on the Y axis
	  
    assign cloud_Width = 80;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
	 assign cloud_Height = 40; 

	
	
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_cloud
        if (Reset)  // Asynchronous Reset
        begin 
            cloud_Y_Motion <= 10'd0; //cloud_Y_Step;
				cloud_X_Motion <= 10'd0; //cloud_X_Step;
				cloud_Y_Pos <= cloud_Y_Center;
				cloud_X_Pos <= cloud_X_Center;

				cloud2_Y_Motion <= 10'd0; //cloud_Y_Step;
				cloud2_X_Motion <= 10'd0; //cloud_X_Step;
				cloud2_Y_Pos <= cloud2_Y_Center;
				cloud2_X_Pos <= cloud2_X_Center;				

        end
           
        else
		   begin 
				if (cloud_X_Pos<=1 && 2*rand_out >= 300)
					begin
						cloud_X_Motion <= cloud_X_Step;
						cloud_Y_Pos <= rand_out;
						cloud_X_Pos <= 840;
					end
					
				else if(cloud2_X_Pos<=1 && 2*rand_out >= 300)
					begin
						cloud2_X_Motion <= cloud_X_Step;
						cloud2_Y_Pos <= rand_out;
						cloud2_X_Pos <= 860;
					end
					
				else if(cloud_X_Pos<=1)
				  begin
						cloud_X_Motion <= cloud_X_Step;
						cloud_Y_Pos <= 2*rand_out;
						cloud_X_Pos <= 840;
				  end
				  
				 else if(cloud2_X_Pos<=1)
				  begin
						cloud2_X_Motion <= cloud_X_Step;
						cloud2_Y_Pos <= 2*rand_out;
						cloud2_X_Pos <= 860;
				  end

				
				else 
				begin
			   cloud_X_Motion <= cloud_X_Step;
			   cloud_Y_Pos <= (cloud_Y_Pos + cloud_Y_Motion);  // Update cloud position
			   cloud_X_Pos <= (cloud_X_Pos + cloud_X_Motion);
				
			   cloud2_Y_Pos <= (cloud2_Y_Pos);  // Update cloud position
			   cloud2_X_Pos <= (cloud2_X_Pos + cloud_X_Motion);
			
				end
			end
	
			
    end
       
    assign cloudX = cloud_X_Pos;  
    assign cloudY = cloud_Y_Pos;
    assign cloudW = cloud_Width;
	 assign cloudH = cloud_Height;

	 
	 assign cloud2X = cloud2_X_Pos;  
    assign cloud2Y = cloud2_Y_Pos;
    assign cloud2W = cloud_Width;
	 assign cloud2H = cloud_Height;

endmodule
