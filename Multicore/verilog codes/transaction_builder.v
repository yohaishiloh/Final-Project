`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:32:23 05/06/2025 
// Design Name: 
// Module Name:    transaction_builder 
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
module transaction_builder(
    input [2:0] bus_cmd,
    input bus_origid,
    input [31:0] bus_addr,
    input [31:0] bus_data,
    output [68:0] transaction_o
    );
		
		
	assign transaction_o[2:0] = bus_cmd;
	assign transaction_o[3] = bus_origid;
	assign transaction_o[4] = 1'b0;
	assign transaction_o[36:5] = bus_addr;
	assign transaction_o[68:37] = bus_data;

endmodule
