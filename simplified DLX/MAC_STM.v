`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:46:31 06/24/2024 
// Design Name: 
// Module Name:    MAC_STM 
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
module MAC_STM(
    input CLK,
    input RESET,
    input MR,
	input MW,
	input ACK_N,
    output busy_o,
    output AS_N_o,
    output WR_N_o,
    output STOP_N_o,
    output [1:0] STATE_o
    );
	
	reg WR_N_out;
	reg STOP_N_out;
	reg AS_N_out;

	reg[1:0] next_state;
	reg WR_N;
	reg STOP_N;
	reg[1:0] STATE;
	reg AS_N;

	parameter wait4req = 2'h0;
	parameter wait4ACK = 2'h1;
	parameter next = 2'h2;
	
// FSM states transitions
	always @(STATE or ACK_N or MW or MR) begin
		next_state = wait4req;
		WR_N = 1;
		AS_N = 1;
		STOP_N = 1;

		case (STATE)
			wait4req: 
				if ((MR|MW) == 1)
					begin
					next_state = wait4ACK;
					WR_N = (~MW);
					AS_N = 0;
					STOP_N = 0;
					end
				else
					next_state = wait4req;

			wait4ACK :
				if(ACK_N == 0)
					begin
					next_state = next;
					WR_N = 1;
					AS_N = 1;
					end
				else
					begin
					next_state = wait4ACK;
					WR_N = (~MW);
					AS_N = 0;
					STOP_N = 0;
					end

			next :
				next_state = wait4req;

			default :
				begin 
				next_state = wait4req;
				WR_N = 1;
				AS_N = 1;
				STOP_N = 1;
				end

		endcase
	end

	always @(posedge CLK)
		if (RESET == 1)
			begin
			STATE <= #1 wait4req;
			WR_N_out <= #1 1;
			AS_N_out <= #1 1;
			STOP_N_out <= #1 1;
			end
		else 
			begin
			STATE <= next_state;
			WR_N_out <= WR_N;
			AS_N_out <= AS_N;
			STOP_N_out <= STOP_N;
			end

assign STATE_o = STATE;
assign WR_N_o = WR_N_out;
assign AS_N_o = AS_N_out;
assign STOP_N_o = STOP_N_out;
assign busy_o = ((STATE == wait4ACK) & ACK_N);

endmodule
