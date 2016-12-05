`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Yaqin Huang
// 
// Create Date:    21:16:20 11/08/2016 
// Design Name: 
// Module Name:    Counter 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Counter(
	input wire clk,
	input wire reset,
	input wire [4:0] rowLength,
	
	output reg [4:0] count,
	output reg [4:0] countZero
);

always @ (posedge clk, posedge reset) begin
	if (reset == 1) begin
		count <= rowLength;
		countZero <= 0;
	end
	else begin
		if (count != 5'b00000) begin
			count <= count - 1;
		end
		else begin
			count <= rowLength;
		end
		
		if (count == 0) begin
			countZero <= countZero + 1;
		end
		else begin
			countZero <= countZero;
		end
	end
end

endmodule
