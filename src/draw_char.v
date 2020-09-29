`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Module Name: draw_char
// Project Name: Statki
// Description: Modu³ odpowiada za wyœwietlanie wiadomoœci o stanie programu na ekran
//////////////////////////////////////////////////////////////////////////////////

    module draw_char(
    input wire clk,
    input wire rst,
    input wire [10:0] hcount_in,
    input wire hsync_in,
    input wire hblnk_in,
    input wire [10:0] vcount_in,
    input wire vsync_in,
    input wire vblnk_in,
    input wire [11:0] rgb_in,
    input wire [7:0] char_instruction, //char_player1, char_player2,
    output reg [10:0] hcount_out,
    output reg hsync_out,
    output reg hblnk_out,
    output reg [10:0] vcount_out,
    output reg vsync_out,
    output reg vblnk_out,
    output reg [11:0] rgb_out,
    output reg [7:0] char_xy_instruction, //char_xy_player1, char_xy_player2,
    output reg [3:0] char_line_instruction //char_line_player1, char_line_player2
    );
    
    reg [11:0] rgb_out_nxt;
    reg [2:0] counter, counter_nxt;
    reg [7:0] char_xy_nxt;
    reg [3:0] char_line_nxt;    
    reg [3:0] char_x, char_y;
    
    localparam H_MIN = 0;
    localparam H_MAX = 800;
    localparam Y_MIN = 0;
    localparam Y_MAX = 600;
    localparam X_POSITION = 300;
    localparam Y_POSITION = 400; //500
        
    always @(posedge clk)
    begin
        if(rst)
        begin
            hcount_out <= 0;
            hsync_out  <= 0;
            hblnk_out  <= 0;
            vcount_out <= 0;
            vsync_out  <= 0;
            vblnk_out  <= 0;
            rgb_out    <= 0; 
            counter    <= 0;           
        end
        else
        begin
            hcount_out <= hcount_in;
            hsync_out  <= hsync_in;
            hblnk_out  <= hblnk_in;
            vcount_out <= vcount_in;
            vsync_out  <= vsync_in;
            vblnk_out  <= vblnk_in;
            rgb_out    <= rgb_out_nxt;
            char_xy_instruction <= char_xy_nxt;
            char_line_instruction <= char_line_nxt;
            counter    <= counter_nxt;            
        end
    end
    
    always @*
    begin
        if(counter == 0)
            counter_nxt = 7;
        else
            counter_nxt = counter-1;
        if(hcount_in == X_POSITION-6)
                counter_nxt = 7;
        if((char_instruction[counter] == 1) && (hcount_in > H_MIN) && (hcount_in < H_MAX) && (vcount_in > Y_MIN) && (vcount_in < Y_MAX))
            rgb_out_nxt = 5;
        else
            rgb_out_nxt = rgb_in;
        if(((hcount_in-X_POSITION)/8 < 16) && (hcount_in >= X_POSITION) && ((vcount_in-Y_POSITION)/16 < 16) && (vcount_in >= Y_POSITION))
        begin
            char_x = (hcount_in-X_POSITION)/8;
            char_y = (vcount_in-Y_POSITION)/16;
            char_xy_nxt = {char_x, char_y};
        end
        else
            char_xy_nxt = 8'hff;
        char_line_nxt = (vcount_in-Y_POSITION)%16;
    end
endmodule
