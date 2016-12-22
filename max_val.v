module max_val(
    input clk,
    input rst,
    input enable,
    input signed [accumulator_size-1:0] stream,
    input [row_id_size-1:0] index,
    output [row_id_size-1:0] max_index
);
    `include "params.vh"

    reg [3:0] current_index;
    reg signed [accumulator_size-1:0] max_value;

    always @ (posedge clk) begin
        if (rst) begin
            current_index = 0;
            max_value = 0;
            max_value[accumulator_size-1] = 1; //very negative
        end
        else begin
            if (enable)
                if (stream > max_value) begin
                    current_index = index;
                    max_value = stream;
                end
        end
    end

    assign max_index = current_index;

endmodule
