`timescale 1ns / 1ps
//// 

module addr_mod_mesi(
    input CLK,
    input [31:0] addr,
    input start_comp, 
    input next_addr,// receives the main_ack (?)
    input [23:0] tag,
	input mod_en,
    input tag_en,
    input [2:0] bus_cmd,
    input [31:0] bus_addr,
    output [31:0] offset_addr);

    reg [3:0] counter;
	reg [3:0] new_addr;
	 
    parameter mask_addr = 32'hFFFFFFF0;
    parameter mask_tag = 32'h000000FF;
	
	 
    always @(posedge CLK ) begin
	 		new_addr <= bus_addr[7:4];
        if(~next_addr)
            counter <= counter + 1;
        else if(start_comp)
            counter <= 0;
    end
	 

assign offset_addr = (bus_cmd == 3) ? {tag, new_addr, counter} :
						(!mod_en) ? addr : 
                        (!tag_en) ? (addr & mask_addr)+ counter : 
                        {tag, addr[7:4], counter};

endmodule



