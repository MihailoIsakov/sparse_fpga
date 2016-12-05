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
    input val_read,
	output [7:0] out,
    output empty
    );

    // These should be templated and generated in python
    parameter channel_num = 4;
    parameter W1_val_start = 0;
    parameter W1_col_start = 3971;
    parameter W1_len_start = 7942;

    reg [15:0] rom_addr;
    reg [15:0] val_addr;
    //reg [15:0] col_addr;
    //reg [15:0] len_addr;
	 
    wire [7:0] rom_out;

    reg val_wr;
    wire [7:0] val_wr_data, full;

    rom rom (
        .clk(clk),
        .a(rom_addr),
        .spo(rom_out)
    );

    fifo val_fifo (
        .clk(clk), // input clk
        .srst(rst), // input srst
        .din(val_wr_data), // input [7 : 0] din
        .wr_en(val_wr), // input wr_en
        .rd_en(val_read), // input rd_en
        .dout(out), // output [7 : 0] dout
        .full(full), // output full
        .empty(empty) // output empty

    );  

    //fifo col_fifo (
        //.clk(clk), // input clk
        //.srst(rst), // input srst
        //.din(din), // input [7 : 0] din
        //.wr_en(wr_en), // input wr_en
        //.rd_en(rd_en), // input rd_en
        //.dout(dout), // output [7 : 0] dout
        //.full(full), // output full
        //.empty(empty) // output empty

    //);  

    //fifo len_fifo (
        //.clk(clk), // input clk
        //.srst(rst), // input srst
        //.din(din), // input [7 : 0] din
        //.wr_en(wr_en), // input wr_en
        //.rd_en(rd_en), // input rd_en
        //.dout(dout), // output [7 : 0] dout
        //.full(full), // output full
        //.empty(empty) // output empty

    //);  
    
    assign val_wr_data = rom_out;

    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            rom_addr <= 0;
            val_addr <= 0;
        end
        else begin
            if (~full) begin
                val_wr <= 1;
                rom_addr <= W1_val_start + val_addr;
                val_addr <= val_addr + 1;
            end
        end
    end

endmodule
