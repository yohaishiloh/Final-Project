`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:16:20 05/05/2025 
// Design Name: 
// Module Name:    bus_control 
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
module bus_control(
    input reset,
    input CLK,
    input IN_INIT1, // Not sure that this is actually needed...
    input IN_INIT2,
    input M_as_N1,
    input M_as_N2,
    input [2:0] bus_cmd1,
    input [2:0] bus_cmd2,
    input [31:0] addr1,
    input [31:0] addr2,
    input M_wr_N1,
    input M_wr_N2,
    input [31:0] data1,
    input [31:0] data2,
    input [31:0] data_mem,
    input main_ack,
    output IN_INIT_out, // To the real bus. Not sure that this is actually needed 
    output M_as_N_out,
    output M_wr_N_out,
    output [31:0] addr_out,
    output [2:0] bus_cmd_out,
    output [31:0] data_out,
    output ack_to1,
    output ack_to2,
    output [1:0] bus_origid
    );

reg [1:0] permission;
wire [1:0] arb_permission;
reg [2:0] state;
reg [2:0] next_state;
reg arb_en;

parameter bus_idle = 3'h0;
parameter arbitration = 3'h1;
parameter bus_grant_to1 = 3'h2;
parameter bus_grant_to2 = 3'h3;
parameter flush_on_bus = 3'h4;

// bus_cmd parameters
parameter BusRd = 3'b001; // Bus Read
parameter BusRdX = 3'b010; // Bus Read Exclusive
parameter flush = 3'b011; // Flush
parameter BusInform = 3'b100; // Bus command - Inform other caches about MESI status cahnge
parameter dirtyflush = 3'b101; // Flush dirty block 


// arb_permissions
parameter IDLE = 2'b00;
parameter cache_1 = 2'b10;
parameter cache_2 = 2'b11;


arbitrator arbiter(
    .req_1(IN_INIT1),
    .req_2(IN_INIT2),
    .reset(reset),
    .arb_en(arb_en),
    .clock(CLK),
    .permission(arb_permission)
    );

always @ (*) begin
    next_state = state;
    case(state)
        bus_idle: begin
            if (~IN_INIT1 || ~IN_INIT2) begin
                next_state = arbitration;
                arb_en = 1;
            end else begin
                arb_en = 0;
                next_state = bus_idle;
            end
        end

        arbitration: begin
            arb_en = 0;
            if (permission == cache_1)
                next_state = bus_grant_to1;
            else if (permission == cache_2) 
                next_state = bus_grant_to2;
            else next_state = bus_idle;
        end
        
        bus_grant_to1: begin
            arb_en = 0;
            if(bus_cmd2 == flush)
                next_state = flush_on_bus;
            else if (IN_INIT1 == 1) begin
                next_state = bus_idle;
            end else begin
                next_state = bus_grant_to1;
            end
        end

        bus_grant_to2: begin
            arb_en = 0;
            if(bus_cmd1 == flush)
                next_state = flush_on_bus;
            else if (IN_INIT2 == 1) begin
                next_state = bus_idle;
            end else begin
                next_state = bus_grant_to2;
            end
        end

        flush_on_bus: begin
            arb_en = 0;
            if (bus_cmd1 != flush && bus_cmd2 != flush) begin // The flush was done, by whoever has done it
                if(permission == cache_1)
                    next_state = bus_grant_to1;
                else if (permission == cache_2) 
                    next_state = bus_grant_to2;
                else next_state = bus_idle; // Error handling, not valid flow
            end else 
                next_state = flush_on_bus;
        end
        
endcase

end

always @ (posedge CLK) begin
    if (reset) begin
        state <= bus_idle;    
        permission <= IDLE;
    end
    else begin
       state <= next_state;
		 if (next_state == bus_idle)
		      permission <= IDLE;
		else if (next_state == arbitration)
			   permission <= arb_permission;	
		else
			permission <= permission;
	end				

end

//assign arb_en = (next_state == arbitration) ? 1 : 0;
assign IN_INIT_out = (state == bus_idle) ? 1 : 0;
assign M_as_N_out = (bus_cmd1 == flush) ? M_as_N1 : 
                    (bus_cmd2 == flush || (permission[0] && bus_cmd2 != BusInform) ) ? M_as_N2 :  
                    (~permission[0] && bus_cmd1 != BusInform)? M_as_N1 : 1;
assign M_wr_N_out = (bus_cmd1 == flush || bus_cmd2 == flush) ? 0 :
                    (~permission[0]) ? M_wr_N1 : 
                    (permission[0]) ? M_wr_N2 : 1;
assign addr_out = (bus_cmd1 == flush) ? addr1 :
                    (bus_cmd2 == flush || permission == cache_2) ? addr2 :
                    (permission == cache_1) ? addr1 : 32'h0;
assign bus_cmd_out = (bus_cmd1 == flush || bus_cmd2 == flush) ? flush : 
                    (permission == cache_1) ? bus_cmd1 : 
                    (permission == cache_2) ? bus_cmd2 : 3'b000;
assign data_out = (bus_cmd1 == flush) ? data1 : 
                    (bus_cmd2 == flush || (permission == cache_2 && bus_cmd2 == dirtyflush)) ? data2 :
                    (permission == cache_1 && bus_cmd1 == dirtyflush) ? data1 : 
                    (bus_cmd_out == BusRd || bus_cmd_out == BusRdX) ? data_mem : 32'h0;
assign ack_to1 = (bus_cmd_out == flush || permission == cache_1) ? main_ack : 1;
assign ack_to2 = (bus_cmd_out == flush || permission == cache_2) ? main_ack : 1;
assign bus_origid = permission;

endmodule
