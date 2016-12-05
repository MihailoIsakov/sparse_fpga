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
    //input [channel_num - 1 : 0] val_read,
    input [channel_num-1:0] val_read,
	output [(channel_num)*8-1:0] val_out,
    output [channel_num-1:0] empty
    );

    // These should be templated and generated in python
    parameter channel_num = 4;
    parameter W1_val_start = 0;
    parameter W1_col_start = 3971;
    parameter W1_len_start = 7942;

    reg [15:0] rom_addr;
    reg [15:0] val_addr;
    reg [7:0] current_channel;
	 
    wire [7:0] rom_out;

    reg [channel_num-1:0] val_wr;
    wire [channel_num-1:0] full;

    rom rom (
        .a(rom_addr),
        .spo(rom_out)
    );

    genvar i;
    generate 
        for (i=0; i < channel_num; i=i+1) begin: FIFO_VAL
            fifo val_fifo (
                .clk(clk), // input clk
                .srst(rst), // input srst
                .din(rom_out), // input [7 : 0] din
                .wr_en(val_wr[i]), // input wr_en
                .rd_en(val_read[i]), // input rd_en
                .dout(val_out[i*8+7:i*8]), // output [7 : 0] dout
                .full(full[i]), // output full
                .empty(empty[i]) // output empty

            );  
        end
    endgenerate

    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            rom_addr <= 0;
            val_addr <= 0;
            val_wr   <= 1;
            current_channel <= 0;
        end
        else begin
            if (~full[current_channel]) begin
                rom_addr <= W1_val_start + val_addr + 1;
                val_addr <= val_addr + 1;
                val_wr[current_channel] = 0;
                current_channel = current_channel == channel_num - 1 ? 0 : current_channel + 1;
                val_wr[current_channel] = 1;
            end
        end
    end

endmodule
