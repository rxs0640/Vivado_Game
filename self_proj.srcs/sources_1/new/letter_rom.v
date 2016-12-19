`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/28/2016 08:18:31 PM
// Design Name: 
// Module Name: letter_rom
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


module letter_rom(
    input wire [9:0] pix_x, pix_y,
    input wire [4:0] left, top,
    input wire [1:0] selector,
    output wire [8:0] rom_bit
    );
    wire [4:0] address, column;
    reg [8:0] data;
    
    always @*
        case(selector)
            0:
                // W I N
                case(address)
                    4'h0: data = 45'b011000011000001111110000111000011;            
                    4'h1: data = 45'b011000011000000011000000111100011;              
                    4'h2: data = 45'b011000011000000011000000110110011;              
                    4'h3: data = 45'b011011011000000011000000110111011;                
                    4'h4: data = 45'b011011011000000011000000110011111;                
                    4'h5: data = 45'b011011011000000011000000110000111;                
                    4'h6: data = 45'b011111111000001111110000110000011;
                 endcase
            1:
                // D I E D
                case(address)
                    4'h0: data = 45'b011111000000001111110000111111100000011111000;
                    4'h1: data = 45'b010000010000000011000000100000000000010000010;
                    4'h2: data = 45'b010000001000000011000000100000000000010000001;
                    4'h3: data = 45'b010000001000000011000000111111100000010000001;
                    4'h4: data = 45'b010000001000000011000000100000000000010000001;
                    4'h5: data = 45'b010000010000000011000000100000000000010000010;
                    4'h6: data = 45'b011111000000001111110000111111100000011111000;
                endcase
        endcase
        
        assign address = pix_y[4:0] - top[4:0];
        assign column = pix_x[4:0] - left[4:0];
        assign rom_bit = data[column];
endmodule
