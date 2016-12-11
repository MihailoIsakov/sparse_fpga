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
module fetcher(
	input clk,
	input rst,
    input  [3*channel_num-1:0] read,
    // each channel has three fields, which are 8 bit values
	output [3*8*channel_num-1:0] out,
    output [3*channel_num-1:0] empty
    );

    // These should be templated and generated in python
    parameter channel_num = 4;

    reg [9:0] addr [channel_num*3-1:0];
    reg [9:0] rom_addr; // current address, gotten as a combination of the base + lane
    reg [7:0] lane;
	 
    wire [63:0] rom_out;

    reg [channel_num*3-1:0] wr_en;
    wire [channel_num*3-1:0] full;

    rom rom (
        .a(rom_addr),
        .spo(rom_out)
    );

    genvar i;
    generate 
        for (i=0; i < channel_num*3; i=i+1) begin: FIFO_ALL
            fifo fifo64 (
                .wr_clk(clk), // input clk
                .rd_clk(clk), // input clk
                .rst(rst), // input srst
                .din(rom_out), // input [7 : 0] din
                .wr_en(wr_en[i]), // input wr_en
                .rd_en(read[i]), // input rd_en
                .dout(out[i*8+7:i*8]), // output [7 : 0] dout
                .full(full[i]), // output full
                .empty(empty[i]) // output empty
            );  
        end
    endgenerate
                                               
    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            rom_addr = 0;
            // TODO add address instantiation code here!
            addr[0] = 0;
            wr_en <= 0;
            lane <= 0;
        end
        else begin
            if (~full[lane]) begin
                lane <= (lane == channel_num * 3 - 1) ? 0 : lane + 1;

                wr_en = 0;
                wr_en[lane] = 1;

                rom_addr = addr[lane];
                addr[lane] = addr[lane] + 1;
            end
        end
    end

endmodule
