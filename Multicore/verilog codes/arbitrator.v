`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:01:17 04/28/2025 
// Design Name: 
// Module Name:    arbitrator 
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
module arbitrator(
    input req_1, // M_as_N from cache 1
    input req_2, // M_as_N from cache 2
    input reset,
    input arb_en,
    input clock,
    output [1:0] permission // who has the permission to access the bus
    );

parameter IDLE = 2'b00;
parameter cache_1 = 2'h2; // 10
parameter cache_2 = 2'h3; // 11

reg [1:0] next_permission;


always @(posedge clock) begin
    if (reset) begin
        next_permission <= 2'h0;
    end else if(arb_en) begin
        if (~req_1 && ~req_2) begin
            if (next_permission == cache_1) 
                next_permission <= cache_2;
            else // last used by cache_2 or wasn't used yet
                next_permission <= cache_1;
        end else if (~req_1) begin
            next_permission <= cache_1;
        end else if (~req_2) begin
            next_permission <= cache_2;
        end
        else 
            next_permission <= next_permission; // maintain current permission
    end

end


assign permission = next_permission;

endmodule
