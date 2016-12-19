`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   02:06:51 12/19/2016
// Design Name:   column_fetcher
// Module Name:   /home/mihailo/documents/classes/verilog/sparse_accelerator/t_column_fetcher.v
// Project Name:  sparse_
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: column_fetcher
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module t_value_fetcher;

	// Inputs
	reg clk;
	reg rst;
	reg [3:0] read;

	// Outputs
	wire [31:0] out;
	wire [3:0] empty;

	// Instantiate the Unit Under Test (UUT)
	value_fetcher uut (
		.clk(clk), 
		.rst(rst), 
		.read(read), 
		.out(out), 
		.empty(empty)
	);

    always
        #1 clk = ~clk;

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		read = 0;

        #20 rst = 1;
        #20 rst = 0;

        #10 read = 15;
        #30 read = 12;
        #30 read = 3;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

