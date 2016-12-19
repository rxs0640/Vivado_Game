`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/17/2016 06:24:09 PM
// Design Name: 
// Module Name: display_rom
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


module display_rom (
	input wire [4:0] address,
    input wire [7:0] counter,
    output reg [8:0] data
	);
	//--------------------------------------------
	// Numbers
	//--------------------------------------------
	always @* 
		case(counter) 
			4'd0:
				case(address)
                    4'h0: data = 9'b001111100;			//  *****
                    4'h1: data = 9'b010000010;			// *     *  
                    4'h2: data = 9'b010000010;			// *     * 
                    4'h3: data = 9'b010000010;			// *     *
                    4'h4: data = 9'b010000010;			// *     * 
                    4'h5: data = 9'b010000010;			// *     * 
                    4'h6: data = 9'b001111100;			//  ***** 
			    endcase
			4'd1:
				case(address)
					4'h0: data = 9'b000010000;			//    *    
					4'h1: data = 9'b000010000;			//    *
					4'h2: data = 9'b000010000;			//    *
					4'h3: data = 9'b000010000;			//    *
					4'h4: data = 9'b000010000;			//    *
					4'h5: data = 9'b000010000;			//    *
					4'h6: data = 9'b000010000;			//    *
			    endcase
			4'd2:
				case(address)
					4'h0: data = 9'b000111000;			//   ***
					4'h1: data = 9'b000000100;			//      *
					4'h2: data = 9'b000000100;			//      *
					4'h3: data = 9'b000111000;			//   ***
					4'h4: data = 9'b001000000;			//  *
					4'h5: data = 9'b001000000;			//  *
					4'h6: data = 9'b000111000;			//   ***
				endcase
			4'd3:
				case(address)
					4'h0: data = 9'b000111000;			//   ***
					4'h1: data = 9'b000000100;			//      *
					4'h2: data = 9'b000000100;			//      *
					4'h3: data = 9'b000111000;			//   ***
					4'h4: data = 9'b000000100;			//      *
					4'h5: data = 9'b000000100;			//      *
					4'h6: data = 9'b000111000;			//   ***
				endcase
			4'd4:
				case(address)
					4'h0: data = 9'b010000100;			//  *    *
					4'h1: data = 9'b010000100;			//  *    *
					4'h2: data = 9'b010000100;			//  *    *
					4'h3: data = 9'b011111100;			//  ******
					4'h4: data = 9'b000000100;			//       *
					4'h5: data = 9'b000000100;			//       *
					4'h6: data = 9'b000000100;			//       *
				endcase
			4'd5:
				case(address)
					4'h0: data = 9'b000111110;			//   *****
					4'h1: data = 9'b000100000;			//   *
					4'h2: data = 9'b000100000;			//   *
					4'h3: data = 9'b000111110;			//   *****
					4'h4: data = 9'b000000010;			//       *
					4'h5: data = 9'b000000010;			//       *
					4'h6: data = 9'b000111110;			//   *****
				endcase
			4'd6:
				case(address)
					4'h0: data = 9'b001111110;			//  ******
					4'h1: data = 9'b001000000;			//  *
					4'h2: data = 9'b001000000;			//  *
					4'h3: data = 9'b001111110;			//  ******
					4'h4: data = 9'b001000010;			//  *    *
					4'h5: data = 9'b001000010;			//  *    *
					4'h6: data = 9'b001111110;			//  ******
				endcase
			4'd7:
				case(address)
					4'h0: data = 9'b001111110;			//  ******
					4'h1: data = 9'b000000010;			//       *
					4'h2: data = 9'b000000010;			//       *
					4'h3: data = 9'b000000010;			//       *
					4'h4: data = 9'b000000010;			//       *
					4'h5: data = 9'b000000010;			//       *
					4'h6: data = 9'b000000010;			//       *
				endcase
			4'd8:
				case(address)
					4'h0: data = 9'b001111100;          //  *****
					4'h1: data = 9'b001000100;          //  *   *
					4'h2: data = 9'b001000100;          //  *   *
					4'h3: data = 9'b001111100;          //  *****
					4'h4: data = 9'b001000100;          //  *   *
					4'h5: data = 9'b001000100;          //  *   * 
					4'h6: data = 9'b001111100;          //  *****
				endcase
			4'd9:
				case(address)
					4'h0: data = 9'b001111110;			//  ******
					4'h1: data = 9'b001000010;			//  *    *
					4'h2: data = 9'b001000010;			//  *    *
					4'h3: data = 9'b001111110;			//  ******
					4'h4: data = 9'b000000010;			//       *
					4'h5: data = 9'b000000010;			//       *
					4'h6: data = 9'b000000010;			//       *
				endcase
		endcase
endmodule