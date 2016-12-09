`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:53:06 12/06/2016
// Design Name:   zero_counter
// Module Name:   /home/mihailo/documents/classes/verilog/sparse_accelerator/t_zero_counter.v
// Project Name:  sparse_
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: zero_counter
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module t_zc;

	// Inputs
	reg [7:0] vec;
	
	// Outputs
	//wire [3:0] addr;
    wire [2:0] addr;
    wire has_zero;

	// Instantiate the Unit Under Test (UUT)
	zc #(8, 3) uut (
		.seq(vec), 
		.addr(addr),
        .has_zero(has_zero)
	);

	initial begin
		// Initialize Inputs
		vec = 0;
		
		//#10 vec = 16'b0000011000110110;
		#10 vec = 8'b00001011;
		#10 vec = 8'b00000001;
		#10 vec = 8'b01001011;
		#10 vec = 8'b10001011;
		#10 vec = 8'b00000000;
		#10 vec = 8'b00000100;
		#10 vec = 8'b00000001;
		#10 vec = 8'b00010000;
		#10 vec = 8'b00100000;

		
		

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

