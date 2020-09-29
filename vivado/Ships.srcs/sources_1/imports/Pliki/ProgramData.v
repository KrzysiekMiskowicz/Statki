`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Module Name: ProgramData
// Project Name: Statki
// Description: Modu³ ma za zadanie byæ "procesorem" programu. Jako sygna³y wejœciowe otrzymuje przyciski z p³ytki oraz myszkê. Na ich podstawie
// wyznacza stan do którego bêdzie przechodzi³ program.
//////////////////////////////////////////////////////////////////////////////////


module ProgramData(
    input wire clk,
    input wire rst,
    input wire play_game, 
    input wire [11:0] mouse_xpos,
    input wire [11:0] mouse_ypos,
    input wire mouse_left_tick,
    input wire mouse_right_tick, 
    input wire uart_data_enable_in,
    input wire [7:0] uart_data_in,
    input wire finished_move_placing,
    input wire finished_move_finding,
    input wire [63:0] player1_placing_board,
    input wire [63:0] player2_placing_board,
    input wire [3:0] finding_rows_counter,
    input wire [3:0] finding_columns_counter,
    input wire active_move_finding,
    input wire place_ships_warning,
    input wire find_ships_warning,
    output reg warning,
    output reg [3:0] program_state,
    output reg active_player,
    output reg [3:0] board_size,
    output reg uart_data_enable_out,
    output reg [7:0] uart_data_out,
    output reg [3:0] uart_data_counter,
    output reg [11:0] max_mouse_value,
    output reg mouse_ctrl,
    output reg hit_ship,
    output reg [4:0] hit_ships1,
    output reg [4:0] hit_ships2,
    output reg [4:0] ships_to_hit
    );

    // program states
    localparam IDLE = 4'b0000;
    localparam CHOSING_BOARD_SIZE = 4'b0001;
    localparam CHOSING_PLAYERS = 4'b0010;
    localparam PLACING_SHIPS = 4'b0011;
    localparam FINDING_SHIPS = 4'b0100;
    localparam SCREEN_BLANKING = 4'b0101;
    localparam GAME_ENDING = 4'b0110;
 
    // FINDING_SHIPS states
    localparam ACTIVE = 2'b00;
    localparam CHECKING = 2'b01;
    localparam WAITING = 2'b10;
       
    // buttons to choose board size
    localparam CHOOSING_SIZE_BUTTONS_WIDTH = 200;
    localparam CHOOSING_SIZE_BUTTONS_LENGTH = 100;
    localparam CHOOSING_SIZE_BUTTONS_YPOS = 250;
    localparam CHOOSING_SIZE_BUTTON1_XPOS = 50; 
    localparam CHOOSING_SIZE_BUTTON2_XPOS = 300;
    localparam CHOOSING_SIZE_BUTTON3_XPOS = 550; 
    

    reg [11:0] max_mouse_value_nxt;
    reg mouse_ctrl_nxt, uart_backspace, uart_backspace_nxt, from_blank_to_place_ships, from_blank_to_place_ships_nxt;    
    reg [7:0] uart_data_out_nxt;
    reg [4:0] hit_ships1_nxt, hit_ships2_nxt, ships_to_hit_nxt;
    reg [3:0] program_state_nxt, uart_data_counter_nxt;
    reg [3:0] board_size_nxt; // sygna³ informuj¹cy o rozmiarze planszy
    reg warning_nxt, uart_data_enable_out_nxt, active_player_nxt, hit_ship_nxt;
    reg [1:0] placing_ship_action_nxt, finding_ships_state, finding_ships_state_nxt;
    
    always @(posedge clk)
    begin
        if(rst)
        begin
            mouse_ctrl <= 0;
            max_mouse_value <= 0;
            program_state <= IDLE;
            warning <= 0;
            from_blank_to_place_ships <= 0;
            active_player <= 0;
            board_size <= 0;
            uart_data_enable_out <= 0;
            uart_data_out <= 0;
            uart_data_counter <= 0;
            uart_backspace <= 0;
            hit_ships1 <= 0;
            hit_ships2 <= 0;
            ships_to_hit <= 0;
            finding_ships_state <= 0;
            hit_ship <= 0;
        end
        else
        begin
            mouse_ctrl <= mouse_ctrl_nxt;
            max_mouse_value <= max_mouse_value_nxt;
            program_state <= program_state_nxt;
            warning <= warning_nxt;
            from_blank_to_place_ships <= from_blank_to_place_ships_nxt;
            active_player <= active_player_nxt;
            board_size <= board_size_nxt;
            uart_data_enable_out <= uart_data_enable_out_nxt;
            uart_data_out <= uart_data_out_nxt;
            uart_data_counter <= uart_data_counter_nxt;
            uart_backspace <= uart_backspace_nxt;
            hit_ships1 <= hit_ships1_nxt;
            hit_ships2 <= hit_ships2_nxt;
            ships_to_hit <= ships_to_hit_nxt;
            finding_ships_state <= finding_ships_state_nxt;
            hit_ship <= hit_ship_nxt;
        end
    end    
 
    always @*
    begin // ustawiamy domyœlne wartoœci dla wszystkich sygna³ów wyjœciowych
        mouse_ctrl_nxt = !mouse_ctrl; // sygna³y do kontroli myszki
        if(mouse_ctrl_nxt) // ustawia od maksymalne wartoœci xpos i ypos
            max_mouse_value_nxt = 595;
        else
            max_mouse_value_nxt = 798; 
        program_state_nxt = program_state;
        warning_nxt = warning;
        from_blank_to_place_ships_nxt = from_blank_to_place_ships;
        active_player_nxt = active_player;
        board_size_nxt = board_size;
        uart_data_enable_out_nxt = 0;
        uart_data_out_nxt = uart_data_in;
        uart_data_counter_nxt = uart_data_counter;
        uart_backspace_nxt = 0;
        hit_ships1_nxt = hit_ships1;
        hit_ships2_nxt = hit_ships2;
        ships_to_hit_nxt = ships_to_hit;
        finding_ships_state_nxt = finding_ships_state;
        hit_ship_nxt = hit_ship;
        if(!play_game) // nalezy wlaczyc swicha V17 aby rozpoczac gre
        begin
            program_state_nxt = IDLE; // jesteœmy w stanie IDLE, czekamy na przycisk
            warning_nxt = 0;
        end
        else
        begin          
            case(program_state) // wchodzimy do case'a w którym ustawiamy wiêkszoœæ sygna³ów w module 
                IDLE:
                begin
                    program_state_nxt = CHOSING_BOARD_SIZE; // przechodzimy do wybrania rozmiaru planszy
                    warning_nxt = 0;
                end
                CHOSING_BOARD_SIZE: // naciskamy przycisk aby wybrac wielkosc planszy
                begin
                    if(warning) // jesli wcisnelismy zle 
                    begin
                        uart_data_counter_nxt = 0;
                        program_state_nxt = CHOSING_BOARD_SIZE;
                        if(mouse_right_tick) // to trzeba nacisnac prawy przycisk myszy aby wybrac wielkosc planszy ponownie
                        begin
                            board_size_nxt = 0;
                            warning_nxt = 0;
                        end
                        else // w przeciwnym razie utkniemy w programie
                        begin
                            board_size_nxt = 0;
                            warning_nxt = 1;
                        end
                    end
                    else
                    begin
                        active_player_nxt = 0;
                        hit_ships1_nxt = 0;
                        hit_ships2_nxt = 0;
                        if(mouse_left_tick) // sprawdzamy czy nacisnelismy odpowiedni przycisk na ekranie
                        begin
                            if((mouse_ypos >= CHOOSING_SIZE_BUTTONS_YPOS) && (mouse_ypos < CHOOSING_SIZE_BUTTONS_YPOS+CHOOSING_SIZE_BUTTONS_LENGTH) && (mouse_xpos >= CHOOSING_SIZE_BUTTON1_XPOS) && (mouse_xpos < CHOOSING_SIZE_BUTTON1_XPOS+CHOOSING_SIZE_BUTTONS_WIDTH)) 
                            begin // wybranie planszy = 6
                                ships_to_hit_nxt = 17;
                                board_size_nxt = 6;
                                warning_nxt = 0;
                                program_state_nxt = CHOSING_PLAYERS;
                            end
                            else if((mouse_ypos >= CHOOSING_SIZE_BUTTONS_YPOS) && (mouse_ypos < CHOOSING_SIZE_BUTTONS_YPOS+CHOOSING_SIZE_BUTTONS_LENGTH) && (mouse_xpos >= CHOOSING_SIZE_BUTTON2_XPOS) && (mouse_xpos < CHOOSING_SIZE_BUTTON2_XPOS+CHOOSING_SIZE_BUTTONS_WIDTH)) 
                            begin // wybranie planszy = 7
                                ships_to_hit_nxt = 22;
                                board_size_nxt = 7;
                                warning_nxt = 0;
                                program_state_nxt = CHOSING_PLAYERS;
                            end
                            else if((mouse_ypos >= CHOOSING_SIZE_BUTTONS_YPOS) && (mouse_ypos < CHOOSING_SIZE_BUTTONS_YPOS+CHOOSING_SIZE_BUTTONS_LENGTH) && (mouse_xpos >= CHOOSING_SIZE_BUTTON3_XPOS) && (mouse_xpos < CHOOSING_SIZE_BUTTON3_XPOS+CHOOSING_SIZE_BUTTONS_WIDTH)) 
                            begin // wybranie planszy = 8
                                ships_to_hit_nxt = 29;
                                board_size_nxt = 8;
                                warning_nxt = 0;
                                program_state_nxt = CHOSING_PLAYERS;                              
                            end 
                            else // zly przycisk, przechodzimy do stanu bledu
                            begin
                                board_size_nxt = 0;
                                warning_nxt = 1;
                                program_state_nxt = CHOSING_BOARD_SIZE;
                            end
                        end
                        else // gracz nie wykona³ ¿adnej akcji 
                        begin
                            board_size_nxt = 0;
                            warning_nxt = 0;
                            program_state_nxt = CHOSING_BOARD_SIZE;                           
                        end
                    end
                end
                CHOSING_PLAYERS: // wybieramy nazwê dla graczy
                begin
                    from_blank_to_place_ships_nxt = 1;
                    if(uart_data_enable_in) // dostajemy informacje o sygnale z uarta
                    begin
                        if(uart_data_in == 8) // wpisaliœmy backspace
                        begin
                            if(uart_data_counter == 0)
                                uart_data_counter_nxt = 1;
                            else
                                uart_data_counter_nxt = uart_data_counter;
                            uart_data_enable_out_nxt = 1;
                            uart_data_out_nxt = 0;
                            uart_backspace_nxt = 1;
                        end
                        else
                        begin
                            uart_backspace_nxt = 0;
                            if(uart_data_counter == 15) // jeœli licznik danych jest ustawiony na wartoœæ 15
                            begin
                                uart_data_counter_nxt = 0;
                                uart_data_enable_out_nxt = 1;
                                if(active_player) // to w zale¿noœci od tego czy otrzymywaliœmy znaki od pierwszego czy drugiego gracza
                                begin
                                    program_state_nxt = SCREEN_BLANKING; // przechodzimy do umieszczania statków (jeœli poprzednie znaki pochodzi³y od 2 gracza)
                                    active_player_nxt = 0;
                                end
                                else
                                begin
                                    program_state_nxt = CHOSING_PLAYERS; // przechodzimy do wysy³ania imienia dla drugiego gracza (jeœli poprzednie znaki pochodzi³y od 1 gracza)
                                    active_player_nxt = 1;
                                end
                            end
                            else
                            begin
                                if(uart_data_in == 13) // jeœli otrzyamliœmy enter to zachowujemy siê analogicznie jakbyœmy otrzymali ostatni znak imienia
                                begin
                                    uart_data_counter_nxt = 0;
                                    uart_data_enable_out_nxt = 0;
                                    if(active_player)
                                    begin
                                        program_state_nxt = SCREEN_BLANKING;
                                        active_player_nxt = 0;
                                    end
                                    else
                                    begin
                                        program_state_nxt = CHOSING_PLAYERS;
                                    active_player_nxt = 1;
                                    end 
                                end
                                else
                                begin
                                    uart_data_counter_nxt = uart_data_counter+1;
                                    uart_data_enable_out_nxt = 1;
                                    active_player_nxt = active_player;
                                    program_state_nxt = CHOSING_PLAYERS;
                                end
                            end
                        end 
                    end
                    else // gracz nie wykona³ ¿adnej akcji
                    begin
                        if(uart_backspace == 1)
                            uart_data_counter_nxt = uart_data_counter-1;
                        else
                            uart_data_counter_nxt = uart_data_counter;
                        uart_data_enable_out_nxt = 0;
                        active_player_nxt = active_player;
                        program_state_nxt = CHOSING_PLAYERS;
                    end    
                end
                PLACING_SHIPS:
                begin
                    warning_nxt = place_ships_warning;
                    if(finished_move_placing)
                    begin
                        program_state_nxt = SCREEN_BLANKING;
                        if(active_player)
                        begin
                            from_blank_to_place_ships_nxt  = 0;
                            active_player_nxt = 0;
                        end
                        else
                        begin
                            from_blank_to_place_ships_nxt = 1;
                            active_player_nxt = 1;
                        end
                    end
                    else
                    begin
                        program_state_nxt = PLACING_SHIPS;
                        from_blank_to_place_ships_nxt = 1;
                    end
                end             
                SCREEN_BLANKING:
                begin
                    finding_ships_state_nxt = ACTIVE;
                    if((uart_data_enable_in == 1) && (uart_data_in == 13)) // naciœniêcie enteru
                    begin
                        if(from_blank_to_place_ships) 
                            program_state_nxt = PLACING_SHIPS;
                        else
                            program_state_nxt = FINDING_SHIPS;
                    end
                    else
                        program_state_nxt = SCREEN_BLANKING;
                end

                FINDING_SHIPS:
                begin
                    warning_nxt = find_ships_warning;
                    case(finding_ships_state)
                        ACTIVE:
                        begin
                            hit_ship_nxt = 0;
                            if(active_move_finding)
                                finding_ships_state_nxt = ACTIVE;
                            else
                                finding_ships_state_nxt = CHECKING;             
                        end
                        CHECKING:
                        begin
                            finding_ships_state_nxt = WAITING; 
                            if(active_player)
                            begin
                                if(player1_placing_board[finding_rows_counter+8*finding_columns_counter] == 1)
                                begin
                                    hit_ships2_nxt = hit_ships2+1;
                                    hit_ship_nxt = 1;
                                end                                                                            
                            end
                            else
                            begin
                                if(player2_placing_board[finding_rows_counter+8*finding_columns_counter] == 1)
                                begin
                                    hit_ships1_nxt = hit_ships1+1;
                                    hit_ship_nxt = 1;
                                end
                            end
                        end
                        WAITING:
                        begin
                            if(active_player)
                            begin
                                if(ships_to_hit == hit_ships2)
                                    program_state_nxt = GAME_ENDING;
                                else
                                begin
                                    if(finished_move_finding)
                                    begin
                                        program_state_nxt = SCREEN_BLANKING;
                                        finding_ships_state_nxt = ACTIVE;
                                        active_player_nxt = 0;
                                    end
                                    else
                                    begin
                                        program_state_nxt = FINDING_SHIPS;
                                        finding_ships_state_nxt = WAITING;                                     
                                    end
                                end 
                            end
                            else
                            begin
                                if(ships_to_hit == hit_ships1)
                                    program_state_nxt = GAME_ENDING;
                                else
                                begin
                                    if(finished_move_finding)
                                    begin
                                        program_state_nxt = SCREEN_BLANKING;
                                        finding_ships_state_nxt = ACTIVE;
                                        active_player_nxt = 1;
                                    end
                                    else
                                    begin
                                        program_state_nxt = FINDING_SHIPS;
                                        finding_ships_state_nxt = WAITING;                                     
                                    end
                                end 
                            end
                        end
                        default:
                            finding_ships_state_nxt = ACTIVE;
                    endcase   
                end
            endcase
        end
    end
endmodule
