module first_one (
    input [n-1:0] seq,
    output [logn-1:0] addr,
    output has_ones
);
    `include "params.vh"

    parameter n=channel_num;
    parameter logn=channel_num_log;

    assign addr[logn-1] = (seq[n/2-1:0] == 0);
    assign has_ones = seq != 0;

    genvar i;
    generate
        for (i=logn-2; i>=0; i=i-1) begin : LOOP
            assign addr[i] = seq[(addr[logn-1:i+1]<<(i+1))+(1<<i)-1-:(1<<i)] == 0;
        end
    endgenerate

endmodule
