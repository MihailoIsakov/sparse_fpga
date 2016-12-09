// Finds the index of the lowest one in a vector seq
// for example, for a vector 00011010, returns a 1 (lowest is on the right)
// addr is the index of the first 1, has_ones is true if the vector isn't all zeros

module first_one (
    input [n-1:0] seq,
    output [logn-1:0] addr,
    output has_ones
);

    parameter n=8;
    parameter logn=3;

	assign addr[logn-1] = (seq[n/2-1:0] == 0);
    assign has_ones = seq != 0;

	genvar i;
    generate
        for (i=logn-2; i>=0; i=i-1) begin : LOOP
		    assign addr[i] = seq[(addr[logn-1:i+1]<<(i+1))+(1<<i)-1-:(1<<i)] == 0;
        end
    endgenerate

endmodule

