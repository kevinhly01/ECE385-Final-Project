//-------------------------------------------------------------------------
//      lab7_usb.sv                                                      --
//      Christine Chen                                                   --
//      Fall 2014                                                        --
//                                                                       --
//      Fall 2014 Distribution                                           --
//                                                                       --
//      For use with ECE 385 Lab 7                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------
//top level entity

module lab8_usb 		( input         Clk,
                                     Reset,
							  output [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
							  output [8:0]  LEDG,
							  output [17:0] LEDR,
							  // VGA Interface 
                       output [7:0]  Red,
							                Green,
												 Blue,
							  output        VGA_clk,
							                sync,
												 blank,
												 vs,
												 hs,
							  // CY7C67200 Interface
							  inout [15:0]  OTG_DATA,						//	CY7C67200 Data bus 16 Bits
							  output [1:0]  OTG_ADDR,						//	CY7C67200 Address 2 Bits
							  output        OTG_CS_N,						//	CY7C67200 Chip Select
												 OTG_RD_N,						//	CY7C67200 Write
												 OTG_WR_N,						//	CY7C67200 Read
												 OTG_RST_N,						//	CY7C67200 Reset
							  input			 OTG_INT,						//	CY7C67200 Interrupt
							  // SDRAM Interface for Nios II Software
							  output [12:0] sdram_wire_addr,				// SDRAM Address 13 Bits
							  inout [31:0]  sdram_wire_dq,				// SDRAM Data 32 Bits
							  output [1:0]  sdram_wire_ba,				// SDRAM Bank Address 2 Bits
							  output [3:0]  sdram_wire_dqm,				// SDRAM Data Mast 4 Bits
							  output			 sdram_wire_ras_n,			// SDRAM Row Address Strobe
							  output			 sdram_wire_cas_n,			// SDRAM Column Address Strobe
							  output			 sdram_wire_cke,				// SDRAM Clock Enable
							  output			 sdram_wire_we_n,				// SDRAM Write Enable
							  output			 sdram_wire_cs_n,				// SDRAM Chip Select
							  output			 sdram_clk						// SDRAM Clock
											);
    
    logic Reset_h,collision_flag,gg,gg1,gg2,ggball,rdy,lost;
	 logic clken, ld_en, cke, ld_en1,pts,pts1,pts2;
	 logic [10:0] total_score;
	 logic [3:0] hex_totalscore,hex_totalscore2;
	 
	 logic [7:0] keycode,ld_seed,ran_val,ran_val1;
	 logic [9:0] xdraw,ydraw,ballx,bally,balls,ballw,ballh
									,obsx,obsy,obsw,obsh
									,obsBotx,obsBoty,obsBotw,obsBoth
									,obsx1,obsy1,obsw1,obsh1
									,obsx2,obsy2,obsw2,obsh2
									,cloudx, cloudy, cloudw, cloudh
									,cloud2x, cloud2y, cloud2w, cloud2h
									,hot_air_balloonx, hot_air_balloony, hot_air_balloonw, hot_air_balloonh;
    
	 logic [0:13][0:78][0:3] gameover_text;
	 logic [0:39][0:79][0:3] cloud;
	 logic [0:25][0:85][0:3] helicopter;
	 logic [0:62][0:57][0:3] balloon;
	 logic [0:27][0:129][0:3] blimp;
	 logic [0:20][0:207][0:3] flappycopter;
	 logic [0:34][0:145][0:3] startscreen;
	 
    assign {Reset_h}=~ (Reset);  // The push buttons are active low
	 assign OTG_FSPEED = 1'bz;
	 assign OTG_LSPEED = 1'bz;
	 
	 assign clken = 1'b1;
	 assign cke = 1'b1;
	// assign ld_en = 1'b1;
	 assign ld_seed = 100;
	  assign ld_seed1 = 100;
	 
	 usb_system usbsys_instance(
										 .clk_clk(Clk),         
										 .reset_reset_n(1'b1),   
										 .sdram_wire_addr(sdram_wire_addr), 
										 .sdram_wire_ba(sdram_wire_ba),   
										 .sdram_wire_cas_n(sdram_wire_cas_n),
										 .sdram_wire_cke(sdram_wire_cke),  
										 .sdram_wire_cs_n(sdram_wire_cs_n), 
										 .sdram_wire_dq(sdram_wire_dq),   
										 .sdram_wire_dqm(sdram_wire_dqm),  
										 .sdram_wire_ras_n(sdram_wire_ras_n),
										 .sdram_wire_we_n(sdram_wire_we_n), 
										 .sdram_out_clk_clk(sdram_clk),
										 .keycode_export(keycode),  
										 .usb_DATA(OTG_DATA),    
										 .usb_ADDR(OTG_ADDR),    
										 .usb_RD_N(OTG_RD_N),    
										 .usb_WR_N(OTG_WR_N),    
										 .usb_CS_N(OTG_CS_N),    
										 .usb_RST_N(OTG_RST_N),   
										 .usb_INT(OTG_INT) );
	
										  
	 HexDriver hex_inst_0 (keycode[3:0], HEX0);
	 HexDriver hex_inst_1 (keycode[7:4], HEX1);
	  HexDriver hex_inst_2 (hex_totalscore, HEX2);
	 HexDriver hex_inst_3 (hex_totalscore2, HEX3);
	 
	 vga_controller(.Clk(Clk),
						 .Reset(Reset_h),
						 .hs(hs),
						 .vs(vs),
						 .pixel_clk(VGA_clk),
						 .blank(blank),
						 .sync(sync),
						 .DrawX(xdraw),
						 .DrawY(ydraw));
    
	 ball(.Reset(Reset_h),
			.frame_clk(vs),
			.rdy(rdy),
			.key(keycode),
			.BallX(ballx),
			.BallY(bally),
			.BallS(balls),
			.BallW(ballw),
			.BallH(ballh),
			.gameover(ggball));
			
	color_mapper(.rdy(rdy),
					.gameover(gg),
					.gameover1(gg1),
					.gameover2(gg2),
					.gameoverball(ggball),
					.lost(lost),
					 .BallX(ballx),
					 .BallY(bally),
					 .DrawX(xdraw),
					 .DrawY(ydraw),
					 .Ball_size(balls),
					 .Ball_width(ballw),
					 .Ball_height(ballh),
					 .ObsX(obsx),
					 .ObsY(obsy),
					 .ObsW(obsw),
					 .ObsH(obsh),
					 .ObsX_bottom(obsBotx), 
					 .ObsY_bottom(obsBoty), 
					 .ObsW_bottom(obsBotw), 
					 .ObsH_bottom(obsBoth),	
					 .ObsX1(obsx1),
					 .ObsY1(obsy1),
					 .ObsW1(obsw1),
					 .ObsH1(obsh1),
					 .ObsX2(obsx2),
					 .ObsY2(obsy2),
					 .ObsW2(obsw2),
					 .ObsH2(obsh2),
					 .cloudX(cloudx),
					 .cloudY(cloudy),
			       .cloudW(cloudw),
			       .cloudH(cloudh),
					 .cloud2X(cloud2x),
					 .cloud2Y(cloud2y),
					 .cloud2W(cloud2w),
					 .cloud2H(cloud2h),
					 .hot_air_balloonX(hot_air_balloonx),
					 .hot_air_balloonY(hot_air_balloony),
					 .hot_air_balloonW(hot_air_balloonw),
					 .hot_air_balloonH(hot_air_balloonh),					 
					 .collision_flag(collision_flag),
					 .gameover_text(gameover_text),
					 .cloud(cloud),
					 .blimp(blimp),
					 .helicopter(helicopter),
					 .balloon(balloon),
					 .flappycopter(flappycopter),
					 .startscreen(startscreen),
					 .Red(Red),
					 .Green(Green),
					 .Blue(Blue));
					 
	 obstacle(.Reset(Reset_h),
			.frame_clk(vs), 
			.collision(collision_flag),
			.rdy(rdy),
			.key(keycode),
			.rand_out(ran_val),
			.ObsX(obsx),
			.ObsY(obsy),
			.ObsW(obsw),
			.ObsH(obsh),
			.ObsX_bottom(obsBotx), 
			.ObsY_bottom(obsBoty), 
			.ObsW_bottom(obsBotw), 
			.ObsH_bottom(obsBoth),
			.ballx(ballx),
			.bally(bally),
			.balls(balls),
			.gameover(gg),
			.score(pts));
			
		 obstype1(.Reset(Reset_h),
			.frame_clk(vs), 
			.collision(collision_flag),
			.rdy(rdy),
			.key(keycode),
			.rand_out(ran_val),
			.ObsX(obsx1),
			.ObsY(obsy1),
			.ObsW(obsw1),
			.ObsH(obsh1),
			.ballx(ballx),
			.bally(bally),
			.balls(balls),
			.gameover(gg1),
			.ld_en(ld_en1),
			.score(pts1));
			
		 obstype2(.Reset(Reset_h),
			.frame_clk(vs), 
			.collision(collision_flag),
			.rdy(rdy),
			.key(keycode),
			.rand_out(ran_val),
			.ObsX(obsx2),
			.ObsY(obsy2),
			.ObsW(obsw2),
			.ObsH(obsh2),
			.ballx(ballx),
			.bally(bally),
			.balls(balls),
			.gameover(gg2),
			.ld_en(ld_en),
			.score(pts2));
			
			cloud(.Reset(Reset_h),
			.frame_clk(vs), 
			.key(keycode),
			.rand_out(ran_val),
			.cloudX(cloudx),
			.cloudY(cloudy),
			.cloudW(cloudw),
			.cloudH(cloudh),
			.cloud2X(cloud2x),
			.cloud2Y(cloud2y),
			.cloud2W(cloud2w),
			.cloud2H(cloud2h));
			
			hot_air_balloon(.Reset(Reset_h),
			.frame_clk(vs), 
			.collision(collision_flag),
			.rdy(rdy),
			.key(keycode),
			.rand_out(ran_val),
			.hot_air_balloonX(hot_air_balloonx),
			.hot_air_balloonY(hot_air_balloony),
			.hot_air_balloonW(hot_air_balloonw),
			.hot_air_balloonH(hot_air_balloonh));
			
		gamestate(.Reset(Reset_h),
					.frame_clk(vs),
					.gameover(gg),
					.gameover1(gg1),
					.gameover2(gg2),
					.gameoverball(ggball),
					.scoring(pts),
					.scoring1(pts1),
					.scoring2(pts2),
					.key(keycode),
					.obsx(obsx),
					.rdy(rdy),
					.lost(lost),
					.totalscore(total_score),
					.hextotal(hex_totalscore),
					.hextotal2(hex_totalscore2));

		randtop obs2(.clk(vs),
					.clk_en(clken),
					.load_seed(ld_en),
					.seed(ld_seed),
					.rand_out(ran_val));
					
		sprite_table(.clk(vs),
						 .gameover_text(gameover_text),
						 .cloud(cloud),
						 .helicopter(helicopter),
						 .balloon(balloon),
						 .blimp(blimp),
						 .flappycopter(flappycopter),
						 .startscreen(startscreen));
					
	/*	randtop obs1(.clk(vs),
					.clk_en(clken),
					.load_seed(ld_en1),
					.seed(ld_seed1),
					.rand_out(ran_val1));*/

	 /**************************************************************************************
	    ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
		 Hidden Question #1/2:
          What are the advantages and/or disadvantages of using a USB interface over PS/2 interface to
			 connect to the keyboard? List any two.  Give an answer in your Post-Lab.
     **************************************************************************************/
endmodule
