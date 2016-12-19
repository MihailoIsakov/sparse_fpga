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

module t_bvb_fifo;
    `include "params.vh"

    defparam channel_num=1;

	// Inputs
	reg clk;
	reg rst;

    reg [9:0] fifo_in;
    reg fifo_wr_en;
    wire [9:0] fifo_out;
    wire fifo_empty, fifo_full;
    wire fifo_read;

    wire [val_bits-1:0] vec;
    wire vec_empty;
    reg bvb_read;

    fifo_width10 #(.channel_num(1)) fifo (
        .rst(rst), // input rst
        .wr_clk(clk), // input wr_clk
        .rd_clk(clk), // input rd_clk
        .din(fifo_in), // input [9 : 0] din
        .wr_en(fifo_wr_en), // input wr_en
        .rd_en(fifo_read), // input rd_en
        .dout(fifo_out), // output [9 : 0] dout
        .full(fifo_full), // output full
        .empty(fifo_empty) // output empty
    );


	// Instantiate the Unit Under Test (UUT)
	bvb #(.channel_num(1)) bvb1 (
		.clk(clk), 
		.rst(rst), 
        //input fifo
		.id(fifo_out), // input 
		.id_fifo_empty(fifo_empty),   // input
		.id_fifo_read(fifo_read),     // output
        // output fifo
		.vec(vec),                  // output
		.vec_fifo_empty(vec_empty), // output
		.vec_fifo_read(bvb_read)    // input
	);


    always
        #1 clk = ~clk;

    always @ (posedge clk) begin
        if (~fifo_full) begin
            fifo_wr_en <= 1;
        end else
            fifo_wr_en <= 0;

        if (fifo_wr_en)
            fifo_in <= fifo_in + 1;
    end

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
        fifo_in = 10'b0111111111;
        bvb_read = 1;

        #20 rst = 1;
        #20 rst = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

