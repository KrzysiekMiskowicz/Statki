`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Module Name: place_ships
// Project Name: Statki
// Description: Modu³ odpowiada za umiejscowienie statków na planszy
//////////////////////////////////////////////////////////////////////////////////


module place_ships(
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
    output reg [2:0] players_ships1x,
    output reg [2:0] players_ships2x,
    output reg [2:0] players_ships3x,
    output reg [2:0] players_ships4x,
    output reg [2:0] players_ships5x,
    output reg [1:0] place_ship_state,
    output reg [2:0] clicked_ship,
    output reg [63:0] player1_board, 
    output reg [63:0] player2_board,
    output reg finished_move
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
    localparam SHIPS_INTERSPACE = 10;
    localparam SHIP_5X_XPOS = 10;
    localparam SHIP_4X_XPOS = SHIP_5X_XPOS+SQUARE_SIZE+SHIPS_INTERSPACE;
    localparam SHIP_3X_XPOS = SHIP_4X_XPOS+SQUARE_SIZE+SHIPS_INTERSPACE;
    localparam SHIP_2X_XPOS = SHIP_3X_XPOS+SQUARE_SIZE+SHIPS_INTERSPACE;
    localparam SHIP_1X_XPOS = SHIP_2X_XPOS+SQUARE_SIZE+SHIPS_INTERSPACE;
    localparam SHIPS_YPOS = 580;
    
    // place_ship_state (sposoby na jakie mo¿na umieœciæ statki na planszy)
    localparam NO_ACTION = 2'b00;
    localparam VERTICAL = 2'b10;
    localparam HORIZONTAL = 2'b11;
    
    integer rows_counter, columns_counter;
    
    reg last_left_tick, last_left_tick_nxt, last_right_tick, last_right_tick_nxt, warning_nxt, finished_move_nxt;
    reg [1:0] place_ship_state_nxt;
    reg [2:0] players_ships1x_nxt, players_ships2x_nxt, players_ships3x_nxt, players_ships4x_nxt, players_ships5x_nxt, clicked_ship_nxt;  
    reg [63:0] player1_board_nxt, player2_board_nxt;    
    
    always @(posedge clk)
    begin
        if(rst)
        begin
            warning <= 0;
            last_left_tick <= 0;
            last_right_tick <= 0;
            players_ships1x <= 0;
            players_ships2x <= 0;
            players_ships3x <= 0;
            players_ships4x <= 0;
            players_ships5x <= 0;
            place_ship_state <= 0;
            clicked_ship <= 0;
            player1_board <= 0;
            player2_board <= 0;
            finished_move <= 0;
        end
        else
        begin
            warning <= warning_nxt;
            last_left_tick <= last_left_tick_nxt;
            last_right_tick <= last_right_tick_nxt;
            players_ships1x <= players_ships1x_nxt;
            players_ships2x <= players_ships2x_nxt;
            players_ships3x <= players_ships3x_nxt;
            players_ships4x <= players_ships4x_nxt;
            players_ships5x <= players_ships5x_nxt;
            place_ship_state <= place_ship_state_nxt;
            clicked_ship <= clicked_ship_nxt;
            player1_board <= player1_board_nxt;
            player2_board <= player2_board_nxt;
            finished_move <= finished_move_nxt;
        end
    end  
    
    always @*
    begin
        warning_nxt = warning;
        last_left_tick_nxt = mouse_left_tick;
        last_right_tick_nxt = mouse_right_tick;
        players_ships1x_nxt = players_ships1x;
        players_ships2x_nxt = players_ships2x;
        players_ships3x_nxt = players_ships3x;
        players_ships4x_nxt = players_ships4x;
        players_ships5x_nxt = players_ships5x;
        place_ship_state_nxt = place_ship_state;
        clicked_ship_nxt = clicked_ship;
        player1_board_nxt = player1_board;
        player2_board_nxt = player2_board;
        finished_move_nxt = finished_move;        
        
        case(program_state)
            IDLE:
            begin
                player1_board_nxt = 0;
                player2_board_nxt = 0;
            end
            CHOSING_PLAYERS:
            begin
                warning_nxt = 0;
                case(board_size)
                    6:
                    begin
                        players_ships1x_nxt = 3;
                        players_ships2x_nxt = 2;
                        players_ships3x_nxt = 2;
                        players_ships4x_nxt = 1;
                        players_ships5x_nxt = 0; 
                    end
                    7:
                    begin
                        players_ships1x_nxt = 3;
                        players_ships2x_nxt = 2;
                        players_ships3x_nxt = 2;
                        players_ships4x_nxt = 1;
                        players_ships5x_nxt = 1;                     
                    end
                    8:
                    begin
                        players_ships1x_nxt = 4;
                        players_ships2x_nxt = 3;
                        players_ships3x_nxt = 2;
                        players_ships4x_nxt = 2;
                        players_ships5x_nxt = 1;                     
                    end
                    default:
                    begin
                        players_ships1x_nxt = 0;
                        players_ships2x_nxt = 0;
                        players_ships3x_nxt = 0;
                        players_ships4x_nxt = 0;
                        players_ships5x_nxt = 0;                                         
                    end                
                endcase
                place_ship_state_nxt = place_ship_state;
                clicked_ship_nxt = clicked_ship;
                player1_board_nxt = 64'b0;
                player2_board_nxt = 64'b0;    
                finished_move_nxt = 0;
            end                 
            PLACING_SHIPS:
            begin                    
                if(warning) // chcieliœmy po³o¿yæ statek na planszy w nieodpowiednim miejscu (by³o zajête albo poza plansz¹) 
                begin
                    place_ship_state_nxt = NO_ACTION;
                    clicked_ship_nxt = 0;     
                    if(mouse_right_tick) // trzeba nacisn¹æ prawy przycisk ¿eby wyjœæ ze stanu b³êdu
                    begin
                        warning_nxt = 0;                           
                    end
                    else
                    begin
                        warning_nxt = 1;
                    end
                end
                else
                begin
                    case(place_ship_state)
                        VERTICAL:  // mamy przygotwany statek do naciœniêcia 
                        begin
                            if((mouse_right_tick == 1) && (last_right_tick == 0)) // jeœli naciœniemy prawy przycisk to zmieniamy jego sposób ustawienia (z wertkalnego na horyzontalny w tym wypadku)
                            begin
                                finished_move_nxt = 0;
                                place_ship_state_nxt = HORIZONTAL;
                                warning_nxt = 0;
                            end
                            else if(mouse_left_tick) // jeœli nacisneliœmy lewy przycisk myszy to sprawdzamy pozycjê myszki
                            begin
                                if((mouse_xpos >= BOARD_XPOS) && (mouse_xpos < BOARD_XPOS+SQUARE_SIZE*board_size) && (mouse_ypos >= BOARD_YPOS) && (mouse_ypos < BOARD_YPOS+SQUARE_SIZE*board_size))
                                begin // jeœli to by³o na planszy to sprawdzamy czy statek mo¿e zostaæ po³o¿ony na zaznaczonych polach
                                    rows_counter = (mouse_xpos-BOARD_XPOS)/SQUARE_SIZE;
                                    columns_counter = (mouse_ypos-BOARD_YPOS)/SQUARE_SIZE;
                                    finished_move_nxt = 0;
                                    place_ship_state_nxt = NO_ACTION;
                                    if(active_player)
                                    begin
                                        case(clicked_ship) // 
                                            3'b001: // 1
                                            begin
                                                if((player2_board[rows_counter+8*columns_counter] == 0) && (rows_counter < board_size) && (columns_counter < board_size))
                                                begin
                                                    players_ships1x_nxt = players_ships1x-1;
                                                    warning_nxt = 0;
                                                    player2_board_nxt[rows_counter+8*columns_counter] = 1;
                                                end
                                                else
                                                begin
                                                    warning_nxt = 1;        
                                                end
                                            end
                                            3'b010: // 2
                                            begin
                                                if(({player2_board[rows_counter+8*columns_counter], player2_board[rows_counter+8*(columns_counter+1)]} == 0) && (rows_counter < board_size) && (columns_counter+1 < board_size))
                                                begin
                                                    players_ships2x_nxt = players_ships2x-1;
                                                    warning_nxt = 0;
                                                    player2_board_nxt[rows_counter+8*columns_counter] = 1;
                                                    player2_board_nxt[rows_counter+8*(columns_counter+1)] = 1;
                                                end
                                                else
                                                begin
                                                    warning_nxt = 1;        
                                                end
                                            end    
                                            3'b011: // 3
                                            begin
                                                if(({player2_board[rows_counter+8*columns_counter], player2_board[rows_counter+8*(columns_counter+1)], player2_board[rows_counter+8*(columns_counter+2)]} == 0) && (rows_counter < board_size) && (columns_counter+2 < board_size))
                                                begin
                                                    players_ships3x_nxt = players_ships3x-1;
                                                    warning_nxt = 0;
                                                    player2_board_nxt[rows_counter+8*columns_counter] = 1;
                                                    player2_board_nxt[rows_counter+8*(columns_counter+1)] = 1;
                                                    player2_board_nxt[rows_counter+8*(columns_counter+2)] = 1;
                                                end
                                                else
                                                begin
                                                    warning_nxt = 1;        
                                                end
                                            end       
                                            3'b100: // 4
                                            begin
                                                if(({player2_board[rows_counter+8*columns_counter], player2_board[rows_counter+8*(columns_counter+1)], player2_board[rows_counter+8*(columns_counter+2)], player2_board[rows_counter+8*(columns_counter+3)]} == 0) && (rows_counter < board_size) && (columns_counter+3 < board_size))
                                                begin
                                                    players_ships4x_nxt = players_ships4x-1;
                                                    warning_nxt = 0;
                                                    player2_board_nxt[rows_counter+8*columns_counter] = 1;
                                                    player2_board_nxt[rows_counter+8*(columns_counter+1)] = 1;
                                                    player2_board_nxt[rows_counter+8*(columns_counter+2)] = 1;
                                                    player2_board_nxt[rows_counter+8*(columns_counter+3)] = 1;
                                                end
                                                else
                                                begin
                                                    warning_nxt = 1;        
                                                end
                                            end
                                            3'b101: // 5
                                            begin
                                                if(({player2_board[rows_counter+8*columns_counter], player2_board[rows_counter+8*(columns_counter+1)], player2_board[rows_counter+8*(columns_counter+2)], player2_board[rows_counter+8*(columns_counter+3)], player2_board[rows_counter+8*(columns_counter+4)]} == 0) && (rows_counter < board_size) && (columns_counter+4 < board_size))
                                                begin
                                                    players_ships5x_nxt = players_ships5x-1;
                                                    warning_nxt = 0;
                                                    player2_board_nxt[rows_counter+8*columns_counter] = 1;
                                                    player2_board_nxt[rows_counter+8*(columns_counter+1)] = 1;
                                                    player2_board_nxt[rows_counter+8*(columns_counter+2)] = 1;
                                                    player2_board_nxt[rows_counter+8*(columns_counter+3)] = 1;
                                                    player2_board_nxt[rows_counter+8*(columns_counter+4)] = 1;
                                                end
                                                else
                                                begin
                                                    warning_nxt = 1;        
                                                end
                                            end                              
                                        endcase
                                    end
                                    else
                                    begin
                                        case(clicked_ship)
                                            3'b001: // 1
                                            begin
                                                if((player1_board[rows_counter+8*columns_counter] == 0) && (rows_counter < board_size) && (columns_counter < board_size))
                                                begin
                                                    players_ships1x_nxt = players_ships1x-1;
                                                    warning_nxt = 0;
                                                    player1_board_nxt[rows_counter+8*columns_counter] = 1;
                                                end
                                                else
                                                begin
                                                    warning_nxt = 1;        
                                                end
                                            end
                                            3'b010: // 2
                                            begin
                                                if(({player1_board[rows_counter+8*columns_counter], player1_board[rows_counter+8*(columns_counter+1)]} == 0) && (rows_counter < board_size) && (columns_counter+1 < board_size))
                                                begin
                                                    players_ships2x_nxt = players_ships2x-1;
                                                    warning_nxt = 0;
                                                    player1_board_nxt[rows_counter+8*columns_counter] = 1;
                                                    player1_board_nxt[rows_counter+8*(columns_counter+1)] = 1;
                                                end 
                                                else
                                                begin
                                                    warning_nxt = 1;        
                                                end
                                            end    
                                            3'b011: // 3
                                            begin
                                                if(({player1_board[rows_counter+8*columns_counter], player1_board[rows_counter+8*(columns_counter+1)], player1_board[rows_counter+8*(columns_counter+2)]} == 0) && (rows_counter < board_size) && (columns_counter+2 < board_size))
                                                begin
                                                    players_ships3x_nxt = players_ships3x-1;
                                                    warning_nxt = 0;
                                                    player1_board_nxt[rows_counter+8*columns_counter] = 1;
                                                    player1_board_nxt[rows_counter+8*(columns_counter+1)] = 1;
                                                    player1_board_nxt[rows_counter+8*(columns_counter+2)] = 1;
                                                end
                                                else
                                                begin
                                                    warning_nxt = 1;        
                                                end
                                            end       
                                            3'b100: // 4
                                            begin
                                                if(({player1_board[rows_counter+8*columns_counter], player1_board[rows_counter+8*(columns_counter+1)], player1_board[rows_counter+8*(columns_counter+2)], player1_board[rows_counter+8*(columns_counter+3)]} == 0) && (rows_counter < board_size) && (columns_counter+3 < board_size))
                                                begin
                                                    players_ships4x_nxt = players_ships4x-1;
                                                    warning_nxt = 0;
                                                    player1_board_nxt[rows_counter+8*columns_counter] = 1;
                                                    player1_board_nxt[rows_counter+8*(columns_counter+1)] = 1;
                                                    player1_board_nxt[rows_counter+8*(columns_counter+2)] = 1;
                                                    player1_board_nxt[rows_counter+8*(columns_counter+3)] = 1;
                                                end
                                                else
                                                begin
                                                     warning_nxt = 1;        
                                                end
                                            end
                                            3'b101: // 5
                                            begin
                                                if(({player1_board[rows_counter+8*columns_counter], player1_board[rows_counter+8*(columns_counter+1)], player1_board[rows_counter+8*(columns_counter+2)], player1_board[rows_counter+8*(columns_counter+3)], player1_board[rows_counter+8*(columns_counter+4)]} == 0) && (rows_counter < board_size) && (columns_counter+4 < board_size))
                                                begin
                                                    players_ships5x_nxt = players_ships5x-1;
                                                    warning_nxt = 0;
                                                    player1_board_nxt[rows_counter+8*columns_counter] = 1;
                                                    player1_board_nxt[rows_counter+8*(columns_counter+1)] = 1;
                                                    player1_board_nxt[rows_counter+8*(columns_counter+2)] = 1;
                                                    player1_board_nxt[rows_counter+8*(columns_counter+3)] = 1;
                                                    player1_board_nxt[rows_counter+8*(columns_counter+4)] = 1;
                                                end
                                                else
                                                begin
                                                    warning_nxt = 1;        
                                                end
                                            end                              
                                            endcase
                                        end
                                    end
                                    ///// else ify zapobiegaj¹ prze³¹czaniu siê zaznaczonego statku
                                    else if((mouse_xpos >= SHIP_5X_XPOS) && (mouse_xpos < SHIP_5X_XPOS+SQUARE_SIZE) && (mouse_ypos >= SHIPS_YPOS-5*SQUARE_SIZE) && (mouse_ypos < SHIPS_YPOS) && (players_ships5x != 0))
                                    begin
                                        clicked_ship_nxt = 5;
                                        place_ship_state_nxt = VERTICAL;
                                        warning_nxt = 0;  
                                    end
                                    else if((mouse_xpos >= SHIP_4X_XPOS) && (mouse_xpos < SHIP_4X_XPOS+SQUARE_SIZE) && (mouse_ypos >= SHIPS_YPOS-4*SQUARE_SIZE) && (mouse_ypos < SHIPS_YPOS) && (players_ships4x != 0))
                                    begin
                                        clicked_ship_nxt = 4;
                                        place_ship_state_nxt = VERTICAL;
                                        warning_nxt = 0;  
                                    end
                                    else if((mouse_xpos >= SHIP_3X_XPOS) && (mouse_xpos < SHIP_3X_XPOS+SQUARE_SIZE) && (mouse_ypos >= SHIPS_YPOS-3*SQUARE_SIZE) && (mouse_ypos < SHIPS_YPOS) && (players_ships3x != 0))
                                    begin
                                        clicked_ship_nxt = 3;
                                        place_ship_state_nxt = VERTICAL;
                                        warning_nxt = 0;  
                                    end
                                    else if((mouse_xpos >= SHIP_2X_XPOS) && (mouse_xpos < SHIP_2X_XPOS+SQUARE_SIZE) && (mouse_ypos >= SHIPS_YPOS-2*SQUARE_SIZE) && (mouse_ypos < SHIPS_YPOS) && (players_ships2x != 0))
                                    begin
                                        clicked_ship_nxt = 2;
                                        place_ship_state_nxt = VERTICAL;
                                        warning_nxt = 0;  
                                    end
                                    else if((mouse_xpos >= SHIP_1X_XPOS) && (mouse_xpos < SHIP_1X_XPOS+SQUARE_SIZE) && (mouse_ypos >= SHIPS_YPOS-SQUARE_SIZE) && (mouse_ypos < SHIPS_YPOS) && (players_ships1x != 0)) 
                                    begin
                                        clicked_ship_nxt = 1;
                                        place_ship_state_nxt = VERTICAL;
                                        warning_nxt = 0;  
                                    end                        
                                ///  
                                else
                                begin
                                    finished_move_nxt = 0;
                                    place_ship_state_nxt = NO_ACTION;
                                    warning_nxt = 0;                                    
                                end
                            end
                            else
                            begin
                                finished_move_nxt = 0;
                                place_ship_state_nxt = VERTICAL;
                                warning_nxt = 0;
                            end
                        end
                        HORIZONTAL:  // mamy przygotwany statek do naciœniêcia 
                        begin
                            if((mouse_right_tick == 1) && (last_right_tick == 0)) // jeœli naciœniemy prawy przycisk to zmieniamy jego sposób ustawienia (z wertkalnego na horyzontalny w tym wypadku)
                            begin
                                finished_move_nxt = 0;
                                place_ship_state_nxt = VERTICAL;
                                warning_nxt = 0;
                            end
                            else if(mouse_left_tick) // jeœli nacisneliœmy lewy przycisk myszy to sprawdzamy pozycjê myszki
                            begin
                                if((mouse_xpos >= BOARD_XPOS) && (mouse_xpos < BOARD_XPOS+SQUARE_SIZE*board_size) && (mouse_ypos >= BOARD_YPOS) && (mouse_ypos < BOARD_YPOS+SQUARE_SIZE*board_size))
                                begin // jeœli to by³o na planszy to sprawdzamy czy statek mo¿e zostaæ po³o¿ony na zaznaczonych polach
                                    rows_counter = (mouse_xpos-BOARD_XPOS)/SQUARE_SIZE;
                                    columns_counter = (mouse_ypos-BOARD_YPOS)/SQUARE_SIZE;
                                    finished_move_nxt = 0;
                                    place_ship_state_nxt = NO_ACTION;
                                    if(active_player)
                                    begin
                                        case(clicked_ship) // 
                                            3'b001: // 1
                                            begin
                                                if((player2_board[rows_counter+8*columns_counter] == 0) && (rows_counter < board_size) && (columns_counter < board_size))
                                                begin
                                                    players_ships1x_nxt = players_ships1x-1;
                                                    warning_nxt = 0;
                                                    player2_board_nxt[rows_counter+8*columns_counter] = 1;
                                                end
                                                else
                                                begin
                                                    warning_nxt = 1;        
                                                end
                                            end
                                            3'b010: // 2
                                            begin
                                                if(({player2_board[rows_counter+8*columns_counter], player2_board[rows_counter+8*columns_counter+1]} == 0) && (rows_counter+1 < board_size) && (columns_counter < board_size))
                                                begin
                                                    players_ships2x_nxt = players_ships2x-1;
                                                    warning_nxt = 0;
                                                    player2_board_nxt[rows_counter+8*columns_counter] = 1;
                                                    player2_board_nxt[rows_counter+8*columns_counter+1] = 1;
                                                end
                                                else
                                                begin
                                                    warning_nxt = 1;        
                                                end
                                            end    
                                            3'b011: // 3
                                            begin
                                                if(({player2_board[rows_counter+8*columns_counter], player2_board[rows_counter+8*columns_counter+1], player2_board[rows_counter+8*columns_counter+2]} == 0) && (rows_counter+2 < board_size) && (columns_counter < board_size))
                                                begin
                                                    players_ships3x_nxt = players_ships3x-1;
                                                    warning_nxt = 0;
                                                    player2_board_nxt[rows_counter+8*columns_counter] = 1;
                                                    player2_board_nxt[rows_counter+8*columns_counter+1] = 1;
                                                    player2_board_nxt[rows_counter+8*columns_counter+2] = 1;
                                                end
                                                else
                                                begin
                                                    warning_nxt = 1;        
                                                end
                                            end       
                                            3'b100: // 4
                                            begin
                                                if(({player2_board[rows_counter+8*columns_counter], player2_board[rows_counter+8*columns_counter+1], player2_board[rows_counter+8*columns_counter+2], player2_board[rows_counter+8*columns_counter+3]} == 0) && (rows_counter+3 < board_size) && (columns_counter < board_size))
                                                begin
                                                    players_ships4x_nxt = players_ships4x-1;
                                                    warning_nxt = 0;
                                                    player2_board_nxt[rows_counter+8*columns_counter] = 1;
                                                    player2_board_nxt[rows_counter+8*columns_counter+1] = 1;
                                                    player2_board_nxt[rows_counter+8*columns_counter+2] = 1;
                                                    player2_board_nxt[rows_counter+8*columns_counter+3] = 1;
                                                end
                                                else
                                                begin
                                                    warning_nxt = 1;        
                                                end
                                            end
                                            3'b101: // 5
                                            begin
                                                if(({player2_board[rows_counter+8*columns_counter], player2_board[rows_counter+8*columns_counter+1], player2_board[rows_counter+8*columns_counter+2], player2_board[rows_counter+8*columns_counter+3], player2_board[rows_counter+8*columns_counter+4]} == 0) && (rows_counter+4 < board_size) && (columns_counter < board_size))
                                                begin
                                                    players_ships5x_nxt = players_ships5x-1;
                                                    warning_nxt = 0;
                                                    player2_board_nxt[rows_counter+8*columns_counter] = 1;
                                                    player2_board_nxt[rows_counter+8*columns_counter+1] = 1;
                                                    player2_board_nxt[rows_counter+8*columns_counter+2] = 1;
                                                    player2_board_nxt[rows_counter+8*columns_counter+3] = 1;
                                                    player2_board_nxt[rows_counter+8*columns_counter+4] = 1;
                                                end
                                                else
                                                begin
                                                    warning_nxt = 1;        
                                                end
                                            end                              
                                        endcase
                                    end
                                    else
                                    begin
                                        case(clicked_ship)
                                            3'b001: // 1
                                            begin
                                                if((player1_board[rows_counter+8*columns_counter] == 0) && (rows_counter < board_size) && (columns_counter < board_size))
                                                begin
                                                    players_ships1x_nxt = players_ships1x-1;
                                                    warning_nxt = 0;
                                                    player1_board_nxt[rows_counter+8*columns_counter] = 1;
                                                end
                                                else
                                                begin
                                                    warning_nxt = 1;        
                                                end
                                            end
                                            3'b010: // 2
                                            begin
                                                if(({player1_board[rows_counter+8*columns_counter], player1_board[rows_counter+8*columns_counter+1]} == 0) && (rows_counter+1 < board_size) && (columns_counter < board_size))
                                                begin
                                                    players_ships2x_nxt = players_ships2x-1;
                                                    warning_nxt = 0;
                                                    player1_board_nxt[rows_counter+8*columns_counter] = 1;
                                                    player1_board_nxt[rows_counter+8*columns_counter+1] = 1;
                                                end 
                                                else
                                                begin
                                                    warning_nxt = 1;        
                                                end
                                            end    
                                            3'b011: // 3
                                            begin
                                                if(({player1_board[rows_counter+8*columns_counter], player1_board[rows_counter+8*columns_counter+1], player1_board[rows_counter+8*columns_counter+2]} == 0) && (rows_counter+2 < board_size) && (columns_counter < board_size))
                                                begin
                                                    players_ships3x_nxt = players_ships3x-1;
                                                    warning_nxt = 0;
                                                    player1_board_nxt[rows_counter+8*columns_counter] = 1;
                                                    player1_board_nxt[rows_counter+8*columns_counter+1] = 1;
                                                    player1_board_nxt[rows_counter+8*columns_counter+2] = 1;
                                                end
                                                else
                                                begin
                                                    warning_nxt = 1;        
                                                end
                                            end       
                                            3'b100: // 4
                                            begin
                                                if(({player1_board[rows_counter+8*columns_counter], player1_board[rows_counter+8*columns_counter+1], player1_board[rows_counter+8*columns_counter+2], player1_board[rows_counter+8*columns_counter+3]} == 0) && (rows_counter+3 < board_size) && (columns_counter < board_size))
                                                begin
                                                    players_ships4x_nxt = players_ships4x-1;
                                                    warning_nxt = 0;
                                                    player1_board_nxt[rows_counter+8*columns_counter] = 1;
                                                    player1_board_nxt[rows_counter+8*columns_counter+1] = 1;
                                                    player1_board_nxt[rows_counter+8*columns_counter+2] = 1;
                                                    player1_board_nxt[rows_counter+8*columns_counter+3] = 1;
                                                end
                                                else
                                                begin
                                                     warning_nxt = 1;        
                                                end
                                            end
                                            3'b101: // 5
                                            begin
                                                if(({player1_board[rows_counter+8*columns_counter], player1_board[rows_counter+8*columns_counter+1], player1_board[rows_counter+8*columns_counter+2], player1_board[rows_counter+8*columns_counter+3], player1_board[rows_counter+8*columns_counter+4]} == 0) && (rows_counter+4 < board_size) && (columns_counter < board_size))
                                                begin
                                                    players_ships5x_nxt = players_ships5x-1;
                                                    warning_nxt = 0;
                                                    player1_board_nxt[rows_counter+8*columns_counter] = 1;
                                                    player1_board_nxt[rows_counter+8*columns_counter+1] = 1;
                                                    player1_board_nxt[rows_counter+8*columns_counter+2] = 1;
                                                    player1_board_nxt[rows_counter+8*columns_counter+3] = 1;
                                                    player1_board_nxt[rows_counter+8*columns_counter+4] = 1;
                                                end
                                                else
                                                begin
                                                    warning_nxt = 1;        
                                                end
                                            end                              
                                            endcase
                                        end
                                    end
                                else
                                begin
                                    finished_move_nxt = 0;
                                    place_ship_state_nxt = NO_ACTION;
                                    warning_nxt = 0;                                    
                                end
                            end
                            else
                            begin
                                finished_move_nxt = 0;
                                place_ship_state_nxt = HORIZONTAL;
                                warning_nxt = 0;
                            end
                        end                         
                        default:
                        begin
                           warning_nxt = 0;
                            if({players_ships1x, players_ships2x, players_ships3x, players_ships4x , players_ships5x} == 0)
                            begin
                                place_ship_state_nxt = NO_ACTION;
                                finished_move_nxt = 1;
                                case(board_size)
                                    4'b0110: // 6
                                    begin
                                        players_ships1x_nxt = 3;
                                        players_ships2x_nxt = 2;
                                        players_ships3x_nxt = 2;
                                        players_ships4x_nxt = 1;
                                        players_ships5x_nxt = 0;
                                    end
                                    4'b0111: // 7
                                    begin
                                        players_ships1x_nxt = 3;
                                        players_ships2x_nxt = 2;
                                        players_ships3x_nxt = 2;
                                        players_ships4x_nxt = 1;
                                        players_ships5x_nxt = 1;
                                    end
                                    4'b1000: // 8
                                    begin
                                        players_ships1x_nxt = 4;
                                        players_ships2x_nxt = 3;
                                        players_ships3x_nxt = 2;
                                        players_ships4x_nxt = 2;
                                        players_ships5x_nxt = 1;
                                    end
                                endcase
                            end
                            else
                            begin 
                                finished_move_nxt = 0; 
                                if(mouse_left_tick == 1) // if((mouse_left_tick == 1) && (last_left_tick == 0)) 
                                begin 
                                    if((mouse_xpos >= SHIP_5X_XPOS) && (mouse_xpos < SHIP_5X_XPOS+SQUARE_SIZE) && (mouse_ypos >= SHIPS_YPOS-5*SQUARE_SIZE) && (mouse_ypos < SHIPS_YPOS) && (players_ships5x != 0))
                                    begin
                                        clicked_ship_nxt = 5;
                                        place_ship_state_nxt = VERTICAL;
                                    end
                                    else if((mouse_xpos >= SHIP_4X_XPOS) && (mouse_xpos < SHIP_4X_XPOS+SQUARE_SIZE) && (mouse_ypos >= SHIPS_YPOS-4*SQUARE_SIZE) && (mouse_ypos < SHIPS_YPOS) && (players_ships4x != 0))
                                    begin
                                        clicked_ship_nxt = 4;
                                        place_ship_state_nxt = VERTICAL;
                                    end
                                    else if((mouse_xpos >= SHIP_3X_XPOS) && (mouse_xpos < SHIP_3X_XPOS+SQUARE_SIZE) && (mouse_ypos >= SHIPS_YPOS-3*SQUARE_SIZE) && (mouse_ypos < SHIPS_YPOS) && (players_ships3x != 0))
                                    begin
                                        clicked_ship_nxt = 3;
                                        place_ship_state_nxt = VERTICAL;
                                    end
                                    else if((mouse_xpos >= SHIP_2X_XPOS) && (mouse_xpos < SHIP_2X_XPOS+SQUARE_SIZE) && (mouse_ypos >= SHIPS_YPOS-2*SQUARE_SIZE) && (mouse_ypos < SHIPS_YPOS) && (players_ships2x != 0))
                                    begin
                                        clicked_ship_nxt = 2;
                                        place_ship_state_nxt = VERTICAL;
                                    end
                                    else if((mouse_xpos >= SHIP_1X_XPOS) && (mouse_xpos < SHIP_1X_XPOS+SQUARE_SIZE) && (mouse_ypos >= SHIPS_YPOS-SQUARE_SIZE) && (mouse_ypos < SHIPS_YPOS) && (players_ships1x != 0)) 
                                    begin
                                        clicked_ship_nxt = 1;
                                        place_ship_state_nxt = VERTICAL;
                                    end                     
                                    else
                                    begin
                                        clicked_ship_nxt = 0;
                                        place_ship_state_nxt = NO_ACTION;
                                    end       
                                end
                                else
                                begin
                                    clicked_ship_nxt = 0;
                                    place_ship_state_nxt = NO_ACTION;
                                end
                            end
                        end
                    endcase
                end                                  
            end            
            default:
            begin
                // Wszystkie przypisania zosta³y dokonane domyœlnie na pocztku bloku kombinacyjnego
            end      
        endcase
    end
      
endmodule
