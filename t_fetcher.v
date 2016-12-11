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
	reg [3*4-1:0] read;
    wire [3*8*4-1:0] out;
    wire [8-1:0] out2;
    wire [3*4-1:0] empty;

    assign out2 = out[8-1:0];

	// Outputs
	fetcher fetcher(
	    .clk(clk),
	    .rst(rst),
        .read(read),
	    .out(out),
        .empty(empty)
    );

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;

        #15 rst = 1;
        #55 rst = 0;

        //#40 read = 12'hFFFF;
        #40 read = 12'h0003;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end

    always
        #2 clk = ~clk;
      
endmodule

