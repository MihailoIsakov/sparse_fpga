`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:33:27 12/18/2016
// Design Name:   cisr_acc
// Module Name:   /home/mihailo/documents/classes/verilog/sparse_accelerator/t_cisr_acc.v
// Project Name:  sparse_
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: cisr_acc
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module t_cisr_acc;

	// Inputs
	reg clk;
	reg rst;
	reg [31:0] row_len_fifo_data;
	reg [3:0] row_len_fifo_empty;
	reg [63:0] mult_fifo_data;
	reg [3:0] mult_fifo_empty;

	// Outputs
	wire [3:0] row_len_fifo_read;
	wire [3:0] mult_fifo_read;
	wire write_data;
	wire [7:0] addr_data;
	wire [31:0] data;

	// Instantiate the Unit Under Test (UUT)
	cisr_acc uut (
		.clk(clk), 
		.rst(rst), 
		.row_len_fifo_data(row_len_fifo_data), 
		.row_len_fifo_empty(row_len_fifo_empty), 
		.row_len_fifo_read(row_len_fifo_read), 
		.mult_fifo_data(mult_fifo_data), 
		.mult_fifo_empty(mult_fifo_empty), 
		.mult_fifo_read(mult_fifo_read), 
		.write_data(write_data), 
		.addr_data(addr_data), 
		.data(data)
	);

    always 
        #1 clk = ~clk;


	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		row_len_fifo_data = 0;
		row_len_fifo_empty = 15;
		mult_fifo_data = 0;
		mult_fifo_empty = 15;

        #20 rst = 1;
        #20 rst = 0;

            row_len_fifo_empty = 0;
            mult_fifo_empty    = 0;
            row_len_fifo_data  = {8'd4, 8'd43, 8'd55, 8'd17};
            mult_fifo_data    = {16'd46, 16'd3, 16'd193, 16'd554};

        #40 mult_fifo_empty = 15;
        #10 mult_fifo_empty = 0;

        #20 row_len_fifo_empty[3] = 1;
        #20 row_len_fifo_empty[3] = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

