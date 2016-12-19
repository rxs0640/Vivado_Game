`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/24/2016 03:01:25 PM
// Design Name: 
// Module Name: spike_rom
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


module spike_rom(
    input wire [9:0] pix_x, pix_y,
    input wire [4:0] SPIKED_Y_T, SPIKED_X_L,
    input wire [4:0] SPIKEU_Y_T, SPIKEU_X_L,
    input wire [4:0] SPIKEL_Y_T, SPIKEL_X_L,
    input wire [4:0] SPIKER_Y_T, SPIKER_X_L,
    output wire [4:0] spiker_rom_bit,  spikel_rom_bit, spikeu_rom_bit, spiked_rom_bit
    );
    reg [12:0] spiked_rom_data, spikeu_rom_data, spikel_rom_data, spiker_rom_data;
    wire [4:0] spiked_rom_col,spikeu_rom_col, spikel_rom_col, spiker_rom_col;
    wire [4:0] spiked_rom_addr, spikeu_rom_addr, spiker_rom_addr, spikel_rom_addr;
    //Image ROM up
    always @*
    case (spikeu_rom_addr)
        4'h0: spikeu_rom_data = 13'b0000001000000;                        //      *
        4'h1: spikeu_rom_data = 13'b0000001000000;                        //      *
        4'h2: spikeu_rom_data = 13'b0000011100000;                        //     ***
        4'h3: spikeu_rom_data = 13'b0000011100000;                        //     ***        
        4'h4: spikeu_rom_data = 13'b0000111110000;                        //    *****
        4'h5: spikeu_rom_data = 13'b0000111110000;                        //    *****        
        4'h6: spikeu_rom_data = 13'b0001111111000;                        //   *******
        4'h7: spikeu_rom_data = 13'b0001111111000;                        //   *******                
        4'h8: spikeu_rom_data = 13'b0011111111100;                        //  *********
        4'h9: spikeu_rom_data = 13'b0011111111100;                        //  *********                
        4'hA: spikeu_rom_data = 13'b0111111111110;                        // ***********
        4'hB: spikeu_rom_data = 13'b0111111111110;                        // ***********    
        4'hC: spikeu_rom_data = 13'b1111111111111;                        //*************
        4'hD: spikeu_rom_data = 13'b1111111111111;                        //*************
        4'hE: spikeu_rom_data = 13'b1111111111111;                        //*************
        4'hF: spikeu_rom_data = 13'b1111111111111;                        //*************
    endcase
    
    //enable details for spike1 up
    assign spikeu_rom_addr = pix_y[4:0] - SPIKEU_Y_T[4:0];
    assign spikeu_rom_col = pix_x[4:0] - SPIKEU_X_L[4:0];
    assign spikeu_rom_bit = spikeu_rom_data[spikeu_rom_col];
    
    //Image ROM down
    always @*
    case (spiked_rom_addr)
        4'h0: spiked_rom_data = 13'b1111111111111;                        //*************
        4'h1: spiked_rom_data = 13'b1111111111111;                        //*************
        4'h2: spiked_rom_data = 13'b1111111111111;                        //*************
        4'h3: spiked_rom_data = 13'b1111111111111;                        //*************
        4'h4: spiked_rom_data = 13'b0111111111110;                        // ***********
        4'h5: spiked_rom_data = 13'b0111111111110;                        // ***********
        4'h6: spiked_rom_data = 13'b0011111111100;                        //  *********
        4'h7: spiked_rom_data = 13'b0011111111100;                        //  *********
        4'h8: spiked_rom_data = 13'b0001111111000;                        //   *******
        4'h9: spiked_rom_data = 13'b0001111111000;                        //   *******
        4'hA: spiked_rom_data = 13'b0000111110000;                        //    *****
        4'hB: spiked_rom_data = 13'b0000111110000;                        //    *****
        4'hC: spiked_rom_data = 13'b0000011100000;                        //     ***
        4'hD: spiked_rom_data = 13'b0000011100000;                        //     ***
        4'hE: spiked_rom_data = 13'b0000001000000;                        //      *
        4'hF: spiked_rom_data = 13'b0000001000000;                        //      *
    endcase
    
    // enable details for spike2 down
    assign spiked_rom_addr = pix_y[4:0] - SPIKED_Y_T[4:0];             //Need to chnge
    assign spiked_rom_col = pix_x[4:0] - SPIKED_X_L[4:0];              //need to change
    assign spiked_rom_bit = spiked_rom_data[spiked_rom_col];
    
    //Image ROM right
    always @*
    case (spiker_rom_addr)
        4'h0: spiker_rom_data = 13'b1100000000000;                        //**
        4'h1: spiker_rom_data = 13'b1111000000000;                        //****
        4'h2: spiker_rom_data = 13'b1111110000000;                        //******
        4'h3: spiker_rom_data = 13'b1111111100000;                        //********
        4'h4: spiker_rom_data = 13'b1111111111000;                        //**********
        4'h5: spiker_rom_data = 13'b1111111111100;                        //***********
        4'h6: spiker_rom_data = 13'b1111111111110;                        //************
        4'h7: spiker_rom_data = 13'b1111111111111;                        //*************
        4'h8: spiker_rom_data = 13'b1111111111111;                        //*************
        4'h9: spiker_rom_data = 13'b1111111111110;                        //************
        4'hA: spiker_rom_data = 13'b1111111111100;                        //***********
        4'hB: spiker_rom_data = 13'b1111111111000;                        //**********
        4'hC: spiker_rom_data = 13'b1111111100000;                        //********
        4'hD: spiker_rom_data = 13'b1111110000000;                        //******
        4'hE: spiker_rom_data = 13'b1111000000000;                        //****
        4'hF: spiker_rom_data = 13'b1100000000000;                        //**
    endcase
    
    // enable details for spike2 right
    assign spiker_rom_addr = pix_y[4:0] - SPIKER_Y_T[4:0];             //Need to change this
    assign spiker_rom_col = pix_x[4:0] - SPIKER_X_L[4:0];              // Need to change this
    assign spiker_rom_bit = spiker_rom_data[spiker_rom_col];
    
    //Image ROM left
        always @*
        case (spikel_rom_addr)
            4'h0: spikel_rom_data = 13'b0000000000011;                        //           **
            4'h1: spikel_rom_data = 13'b0000000001111;                        //         ****
            4'h2: spikel_rom_data = 13'b0000000111111;                        //       ******
            4'h3: spikel_rom_data = 13'b0000011111111;                        //     ********
            4'h4: spikel_rom_data = 13'b0001111111111;                        //   **********
            4'h5: spikel_rom_data = 13'b0011111111111;                        //  ***********
            4'h6: spikel_rom_data = 13'b0111111111111;                        // ************
            4'h7: spikel_rom_data = 13'b1111111111111;                        //*************
            4'h8: spikel_rom_data = 13'b1111111111111;                        //*************
            4'h9: spikel_rom_data = 13'b0111111111111;                        // ************
            4'hA: spikel_rom_data = 13'b0011111111111;                        //  ***********
            4'hB: spikel_rom_data = 13'b0001111111111;                        //   **********
            4'hC: spikel_rom_data = 13'b0000011111111;                        //     ********
            4'hD: spikel_rom_data = 13'b0000000111111;                        //       ******
            4'hE: spikel_rom_data = 13'b0000000001111;                        //         ****
            4'hF: spikel_rom_data = 13'b0000000000011;                        //           **
        endcase
        
        // enable details for spike2 left
        assign spikel_rom_addr = pix_y[4:0] - SPIKEL_Y_T[4:0];
        assign spikel_rom_col = pix_x[4:0] - SPIKEL_X_L[4:0];
        assign spikel_rom_bit = spikel_rom_data[spikel_rom_col];
endmodule
