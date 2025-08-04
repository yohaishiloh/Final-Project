`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:01:27 04/28/2025 
// Design Name: 
// Module Name:    Imem1 
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
module Imem1 #(parameter ADDR_WIDTH = 7)
	(
	input wire CLK,	
    input wire [ADDR_WIDTH-1:0] i_addr, 
	input wire as_N,
	input wire id,
	output wire ack_N,
    output wire [31:0] o_data 
    );


    reg [31:0] memory_array_0 [0:2**ADDR_WIDTH-1]; 
	reg [31:0] memory_array_1 [0:2**ADDR_WIDTH-1]; 
    reg give_ack;
	 
    initial begin
		$readmemh("Imem1.data", memory_array_1);
		$readmemh("Imem0.data", memory_array_0);	
		give_ack = 1'b1;
    end

    always@(posedge CLK) give_ack <= as_N;
	 
	assign ack_N = give_ack;
	assign o_data = (id) ? memory_array_1[i_addr] : memory_array_0[i_addr];

endmodule
