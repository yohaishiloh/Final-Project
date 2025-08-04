// Verilog test fixture created from schematic E:\adlx\B2\yohai_yarin_2\yohai_yarin\Lab7_DLX\HOME_VER\DLX_IOSIM.sch - Mon Jul 15 16:42:20 2024

`timescale 1ns / 1ps

module DLX_IOSIM_DLX_IOSIM_sch_tb();

// Inputs
   reg CLK_IN;
   reg RST_IN;
   reg STEP_IN;

// Output
   wire right;
   wire MARce;
   wire DINTsel;
   wire [31:0] IROUT;
   wire [31:0] PC;
   wire [31:0] MDO;
   wire IRce;
   wire PCce;
   wire Ace;
   wire Bce;
   wire Cce;
   wire MDRce;
   wire Asel;
   wire shift;
   wire add;
   wire test;
   wire MR;
   wire busy;
   wire GPR_WE;
   wire jlink;
   wire itype;
   wire [1:0] MAC_State;
   wire MW;
   wire STOP_N;
   wire [2:0] ALUF;
   wire [1:0] S1sel;
   wire [1:0] S2sel;
   wire [4:0] CTRL_STATE;
   wire MDRsel;
   wire as_N;
   wire wr_N;
   wire [31:0] MAO;
   wire ack_n;
   wire [31:0] DI;

// Bidirs

// Instantiate the UUT
   DLX_IOSIM UUT (
		.right(right), 
		.MARce(MARce), 
		.DINTsel(DINTsel), 
		.IROUT(IROUT), 
		.PC(PC), 
		.MDO(MDO), 
		.IRce(IRce), 
		.PCce(PCce), 
		.Ace(Ace), 
		.Bce(Bce), 
		.Cce(Cce), 
		.MDRce(MDRce), 
		.Asel(Asel), 
		.shift(shift), 
		.add(add), 
		.test(test), 
		.MR(MR), 
		.busy(busy), 
		.GPR_WE(GPR_WE), 
		.jlink(jlink), 
		.itype(itype), 
		.MAC_State(MAC_State), 
		.MW(MW), 
		.STOP_N(STOP_N), 
		.ALUF(ALUF), 
		.S1sel(S1sel), 
		.S2sel(S2sel), 
		.CTRL_STATE(CTRL_STATE), 
		.MDRsel(MDRsel), 
		.CLK_IN(CLK_IN), 
		.RST_IN(RST_IN), 
		.STEP_IN(STEP_IN), 
		.as_N(as_N), 
		.wr_N(wr_N), 
		.MAO(MAO), 
		.ack_n(ack_n), 
		.DI(DI)
   );


		initial
		CLK_IN = 0;
		always #10 CLK_IN = ~CLK_IN;
		
		
		// Initialize Inputs
      initial begin
		STEP_IN = 0;
		CLK_IN = 0;
		RST_IN = 0;
		#41;
		RST_IN = 1;
		#100;
		RST_IN = 0;
		#60;
		STEP_IN = 1;
		#300;
		STEP_IN = 0;
		#20;
		RST_IN = 1;
		#40;
		RST_IN = 0;
		#40;
		STEP_IN = 1;
		#400;
		STEP_IN = 0;
		#200;
		STEP_IN = 1;
		#20;
		STEP_IN = 0;
		#100;
		STEP_IN = 1;
		

		end

endmodule
