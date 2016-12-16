

module bvb(
    input clk,
    input rst,

    // input fifo connections
    input  [channel_num*col_id_size-1:0] id,
    input  [channel_num-1:0]             id_fifo_empty,
    output reg [channel_num-1:0]         id_fifo_read,

    // output fifo outputs, this fifo is inside the module
    output [channel_num*8-1:0] vec,
    output [channel_num-1:0]   vec_fifo_empty,
    input  [channel_num-1:0]   vec_fifo_read
);
    `include "params.vh"

    // output vector inputs 
    reg [channel_num-1:0]  vec_fifo_wr_en;
    wire [channel_num-1:0] vec_fifo_full;


    // for an input column id, holds the bank_id which is the first n bits 
    wire [ram_split_bits-1:0] bank_id [channel_num-1:0]; 
    genvar ch;
    for (ch=0; ch<channel_num; ch=ch+1)
        assign bank_id[ch] = id[(ch+1)*col_id_size-1-:ram_split_bits];

    // holds the address inside the bank
    wire [col_id_size-ram_split_bits-1:0] local_id [channel_num-1:0]; // for an input column id, holds the bank_id which is the first n bits 
    for (ch=0; ch<channel_num; ch=ch+1)
        assign local_id[ch] = id[(ch+1)*col_id_size-ram_split_bits:ch*col_id_size];
    //////////////

    reg [bvb_addr_size:0] image_start;
    reg [ram_split_bits-1:0] counter; // counts on which cell in ram we are
    wire [ram_width:0] ram_out; // wire from the ram to the FIFOs

    // RAM has a width of ram_width
    // each image can be split into ram_splits chunks of ram_width bits
    // the counter goes over the image, iteratively loading the next chunk
    vector_ram vector_ram (
        .clk(clk), 
        .write_enable(), // we wont be doing any writing
        .in(), 
        .addr(image_start + counter), 
        .out(ram_out)
    );

    // generate the output FIFOs for vector values, one FIFO per channel
    genvar f;
    generate
        for (f=0; f<channel_num; f=f+1) begin: FIFO_BVB
            fifo_bvb fifo_bvb(
                .clk(clk), // input clk
                .din(ram_out[local_id[f]+val_bits-1-:val_bits]), // input [7 : 0] din
                .wr_en(vec_fifo_wr_en[f]), // input wr_en
                .rd_en(vec_fifo_read[f]), // input rd_en
                .dout(vec[f*val_bits+val_bits-1:f*val_bits]), // output [7 : 0] dout
                .full(vec_fifo_full[f]), // output full
                .empty(vec_fifo_empty[f]) // output empty
            );
        end
    endgenerate


    // for each channel, check if the requested index is in the current bank.
    // The current bank is counter, and the requested bank is bank_id
    genvar i;
    generate
        for (i=0; i<channel_num; i=i+1) begin: MUX
            always @ (posedge clk) begin
                // check the ram_split_bits MSB of id == counter
                if (counter == bank_id[i]
                    & ~id_fifo_empty[i]
                    & ~vec_fifo_full[i]) begin 
                    
                    id_fifo_read[i] <= 1;
                    vec_fifo_wr_en[i] <= 1;
                end
                else begin
                    id_fifo_read[i] <= 0;
                    vec_fifo_wr_en[i] <= 0;
                end
            end
        end
    endgenerate


    // moves the counter around
    always @ (posedge clk) begin
        if (rst) begin
            counter <= 0;
            image_start <= 0;
        end
        else begin
            counter <= (counter == ram_splits) ? 0 :counter + 1;
        end
    end

endmodule   
