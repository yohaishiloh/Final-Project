// Verilog test fixture created from schematic E:\adlx\B2\yohai_yarin_2\yohai_yarin\Lab7_DLX\HOME_VER\control.sch - Mon Jul 08 16:21:31 2024

`timescale 1ns / 1ps

module control_control_sch_tb();

// Inputs
   reg CLK;
   reg RESET;
   reg STEP_EN;
   reg [5:0] opcode;
   reg [5:0] R_type_func;
   reg ack_n;

// Output
   wire IRce;
   wire PCce;
   wire Ace;
   wire Bce;
   wire Cce;
   wire MARce;
   wire MDR;
   wire DINTsel;
   wire MDRsel;
   wire Asel;
   wire shift;
   wire right;
   wire add;
   wire test;
   wire MR;
   wire busy;
   wire GPR_WE;
   wire [2:0] ALUf;
   wire Jlink;
   wire Itype;
   wire [1:0] S1sel;
   wire [1:0] S2sel;
   wire [1:0] MAC_state;
   wire wr_N;
   wire MW;
   wire as_N;
   wire STOP_N;
	wire [4:0] STATE;

// Bidirs

// Instantiate the UUT
   control UUT (
		.CLK(CLK), 
		.IRce(IRce), 
		.PCce(PCce), 
		.Ace(Ace), 
		.Bce(Bce), 
		.Cce(Cce), 
		.RESET(RESET), 
		.MARce(MARce), 
		.MDR(MDR), 
		.DINTsel(DINTsel), 
		.MDRsel(MDRsel), 
		.Asel(Asel), 
		.shift(shift), 
		.right(right), 
		.add(add), 
		.test(test), 
		.MR(MR), 
		.busy(busy), 
		.STEP_EN(STEP_EN), 
		.GPR_WE(GPR_WE), 
		.opcode(opcode), 
		.R_type_func(R_type_func), 
		.ALUf(ALUf), 
		.Jlink(Jlink), 
		.Itype(Itype), 
		.S1sel(S1sel), 
		.S2sel(S2sel), 
		.MAC_state(MAC_state), 
		.wr_N(wr_N), 
		.ack_n(ack_n), 
		.MW(MW), 
		.as_N(as_N), 
		.STOP_N(STOP_N),
		.STATE(STATE)
   );

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

	
		initial
		CLK = 0;
		always #10 CLK = ~CLK;

	
// Initialize Inputs
      initial begin
		STEP_EN = 0;
		CLK = 0;
		RESET = 0;
		opcode = 0;
		ack_n = 1;
		
		
	//wating 2 clock cycles for reset to finish
	#41; 
	RESET = 1;
	#40;
	RESET = 0;
	#100

	opcode = 6'b100011; // lw
//	DO = 32'h00112233;
//	Data_from_MEM = 32'h01230123;
//	AD = 32'h0000A000;
	
		
	STEP_EN = 1;
	#20;
	STEP_EN = 0;
	#200;
	ack_n = 0;
	#20;
	ack_n = 1;
	#200;
	ack_n = 0;
	#20;
	ack_n = 1;
	#80;

// start store operation:
	opcode = 6'b101011; 
	STEP_EN = 1;
	#20;
	STEP_EN = 0;
	#140;
	ack_n = 0;
	#20;
	ack_n = 1;
	#120;
	ack_n = 0;
	#20;
	ack_n = 1;
	#100;
	
// start halt operatoin
	opcode = 6'b100011; 
	STEP_EN = 1;
	#20;
	STEP_EN = 0;
	#160;
	ack_n = 0;
	#20;
	ack_n = 1;
	#140;
	opcode = 6'b111111;
	STEP_EN = 1;
	#20;
	STEP_EN = 0;
	#140;
	
// another reset check
	RESET = 1;
	#40;
	RESET = 0;
	#40;
	
	end



endmodule
