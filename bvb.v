module bvb(
    input clk,
    input rst,

    // input fifo connections
    input  [channel_num*col_id_size-1:0] id,
    input  [channel_num-1:0] id_empty,
    output reg [channel_num-1:0] id_read,

    // output fifo outputs
    output [channel_num*8-1:0] val,
    output [channel_num-1:0]   val_empty,
    input  [channel_num-1:0]   val_read
);

    parameter channel_num  = 4;
    parameter col_id_size  = 10; // if 1024 columns
    parameter counter_bits = 3;
    parameter counter_max  = 8;  // if ram has 8 sections

    reg [6:0] image_start;
    reg [counter_bits-1:0] counter; // counts on which cell in ram we are

    reg [channel_num-1:0]   val_wr_en;
    wire [channel_num-1:0]   val_full;

    wire [1023:0] ram_out;

    reg [9:0] local_id [channel_num-1:0];

    vector_ram vector_ram (
        .clk(clk), 
        .write_enable(), 
        .in(), 
        .addr(image_start + counter), 
        .out(ram_out)
    );

    genvar f;
    generate
        for (f=0; f<channel_num; f=f+1) begin: FIFO_BVB
            fifo_bvb fifo_bvb(
                .clk(clk), // input clk
                .din(ram_out[local_id[f]+7-:8]), // input [7 : 0] din
                .wr_en(val_wr_en[f]), // input wr_en
                .rd_en(val_read[f]), // input rd_en
                .dout(val[f*8+7:f*8]), // output [7 : 0] dout
                .full(val_full[f]), // output full
                .empty(val_empty[f]) // output empty

            );
        end
    endgenerate

    genvar i;
    generate
        for (i=0; i<channel_num; i=i+1) begin: MUX
            always @ (posedge clk) begin
                // check the counter_bits MSB of id == counter
                if (counter == id[i*col_id_size+col_id_size-1:i*col_id_size+col_id_size-counter_bits] 
                    & ~id_empty[i]
                    & ~val_full[i]) begin 
                    
                    id_read[i]   <= 1;
                    val_wr_en[i] <= 1;
                    local_id[i]  <= id[i*10+9:i*10] << 3; 
                end
                else begin
                    id_read[i]   <= 0;
                    val_wr_en[i] <= 0;
                end
            end
        end
    endgenerate


    always @ (posedge clk) begin
        if (rst) begin
            counter <= 0;
            image_start <= 0;
        end
        else begin
            counter <= (counter == counter_max) ? 0 :counter + 1;
        end
    end

endmodule   
