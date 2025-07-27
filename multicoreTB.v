// Verilog test fixture created from schematic C:\multiCoreDLX_Project\full_project\HOME_VER\DLX_IOSIM.sch - Sun May 11 13:47:41 2025
// This file perfomes a simulation testbench for the full multi-core DLX system.
// The simulation is done by sending step signals to allow the operation of the instructions from the instruction memory units.

`timescale 1ns / 1ps

module DLX_IOSIM_DLX_IOSIM_sch_tb();

// Inputs
   reg CLK_IN;
   reg RST_IN;
   reg STEP_IN;

// Output
   wire main_ack;
   wire [31:0] mem_data;
   wire M_wr_n_0;
   wire M_wr_n_1;
   wire core_1_ack;
   wire core_0_ack;
   wire M_wr_n_out;
   wire M_as_n_out;
   wire M_as_n_0;
   wire shared_0_o;
   wire IN_INIT_0;
   wire M_as_n_1;
   wire shared_1_o;
   wire IN_INIT_1;
   wire [68:0] transaction_1;
   wire [68:0] transaction_0;
   wire [68:0] main_bus;

// Bidirs

// Instantiate the UUT
   DLX_IOSIM UUT (
		.main_ack(main_ack), 
		.mem_data(mem_data), 
		.M_wr_n_0(M_wr_n_0), 
		.M_wr_n_1(M_wr_n_1), 
		.core_1_ack(core_1_ack), 
		.core_0_ack(core_0_ack), 
		.M_wr_n_out(M_wr_n_out), 
		.M_as_n_out(M_as_n_out), 
		.M_as_n_0(M_as_n_0), 
		.shared_0_o(shared_0_o), 
		.IN_INIT_0(IN_INIT_0), 
		.M_as_n_1(M_as_n_1), 
		.shared_1_o(shared_1_o), 
		.IN_INIT_1(IN_INIT_1), 
		.transaction_1(transaction_1), 
		.transaction_0(transaction_0), 
		.main_bus(main_bus), 
		.CLK_IN(CLK_IN), 
		.RST_IN(RST_IN), 
		.STEP_IN(STEP_IN)
   );
// Initialize Inputs
   		initial
		CLK_IN = 0;
		always #5 CLK_IN = ~CLK_IN;
		
		// Initialize Inputs
      initial begin
		STEP_IN = 0;
		CLK_IN = 0;
		RST_IN = 0;
		#41;
		
		// System set
		RST_IN = 1; 
		#100;
		RST_IN = 0;
		#60;
		
		// Reset test
		STEP_IN = 1;
		#300;
		STEP_IN = 0;
		#20;	
		RST_IN = 1;
		#40;
		RST_IN = 0;
		#40;

		// Start Execution
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

