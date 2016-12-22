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
module column_fetcher(
	input clk,
	input rst,
    // output FIFO
    input  [channel_num-1:0] read,
	output [col_id_size*channel_num-1:0] out, //column fetcher serves all channel_num column FIFOs, 
    output [channel_num-1:0] empty
    );

    `include "params.vh"

    reg  [1:0] current_matrix; // 0, 1, or 2
    reg  [12:0] addr [channel_num-1:0]; // current positions for channels
    reg  [channel_num_log-1:0] channel; 
	 
    // inputs to the column FIFO
    reg  [channel_num-1:0] wr_en;
    wire [channel_num-1:0] full;
    wire [15:0] rom_out;

    rom16 rom (
        .clka(clk),
        .addra(addr[channel]), // remember to generate ROM with 32 bit addresses, no matter the size of the ROM
        .douta(rom_out)
    );

    genvar i;
    generate 
        for (i=0; i < channel_num; i=i+1) begin: FIFO_ALL
            fifo16 fifo (
                .clk(clk), // input clk
                .rst(rst), // input srst
                .din(rom_out), // input [7 : 0] din
                .wr_en(wr_en[i]), // input wr_en
                .rd_en(read[i]), // input rd_en
                .dout(out[i*col_id_size+:col_id_size]), // output [7 : 0] dout
                .full(full[i]), // output full
                .empty(empty[i]) // output empty
            );  
        end
    endgenerate
                                               
    integer j;
    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            current_matrix <= 0;
            channel <= 0;
            wr_en <= 0;

            for (j=0; j<channel_num; j=j+1)
                addr[j] <= col_addr[j*13+:13]; // get starting address from params.vh

        end
        else begin
            if (~full[channel]) begin
                // TODO logic for changing channels

                wr_en = 0;
                wr_en[channel] = 1;

                addr[channel] <= addr[channel] + 1;
            end
            channel <= (channel == channel_num - 1) ? 0 : channel + 1;
        end
    end

endmodule
