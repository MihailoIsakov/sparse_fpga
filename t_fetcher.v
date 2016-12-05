`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   00:50:34 12/05/2016
// Design Name:   fetcher
// Module Name:   /home/mihailo/documents/classes/verilog/sparse_accelerator/t_fetcher.v
// Project Name:  sparse_
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: fetcher
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module t_fetcher;

	// Inputs
	reg clk;
	reg rst;
	reg val_read;

	// Outputs
	wire [7:0] out;
	wire empty;

	// Instantiate the Unit Under Test (UUT)
	fetcher uut (
		.clk(clk), 
		.rst(rst), 
		.val_read(val_read), 
		.out(out), 
		.empty(empty)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		val_read = 0;

        #10 rst = 1;
        #10 rst = 0;

        #20 val_read = 1;
        #80 val_read = 0;
        #60 val_read = 1;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end

    always
        #5 clk = ~clk;
      
endmodule

