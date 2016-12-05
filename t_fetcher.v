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
	reg [3:0] val_read;
	reg [3:0] col_read;
	reg [3:0] len_read;

	// Outputs
	wire [31:0] val_out;
	wire [31:0] col_out;
	wire [31:0] len_out;
	wire [3:0] val_empty;
	wire [3:0] col_empty;
	wire [3:0] len_empty;

	// Instantiate the Unit Under Test (UUT)
	fetcher uut (
		.clk(clk), 
		.rst(rst), 
		.val_read(val_read), 
		.col_read(col_read), 
		.len_read(len_read), 
		.val_out(val_out), 
		.col_out(col_out), 
		.len_out(len_out), 
		.val_empty(val_empty),
		.col_empty(col_empty),
		.len_empty(len_empty)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		val_read = 0;
		col_read = 0;
		len_read = 0;

        #5 rst = 1;
        #25 rst = 0;

        #20 val_read = 15;
            col_read = 15;
            len_read = 15;
        #80 val_read = 0;
            col_read = 0;
            len_read = 0;
        #60 val_read = 15;
            col_read = 15;
            len_read = 15;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end

    always
        #5 clk = ~clk;
      
endmodule

