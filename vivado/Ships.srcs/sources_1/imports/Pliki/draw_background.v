`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Module Name: draw_background
// Project Name: Statki
// Description: Modu³ obs³uguje rysowanie t³a na ekranie. Otrzymane sygna³y pikseli od modu³u timing zostaj¹ wstêpnie pokolorwane,
// a sygna³y steruj¹ce zinkrementowane. Wszytskie sygna³y id¹ wspólnie do nastêpnego modu³u przetwarzaj¹cego piksele - draw_reg
//////////////////////////////////////////////////////////////////////////////////

module draw_background(
    input wire clk,
    input wire rst,
    input wire [10:0] hcount_in,
    input wire hsync_in,
    input wire hblnk_in,
    input wire [10:0] vcount_in,
    input wire vsync_in,
    input wire vblnk_in,
    input wire [3:0] program_state,
    input wire [3:0] board_size_in,
    output reg [10:0] hcount_out,
    output reg hsync_out,
    output reg hblnk_out,
    output reg [10:0] vcount_out,
    output reg vsync_out,
    output reg vblnk_out,
    output reg [11:0] rgb_out
    );
    
    
    // program states
    localparam IDLE = 4'b0000;
    localparam CHOSING_BOARD_SIZE = 4'b0001;
    localparam CHOSING_PLAYERS = 4'b0010;
    localparam PLACING_SHIPS = 4'b0011;
    localparam FINDING_SHIPS = 4'b0100;
    localparam SCREEN_BLANKING = 4'b0101;
    localparam GAME_ENDING = 4'b0110;
    
    localparam BOARD_XPOS = 40;
    localparam BOARD_YPOS = 40;
    localparam SQUARE_SIZE = 40;

    reg [11:0] rgb_out_nxt; 
    
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
        end
        else
            hcount_out <= hcount_in;
            hsync_out  <= hsync_in;
            hblnk_out  <= hblnk_in;
            vcount_out <= vcount_in;
            vsync_out  <= vsync_in;
            vblnk_out  <= vblnk_in;
            rgb_out <= rgb_out_nxt;
        begin            
        end
    end
    
    always @*
    begin
        rgb_out_nxt = rgb_out;
        if(vblnk_in || hblnk_in) 
            rgb_out_nxt <= 12'h0_0_0; // Blank screen
        else
        begin             
             if(vcount_in == 0) 
                rgb_out_nxt = 12'hf_f_0; // Active display, top edge, make a yellow line.            
            else if(vcount_in == 599) 
                rgb_out_nxt = 12'hf_0_0; // Active display, bottom edge, make a red line.
            else if(hcount_in == 0) 
                rgb_out_nxt = 12'h0_f_0; // Active display, left edge, make a green line.            
            else if(hcount_in == 799) 
                rgb_out_nxt = 12'h0_0_f; // Active display, right edge, make a blue line.
            else
                rgb_out_nxt = 12'h8_8_8; // Active display, interior, fill with gray.                  
        end
        case(program_state)
            PLACING_SHIPS: // rysuje plansze 
            begin    
                if((hcount_in >= BOARD_XPOS) && (hcount_in < BOARD_XPOS+SQUARE_SIZE*board_size_in) && (vcount_in >= BOARD_YPOS) && (vcount_in < BOARD_YPOS+SQUARE_SIZE*board_size_in))
                begin
                    if((((hcount_in-BOARD_XPOS)/SQUARE_SIZE) % 2) == (((vcount_in-BOARD_YPOS)/SQUARE_SIZE) % 2))
                        rgb_out_nxt = 12'h3_5_9;    
                    else
                        rgb_out_nxt = 12'h9_3_5;
                end
            end
            FINDING_SHIPS:
            begin
                if((hcount_in >= BOARD_XPOS) && (hcount_in < BOARD_XPOS+SQUARE_SIZE*board_size_in) && (vcount_in >= BOARD_YPOS) && (vcount_in < BOARD_YPOS+SQUARE_SIZE*board_size_in))
                begin
                    if((((hcount_in-BOARD_XPOS)/SQUARE_SIZE) % 2) == (((vcount_in-BOARD_YPOS)/SQUARE_SIZE) % 2))
                        rgb_out_nxt = 12'h3_5_9;    
                    else
                        rgb_out_nxt = 12'h9_3_5;
                end            
            end
            default:
            begin
                // w innych przypadkach nie trzeba niczego dorysowywaæ
            end    
         endcase
    end
endmodule
