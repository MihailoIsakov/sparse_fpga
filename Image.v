`include "definitions.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:21:08 12/04/2016 
// Design Name: 
// Module Name:    Image 
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


module Image(
    input wire clk, 
    input wire rst,
	 input wire [3:0] input_index, // the image memory
	 input wire [3:0] output_index,
	 input wire switch,
	 
	 output wire [7:0] Led,
    output reg [7:0] rgb, // the output rgb color
    output wire hsync, //hsync signal
    output wire vsync //vsync signal
    );
	 
	 reg wr_en;
	 reg [15:0] index=0;
	 wire [7:0] rgb_o;
	 integer i,j;
	
	 
	 reg clk_count;
    reg clk_monitor;
	 always@(posedge clk) begin
		clk_count <= ~clk_count;
      if (clk_count) begin
			clk_monitor <= ~clk_monitor;
      end
	 end
    
	 reg [9:0] counter_x = 0;
    reg [9:0] counter_y = 0;
	 always @ (posedge clk_monitor) begin
       if (counter_x >= `PIXEL_WIDTH + `HSYNC_FRONT_PORCH + `HSYNC_PULSE_WIDTH + `HSYNC_BACK_PORCH) begin
           counter_x <= 0;
           if (counter_y >= `PIXEL_HEIGHT + `VSYNC_FRONT_PORCH + `VSYNC_PULSE_WIDTH + `VSYNC_BACK_PORCH) begin
               counter_y <= 0;
           end else begin
               counter_y <= counter_y + 1;
           end
       end else begin
           counter_x <= counter_x + 1;
       end
    end
	 
    assign hsync = ~(counter_x >= (`PIXEL_WIDTH + `HSYNC_FRONT_PORCH) &&
                     counter_x < (`PIXEL_WIDTH + `HSYNC_FRONT_PORCH + `HSYNC_PULSE_WIDTH));
    assign vsync = ~(counter_y >= (`PIXEL_HEIGHT + `VSYNC_FRONT_PORCH) &&
                     counter_y < (`PIXEL_HEIGHT + `VSYNC_FRONT_PORCH + `VSYNC_PULSE_WIDTH));
	 
	 vector_bram vector_bram_(.addra(index),
//					.dina(pixel_i),
					.wea(wr_en),
					.clka(clk),
					.douta(rgb_o)
					);
	 
	 always@(posedge clk) begin
		if(rst==1) begin
			index<=0;
			rgb<=`BLACK;
		end else begin
			if((counter_x > (`PIXEL_WIDTH - `BLOCK_SIZE*`BLOCKS_WIDE)/2) && 
				(counter_x < (`PIXEL_WIDTH + `BLOCK_SIZE*`BLOCKS_WIDE)/2) && 
				(counter_y > (`PIXEL_HEIGHT - `BLOCK_SIZE*`BLOCKS_HIGH)/2) &&
				(counter_y < (`PIXEL_HEIGHT + `BLOCK_SIZE*`BLOCKS_HIGH)/2)) begin
				
				j=(counter_y-(`PIXEL_HEIGHT-`BLOCK_SIZE*`BLOCKS_HIGH)/2)/`BLOCK_SIZE;
				i=(counter_x-(`PIXEL_WIDTH-`BLOCK_SIZE*`BLOCKS_WIDE)/2)/`BLOCK_SIZE;
				if(switch==0) begin
					rgb<=rgb_o;
					case(input_index) 
						4'b0000: 		  index<=j*`BLOCKS_WIDE+i;
						4'b0001: 		  index<=j*`BLOCKS_WIDE+i+1024;
						4'b0010: 		  index<=j*`BLOCKS_WIDE+i+2048;
						4'b0011: 		  index<=j*`BLOCKS_WIDE+i+3072;
						4'b0100: 		  index<=j*`BLOCKS_WIDE+i+4096;
						4'b0101: 		  index<=j*`BLOCKS_WIDE+i+5120;
						4'b0110: 		  index<=j*`BLOCKS_WIDE+i+6144;
						4'b0111: 		  index<=j*`BLOCKS_WIDE+i+7168;
						4'b1000:         index<=j*`BLOCKS_WIDE+i+8192;
						4'b1001:         index<=j*`BLOCKS_WIDE+i+9216;
						default: 	     index<=j*`BLOCKS_WIDE+i;
					endcase; 
				end else begin
				case(output_index)
					4'b0000:	begin
						if((i<=4) || (i>=24) || (j<=4) || (j>=24)) begin
							rgb<=`RED;
						end else begin
							rgb<=`BLACK;
						end
					end
					4'b0001: 	begin
						if((i>=24)) begin
							rgb<=`RED;
						end else begin
							rgb<=`BLACK;
						end
					end
					4'b0010:  begin
						if((i>=4 && j<=4) || (i>=24 && j<=14) || (j<=16 && j>=12) || (i<=4 && j>=14) || (j>=24)) begin
							rgb<=`RED;
						end else begin
							rgb<=`BLACK;
						end
					end
					4'b0011:   begin
						if((i>=4 && j<=4) || (i>=24 && j<=14) || (j<=16 && j>=12) || (i>=24 && j>=14) || (j>=24)) begin
							rgb<=`RED;
						end else begin
							rgb<=`BLACK;
						end
					end
					4'b0100: 	begin
						if((i<=4 && j<=14) || (i>=24 && j<=14) || (j<=16 && j>=12) || (i>=24 && j>=14)) begin
							rgb<=`RED;
						end else begin
							rgb<=`BLACK;
						end
					end
					4'b0101:   begin
						if((i>=4 && j<=4) || (i<=4 && j<=14) || (j<=16 && j>=12) || (i>=24 && j>=14) || (j>=24)) begin
							rgb<=`RED;
						end else begin
							rgb<=`BLACK;
						end
					end
					4'b0110:   begin
						if((i>=4 && j<=4) || (i<=4 && j<=14) || (i<=4 && j>=14) || (j<=16 && j>=12) || (i>=24 && j>=14) || (j>=24)) begin
							rgb<=`RED;
						end else begin
							rgb<=`BLACK;
						end
					end
					4'b0111:   begin
						if((j<=4) || (i>=24)) begin
							rgb<=`RED;
						end else begin
							rgb<=`BLACK;
						end
					end
					4'b1000:   begin
						if((i>=4 && j<=4) || (i<=4 && j<=14) || (i<=4 && j>=14) || (j<=16 && j>=12) || (i>=24 && j>=14) || (j>=24) || (i>=24 && j<=14)) begin
							rgb<=`RED;
						end else begin
							rgb<=`BLACK;
						end
					end
					4'b1001:    begin
						if((i>=4 && j<=4) || (i<=4 && j<=14) || (j<=16 && j>=12) || (i>=24 && j>=14) || (j>=24) || (i>=24 && j<=14)) begin
							rgb<=`RED;
						end else begin
							rgb<=`BLACK;
						end
					end
					default:		begin
						if((i<=4) || (i>=24) || (j<=4) || (j>=24)) begin
							rgb<=`RED;
						end else begin
							rgb<=`BLACK;
						end
					end
					endcase;
				end
			end else begin
				rgb<=`BLACK;
			end
			
		end
	end

endmodule
