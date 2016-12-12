`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:37:51 12/04/2016 
// Design Name: 
// Module Name:    fetcher 
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
module vector_ram(
    input clk,
    input write_enable,
    input [1023:0] in,
    // addressing for images. Each image has 8 addresses (0-7), each accessing 128 bytes
    // for 10 images * 8 cells per image, we need ceil(log2(80))=7 bits
    input  [6:0] addr, 
	output [1024-1:0] out // 128 bytes. Each image is split into 8 of these
    );

    // vector_ram stores images of size 28*28 as vector of length 784.
    // Vectors are padded with a trailing 1, for the lenght of 785
    // Vectors are padded with zeros, resulting in the length of 1024
    // 10 images are stored in the COE file, each 1024 bytes long
    //
    // vector_ram loads 128 bytes of each image, and presents it to the output
    // Each image is therefore indexed with 3 bits, with values from 0 to 8
    //
    // IMPORTANT: you should ignore the vector padding, and treat the image as 
    // 785 bytes long. The padding is there just to ensure that the next
    // image is easily loaded from the start

    vector_bram vector_bram (
        .clka(clk), // input clka
        .wea(write_enable), // input [0 : 0] wea
        .addra(addr), // input [6 : 0] addra
        .dina(in), // input [1023 : 0] dina
        .douta(out) // output [1023 : 0] douta
    );

endmodule
