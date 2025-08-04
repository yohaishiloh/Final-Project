`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:23:55 01/25/2025 
// Design Name: 
// Module Name:    isfetchcheck 
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
module isfetchcheck(
    input [4:0] state,
    output fetch
    );

assign fetch = (state == 5'h01) ? 1:0; 
endmodule
