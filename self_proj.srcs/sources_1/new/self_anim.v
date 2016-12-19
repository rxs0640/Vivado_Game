`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/03/2016 05:18:44 PM
// Design Name: 
// Module Name: self_anim
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


// Listing 13.5
module self_anim (
    input wire clk, reset,
    input wire video_on,
    input wire [3:0] btn,
    input wire jmp_btn,
    input wire [9:0] pix_x, pix_y,
    output reg [11:0] graph_rgb,
    output reg LED
   );
	//--------------------------------------------
	// constants and signal declarations
	//--------------------------------------------
	// x, y coordinates (0,0) to (639,479)
	localparam MAX_X = 640;
	localparam MAX_Y = 480;
	wire refr_tick;
	// object enable signals
	wire char_on;                                                                      // Character
	wire left_bound_on, right_bound_on, top_bound_on, bot_bound_on;                    // Bounds
	/* Spikes */
	wire sboxd_on, sboxu_on, sboxl_on, sboxr_on;
	wire sboxd_detail_on, sboxu_detail_on, sboxl_detail_on, sboxr_detail_on;
	wire obstacle1_on, spike1u_on;
	wire obstacle2_on, spike1d_on;
	wire obstacle3_on, spike2d_on;
	wire obstacle4_on, spike2u_on;
	wire obstacle5_on, spike3d_on;
	wire obstacle6_on, spike3u_on;
	wire obstacle7_on, spike4d_on;
	wire obstacle8_on, spike4u_on;
	wire obstacle9_on, spike1l_on;
	wire obstacle10_on, spike2l_on;
	wire obstacle11_on, spike3l_on;
	wire obstacle12_on, spike4l_on;
	wire obstacle13_on, spike5l_on;
	wire obstacle14_on, spike6l_on;
	wire obstacle15_on, spike7l_on;
	wire obstacle16_on, spike8l_on;
	wire obstacle17_on, spike5d_on;
	wire obstacle18_on, spike6d_on;
	wire obstacle19_on, spike7d_on;
	wire obstacle20_on, spike8d_on;
	wire obstacle21_on, spike5u_on;
	wire obstacle22_on, spike9d_on;
	wire obstacle23_on, spike6u_on;
	wire obstacle24_on, spike7u_on;
	wire obstacle25_on, spike10d_on;
	wire obstacle26_on, spike11d_on;
	wire obstacle27_on, spike12d_on;
	wire obstacle28_on, spike13d_on;
	wire obstacle29_on, spike14d_on;
	wire obstacle30_on, spike9l_on;
	wire obstacle31_on, spike1r_on;
	wire obstacle32_on, spike2r_on;
	wire obstacle33_on, spike15d_on;
	wire obstacle34_on, spike16d_on;
	wire obstacle35_on, spike17d_on;
	wire obstacle36_on, spike18d_on;
	wire obstacle37_on, spike3r_on;
	wire obstacle38_on, spike4r_on;
	wire obstacle39_on, spike5r_on;
	wire obstacle40_on, spike6r_on;
	wire obstacle41_on, spike7r_on;
	wire obstacle42_on, spike19d_on;
	wire obstacle43_on, spike8u_on;
	wire obstacle44_on, spike20d_on;
	wire obstacle45_on, spike21d_on;
	wire obstacle46_on, spike8r_on;
	wire obstacle47_on, spike9r_on;
	wire obstacle48_on, spike10l_on;
	/* Platforms */
	wire start_plat_on, r_stair_on, r_stair2_on;
	wire c_plats_on, c_plats2_on;
	wire c_platl_on, c_platr_on;
	wire c_platl2_on, c_platls_on;
	wire l_sq1_on, l_sq2_on;
	wire s_box_on;
	wire tl_plat_on, tl_box_on;
	wire t_platl_on, t_platr_on;
	wire t_platrs_on, t_platrs2_on;
	wire tr_box_on, end_plat_on;
	/* counters */
	wire vcounter10_on, vcounter1_on;
	wire vc10_on, vc1_on;
	wire dcounter10_on, dcounter1_on;
	wire dc10_on, dc1_on;
	wire wintext_on, diedtext_on;
	wire wtext_on, dtext_on;
	// color enables
	wire [11:0] wall_rgb, char_rgb, spike_rgb, counter_rgb;
	// velocity constants
	localparam VEL_P = 2;
	localparam VEL_N = -2;
	localparam JUMP_H = 80;
	// size constants
    localparam WALL_SIZE = 10;
    localparam SPIKE_SIZE = 15;
    localparam CHAR_SIZE = 13;
	// boundary variables

	    // boundaries
		   // bottom boundary
		   localparam WALL_Y_B1 = MAX_Y;                  //Bottom wall's bottom
		   localparam WALL_Y_T1 = MAX_Y - WALL_SIZE;      //Bottom wall's top
		   // left boundary
		   localparam WALL_X_L1 = 0;                      //Left wall's left
		   localparam WALL_X_R1 = WALL_SIZE;              //Left wall's right
		   // right boundary
		   localparam WALL_X_L2 = MAX_X - WALL_SIZE;      //Right wall's left
		   localparam WALL_X_R2 = MAX_X;                  //Right wall's right
    // platform variables
        // boundaries
           // start platform
           localparam START_PLAT_B = WALL_Y_T1;           //Bottom
           localparam START_PLAT_T = START_PLAT_B - 70;   //Height
           localparam START_PLAT_L = 0;                   //Left
           localparam START_PLAT_R = 40;                  //Right
           // right stair 2nd step
          localparam R_STAIR2_B = WALL_Y_T1;
          localparam R_STAIR2_T = R_STAIR2_B - 40;
          localparam R_STAIR2_R = WALL_X_L2;
          localparam R_STAIR2_L = R_STAIR2_R - (3 * CHAR_SIZE) - VEL_P;
           // right stair 1st step
           localparam R_STAIR_B = WALL_Y_T1;
           localparam R_STAIR_T = R_STAIR_B - 20;
           localparam R_STAIR_R = R_STAIR2_L;
           localparam R_STAIR_L = R_STAIR_R - (3 * CHAR_SIZE) - VEL_P;
           // center plat right
           localparam C_PLATR_B = WALL_Y_T1 - 45;           //Slightly higher than jump height
           localparam C_PLATR_T = C_PLATR_B - 20;
           localparam C_PLATR_R = R_STAIR2_L - 80;
           localparam C_PLATR_L = C_PLATR_R - 150;
           // center plat right stair 1st step
           localparam C_PLATS2_B = C_PLATR_T;
           localparam C_PLATS2_T = C_PLATS2_B - 20;
           localparam C_PLATS2_R = C_PLATR_R - (3 * CHAR_SIZE) - VEL_P;
           localparam C_PLATS2_L = C_PLATS2_R - (3 * CHAR_SIZE) - VEL_P;
           // center plat right stair 2nd step
           localparam C_PLATS_B = C_PLATR_T;
           localparam C_PLATS_T = C_PLATS_B - 40;
           localparam C_PLATS_R = C_PLATS2_L;
           localparam C_PLATS_L = C_PLATS_R - (3 * CHAR_SIZE) - VEL_P;
           // spike box
           localparam S_BOX_B = C_PLATR_T - SPIKE_SIZE;
           localparam S_BOX_T = S_BOX_B - SPIKE_SIZE;
           localparam S_BOX_R = C_PLATR_L - (2 * SPIKE_SIZE);
           localparam S_BOX_L = S_BOX_R - SPIKE_SIZE; 
           // center plat left
           localparam C_PLATL_B = C_PLATR_B;
           localparam C_PLATL_T = C_PLATL_B - 2 - SPIKE_SIZE;
           localparam C_PLATL_R = C_PLATR_L - 80;
           localparam C_PLATL_L = START_PLAT_R + CHAR_SIZE + 40;
           // center plat left level 2
           localparam C_PLATL2_B = C_PLATL_T;
           localparam C_PLATL2_T = C_PLATL2_B - SPIKE_SIZE - 2;
           localparam C_PLATL2_R = C_PLATL_R;
           localparam C_PLATL2_L = C_PLATL_L + (3 * SPIKE_SIZE);
           // center plat left stair 1st step
           localparam C_PLATLS_B = C_PLATL2_T;
           localparam C_PLATLS_T = C_PLATLS_B - 20;
           localparam C_PLATLS_R = C_PLATL2_R - (2 * CHAR_SIZE) - VEL_P;
           localparam C_PLATLS_L = C_PLATLS_R - (3 * CHAR_SIZE) - VEL_P;
           // left sq 1
           localparam L_SQ1_B = C_PLATLS_T;
           localparam L_SQ1_T = L_SQ1_B - 20;
           localparam L_SQ1_R = C_PLATLS_L - (2 * SPIKE_SIZE);
           localparam L_SQ1_L = L_SQ1_R - (3 * CHAR_SIZE) - VEL_P;
           // left sq 2
           localparam L_SQ2_B = L_SQ1_T;
           localparam L_SQ2_T = L_SQ2_B - 20;
           localparam L_SQ2_R = L_SQ1_L;
           localparam L_SQ2_L = C_PLATL_L;
           // top left plat 
           localparam TL_PLAT_B = L_SQ2_T;
           localparam TL_PLAT_T = TL_PLAT_B - 20;
           localparam TL_PLAT_R = L_SQ2_L;
           localparam TL_PLAT_L = WALL_X_R1;
           // top left box
           localparam TL_BOX_B = TL_PLAT_T - 80;
           localparam TL_BOX_T = 0;                            
           localparam TL_BOX_R = C_PLATL_R;
           localparam TL_BOX_L = WALL_X_R1;
           // top plat left
           localparam T_PLATL_B = TL_PLAT_T;
           localparam T_PLATL_T = T_PLATL_B - 20;
           localparam T_PLATL_L = TL_PLAT_R + (2 * SPIKE_SIZE);
           localparam T_PLATL_R = C_PLATL_R;
           // top plat right 
           localparam T_PLATR_B = T_PLATL_T;
           localparam T_PLATR_T = T_PLATR_B - 20;
           localparam T_PLATR_L = T_PLATL_R + (2 * SPIKE_SIZE);
           localparam T_PLATR_R = C_PLATR_R;
           // top plat right platform's step 1
           localparam T_PLATRS_B = T_PLATR_T;
           localparam T_PLATRS_T = T_PLATRS_B - 40;
           localparam T_PLATRS_L = T_PLATR_R - (6 * CHAR_SIZE) - (2 * VEL_P);
           localparam T_PLATRS_R = T_PLATRS_L + (3 * CHAR_SIZE) + VEL_P;
           // top plat right platform's step 2
           localparam T_PLATRS2_B = T_PLATR_T;
           localparam T_PLATRS2_T = T_PLATRS2_B - 20;
           localparam T_PLATRS2_R = T_PLATRS_L;
           localparam T_PLATRS2_L = T_PLATRS2_R - (3 * CHAR_SIZE) - VEL_P;
           // top right box
           localparam TR_BOX_B = T_PLATR_B;
           localparam TR_BOX_T = TR_BOX_B - 80;
           localparam TR_BOX_R = WALL_X_L2;
           localparam TR_BOX_L = R_STAIR_L;
           // end plat
           localparam END_PLAT_B = TR_BOX_T - 50;
           localparam END_PLAT_T = END_PLAT_B - 10;                 // Thinnest platform
           localparam END_PLAT_R = WALL_X_L2;
           localparam END_PLAT_L = R_STAIR2_L;
            // top boundary
            localparam WALL_Y_B2 = END_PLAT_T - 50;              //Top wall's bottom
            localparam WALL_Y_T2 = 0;                      //Top wall's top
    // WIN text
            localparam WINTEXT_X_L = WALL_X_R1 + 20;
            localparam WINTEXT_X_R = WINTEXT_X_L + 45; 
            localparam WINTEXT_Y_T = 30;
            localparam WINTEXT_Y_B = WINTEXT_Y_T + 16;
    // DIED text           
            localparam DIEDTEXT_X_L = WINTEXT_X_L;
            localparam DIEDTEXT_X_R = DIEDTEXT_X_L + 45;
            localparam DIEDTEXT_Y_T = WINTEXT_Y_B + 20;
            localparam DIEDTEXT_Y_B = DIEDTEXT_Y_T + 16;  
    // counter variables
            // victory 10s
            localparam VCOUNTER10_X_L = WINTEXT_X_R + 20;       
            localparam VCOUNTER10_X_R = VCOUNTER10_X_L + 7;        
            localparam VCOUNTER10_Y_T = WINTEXT_Y_T;       
            localparam VCOUNTER10_Y_B = WINTEXT_Y_B;       
            // victory 1s
            localparam VCOUNTER1_X_L = VCOUNTER10_X_R + 15;            
            localparam VCOUNTER1_X_R = VCOUNTER1_X_L + 7;            
            localparam VCOUNTER1_Y_T = VCOUNTER10_Y_T;            
            localparam VCOUNTER1_Y_B = VCOUNTER10_Y_B;            
            // death 10s
            localparam DCOUNTER10_X_L = DIEDTEXT_X_R + 20;       
            localparam DCOUNTER10_X_R = DCOUNTER10_X_L + 7;        
            localparam DCOUNTER10_Y_T = DIEDTEXT_Y_T;       
            localparam DCOUNTER10_Y_B = DIEDTEXT_Y_B;   
            // death 1s
            localparam DCOUNTER1_X_L = DCOUNTER10_X_R + 15;         
            localparam DCOUNTER1_X_R = DCOUNTER1_X_L + 7;         
            localparam DCOUNTER1_Y_T = DCOUNTER10_Y_T;         
            localparam DCOUNTER1_Y_B = DCOUNTER10_Y_B;            
    //spike variables
        // The Spike box
            //Down
            localparam SBOXD_Y_T = S_BOX_B;
            localparam SBOXD_Y_B = SBOXD_Y_T + SPIKE_SIZE;
            localparam SBOXD_X_L = S_BOX_L + 2;
            localparam SBOXD_X_R = SBOXD_X_L + SPIKE_SIZE;
            //Up
            localparam SBOXU_Y_B = S_BOX_T;
            localparam SBOXU_Y_T = SBOXU_Y_B - SPIKE_SIZE;
            localparam SBOXU_X_L = S_BOX_L + 2;
            localparam SBOXU_X_R = SBOXU_X_L + SPIKE_SIZE;  
            //Left
            localparam SBOXL_X_R = S_BOX_L + 3;
            localparam SBOXL_X_L = SBOXL_X_R - SPIKE_SIZE;
            localparam SBOXL_Y_B = S_BOX_B;
            localparam SBOXL_Y_T = SBOXL_Y_B - SPIKE_SIZE;
            //Right 
            localparam SBOXR_X_L = S_BOX_R;
            localparam SBOXR_X_R = SBOXR_X_L + SPIKE_SIZE;
            localparam SBOXR_Y_B = S_BOX_B;
            localparam SBOXR_Y_T = SBOXR_Y_B - SPIKE_SIZE; 
        // Spike 1 (DOWN)       
        localparam SPIKE1D_Y_T = C_PLATL_B;
        localparam SPIKE1D_Y_B = SPIKE1D_Y_T + SPIKE_SIZE;            
        localparam SPIKE1D_X_L = C_PLATL_L + 2;
        localparam SPIKE1D_X_R = SPIKE1D_X_L + SPIKE_SIZE;
        // Spike 2 (UP)
        localparam SPIKE1U_Y_B = WALL_Y_T1;
        localparam SPIKE1U_Y_T = SPIKE1U_Y_B - SPIKE_SIZE;
        localparam SPIKE1U_X_L = SPIKE1D_X_R + (3 * SPIKE_SIZE);
        localparam SPIKE1U_X_R = SPIKE1U_X_L + SPIKE_SIZE;
        // Spike 3 (DOWN)
        localparam SPIKE2D_Y_T = C_PLATL_B;
        localparam SPIKE2D_Y_B = SPIKE2D_Y_T + SPIKE_SIZE;
        localparam SPIKE2D_X_L = SPIKE1U_X_R + (3 * SPIKE_SIZE);
        localparam SPIKE2D_X_R = SPIKE2D_X_L + SPIKE_SIZE;
        
        // Spike 4 (UP)
        localparam SPIKE2U_Y_B = WALL_Y_T1;
        localparam SPIKE2U_Y_T = SPIKE2U_Y_B - SPIKE_SIZE;
        localparam SPIKE2U_X_L = SPIKE2D_X_R + (3 * SPIKE_SIZE);
        localparam SPIKE2U_X_R = SPIKE2U_X_L + SPIKE_SIZE;
        // Spike 5 (DOWN)
        localparam SPIKE3D_Y_T = C_PLATL_B;
        localparam SPIKE3D_Y_B = SPIKE3D_Y_T + SPIKE_SIZE;
        localparam SPIKE3D_X_L = C_PLATR_L + 2;
        localparam SPIKE3D_X_R = SPIKE3D_X_L + SPIKE_SIZE;
        // Spike 6 (UP)
        localparam SPIKE3U_Y_B = WALL_Y_T1;
        localparam SPIKE3U_Y_T = SPIKE3U_Y_B - SPIKE_SIZE;
        localparam SPIKE3U_X_L = SPIKE3D_X_R + (3 * SPIKE_SIZE);
        localparam SPIKE3U_X_R = SPIKE3U_X_L + SPIKE_SIZE;
        // Spike 7 (DOWN)
        localparam SPIKE4D_Y_T = C_PLATR_B;
        localparam SPIKE4D_Y_B = SPIKE4D_Y_T + SPIKE_SIZE;
        localparam SPIKE4D_X_L = SPIKE3U_X_R + (3 * SPIKE_SIZE);
        localparam SPIKE4D_X_R = SPIKE4D_X_L + SPIKE_SIZE;
        // Spike 8 (LEFT)
        localparam SPIKE1L_X_R = WALL_X_L2 + 3;
        localparam SPIKE1L_X_L = SPIKE1L_X_R - SPIKE_SIZE;
        localparam SPIKE1L_Y_B = R_STAIR2_T - 3;
        localparam SPIKE1L_Y_T = SPIKE1L_Y_B - SPIKE_SIZE;
        // Spike 9 (LEFT)
        localparam SPIKE2L_X_R = WALL_X_L2 + 3;
        localparam SPIKE2L_X_L = SPIKE2L_X_R - SPIKE_SIZE;
        localparam SPIKE2L_Y_B = SPIKE1L_Y_T - 3;
        localparam SPIKE2L_Y_T = SPIKE2L_Y_B - SPIKE_SIZE;
        // Spike 10 (LEFT)
        localparam SPIKE3L_X_R = WALL_X_L2 + 3;
        localparam SPIKE3L_X_L = SPIKE3L_X_R - SPIKE_SIZE;
        localparam SPIKE3L_Y_B = SPIKE2L_Y_T - 3;
        localparam SPIKE3L_Y_T = SPIKE3L_Y_B - SPIKE_SIZE;
        // Spike 11 (LEFT)
        localparam SPIKE4L_X_R = WALL_X_L2 + 3;
        localparam SPIKE4L_X_L = SPIKE4L_X_R - SPIKE_SIZE;
        localparam SPIKE4L_Y_B = SPIKE3L_Y_T - 3;
        localparam SPIKE4L_Y_T = SPIKE4L_Y_B - SPIKE_SIZE;
        // Spike 12 (LEFT)
        localparam SPIKE5L_X_R = WALL_X_L2 + 3;
        localparam SPIKE5L_X_L = SPIKE5L_X_R - SPIKE_SIZE;
        localparam SPIKE5L_Y_B = SPIKE4L_Y_T - 3;
        localparam SPIKE5L_Y_T = SPIKE5L_Y_B - SPIKE_SIZE;        
        // Spike 13 (LEFT)
        localparam SPIKE6L_X_R = WALL_X_L2 + 3;
        localparam SPIKE6L_X_L = SPIKE6L_X_R - SPIKE_SIZE;
        localparam SPIKE6L_Y_B = SPIKE5L_Y_T - 3;
        localparam SPIKE6L_Y_T = SPIKE6L_Y_B - SPIKE_SIZE; 
        // Spike 14 (LEFT)
        localparam SPIKE7L_X_R = WALL_X_L2 + 3;
        localparam SPIKE7L_X_L = SPIKE7L_X_R - SPIKE_SIZE;
        localparam SPIKE7L_Y_B = SPIKE6L_Y_T - 3;
        localparam SPIKE7L_Y_T = SPIKE7L_Y_B - SPIKE_SIZE; 
        // Spike 15 (LEFT)
        localparam SPIKE8L_X_R = WALL_X_L2 + 3;
        localparam SPIKE8L_X_L = SPIKE8L_X_R - SPIKE_SIZE;
        localparam SPIKE8L_Y_B = SPIKE7L_Y_T - 3;
        localparam SPIKE8L_Y_T = SPIKE8L_Y_B - SPIKE_SIZE;
        // Spike 16 (DOWN)
        localparam SPIKE5D_Y_T = TR_BOX_B;
        localparam SPIKE5D_Y_B = SPIKE5D_Y_T + SPIKE_SIZE;
        localparam SPIKE5D_X_R = SPIKE8L_X_L - 3;
        localparam SPIKE5D_X_L = SPIKE5D_X_R - SPIKE_SIZE;
        // Spike 17 (DOWN)
        localparam SPIKE6D_Y_T = TR_BOX_B;
        localparam SPIKE6D_Y_B = SPIKE6D_Y_T + SPIKE_SIZE;
        localparam SPIKE6D_X_R = SPIKE5D_X_L;
        localparam SPIKE6D_X_L = SPIKE6D_X_R - SPIKE_SIZE;
        // Spike 18 (DOWN)
        localparam SPIKE7D_Y_T = TR_BOX_B;
        localparam SPIKE7D_Y_B = SPIKE7D_Y_T + SPIKE_SIZE;
        localparam SPIKE7D_X_R = SPIKE6D_X_L;
        localparam SPIKE7D_X_L = SPIKE7D_X_R - SPIKE_SIZE;
        // Spike 19 (DOWN)         
        localparam SPIKE8D_Y_T = TR_BOX_B;
        localparam SPIKE8D_Y_B = SPIKE8D_Y_T + SPIKE_SIZE;
        localparam SPIKE8D_X_R = SPIKE7D_X_L;
        localparam SPIKE8D_X_L = SPIKE8D_X_R - SPIKE_SIZE;
        // Spike 20 (UP)
        localparam SPIKE4U_Y_B = C_PLATS_T;
        localparam SPIKE4U_Y_T = SPIKE4U_Y_B - SPIKE_SIZE;
        localparam SPIKE4U_X_L = T_PLATRS2_L;
        localparam SPIKE4U_X_R = SPIKE4U_X_L + SPIKE_SIZE;
        // Spike 21 (UP)
        localparam SPIKE5U_Y_B = C_PLATL2_T;
        localparam SPIKE5U_Y_T = SPIKE5U_Y_B - SPIKE_SIZE; 
        localparam SPIKE5U_X_R = C_PLATLS_L - 3;
        localparam SPIKE5U_X_L = SPIKE5U_X_R - SPIKE_SIZE;  
        // Spike 22 (DOWN)
        localparam SPIKE9D_Y_T = L_SQ1_B;
        localparam SPIKE9D_Y_B = SPIKE9D_Y_T + SPIKE_SIZE;
        localparam SPIKE9D_X_L = L_SQ1_L + 15;
        localparam SPIKE9D_X_R = SPIKE9D_X_L + SPIKE_SIZE; 
        // Spike 23 (UP)
        localparam SPIKE6U_Y_B = C_PLATL_T;
        localparam SPIKE6U_Y_T = SPIKE6U_Y_B - SPIKE_SIZE;
        localparam SPIKE6U_X_R = C_PLATL2_L - 3;
        localparam SPIKE6U_X_L = SPIKE6U_X_R - SPIKE_SIZE; 
        // Spike 24 (UP)
        localparam SPIKE7U_Y_B = C_PLATL_T;
        localparam SPIKE7U_Y_T = SPIKE7U_Y_B - SPIKE_SIZE;
        localparam SPIKE7U_X_R = SPIKE6U_X_L - 3;
        localparam SPIKE7U_X_L = SPIKE7U_X_R - SPIKE_SIZE; 
        // Spike 25 (DOWN)
        localparam SPIKE10D_Y_T = TL_PLAT_B;
        localparam SPIKE10D_Y_B = SPIKE10D_Y_T + SPIKE_SIZE;
        localparam SPIKE10D_X_L = WALL_X_R1 + 3;
        localparam SPIKE10D_X_R = SPIKE10D_X_L + SPIKE_SIZE; 
        // Spike 26 (DOWN)
        localparam SPIKE11D_Y_T = TL_PLAT_B;
        localparam SPIKE11D_Y_B = SPIKE11D_Y_T + SPIKE_SIZE;
        localparam SPIKE11D_X_L = SPIKE10D_X_R;
        localparam SPIKE11D_X_R = SPIKE11D_X_L + SPIKE_SIZE;
        // Spike 27 (DOWN)
        localparam SPIKE12D_Y_T = TL_PLAT_B;
        localparam SPIKE12D_Y_B = SPIKE12D_Y_T + SPIKE_SIZE;
        localparam SPIKE12D_X_L = SPIKE11D_X_R;
        localparam SPIKE12D_X_R = SPIKE12D_X_L + SPIKE_SIZE;
        // Spike 28 (DOWN)
        localparam SPIKE13D_Y_T = TL_PLAT_B;
        localparam SPIKE13D_Y_B = SPIKE13D_Y_T + SPIKE_SIZE;
        localparam SPIKE13D_X_L = SPIKE12D_X_R;
        localparam SPIKE13D_X_R = SPIKE13D_X_L + SPIKE_SIZE;
        // Spike 29 (DOWN)
        localparam SPIKE14D_Y_T = TL_PLAT_B;
        localparam SPIKE14D_Y_B = SPIKE14D_Y_T + SPIKE_SIZE;
        localparam SPIKE14D_X_L = SPIKE13D_X_R;
        localparam SPIKE14D_X_R = SPIKE14D_X_L + SPIKE_SIZE;
        // Spike 30 (LEFT)
        localparam SPIKE9L_X_R = C_PLATR_L + 3;
        localparam SPIKE9L_X_L = SPIKE9L_X_R - SPIKE_SIZE;
        localparam SPIKE9L_Y_B = C_PLATR_B - 3;
        localparam SPIKE9L_Y_T = SPIKE9L_Y_B - SPIKE_SIZE; 
        // Spike 31 (RIGHT)
        localparam SPIKE1R_X_L = C_PLATL_R;
        localparam SPIKE1R_X_R = SPIKE1R_X_L + SPIKE_SIZE;
        localparam SPIKE1R_Y_B = C_PLATL_B;
        localparam SPIKE1R_Y_T = SPIKE1R_Y_B - SPIKE_SIZE;
        // Spike 32 (RIGHT)
        localparam SPIKE2R_X_L = C_PLATL2_R;
        localparam SPIKE2R_X_R = SPIKE2R_X_L + SPIKE_SIZE;
        localparam SPIKE2R_Y_B = C_PLATL2_B;
        localparam SPIKE2R_Y_T = SPIKE2R_Y_B - SPIKE_SIZE;      
        // Spike 33 (DOWN)
        localparam SPIKE15D_Y_T = T_PLATR_B;
        localparam SPIKE15D_Y_B = SPIKE15D_Y_T + SPIKE_SIZE;
        localparam SPIKE15D_X_R = T_PLATR_R;
        localparam SPIKE15D_X_L = SPIKE15D_X_R - SPIKE_SIZE;
        // Spike 34 (DOWN)
        localparam SPIKE16D_Y_T = T_PLATR_B;
        localparam SPIKE16D_Y_B = SPIKE16D_Y_T + SPIKE_SIZE;
        localparam SPIKE16D_X_R = C_PLATS2_R;
        localparam SPIKE16D_X_L = SPIKE16D_X_R - SPIKE_SIZE;
        // Spike 35 (DOWN)
        localparam SPIKE17D_Y_T = T_PLATR_B;
        localparam SPIKE17D_Y_B = SPIKE17D_Y_T + SPIKE_SIZE;
        localparam SPIKE17D_X_R = C_PLATR_L;
        localparam SPIKE17D_X_L = SPIKE17D_X_R - SPIKE_SIZE;
        // Spike 36 (DOWN)
        localparam SPIKE18D_Y_T = T_PLATL_B;
        localparam SPIKE18D_Y_B = SPIKE18D_Y_T + SPIKE_SIZE;
        localparam SPIKE18D_X_R = C_PLATLS_R;
        localparam SPIKE18D_X_L = SPIKE18D_X_R - SPIKE_SIZE;        
        // Spike 37 (RIGHT)
        localparam SPIKE3R_X_L = WALL_X_R1;
        localparam SPIKE3R_X_R = SPIKE3R_X_L + SPIKE_SIZE;
        localparam SPIKE3R_Y_B = TL_PLAT_T - 10;
        localparam SPIKE3R_Y_T = SPIKE3R_Y_B - SPIKE_SIZE;        
        // Spike 38 (RIGHT)
        localparam SPIKE4R_X_L = WALL_X_R1;
        localparam SPIKE4R_X_R = SPIKE4R_X_L + SPIKE_SIZE;
        localparam SPIKE4R_Y_B = SPIKE3R_Y_T - 3;
        localparam SPIKE4R_Y_T = SPIKE4R_Y_B - SPIKE_SIZE;              
        // Spike 39 (RIGHT)
        localparam SPIKE5R_X_L = WALL_X_R1;
        localparam SPIKE5R_X_R = SPIKE5R_X_L + SPIKE_SIZE;
        localparam SPIKE5R_Y_B = SPIKE4R_Y_T - 3;
        localparam SPIKE5R_Y_T = SPIKE5R_Y_B - SPIKE_SIZE;           
        // Spike 40 (RIGHT)
        localparam SPIKE6R_X_L = WALL_X_R1;
        localparam SPIKE6R_X_R = SPIKE6R_X_L + SPIKE_SIZE;
        localparam SPIKE6R_Y_B = SPIKE5R_Y_T - 3;
        localparam SPIKE6R_Y_T = SPIKE6R_Y_B - SPIKE_SIZE;
        // Spike 41 (RIGHT)
        localparam SPIKE7R_X_L = TL_BOX_R;
        localparam SPIKE7R_X_R = SPIKE7R_X_L + SPIKE_SIZE;
        localparam SPIKE7R_Y_B = TL_BOX_B - 3;
        localparam SPIKE7R_Y_T = SPIKE7R_Y_B - SPIKE_SIZE;        
        // Spike 42 (DOWN)
        localparam SPIKE19D_Y_T = TL_BOX_B;
        localparam SPIKE19D_Y_B = SPIKE19D_Y_T + SPIKE_SIZE;
        localparam SPIKE19D_X_L = T_PLATL_L;
        localparam SPIKE19D_X_R = SPIKE19D_X_L + SPIKE_SIZE;
        // Spike 43 (UP)
        localparam SPIKE8U_Y_B = T_PLATL_T;
        localparam SPIKE8U_Y_T = SPIKE8U_Y_B - SPIKE_SIZE;
        localparam SPIKE8U_X_L = SPIKE19D_X_R + (3 * SPIKE_SIZE);
        localparam SPIKE8U_X_R = SPIKE8U_X_L + SPIKE_SIZE;
        // Spike 44 (DOWN)
        localparam SPIKE20D_Y_T = TL_BOX_B;
        localparam SPIKE20D_Y_B = SPIKE20D_Y_T + SPIKE_SIZE;
        localparam SPIKE20D_X_L = SPIKE8U_X_R + (3 * SPIKE_SIZE);
        localparam SPIKE20D_X_R = SPIKE20D_X_L + SPIKE_SIZE;
        // Spike 45 (DOWN)
        localparam SPIKE21D_Y_T = WALL_Y_B2;
        localparam SPIKE21D_Y_B = SPIKE21D_Y_T + SPIKE_SIZE;
        localparam SPIKE21D_X_L = END_PLAT_L;
        localparam SPIKE21D_X_R = SPIKE21D_X_L + SPIKE_SIZE;
        // Spike 46 (RIGHT)
        localparam SPIKE8R_X_L = T_PLATL_R;
        localparam SPIKE8R_X_R = SPIKE8R_X_L + SPIKE_SIZE;
        localparam SPIKE8R_Y_B = T_PLATL_B - 4;
        localparam SPIKE8R_Y_T = SPIKE8R_Y_B - SPIKE_SIZE;
        // Spike 47 (RIGHT) 
        localparam SPIKE9R_X_L = T_PLATR_R;
        localparam SPIKE9R_X_R = SPIKE9R_X_L + SPIKE_SIZE;
        localparam SPIKE9R_Y_B = T_PLATR_B - 4;
        localparam SPIKE9R_Y_T = SPIKE9R_Y_B - SPIKE_SIZE;
        // Spike 48 (LEFT) 
        localparam SPIKE10L_X_R = TR_BOX_L + 3;
        localparam SPIKE10L_X_L = SPIKE10L_X_R - SPIKE_SIZE; 
        localparam SPIKE10L_Y_B = SPIKE9R_Y_B; 
        localparam SPIKE10L_Y_T = SPIKE10L_Y_B - SPIKE_SIZE;    
        // Spike detail set 
             // Spike box
             wire [4:0] sboxd_rom_bit, sboxu_rom_bit, sboxl_rom_bit, sboxr_rom_bit;
             // Pointing up
             wire [4:0] 
                        spikeu_rom_bit, spike2u_rom_bit, spike3u_rom_bit
                        , spike4u_rom_bit, spike5u_rom_bit, spike6u_rom_bit
                        , spike7u_rom_bit, spike8u_rom_bit, spike9u_rom_bit
                        , spike10u_rom_bit, spike11u_rom_bit, spike12u_rom_bit
                        , spike13u_rom_bit, spike14u_rom_bit, spike15u_rom_bit
                        , spike16u_rom_bit, spike17u_rom_bit, spike18u_rom_bit;

             // Pointing down
             wire [4:0] 
                        spiked_rom_bit, spike2d_rom_bit, spike3d_rom_bit
                        , spike4d_rom_bit, spike5d_rom_bit, spike6d_rom_bit
                        , spike7d_rom_bit, spike8d_rom_bit, spike9d_rom_bit
                        , spike10d_rom_bit, spike11d_rom_bit, spike12d_rom_bit
                        , spike13d_rom_bit, spike14d_rom_bit, spike15d_rom_bit
                        , spike16d_rom_bit, spike17d_rom_bit, spike18d_rom_bit
                        , spike19d_rom_bit, spike20d_rom_bit, spike21d_rom_bit;

             // Pointing left
             wire [4:0] 
                        spikel_rom_bit, spike2l_rom_bit, spike3l_rom_bit
                        , spike4l_rom_bit, spike5l_rom_bit, spike6l_rom_bit
                        , spike7l_rom_bit, spike8l_rom_bit, spike9l_rom_bit
                        , spike10l_rom_bit, spike11l_rom_bit, spike12l_rom_bit
                        , spike13l_rom_bit, spike14l_rom_bit, spike15l_rom_bit
                        , spike16l_rom_bit, spike17l_rom_bit, spike18l_rom_bit;

             // Pointing right
             wire [4:0] 
                        spiker_rom_bit, spike2r_rom_bit, spike3r_rom_bit
                        , spike4r_rom_bit, spike5r_rom_bit, spike6r_rom_bit
                        , spike7r_rom_bit, spike8r_rom_bit, spike9r_rom_bit
                        , spike10r_rom_bit, spike11r_rom_bit, spike12r_rom_bit
                        , spike13r_rom_bit, spike14r_rom_bit, spike15r_rom_bit
                        , spike16r_rom_bit, spike17r_rom_bit, spike18r_rom_bit;

	// character variables 

		// boundaries
			// left, right boundary
			wire [9:0] char_x_l, char_x_r;
			// top, bottom boundary
			wire [9:0] char_y_t, char_y_b;
			// reg to keep track of positions
			reg [9:0] char_x_reg, char_y_reg;
			reg [9:0] char_x_next, char_y_next;
    // Other variables
        // Game over conditions
            reg [7:0] victory = 0;
            reg [7:0] deaths = 0;
        // Game over counters
            wire [7:0] vcounter10s, vcounter1s;
            wire [7:0] dcounter10s, dcounter1s;
        // Game over addresses
            wire [4:0] vcounter10_bit;
            wire [4:0] vcounter1_bit;         
            wire [4:0] dcounter10_bit;
            wire [4:0] dcounter1_bit;    
        // Texts
            wire [8:0] wintext_bit;
            wire [8:0] diedtext_bit; 
	//--------------------------------------------
	// spikes
	//--------------------------------------------
	// Spike box
	spike_rom sbd(
               .pix_x(pix_x), .pix_y(pix_y), 
               .SPIKED_Y_T(SBOXD_Y_T), .SPIKED_X_L(SBOXD_X_L),
               .SPIKEU_Y_T(), .SPIKEU_X_L(), 
               .SPIKEL_Y_T(), .SPIKEL_X_L(),
               .SPIKER_Y_T(), .SPIKER_X_L(),
               .spiker_rom_bit(), .spikel_rom_bit(), .spikeu_rom_bit(), .spiked_rom_bit(sboxd_rom_bit)
               );
               
    spike_rom sbu(
              .pix_x(pix_x), .pix_y(pix_y), 
              .SPIKED_Y_T(), .SPIKED_X_L(),
              .SPIKEU_Y_T(SBOXU_Y_T), .SPIKEU_X_L(SBOXU_X_L), 
              .SPIKEL_Y_T(), .SPIKEL_X_L(),
              .SPIKER_Y_T(), .SPIKER_X_L(),
              .spiker_rom_bit(), .spikel_rom_bit(), .spikeu_rom_bit(sboxu_rom_bit), .spiked_rom_bit()
              );       
    spike_rom sbl(
            .pix_x(pix_x), .pix_y(pix_y), 
            .SPIKED_Y_T(), .SPIKED_X_L(),
            .SPIKEU_Y_T(), .SPIKEU_X_L(), 
            .SPIKEL_Y_T(), .SPIKEL_X_L(),
            .SPIKER_Y_T(SBOXL_Y_T), .SPIKER_X_L(SBOXL_X_L),
            .spiker_rom_bit(sboxl_rom_bit), .spikel_rom_bit(), .spikeu_rom_bit(), .spiked_rom_bit()
            );                      
    spike_rom sbr(
            .pix_x(pix_x), .pix_y(pix_y), 
            .SPIKED_Y_T(), .SPIKED_X_L(),
            .SPIKEU_Y_T(), .SPIKEU_X_L(), 
            .SPIKEL_Y_T(SBOXR_Y_T), .SPIKEL_X_L(SBOXR_X_L),
            .SPIKER_Y_T(), .SPIKER_X_L(),
            .spiker_rom_bit(), .spikel_rom_bit(sboxr_rom_bit), .spikeu_rom_bit(), .spiked_rom_bit()
            );            
            
	// Up Spikes
	
	spike_rom s1u(
	               .pix_x(pix_x), .pix_y(pix_y), 
	               .SPIKED_Y_T(), .SPIKED_X_L(),
	               .SPIKEU_Y_T(SPIKE1U_Y_T), .SPIKEU_X_L(SPIKE1U_X_L), 
	               .SPIKEL_Y_T(), .SPIKEL_X_L(),
	               .SPIKER_Y_T(), .SPIKER_X_L(),
	               .spiker_rom_bit(), .spikel_rom_bit(), .spikeu_rom_bit(spikeu_rom_bit), .spiked_rom_bit()
	               );
    spike_rom s2u(
                  .pix_x(pix_x), .pix_y(pix_y), 
                  .SPIKED_Y_T(), .SPIKED_X_L(),
                  .SPIKEU_Y_T(SPIKE2U_Y_T), .SPIKEU_X_L(SPIKE2U_X_L), 
                  .SPIKEL_Y_T(), .SPIKEL_X_L(),
                  .SPIKER_Y_T(), .SPIKER_X_L(),
                  .spiker_rom_bit(), .spikel_rom_bit(), .spikeu_rom_bit(spike2u_rom_bit), .spiked_rom_bit()
                  );	               
	spike_rom s3u(
                 .pix_x(pix_x), .pix_y(pix_y), 
                 .SPIKED_Y_T(), .SPIKED_X_L(),
                 .SPIKEU_Y_T(SPIKE3U_Y_T), .SPIKEU_X_L(SPIKE3U_X_L), 
                 .SPIKEL_Y_T(), .SPIKEL_X_L(),
                 .SPIKER_Y_T(), .SPIKER_X_L(),
                 .spiker_rom_bit(), .spikel_rom_bit(), .spikeu_rom_bit(spike3u_rom_bit), .spiked_rom_bit()
                 );   
	spike_rom s4u(
                 .pix_x(pix_x), .pix_y(pix_y), 
                 .SPIKED_Y_T(), .SPIKED_X_L(),
                 .SPIKEU_Y_T(SPIKE4U_Y_T), .SPIKEU_X_L(SPIKE4U_X_L), 
                 .SPIKEL_Y_T(), .SPIKEL_X_L(),
                 .SPIKER_Y_T(), .SPIKER_X_L(),
                 .spiker_rom_bit(), .spikel_rom_bit(), .spikeu_rom_bit(spike4u_rom_bit), .spiked_rom_bit()
                 );     
	spike_rom s5u(
                 .pix_x(pix_x), .pix_y(pix_y), 
                 .SPIKED_Y_T(), .SPIKED_X_L(),
                 .SPIKEU_Y_T(SPIKE5U_Y_T), .SPIKEU_X_L(SPIKE5U_X_L), 
                 .SPIKEL_Y_T(), .SPIKEL_X_L(),
                 .SPIKER_Y_T(), .SPIKER_X_L(),
                 .spiker_rom_bit(), .spikel_rom_bit(), .spikeu_rom_bit(spike5u_rom_bit), .spiked_rom_bit()
                 );           
	spike_rom s6u(
                 .pix_x(pix_x), .pix_y(pix_y), 
                 .SPIKED_Y_T(), .SPIKED_X_L(),
                 .SPIKEU_Y_T(SPIKE6U_Y_T), .SPIKEU_X_L(SPIKE6U_X_L), 
                 .SPIKEL_Y_T(), .SPIKEL_X_L(),
                 .SPIKER_Y_T(), .SPIKER_X_L(),
                 .spiker_rom_bit(), .spikel_rom_bit(), .spikeu_rom_bit(spike6u_rom_bit), .spiked_rom_bit()
                 );
	spike_rom s7u(
                 .pix_x(pix_x), .pix_y(pix_y), 
                 .SPIKED_Y_T(), .SPIKED_X_L(),
                 .SPIKEU_Y_T(SPIKE7U_Y_T), .SPIKEU_X_L(SPIKE7U_X_L), 
                 .SPIKEL_Y_T(), .SPIKEL_X_L(),
                 .SPIKER_Y_T(), .SPIKER_X_L(),
                 .spiker_rom_bit(), .spikel_rom_bit(), .spikeu_rom_bit(spike7u_rom_bit), .spiked_rom_bit()
                 );
	spike_rom s8u(
                  .pix_x(pix_x), .pix_y(pix_y), 
                  .SPIKED_Y_T(), .SPIKED_X_L(),
                  .SPIKEU_Y_T(SPIKE8U_Y_T), .SPIKEU_X_L(SPIKE8U_X_L), 
                  .SPIKEL_Y_T(), .SPIKEL_X_L(),
                  .SPIKER_Y_T(), .SPIKER_X_L(),
                  .spiker_rom_bit(), .spikel_rom_bit(), .spikeu_rom_bit(spike8u_rom_bit), .spiked_rom_bit()
                  );                                                                                      
    // Down Spikes
    
	spike_rom s1d(
                   .pix_x(pix_x), .pix_y(pix_y), 
                   .SPIKED_Y_T(SPIKE1D_Y_T), .SPIKED_X_L(SPIKE1D_X_L),
                   .SPIKEU_Y_T(), .SPIKEU_X_L(), 
                   .SPIKEL_Y_T(), .SPIKEL_X_L(),
                   .SPIKER_Y_T(), .SPIKER_X_L(),
                   .spiker_rom_bit(), .spikel_rom_bit(), .spikeu_rom_bit(), .spiked_rom_bit(spiked_rom_bit)
                   );    
                   
	spike_rom s2d(
                  .pix_x(pix_x), .pix_y(pix_y), 
                  .SPIKED_Y_T(SPIKE2D_Y_T), .SPIKED_X_L(SPIKE2D_X_L),
                  .SPIKEU_Y_T(), .SPIKEU_X_L(), 
                  .SPIKEL_Y_T(), .SPIKEL_X_L(),
                  .SPIKER_Y_T(), .SPIKER_X_L(),
                  .spiker_rom_bit(), .spikel_rom_bit(), .spikeu_rom_bit(), .spiked_rom_bit(spike2d_rom_bit)
                  );             
	spike_rom s3d(
                  .pix_x(pix_x), .pix_y(pix_y), 
                  .SPIKED_Y_T(SPIKE3D_Y_T), .SPIKED_X_L(SPIKE3D_X_L),
                  .SPIKEU_Y_T(), .SPIKEU_X_L(), 
                  .SPIKEL_Y_T(), .SPIKEL_X_L(),
                  .SPIKER_Y_T(), .SPIKER_X_L(),
                  .spiker_rom_bit(), .spikel_rom_bit(), .spikeu_rom_bit(), .spiked_rom_bit(spike3d_rom_bit)
                  );
	spike_rom s4d(
                  .pix_x(pix_x), .pix_y(pix_y), 
                  .SPIKED_Y_T(SPIKE4D_Y_T), .SPIKED_X_L(SPIKE4D_X_L),
                  .SPIKEU_Y_T(), .SPIKEU_X_L(), 
                  .SPIKEL_Y_T(), .SPIKEL_X_L(),
                  .SPIKER_Y_T(), .SPIKER_X_L(),
                  .spiker_rom_bit(), .spikel_rom_bit(), .spikeu_rom_bit(), .spiked_rom_bit(spike4d_rom_bit)
                  );    
    spike_rom s5d(
                  .pix_x(pix_x), .pix_y(pix_y), 
                  .SPIKED_Y_T(SPIKE5D_Y_T), .SPIKED_X_L(SPIKE5D_X_L),
                  .SPIKEU_Y_T(), .SPIKEU_X_L(), 
                  .SPIKEL_Y_T(), .SPIKEL_X_L(),
                  .SPIKER_Y_T(), .SPIKER_X_L(),
                  .spiker_rom_bit(), .spikel_rom_bit(), .spikeu_rom_bit(), .spiked_rom_bit(spike5d_rom_bit)
                  );
	spike_rom s6d(
                  .pix_x(pix_x), .pix_y(pix_y), 
                  .SPIKED_Y_T(SPIKE6D_Y_T), .SPIKED_X_L(SPIKE6D_X_L),
                  .SPIKEU_Y_T(), .SPIKEU_X_L(), 
                  .SPIKEL_Y_T(), .SPIKEL_X_L(),
                  .SPIKER_Y_T(), .SPIKER_X_L(),
                  .spiker_rom_bit(), .spikel_rom_bit(), .spikeu_rom_bit(), .spiked_rom_bit(spike6d_rom_bit)
                  ); 
	spike_rom s7d(
                  .pix_x(pix_x), .pix_y(pix_y), 
                  .SPIKED_Y_T(SPIKE7D_Y_T), .SPIKED_X_L(SPIKE7D_X_L),
                  .SPIKEU_Y_T(), .SPIKEU_X_L(), 
                  .SPIKEL_Y_T(), .SPIKEL_X_L(),
                  .SPIKER_Y_T(), .SPIKER_X_L(),
                  .spiker_rom_bit(), .spikel_rom_bit(), .spikeu_rom_bit(), .spiked_rom_bit(spike7d_rom_bit)
                  );                                                                    
	spike_rom s8d(
                  .pix_x(pix_x), .pix_y(pix_y), 
                  .SPIKED_Y_T(SPIKE8D_Y_T), .SPIKED_X_L(SPIKE8D_X_L),
                  .SPIKEU_Y_T(), .SPIKEU_X_L(), 
                  .SPIKEL_Y_T(), .SPIKEL_X_L(),
                  .SPIKER_Y_T(), .SPIKER_X_L(),
                  .spiker_rom_bit(), .spikel_rom_bit(), .spikeu_rom_bit(), .spiked_rom_bit(spike8d_rom_bit)
                  );       
	spike_rom s9d(
                  .pix_x(pix_x), .pix_y(pix_y), 
                  .SPIKED_Y_T(SPIKE9D_Y_T), .SPIKED_X_L(SPIKE9D_X_L),
                  .SPIKEU_Y_T(), .SPIKEU_X_L(), 
                  .SPIKEL_Y_T(), .SPIKEL_X_L(),
                  .SPIKER_Y_T(), .SPIKER_X_L(),
                  .spiker_rom_bit(), .spikel_rom_bit(), .spikeu_rom_bit(), .spiked_rom_bit(spike9d_rom_bit)
                  );           
    spike_rom s10d(
                 .pix_x(pix_x), .pix_y(pix_y), 
                 .SPIKED_Y_T(SPIKE10D_Y_T), .SPIKED_X_L(SPIKE10D_X_L),
                 .SPIKEU_Y_T(), .SPIKEU_X_L(), 
                 .SPIKEL_Y_T(), .SPIKEL_X_L(),
                 .SPIKER_Y_T(), .SPIKER_X_L(),
                 .spiker_rom_bit(), .spikel_rom_bit(), .spikeu_rom_bit(), .spiked_rom_bit(spike10d_rom_bit)
                 );    
    spike_rom s11d(
                 .pix_x(pix_x), .pix_y(pix_y), 
                 .SPIKED_Y_T(SPIKE11D_Y_T), .SPIKED_X_L(SPIKE11D_X_L),
                 .SPIKEU_Y_T(), .SPIKEU_X_L(), 
                 .SPIKEL_Y_T(), .SPIKEL_X_L(),
                 .SPIKER_Y_T(), .SPIKER_X_L(),
                 .spiker_rom_bit(), .spikel_rom_bit(), .spikeu_rom_bit(), .spiked_rom_bit(spike11d_rom_bit)
                 );   
                 
    spike_rom s12d(
                  .pix_x(pix_x), .pix_y(pix_y), 
                  .SPIKED_Y_T(SPIKE12D_Y_T), .SPIKED_X_L(SPIKE12D_X_L),
                  .SPIKEU_Y_T(), .SPIKEU_X_L(), 
                  .SPIKEL_Y_T(), .SPIKEL_X_L(),
                  .SPIKER_Y_T(), .SPIKER_X_L(),
                  .spiker_rom_bit(), .spikel_rom_bit(), .spikeu_rom_bit(), .spiked_rom_bit(spike12d_rom_bit)
                  );                                                                                                               
                  
    spike_rom s13d(
               .pix_x(pix_x), .pix_y(pix_y), 
               .SPIKED_Y_T(SPIKE13D_Y_T), .SPIKED_X_L(SPIKE13D_X_L),
               .SPIKEU_Y_T(), .SPIKEU_X_L(), 
               .SPIKEL_Y_T(), .SPIKEL_X_L(),
               .SPIKER_Y_T(), .SPIKER_X_L(),
               .spiker_rom_bit(), .spikel_rom_bit(), .spikeu_rom_bit(), .spiked_rom_bit(spike13d_rom_bit)
               );                    
    spike_rom s14d(
              .pix_x(pix_x), .pix_y(pix_y), 
              .SPIKED_Y_T(SPIKE14D_Y_T), .SPIKED_X_L(SPIKE14D_X_L),
              .SPIKEU_Y_T(), .SPIKEU_X_L(), 
              .SPIKEL_Y_T(), .SPIKEL_X_L(),
              .SPIKER_Y_T(), .SPIKER_X_L(),
              .spiker_rom_bit(), .spikel_rom_bit(), .spikeu_rom_bit(), .spiked_rom_bit(spike14d_rom_bit)
              );                      
    spike_rom s15d(
            .pix_x(pix_x), .pix_y(pix_y), 
            .SPIKED_Y_T(SPIKE15D_Y_T), .SPIKED_X_L(SPIKE15D_X_L),
            .SPIKEU_Y_T(), .SPIKEU_X_L(), 
            .SPIKEL_Y_T(), .SPIKEL_X_L(),
            .SPIKER_Y_T(), .SPIKER_X_L(),
            .spiker_rom_bit(), .spikel_rom_bit(), .spikeu_rom_bit(), .spiked_rom_bit(spike15d_rom_bit)
            );
    spike_rom s16d(
          .pix_x(pix_x), .pix_y(pix_y), 
          .SPIKED_Y_T(SPIKE16D_Y_T), .SPIKED_X_L(SPIKE16D_X_L),
          .SPIKEU_Y_T(), .SPIKEU_X_L(), 
          .SPIKEL_Y_T(), .SPIKEL_X_L(),
          .SPIKER_Y_T(), .SPIKER_X_L(),
          .spiker_rom_bit(), .spikel_rom_bit(), .spikeu_rom_bit(), .spiked_rom_bit(spike16d_rom_bit)
          );
    spike_rom s17d(
            .pix_x(pix_x), .pix_y(pix_y), 
            .SPIKED_Y_T(SPIKE17D_Y_T), .SPIKED_X_L(SPIKE17D_X_L),
            .SPIKEU_Y_T(), .SPIKEU_X_L(), 
            .SPIKEL_Y_T(), .SPIKEL_X_L(),
            .SPIKER_Y_T(), .SPIKER_X_L(),
            .spiker_rom_bit(), .spikel_rom_bit(), .spikeu_rom_bit(), .spiked_rom_bit(spike17d_rom_bit)
            );
    spike_rom s18d(
          .pix_x(pix_x), .pix_y(pix_y), 
          .SPIKED_Y_T(SPIKE18D_Y_T), .SPIKED_X_L(SPIKE18D_X_L),
          .SPIKEU_Y_T(), .SPIKEU_X_L(), 
          .SPIKEL_Y_T(), .SPIKEL_X_L(),
          .SPIKER_Y_T(), .SPIKER_X_L(),
          .spiker_rom_bit(), .spikel_rom_bit(), .spikeu_rom_bit(), .spiked_rom_bit(spike18d_rom_bit)
          );      
    spike_rom s19d(
            .pix_x(pix_x), .pix_y(pix_y), 
            .SPIKED_Y_T(SPIKE19D_Y_T), .SPIKED_X_L(SPIKE19D_X_L),
            .SPIKEU_Y_T(), .SPIKEU_X_L(), 
            .SPIKEL_Y_T(), .SPIKEL_X_L(),
            .SPIKER_Y_T(), .SPIKER_X_L(),
            .spiker_rom_bit(), .spikel_rom_bit(), .spikeu_rom_bit(), .spiked_rom_bit(spike19d_rom_bit)
            );                                                                            
    spike_rom s20d(
              .pix_x(pix_x), .pix_y(pix_y), 
              .SPIKED_Y_T(SPIKE20D_Y_T), .SPIKED_X_L(SPIKE20D_X_L),
              .SPIKEU_Y_T(), .SPIKEU_X_L(), 
              .SPIKEL_Y_T(), .SPIKEL_X_L(),
              .SPIKER_Y_T(), .SPIKER_X_L(),
              .spiker_rom_bit(), .spikel_rom_bit(), .spikeu_rom_bit(), .spiked_rom_bit(spike20d_rom_bit)
              );   
    spike_rom s21d(
            .pix_x(pix_x), .pix_y(pix_y), 
            .SPIKED_Y_T(SPIKE21D_Y_T), .SPIKED_X_L(SPIKE21D_X_L),
            .SPIKEU_Y_T(), .SPIKEU_X_L(), 
            .SPIKEL_Y_T(), .SPIKEL_X_L(),
            .SPIKER_Y_T(), .SPIKER_X_L(),
            .spiker_rom_bit(), .spikel_rom_bit(), .spikeu_rom_bit(), .spiked_rom_bit(spike21d_rom_bit)
            );               
                          
    // Left Spikes
    
	spike_rom s1l(
                   .pix_x(pix_x), .pix_y(pix_y), 
                   .SPIKED_Y_T(), .SPIKED_X_L(),
                   .SPIKEU_Y_T(), .SPIKEU_X_L(), 
                   .SPIKEL_Y_T(), .SPIKEL_X_L(),
                   .SPIKER_Y_T(SPIKE1L_Y_T), .SPIKER_X_L(SPIKE1L_X_L),
                   .spiker_rom_bit(spikel_rom_bit), .spikel_rom_bit(), .spikeu_rom_bit(), .spiked_rom_bit()
                   );     
                   
	spike_rom s2l(
                  .pix_x(pix_x), .pix_y(pix_y), 
                  .SPIKED_Y_T(), .SPIKED_X_L(),
                  .SPIKEU_Y_T(), .SPIKEU_X_L(), 
                  .SPIKEL_Y_T(), .SPIKEL_X_L(),
                  .SPIKER_Y_T(SPIKE2L_Y_T), .SPIKER_X_L(SPIKE2L_X_L),
                  .spiker_rom_bit(spike2l_rom_bit), .spikel_rom_bit(), .spikeu_rom_bit(), .spiked_rom_bit()
                  ); 
                  
	spike_rom s3l(
                 .pix_x(pix_x), .pix_y(pix_y), 
                 .SPIKED_Y_T(), .SPIKED_X_L(),
                 .SPIKEU_Y_T(), .SPIKEU_X_L(), 
                 .SPIKEL_Y_T(), .SPIKEL_X_L(),
                 .SPIKER_Y_T(SPIKE3L_Y_T), .SPIKER_X_L(SPIKE3L_X_L),
                 .spiker_rom_bit(spike3l_rom_bit), .spikel_rom_bit(), .spikeu_rom_bit(), .spiked_rom_bit()
                 ); 
                 
    spike_rom s4l(
                .pix_x(pix_x), .pix_y(pix_y), 
                .SPIKED_Y_T(), .SPIKED_X_L(),
                .SPIKEU_Y_T(), .SPIKEU_X_L(), 
                .SPIKEL_Y_T(), .SPIKEL_X_L(),
                .SPIKER_Y_T(SPIKE4L_Y_T), .SPIKER_X_L(SPIKE4L_X_L),
                .spiker_rom_bit(spike4l_rom_bit), .spikel_rom_bit(), .spikeu_rom_bit(), .spiked_rom_bit()
                ); 
                
    spike_rom s5l(
               .pix_x(pix_x), .pix_y(pix_y), 
               .SPIKED_Y_T(), .SPIKED_X_L(),
               .SPIKEU_Y_T(), .SPIKEU_X_L(), 
               .SPIKEL_Y_T(), .SPIKEL_X_L(),
               .SPIKER_Y_T(SPIKE5L_Y_T), .SPIKER_X_L(SPIKE5L_X_L),
               .spiker_rom_bit(spike5l_rom_bit), .spikel_rom_bit(), .spikeu_rom_bit(), .spiked_rom_bit()
               );    
    spike_rom s6l(
               .pix_x(pix_x), .pix_y(pix_y), 
               .SPIKED_Y_T(), .SPIKED_X_L(),
               .SPIKEU_Y_T(), .SPIKEU_X_L(), 
               .SPIKEL_Y_T(), .SPIKEL_X_L(),
               .SPIKER_Y_T(SPIKE6L_Y_T), .SPIKER_X_L(SPIKE6L_X_L),
               .spiker_rom_bit(spike6l_rom_bit), .spikel_rom_bit(), .spikeu_rom_bit(), .spiked_rom_bit()
               ); 
    spike_rom s7l(
               .pix_x(pix_x), .pix_y(pix_y), 
               .SPIKED_Y_T(), .SPIKED_X_L(),
               .SPIKEU_Y_T(), .SPIKEU_X_L(), 
               .SPIKEL_Y_T(), .SPIKEL_X_L(),  
               .SPIKER_Y_T(SPIKE7L_Y_T), .SPIKER_X_L(SPIKE7L_X_L),
               .spiker_rom_bit(spike7l_rom_bit), .spikel_rom_bit(), .spikeu_rom_bit(), .spiked_rom_bit()
               ); 
    spike_rom s8l(
               .pix_x(pix_x), .pix_y(pix_y), 
               .SPIKED_Y_T(), .SPIKED_X_L(),
               .SPIKEU_Y_T(), .SPIKEU_X_L(), 
               .SPIKEL_Y_T(), .SPIKEL_X_L(),
               .SPIKER_Y_T(SPIKE8L_Y_T), .SPIKER_X_L(SPIKE8L_X_L),
               .spiker_rom_bit(spike8l_rom_bit), .spikel_rom_bit(), .spikeu_rom_bit(), .spiked_rom_bit()
               );             
    spike_rom s9l(
              .pix_x(pix_x), .pix_y(pix_y), 
              .SPIKED_Y_T(), .SPIKED_X_L(),
              .SPIKEU_Y_T(), .SPIKEU_X_L(), 
              .SPIKEL_Y_T(), .SPIKEL_X_L(),
              .SPIKER_Y_T(SPIKE9L_Y_T), .SPIKER_X_L(SPIKE9L_X_L),
              .spiker_rom_bit(spike9l_rom_bit), .spikel_rom_bit(), .spikeu_rom_bit(), .spiked_rom_bit()
              );    
    spike_rom s10l(
            .pix_x(pix_x), .pix_y(pix_y), 
            .SPIKED_Y_T(), .SPIKED_X_L(),
            .SPIKEU_Y_T(), .SPIKEU_X_L(), 
            .SPIKEL_Y_T(), .SPIKEL_X_L(),
            .SPIKER_Y_T(SPIKE10L_Y_T), .SPIKER_X_L(SPIKE10L_X_L),
            .spiker_rom_bit(spike10l_rom_bit), .spikel_rom_bit(), .spikeu_rom_bit(), .spiked_rom_bit()
            );                                                  
    // Right Spikes  
    spike_rom s1r(
              .pix_x(pix_x), .pix_y(pix_y), 
              .SPIKED_Y_T(), .SPIKED_X_L(),
              .SPIKEU_Y_T(), .SPIKEU_X_L(), 
              .SPIKEL_Y_T(SPIKE1R_Y_T), .SPIKEL_X_L(SPIKE1R_X_L),
              .SPIKER_Y_T(), .SPIKER_X_L(),
              .spiker_rom_bit(), .spikel_rom_bit(spike1r_rom_bit), .spikeu_rom_bit(), .spiked_rom_bit()
              );
    spike_rom s2r(
            .pix_x(pix_x), .pix_y(pix_y), 
            .SPIKED_Y_T(), .SPIKED_X_L(),
            .SPIKEU_Y_T(), .SPIKEU_X_L(), 
            .SPIKEL_Y_T(SPIKE2R_Y_T), .SPIKEL_X_L(SPIKE2R_X_L),
            .SPIKER_Y_T(), .SPIKER_X_L(),
            .spiker_rom_bit(), .spikel_rom_bit(spike2r_rom_bit), .spikeu_rom_bit(), .spiked_rom_bit()
            ); 
    spike_rom s3r(
            .pix_x(pix_x), .pix_y(pix_y), 
            .SPIKED_Y_T(), .SPIKED_X_L(),
            .SPIKEU_Y_T(), .SPIKEU_X_L(), 
            .SPIKEL_Y_T(SPIKE3R_Y_T), .SPIKEL_X_L(SPIKE3R_X_L),
            .SPIKER_Y_T(), .SPIKER_X_L(),
            .spiker_rom_bit(), .spikel_rom_bit(spike3r_rom_bit), .spikeu_rom_bit(), .spiked_rom_bit()
            );  
    spike_rom s4r(
            .pix_x(pix_x), .pix_y(pix_y), 
            .SPIKED_Y_T(), .SPIKED_X_L(),
            .SPIKEU_Y_T(), .SPIKEU_X_L(), 
            .SPIKEL_Y_T(SPIKE4R_Y_T), .SPIKEL_X_L(SPIKE4R_X_L),
            .SPIKER_Y_T(), .SPIKER_X_L(),
            .spiker_rom_bit(), .spikel_rom_bit(spike4r_rom_bit), .spikeu_rom_bit(), .spiked_rom_bit()
            );  
    spike_rom s5r(
            .pix_x(pix_x), .pix_y(pix_y), 
            .SPIKED_Y_T(), .SPIKED_X_L(),
            .SPIKEU_Y_T(), .SPIKEU_X_L(), 
            .SPIKEL_Y_T(SPIKE5R_Y_T), .SPIKEL_X_L(SPIKE5R_X_L),
            .SPIKER_Y_T(), .SPIKER_X_L(),
            .spiker_rom_bit(), .spikel_rom_bit(spike5r_rom_bit), .spikeu_rom_bit(), .spiked_rom_bit()
            );  
    spike_rom s6r(
            .pix_x(pix_x), .pix_y(pix_y), 
            .SPIKED_Y_T(), .SPIKED_X_L(),
            .SPIKEU_Y_T(), .SPIKEU_X_L(), 
            .SPIKEL_Y_T(SPIKE6R_Y_T), .SPIKEL_X_L(SPIKE6R_X_L),
            .SPIKER_Y_T(), .SPIKER_X_L(),
            .spiker_rom_bit(), .spikel_rom_bit(spike6r_rom_bit), .spikeu_rom_bit(), .spiked_rom_bit()
            );     
    spike_rom s7r(
            .pix_x(pix_x), .pix_y(pix_y), 
            .SPIKED_Y_T(), .SPIKED_X_L(),
            .SPIKEU_Y_T(), .SPIKEU_X_L(), 
            .SPIKEL_Y_T(SPIKE7R_Y_T), .SPIKEL_X_L(SPIKE7R_X_L),
            .SPIKER_Y_T(), .SPIKER_X_L(),
            .spiker_rom_bit(), .spikel_rom_bit(spike7r_rom_bit), .spikeu_rom_bit(), .spiked_rom_bit()
            );      
    spike_rom s8r(
            .pix_x(pix_x), .pix_y(pix_y), 
            .SPIKED_Y_T(), .SPIKED_X_L(),
            .SPIKEU_Y_T(), .SPIKEU_X_L(), 
            .SPIKEL_Y_T(SPIKE8R_Y_T), .SPIKEL_X_L(SPIKE8R_X_L),
            .SPIKER_Y_T(), .SPIKER_X_L(),
            .spiker_rom_bit(), .spikel_rom_bit(spike8r_rom_bit), .spikeu_rom_bit(), .spiked_rom_bit()
            );  
    spike_rom s9r(
            .pix_x(pix_x), .pix_y(pix_y), 
            .SPIKED_Y_T(), .SPIKED_X_L(),
            .SPIKEU_Y_T(), .SPIKEU_X_L(), 
            .SPIKEL_Y_T(SPIKE9R_Y_T), .SPIKEL_X_L(SPIKE9R_X_L),
            .SPIKER_Y_T(), .SPIKER_X_L(),
            .spiker_rom_bit(), .spikel_rom_bit(spike9r_rom_bit), .spikeu_rom_bit(), .spiked_rom_bit()
            );                                                                                           
	//--------------------------------------------
	// character 
	//--------------------------------------------
	// registers
	always @ (posedge clk, posedge reset)
		if (reset)
			begin
				char_x_reg <= WALL_X_R1 + 1;
				char_y_reg <= START_PLAT_T - CHAR_SIZE;		
				deaths <= 0;
				victory <= 0;						
			end
		else
			begin
				char_x_reg <= char_x_next;
				char_y_reg <= char_y_next;
			end
	// refr_tick: 1-clock tick asserted at start of v-sync
	//            i.e., when the screen is refreshed (60 Hz)
	assign refr_tick = (pix_y==481) && (pix_x==0);
	// boundary
	assign char_y_t = char_y_reg;
	assign char_x_l = char_x_reg;
	assign char_x_r = char_x_l + CHAR_SIZE - 1;
	assign char_y_b = char_y_t + CHAR_SIZE - 1;
	// Movement
        // Update character position
        always @ *
            begin
                char_x_next = char_x_reg;	// No movement
                char_y_next = char_y_reg;   // No movement
                if (refr_tick) begin
                    // Vertical Movement
                    //--------------------------------------------
                    //                  Jump
                    //--------------------------------------------
                    if ( (btn == 4'b0100) &&         //Begin conditions for Jumping
                        /* At start platform */                 (((char_y_t >= TL_PLAT_B) &&     // Not touching bottom of top left platform
                                                                (((char_x_l >= START_PLAT_L) && (char_x_r <= START_PLAT_R)))        // Between Start platform
                                                            ) ||
                        /* Between start plat and center plat left */ ((char_y_t >= TL_PLAT_B) &&   // Not touching bottom of top left platform
                                                                      (((char_x_l >= START_PLAT_R) && (char_x_r <= C_PLATL_L)))     // Between start and center plat left
                                                            ) ||
                        /* Under center plat left */                  ((char_y_t >= C_PLATL_B) &&   // Not touching bottom of center plat left
                                                                      (((char_x_l >= C_PLATL_L) && (char_x_r <= C_PLATL_R)))        // Between center plat left
                                                            ) ||
                        /* Between center plat left and top bound */      ((char_y_t >= WALL_Y_B2) &&   // Not touching bottom of top plat right
                                                                      (((char_x_l >= C_PLATL_R) && (char_x_r <= T_PLATR_L)))        // Between center plat left and right
                                                            ) ||
                        /* Under top plat right */                             ((char_y_t >= T_PLATR_B) &&
                                                                      (((char_x_l >= T_PLATR_L) && (char_x_r <= C_PLATR_L)))
                                                            ) ||
                        /* Under center plat right */                 ((char_y_t >= C_PLATR_B) &&   // Not touching bottom of center plat right
                                                                      (((char_x_l >= C_PLATR_L) && (char_x_r <= C_PLATR_R)))        // Between center plat right
                                                            ) ||
                        /* Between center plat right and stair 1 */     ((char_y_t >= WALL_Y_B2) &&     // Not touching bottom of top boundary
                                                                      (((char_x_l >= C_PLATR_R) && (char_x_r <= R_STAIR_L)))        // Between plat right and stair step 1
                                                            ) ||
                        /* Between stair 1 and top right box */         ((char_y_t >= TR_BOX_B) &&      // Not touching bottom of top right box
                                                                      (((char_x_l >= R_STAIR_L) && (char_x_r <= R_STAIR2_L)))       // Between stair 1 and 2
                                                            ) ||
                        /* Between stair 2 and right bound */           ((char_y_t >= TR_BOX_B) &&      // Not touching bottom of top right box
                                                                      (((char_x_l >= R_STAIR2_L) && (char_x_r <= WALL_X_L2)))       // Between stair 2 and bound
                                                            ) ||
                        /* Between center platform */                   ((char_y_t >= T_PLATR_B) &&     // Not touching bottom of top plat right
                                                                      (((char_y_b <= C_PLATR_T + 1) && (char_x_l >= C_PLATR_L) && (char_x_r <= C_PLATR_R)))        // Between platform and not under center platform
                                                            ) ||
                        /* Between left platform's right and step 1 */  ((char_y_t >= T_PLATL_B) &&         // Not touching bottom of top plat left
                                                                      (((char_y_b <= C_PLATL2_T + 1) && (char_x_l >= L_SQ1_R) && (char_x_r <= C_PLATL2_R)))
                                                            ) ||
                        /* Between left platform's left and step 2 */   ((char_y_t >= L_SQ2_B) &&           // Not touching bottom of left square 2
                                                                      (((char_y_b <= C_PLATL_T + 1) && (char_x_l >= C_PLATL_L) && (char_x_r <= L_SQ2_R)))
                                                            ) ||
                        /* Between stair 1 */                           ((char_y_t >= T_PLATL_B) &&         // Not touching bottom of top plat left             
                                                                      (((char_y_b <= L_SQ1_T + 1) && (char_x_l >= L_SQ1_L) && (char_x_r <= L_SQ1_R)))   
                                                            ) ||
                        /* Between stair 2 and top plat left */          ((char_y_t >= T_PLATL_B) &&
                                                                      (((char_y_b <= L_SQ2_T + 1) && (char_x_l >= T_PLATL_L) && (char_x_r <= L_SQ2_R)))
                                                            ) ||
                        /* Between stair 2 and top left box */           ((char_y_t >= TL_BOX_B) &&
                                                                      (((char_y_b <= L_SQ2_T + 1) && (char_x_l >= L_SQ2_L) && (char_x_r <= T_PLATL_L)))
                                                            ) ||
                        /* Between top left plat and top left box */     ((char_y_t >= TL_BOX_B) &&
                                                                      (((char_y_b <= TL_PLAT_T + 1) && (char_x_l >= WALL_X_R1) && (char_x_r <= TL_PLAT_R)))
                                                            ) ||
                        /* Between top left box and top plat left */     ((char_y_t >= TL_BOX_B) &&
                                                                      (((char_y_b <= T_PLATL_T + 1) && (char_x_l >= T_PLATL_L) && (char_x_r <= T_PLATL_R)))
                                                            ) || 
                        /* Between top plat right and top bound */       ((char_y_t >= WALL_Y_B2) &&
                                                                      (((char_y_b <= T_PLATR_T + 1) && (char_x_l >= T_PLATR_L) && (char_x_r <= T_PLATR_R)))
                                                            ) ||
                        /* Between Top right box and top bound */        ((char_y_t >= WALL_Y_B2) &&
                                                                      (((char_y_b <= TR_BOX_T + 1) && (char_x_l >= TR_BOX_L) && (char_x_r <= END_PLAT_L)))
                                                            ) ||                                                           
                        /* Between top right box and end platform */     ((char_y_t >= END_PLAT_B) &&
                                                                      (((char_y_b <= TR_BOX_T + 1) && (char_x_l >= END_PLAT_L) && (char_x_r <= WALL_X_L2)))
                                                            ) ||
                        /* Between end platform */                       ((char_y_t >= WALL_Y_B2) &&
                                                                      (((char_y_b <= END_PLAT_T + 1) && (char_x_l >= END_PLAT_L) && (char_x_r <= END_PLAT_R)))
                                                            )
                    )) 
                    begin            // Jump
                        
                        char_y_next = char_y_reg - 2;           
                    end
                    //--------------------------------------------
                    //                  Fall
                    //--------------------------------------------
                    else if(   (btn == 4'b1000) &&      //Begin conditions for falling
                        /* Begin bottom falling conditions */   (((char_y_b <= WALL_Y_T1 - 1) &&        // Not touching bottom platform 
                                                                (((char_y_b >= TL_PLAT_B - 5) && (char_x_l >= START_PLAT_R - 1) && (char_x_r <= C_PLATL_L - 1)) ||       // Fall region: between start platform & center platform l & under top left plat
                                                                ((char_y_b >= C_PLATL_B - 5) && (char_x_l >= C_PLATL_L - 1) && (char_x_r < C_PLATL_R - 1)) ||     // Fall region: under center platform l
                                                                ((char_x_l >= C_PLATL_R - 1) && (char_x_r <= T_PLATR_L - 1)) ||           // Fall region: Between center platform l and top platfrom r 
                                                                ((char_y_b >= T_PLATR_B - 5) && (char_x_l >= T_PLATR_L - 1) && (char_x_r <= C_PLATR_L - 1)) ||               // Fall region: Under top platform r and Between top platform r and center platform r
                                                                ((char_y_b >= C_PLATR_B - 5) && (char_x_l >= C_PLATR_L - 1) && (char_x_r < C_PLATR_R - 1)) ||     // Fall region: under center platfrom r 
                                                                ((char_x_l >= C_PLATR_R - 1) && (char_x_r <= R_STAIR_L - 1)))                                       // Fall region: Between center platform r and right stair 1st step
                                                            ) ||                                    //End bot fall conditions
                        // ***************************************************************************************************************************************************************************************************************************************                                                                        
                        /* not touching start platform */ ((char_y_b <= START_PLAT_T - 1) && (char_y_b >= TL_PLAT_B - 5) && (char_x_r <= START_PLAT_R - 1)) ||     // Fall region: under top left platform
                        // ***************************************************************************************************************************************************************************************************************************************
                        /* not touching first step */ ((char_y_b >= TL_BOX_B - 5) && (char_y_b <= R_STAIR_T - 1) && (char_x_l >= R_STAIR_L - 1) && (char_x_r <= R_STAIR_R - 1)) ||
                        // ***************************************************************************************************************************************************************************************************************************************
                        /* not touching second step */ ((char_y_b >= TL_BOX_B - 5) && (char_y_b <= R_STAIR2_T - 1) && (char_x_l >= R_STAIR2_L - 1) && (char_x_r <= R_STAIR2_R - 1)) ||
                        // ***************************************************************************************************************************************************************************************************************************************
                        /* not touching right center platform */ ((char_y_b <= C_PLATR_T - 1) &&        // Not touching center platform 
                                                                    ((char_y_b >= T_PLATR_B - 5) && ((char_x_l >= C_PLATR_L - 1) && (char_x_r <= C_PLATS_L)) ||    // Not at second stair and under top platform right
                                                                    ((char_y_b >= T_PLATR_B - 5) && (char_x_r <= C_PLATR_R - 1) && (char_x_l >= C_PLATS2_R)))      // Not at first stair and under top platform right
                                                            ) ||                                    //End center plat 1 fall condition
                        // ***************************************************************************************************************************************************************************************************************************************
                        /* not touching first step */ ((char_y_b <= C_PLATS2_T - 1) && (char_y_b >= T_PLATR_B - 5) && (char_x_l >= C_PLATS2_L - 1) && (char_x_r <= C_PLATS2_R - 1)) ||             // Between stair and under top platform right
                        // ***************************************************************************************************************************************************************************************************************************************
                        /* not touching second step */ ((char_y_b <= C_PLATS_T - 1) && (char_y_b >= T_PLATR_B - 5) && (char_x_l >= C_PLATS_L - 1) && (char_x_r <= C_PLATS_R - 1)) ||               // Between stair and under top platform right
                        // ***************************************************************************************************************************************************************************************************************************************
                        /* not touching left center platform */ ((char_y_b <= C_PLATL_T - 1) && 
                                                                    ((char_y_b >= L_SQ2_B - 5) && (char_x_l >= C_PLATL_L - 1) && (char_x_r <= C_PLATL2_L - 1))        // Not at 2nd level
                                                            ) ||                // End left center platform conditions
                        // ***************************************************************************************************************************************************************************************************************************************
                        /* not touching left center level 2 */ ((char_y_b <= C_PLATL2_T - 1) &&                                     // Not at 2nd level
                                                                    (((char_y_b >= T_PLATL_B - 5) && (char_x_l >= C_PLATLS_R - 1) && (char_x_r <= C_PLATL2_R - 1)) ||      // Between step and right edge and under top plat left
                                                                    ((char_y_b >= T_PLATL_B - 5) && (char_x_l >= L_SQ1_R - 1) && (char_x_r <= C_PLATLS_L - 1)) ||      //  Between first square and step and under top plat left
                                                                    ((char_y_b >= L_SQ1_B - 5) && (char_x_l >= L_SQ1_L - 1) && (char_x_r < L_SQ1_R - 1)))        // Fall region: under the square 1 (allows us to stand on the step)
                                                                    // Fall region: under Top left platform
                                                            ) ||                               // End left center level 2 conditions                                     
                        // ***************************************************************************************************************************************************************************************************************************************
                        /* not touching left center 1st step */ ((char_y_b <= C_PLATLS_T - 1) &&                                // Not touching platform
                                                                    ((char_y_b >= T_PLATL_B - 5) && (char_x_l >= C_PLATLS_L - 1) && (char_x_r <= C_PLATLS_R - 1))       // between the platform and under top plat left 
                                                            ) ||                                // End left center step conditions
                        // ***************************************************************************************************************************************************************************************************************************************
                        /* not touching left sq 1 */ ((char_y_b <= L_SQ1_T - 1) &&                  // Not touching the platform 
                                                                    (char_y_b >= T_PLATL_B - 5) && (char_x_l >= L_SQ1_L - 1) && (char_x_r <= L_SQ1_R - 1)       // Fall region: Under top plat left
                                                            ) ||        // End left square 1 conditions
                        // ***************************************************************************************************************************************************************************************************************************************
                        /* not touching left sq 2 */ ((char_y_b <= L_SQ2_T - 1) &&                  // Not touching the platform
                                                                    (((char_x_l >= L_SQ2_L - 1) && (char_x_r <= T_PLATL_L - 1)) ||            // Fall region: between left of square and right of top plat left
                                                                    ((char_y_b >= T_PLATL_B - 5) && (char_x_l >= T_PLATL_L - 1) && (char_x_r <= L_SQ2_R - 1)))               // Fall region: Under top plat left 
                                                            ) ||        // End left square 2 conditions
                        // ***************************************************************************************************************************************************************************************************************************************
                        /* not touching top left plat */ ((char_y_b <= TL_PLAT_T - 1) && (char_x_l >= TL_PLAT_L - 1) && (char_x_r <= TL_PLAT_R - 1)) ||
                        // ***************************************************************************************************************************************************************************************************************************************
                        /* not touching top platform left */ ((char_y_b <= T_PLATL_T - 1) && (char_x_l >= T_PLATL_L - 1) && (char_x_r <= T_PLATL_R - 1)) ||
                        // ***************************************************************************************************************************************************************************************************************************************
                        /* not touching top platform right */ ((char_y_b <= T_PLATR_T - 1) &&           // Not touching the platform 
                                                                    (((char_x_l >= T_PLATR_L - 1) && (char_x_r <= T_PLATRS2_L - 1)) ||                  // Between first step and left side
                                                                    ((char_x_l >= T_PLATRS_R - 1) && (char_x_r <= T_PLATR_R - 1)))// Between second step and right side
                                                            ) ||
                        // ***************************************************************************************************************************************************************************************************************************************
                        /* not touching top platform right stair 1 */ ((char_y_b <= T_PLATRS2_T - 1) && (char_x_l >= T_PLATRS2_L - 1) && (char_x_r <= T_PLATRS2_R - 1)) ||
                        // ***************************************************************************************************************************************************************************************************************************************
                        /* not touching top platform right stair 2 */ ((char_y_b <= T_PLATRS_T - 1) && (char_x_l >= T_PLATRS_L - 1) && (char_x_r <= T_PLATRS_R - 1)) ||
                        // ***************************************************************************************************************************************************************************************************************************************
                        /* not touching top right box */ ((char_y_b <= TR_BOX_T - 1) &&                 // Not touching the platform 
                                                                    (((char_x_l >= TR_BOX_L - 1) && (char_x_r <= END_PLAT_L - 1)) ||            // Fall region: left of end plat
                                                                    ((char_y_b >= END_PLAT_B - 5) && (char_x_l >= END_PLAT_L - 1) && (char_x_r <= TR_BOX_R)))           // Fall region: under end plat
                                                            ) ||
                        // ***************************************************************************************************************************************************************************************************************************************
                        /* not touching end platform */ ((char_y_b <= END_PLAT_T - 1) && (char_x_l >= END_PLAT_L - 1) && (char_x_r <= END_PLAT_R - 1))
                        // ***************************************************************************************************************************************************************************************************************************************
                    ))  
                    // Begin falling
                    begin
                    char_y_next = char_y_reg + 2;                           
                    end
                    
                    // Horizontal Movement
                    //--------------------------------------------
                    //                    Right
                    //--------------------------------------------
                    if(btn[1]) begin                                                  // Check if right button is pressed
                        if (        //Begin conditions for moving right
                              /* At start platform */  ((char_x_r <= C_PLATL_L) && (char_y_t >= TL_PLAT_B + 5)) || 
                              /* Region under c_platl */  ((char_x_r <= C_PLATL_R) && (char_x_l >= C_PLATL_L - CHAR_SIZE) && (char_y_t >= C_PLATL_B) && (char_y_b <= WALL_Y_T1 + 5)) ||
                              /* Region between platforms */  ((char_x_r <= C_PLATR_L) && (char_x_l >= C_PLATL_R - CHAR_SIZE) && (char_y_t >= T_PLATR_B) && (char_y_b <= WALL_Y_T1 + 5)) ||
                              /* Region under c_platr */  ((char_x_r <= C_PLATR_R) && (char_x_l >= C_PLATR_L - CHAR_SIZE) && (char_y_t >= C_PLATR_B) && (char_y_b <= WALL_Y_T1 + 5)) ||
                              /* Region beteen c_platr and right stair */  ((char_x_r <= R_STAIR_L) && (char_x_l >= C_PLATR_R - CHAR_SIZE) && (char_y_t >= WALL_Y_B2) && (char_y_b <= WALL_Y_T1 + 5)) ||
                              /* Between step 1 */  ((char_x_r <= R_STAIR2_L) && (char_x_l >= R_STAIR_L - CHAR_SIZE) && (char_y_t >= TR_BOX_B) && (char_y_b <= R_STAIR_T + 5)) ||
                              /* Between step 2 */  ((char_x_r <= WALL_X_L2) && (char_x_l >= R_STAIR2_L - CHAR_SIZE) && (char_y_t >= TR_BOX_B) && (char_y_b <= R_STAIR2_T + 5)) ||                              
                              /* Between first step center platform and edge of c_platr */ ((char_x_r <= C_PLATR_R) && (char_x_l >= C_PLATS2_L - CHAR_SIZE) && (char_y_t >= T_PLATR_B) && (char_y_b <= C_PLATR_T + 5)) ||
                              /* Between second step */  ((char_x_r <= C_PLATS2_R) && (char_x_l >= C_PLATS_L - CHAR_SIZE) && (char_y_t >= T_PLATR_B) && (char_y_b <= C_PLATS_T + 5)) ||
                              /* Between left edge c_platr and second step */ ((char_x_r <= C_PLATS_L) && (char_x_l >= C_PLATR_L - CHAR_SIZE) && (char_y_t >= T_PLATR_B) && (char_y_b <= C_PLATR_T + 5)) ||
                              /* Between left platform level 2 */  ((char_x_r <= C_PLATL2_R) && (char_x_l >= C_PLATL2_L - CHAR_SIZE) && (char_y_t >= T_PLATL_B) && (char_y_b <= C_PLATL_T + 5)) ||
                              /* Small platform center left */  ((char_x_r <= C_PLATL2_L) && (char_x_l >= C_PLATL_L - CHAR_SIZE) && (char_y_t >= L_SQ2_B) && (char_y_b <= C_PLATL_T + 5)) ||
                              /* Between square 1 and 2 */  ((char_x_r <= L_SQ1_R) && (char_x_l >= L_SQ2_L - CHAR_SIZE) && (char_y_t >= T_PLATL_B) && (char_y_b <= L_SQ1_T + 5)) ||                              
                              /* Between left bound and t_platl's right */  ((char_x_r <= T_PLATL_L) && (char_x_l >= WALL_X_R1) && (char_y_t >= TL_BOX_B) && (char_y_b <= TL_PLAT_T + 5)) ||                              
                              /* Between top plat left */  ((char_x_r <= T_PLATL_R) && (char_x_l >= T_PLATL_L - CHAR_SIZE) && (char_y_t >= TL_BOX_B) && (char_y_b <= T_PLATL_T + 5)) ||
                              /* Between two top platforms */  ((char_x_r <= T_PLATR_L) && (char_x_l >= T_PLATL_R - CHAR_SIZE) && (char_y_t >= WALL_Y_B2) && (char_y_b <= T_PLATL_T + 5)) ||                              
                              /* Between platform's left and stair */ ((char_x_r <= T_PLATRS2_L) && (char_x_l >= T_PLATR_L - CHAR_SIZE) && (char_y_t >= WALL_Y_B2) && (char_y_b <= T_PLATR_T + 5)) ||                              
                              /* Between first step */  ((char_x_r <= T_PLATRS2_R) && (char_x_l >= T_PLATRS2_L - CHAR_SIZE) && (char_y_t >= WALL_Y_B2) && (char_y_b <= T_PLATRS2_T + 5)) ||
                              /* Between second step */  ((char_x_r <= T_PLATRS_R) && (char_x_l >= T_PLATRS_L - CHAR_SIZE) && (char_y_t >= WALL_Y_B2) && (char_y_b <= T_PLATRS_T + 5)) ||                              
                              /* Between second and top right box */  ((char_x_r <= TR_BOX_L) && (char_x_l >= T_PLATRS_R - CHAR_SIZE) && (char_y_t >= WALL_Y_B2) && (char_y_b <= T_PLATR_T + 5)) ||
                              /* Between top right box and left of end plat */  ((char_x_r <= END_PLAT_L) && (char_x_l >= TR_BOX_L - CHAR_SIZE) && (char_y_t >= WALL_Y_B2) && (char_y_b <= TR_BOX_T + 5)) ||
                              /* Between end plat and right wall (under end plat) */  ((char_x_r <= WALL_X_L2) && (char_x_l >= END_PLAT_L - CHAR_SIZE) && (char_y_t >= END_PLAT_B) && (char_y_b <= TR_BOX_T + 5)) ||                              
                              /* Between end plat */  ((char_x_r <= WALL_X_L2) && (char_x_l >= END_PLAT_L - CHAR_SIZE) && (char_y_t >= WALL_Y_B2) && (char_y_b <= END_PLAT_T + 5))                                                            
                           )			 
                        char_x_next = char_x_reg + VEL_P;				      	 // Move right
                    end
                    //--------------------------------------------
                    //                  Left
                    //--------------------------------------------
                    else if (btn[0]) begin                                      // Check if left button is pressed
                        if(         // Begin conditions for moving left
                            /* At start platform */  ((char_x_l >= WALL_X_R1) && (char_x_r <= START_PLAT_R + CHAR_SIZE) && (char_y_t >= TL_PLAT_B) && (char_y_b <= START_PLAT_T + 5)) ||
                            /* Region between c_platl  and start plat */  ((char_x_l >= START_PLAT_R) && (char_x_r <= C_PLATL_L + CHAR_SIZE) && (char_y_t >= TL_PLAT_B) && (char_y_b <= WALL_Y_T1 + 5)) ||                                                      
                            /* Region under c_platl */ ((char_x_l >= C_PLATL_L) && (char_x_r <= C_PLATL_R + CHAR_SIZE) && (char_y_t >= C_PLATL_B) && (char_y_b <= WALL_Y_T1 + 5)) ||                            
                            /* region between platforms */  ((char_x_l >= C_PLATL_R) && (char_x_r <= C_PLATR_L + CHAR_SIZE) && (char_y_t >= T_PLATR_B) && (char_y_b <= WALL_Y_T1 + 5)) ||                                                        
                            /* Region under c_platr */  ((char_x_l >= C_PLATR_L) && (char_x_r <= C_PLATR_R + CHAR_SIZE) && (char_y_t >= C_PLATR_B) && (char_y_b <= WALL_Y_T1 + 5)) ||
                            /* region between c_platr and right stair */  ((char_x_l >= C_PLATR_R) && (char_x_r <= R_STAIR_L + CHAR_SIZE) && (char_y_t >= WALL_Y_B2) && (char_y_b <= WALL_Y_T1 + 5)) ||                            
                            /* Region at stairs */  ((char_x_l >= R_STAIR_L) && (char_x_r <= WALL_X_L2 + CHAR_SIZE) && (char_y_t >= TR_BOX_B) && (char_y_b <= WALL_Y_T1 + 5)) ||                            
                            /* Between right of platform and stair */  ((char_x_l >= C_PLATS2_R) && (char_x_r <= C_PLATR_R + CHAR_SIZE) && (char_y_t >= T_PLATR_B) && (char_y_b <= C_PLATR_T + 5)) ||
                            /* Between step 1 */  ((char_x_l >= C_PLATS2_L) && (char_x_r <= C_PLATS2_R + CHAR_SIZE) && (char_y_t >= T_PLATR_B) && (char_y_b <= C_PLATS2_T + 5)) ||                            
                            /* Between step 2 */  ((char_x_l >= C_PLATS_L) && (char_x_r <= C_PLATS_R + CHAR_SIZE) && (char_y_t >= T_PLATR_B) && (char_y_b <= C_PLATS_T + 5)) ||
                            /* Between left edge of plat and step 2 */  ((char_x_l >= C_PLATR_L) && (char_x_r <= C_PLATS_L + CHAR_SIZE) && (char_y_t >= T_PLATR_B) && (char_y_b <= C_PLATR_T + 5)) ||                                                        
                            /* Between step and right edge of platform */  ((char_x_l >= C_PLATLS_R) && (char_x_r <= C_PLATL_R + CHAR_SIZE) && (char_y_t >= T_PLATL_B) && (char_y_b <= C_PLATL_T + 5)) ||                            
                            /* Between step */ ((char_x_l >= L_SQ1_R) && (char_x_r <= C_PLATLS_R + CHAR_SIZE) && (char_y_t >= T_PLATL_B) && (char_y_b <= C_PLATLS_T + 5)) ||                                      
                            /* Between step and first square */ ((char_x_l >= L_SQ1_R) && (char_x_r <= C_PLATLS_R) && (char_y_t >= T_PLATL_B) && (char_y_b <= C_PLATL2_T + 5)) ||                  
                            /* Under first square */  ((char_x_l >= L_SQ1_L) && (char_x_r <= L_SQ1_R + CHAR_SIZE) && (char_y_t >= L_SQ1_B) && (char_y_b <= C_PLATL2_T + 5)) || 
                            /* Under second square */  ((char_x_l >= L_SQ2_L) && (char_x_r <= L_SQ2_R + CHAR_SIZE) && (char_y_t >= L_SQ2_B) && (char_y_b <= C_PLATL_T + 5)) ||                            
                            /* Above first square */  ((char_x_l >= L_SQ1_L) && (char_x_r <= L_SQ1_R + CHAR_SIZE) && (char_y_t >= T_PLATL_B) && (char_y_b <= L_SQ1_T + 5)) ||
                            /* Above second square up to tl_box*/ ((char_x_l >= L_SQ2_L) && (char_x_r <= L_SQ2_R + CHAR_SIZE) && (char_y_t >= TL_BOX_B) && (char_y_b <= L_SQ2_T + 5)) ||                            
                            /* Between tl_plat */ ((char_x_l >= WALL_X_R1) && (char_x_r <= TL_PLAT_R + CHAR_SIZE) && (char_y_t >= TL_BOX_B) && (char_y_b <= TL_PLAT_T + 5)) ||                            
                            /* Between t_platl */ ((char_x_l >= T_PLATL_L) && (char_x_r <= T_PLATL_R + CHAR_SIZE) && (char_y_t >= TL_BOX_B) && (char_y_b <= T_PLATL_T + 5)) ||
                            /* Between t_platl and t_platr */  ((char_x_l >= T_PLATL_R) && (char_x_r <= T_PLATR_L + CHAR_SIZE) && (char_y_t >= WALL_Y_B2) && (char_y_b <= T_PLATL_T + 5)) ||                            
                            /* Between t_platr and step 1 end */  ((char_x_l >= T_PLATR_L) && (char_x_r <= T_PLATRS2_R + CHAR_SIZE) && (char_y_t >= WALL_Y_B2) && (char_y_b <= T_PLATR_T + 5)) ||
                            /* Between step 2 */  ((char_x_l >= T_PLATRS_L) && (char_x_r <= T_PLATRS_R + CHAR_SIZE) && (char_y_t >= WALL_Y_B2) && (char_y_b <= T_PLATRS_T + 5)) ||
                            /* Between step 2 and end of t_platr */ ((char_x_l >= T_PLATRS_R) && (char_x_r <= T_PLATR_R + CHAR_SIZE) && (char_y_t >= WALL_Y_B2) && (char_y_b <= T_PLATR_T + 5)) ||                            
                            /* Region above tr_box */  ((char_x_l >= TR_BOX_L) && (char_x_r <= WALL_X_L2 + CHAR_SIZE) && (char_y_t >= WALL_Y_B2) && (char_y_b <= TR_BOX_T + 5))                            
                          )
                            char_x_next = char_x_reg + VEL_N;					     // Move left
                    end        
                    
                    //--------------------------------------------
                    // game over condition 
                    //--------------------------------------------
                    // Reached the end 
                    if((char_x_r <= WALL_X_L2) && (char_x_l >= SPIKE21D_X_R - CHAR_SIZE) && ((char_y_b <= END_PLAT_B) || (char_y_b >= END_PLAT_T))) begin
                            char_x_next <= WALL_X_R1 + 1;
                            char_y_next <= START_PLAT_T - CHAR_SIZE;
                            victory = victory + 1;
                            deaths = 0;
                    end
                    // Hit a spike
                    else if(
                                // Up Spikes
                                ((char_x_r >= SPIKE1U_X_L) && (char_y_b >= SPIKE1U_Y_B) && (char_x_l <= SPIKE1U_X_R) && (char_y_t <= SPIKE1U_Y_B)) ||    
                                ((char_x_r >= SPIKE2U_X_L) && (char_y_b >= SPIKE2U_Y_B) && (char_x_l <= SPIKE2U_X_R) && (char_y_t <= SPIKE2U_Y_B)) ||
                                ((char_x_r >= SPIKE3U_X_L) && (char_y_b >= SPIKE3U_Y_B) && (char_x_l <= SPIKE3U_X_R) && (char_y_t <= SPIKE3U_Y_B)) ||
                                ((char_x_r >= SPIKE4U_X_L) && (char_y_b >= SPIKE4U_Y_B) && (char_x_l <= SPIKE4U_X_R) && (char_y_t <= SPIKE4U_Y_B)) ||
                                ((char_x_r >= SPIKE5U_X_L) && (char_y_b >= SPIKE5U_Y_B) && (char_x_l <= SPIKE5U_X_R) && (char_y_t <= SPIKE5U_Y_B)) ||
                                ((char_x_r >= SPIKE6U_X_L) && (char_y_b >= SPIKE6U_Y_B) && (char_x_l <= SPIKE6U_X_R) && (char_y_t <= SPIKE6U_Y_B)) ||
                                ((char_x_r >= SPIKE7U_X_L) && (char_y_b >= SPIKE7U_Y_B) && (char_x_l <= SPIKE7U_X_R) && (char_y_t <= SPIKE7U_Y_B)) ||
                                ((char_x_r >= SPIKE8U_X_L) && (char_y_b >= SPIKE8U_Y_B) && (char_x_l <= SPIKE8U_X_R) && (char_y_t <= SPIKE8U_Y_B)) ||
                                ((char_x_r >= SBOXU_X_L) && (char_y_b >= SBOXU_Y_B) && (char_x_l <= SBOXU_X_R) && (char_y_t <= SBOXU_Y_B)) ||
                                // Down Spikes
                                ((char_x_r >= SPIKE1D_X_L) && (char_y_b >= SPIKE1D_Y_B) && (char_x_l <= SPIKE1D_X_R) && (char_y_t <= SPIKE1D_Y_B)) ||    
                                ((char_x_r >= SPIKE2D_X_L) && (char_y_b >= SPIKE2D_Y_B) && (char_x_l <= SPIKE2D_X_R) && (char_y_t <= SPIKE2D_Y_B)) ||
                                ((char_x_r >= SPIKE3D_X_L) && (char_y_b >= SPIKE3D_Y_B) && (char_x_l <= SPIKE3D_X_R) && (char_y_t <= SPIKE3D_Y_B)) ||
                                ((char_x_r >= SPIKE4D_X_L) && (char_y_b >= SPIKE4D_Y_B) && (char_x_l <= SPIKE4D_X_R) && (char_y_t <= SPIKE4D_Y_B)) ||
                                ((char_x_r >= SPIKE5D_X_L) && (char_y_b >= SPIKE5D_Y_B) && (char_x_l <= SPIKE5D_X_R) && (char_y_t <= SPIKE5D_Y_B)) ||
                                ((char_x_r >= SPIKE6D_X_L) && (char_y_b >= SPIKE6D_Y_B) && (char_x_l <= SPIKE6D_X_R) && (char_y_t <= SPIKE6D_Y_B)) ||
                                ((char_x_r >= SPIKE7D_X_L) && (char_y_b >= SPIKE7D_Y_B) && (char_x_l <= SPIKE7D_X_R) && (char_y_t <= SPIKE7D_Y_B)) ||
                                ((char_x_r >= SPIKE8D_X_L) && (char_y_b >= SPIKE8D_Y_B) && (char_x_l <= SPIKE8D_X_R) && (char_y_t <= SPIKE8D_Y_B)) ||
                                ((char_x_r >= SPIKE9D_X_L) && (char_y_b >= SPIKE9D_Y_B) && (char_x_l <= SPIKE9D_X_R) && (char_y_t <= SPIKE9D_Y_B)) ||
                                ((char_x_r >= SPIKE10D_X_L) && (char_y_b >= SPIKE10D_Y_B) && (char_x_l <= SPIKE10D_X_R) && (char_y_t <= SPIKE10D_Y_B)) ||
                                ((char_x_r >= SPIKE11D_X_L) && (char_y_b >= SPIKE11D_Y_B) && (char_x_l <= SPIKE11D_X_R) && (char_y_t <= SPIKE11D_Y_B)) ||
                                ((char_x_r >= SPIKE12D_X_L) && (char_y_b >= SPIKE12D_Y_B) && (char_x_l <= SPIKE12D_X_R) && (char_y_t <= SPIKE12D_Y_B)) ||
                                ((char_x_r >= SPIKE13D_X_L) && (char_y_b >= SPIKE13D_Y_B) && (char_x_l <= SPIKE13D_X_R) && (char_y_t <= SPIKE13D_Y_B)) ||
                                ((char_x_r >= SPIKE14D_X_L) && (char_y_b >= SPIKE14D_Y_B) && (char_x_l <= SPIKE14D_X_R) && (char_y_t <= SPIKE14D_Y_B)) ||
                                ((char_x_r >= SPIKE15D_X_L) && (char_y_b >= SPIKE15D_Y_B) && (char_x_l <= SPIKE15D_X_R) && (char_y_t <= SPIKE15D_Y_B)) ||
                                ((char_x_r >= SPIKE16D_X_L) && (char_y_b >= SPIKE16D_Y_B) && (char_x_l <= SPIKE16D_X_R) && (char_y_t <= SPIKE16D_Y_B)) ||
                                ((char_x_r >= SPIKE17D_X_L) && (char_y_b >= SPIKE17D_Y_B) && (char_x_l <= SPIKE17D_X_R) && (char_y_t <= SPIKE17D_Y_B)) ||
                                ((char_x_r >= SPIKE18D_X_L) && (char_y_b >= SPIKE18D_Y_B) && (char_x_l <= SPIKE18D_X_R) && (char_y_t <= SPIKE18D_Y_B)) ||
                                ((char_x_r >= SPIKE19D_X_L) && (char_y_b >= SPIKE19D_Y_B) && (char_x_l <= SPIKE19D_X_R) && (char_y_t <= SPIKE19D_Y_B)) ||
                                ((char_x_r >= SPIKE20D_X_L) && (char_y_b >= SPIKE20D_Y_B) && (char_x_l <= SPIKE20D_X_R) && (char_y_t <= SPIKE20D_Y_B)) ||
                                ((char_x_r >= SPIKE21D_X_L) && (char_y_b >= SPIKE21D_Y_B) && (char_x_l <= SPIKE21D_X_R) && (char_y_t <= SPIKE21D_Y_B)) ||
                                ((char_x_r >= SBOXD_X_L) && (char_y_b >= SBOXD_Y_B) && (char_x_l <= SBOXD_X_R) && (char_y_t <= SBOXD_Y_B)) ||
                                // Left Spikes
                                ((char_x_r >= SPIKE1L_X_L) && (char_y_b >= SPIKE1L_Y_B) && (char_x_l <= SPIKE1L_X_R) && (char_y_t <= SPIKE1L_Y_B)) ||
                                ((char_x_r >= SPIKE2L_X_L) && (char_y_b >= SPIKE2L_Y_B) && (char_x_l <= SPIKE2L_X_R) && (char_y_t <= SPIKE2L_Y_B)) ||
                                ((char_x_r >= SPIKE3L_X_L) && (char_y_b >= SPIKE3L_Y_B) && (char_x_l <= SPIKE3L_X_R) && (char_y_t <= SPIKE3L_Y_B)) ||
                                ((char_x_r >= SPIKE4L_X_L) && (char_y_b >= SPIKE4L_Y_B) && (char_x_l <= SPIKE4L_X_R) && (char_y_t <= SPIKE4L_Y_B)) ||
                                ((char_x_r >= SPIKE5L_X_L) && (char_y_b >= SPIKE5L_Y_B) && (char_x_l <= SPIKE5L_X_R) && (char_y_t <= SPIKE5L_Y_B)) ||
                                ((char_x_r >= SPIKE6L_X_L) && (char_y_b >= SPIKE6L_Y_B) && (char_x_l <= SPIKE6L_X_R) && (char_y_t <= SPIKE6L_Y_B)) ||
                                ((char_x_r >= SPIKE7L_X_L) && (char_y_b >= SPIKE7L_Y_B) && (char_x_l <= SPIKE7L_X_R) && (char_y_t <= SPIKE7L_Y_B)) ||
                                ((char_x_r >= SPIKE8L_X_L) && (char_y_b >= SPIKE8L_Y_B) && (char_x_l <= SPIKE8L_X_R) && (char_y_t <= SPIKE8L_Y_B)) ||
                                ((char_x_r >= SPIKE9L_X_L) && (char_y_b >= SPIKE9L_Y_B) && (char_x_l <= SPIKE9L_X_R) && (char_y_t <= SPIKE9L_Y_B)) ||
                                ((char_x_r >= SPIKE10L_X_L) && (char_y_b >= SPIKE10L_Y_B) && (char_x_l <= SPIKE10L_X_R) && (char_y_t <= SPIKE10L_Y_B)) ||
                                ((char_x_r >= SBOXL_X_L) && (char_y_b >= SBOXL_Y_B) && (char_x_l <= SBOXL_X_R) && (char_y_t <= SBOXL_Y_B)) ||
                                // Right Spikes
                                ((char_x_r >= SPIKE1R_X_L) && (char_y_b >= SPIKE1R_Y_B) && (char_x_l <= SPIKE1R_X_R) && (char_y_t <= SPIKE1R_Y_B)) ||
                                ((char_x_r >= SPIKE2R_X_L) && (char_y_b >= SPIKE2R_Y_B) && (char_x_l <= SPIKE2R_X_R) && (char_y_t <= SPIKE2R_Y_B)) ||
                                ((char_x_r >= SPIKE3R_X_L) && (char_y_b >= SPIKE3R_Y_B) && (char_x_l <= SPIKE3R_X_R) && (char_y_t <= SPIKE3R_Y_B)) ||
                                ((char_x_r >= SPIKE4R_X_L) && (char_y_b >= SPIKE4R_Y_B) && (char_x_l <= SPIKE4R_X_R) && (char_y_t <= SPIKE4R_Y_B)) ||
                                ((char_x_r >= SPIKE5R_X_L) && (char_y_b >= SPIKE5R_Y_B) && (char_x_l <= SPIKE5R_X_R) && (char_y_t <= SPIKE5R_Y_B)) ||
                                ((char_x_r >= SPIKE6R_X_L) && (char_y_b >= SPIKE6R_Y_B) && (char_x_l <= SPIKE6R_X_R) && (char_y_t <= SPIKE6R_Y_B)) ||
                                ((char_x_r >= SPIKE7R_X_L) && (char_y_b >= SPIKE7R_Y_B) && (char_x_l <= SPIKE7R_X_R) && (char_y_t <= SPIKE7R_Y_B)) ||
                                ((char_x_r >= SPIKE8R_X_L) && (char_y_b >= SPIKE8R_Y_B) && (char_x_l <= SPIKE8R_X_R) && (char_y_t <= SPIKE8R_Y_B)) ||
                                ((char_x_r >= SPIKE9R_X_L) && (char_y_b >= SPIKE9R_Y_B) && (char_x_l <= SPIKE9R_X_R) && (char_y_t <= SPIKE9R_Y_B)) ||
                                ((char_x_r >= SBOXR_X_L) && (char_y_b >= SBOXR_Y_B) && (char_x_l <= SBOXR_X_R) && (char_y_t <= SBOXR_Y_B))
                           ) begin
                       char_x_next <= WALL_X_R1 + 1;
                       char_y_next <= START_PLAT_T - CHAR_SIZE; 
                       deaths = deaths + 1;
                       end
                end     // end If refr_tick
            end
            
    //--------------------------------------------                                   
    // Counter
    //--------------------------------------------
    assign vcounter10s = victory/10;
    assign vcounter1s = victory%10;
    assign dcounter10s = deaths/10;
    assign dcounter1s = deaths%10;                
    
    wire [4:0] vcounter1_addr, vcounter1_col, vcounter1_bit;
    wire [8:0] vcounter1_data;
    assign vcounter1_addr = pix_x[2:0] - VCOUNTER1_X_L[2:0];
    assign vcounter1_col = pix_y[3:0] - VCOUNTER1_Y_T[3:0];
    assign vcounter1_bit = vcounter1_data[vcounter1_col];
    
    wire [4:0] vcounter10_addr, vcounter10_col, vcounter10_bit;
    wire [8:0] vcounter10_data;
    assign vcounter10_addr = pix_x[2:0] - VCOUNTER10_X_L[2:0];
    assign vcounter10_col = pix_y[3:0] - VCOUNTER10_Y_T[3:0];
    assign vcounter10_bit = vcounter10_data[vcounter10_col];
    
    wire [4:0] dcounter1_addr, dcounter1_col, dcounter1_bit;
    wire [8:0] dcounter1_data;
    assign dcounter1_addr = pix_x[2:0] - DCOUNTER1_X_L[2:0];
    assign dcounter1_col = pix_y[3:0] - DCOUNTER1_Y_T[3:0];
    assign dcounter1_bit = dcounter1_data[dcounter1_col];
        
    wire [4:0] dcounter10_addr, dcounter10_col, dcounter10_bit;
    wire [8:0] dcounter10_data;
    assign dcounter10_addr = pix_x[2:0] - DCOUNTER10_X_L[2:0];
    assign dcounter10_col = pix_y[3:0] - DCOUNTER10_Y_T[3:0];
    assign dcounter10_bit = dcounter10_data[dcounter10_col];
    
    
    
        // Create counters
        display_rom counter1(.address(vcounter1_addr), .counter(vcounter1s), .data(vcounter1_data));     //Create victory 1's digit counter
        display_rom vcounter10(.address(vcounter10_addr), .counter(vcounter10s), .data(vcounter10_data));     //Create victory 10's digit counter        
        display_rom dcounter1(.address(dcounter1_addr), .counter(dcounter1s), .data(dcounter1_data));     //Create deaths 1's digit counter
        display_rom dcounter10(.address(dcounter10_addr), .counter(dcounter10s), .data(dcounter10_data));     //Create deaths 10's digit counter
        
        // Create text
        letter_rom wint(.pix_x(pix_x), .pix_y(pix_y), .left(WINTEXT_X_L), .top(WINTEXT_Y_T), .selector(0), .rom_bit(wintext_bit));
        letter_rom diedt(.pix_x(pix_x), .pix_y(pix_y), .left(DIEDTEXT_X_L), .top(DIEDTEXT_Y_T), .selector(1), .rom_bit(diedtext_bit));
	//--------------------------------------------
	// turn on signals
	//--------------------------------------------	
	// boundaries
	assign bot_bound_on = (WALL_Y_T1<=pix_y) && (pix_y<=WALL_Y_B1);
	assign left_bound_on = (WALL_X_L1<=pix_x) && (pix_x<=WALL_X_R1);
	assign right_bound_on = (WALL_X_L2<=pix_x) && (pix_x<=WALL_X_R2);
	assign top_bound_on = (WALL_Y_T2<=pix_y) && (pix_y<=WALL_Y_B2);
	// platforms
	assign start_plat_on = (START_PLAT_T<=pix_y) && (pix_y<=START_PLAT_B) &&
	                           (START_PLAT_L<=pix_x) && (pix_x<=START_PLAT_R);
    assign r_stair_on = (R_STAIR_T<=pix_y) && (pix_y<=R_STAIR_B) &&
                            (R_STAIR_L<=pix_x) && (pix_x<=R_STAIR_R);
    assign r_stair2_on = (R_STAIR2_T<=pix_y) && (pix_y<=R_STAIR2_B) &&
                            (R_STAIR2_L<=pix_x) && (pix_x<=R_STAIR2_R);
    assign c_platl_on = (C_PLATL_T<=pix_y) && (pix_y<=C_PLATL_B) &&
                            (C_PLATL_L<=pix_x) && (pix_x<=C_PLATL_R);
    assign c_platl2_on = (C_PLATL2_T<=pix_y) && (pix_y<=C_PLATL2_B) &&
                            (C_PLATL2_L<=pix_x) && (pix_x<=C_PLATL2_R);
    assign c_platls_on = (C_PLATLS_T<=pix_y) && (pix_y<=C_PLATLS_B) &&
                        (C_PLATLS_L<=pix_x) && (pix_x<=C_PLATLS_R);
    assign c_platr_on = (C_PLATR_T<=pix_y) && (pix_y<=C_PLATR_B) &&
                            (C_PLATR_L<=pix_x) && (pix_x<=C_PLATR_R);
    assign s_box_on = (S_BOX_T<=pix_y) && (pix_y<=S_BOX_B) &&
                            (S_BOX_L<=pix_x) && (pix_x<=S_BOX_R);
    assign c_plats_on = (C_PLATS_T<=pix_y) && (pix_y<=C_PLATS_B) &&
                            (C_PLATS_L<=pix_x) && (pix_x<=C_PLATS_R);
    assign c_plats2_on = (C_PLATS2_T<=pix_y) && (pix_y<=C_PLATS2_B) &&
                            (C_PLATS2_L<=pix_x) && (pix_x<=C_PLATS2_R);
    assign l_sq1_on = (L_SQ1_T<=pix_y) && (pix_y<=L_SQ1_B) &&
                            (L_SQ1_L<=pix_x) && (pix_x<=L_SQ1_R);
    assign l_sq2_on = (L_SQ2_T<=pix_y) && (pix_y<=L_SQ2_B) &&
                            (L_SQ2_L<=pix_x) && (pix_x<=L_SQ2_R);    
    assign tl_plat_on = (TL_PLAT_T<=pix_y) && (pix_y<=TL_PLAT_B) &&
                            (TL_PLAT_L<=pix_x) && (pix_x<=TL_PLAT_R);
    assign tl_box_on = (TL_BOX_T<=pix_y) && (pix_y<=TL_BOX_B) &&
                            (TL_BOX_L<=pix_x) && (pix_x<=TL_BOX_R);
    assign t_platl_on = (T_PLATL_T<=pix_y) && (pix_y<=T_PLATL_B) &&
                            (T_PLATL_L<=pix_x) && (pix_x<=T_PLATL_R);
    assign t_platr_on = (T_PLATR_T<=pix_y) && (pix_y<=T_PLATR_B) &&
                            (T_PLATR_L<=pix_x) && (pix_x<=T_PLATR_R);
    assign tr_box_on = (TR_BOX_T<=pix_y) && (pix_y<=TR_BOX_B) &&
                            (TR_BOX_L<=pix_x) && (pix_x<=TR_BOX_R);
    assign t_platrs_on = (T_PLATRS_T<=pix_y) && (pix_y<=T_PLATRS_B) &&
                            (T_PLATRS_L<=pix_x) && (pix_x<=T_PLATRS_R);
    assign t_platrs2_on = (T_PLATRS2_T<=pix_y) && (pix_y<=T_PLATRS2_B) &&
                            (T_PLATRS2_L<=pix_x) && (pix_x<=T_PLATRS2_R);
    assign end_plat_on = (END_PLAT_T<=pix_y) && (pix_y<=END_PLAT_B) &&
                            (END_PLAT_L<=pix_x) && (pix_x<=END_PLAT_R);
	// spikes
    assign sboxd_detail_on = 
        (SBOXD_X_L<=pix_x) && (pix_x<=SBOXD_X_R) &&
        (SBOXD_Y_T<=pix_y) && (pix_y<=SBOXD_Y_B);
    assign sboxd_on = sboxd_detail_on & sboxd_rom_bit;
    
    assign sboxu_detail_on = 
        (SBOXU_X_L<=pix_x) && (pix_x<=SBOXU_X_R) &&
        (SBOXU_Y_T<=pix_y) && (pix_y<=SBOXU_Y_B);
    assign sboxu_on = sboxu_detail_on & sboxu_rom_bit;
    
    assign sboxl_detail_on = 
        (SBOXL_X_L<=pix_x) && (pix_x<=SBOXL_X_R) &&
        (SBOXL_Y_T<=pix_y) && (pix_y<=SBOXL_Y_B);
    assign sboxl_on = sboxl_detail_on & sboxl_rom_bit;
    
    assign sboxr_detail_on = 
        (SBOXR_X_L<=pix_x) && (pix_x<=SBOXR_X_R) &&
        (SBOXR_Y_T<=pix_y) && (pix_y<=SBOXR_Y_B);
    assign sboxr_on = sboxr_detail_on & sboxr_rom_bit;            

	assign obstacle1_on = 
	    (SPIKE1U_X_L<=pix_x) && (pix_x<=SPIKE1U_X_R) &&
	    (SPIKE1U_Y_T<=pix_y) && (pix_y<=SPIKE1U_Y_B);
    assign spike1u_on = obstacle1_on & spikeu_rom_bit;
    
    assign obstacle2_on = 
            (SPIKE1D_X_L<=pix_x) && (pix_x<=SPIKE1D_X_R) &&
            (SPIKE1D_Y_T<=pix_y) && (pix_y<=SPIKE1D_Y_B);
    assign spike1d_on = obstacle2_on & spiked_rom_bit;
    
    assign obstacle3_on = 
            (SPIKE2D_X_L<=pix_x) && (pix_x<=SPIKE2D_X_R) &&
            (SPIKE2D_Y_T<=pix_y) && (pix_y<=SPIKE2D_Y_B);
    assign spike2d_on = obstacle3_on & spike2d_rom_bit;   
     
    assign obstacle4_on = 
            (SPIKE2U_X_L<=pix_x) && (pix_x<=SPIKE2U_X_R) &&
            (SPIKE2U_Y_T<=pix_y) && (pix_y<=SPIKE2U_Y_B);
    assign spike2u_on = obstacle4_on & spike2u_rom_bit;
    
    assign obstacle5_on = 
            (SPIKE3D_X_L<=pix_x) && (pix_x<=SPIKE3D_X_R) &&
            (SPIKE3D_Y_T<=pix_y) && (pix_y<=SPIKE3D_Y_B);
    assign spike3d_on = obstacle5_on & spike3d_rom_bit;
    
    assign obstacle6_on = 
            (SPIKE3U_X_L<=pix_x) && (pix_x<=SPIKE3U_X_R) &&
            (SPIKE3U_Y_T<=pix_y) && (pix_y<=SPIKE3U_Y_B);
    assign spike3u_on = obstacle6_on & spike3u_rom_bit; 
    
    assign obstacle7_on = 
            (SPIKE4D_X_L<=pix_x) && (pix_x<=SPIKE4D_X_R) &&
            (SPIKE4D_Y_T<=pix_y) && (pix_y<=SPIKE4D_Y_B);
    assign spike4d_on = obstacle7_on & spike4d_rom_bit;   

    assign obstacle8_on = 
            (SPIKE4U_X_L<=pix_x) && (pix_x<=SPIKE4U_X_R) &&
            (SPIKE4U_Y_T<=pix_y) && (pix_y<=SPIKE4U_Y_B);
    assign spike4u_on = obstacle8_on & spike4u_rom_bit;
        
    assign obstacle9_on = 
            (SPIKE1L_X_L<=pix_x) && (pix_x<=SPIKE1L_X_R) &&
            (SPIKE1L_Y_T<=pix_y) && (pix_y<=SPIKE1L_Y_B);
    assign spike1l_on = obstacle9_on & spikel_rom_bit;      
    
    assign obstacle10_on = 
        (SPIKE2L_X_L<=pix_x) && (pix_x<=SPIKE2L_X_R) &&
        (SPIKE2L_Y_T<=pix_y) && (pix_y<=SPIKE2L_Y_B);
    assign spike2l_on = obstacle10_on & spike2l_rom_bit;  
    
    assign obstacle11_on = 
            (SPIKE3L_X_L<=pix_x) && (pix_x<=SPIKE3L_X_R) &&
            (SPIKE3L_Y_T<=pix_y) && (pix_y<=SPIKE3L_Y_B);
    assign spike3l_on = obstacle11_on & spike3l_rom_bit;  
    
    assign obstacle12_on = 
            (SPIKE4L_X_L<=pix_x) && (pix_x<=SPIKE4L_X_R) &&
            (SPIKE4L_Y_T<=pix_y) && (pix_y<=SPIKE4L_Y_B);
    assign spike4l_on = obstacle12_on & spike4l_rom_bit;  
    
    assign obstacle13_on = 
            (SPIKE5L_X_L<=pix_x) && (pix_x<=SPIKE5L_X_R) &&
            (SPIKE5L_Y_T<=pix_y) && (pix_y<=SPIKE5L_Y_B);
    assign spike5l_on = obstacle13_on & spike5l_rom_bit;  
    
    assign obstacle14_on = 
            (SPIKE6L_X_L<=pix_x) && (pix_x<=SPIKE6L_X_R) &&
            (SPIKE6L_Y_T<=pix_y) && (pix_y<=SPIKE6L_Y_B);
    assign spike6l_on = obstacle14_on & spike6l_rom_bit;  
    
    assign obstacle15_on = 
            (SPIKE7L_X_L<=pix_x) && (pix_x<=SPIKE7L_X_R) &&
            (SPIKE7L_Y_T<=pix_y) && (pix_y<=SPIKE7L_Y_B);
    assign spike7l_on = obstacle15_on & spike7l_rom_bit;  
    
    assign obstacle16_on = 
            (SPIKE8L_X_L<=pix_x) && (pix_x<=SPIKE8L_X_R) &&
            (SPIKE8L_Y_T<=pix_y) && (pix_y<=SPIKE8L_Y_B);
    assign spike8l_on = obstacle16_on & spike8l_rom_bit;  
    
    assign obstacle17_on = 
            (SPIKE5D_X_L<=pix_x) && (pix_x<=SPIKE5D_X_R) &&
            (SPIKE5D_Y_T<=pix_y) && (pix_y<=SPIKE5D_Y_B);
    assign spike5d_on = obstacle17_on & spike5d_rom_bit; 

    assign obstacle18_on = 
            (SPIKE6D_X_L<=pix_x) && (pix_x<=SPIKE6D_X_R) &&
            (SPIKE6D_Y_T<=pix_y) && (pix_y<=SPIKE6D_Y_B);
    assign spike6d_on = obstacle18_on & spike6d_rom_bit; 
    
    assign obstacle19_on = 
            (SPIKE7D_X_L<=pix_x) && (pix_x<=SPIKE7D_X_R) &&
            (SPIKE7D_Y_T<=pix_y) && (pix_y<=SPIKE7D_Y_B);
    assign spike7d_on = obstacle19_on & spike7d_rom_bit; 

    assign obstacle20_on = 
            (SPIKE8D_X_L<=pix_x) && (pix_x<=SPIKE8D_X_R) &&
            (SPIKE8D_Y_T<=pix_y) && (pix_y<=SPIKE8D_Y_B);
    assign spike8d_on = obstacle20_on & spike8d_rom_bit;  
    
    assign obstacle21_on = 
            (SPIKE5U_X_L<=pix_x) && (pix_x<=SPIKE5U_X_R) &&
            (SPIKE5U_Y_T<=pix_y) && (pix_y<=SPIKE5U_Y_B);
    assign spike5u_on = obstacle21_on & spike5u_rom_bit; 
    
    assign obstacle22_on = 
            (SPIKE9D_X_L<=pix_x) && (pix_x<=SPIKE9D_X_R) &&
            (SPIKE9D_Y_T<=pix_y) && (pix_y<=SPIKE9D_Y_B);
    assign spike9d_on = obstacle22_on & spike9d_rom_bit; 
    
    assign obstacle23_on = 
            (SPIKE6U_X_L<=pix_x) && (pix_x<=SPIKE6U_X_R) &&
            (SPIKE6U_Y_T<=pix_y) && (pix_y<=SPIKE6U_Y_B);
    assign spike6u_on = obstacle23_on & spike6u_rom_bit;  
    
    assign obstacle24_on = 
            (SPIKE7U_X_L<=pix_x) && (pix_x<=SPIKE7U_X_R) &&
            (SPIKE7U_Y_T<=pix_y) && (pix_y<=SPIKE7U_Y_B);
    assign spike7u_on = obstacle24_on & spike7u_rom_bit;          
    
    assign obstacle25_on = 
            (SPIKE10D_X_L<=pix_x) && (pix_x<=SPIKE10D_X_R) &&
            (SPIKE10D_Y_T<=pix_y) && (pix_y<=SPIKE10D_Y_B);
    assign spike10d_on = obstacle25_on & spike10d_rom_bit; 
    
    assign obstacle26_on = 
            (SPIKE11D_X_L<=pix_x) && (pix_x<=SPIKE11D_X_R) &&
            (SPIKE11D_Y_T<=pix_y) && (pix_y<=SPIKE11D_Y_B);
    assign spike11d_on = obstacle26_on & spike11d_rom_bit;
    
    assign obstacle27_on = 
            (SPIKE12D_X_L<=pix_x) && (pix_x<=SPIKE12D_X_R) &&
            (SPIKE12D_Y_T<=pix_y) && (pix_y<=SPIKE12D_Y_B);
    assign spike12d_on = obstacle27_on & spike12d_rom_bit;
    
    assign obstacle28_on = 
            (SPIKE13D_X_L<=pix_x) && (pix_x<=SPIKE13D_X_R) &&
            (SPIKE13D_Y_T<=pix_y) && (pix_y<=SPIKE13D_Y_B);
    assign spike13d_on = obstacle28_on & spike13d_rom_bit;         
    
    assign obstacle29_on = 
            (SPIKE14D_X_L<=pix_x) && (pix_x<=SPIKE14D_X_R) &&
            (SPIKE14D_Y_T<=pix_y) && (pix_y<=SPIKE14D_Y_B);
    assign spike14d_on = obstacle29_on & spike14d_rom_bit;             
    
    assign obstacle30_on = 
            (SPIKE9L_X_L<=pix_x) && (pix_x<=SPIKE9L_X_R) &&
            (SPIKE9L_Y_T<=pix_y) && (pix_y<=SPIKE9L_Y_B);
    assign spike9l_on = obstacle30_on & spike9l_rom_bit;           
    
    assign obstacle31_on = 
            (SPIKE1R_X_L<=pix_x) && (pix_x<=SPIKE1R_X_R) &&
            (SPIKE1R_Y_T<=pix_y) && (pix_y<=SPIKE1R_Y_B);
    assign spike1r_on = obstacle31_on & spike1r_rom_bit;  
    
    assign obstacle32_on = 
            (SPIKE2R_X_L<=pix_x) && (pix_x<=SPIKE2R_X_R) &&
            (SPIKE2R_Y_T<=pix_y) && (pix_y<=SPIKE2R_Y_B);
    assign spike2r_on = obstacle32_on & spike2r_rom_bit; 
    
    assign obstacle33_on = 
            (SPIKE15D_X_L<=pix_x) && (pix_x<=SPIKE15D_X_R) &&
            (SPIKE15D_Y_T<=pix_y) && (pix_y<=SPIKE15D_Y_B);
    assign spike15d_on = obstacle33_on & spike15d_rom_bit;  
    
    assign obstacle34_on = 
            (SPIKE16D_X_L<=pix_x) && (pix_x<=SPIKE16D_X_R) &&
            (SPIKE16D_Y_T<=pix_y) && (pix_y<=SPIKE16D_Y_B);
    assign spike16d_on = obstacle34_on & spike16d_rom_bit; 
    
    assign obstacle35_on = 
            (SPIKE17D_X_L<=pix_x) && (pix_x<=SPIKE17D_X_R) &&
            (SPIKE17D_Y_T<=pix_y) && (pix_y<=SPIKE17D_Y_B);
    assign spike17d_on = obstacle35_on & spike17d_rom_bit; 
    
    assign obstacle36_on = 
            (SPIKE18D_X_L<=pix_x) && (pix_x<=SPIKE18D_X_R) &&
            (SPIKE18D_Y_T<=pix_y) && (pix_y<=SPIKE18D_Y_B);
    assign spike18d_on = obstacle36_on & spike18d_rom_bit;           
    
    assign obstacle37_on = 
            (SPIKE3R_X_L<=pix_x) && (pix_x<=SPIKE3R_X_R) &&
            (SPIKE3R_Y_T<=pix_y) && (pix_y<=SPIKE3R_Y_B);
    assign spike3r_on = obstacle37_on & spike3r_rom_bit;   
    
    assign obstacle38_on = 
            (SPIKE4R_X_L<=pix_x) && (pix_x<=SPIKE4R_X_R) &&
            (SPIKE4R_Y_T<=pix_y) && (pix_y<=SPIKE4R_Y_B);
    assign spike4r_on = obstacle38_on & spike4r_rom_bit; 
    
    assign obstacle39_on = 
            (SPIKE5R_X_L<=pix_x) && (pix_x<=SPIKE5R_X_R) &&
            (SPIKE5R_Y_T<=pix_y) && (pix_y<=SPIKE5R_Y_B);
    assign spike5r_on = obstacle39_on & spike5r_rom_bit; 
    
    assign obstacle40_on = 
            (SPIKE6R_X_L<=pix_x) && (pix_x<=SPIKE6R_X_R) &&
            (SPIKE6R_Y_T<=pix_y) && (pix_y<=SPIKE6R_Y_B);
    assign spike6r_on = obstacle40_on & spike6r_rom_bit;                           

    assign obstacle41_on = 
            (SPIKE7R_X_L<=pix_x) && (pix_x<=SPIKE7R_X_R) &&
            (SPIKE7R_Y_T<=pix_y) && (pix_y<=SPIKE7R_Y_B);
    assign spike7r_on = obstacle41_on & spike7r_rom_bit;   
    
    assign obstacle42_on = 
            (SPIKE19D_X_L<=pix_x) && (pix_x<=SPIKE19D_X_R) &&
            (SPIKE19D_Y_T<=pix_y) && (pix_y<=SPIKE19D_Y_B);
    assign spike19d_on = obstacle42_on & spike19d_rom_bit; 
    
    assign obstacle43_on = 
            (SPIKE8U_X_L<=pix_x) && (pix_x<=SPIKE8U_X_R) &&
            (SPIKE8U_Y_T<=pix_y) && (pix_y<=SPIKE8U_Y_B);
    assign spike8u_on = obstacle43_on & spike8u_rom_bit; 
    
    assign obstacle44_on = 
            (SPIKE20D_X_L<=pix_x) && (pix_x<=SPIKE20D_X_R) &&
            (SPIKE20D_Y_T<=pix_y) && (pix_y<=SPIKE20D_Y_B);
    assign spike20d_on = obstacle44_on & spike20d_rom_bit;             
                                                          
    assign obstacle45_on = 
            (SPIKE21D_X_L<=pix_x) && (pix_x<=SPIKE21D_X_R) &&
            (SPIKE21D_Y_T<=pix_y) && (pix_y<=SPIKE21D_Y_B);
    assign spike21d_on = obstacle45_on & spike21d_rom_bit;  

    assign obstacle46_on = 
            (SPIKE8R_X_L<=pix_x) && (pix_x<=SPIKE8R_X_R) &&
            (SPIKE8R_Y_T<=pix_y) && (pix_y<=SPIKE8R_Y_B);
    assign spike8r_on = obstacle46_on & spike8r_rom_bit;  
    
    assign obstacle47_on = 
            (SPIKE9R_X_L<=pix_x) && (pix_x<=SPIKE9R_X_R) &&
            (SPIKE9R_Y_T<=pix_y) && (pix_y<=SPIKE9R_Y_B);
    assign spike9r_on = obstacle47_on & spike9r_rom_bit;    
                                                                  
    assign obstacle48_on = 
            (SPIKE10L_X_L<=pix_x) && (pix_x<=SPIKE10L_X_R) &&
            (SPIKE10L_Y_T<=pix_y) && (pix_y<=SPIKE10L_Y_B);
    assign spike10l_on = obstacle48_on & spike10l_rom_bit;    
                                                         
    // counters
    assign vcounter10_on = (VCOUNTER10_X_L<=pix_x) && (pix_x<=VCOUNTER10_X_R) &&
                           (VCOUNTER10_Y_T<=pix_y) && (pix_y<=VCOUNTER10_Y_B);
    assign vc10_on = vcounter10_on & vcounter10_bit;
    
    assign vcounter1_on = (VCOUNTER1_X_L<=pix_x) && (pix_x<=VCOUNTER1_X_R) &&
                          (VCOUNTER1_Y_T<=pix_y) && (pix_y<=VCOUNTER1_Y_B);
    assign vc1_on = vcounter1_on & vcounter1_bit;
    
    assign dcounter10_on = (DCOUNTER10_X_L<=pix_x) && (pix_x<=DCOUNTER10_X_R) &&
                           (DCOUNTER10_Y_T<=pix_y) && (pix_y<=DCOUNTER10_Y_B);
    assign dc10_on = dcounter10_on & dcounter10_bit;   
                        
    assign dcounter1_on = (DCOUNTER1_X_L<=pix_x) && (pix_x<=DCOUNTER1_X_R) &&
                          (DCOUNTER1_Y_T<=pix_y) && (pix_y<=DCOUNTER1_Y_B);
    assign dc1_on = dcounter1_on & dcounter1_bit;
    
    assign wintext_on = (WINTEXT_X_L<=pix_x) && (pix_x<=WINTEXT_X_R) &&
                        (WINTEXT_Y_T<=pix_y) && (pix_y<=WINTEXT_Y_B);
    assign wtext_on = wintext_on & wintext_bit;
    
    assign diedtext_on = (DIEDTEXT_X_L<=pix_x) && (pix_x<=DIEDTEXT_X_R) &&
                        (DIEDTEXT_Y_T<=pix_y) && (pix_y<=DIEDTEXT_Y_B);
    assign dtext_on = diedtext_on & diedtext_bit;
	// character
	assign char_on =
		(char_x_l<=pix_x) && (pix_x<=char_x_r) &&
		(char_y_t<=pix_y) && (pix_y<=char_y_b);
	       
	//--------------------------------------------
	// colors
	//--------------------------------------------
	// boundaries & platforms
	assign wall_rgb = 12'h000; // black
	assign char_rgb = 12'h00F; // blue
	assign spike_rgb = 12'hFFF; // white
	assign counter_rgb = 12'hFFF; // white
	
	//--------------------------------------------
	// rgb multiplexing circuit
	//--------------------------------------------
	always @*
		if (~video_on)
			graph_rgb = 12'h000; // blank
		else
		    /* character on */
			if (char_on)
				graph_rgb = char_rgb;
            /* counter on */
/*            else if (
                vcounter10_on || vcounter1_on ||
                dcounter10_on || dcounter1_on ||
                wtext_on || dtext_on
                )
                graph_rgb = counter_rgb;*/
            /* platforms on */
			else if (bot_bound_on || top_bound_on ||
				left_bound_on || right_bound_on ||
				start_plat_on || r_stair_on || 
				r_stair2_on || c_platl_on || c_platr_on ||
				c_plats_on || c_plats2_on || c_platl2_on ||
				c_platls_on || l_sq1_on ||
				l_sq2_on || tl_plat_on || tl_box_on ||
				t_platl_on || t_platr_on || tr_box_on ||
				t_platrs_on || end_plat_on || t_platrs2_on ||
				s_box_on
				)
				graph_rgb = wall_rgb;
            /* Spike on */
            else if (
                sboxd_on || sboxu_on ||
                sboxl_on || sboxr_on ||
                spike1u_on || spike1d_on ||
                spike2d_on || spike2u_on || 
                spike3d_on || spike3u_on ||
                spike4d_on || spike1l_on ||
                spike2l_on || spike3l_on ||
                spike4l_on || spike5l_on ||
                spike6l_on || spike7l_on ||
                spike8l_on || spike5d_on ||
                spike6d_on || spike7d_on ||
                spike8d_on || spike4u_on ||
                spike5u_on || spike9d_on ||
                spike6u_on || spike7u_on ||
                spike10d_on || spike11d_on ||
                spike12d_on || spike13d_on ||
                spike14d_on || spike9l_on ||
                spike1r_on || spike2r_on ||
                spike15d_on || spike16d_on ||
                spike17d_on || spike18d_on ||
                spike3r_on || spike4r_on ||
                spike5r_on || spike6r_on ||
                spike7r_on || spike19d_on ||
                spike8u_on || spike20d_on ||
                spike21d_on || spike8r_on ||
                spike9r_on || spike10l_on                
                )
                graph_rgb = spike_rgb;
            /* Background on */
			else
				graph_rgb = 12'h95D; //Purple  
endmodule
