`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:37:28 01/09/2025 
// Design Name: 
// Module Name:    dataMemory 
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
module dataMemory(
    input clock,
    input write_en,
    input [7:0] addr,
    input [31:0] DI,
    output [31:0] DO
    );

reg [31:0] memory_array [0:255]; 
    
    
    
    always @ (posedge clock) 
	 /// #1;
	 if(write_en == 1) memory_array[addr] <= DI; // Save DI to REG[addr}
    //end	 
	 assign DO = memory_array[addr]; // Read REG[ADDR] to DO

endmodule
