//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//                                                                       --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 7                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------


module  color_mapper (input [9:0] BallX, BallY, DrawX, DrawY, Ball_size,Ball_width, Ball_height,
											 ObsX,ObsY,ObsW,ObsH, ObsX_bottom, ObsY_bottom, ObsW_bottom, ObsH_bottom,
											 ObsX1,ObsY1,ObsW1,ObsH1,
											 ObsX2,ObsY2,ObsW2,ObsH2,
											 cloudX,cloudY,cloudW,cloudH,
											 cloud2X,cloud2Y,cloud2W,cloud2H,
											 hot_air_balloonX, hot_air_balloonY, hot_air_balloonW, hot_air_balloonH,
							 input [0:13][0:78][0:3] gameover_text,
							 input [0:39][0:79][0:3] cloud,
							 input [0:25][0:85][0:3] helicopter,
							 input [0:62][0:57][0:3] balloon,
							 input [0:27][0:129][0:3] blimp,
							 input [0:20][0:207][0:3] flappycopter,
							 input [0:34][0:145][0:3] startscreen,
							 input rdy,gameover,gameover1,gameover2,gameoverball,lost,

							 output collision_flag,
                      output logic [7:0]  Red, Green, Blue );
    
   logic ball_on,obs_on,obs1_on,obs2_on,collision_detected;
	 
	 //test shape sprite variables
	logic shape_on;
	logic[10:0] shape_x = 300; //top left corner
	logic[10:0] shape_y = 300;
	logic[10:0] shape_size_x = 8;
	logic[10:0] shape_size_y = 16;
	
	logic [3:0] gameover_on;
	logic[9:0] gameover_x = 280; //top left corner
	logic[9:0] gameover_y = 200;
	logic[9:0] gameover_size_x = 10'd79;
	logic[9:0] gameover_size_y = 10'd14;
	
	logic [3:0] cloud_on;
	logic [3:0] cloud2_on;
	
	logic[3:0] helicopter_on;
	logic[9:0] helicopter_x = 100; //top left corner
	logic[9:0] helicopter_y = 100;
	logic[9:0] helicopter_size_x = 10'd55;
	logic[9:0] helicopter_size_y = 10'd20;
	
	logic[3:0] blimp_on;
	logic[9:0] blimp_x = 50; //top left corner
	logic[9:0] blimp_y = 50;
	logic[9:0] blimp_size_x = 10'd130;
	logic[9:0] blimp_size_y = 10'd28;
	
	logic[3:0] flappycopter_on;
	logic[9:0] flappycopter_x = 220; //top left corner
	logic[9:0] flappycopter_y = 105;
	logic[9:0] flappycopter_size_x = 10'd208;
	logic[9:0] flappycopter_size_y = 10'd21;
	
	logic[3:0] startscreen_on;
	logic[9:0] startscreen_x = 220; //top left corner
	logic[9:0] startscreen_y = 165;
	logic[9:0] startscreen_size_x = 10'd146;
	logic[9:0] startscreen_size_y = 10'd35;
	
	logic[3:0] balloon_on;
	/*logic[9:0] balloon_x = 400; //top left corner
	logic[9:0] balloon_y = 80;
	logic[9:0] balloon_size_x = 10'd58;
	logic[9:0] balloon_size_y = 10'd63;*/
	
	//TODO instantiate player _rom
	player_rom(.addr(player_addr), .data(player_data));
	
	logic [10:0] sprite_addr;
	logic [7:0] sprite_data;
	font_rom(.addr(sprite_addr), .data(sprite_data));
	
	logic [10:0] P_addr;
	logic [7:0] P_data;
	font_rom(.addr(P_addr), .data(P_data));
	
	
	logic player_addr;
	logic [31:0] player_data;
	
	assign player_addr = 0;
	
	//---------------------------------START SCREEN TEXT---------------------------------//
		//Draw Letter P
	logic P_on;
	logic[10:0] P_x = 380; //top left corner
	logic[10:0] P_y = 200;
	logic[10:0] P_size_x = 8;
	logic[10:0] P_size_y = 16;
	
	//-----------------------------------------------------------------------------------//
	  
    int DistX, DistY, Size;
	 assign DistX = DrawX - BallX;
    assign DistY = DrawY - BallY;
    assign Size = Ball_size;
	  
    always_comb
    begin:Obs_on_proc
     if ( !lost &&
	  (rdy && (DrawX >= ObsX - ObsW) &&
       (DrawX <= ObsX + ObsW) &&
       (DrawY >= ObsY - ObsH) &&
       (DrawY <= ObsY + ObsH))   ||
		 
		 (rdy && !lost &&(DrawX >= ObsX_bottom - ObsW_bottom) &&
       (DrawX <= ObsX_bottom + ObsW_bottom) &&
       (DrawY >= ObsY_bottom - ObsH_bottom) &&
       (DrawY <= ObsY_bottom + ObsH_bottom))
		 )
            obs_on = 1'b1;
        else 
            obs_on = 1'b0;
     end 
	

//BALL	
/*	 always_comb
    begin:Ball_on_proc
        if ( ( DistX*DistX + DistY*DistY) <= (Size * Size) ) 
            ball_on = 1'b1;
        else 
            ball_on = 1'b0;
     end*/
	  
	  always_comb
    begin:Ball_on_proc
        if ((!lost && DrawX >= BallX) && 
		  (DrawX <= BallX + Ball_width) && 
		  (DrawY >= BallY) &&
		  (DrawY <= BallY +Ball_height)) 
		 	 

            //ball_on = 1'b1;
				begin
				ball_on = 1'b1;
				helicopter_on = helicopter[DrawY-BallY][DrawX-BallX];
				
				end
        else 
			begin
            ball_on = 1'b0;
				
				helicopter_on = 1'b0;
				
			end
   
     end
	  
	 //OBS1
	 always_comb
    begin:Obs1_on_proc
     if ( rdy &&(!lost &&
	  (DrawX >= ObsX1 - ObsW1) &&
       (DrawX <= ObsX1 + ObsW1) &&
       (DrawY >= ObsY1 - ObsH1) &&
       (DrawY <= ObsY1 + ObsH1))   
		 	 
		 
		 )

            obs1_on = 1'b1;
        else 
            obs1_on = 1'b0;
     end 

	 //OBS2
	 always_comb
    begin:Obs2_on_proc
     if ((!lost &&
		(DrawX >= ObsX2 - ObsW2) &&
       (DrawX <= ObsX2 + ObsW2) &&
       (DrawY >= ObsY2 - ObsH2) &&
       (DrawY <= ObsY2 + ObsH2))   
		 	 
		 
		 )

            obs2_on = 1'b1;
        else 
            obs2_on = 1'b0;
     end 
	  
	/* always_comb
    begin:Spritetest
     if (((DrawX >= shape_x) &&
       (DrawX < shape_x + shape_size_x) &&
       (DrawY >= shape_y) &&
       (DrawY <= shape_y + shape_size_y)))
		 begin
		 shape_on = 1'b1;
		 sprite_addr = (DrawY-shape_y + 16*'h50);
		 
		 end
      else 
		begin
           shape_on = 1'b0;
			  sprite_addr = 10'b0;
			  
		end
		
	end*/
	
	/*always_comb
    begin:DrawP
     if (((DrawX >= P_x) &&
       (DrawX < P_x + P_size_x) &&
       (DrawY >= P_y) &&
       (DrawY < P_y + P_size_y)))
		 begin
		 P_on = 1'b1;
		 P_addr = (DrawY-P_y + 16*'h52);
		 
		 end
      else 
		begin
           P_on = 1'b0;
			  P_addr = 10'b0;
			  
		end
		
	end*/
		
		
	/* always_comb
    begin:PlayerSpritetest
     if (((DrawX >= player_x) && (DrawX <= player_x + player_size_x) && (DrawY >= player_y) &&(DrawY <= player_y + player_size_y)))
		 begin
		 player_on = player[DrawY-player_y][DrawX-player_x];
		 end
		 
     else 
			begin
           player_on = 4'b0;	  
		end		

    end */
	 
	//-----------------------------------------Draw Clouds --------------------------------------------------//
	 always_comb
    begin:CloudSprite
     if (((DrawX >= cloudX) && (DrawX <= cloudX + cloudW) && (DrawY >= cloudY) &&(DrawY <= cloudY + cloudH)))
		 begin
		 cloud_on = cloud[DrawY-cloudY][DrawX-cloudX];
		 end
		 
     else 
			begin
           cloud_on = 4'b0;	  
		end		

    end 
	 
	 always_comb
    begin:CloudSprite2
  if(((DrawX >= cloud2X) && (DrawX <= cloud2X + cloud2W) && (DrawY >= cloud2Y) &&(DrawY <= cloud2Y + cloud2H)))
		begin
		 cloud2_on = cloud[DrawY-cloud2Y][DrawX-cloud2X];
		 end
		 
     else 
			begin
           cloud2_on = 4'b0;	  
		end		

    end 
	 
/*	 always_comb
    begin:HelicopterSpritetest
     if (((DrawX >= helicopter_x) && (DrawX <= helicopter_x + helicopter_size_x) && (DrawY >= helicopter_y) &&(DrawY <= helicopter_y +helicopter_size_y)))
		 begin
		 helicopter_on = helicopter[DrawY-helicopter_y][DrawX-helicopter_x];
		 end
		 
     else 
			begin
           helicopter_on = 4'b0;	  
		end		

    end */
	 
    always_comb
    begin:BalloonSpritetest
     if ((rdy && !gameover && !gameover1 && !gameover2 && !gameoverball
	     && DrawX >= hot_air_balloonX) && (DrawX <= hot_air_balloonX + hot_air_balloonW) 
	     && (DrawY >= hot_air_balloonY) &&(DrawY <= hot_air_balloonY + hot_air_balloonH))
		 begin
		 balloon_on = balloon[DrawY-hot_air_balloonY][DrawX-hot_air_balloonX];
		 end
		 
     else 
			begin
           balloon_on = 4'b0;	  
		end		

    end 
	
	/*always_comb
    begin:BlimpSprite
     if (rdy && ((DrawX >= blimp_x) && (DrawX <= blimp_x + blimp_size_x) && (DrawY >= blimp_y) &&(DrawY <= blimp_y +blimp_size_y)))
		 begin
		 blimp_on = blimp[DrawY-blimp_y][DrawX-blimp_x];
		 end
		 
     else 
			begin
           blimp_on = 4'b0;	  
		end		

    end 	*/
	 
	always_comb
    begin:flappycopterSpritetest
     if (!rdy && !gameover && !gameover1 && !gameover2 && !gameoverball
	  && ((DrawX >= flappycopter_x) && (DrawX <= flappycopter_x + flappycopter_size_x) 
	  && (DrawY >= flappycopter_y) &&(DrawY <= flappycopter_y +flappycopter_size_y)))
     begin
     flappycopter_on = flappycopter[DrawY-flappycopter_y][DrawX-flappycopter_x];
     end
     
     else 
      begin
           flappycopter_on = 4'b0;   
    end   

    end 
	 
	 always_comb
    begin:startscreenSpritetest
	 
	  if((gameover || gameover1 || gameover2 || gameoverball))
		startscreen_on = 4'b0;  
		
    else if (!rdy && (!lost && !rdy)
	  && ((DrawX >= startscreen_x) && (DrawX <= startscreen_x + startscreen_size_x) 
    && (DrawY >= startscreen_y) &&(DrawY <= startscreen_y +startscreen_size_y)))
     begin
     startscreen_on = startscreen[DrawY-startscreen_y][DrawX-startscreen_x];
     end
     
     else 
      begin
           startscreen_on = 4'b0;   
    end   

    end 
	 
	 always_comb
    begin:gameoverSpritetest
		
    if (lost
	  && ((DrawX >= gameover_x) && (DrawX <= gameover_x + gameover_size_x) 
    && (DrawY >= gameover_y) &&(DrawY <= gameover_y +gameover_size_y)))
     begin
     gameover_on = gameover_text[DrawY-gameover_y][DrawX-gameover_x];
     end
     
     else 
      begin
           gameover_on = 4'b0;   
    end   

    end 
	  
	  
	  /**********************************************************************************/
       
    always_comb
    begin:RGB_Display
	 
		//ball
   /*     if ((ball_on == 1'b1)) 
        begin 
            Red = 8'h00;
            Green = 8'h66;
            //Blue = 8'hff;
				Blue = 8'h00;
        end */
		  
		  	if(ball_on == 1'b1 && helicopter_on == 4'b0001)
			begin
				Red = 8'h0;
            Green = 8'h0;
				Blue = 8'h0;
			end
			
			else if(ball_on == 1'b1 &&helicopter_on == 4'b0010)
			begin
				Red = 8'h32;
            Green = 8'h32;
				Blue = 8'h32;
			end
			
			else if(ball_on == 1'b1 &&helicopter_on == 4'b0011)
			begin
				Red = 8'h0;
            Green = 8'h0;
				Blue = 8'h0;
			end
			
			else if(ball_on == 1'b1 &&helicopter_on == 4'b0100)
			begin
				Red = 8'h4A;
            Green = 8'h4A;
				Blue = 8'h4A;
			end
			
			else if(ball_on == 1'b1 &&helicopter_on == 4'b0101)
			begin
				Red = 8'h92;
            Green = 8'h0;
				Blue = 8'h0;
			end
			
			else if(ball_on == 1'b1 &&helicopter_on == 4'b0110)
			begin
				Red = 8'hFF;
            Green = 8'hFF;
				Blue = 8'hFF;
			end
			
					  //obstacle
		  else if((obs_on) == 1'b1)
		  begin
	       begin 
            Red = 8'h00;
            Green = 8'hff;
				Blue = 8'h00;
          end 	    
	     end
	 
		  //obstacle
		  else if((obs1_on) == 1'b1)
		  begin
	       begin 
            Red = 8'h00;
            Green = 8'hff;
				Blue = 8'h00;
          end 	  	  
	     end
		  
		  //obstacle
		  else if((obs2_on) == 1'b1)
		  begin
	       begin 
            Red = 8'h00;
            Green = 8'hff;
				Blue = 8'h00;
          end 	  
	     end
		  
		  //drw font sprite
		  else if ((shape_on == 1'b1) && (sprite_data[DrawX - shape_x] == 1'b1)) 
        begin 
            Red = 8'h00;
            Green = 8'h66;
				Blue = 8'h00;
        end 
		  
		   else if ((P_on == 1'b1) && P_data[DrawX - P_x] == 1'b1) 
        begin 
            Red = 8'hff;
            Green = 8'hff;
				Blue = 8'h00;
        end 
			
			//---------------------------------------Draw Balloon-------------------------------------------------//
			
			else if(balloon_on == 4'b0001)
			begin
				Red = 8'hF2;
            Green = 8'h80;
				Blue = 8'hB;
			end
			
			else if(balloon_on == 4'b0010)
			begin
				Red <=   8'hBD;
				Green <= 8'hBD;
				Blue  <= 8'hBD;
			end
			
			else if(balloon_on == 4'b0011)
			begin
				Red = 8'hD8;
            	Green = 8'h73;
				Blue = 8'hC;
			end
			
			else if(balloon_on == 4'b0100)
			begin
				Red = 8'h87;
            Green = 8'h57;
				Blue = 8'hD;
			end
			
			else if(balloon_on == 4'b0101)
			begin
				Red = 8'h1A;
            Green = 8'h14;
				Blue = 8'hF;
			end
			
			else if(balloon_on == 4'b0110)
			begin
				Red = 8'hE3;
            Green = 8'hBB;
				Blue = 8'h15;
			end
			
			else if(balloon_on == 4'b0111)
			begin
				Red = 8'hEE;
            Green = 8'h6;
				Blue = 8'h6;
			end
			
			//---------------------------------------FlappyCopte Title-------------------------------------------------//
			
			else if(flappycopter_on == 4'b0001 && !rdy)
			begin
			Red = 8'h0;
         Green = 8'h0;
			Blue = 8'h0;
			end
			
			//---------------------------------------START SCREEN TEXT-------------------------------------------------//
			// Display Created By: Alvin Wu & Kevin Ly
			else if(startscreen_on == 4'b0001 && !rdy)
			begin
			Red = 8'h0;
         Green = 8'h0;
			Blue = 8'h0;
			end
			
			// Display Instructions to Play
			else if(startscreen_on == 4'b0010 && !rdy)
			begin
			Red = 8'h0;
         Green = 8'h0;
			Blue = 8'h0;
			end
			
			//---------------------------------------GAMEOVER TEXT-------------------------------------------------//
			
			else if(gameover_on == 4'b0001)
			begin
			Red = 8'hB3;
         Green = 8'hE;
			Blue = 8'hE;
			end
			
			//---------------------------------------Draw Blimp-------------------------------------------------//
			else if(blimp_on == 4'b0001)
			begin
				Red = 8'h0;
            Green = 8'h0;
				Blue = 8'h0;
			end
			
			else if(blimp_on == 4'b0010)
			begin
				Red = 8'hEE;
            Green = 8'h6;
				Blue = 8'h6;
			end
			
			else if(blimp_on == 4'b0011)
			begin
				Red = 8'hFF;
            Green = 8'hFF;
				Blue = 8'hFF;
			end
			
			else if(blimp_on == 4'b0010)
			begin
				Red = 8'hFF;
            Green = 8'hFF;
				Blue = 8'hFF;
			end
			
					
			//---------------------------------------Draw Clouds-------------------------------------------------//
			//Dark Grey Outline of Cloud
			else if(cloud_on == 4'b0110)
			begin
				Red <=   8'hBD;
				Green <= 8'hBD;
				Blue  <= 8'hBD;	
			end
			
			else if(cloud_on == 4'b0100)
			begin
				Red <= 8'hFF;
				Green <=  8'hFF;
				Blue <=  8'hFF;
			end
			
			else if(cloud_on == 4'b0111)
			begin
				Red <=   8'hE7;
				Green <= 8'hE7;
				Blue  <= 8'hE7;
			end
			
			else if(cloud2_on == 4'b0110)
			begin
				Red <=   8'hBD;
				Green <= 8'hBD;
				Blue  <= 8'hBD;	
			end
			
			else if(cloud2_on == 4'b0100)
			begin
				Red <= 8'hFF;
				Green <=  8'hFF;
				Blue <=  8'hFF;
			end
			
			else if(cloud2_on == 4'b0111)
			begin
				Red <=   8'hE7;
				Green <= 8'hE7;
				Blue  <= 8'hE7;
			end

		  //---------------------------------------Draw Sky Background: Deep Sky Blue-------------------------------------------------//
        else 
        begin 
			   Red = 8'h0;
            Green = 8'hBF;
            Blue = 8'hFF; 
        end  

		  
    end 
    
endmodule
