`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Yaqin Huang
//
// Create Date:   21:11:19 12/03/2016
// Design Name:   Counter
// Module Name:   C:/Users/yaqin/Documents/BU_Spring2016/EC551/Project/CISRDecoder/Testbench_Counter.v
// Project Name:  CISRDecoder
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Counter
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Testbench_Counter;

	// Inputs
	reg clk;
	reg reset;
	reg [4:0] rowLength;

	// Outputs
	wire [4:0] count;
	wire [4:0] countZero;

	// Instantiate the Unit Under Test (UUT)
	Counter CON (
		.clk(clk), 
		.reset(reset), 
		.rowLength(rowLength), 
		.count(count), 
		.countZero(countZero)
	);
	
	always #1 clk=~clk;

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 1;
		rowLength = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		#2 rowLength = 4;
		#2 reset = 0;
		#30;
		
		#2 rowLength = 1;
		#10;

	end
      
endmodule

