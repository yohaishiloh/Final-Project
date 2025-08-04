`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:05:35 01/05/2025 
// Design Name: 
// Module Name:    tagMemory 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module tagMemory(
    input clock,
    input reset,
    input write_en,
    input [23:0] tag_in,
    input [3:0] index,
    input set_dirty,
    output [23:0] tag_out,
    output dirty,
    output valid
    );
	 
	 
	 reg [23:0] blocktag [15:0];
	 reg blockvalid [15:0]; 
	 reg blockdirty [15:0];
	 integer i;
	initial begin
	
		i = 0;
	repeat(16)
		begin
		blockvalid[i] = 1'b0;
		i = i+1;
		end
	
	end
	
	always @(posedge clock)
		begin
			if(reset)
				begin
					i = 0;
					repeat(16)
						begin
						blockvalid[i] = 1'b0;
						i = i+1;
						end
					end
			
			else if(write_en == 1)
				begin
					blocktag[index] <= tag_in;
					blockdirty[index] <= set_dirty;
					blockvalid[index] <= 1'b1;
				end
		end	
		
	assign tag_out = blocktag[index];
	assign dirty = blockdirty[index];
	assign valid = blockvalid[index];	

endmodule
