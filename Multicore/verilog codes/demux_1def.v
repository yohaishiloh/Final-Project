`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:18:54 05/05/2025 
// Design Name: 
// Module Name:    demux_1def 
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
module demux_1def(
    input fetch_sel,
    input as_n,
    output as_n_to_cache,
    output as_n_to_imem
    );


assign as_n_to_cache = (fetch_sel) ? 1 : as_n;
assign as_n_to_imem = (fetch_sel) ? as_n : 1;

endmodule
