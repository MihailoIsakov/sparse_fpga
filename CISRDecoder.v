`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Yaqin Huang
// 
// Create Date:    16:29:45 12/03/2016 
// Design Name: 
// Module Name:    CISRDecoder 
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
module CISRDecoder(
  input wire clk,
  input wire reset,
  
  input wire [4:0]rowLength1,
  input wire [4:0]rowLength2,
  input wire [4:0]rowLength3,
  input wire [4:0]rowLength4,
  
  output reg [4:0]rowID1,
  output reg [4:0]rowID2,
  output reg [4:0]rowID3,
  output reg [4:0]rowID4
  );
  
  wire [4:0] count1;
  wire [4:0] count2;
  wire [4:0] count3;
  wire [4:0] count4;
  
  wire [4:0] countZero1;
  wire [4:0] countZero2;
  wire [4:0] countZero3;
  wire [4:0] countZero4;
  
  
  Counter C1
  (
  .clk(clk),
  .reset(reset),
  
  .rowLength(rowLength1),
  .count(count1),
  .countZero(countZero1)
  );
  
  always @(posedge clk, posedge reset) begin
	if (reset == 1) begin
		rowID1 <= 0;
	end
	else begin
		if (count1 != 0) begin
			rowID1 <= countZero1;
		end
		else begin 
			rowID1 <= rowID1 + 1;
		end
	end
  end //Channel 1
  
  
  Counter C2
  (
  .clk(clk),
  .reset(reset),
  
  .rowLength(rowLength2),
  .count(count2),
  .countZero(countZero2)
  );
  
  always @(count2) begin
	rowID2 = 1;
	if (rowID1 >= rowID2) begin
			rowID2 = rowID1 + 1;
	end 
	else begin
		if (count2 != 0) begin
		rowID2 = rowID2;
		end
		else begin
			rowID2 = rowID2 + 1;
		end
	end
  end //Channel 2
  
  
  Counter C3
  (
  .clk(clk),
  .reset(reset),
  
  .rowLength(rowLength3),
  .count(count3),
  .countZero(countZero3)
  );
  
  always @(count3) begin
	rowID3 = 2;
	if (rowID2 >= rowID3) begin
			rowID3 = rowID2 + 1;
	end 
	else begin
		if (count3 != 0) begin
		rowID3 = rowID3;
		end
		else begin
			rowID3 = rowID3 + 1;
		end
	end
  end //Channel 3
  
  
  Counter C4
  (
  .clk(clk),
  .reset(reset),
  
  .rowLength(rowLength4),
  .count(count4),
  .countZero(countZero4)
  );
  
  always @(count4) begin
	rowID4 = 3;
	if (rowID3 >= rowID4) begin
			rowID4 = rowID3 + 1;
	end
	else begin
		if (count4 != 0) begin
			rowID4 = rowID4;
		end 
		else begin
			rowID4 = rowID4 + 1;
		end
	end
  end  //Channel 4
  
endmodule
