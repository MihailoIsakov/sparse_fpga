`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Yaqin Huang
//
// Create Date:   16:30:11 12/03/2016
// Design Name:   CISRDecoder
// Module Name:   C:/Users/yaqin/Documents/BU_Spring2016/EC551/Project/CISRDecoder/Testbench_CISRDecoder.v
// Project Name:  CISRDecoder
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: CISRDecoder
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Testbench_CISRDecoder;
	//Inputs
	reg clk;
	reg reset;
	reg [4:0] rowLength1;
	reg [4:0] rowLength2;
	reg [4:0] rowLength3;
	reg [4:0] rowLength4;

	// Outputs
	wire [4:0] rowID1;
	wire [4:0] rowID2;
	wire [4:0] rowID3;
	wire [4:0] rowID4;

	// Instantiate the Unit Under Test (UUT)
	CISRDecoder CISRDE (
		.clk(clk),
		.reset(reset),
		
		.rowLength1(rowLength1),
		.rowLength2(rowLength2),
		.rowLength3(rowLength3),
		.rowLength4(rowLength4),
		
		.rowID1(rowID1),
		.rowID2(rowID2),
		.rowID3(rowID3),
		.rowID4(rowID4)
	);
	
	always #1 clk=~clk;

	initial begin
		// Initialize Inputs
		reset = 1;
		clk = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		#2 rowLength1 = 3; rowLength2 = 2; rowLength3 = 4; rowLength4 = 1;
		#2 reset = 0;
		#10;

	end
      
endmodule

