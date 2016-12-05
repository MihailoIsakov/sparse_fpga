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
    input  [channel_num-1:0] val_read,
    input  [channel_num-1:0] col_read,
    input  [channel_num-1:0] len_read,
	output [(channel_num)*8-1:0] val_out,
	output [(channel_num)*8-1:0] col_out,
	output [(channel_num)*8-1:0] len_out,
    output [channel_num-1:0] val_empty,
    output [channel_num-1:0] col_empty,
    output [channel_num-1:0] len_empty
    );

    // These should be templated and generated in python
    parameter channel_num = 4;

    parameter W1_val_start = 0;
    parameter W1_col_start = 3971;
    parameter W1_len_start = 7942;

    reg [15:0] rom_addr; // current address, gotten as a combination of the base + counter
    reg [15:0] val_addr; // specific counters of values traversed
    reg [15:0] col_addr;
    reg [15:0] len_addr;
    //reg [7:0] current_channel;
    reg [7:0] counter;
	 
    wire [7:0] rom_out;

    reg [channel_num*3-1:0] wr_en;
    wire [channel_num*3-1:0] full;

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
                .wr_en(wr_en[i]), // input wr_en
                .rd_en(val_read[i]), // input rd_en
                .dout(val_out[i*8+7:i*8]), // output [7 : 0] dout
                .full(full[i]), // output full
                .empty(val_empty[i]) // output empty

            );  
        end
    endgenerate

    genvar j;
    generate 
        for (j=0; j < channel_num; j=j+1) begin: FIFO_COL
            fifo col_fifo (
                .clk(clk), // input clk
                .srst(rst), // input srst
                .din(rom_out), // input [7 : 0] din
                .wr_en(wr_en[channel_num+j]), // input wr_en
                .rd_en(col_read[j]), // input rd_en
                .dout(col_out[j*8+7:j*8]), // output [7 : 0] dout
                .full(full[channel_num+j]), // output full
                .empty(col_empty[j]) // output empty
            );  
        end
    endgenerate

    genvar k;
    generate 
        for (k=0; k < channel_num; k=k+1) begin: FIFO_LEN
            fifo len_fifo (
                .clk(clk), // input clk
                .srst(rst), // input srst
                .din(rom_out), // input [7 : 0] din
                .wr_en(wr_en[channel_num*2+k]), // input wr_en
                .rd_en(len_read[k]), // input rd_en
                .dout(len_out[k*8+7:k*8]), // output [7 : 0] dout
                .full(full[channel_num*2+k]), // output full
                .empty(len_empty[k]) // output empty
            );  
        end
    endgenerate

                                               
    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            rom_addr = 0;
            val_addr <= 0;
            col_addr <= 0;
            len_addr <= 0;
            wr_en <= 1;
            counter <= 0;
            //current_channel <= 0;
        end
        else begin
            if (~full[counter]) begin
                counter <= (counter == channel_num * 3 - 1) ? 0 : counter + 1;

                wr_en = 0;
                wr_en[counter] = 1;

                rom_addr <= (counter < channel_num)   ? W1_val_start + val_addr :
                           (counter < channel_num*2) ? W1_col_start + col_addr :
                                                       W1_len_start + len_addr;

                if (counter < channel_num) begin
                    val_addr = val_addr + 1;
                end
                else if (counter < channel_num*2)
                    col_addr = col_addr + 1;
                else
                    len_addr = len_addr + 1;

                //val_addr <= val_addr + 1;
                //current_channel = current_channel == channel_num - 1 ? 0 : current_channel + 1;
                //val_wr[current_channel] = 1;
            end
        end
    end

endmodule
