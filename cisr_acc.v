module cisr_acc(
    input clk,
    input rst,

    // row lengths FIFO inputs
    input      [row_len_size*channel_num-1:0] row_len_fifo_data, 
    input      [channel_num-1:0]              row_len_fifo_empty, 
    output reg [channel_num-1:0]              row_len_fifo_read, 

    // channel multiplier FIFO
    input      [val_bits*2*channel_num-1:0] mult_fifo_data, 
    input      [channel_num-1:0]           mult_fifo_empty, 
    output reg [channel_num-1:0]           mult_fifo_read, 

    //saving 
    output                        write_data,
    output [row_id_size-1:0]      addr_data,
    output reg [accumulator_size-1:0] data
);
    `include "params.vh"

    genvar j;
    integer i;

    reg [counter_size-1:0]     counters     [channel_num-1:0]; // keeps track how many more elements need to be processed
    reg [row_id_size-1:0]      row_ids      [channel_num-1:0]; // keeps track of where the results should be written
    reg signed [accumulator_size-1:0] accumulators [channel_num-1:0]; // accumulators, TODO the size could be better defined

    reg [row_id_size-1:0]  next_id; // next id to be assigned to a channel

    // logic for finding if any counters are zero, and the lowest one
    wire [channel_num-1:0] is_zero;
    generate for (j=0; j<channel_num; j=j+1) begin: IS_ZERO
        assign is_zero[j] = (counters[j] == 0);
    end
    endgenerate
    wire has_zero_counters;
    wire [channel_num_log-1:0] first_index;
    first_one first_one(is_zero, first_index, has_zero_counters);
    //

    // converting mult vector into signed memory
    wire signed [val_bits*2-1:0] mults [channel_num-1:0];
    generate 
        for(j=0; j<channel_num; j=j+1) begin: SIGNED_MULT
            assign mults[j] = mult_fifo_data[j*val_bits*2+:val_bits*2];
        end 
    endgenerate
    //

    always @ (posedge clk) begin
        if (rst) begin
            next_id <= 0; // the assigned ids at the start range from 0 to channel_num-1
            row_len_fifo_read <= 0;
            mult_fifo_read    <= 0;

            for (i=0; i<channel_num; i=i+1) begin
                counters[i]     <= 0;
                row_ids[i]      <= 0; // (OR NOT) the assigned ids at the start range from 0 to channel_num-1
                accumulators[i] <= 0;
            end 
        end
        else begin
            row_len_fifo_read = 0; // dont read lengths. If any counter is zero, some bit will be set to 1 later.

            if (has_zero_counters) begin // if any channel has finished processing a row, stop and process
                if (~row_len_fifo_empty[first_index]) begin // if the channel cant load the next row_length, stall
                    // reset accumulator
                    data <= accumulators[first_index];
                    accumulators[first_index] <= 0;
                    
                    // load new row length into the counter
                    //counters[first_index] <= row_len_fifo_data[(first_index+1)*row_len_size-1-:(row_len_size-1)];
                    counters[first_index] <= row_len_fifo_data[first_index*row_len_size+:row_len_size];
                    row_len_fifo_read[first_index] = 1;
                    
                    // get the next row_id
                    row_ids[first_index] <= next_id;
                    next_id <= next_id + 1;
                end else begin //stalling as the emptied channel has no row_length to load
                    row_len_fifo_read <= 0;
                end
            end else begin
                if (mult_fifo_empty == 0) begin // if any of the mult fifos is empty, stall
                    for (i=0; i<channel_num; i=i+1) begin
                        // decrement counters
                        counters[i] <= counters[i] - 1;
                        // add the next value
                        //accumulators[i] = accumulators[i] + mult_fifo_data[(i+1)*mult_size-1-:(mult_size)];
                        //accumulators[i] = accumulators[i] + mult_fifo_data[i*mult_size+:mult_size];
                        accumulators[i] <= accumulators[i] + mults[i];
                        // set FIFO to read
                        mult_fifo_read[i] <= 1; 
                    end
                end
                else begin // stalling because not all mult fifos are non-empty
                    mult_fifo_read = 0; 
                end
            end
        end
    end

    // outputs 
    assign addr_data = row_ids[first_index];
    //assign data = accumulators[first_index];
    assign write_data = has_zero_counters;

endmodule
