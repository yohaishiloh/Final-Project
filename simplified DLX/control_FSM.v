`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:39:45 07/06/2024 
// Design Name: 
// Module Name:    control_FSM 
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
module control_FSM(
    input CLK,
    input RESET,
    input STEP_EN,
    input busy,
    input [5:0] opcode,
    input [5:0] R_type_func,
	input AEQZ, // 'Branch taken' determain either will branch or not;
	output [4:0] STATE_o,
    output [2:0] ALUf,
    output IRce,
    output PCce,
    output Ace,
    output Bce,
    output Cce,
    output MARce,
    output MDRce,
    output [1:0] S1sel,
    output [1:0] S2sel,
    output DINTsel,
    output MDRsel,
    output Asel,
    output shift_o,
    output right,
    output add_o,
    output test,
    output MR,
    output MW,
    output GPR_WE,
    output Itype,
    output Jlink
    );

// Supporting registers	
reg [4:0] next_state;
reg [4:0] STATE; 
reg hold; // Small FSM letch indicator. Equal to one only if is in MEM transaction state for one cycle or more
wire bt;

// states parameters definitions:
parameter INIT = 5'h00;
parameter fetch = 5'h01;
parameter decode = 5'h02;
parameter halt = 5'h1f;
parameter ALU = 5'h03;
parameter shift_state = 5'h04;
parameter WBR = 5'h05;
parameter ALUI= 5'h06;
parameter testI = 5'h07;
parameter WBI = 5'h08;
parameter addessCMP = 5'h09;
parameter load = 5'h0a;
parameter copyMDR2C = 5'h0b;
parameter copyGPR2MDR = 5'h0c;
parameter store = 5'h0d;
parameter JR = 5'h0e;
parameter savePC = 5'h0f;
parameter JALR = 5'h10;
parameter branch = 5'h11;
parameter Btaken = 5'h12;


// R type instructions' Function code
parameter R_inst_opcode = 6'b000000;
parameter slli = 3'b000;
parameter srli = 3'b010;
parameter add_func= 3'b011;
parameter sub = 3'b010;
parameter and_logic = 3'b110;
parameter or_logic = 3'b101;
parameter xor_logic = 3'b100;

// I type instructions' Opcode
parameter D1 = 3'b110; // special nop - go to INIT/fetch
parameter D5 = 3'b001;
parameter D6 = 3'b011;
parameter D7 = 2'b10; // lw and sw instruction flow
parameter D8 = 6'b010110;
parameter D9 = 6'b010111; 
parameter D12 = 5'b00010;
parameter lw = 4'b0011;
parameter sw = 4'b1011;
parameter addi =6'b001011;

always @(STATE or busy or STEP_EN) begin
    if (~STEP_EN) next_state = INIT;
    case(STATE) 
        INIT:
        if(STEP_EN)
            next_state = fetch;
        else
            next_state = INIT;
        fetch:
            if (~busy & hold)
                next_state = decode;
            else
                next_state = fetch;
        decode:
            if (opcode == R_inst_opcode) // R type instruction was received
                if(R_type_func[5]==1) next_state = ALU;
                else if (R_type_func[5] == 0) next_state = shift_state;
                else next_state = halt; // Undefined R type instruction has been detected
            else // I type instruction
                if(opcode[5:3] == D1) // special nop
                    next_state = (STEP_EN) ? fetch : INIT;
                else if(opcode == addi) next_state = ALUI;
                else if(opcode[5:3] == D6) next_state = testI;
                else if (opcode[5:4]== D7) next_state = addessCMP; 
                else if (opcode == D8) next_state = JR;
                else if (opcode == D9) next_state = savePC;
                else if (opcode[5:1] == D12) next_state = branch;
                else next_state = halt; 
        ALU, shift_state: 
            next_state = WBR;
        ALUI, testI, copyMDR2C: 
            next_state = WBI;
        WBI, WBR, JR, JALR, Btaken: 
            next_state = (STEP_EN) ? fetch : INIT;
        addessCMP: 
            next_state = (opcode[3]) ? copyGPR2MDR : load;
        copyGPR2MDR: 
            next_state = store;
        store:
            if (~busy & hold) next_state = INIT;
            else next_state = store;
        load:
            if (~busy & hold) next_state = copyMDR2C;
            else next_state = load;
        savePC:
            next_state = JALR;
        branch:
            if (bt) next_state = Btaken; // Branch at the next step
            else next_state = (STEP_EN) ? fetch : INIT; // Don't branch - go to the next instruction
        halt:
            next_state = halt;

        default:
            next_state = INIT;
            
        endcase
    end

always @(posedge CLK) begin
    if (RESET)
        STATE <= INIT;
    else
      begin
		STATE <= #1 next_state;
		hold <= ((STATE == fetch)|(STATE == store)|(STATE == load)) ? 1 : 0;
		end
    end

assign STATE_o = STATE;
assign ALUf = ((opcode[5:3] == 3'b001)||(opcode[5:3] == 3'b011)) ? opcode[2:0] : (opcode == R_inst_opcode)&(R_type_func[5:3] == 3'b100) ? R_type_func[2:0] : 3'b000;
assign IRce = (STATE == fetch) ? 1:0;
assign PCce = (STATE == decode)|(STATE == Btaken)|(STATE == JR)|(STATE == JALR) ? 1:0;
assign Ace = (STATE == decode) ? 1:0;
assign Bce = Ace;
assign Cce = (STATE == ALU)|(STATE == testI)|(STATE == ALUI)|(STATE == shift_state)|(STATE == copyMDR2C)|(STATE == savePC) ? 1:0;
assign MARce = (STATE == addessCMP) ? 1:0;
assign MDRce = (STATE == load)|(STATE == copyGPR2MDR) ? 1:0;
assign S1sel[1] = (STATE == copyGPR2MDR)|(STATE == copyMDR2C) ? 1:0;
assign S1sel[0] = ((Cce)&(STATE != savePC))|(STATE == addessCMP)|(STATE == JR)|(STATE == JALR) ? 1:0;
assign S2sel = (STATE == decode) ? 2'b11 : ((opcode[5:3] == 3'b010)|(STATE == copyGPR2MDR)|(STATE==copyMDR2C)) ? 2'b10 : ((STATE == addessCMP)||((~GPR_WE)&Itype)||(STATE == Btaken)) ? 2'b01 : 2'b0;
assign DINTsel = (shift_o)|(STATE == copyGPR2MDR)|(STATE == copyMDR2C) ? 1:0;
assign MDRsel = (STATE == load) ? 1 : 0;
assign Asel = (STATE == load)|(STATE == store) ? 1 : 0;
assign shift_o = (STATE == shift_state) ? 1 : 0;
assign right = (shift_o & R_type_func[1]);
assign add_o = (STATE ==decode)|(STATE == ALUI)|(STATE == addessCMP)|(STATE == Btaken)| (STATE ==JR)|(STATE == savePC)|(STATE == JALR) ? 1 : 0;
assign test = (STATE == testI) ? 1 : 0;
assign MR = (STATE == fetch)|(STATE == load) ? 1 : 0;
assign MW = (STATE == store) ? 1 : 0;
assign GPR_WE = (STATE ==WBI)|(STATE == WBR)|(STATE == JALR) ? 1 : 0;
assign Itype = (STATE == ALUI)|(STATE == testI)|(STATE == WBI) ? 1 : 0;
assign Jlink = (STATE == JALR) ? 1 : 0;
assign bt = (AEQZ ^ opcode[0]);

endmodule
