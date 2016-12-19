`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11/03/2016 05:17:20 PM
// Design Name:
// Module Name: self_top
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


// Listing 13.6
module self_top
   ( input wire clk, reset, PS2Clk,
    input wire PS2Data,
    output wire hsync, vsync,
    output wire [11:0] rgb,
    output wire LED,
    output [6:0] seg,
    output [7:0] an,
    output dp,
    output RsTx                             //Keyboard output ??
   );
   // signal declaration
   wire clk_50m;
   wire [9:0] pixel_x, pixel_y;
   wire video_on, pixel_tick;
   reg [11:0] rgb_reg;
   wire [11:0] rgb_next;
   wire btn_tick;
   // body
   
   // 50 MHz clock
   clk_50m_generator myclk(clk, reset_clk, clk_50m);
  //--------------------------------------------
   // PS2 keyboard
   //--------------------------------------------
   // Instantiate variables
   wire done_tick;
   wire [7:0] curr_out;
   reg [7:0] f0flag;
   reg [7:0] prev_out;
   reg [3:0] btn = 4'b0000;
      //Create PS2 unit
   ps2_rx ps2_unit
      (.clk(clk_50m), .reset(reset), .ps2d(PS2Data), .ps2c(PS2Clk), .rx_en(1'b1),
      .rx_done_tick(done_tick), .dout(curr_out)
      );
  		
   always @ (posedge done_tick, posedge reset) begin
        if(reset) begin
            btn = 0;
            f0flag = 0;
            prev_out = 0;
        end
        else begin
           if(done_tick) begin
           	if(prev_out != 8'hF0)
		    	begin
					if (curr_out == 8'hF0)
						f0flag = 1;
					else if (curr_out == 8'h1B)
					    btn = 4'b0001;
				    else if(curr_out == 8'h2B)
						btn = 4'b0010;                         
				    else if (curr_out == 8'h24)
					    btn = 4'b0100;   
					else if (curr_out == 8'h23)
						btn = 4'b1000;
				  	else
					    btn = 0;
					prev_out = curr_out;
			  	end
		    
		    else if(f0flag) begin
				btn = 0;
			    prev_out = curr_out;
			    f0flag = 0;
		    end
			
			else begin
				btn = 0;
			end
        end
        end
   end
		
   //Create 7 segment display unit
   seg7decimal seg_unit (
    .x(btn[0]), .clk(clk_50m), .seg(seg), .an(an), .dp(dp), .y(btn[2]), .w(btn[1]), .z(btn[3])
   );
   
   // instantiate vga sync circuit
   vga_sync vsync_unit (
       .clk(clk_50m), .reset(reset), .hsync(hsync), .vsync(vsync),
       .video_on(video_on), .p_tick(pixel_tick),
       .pixel_x(pixel_x), .pixel_y(pixel_y));
   // instantiate graphic generator
   self_anim an_unit
      (.clk(clk_50m), .reset(reset), .btn(btn),
       .video_on(video_on), .pix_x(pixel_x),
       .pix_y(pixel_y), .graph_rgb(rgb_next), .LED(LED));
   // rgb buffer
   always @(posedge clk)
      if (pixel_tick)
         rgb_reg <= rgb_next;
   // output
   assign rgb = rgb_reg;
endmodule