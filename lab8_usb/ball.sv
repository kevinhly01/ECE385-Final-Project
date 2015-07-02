//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 298 Lab 7                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  ball ( input Reset, frame_clk,rdy, 
					input [7:0] key,
               output [9:0]  BallX, BallY, BallS, BallW, BallH,
					output gameover);
    
    logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion, Ball_Size,Ball_W,Ball_H;
	logic gg;
	 
  //  parameter [9:0] Ball_X_Center=320;  // Center position on the X axis
   parameter [9:0] Ball_Y_Center=240;  // Center position on the Y axis
	 parameter [9:0] Ball_X_Center=100;  // Center position on the Y axis
	 
    parameter [9:0] Ball_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max=479;     // Bottommost point on the Y axis
    //parameter [9:0] Ball_X_Step=0;      // Step size on the X axis
	 parameter [9:0] Ball_X_Step=1;      // Step size on the X axis
  //  parameter [9:0] Ball_Y_Step=1;      // Step size on the Y axis
	 parameter [9:0] Ball_Y_Step=8;      // Step size on the Y axis
	 parameter [9:0] Ball_Y_Jump=-6;      // Step size on the Y axis
	  
	 
	  

    assign Ball_Size = 16;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
	 assign Ball_W = 86;
	 assign Ball_H =  26;
   
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Ball
        if (Reset)  // Asynchronous Reset
        begin 
            Ball_Y_Motion <= 10'd0; //Ball_Y_Step;
				Ball_X_Motion <= 10'd0; //Ball_X_Step;
				Ball_Y_Pos <= Ball_Y_Center;
				Ball_X_Pos <= Ball_X_Center;
				gg = 0;
			
        end
		  
        else if (!rdy)
		  begin
				//dont move
			   Ball_Y_Motion <= 10'd0; //Obs_Y_Step;
				Ball_X_Motion <= 10'd0; //Obs_X_Step;
				
				//if crash, freeze where it crashed
				Ball_Y_Pos <= Ball_Y_Pos;
				Ball_X_Pos <= Ball_X_Pos;
				gg = 0;
			
		  end  
		  
        else
		   begin 
				//BIRD GAME LOGIC
				 if ( (Ball_Y_Pos + Ball_Size) >= Ball_Y_Max || (Ball_Y_Pos + Ball_Size) < Ball_Y_Min)
				 begin 
					Ball_Y_Motion <= 0 ;
					gg =1;
				 
				 end
				 
				else if (key==8'hcc || key == 8'h1a) //1a for w, cc for mech keyboard
					begin
						//Ball_Y_Motion <= (~ (Ball_Y_Step) + 1'b1);
						Ball_Y_Motion <= Ball_Y_Jump;
						Ball_X_Motion <= 0;
						gg = 0;
					end
				else	
					begin
						Ball_Y_Motion <= Ball_Y_Step;
						Ball_X_Motion <= 0;
						gg = 0;
					end
					  
					  
				 Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);  // Update ball position
				 Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion);
			
			
		end  
    end
       
    assign BallX = Ball_X_Pos;
    assign BallY = Ball_Y_Pos;
    assign BallS = Ball_Size;
	 assign BallW = Ball_W;
	 assign BallH = Ball_H;
	 assign gameover = gg;
    

endmodule
