`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:51:19 05/05/2025 
// Design Name: 
// Module Name:    mesi_tagMemory 
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
module mesi_tagMemory(
    input [2:0] bus_cmd,
    input [1:0] bus_origid,
    input [31:0] bus_addr,
    input [31:0] dlx_addr,
    output [1:0] bus_addr_mesi,
    output [1:0] dlx_addr_mesi,
	 output tag_hit,
    output flush,
    output is_shared,
    output my_informed,
	 output [23:0] tag_out,
    input clock,
    input reset,
    input modified_en,
    input bus_shared,
	 input my_id
    );
	 
	 

	 reg [23:0] blocktag [15:0];
	 reg [1:0] blockmesi [15:0];
	 reg im_flush;
	 reg im_shared;
	 parameter invalid = 2'h0;
	 parameter shared = 2'h1;
	 parameter exclusive = 2'h2;
	 parameter modified = 2'h3;	 
	 parameter bus_nocmd = 3'h0;
	 parameter bus_rd = 3'h1;
	 parameter bus_rdx = 3'h2;
	 parameter flush_p  = 3'h3;
    parameter informed = 3'h4; 
	 
	 integer i;
	initial begin
	
		im_flush = 1'b0;
		i = 0;
	repeat(16)
		begin
		blockmesi[i] = 2'h0;
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
						blockmesi[i] = 2'h0;
						i = i+1;
						end
				end
			
			else 
				begin
					im_shared <= (bus_origid != my_id && bus_addr[31:8] == blocktag[bus_addr[7:4]] && blockmesi[bus_addr[7:4]] != invalid) ? 1 : 0;
					if(modified_en)
						blockmesi[dlx_addr[7:4]] <= modified;
						
					case(bus_cmd)
						
						bus_rd:
							if(bus_origid[0] == my_id)
								begin
									blocktag[bus_addr[7:4]] <= bus_addr[31:8];
									if(bus_shared == 1'b1) blockmesi[bus_addr[7:4]] <= shared; 
									else 	blockmesi[bus_addr[7:4]] <= exclusive;
								end
							else if((bus_origid != my_id && bus_addr[31:8] == blocktag[bus_addr[7:4]] && blockmesi[bus_addr[7:4]] != invalid) == 1'b1)  
											begin 
												if(blockmesi[bus_addr[7:4]]== modified) im_flush <= 1'b1;
												blockmesi[bus_addr[7:4]] <= shared;
											end
												
						
						bus_rdx:
								if(bus_origid[0] == my_id)
									begin
										blocktag[bus_addr[7:4]] <= bus_addr[31:8];
										blockmesi[bus_addr[7:4]] <= modified;
									end
								else if((bus_origid != my_id && bus_addr[31:8] == blocktag[bus_addr[7:4]] && blockmesi[bus_addr[7:4]] != invalid) == 1'b1)
										begin 
											if(blockmesi[bus_addr[7:4]]== modified) im_flush <= 1'b1;
											blockmesi[bus_addr[7:4]] <= invalid;
										end
									
						flush_p:
							im_flush <= 1'b0;
						
						informed:
							if(bus_origid[0] != my_id)
								begin
									if(bus_origid != my_id && bus_addr[31:8] == blocktag[bus_addr[7:4]] && blockmesi[bus_addr[7:4]] != invalid) blockmesi[bus_addr[7:4]]<= invalid;
								end
							else 
								blockmesi[bus_addr[7:4]] <= modified;
					
					endcase
				end
		end	
		
	assign bus_addr_mesi = blockmesi[bus_addr[7:4]];
	assign dlx_addr_mesi = blockmesi[dlx_addr[7:4]];
	assign tag_hit = (dlx_addr[31:8] == blocktag[dlx_addr[7:4]]) ? 1 : 0;
	assign is_shared = im_shared;
	assign my_informed = (bus_cmd == informed && bus_origid[0] == my_id) ? 1 : 0;
	assign flush = im_flush;
	assign tag_out = blocktag[bus_addr[7:4]];

endmodule
