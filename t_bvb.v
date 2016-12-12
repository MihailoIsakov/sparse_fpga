`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   05:17:50 12/12/2016
// Design Name:   bvb
// Module Name:   /home/mihailo/documents/classes/verilog/sparse_accelerator/t_bvb.v
// Project Name:  sparse_
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: bvb
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module t_bvb;

	// Inputs
	reg clk;
	reg rst;
	reg [39:0] id;
	reg [3:0] id_empty;
	reg [3:0] val_read;

	// Outputs
	wire [3:0] id_read;
	wire [31:0] val;
	wire [3:0] val_empty;

	// Instantiate the Unit Under Test (UUT)
	bvb uut (
		.clk(clk), 
		.rst(rst), 
		.id(id), 
		.id_empty(id_empty), 
		.id_read(id_read), 
		.val(val), 
		.val_empty(val_empty), 
		.val_read(val_read)
	);

    always
        #1 clk = ~clk;

    always 
        #2 id = id + 1;

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		id = 0;
		id_empty = 15;
		val_read = 0;

        #20 rst = 1;
        #20 rst = 0;

        #20 id_empty = 0;

        #50 val_read = 15;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

