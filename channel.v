module channel(
    input clk,
    input rst,

    // vector values FIFO
    input  [channel_num*val_bits-1:0] vec,
    input  [channel_num-1:0]          vec_fifo_empty,
    output [channel_num-1:0]          vec_fifo_read,

    // matrix values FIFO
	input  [channel_num*val_bits-1:0] mat, 
    input  [channel_num-1:0]          mat_fifo_empty,
    output [channel_num-1:0]          mat_fifo_read,

    //output fifo
	output [val_bits*2*channel_num-1:0] mult, 
    output [channel_num-1:0]           mult_fifo_empty,
    input  [channel_num-1:0]           mult_fifo_read
);
    `include "params.vh"

    wire signed [val_bits-1:0]   signed_vec [channel_num-1:0];
    wire signed [val_bits-1:0]   signed_mat [channel_num-1:0];
    wire signed [val_bits*2-1:0] signed_res [channel_num-1:0];

    wire [channel_num-1:0] mult_fifo_write;
    wire [channel_num-1:0] mult_fifo_full;

    assign mult_fifo_write = (~vec_fifo_empty && ~mat_fifo_empty && ~mult_fifo_full); 
    assign vec_fifo_read = mult_fifo_write;
    assign mat_fifo_read = mult_fifo_write;

    genvar i; 
    generate
    for (i=0; i<channel_num; i=i+1) begin: WIRES2MEM
        assign signed_vec[i] = vec[i*val_bits+:val_bits];
        assign signed_mat[i] = mat[i*val_bits+:val_bits];
        assign signed_res[i] = signed_mat[i] * signed_vec[i];

        fifo16 fifo(
            .clk(clk),
            .rst(rst),
            .din(signed_res[i]),
            .wr_en(mult_fifo_write[i]),
            .rd_en(mult_fifo_read[i]),
            .dout(mult[i*mult_size+:mult_size]),
            .full(mult_fifo_full[i]),
            .empty(mult_fifo_empty[i])
        );
    end
    endgenerate
endmodule
