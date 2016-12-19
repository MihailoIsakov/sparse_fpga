`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:25:14 12/19/2016
// Design Name:   channel
// Module Name:   /home/mihailo/documents/classes/verilog/sparse_accelerator/t_channel.v
// Project Name:  sparse_
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: channel
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module t_channel;

	// Inputs
	reg clk;
	reg rst;
	reg [31:0] vec;
	reg [3:0] vec_fifo_empty;
	reg [31:0] mat;
	reg [3:0] mat_fifo_empty;
	reg [3:0] mult_fifo_read;

	// Outputs
	wire [3:0] vec_fifo_read;
	wire [3:0] mat_fifo_read;
	wire [63:0] mult;
	wire [3:0] mult_fifo_empty;

	// Instantiate the Unit Under Test (UUT)
	channel uut (
		.clk(clk), 
		.rst(rst), 
		.vec(vec), 
		.vec_fifo_empty(vec_fifo_empty), 
		.vec_fifo_read(vec_fifo_read), 
		.mat(mat), 
		.mat_fifo_empty(mat_fifo_empty), 
		.mat_fifo_read(mat_fifo_read), 
		.mult(mult), 
		.mult_fifo_empty(mult_fifo_empty), 
		.mult_fifo_read(mult_fifo_read)
	);

    always 
        #1 clk = ~clk;

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		vec = 0;
		vec_fifo_empty = 0;
		mat = 0;
		mat_fifo_empty = 0;
		mult_fifo_read = 0;

        #20 rst = 1;
        #20 rst = 0;

        #20 mat = {8'd15, -8'd56, 8'd4, 8'd14};
            vec = {8'd5, 8'd2, 8'd9, 8'd0};
            mult_fifo_read = 15;
        
        #20 mat = {8'd100, -8'd96, 8'd40, -8'd4};
        #50 mult_fifo_read = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

