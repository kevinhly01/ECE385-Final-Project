module player_rom ( input 	addr,
						output [31:0]	data
					 );
					 
	parameter ADDR_WIDTH = 1; //give addr of 0 to access player sprite
   parameter DATA_WIDTH =  32;
	logic [ADDR_WIDTH-1:0] addr_reg;
	
	parameter [0:2**ADDR_WIDTH-1][DATA_WIDTH-1:0] ROM = {
        32'b00000000000000000000000000000000, // 0
        32'b00000000000000000000000000000000, // 1
        32'b00000000000000000000000000000000, // 2
        32'b00000000000000000000000000000000, // 3
        32'b00000000000000000000000000000000, // 4
        32'b00000000000000000000000000000000, // 5
        32'b00000000000000000000000000000000, // 6
        32'b00000000000000000000000000000000, // 7
        32'b00000000000000000000000000000000, // 8
        32'b00000000000000010000000100000000, // 9
        32'b00000000000000010000000100000000, // 10
        32'b00000000000000010000000100000000, // 11
        32'b00000000000000010000000100000000, // 12
        32'b00000000000000010000000100000000, // 13
        32'b00000000000000010000000100000000, // 14
        32'b00000000000000010000000100000000, // 15
		  32'b00000000000000010000000100000000, // 16
        32'b00000000000000010000000100000000, // 17
        32'b00000000000000010000000100000000, // 18
        32'b00000000000000010000000100000000, // 19
        32'b00000000000000011111111100000000, // 1
        32'b00000000000000000000000000000000, // 5
        32'b00000000000000000000000000000000, // 6
        32'b00000000000000000000000000000000, // 7
		  32'b00000000000000000000000000000000, // 0
        32'b00000000000000000000000000000000, // 1
        32'b00000000000000000000000000000000, // 2
        32'b00000000000000000000000000000000, // 3
        32'b00000000000000000000000000000000, // 4
        32'b00000000000000000000000000000000, // 5
        32'b00000000000000000000000000000000, // 6
        32'b00000000000000000000000000000000, // 7
	
	};
	
	assign data = ROM[addr];

endmodule  