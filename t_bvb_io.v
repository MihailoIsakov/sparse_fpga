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

module t_bvb_io;
    `include "params.vh"

	// Inputs
	reg clk;
	reg rst;
	reg [channel_num*col_id_size-1:0] id;
	reg [channel_num-1:0] id_empty;
	reg [channel_num-1:0] vec_read;

	// Outputs
	wire [channel_num-1:0] id_read;
	wire [channel_num*val_bits-1:0] vec;
	wire [channel_num-1:0] vec_empty;

	// Instantiate the Unit Under Test (UUT)
	bvb bvb (
		.clk(clk), 
		.rst(rst), 
		.id(id),                    // input 
		.id_fifo_empty(id_empty),   // input
		.id_fifo_read(id_read),     // output
		.vec(vec),                  // output
		.vec_fifo_empty(vec_empty), // output
		.vec_fifo_read(vec_read)    // input
	);

    always
        #1 clk = ~clk;

    always begin 
        #5 id[0*col_id_size+:col_id_size] = id[0*col_id_size+:col_id_size] + 1;
           id[1*col_id_size+:col_id_size] = id[1*col_id_size+:col_id_size] + 1;
           id[2*col_id_size+:col_id_size] = id[2*col_id_size+:col_id_size] + 1;
           id[3*col_id_size+:col_id_size] = id[3*col_id_size+:col_id_size] + 1;
        end

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		id = 0;
		id_empty = 00; // ID FIFOs are empty
		vec_read = 0;  // nothing being read

        #20 rst = 1;
        #20 rst = 0;

        //#20 id_empty = 0;
            //id = {10'b0000000000, 10'b0010000000, 10'b0011111111, 10'b0011111110}; // 1st bank 0, 2nd bank, 0, 1023, 1022  
        //#15
            //id = {10'b0111111110, 10'b0111111111, 10'b0011111111, 10'b0011111110}; // 4th bank 1022, 1023, 2nd bank 1023, 1022  
        //#15 id_empty = 15;

        #50 vec_read = 15;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

