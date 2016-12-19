`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:33:32 12/18/2016
// Design Name:   first_one
// Module Name:   /home/mihailo/documents/classes/verilog/sparse_accelerator/t_first_one.v
// Project Name:  sparse_
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: first_one
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module t_first_one;

	// Inputs
	reg [7:0] seq;

	// Outputs
	wire [2:0] addr;
	wire has_ones;

	// Instantiate the Unit Under Test (UUT)
	first_one uut (
		.seq(seq), 
		.addr(addr), 
		.has_ones(has_ones)
	);

	initial begin
		// Initialize Inputs
		seq = 0;
		
		#10 seq = 8'b00101110;
		#10 seq = 8'b10100000;
		#10 seq = 8'b01000000;
		#10 seq = 8'b00000000;
		#10 seq = 8'b10000100;
		#10 seq = 8'b11001000;


		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

