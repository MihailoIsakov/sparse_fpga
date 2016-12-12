`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   01:24:38 12/12/2016
// Design Name:   vector_ram
// Module Name:   /home/mihailo/documents/classes/verilog/sparse_accelerator/t_vector_ram.v
// Project Name:  sparse_
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: vector_ram
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module t_vector_ram;

	// Inputs
	reg clk;
	reg write_enable;
	reg [1023:0] in;
	reg [6:0] addr;

	// Outputs
	wire [1023:0] out;

	// Instantiate the Unit Under Test (UUT)
	vector_ram uut (
		.clk(clk), 
		.write_enable(write_enable), 
		.in(in), 
		.addr(addr), 
		.out(out)
	);

    always
        #1 clk = ~clk;

    always
        #5 addr = addr + 1;

	initial begin
		// Initialize Inputs
		clk = 0;
		write_enable = 0;
		in = 0;
		addr = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

