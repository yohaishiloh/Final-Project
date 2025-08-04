`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:39:58 01/09/2025 
// Design Name: 
// Module Name:    cacheComparator 
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
module cacheComparator(
    input [23:0] tag_req,
    input [23:0] tag_saved,
    input valid,
    output hit
    );

	assign hit = (valid && (tag_req == tag_saved)) ? 1'b1 : 1'b0; 

endmodule
