module top(
    input clk,
    input rst
);
    `include "params.vh"

    genvar i;

    // value fetcher
    wire [channel_num-1:0]          val_fifo_empty;
    wire [channel_num-1:0]          val_fifo_read;
    wire [val_bits*channel_num-1:0] val_fifo_out;
    wire [val_bits-1:0]             vals [channel_num-1:0];

    value_fetcher value_fetcher (
        .clk(clk),
        .rst(rst),
        .read(val_fifo_read),
        .empty(val_fifo_empty),
        .out(val_fifo_out)
    );
    //

    // column fetcher 
    wire [channel_num-1:0]             col_fifo_empty;
    wire [channel_num-1:0]             col_fifo_read;
    wire [col_id_size*channel_num-1:0] col_fifo_out;
    wire [col_id_size-1:0]             cols [channel_num-1:0];

    column_fetcher column_fetcher(
        .clk(clk),
        .rst(rst),
        .read(col_fifo_read),
        .empty(col_fifo_empty),
        .out(col_fifo_out)
    );
    //
    
    // length fetcher 
    wire [channel_num-1:0]              len_fifo_read;
    wire [channel_num-1:0]              len_fifo_empty;
    wire [row_len_size*channel_num-1:0] len_fifo_out;
    wire [row_len_size-1:0]             lens [channel_num-1:0];

    length_fetcher length_fetcher(
        .clk(clk),
        .rst(rst),
        .read(len_fifo_read),
        .empty(len_fifo_empty),
        .out(len_fifo_out)
    );
    //

    // Banked vector buffer
    wire [val_bits*channel_num-1:0] vec_fifo_out;
    wire [channel_num-1:0]          vec_fifo_read;
    wire [channel_num-1:0]          vec_fifo_empty;
    wire [val_bits-1:0]             vecs [channel_num-1:0];
    
    bvb bvb (
        .clk(clk),
        .rst(rst),
        .id(col_fifo_out),
        .id_fifo_empty(col_fifo_empty),
        .id_fifo_read(col_fifo_read),
        .vec(vec_fifo_out),
        .vec_fifo_read(vec_fifo_read),
        .vec_fifo_empty(vec_fifo_empty)
    );
    //
    
    //// channels 
    wire [val_bits*2*channel_num-1:0] mult_fifo_out;
    wire [channel_num-1:0]            mult_fifo_empty;
    wire [channel_num-1:0]            mult_fifo_read;

    channel channel(
        .clk(clk),
        .rst(rst),
        // vector fifo
        .vec(vec_fifo_out),
        .vec_fifo_empty(vec_fifo_empty),
        .vec_fifo_read(vec_fifo_read),
        // matrix fifo 
        .mat(val_fifo_out),
        .mat_fifo_empty(val_fifo_empty),
        .mat_fifo_read(val_fifo_read),
        // mult out fifo
        .mult(mult_fifo_out),
        .mult_fifo_empty(mult_fifo_empty),
        .mult_fifo_read(mult_fifo_read)
    );
    

    // convert vectors to memories
    generate 
        for (i=0; i<channel_num; i=i+1) begin: VECTOR2MEMORY
            assign vals[i] = val_fifo_out[i*val_bits+:val_bits];
            assign cols[i] = col_fifo_out[i*col_id_size+:col_id_size];
            assign lens[i] = len_fifo_out[i*row_len_size+:row_len_size];
            assign vecs[i] = vec_fifo_out[i*val_bits+:val_bits];
        end
    endgenerate

    assign vec_fifo_read = 15;

endmodule
