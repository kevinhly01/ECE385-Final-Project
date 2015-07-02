module gamestate(input Reset, frame_clk,gameover,gameover1,gameover2,gameoverball,scoring,scoring1,scoring2,
						input [7:0] key,
						input [9:0] obsx,
					  output rdy,
					  output lost,
					  output [10:0] totalscore,
					  output [3:0] hextotal,hextotal2);
					  
enum logic [3:0] {Press_Start, Playing,Game_Over}   State, Next_state;   // Internal state logic
logic ready,incscore,lost_game;
logic [10:0] score_total;
logic [3:0] hex_score, hex_score2;


  always_ff @ (posedge Reset or posedge frame_clk  )
    begin : Assign_Next_State
        if (Reset) 
            State <= Press_Start;
        else 
				
            State <= Next_state;
    end	


//NEXT STAte
	always_comb
    begin 
	    Next_state  = State;

	 
        unique case (State)
            Press_Start : 
	            if (key == 8'hcc || key == 8'h1a) //1a is w
						Next_state <= Playing;					  
            Playing : 
					if(gameover || gameover1 || gameover2 || gameoverball)
						Next_state <= Game_Over;
						
				Game_Over: ;
            
			default : ;

	     endcase
    end	
	

//ACTION AT EACH STAte
   //always//_comb
	always_ff @ (posedge Reset or posedge frame_clk  )
    begin 
        //default controls signal values; within a process, these can be
        //overridden further down (in the case statement, in this case)
	   // LD_MAR = 1'b0;
	  //  LD_MDR = 1'b0;
	  //  LD_IR = 1'b0;
		ready = 0;
		incscore = 0;
		hex_score = hex_score;
					score_total = score_total;
					hex_score2= hex_score2;
					lost_game=0;
		 
	    case (State)
			Press_Start : 
				begin 
					//GatePC = 1'b1; //open TRISTATE BUFFER so PC data can go on bus
					//LD_MAR = 1'b1; //tell MAR to load data in
					//PCMUX = 2'b00; //tell PCMUX to increment PC by 1
					//LD_PC = 1'b1;	//tell PC to reload PC+1
					score_total = 0;
					hex_score = 0;
					hex_score2 = 0;
					ready = 0;
					incscore = 0;
					lost_game=0;
				end
			Playing : 
				begin
				
				if((scoring || scoring1 || scoring2))
				begin
					score_total++;
					hex_score= hex_score + 1;
					hex_score2= hex_score2;
				end
				
				
				if(hex_score >= 'd10)
					begin
						hex_score = 0;
						hex_score2 = hex_score2 + 1;
					
					end
				
				
				ready = 1;
				lost_game=0;
				end
			Game_Over : 
				begin 
					//Mem_OE = 1'b0; //done reading
					//LD_MDR = 1'b1; //tell MDR to load data read
					ready = 0;
					hex_score = hex_score;
					score_total = score_total;
					hex_score2= hex_score2;
					lost_game=1;
            end
        
          default : ;
           
			  
		endcase
		
	
       
	end 	

		assign rdy = ready;
		assign totalscore = score_total;
		assign hextotal = hex_score;
		assign hextotal2 = hex_score2;
		assign lost= lost_game;
	
endmodule
