`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Module Name: find_ships
// Project Name: Statki
// Description: Modu³ odpowiada za odnajdywanie statków na planszy
//////////////////////////////////////////////////////////////////////////////////


module find_ships(
    input wire clk,
    input wire rst,
    input wire [11:0] mouse_xpos,
    input wire [11:0] mouse_ypos,
    input wire mouse_left_tick,
    input wire mouse_right_tick,
    input wire [3:0] board_size,
    input wire [3:0] program_state,
    input wire active_player, 
    output reg warning,
    output reg [63:0] player1_board, 
    output reg [63:0] player2_board,
    output reg [3:0] rows_counter,
    output reg [3:0] columns_counter,
    output reg finished_move,
    output reg active_move
    );
    
    // program states
    localparam IDLE = 4'b0000;
    localparam CHOSING_BOARD_SIZE = 4'b0001;
    localparam CHOSING_PLAYERS = 4'b0010;
    localparam PLACING_SHIPS = 4'b0011;
    localparam FINDING_SHIPS = 4'b0100;
    localparam SCREEN_BLANKING = 4'b0101;
    localparam GAME_ENDING = 4'b0110;
   
    // rozmiary wszelakiej wielkoœci statków 
    localparam BOARD_XPOS = 40;
    localparam BOARD_YPOS = 40;
    localparam SQUARE_SIZE = 40;
    
    
    reg [63:0] player1_board_nxt, player2_board_nxt;   
    reg [3:0] rows_counter_nxt, columns_counter_nxt; 
    reg warning_nxt, active_move_nxt, active_player_nxt, finished_move_nxt;
        
    always @(posedge clk)
    begin
        if(rst)
        begin
            warning <= 0;
            player1_board <= 0;
            player2_board <= 0;
            active_move <= 0;
            finished_move <= 0;
            rows_counter <= 0;
            columns_counter <= 0;
        end
        else
        begin
            warning <= warning_nxt;
            player1_board <= player1_board_nxt;
            player2_board <= player2_board_nxt;
            active_move <= active_move_nxt;
            finished_move <= finished_move_nxt;
            rows_counter <= rows_counter_nxt;
            columns_counter <= columns_counter_nxt;
        end
    end  
    
    always @*
    begin
        warning_nxt = warning;
        active_player_nxt = active_player;
        player1_board_nxt = player1_board;
        player2_board_nxt = player2_board;
        active_move_nxt = active_move;        
        finished_move_nxt = 0;
        rows_counter_nxt = rows_counter;
        columns_counter_nxt = columns_counter;
        case(program_state)
            IDLE:
            begin
                player1_board_nxt = 0;
                player2_board_nxt = 0;
            end
            PLACING_SHIPS:
            begin
                warning_nxt = 0;
                player1_board_nxt = 0;
                player2_board_nxt = 0;
                active_move_nxt = 1;
            end            
            FINDING_SHIPS:
            begin     
                if(warning)
                begin
                    if(mouse_right_tick) // trzeba nacisn¹æ prawy przycisk ¿eby wyjœæ ze stanu b³êdu
                        warning_nxt = 0;
                    else
                        warning_nxt = 1;
                end
                else
                begin
                    if(active_move)
                    begin
                        if(mouse_left_tick) // jeœli nacisneliœmy lewy przycisk myszy to sprawdzamy pozycjê myszki
                        begin
                            if((mouse_xpos >= BOARD_XPOS) && (mouse_xpos < BOARD_XPOS+SQUARE_SIZE*board_size) && (mouse_ypos >= BOARD_YPOS) && (mouse_ypos < BOARD_YPOS+SQUARE_SIZE*board_size))
                            begin // jeœli to by³o na planszy to sprawdzamy czy statek mo¿e zostaæ po³o¿ony na zaznaczonych polach
                                rows_counter_nxt = (mouse_xpos-BOARD_XPOS)/SQUARE_SIZE;
                                columns_counter_nxt = (mouse_ypos-BOARD_YPOS)/SQUARE_SIZE;
                                if(active_player)
                                begin
                                    if(player2_board[rows_counter_nxt+8*columns_counter_nxt] == 0)
                                    begin
                                        player2_board_nxt[rows_counter_nxt+8*columns_counter_nxt] = 1;
                                        active_move_nxt = 0;
                                    end
                                    else
                                        warning_nxt = 1;
                                end
                                else
                                begin
                                    if(player1_board[rows_counter_nxt+8*columns_counter_nxt] == 0)
                                    begin
                                        player1_board_nxt[rows_counter_nxt+8*columns_counter_nxt] = 1;
                                        active_move_nxt = 0;
                                    end
                                    else
                                        warning_nxt = 1;
                                end
                            end 
                        end
                    end
                    else
                    begin
                        if(mouse_right_tick)
                        begin
                            finished_move_nxt = 1;
                            active_move_nxt = 1;
                        end
                    end                              
                end
            end
            default:
            begin
                ///
            end      
        endcase
    end
      
endmodule
