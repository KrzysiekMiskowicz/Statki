`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Module Name: char_rom_16x16
// Project Name: Statki
// Description: Modu³ odpowiada za wybór odpowiedniej informacji do wyœwietlenia. Dokonuje tego na podstawie sygna³ z modu³u ProgramData
//////////////////////////////////////////////////////////////////////////////////

module char_rom_16x16(
    input wire clk,
    input wire rst,
    input wire [3:0] program_state,
    input wire warning,
    input wire active_player,
    input wire active_move_finding,
    input wire hit_ship,
    input wire [4:0] hit_ships1,
    input wire [4:0] hit_ships2,
    input wire [4:0] ships_to_hit,
    input wire player_name_character_enable,
    input wire [7:0] player_name_character,
    input wire [3:0] player_name_character_counter,
    input wire [7:0] char_xy,
    input wire [2:0] players_ships1x,
    input wire [2:0] players_ships2x,
    input wire [2:0] players_ships3x,
    input wire [2:0] players_ships4x,
    input wire [2:0] players_ships5x,
    output reg [6:0] char_code
    );

    // program states
    localparam IDLE = 4'b0000;
    localparam CHOSING_BOARD_SIZE = 4'b0001;
    localparam CHOSING_PLAYERS = 4'b0010;
    localparam PLACING_SHIPS = 4'b0011;
    localparam FINDING_SHIPS = 4'b0100;
    localparam SCREEN_BLANKING = 4'b0101;
    localparam GAME_ENDING = 4'b0110;
        
    localparam ZERO = 48;    
    localparam A = 65; 
    localparam B = 66; 
    localparam C = 67; 
    localparam D = 68; 
    localparam E = 69; 
    localparam F = 70; 
    localparam G = 71; 
    localparam H = 72; 
    localparam I = 73; 
    localparam J = 74; 
    localparam K = 75; 
    localparam L = 76;
    localparam M = 77; 
    localparam N = 78; 
    localparam O = 79; 
    localparam P = 80; 
    localparam Q = 81; 
    localparam R = 82;
    localparam S = 83; 
    localparam T = 84; 
    localparam U = 85; 
    localparam V = 86; 
    localparam W = 87; 
    localparam X = 88;
    localparam Y = 89; 
    localparam Z = 90; 
    localparam a = 97; 
    localparam b = 98; 
    localparam c = 99; 
    localparam d = 100; 
    localparam e = 101; 
    localparam f = 102; 
    localparam g = 103; 
    localparam h = 104; 
    localparam i = 105; 
    localparam j = 106; 
    localparam k = 107; 
    localparam l = 108;
    localparam m = 109; 
    localparam n = 110; 
    localparam o = 111; 
    localparam p = 112; 
    localparam q = 113; 
    localparam r = 114;
    localparam s = 115; 
    localparam t = 116; 
    localparam u = 117; 
    localparam v = 118; 
    localparam w = 119; 
    localparam x = 120;
    localparam y = 121; 
    localparam z = 122; 
           
    reg [6:0] char_code_nxt;
    reg [7:0] player1_name [15:0];
    reg [7:0] player1_name_nxt [15:0];
    reg [7:0] player2_name [15:0];
    reg [7:0] player2_name_nxt [15:0];
    integer memory_counter = 0;
    
    always @(posedge clk)
    begin
        if(rst)
        begin
            char_code <= 0;
            for(memory_counter = 0; memory_counter < 16; memory_counter=memory_counter+1)
            begin
                player1_name[memory_counter] <= 0;
                player2_name[memory_counter] <= 0;
            end  
        end
        else
        begin
            char_code <= char_code_nxt;
            for(memory_counter = 0; memory_counter < 16; memory_counter=memory_counter+1)
            begin
                player1_name[memory_counter] <= player1_name_nxt[memory_counter];
                player2_name[memory_counter] <= player2_name_nxt[memory_counter];
            end 
        end
    end
    
    always @*
    begin
    for(memory_counter = 0; memory_counter < 16; memory_counter=memory_counter+1)
    begin
        player1_name_nxt[memory_counter] = player1_name[memory_counter];
        player2_name_nxt[memory_counter] = player2_name[memory_counter];
    end 
        char_code_nxt = 0;
        if(player_name_character_enable)
        begin
            if(active_player)
            begin
                player1_name_nxt[player_name_character_counter] = player1_name[player_name_character_counter];
                player2_name_nxt[player_name_character_counter] = player_name_character;
            end
            else
            begin
                player1_name_nxt[player_name_character_counter] = player_name_character;
                player2_name_nxt[player_name_character_counter] = player2_name[player_name_character_counter]; 
            end
        end
        case(program_state)
            IDLE:
            begin
                case(char_xy) // To start a game turn on switch V17
                    8'h00: char_code_nxt = T;
                    8'h10: char_code_nxt = o;  
                    8'h30: char_code_nxt = s;
                    8'h40: char_code_nxt = t;
                    8'h50: char_code_nxt = a;
                    8'h60: char_code_nxt = r;
                    8'h70: char_code_nxt = t;
                    8'h90: char_code_nxt = a;  
                    8'hb0: char_code_nxt = g;
                    8'hc0: char_code_nxt = a;
                    8'hd0: char_code_nxt = m;
                    8'he0: char_code_nxt = e; 
                    8'h01: char_code_nxt = t;
                    8'h11: char_code_nxt = u;
                    8'h21: char_code_nxt = r;
                    8'h31: char_code_nxt = n;
                    8'h51: char_code_nxt = o;  
                    8'h61: char_code_nxt = n;
                    8'h81: char_code_nxt = s;
                    8'h91: char_code_nxt = w;
                    8'ha1: char_code_nxt = i;
                    8'hb1: char_code_nxt = t;
                    8'hc1: char_code_nxt = c;  
                    8'hd1: char_code_nxt = h;
                    8'h02: char_code_nxt = V;
                    8'h12: char_code_nxt = ZERO+1;
                    8'h22: char_code_nxt = ZERO+7;                   
                    default: char_code_nxt = 0;
                endcase              
            end
            CHOSING_BOARD_SIZE:
            begin
                for(memory_counter = 0; memory_counter < 16; memory_counter=memory_counter+1)
                begin
                    player1_name_nxt[memory_counter] = 0;
                    player2_name_nxt[memory_counter] = 0;
                end      
                if(warning)
                begin
                    case(char_xy) // Error! Rightclick_mouse_to pick_board_size again 
                        8'h00: char_code_nxt = E;
                        8'h10: char_code_nxt = r;  
                        8'h20: char_code_nxt = r;
                        8'h30: char_code_nxt = o;
                        8'h40: char_code_nxt = r;
                        8'h50: char_code_nxt = 33; // !
                        8'h01: char_code_nxt = R;
                        8'h11: char_code_nxt = i;  
                        8'h21: char_code_nxt = g;
                        8'h31: char_code_nxt = h;
                        8'h41: char_code_nxt = t;
                        8'h51: char_code_nxt = c;
                        8'h61: char_code_nxt = l;
                        8'h71: char_code_nxt = i;
                        8'h81: char_code_nxt = c;  
                        8'h91: char_code_nxt = k;
                        8'hb1: char_code_nxt = t;
                        8'hc1: char_code_nxt = o;
                        8'h02: char_code_nxt = p;
                        8'h12: char_code_nxt = i;  
                        8'h22: char_code_nxt = c;
                        8'h32: char_code_nxt = k;
                        8'h52: char_code_nxt = b;
                        8'h62: char_code_nxt = o;
                        8'h72: char_code_nxt = a;
                        8'h82: char_code_nxt = r;  
                        8'h92: char_code_nxt = d;
                        8'hb2: char_code_nxt = s;
                        8'hc2: char_code_nxt = i;
                        8'hd2: char_code_nxt = z;
                        8'he2: char_code_nxt = e;
                        8'h03: char_code_nxt = a;
                        8'h13: char_code_nxt = g;
                        8'h23: char_code_nxt = a;
                        8'h33: char_code_nxt = i;
                        8'h43: char_code_nxt = n;                    
                        default: char_code_nxt = 0;
                endcase           
                end
                else
                begin
                    case(char_xy) // Pick_board_size 
                        8'h00: char_code_nxt = P;
                        8'h10: char_code_nxt = i;  
                        8'h20: char_code_nxt = c;
                        8'h30: char_code_nxt = k;
                        8'h50: char_code_nxt = b;
                        8'h60: char_code_nxt = o;
                        8'h70: char_code_nxt = a;
                        8'h80: char_code_nxt = r;  
                        8'h90: char_code_nxt = d;
                        8'hb0: char_code_nxt = s;
                        8'hc0: char_code_nxt = i;
                        8'hd0: char_code_nxt = z;
                        8'he0: char_code_nxt = e;
                        8'hf0: char_code_nxt = 46;// .
                        8'h01: char_code_nxt = I;  
                        8'h11: char_code_nxt = n;
                        8'h31: char_code_nxt = o;
                        8'h41: char_code_nxt = r;
                        8'h51: char_code_nxt = d;
                        8'h61: char_code_nxt = e;
                        8'h71: char_code_nxt = r;  
                        8'h91: char_code_nxt = f;
                        8'ha1: char_code_nxt = r;
                        8'hb1: char_code_nxt = o;
                        8'hc1: char_code_nxt = m;
                        8'h02: char_code_nxt = l;
                        8'h12: char_code_nxt = e;
                        8'h22: char_code_nxt = f;
                        8'h32: char_code_nxt = t;
                        8'h42: char_code_nxt = 58; // :
                        8'h03: char_code_nxt = 45; // -                        
                        8'h23: char_code_nxt = ZERO+6;  
                        8'h33: char_code_nxt = x;
                        8'h43: char_code_nxt = ZERO+6;
                        8'h04: char_code_nxt = 45; // - 
                        8'h24: char_code_nxt = ZERO+7;
                        8'h34: char_code_nxt = x;                        
                        8'h44: char_code_nxt = ZERO+7; 
                        8'h05: char_code_nxt = 45; // - 
                        8'h25: char_code_nxt = ZERO+8;
                        8'h35: char_code_nxt = x;                        
                        8'h45: char_code_nxt = ZERO+8;  
                        default: char_code_nxt = 0;
                    endcase
                end
            end
            CHOSING_PLAYERS:
                    case(char_xy) // Write_a_name_for Player_1/2 
                        8'h00: char_code_nxt = W;
                        8'h10: char_code_nxt = r;  
                        8'h20: char_code_nxt = i;
                        8'h30: char_code_nxt = t;
                        8'h40: char_code_nxt = e;
                        8'h60: char_code_nxt = a;
                        8'h80: char_code_nxt = n;
                        8'h90: char_code_nxt = a;  
                        8'ha0: char_code_nxt = m;
                        8'hb0: char_code_nxt = e;
                        8'hd0: char_code_nxt = f;
                        8'he0: char_code_nxt = o;
                        8'hf0: char_code_nxt = r;
                        8'h01: char_code_nxt = P;
                        8'h11: char_code_nxt = l;  
                        8'h21: char_code_nxt = a;
                        8'h31: char_code_nxt = y;
                        8'h41: char_code_nxt = e;
                        8'h51: char_code_nxt = r;
                        8'h71: 
                            if(active_player)
                                char_code_nxt = 50; // 2
                            else
                                char_code_nxt = 49; // 1
                        
                        8'h91: char_code_nxt = 40; // (
                        8'ha1: char_code_nxt = u;  
                        8'hb1: char_code_nxt = p;
                        8'hd1: char_code_nxt = t;
                        8'he1: char_code_nxt = o;
                        8'h02: char_code_nxt = 49; // 1
                        8'h12: char_code_nxt = 53; // 5
                        8'h32: char_code_nxt = c;  
                        8'h42: char_code_nxt = h;
                        8'h52: char_code_nxt = a;
                        8'h62: char_code_nxt = r;
                        8'h72: char_code_nxt = a;
                        8'h82: char_code_nxt = c;
                        8'h92: char_code_nxt = t;
                        8'ha2: char_code_nxt = e;  
                        8'hb2: char_code_nxt = r;
                        8'hc2: char_code_nxt = s;
                        8'hd2: char_code_nxt = 41; // )                             
                        // Writing names on screen      
                          
                        8'h03: 
                            if(active_player)
                                char_code_nxt = player2_name[1]; 
                            else
                                char_code_nxt = player1_name[1];
                        8'h13: 
                            if(active_player)
                                char_code_nxt = player2_name[2];
                            else
                                char_code_nxt = player1_name[2];
                        8'h23: 
                            if(active_player)
                                char_code_nxt = player2_name[3];
                            else
                                char_code_nxt = player1_name[3];
                        8'h33: 
                            if(active_player)
                                char_code_nxt = player2_name[4];
                            else
                                char_code_nxt = player1_name[4];
                        8'h43: 
                            if(active_player)
                                char_code_nxt = player2_name[5];
                            else
                                char_code_nxt = player1_name[5];
                        8'h53: 
                            if(active_player)
                                char_code_nxt = player2_name[6];
                            else
                                char_code_nxt = player1_name[6];
                        8'h63: 
                            if(active_player)
                                char_code_nxt = player2_name[7];
                            else
                                char_code_nxt = player1_name[7];
                        8'h73: 
                            if(active_player)
                                char_code_nxt = player2_name[8];
                            else
                                char_code_nxt = player1_name[8];
                        8'h83: 
                            if(active_player)
                                char_code_nxt = player2_name[9];
                            else
                                char_code_nxt = player1_name[9];
                        8'h93: 
                            if(active_player)
                                char_code_nxt = player2_name[10];
                            else
                                char_code_nxt = player1_name[10];
                        8'ha3: 
                            if(active_player)
                                char_code_nxt = player2_name[11];
                            else
                                char_code_nxt = player1_name[11];
                        8'hb3: 
                            if(active_player)
                                char_code_nxt = player2_name[12];
                            else
                                char_code_nxt = player1_name[12];
                         8'hc3: 
                            if(active_player)
                                char_code_nxt = player2_name[13];
                            else
                                char_code_nxt = player1_name[13];
                         8'hd3: 
                            if(active_player)
                                char_code_nxt = player2_name[14];
                            else
                                char_code_nxt = player1_name[14];
                         8'he3: 
                            if(active_player)
                                char_code_nxt = player2_name[15];
                            else
                                char_code_nxt = player1_name[15];
                                        
                        default: char_code_nxt = 0;
                    endcase
                default: char_code_nxt = 0;  
            PLACING_SHIPS:
            begin
                if(warning) //Player 1/2 You tried to place a ship in unable square. Rightclick to try again
                begin
                    case(char_xy)
                        8'h00: 
                            if(active_player)
                                char_code_nxt = player2_name[1]; 
                            else
                                char_code_nxt = player1_name[1];
                        8'h10: 
                            if(active_player)
                                char_code_nxt = player2_name[2];
                            else
                                char_code_nxt = player1_name[2];
                        8'h20: 
                            if(active_player)
                                char_code_nxt = player2_name[3];
                            else
                                char_code_nxt = player1_name[3];
                        8'h30: 
                            if(active_player)
                                char_code_nxt = player2_name[4];
                            else
                                char_code_nxt = player1_name[4];
                        8'h40: 
                            if(active_player)
                                char_code_nxt = player2_name[5];
                            else
                                char_code_nxt = player1_name[5];
                        8'h50: 
                            if(active_player)
                                char_code_nxt = player2_name[6];
                            else
                                char_code_nxt = player1_name[6];
                        8'h60: 
                            if(active_player)
                                char_code_nxt = player2_name[7];
                            else
                                char_code_nxt = player1_name[7];
                        8'h70: 
                            if(active_player)
                                char_code_nxt = player2_name[8];
                            else
                                char_code_nxt = player1_name[8];
                        8'h80: 
                            if(active_player)
                                char_code_nxt = player2_name[9];
                            else
                                char_code_nxt = player1_name[9];
                        8'h90: 
                            if(active_player)
                                char_code_nxt = player2_name[10];
                            else
                                char_code_nxt = player1_name[10];
                        8'ha0: 
                            if(active_player)
                                char_code_nxt = player2_name[11];
                            else
                                char_code_nxt = player1_name[11];
                        8'hb0: 
                            if(active_player)
                                char_code_nxt = player2_name[12];
                            else
                                char_code_nxt = player1_name[12];
                        8'hc0: 
                            if(active_player)
                                char_code_nxt = player2_name[13];
                            else
                                char_code_nxt = player1_name[13];
                        8'hd0: 
                            if(active_player)
                                char_code_nxt = player2_name[14];
                            else
                                char_code_nxt = player1_name[14];
                        8'he0: 
                            if(active_player)
                                char_code_nxt = player2_name[15];
                            else
                                char_code_nxt = player1_name[15];

                        8'h01: char_code_nxt = Y;         
                        8'h11: char_code_nxt = o;  
                        8'h21: char_code_nxt = y;
                        8'h41: char_code_nxt = t;
                        8'h51: char_code_nxt = r;
                        8'h61: char_code_nxt = i;
                        8'h71: char_code_nxt = e;
                        8'h81: char_code_nxt = d;  
                        8'ha1: char_code_nxt = t;
                        8'hb1: char_code_nxt = o;
                        8'h02: char_code_nxt = p;
                        8'h12: char_code_nxt = l;
                        8'h22: char_code_nxt = a;  
                        8'h32: char_code_nxt = c;  
                        8'h42: char_code_nxt = e;         
                        8'h62: char_code_nxt = a;  
                        8'h82: char_code_nxt = s;
                        8'h92: char_code_nxt = h;
                        8'ha2: char_code_nxt = i;
                        8'hb2: char_code_nxt = p;
                        8'hd2: char_code_nxt = i;
                        8'he2: char_code_nxt = n;  
                        8'h03: char_code_nxt = u;
                        8'h13: char_code_nxt = n;
                        8'h23: char_code_nxt = a;
                        8'h33: char_code_nxt = b;         
                        8'h43: char_code_nxt = l;  
                        8'h53: char_code_nxt = e;
                        8'h73: char_code_nxt = s; 
                        8'h83: char_code_nxt = q; 
                        8'h93: char_code_nxt = u;
                        8'ha3: char_code_nxt = a;
                        8'hb3: char_code_nxt = r;                   
                        8'hc3: char_code_nxt = e;  
                        8'hd3: char_code_nxt = 46; // .  
                        8'h04: char_code_nxt = R;
                        8'h14: char_code_nxt = i;
                        8'h24: char_code_nxt = g;         
                        8'h34: char_code_nxt = h;  
                        8'h44: char_code_nxt = t;
                        8'h54: char_code_nxt = c;
                        8'h64: char_code_nxt = l;
                        8'h74: char_code_nxt = i;
                        8'h84: char_code_nxt = c;
                        8'h94: char_code_nxt = k;  
                        8'hb4: char_code_nxt = t;       
                        8'hc4: char_code_nxt = o;
                        8'h05: char_code_nxt = t;
                        8'h15: char_code_nxt = r;
                        8'h25: char_code_nxt = y;         
                        8'h45: char_code_nxt = a;
                        8'h55: char_code_nxt = g;
                        8'h65: char_code_nxt = a;
                        8'h75: char_code_nxt = i;  
                        8'h85: char_code_nxt = n;         
                        default: char_code_nxt = 0; 
                    endcase                   
                end
                else // Player1/2 Place your ships. Leftclick 
                // /*
                begin
                    case(char_xy)
                        8'h00: 
                            if(active_player)
                                char_code_nxt = player2_name[1]; 
                            else
                                char_code_nxt = player1_name[1];
                        8'h10: 
                            if(active_player)
                                char_code_nxt = player2_name[2];
                            else
                                char_code_nxt = player1_name[2];
                        8'h20: 
                            if(active_player)
                                char_code_nxt = player2_name[3];
                            else
                                char_code_nxt = player1_name[3];
                        8'h30: 
                            if(active_player)
                                char_code_nxt = player2_name[4];
                            else
                                char_code_nxt = player1_name[4];
                        8'h40: 
                            if(active_player)
                                char_code_nxt = player2_name[5];
                            else
                                char_code_nxt = player1_name[5];
                        8'h50: 
                            if(active_player)
                                char_code_nxt = player2_name[6];
                            else
                                char_code_nxt = player1_name[6];
                        8'h60: 
                            if(active_player)
                                char_code_nxt = player2_name[7];
                            else
                                char_code_nxt = player1_name[7];
                        8'h70: 
                            if(active_player)
                                char_code_nxt = player2_name[8];
                            else
                                char_code_nxt = player1_name[8];
                        8'h80: 
                            if(active_player)
                                char_code_nxt = player2_name[9];
                            else
                                char_code_nxt = player1_name[9];
                        8'h90: 
                            if(active_player)
                                char_code_nxt = player2_name[10];
                            else
                                char_code_nxt = player1_name[10];
                        8'ha0: 
                            if(active_player)
                                char_code_nxt = player2_name[11];
                            else
                                char_code_nxt = player1_name[11];
                        8'hb0: 
                            if(active_player)
                                char_code_nxt = player2_name[12];
                            else
                                char_code_nxt = player1_name[12];
                        8'hc0: 
                            if(active_player)
                                char_code_nxt = player2_name[13];
                            else
                                char_code_nxt = player1_name[13];
                        8'hd0: 
                            if(active_player)
                                char_code_nxt = player2_name[14];
                            else
                                char_code_nxt = player1_name[14];
                        8'he0: 
                            if(active_player)
                                char_code_nxt = player2_name[15];
                            else
                                char_code_nxt = player1_name[15];

                        8'h01: char_code_nxt = P;         
                        8'h11: char_code_nxt = l;  
                        8'h21: char_code_nxt = a;
                        8'h31: char_code_nxt = c;
                        8'h41: char_code_nxt = e;
                        8'h61: char_code_nxt = y;
                        8'h71: char_code_nxt = o;
                        8'h81: char_code_nxt = u;  
                        8'h91: char_code_nxt = r;
                        8'hb1: char_code_nxt = s;
                        8'hc1: char_code_nxt = h;
                        8'hd1: char_code_nxt = i;
                        8'he1: char_code_nxt = p;  
                        8'hf1: char_code_nxt = s;  
                        8'h02: char_code_nxt = L;         
                        8'h12: char_code_nxt = e;  
                        8'h22: char_code_nxt = f;
                        8'h32: char_code_nxt = t;
                        8'h42: char_code_nxt = c;
                        8'h52: char_code_nxt = l;
                        8'h62: char_code_nxt = i;
                        8'h72: char_code_nxt = c;  
                        8'h82: char_code_nxt = k;
                        8'ha2: char_code_nxt = t;
                        8'hb2: char_code_nxt = o;
                        8'h03: char_code_nxt = p;         
                        8'h13: char_code_nxt = i;  
                        8'h23: char_code_nxt = c;
                        8'h33: char_code_nxt = k;
                        8'h53: char_code_nxt = 38; // &
                        8'h73: char_code_nxt = p; 
                        8'h83: char_code_nxt = u;
                        8'h93: char_code_nxt = t;
                        8'hb3: char_code_nxt = s;                   
                        8'hc3: char_code_nxt = h;  
                        8'hd3: char_code_nxt = i;
                        8'he3: char_code_nxt = p;
                        8'h04: char_code_nxt = R;         
                        8'h14: char_code_nxt = i;  
                        8'h24: char_code_nxt = g;
                        8'h34: char_code_nxt = h;
                        8'h44: char_code_nxt = t;
                        8'h54: char_code_nxt = c;
                        8'h64: char_code_nxt = l;
                        8'h74: char_code_nxt = i;  
                        8'h84: char_code_nxt = c;       
                        8'h94: char_code_nxt = k;
                        8'hb4: char_code_nxt = t;
                        8'hc4: char_code_nxt = o;
                        8'h05: char_code_nxt = r;         
                        8'h15: char_code_nxt = e;  
                        8'h25: char_code_nxt = v;
                        8'h35: char_code_nxt = e;
                        8'h45: char_code_nxt = r;
                        8'h55: char_code_nxt = s;
                        8'h65: char_code_nxt = e;  
                        8'h85: char_code_nxt = s;       
                        8'h95: char_code_nxt = h;
                        8'ha5: char_code_nxt = i;
                        8'hb5: char_code_nxt = p;
                        8'h06: char_code_nxt = S;         
                        8'h16: char_code_nxt = h;  
                        8'h26: char_code_nxt = i;
                        8'h36: char_code_nxt = p;
                        8'h46: char_code_nxt = s;
                        8'h66: char_code_nxt = l;
                        8'h76: char_code_nxt = e;
                        8'h86: char_code_nxt = f;  
                        8'h96: char_code_nxt = t;       
                        8'ha6: char_code_nxt = 58; // :
                        8'hc6: 
                            if(players_ships5x+players_ships4x+players_ships3x+players_ships2x+players_ships1x >= 10)
                                char_code_nxt = 48+(players_ships5x+players_ships4x+players_ships3x+players_ships2x+players_ships1x)/10;
                            else
                                char_code_nxt = 48+players_ships5x+players_ships4x+players_ships3x+players_ships2x+players_ships1x;
                        8'hd6: 
                            if(players_ships5x+players_ships4x+players_ships3x+players_ships2x+players_ships1x >= 10)
                                char_code_nxt = 48+(players_ships5x+players_ships4x+players_ships3x+players_ships2x+players_ships1x)%10;
                            else
                                char_code_nxt = 0;
                        8'h07: char_code_nxt = 53; // 5         
                        8'h27: char_code_nxt = e;
                        8'h37: char_code_nxt = l;
                        8'h47: char_code_nxt = e;
                        8'h57: char_code_nxt = m;
                        8'h67: char_code_nxt = e;
                        8'h77: char_code_nxt = n;
                        8'h87: char_code_nxt = t;  
                        8'h97: char_code_nxt = s;       
                        8'hb7: char_code_nxt = 61; // =
                        8'hd7: char_code_nxt = 48+players_ships5x;   
                        8'h08: char_code_nxt = 52; // 4        
                        8'h28: char_code_nxt = e;
                        8'h38: char_code_nxt = l;
                        8'h48: char_code_nxt = e;
                        8'h58: char_code_nxt = m;
                        8'h68: char_code_nxt = e;
                        8'h78: char_code_nxt = n;
                        8'h88: char_code_nxt = t;  
                        8'h98: char_code_nxt = s;       
                        8'hb8: char_code_nxt = 61; // =
                        8'hd8: char_code_nxt = 48+players_ships4x;
                        8'h09: char_code_nxt = 51; // 3         
                        8'h29: char_code_nxt = e;
                        8'h39: char_code_nxt = l;
                        8'h49: char_code_nxt = e;
                        8'h59: char_code_nxt = m;
                        8'h69: char_code_nxt = e;
                        8'h79: char_code_nxt = n;
                        8'h89: char_code_nxt = t;  
                        8'h99: char_code_nxt = s;       
                        8'hb9: char_code_nxt = 61; // =
                        8'hd9: char_code_nxt = 48+players_ships3x;   
                        8'h0a: char_code_nxt = 50; // 2         
                        8'h2a: char_code_nxt = e;
                        8'h3a: char_code_nxt = l;
                        8'h4a: char_code_nxt = e;
                        8'h5a: char_code_nxt = m;
                        8'h6a: char_code_nxt = e;
                        8'h7a: char_code_nxt = n;
                        8'h8a: char_code_nxt = t;  
                        8'h9a: char_code_nxt = s;       
                        8'hba: char_code_nxt = 61; // =
                        8'hda: char_code_nxt = 48+players_ships2x;    
                        8'h0b: char_code_nxt = 49; // 1         
                        8'h2b: char_code_nxt = e;
                        8'h3b: char_code_nxt = l;
                        8'h4b: char_code_nxt = e;
                        8'h5b: char_code_nxt = m;
                        8'h6b: char_code_nxt = e;
                        8'h7b: char_code_nxt = n;
                        8'h8b: char_code_nxt = t;  
                        8'h9b: char_code_nxt = s;       
                        8'hbb: char_code_nxt = 61; // =
                        8'hdb: char_code_nxt = 48+players_ships1x;                                                                   
                        default: char_code_nxt = 0;
                    endcase                      
                end
            end
            SCREEN_BLANKING:
            begin
                case(char_xy) // Player1/2 Press ENTER when ready to start a move
                    8'h00: 
                        if(active_player)
                            char_code_nxt = player2_name[1]; 
                        else
                            char_code_nxt = player1_name[1];
                    8'h10: 
                        if(active_player)
                            char_code_nxt = player2_name[2];
                        else
                            char_code_nxt = player1_name[2];
                    8'h20:  
                        if(active_player)
                            char_code_nxt = player2_name[3];
                        else
                            char_code_nxt = player1_name[3];
                    8'h30: 
                        if(active_player)
                            char_code_nxt = player2_name[4];
                        else
                            char_code_nxt = player1_name[4];
                    8'h40: 
                        if(active_player)
                            char_code_nxt = player2_name[5];
                        else
                            char_code_nxt = player1_name[5];
                    8'h50: 
                        if(active_player)
                            char_code_nxt = player2_name[6];
                        else
                            char_code_nxt = player1_name[6];
                    8'h60: 
                        if(active_player)
                            char_code_nxt = player2_name[7];
                        else
                            char_code_nxt = player1_name[7];
                    8'h70: 
                        if(active_player)
                            char_code_nxt = player2_name[8];
                        else
                            char_code_nxt = player1_name[8];
                    8'h80: 
                        if(active_player)
                            char_code_nxt = player2_name[9];
                        else
                            char_code_nxt = player1_name[9];
                    8'h90: 
                        if(active_player)
                            char_code_nxt = player2_name[10];
                        else
                            char_code_nxt = player1_name[10];
                    8'ha0: 
                        if(active_player)
                            char_code_nxt = player2_name[11];
                        else
                            char_code_nxt = player1_name[11];
                    8'hb0: 
                        if(active_player)
                            char_code_nxt = player2_name[12];
                        else
                            char_code_nxt = player1_name[12];
                    8'hc0: 
                        if(active_player)
                            char_code_nxt = player2_name[13];
                        else
                            char_code_nxt = player1_name[13];
                    8'hd0: 
                        if(active_player)
                            char_code_nxt = player2_name[14];
                        else
                            char_code_nxt = player1_name[14];
                    8'he0:  
                        if(active_player)
                            char_code_nxt = player2_name[15];
                        else
                            char_code_nxt = player1_name[15];

                    8'h01: char_code_nxt = P;
                    8'h11: char_code_nxt = r;  
                    8'h21: char_code_nxt = e;
                    8'h31: char_code_nxt = s;
                    8'h41: char_code_nxt = s;
                    8'h61: char_code_nxt = E;
                    8'h71: char_code_nxt = N;
                    8'h81: char_code_nxt = T;  
                    8'h91: char_code_nxt = E;
                    8'ha1: char_code_nxt = R;
                    8'hc1: char_code_nxt = w;
                    8'hd1: char_code_nxt = h; 
                    8'he1: char_code_nxt = e;
                    8'hf1: char_code_nxt = n;
                    8'h02: char_code_nxt = r;
                    8'h12: char_code_nxt = e;
                    8'h22: char_code_nxt = a;  
                    8'h32: char_code_nxt = d;
                    8'h42: char_code_nxt = y;
                    8'h62: char_code_nxt = t;
                    8'h72: char_code_nxt = o;
                    8'h92: char_code_nxt = s;
                    8'ha2: char_code_nxt = t;  
                    8'hb2: char_code_nxt = a;
                    8'hc2: char_code_nxt = r;
                    8'hd2: char_code_nxt = t;  
                    8'hf2: char_code_nxt = a;
                    8'h03: char_code_nxt = m;
                    8'h13: char_code_nxt = o;
                    8'h23: char_code_nxt = v;
                    8'h33: char_code_nxt = e;
                    default: char_code_nxt = 0;                   
                endcase
            end
            // /*
            FINDING_SHIPS:
            begin
                if(warning) //Player 1/2 You tried to find a ship in same square as before. Rightclick to try again
                begin
                    case(char_xy)
                        8'h00: 
                            if(active_player)
                                char_code_nxt = player2_name[1]; 
                            else
                                char_code_nxt = player1_name[1];
                        8'h10: 
                            if(active_player)
                                char_code_nxt = player2_name[2];
                            else
                                char_code_nxt = player1_name[2];
                        8'h20: 
                            if(active_player)
                                char_code_nxt = player2_name[3];
                            else
                                char_code_nxt = player1_name[3];
                        8'h30: 
                            if(active_player)
                                char_code_nxt = player2_name[4];
                            else
                                char_code_nxt = player1_name[4];
                        8'h40: 
                            if(active_player)
                                char_code_nxt = player2_name[5];
                            else
                                char_code_nxt = player1_name[5];
                        8'h50: 
                            if(active_player)
                                char_code_nxt = player2_name[6];
                            else
                                char_code_nxt = player1_name[6];
                        8'h60: 
                            if(active_player)
                                char_code_nxt = player2_name[7];
                            else
                                char_code_nxt = player1_name[7];
                        8'h70: 
                            if(active_player)
                                char_code_nxt = player2_name[8];
                            else
                                char_code_nxt = player1_name[8];
                        8'h80: 
                            if(active_player)
                                char_code_nxt = player2_name[9];
                            else
                                char_code_nxt = player1_name[9];
                        8'h90: 
                            if(active_player)
                                char_code_nxt = player2_name[10];
                            else
                                char_code_nxt = player1_name[10];
                        8'ha0: 
                            if(active_player)
                                char_code_nxt = player2_name[11];
                            else
                                char_code_nxt = player1_name[11];
                        8'hb0: 
                            if(active_player)
                                char_code_nxt = player2_name[12];
                            else
                                char_code_nxt = player1_name[12];
                        8'hc0: 
                            if(active_player)
                                char_code_nxt = player2_name[13];
                            else
                                char_code_nxt = player1_name[13];
                        8'hd0: 
                            if(active_player)
                                char_code_nxt = player2_name[14];
                            else
                                char_code_nxt = player1_name[14];
                        8'he0: 
                            if(active_player)
                                char_code_nxt = player2_name[15];
                            else
                                char_code_nxt = player1_name[15];

                        8'h01: char_code_nxt = Y;         
                        8'h11: char_code_nxt = o;  
                        8'h21: char_code_nxt = u;
                        8'h41: char_code_nxt = t;
                        8'h51: char_code_nxt = r;
                        8'h61: char_code_nxt = i;
                        8'h71: char_code_nxt = e;
                        8'h81: char_code_nxt = d;  
                        8'ha1: char_code_nxt = t;
                        8'hb1: char_code_nxt = o;
                        8'h02: char_code_nxt = f;
                        8'h12: char_code_nxt = i;
                        8'h22: char_code_nxt = n;  
                        8'h32: char_code_nxt = d;          
                        8'h52: char_code_nxt = a;  
                        8'h72: char_code_nxt = s;
                        8'h82: char_code_nxt = h;
                        8'h92: char_code_nxt = i;
                        8'ha2: char_code_nxt = p;
                        8'hc2: char_code_nxt = i;
                        8'hd2: char_code_nxt = n;  
                        8'h03: char_code_nxt = s;
                        8'h13: char_code_nxt = a;
                        8'h23: char_code_nxt = m;
                        8'h33: char_code_nxt = e;         
                        8'h53: char_code_nxt = p;  
                        8'h63: char_code_nxt = l;
                        8'h73: char_code_nxt = a; 
                        8'h83: char_code_nxt = c; 
                        8'h93: char_code_nxt = e;
                        8'hb3: char_code_nxt = a;
                        8'hc3: char_code_nxt = s;                   
                        8'h04: char_code_nxt = b;
                        8'h14: char_code_nxt = e; 
                        8'h24: char_code_nxt = f;
                        8'h34: char_code_nxt = o;
                        8'h44: char_code_nxt = r;                   
                        8'h54: char_code_nxt = e;
                        8'h64: char_code_nxt = 46; // .                           
                        8'h05: char_code_nxt = R;
                        8'h15: char_code_nxt = i;
                        8'h25: char_code_nxt = g;         
                        8'h35: char_code_nxt = h;  
                        8'h45: char_code_nxt = t;
                        8'h55: char_code_nxt = c;
                        8'h65: char_code_nxt = l;
                        8'h75: char_code_nxt = i;
                        8'h85: char_code_nxt = c;
                        8'h95: char_code_nxt = k;  
                        8'hb5: char_code_nxt = t;       
                        8'hc5: char_code_nxt = o;
                        8'h06: char_code_nxt = t;
                        8'h16: char_code_nxt = r;
                        8'h26: char_code_nxt = y;         
                        8'h46: char_code_nxt = a;
                        8'h56: char_code_nxt = g;
                        8'h66: char_code_nxt = a;
                        8'h76: char_code_nxt = i;  
                        8'h86: char_code_nxt = n;         
                        default: char_code_nxt = 0; 
                    endcase                   
                end
                else // Player1/2 Place your ships. Leftclick 
                begin
                    if(active_move_finding)
                    begin
                        case(char_xy)
                            8'h00: 
                                if(active_player)
                                    char_code_nxt = player2_name[1]; 
                                else
                                    char_code_nxt = player1_name[1];
                            8'h10: 
                                if(active_player)
                                    char_code_nxt = player2_name[2];
                                else
                                    char_code_nxt = player1_name[2];
                            8'h20: 
                                if(active_player)
                                    char_code_nxt = player2_name[3];
                                else
                                    char_code_nxt = player1_name[3];
                            8'h30: 
                                if(active_player)
                                    char_code_nxt = player2_name[4];
                                else
                                    char_code_nxt = player1_name[4];
                            8'h40: 
                                if(active_player)
                                    char_code_nxt = player2_name[5];
                                else
                                    char_code_nxt = player1_name[5];
                            8'h50: 
                                if(active_player)
                                    char_code_nxt = player2_name[6];
                                else
                                    char_code_nxt = player1_name[6];
                            8'h60: 
                                if(active_player)
                                    char_code_nxt = player2_name[7];
                                else
                                    char_code_nxt = player1_name[7];
                            8'h70: 
                                if(active_player)
                                    char_code_nxt = player2_name[8];
                                else
                                    char_code_nxt = player1_name[8];
                            8'h80: 
                                if(active_player)
                                    char_code_nxt = player2_name[9];
                                else
                                    char_code_nxt = player1_name[9];
                            8'h90:  
                                if(active_player)
                                    char_code_nxt = player2_name[10];
                                else
                                    char_code_nxt = player1_name[10];
                            8'ha0: 
                                if(active_player)
                                    char_code_nxt = player2_name[11];
                                else
                                    char_code_nxt = player1_name[11];
                            8'hb0: 
                                if(active_player)
                                    char_code_nxt = player2_name[12];
                                else
                                    char_code_nxt = player1_name[12];
                            8'hc0: 
                                if(active_player)
                                    char_code_nxt = player2_name[13];
                                else
                                    char_code_nxt = player1_name[13];
                            8'hd0: 
                                if(active_player)
                                    char_code_nxt = player2_name[14];
                                else
                                    char_code_nxt = player1_name[14];
                            8'he0: 
                                if(active_player)
                                    char_code_nxt = player2_name[15];
                                else
                                    char_code_nxt = player1_name[15];
                        
                            8'h01: char_code_nxt = F;         
                            8'h11: char_code_nxt = i;  
                            8'h21: char_code_nxt = n;
                            8'h31: char_code_nxt = d;
                            8'h51: char_code_nxt = o;
                            8'h61: char_code_nxt = p;
                            8'h71: char_code_nxt = p;
                            8'h81: char_code_nxt = o;  
                            8'h91: char_code_nxt = n;
                            8'ha1: char_code_nxt = e;
                            8'hb1: char_code_nxt = n;
                            8'hc1: char_code_nxt = t;
                            8'hd1: char_code_nxt = 39; // '  
                            8'he1: char_code_nxt = s;  
                            8'h02: char_code_nxt = s;         
                            8'h12: char_code_nxt = h;  
                            8'h22: char_code_nxt = i;
                            8'h32: char_code_nxt = p;
                            8'h42: char_code_nxt = s;
                            8'h62: char_code_nxt = b;  
                            8'h72: char_code_nxt = y;
                            8'h03: char_code_nxt = l;
                            8'h13: char_code_nxt = e;
                            8'h23: char_code_nxt = f;
                            8'h33: char_code_nxt = t;   
                            8'h43: char_code_nxt = c;  
                            8'h53: char_code_nxt = l;         
                            8'h63: char_code_nxt = i;  
                            8'h73: char_code_nxt = k;
                            8'h83: char_code_nxt = i;
                            8'h93: char_code_nxt = n;
                            8'ha3: char_code_nxt = g;
                            8'hc3: char_code_nxt = o;  
                            8'hd3: char_code_nxt = n;
                            8'h04: char_code_nxt = b;
                            8'h14: char_code_nxt = o;
                            8'h24: char_code_nxt = a;
                            8'h34: char_code_nxt = r;   
                            8'h44: char_code_nxt = d;  
                            8'h05: char_code_nxt = Y;         
                            8'h15: char_code_nxt = o;  
                            8'h25: char_code_nxt = u;
                            8'h45: char_code_nxt = f;
                            8'h55: char_code_nxt = o;
                            8'h65: char_code_nxt = u;
                            8'h75: char_code_nxt = n;
                            8'h85: char_code_nxt = d;  
                            8'h95: char_code_nxt = 58; // :                                  
                            8'hb5: 
                                if(active_player)
                                begin
                                    if(hit_ships2 >= 10)
                                        char_code_nxt = 48+(hit_ships2)/10;
                                else
                                        char_code_nxt = 48+hit_ships2;
                                end
                                else
                                begin
                                    if(hit_ships1 >= 10)
                                        char_code_nxt = 48+(hit_ships1)/10;
                                    else
                                        char_code_nxt = 48+hit_ships1;
                                end                                   
                            8'hc5: 
                                if(active_player)
                                begin
                                    if(hit_ships2 >= 10)
                                        char_code_nxt = 48+(hit_ships2)%10;
                                    else
                                        char_code_nxt = 47; // /
                                end
                                else
                                begin
                                    if(hit_ships1 >= 10)
                                        char_code_nxt = 48+(hit_ships1)%10;
                                    else
                                        char_code_nxt = 47; // /
                                end      
                            8'hd5: 
                                if(active_player)
                                begin
                                    if(hit_ships2 >= 10)
                                        char_code_nxt = 47; // / 
                                    else
                                        char_code_nxt = 48+ships_to_hit/10;
                                end
                                else
                                begin
                                    if(hit_ships1 >= 10)
                                        char_code_nxt = 47; // / 
                                    else
                                        char_code_nxt = 48+ships_to_hit/10;
                                end
                            8'he5: 
                                if(active_player)
                                begin
                                   if(hit_ships2 >= 10)
                                       char_code_nxt = 48+ships_to_hit/10; 
                                   else
                                       char_code_nxt = 48+ships_to_hit%10;
                                end
                                else
                                begin
                                    if(hit_ships1 >= 10)
                                        char_code_nxt = 48+ships_to_hit/10; 
                                    else
                                        char_code_nxt = 48+ships_to_hit%10;
                                end                             
                            8'hf5: 
                                if(active_player)
                                begin
                                    if(hit_ships2 >= 10)
                                        char_code_nxt = 48+ships_to_hit%10; 
                                    else
                                        char_code_nxt = 0;
                                end
                                else
                                begin
                                    if(hit_ships1 >= 10)
                                        char_code_nxt = 48+ships_to_hit%10; 
                                    else
                                        char_code_nxt = 0;
                                end
                            8'h06: char_code_nxt = s;         
                            8'h16: char_code_nxt = h;  
                            8'h26: char_code_nxt = i;
                            8'h36: char_code_nxt = p;
                            8'h46: char_code_nxt = s;
                            
                            8'h07: 
                                if(!active_player)
                                    char_code_nxt = player2_name[1]; 
                                else
                                    char_code_nxt = player1_name[1];
                            8'h17: 
                                if(!active_player)
                                    char_code_nxt = player2_name[2];
                                else
                                    char_code_nxt = player1_name[2];
                            8'h27:  
                                if(!active_player)
                                    char_code_nxt = player2_name[3];
                                else
                                    char_code_nxt = player1_name[3];
                            8'h37: 
                                if(!active_player)
                                    char_code_nxt = player2_name[4];
                                else
                                    char_code_nxt = player1_name[4];
                            8'h47: 
                                if(!active_player)
                                    char_code_nxt = player2_name[5];
                                else
                                    char_code_nxt = player1_name[5];
                            8'h57: 
                                if(!active_player)
                                    char_code_nxt = player2_name[6];
                                else
                                    char_code_nxt = player1_name[6];
                            8'h67: 
                                if(!active_player)
                                    char_code_nxt = player2_name[7];
                                else
                                    char_code_nxt = player1_name[7];
                            8'h77: 
                                if(!active_player)
                                    char_code_nxt = player2_name[8];
                                else
                                    char_code_nxt = player1_name[8];
                            8'h87: 
                                if(!active_player)
                                    char_code_nxt = player2_name[9];
                                else
                                    char_code_nxt = player1_name[9];
                            8'h97:  
                                if(!active_player)
                                    char_code_nxt = player2_name[10];
                                else
                                    char_code_nxt = player1_name[10];
                            8'ha7: 
                                if(!active_player)
                                    char_code_nxt = player2_name[11];
                                else
                                    char_code_nxt = player1_name[11];
                            8'hb7: 
                                if(!active_player)
                                    char_code_nxt = player2_name[12];
                                else
                                    char_code_nxt = player1_name[12];
                            8'hc7: 
                                if(!active_player)
                                    char_code_nxt = player2_name[13];
                                else
                                    char_code_nxt = player1_name[13];
                            8'hd7: 
                                if(!active_player)
                                    char_code_nxt = player2_name[14];
                                else
                                    char_code_nxt = player1_name[14];
                            8'he7:  
                                if(!active_player)
                                    char_code_nxt = player2_name[15];
                                else
                                    char_code_nxt = player1_name[15];
                                    
                            8'h08: char_code_nxt = f;
                            8'h18: char_code_nxt = o;
                            8'h28: char_code_nxt = u;
                            8'h38: char_code_nxt = n;
                            8'h48: char_code_nxt = d;  
                            8'h58: char_code_nxt = 58; // : 
                            8'h78:
                                if(!active_player)
                                begin
                                    if(hit_ships2 >= 10)
                                        char_code_nxt = 48+(hit_ships2)/10;
                                else
                                        char_code_nxt = 48+hit_ships2;
                                end
                                else
                                begin
                                    if(hit_ships1 >= 10)
                                        char_code_nxt = 48+(hit_ships1)/10;
                                    else
                                        char_code_nxt = 48+hit_ships1;
                                end                                   
                            8'h88: 
                                if(!active_player)
                                begin
                                    if(hit_ships2 >= 10)
                                        char_code_nxt = 48+(hit_ships2)%10;
                                    else
                                        char_code_nxt = 47; // /
                                end
                                else
                                begin
                                    if(hit_ships1 >= 10)
                                        char_code_nxt = 48+(hit_ships1)%10;
                                    else
                                        char_code_nxt = 47; // /
                                end      
                            8'h98: 
                                if(!active_player)
                                begin
                                    if(hit_ships2 >= 10)
                                        char_code_nxt = 47; // / 
                                    else
                                        char_code_nxt = 48+ships_to_hit/10;
                                end
                                else
                                begin
                                    if(hit_ships1 >= 10)
                                        char_code_nxt = 47; // / 
                                    else
                                        char_code_nxt = 48+ships_to_hit/10;
                                end
                            8'ha8: 
                                if(!active_player)
                                begin
                                    if(hit_ships2 >= 10)
                                        char_code_nxt = 48+ships_to_hit/10; 
                                else
                                        char_code_nxt = 48+ships_to_hit%10;
                                end
                                else
                                begin
                                    if(hit_ships1 >= 10)
                                        char_code_nxt = 48+ships_to_hit/10; 
                                    else
                                        char_code_nxt = 48+ships_to_hit%10;
                                end                             
                            8'hb8: 
                                if(!active_player)
                                begin
                                    if(hit_ships2 >= 10)
                                        char_code_nxt = 48+ships_to_hit%10; 
                                    else
                                        char_code_nxt = 0;
                                end
                                else
                                begin
                                    if(hit_ships1 >= 10)
                                        char_code_nxt = 48+ships_to_hit%10; 
                                    else
                                        char_code_nxt = 0;
                                end
                            8'h09: char_code_nxt = s;         
                            8'h19: char_code_nxt = h;  
                            8'h29: char_code_nxt = i;
                            8'h39: char_code_nxt = p;
                            8'h49: char_code_nxt = s;    
                            default: char_code_nxt = 0;
                        endcase
                    end
                    else
                    begin
                        case(char_xy) 
                            8'h00: 
                                if(active_player)
                                    char_code_nxt = player2_name[1]; 
                                else
                                    char_code_nxt = player1_name[1];
                            8'h10: 
                                if(active_player)
                                    char_code_nxt = player2_name[2];
                                else
                                    char_code_nxt = player1_name[2];
                            8'h20: 
                                if(active_player)
                                    char_code_nxt = player2_name[3];
                                else
                                    char_code_nxt = player1_name[3];
                            8'h30: 
                                if(active_player)
                                    char_code_nxt = player2_name[4];
                                else
                                    char_code_nxt = player1_name[4];
                            8'h40: 
                                if(active_player)
                                    char_code_nxt = player2_name[5];
                                else
                                    char_code_nxt = player1_name[5];
                            8'h50: 
                                if(active_player)
                                    char_code_nxt = player2_name[6];
                                else
                                    char_code_nxt = player1_name[6];
                            8'h60: 
                                if(active_player)
                                    char_code_nxt = player2_name[7];
                                else
                                    char_code_nxt = player1_name[7];
                            8'h70: 
                                if(active_player)
                                    char_code_nxt = player2_name[8];
                                else
                                    char_code_nxt = player1_name[8];
                            8'h80: 
                                if(active_player)
                                    char_code_nxt = player2_name[9];
                                else
                                    char_code_nxt = player1_name[9];
                            8'h90:  
                                if(active_player)
                                    char_code_nxt = player2_name[10];
                                else
                                    char_code_nxt = player1_name[10];
                            8'ha0: 
                                if(active_player)
                                    char_code_nxt = player2_name[11];
                                else
                                    char_code_nxt = player1_name[11];
                            8'hb0: 
                                if(active_player)
                                    char_code_nxt = player2_name[12];
                                else
                                    char_code_nxt = player1_name[12];
                            8'hc0: 
                               if(active_player)
                                    char_code_nxt = player2_name[13];
                                else
                                    char_code_nxt = player1_name[13];
                            8'hd0: 
                                if(active_player)
                                    char_code_nxt = player2_name[14];
                                else
                                    char_code_nxt = player1_name[14];
                            8'he0: 
                                if(active_player)
                                    char_code_nxt = player2_name[15];
                                else
                                    char_code_nxt = player1_name[15];

                            8'h01: char_code_nxt = Y;
                            8'h11: char_code_nxt = o;  
                            8'h21: char_code_nxt = u;
                            8'h41: 
                                if(hit_ship)
                                    char_code_nxt = h;
                                else
                                    char_code_nxt = m;
                            8'h51: 
                                if(hit_ship)
                                    char_code_nxt = i;
                                else
                                    char_code_nxt = i;
                            8'h61: 
                                if(hit_ship)
                                    char_code_nxt = t;
                                else
                                    char_code_nxt = s;
                            8'h71: 
                                if(hit_ship)
                                    char_code_nxt = 0;
                                else
                                    char_code_nxt = s;                                    
                            8'h81: 
                                if(hit_ship)
                                    char_code_nxt = a;
                                else
                                    char_code_nxt = e;
                            8'h91: 
                                if(hit_ship)
                                    char_code_nxt = 0;
                                else
                                    char_code_nxt = d;
                            8'ha1: 
                                if(hit_ship)
                                    char_code_nxt = s;  
                                else
                                    char_code_nxt = 0;                
                            8'hb1: 
                                if(hit_ship)
                                    char_code_nxt = h;
                                else
                                    char_code_nxt = 0;
                            8'hc1: 
                                if(hit_ship)
                                    char_code_nxt = i;
                                else
                                    char_code_nxt = 0;
                            8'hd1: 
                                if(hit_ship)
                                    char_code_nxt = p;
                                else
                                    char_code_nxt = 0;
                            8'he1: 
                                if(hit_ship)
                                    char_code_nxt = 33; // !  
                                else
                                    char_code_nxt = 0;
                                    
                            8'h02: char_code_nxt = Y;         
                            8'h12: char_code_nxt = o;  
                            8'h22: char_code_nxt = u;
                            8'h42: char_code_nxt = f;
                            8'h52: char_code_nxt = o;
                            8'h62: char_code_nxt = u;
                            8'h72: char_code_nxt = n;
                            8'h82: char_code_nxt = d;  
                            8'h92: char_code_nxt = 58; // :                                  
                            8'hb2: 
                                if(active_player)
                                begin
                                    if(hit_ships2 >= 10)
                                        char_code_nxt = 48+(hit_ships2)/10;
                                else
                                        char_code_nxt = 48+hit_ships2;
                                end
                                else
                                begin
                                    if(hit_ships1 >= 10)
                                        char_code_nxt = 48+(hit_ships1)/10;
                                    else
                                        char_code_nxt = 48+hit_ships1;
                                end                                   
                            8'hc2: 
                                if(active_player)
                                begin
                                    if(hit_ships2 >= 10)
                                        char_code_nxt = 48+(hit_ships2)%10;
                                    else
                                        char_code_nxt = 47; // /
                                end
                                else
                                begin
                                    if(hit_ships1 >= 10)
                                        char_code_nxt = 48+(hit_ships1)%10;
                                    else
                                        char_code_nxt = 47; // /
                                end      
                            8'hd2: 
                                if(active_player)
                                begin
                                    if(hit_ships2 >= 10)
                                        char_code_nxt = 47; // / 
                                    else
                                        char_code_nxt = 48+ships_to_hit/10;
                                end
                                else
                                begin
                                    if(hit_ships1 >= 10)
                                        char_code_nxt = 47; // / 
                                    else
                                        char_code_nxt = 48+ships_to_hit/10;
                                end
                            8'he2: 
                                if(active_player)
                                begin
                                   if(hit_ships2 >= 10)
                                       char_code_nxt = 48+ships_to_hit/10; 
                                   else
                                       char_code_nxt = 48+ships_to_hit%10;
                                end
                                else
                                begin
                                    if(hit_ships1 >= 10)
                                        char_code_nxt = 48+ships_to_hit/10; 
                                    else
                                        char_code_nxt = 48+ships_to_hit%10;
                                end                             
                            8'hf2: 
                                if(active_player)
                                begin
                                    if(hit_ships2 >= 10)
                                        char_code_nxt = 48+ships_to_hit%10; 
                                    else
                                        char_code_nxt = 0;
                                end
                                else
                                begin
                                    if(hit_ships1 >= 10)
                                        char_code_nxt = 48+ships_to_hit%10; 
                                    else
                                        char_code_nxt = 0;
                                end
                            8'h03: char_code_nxt = s;         
                            8'h13: char_code_nxt = h;  
                            8'h23: char_code_nxt = i;
                            8'h33: char_code_nxt = p;
                            8'h43: char_code_nxt = s;
                            
                            8'h04: 
                                if(!active_player)
                                    char_code_nxt = player2_name[1]; 
                                else
                                    char_code_nxt = player1_name[1];
                            8'h14: 
                                if(!active_player)
                                    char_code_nxt = player2_name[2];
                                else
                                    char_code_nxt = player1_name[2];
                            8'h24:  
                                if(!active_player)
                                    char_code_nxt = player2_name[3];
                                else
                                    char_code_nxt = player1_name[3];
                            8'h34: 
                                if(!active_player)
                                    char_code_nxt = player2_name[4];
                                else
                                    char_code_nxt = player1_name[4];
                            8'h44: 
                                if(!active_player)
                                    char_code_nxt = player2_name[5];
                                else
                                    char_code_nxt = player1_name[5];
                            8'h54: 
                                if(!active_player)
                                    char_code_nxt = player2_name[6];
                                else
                                    char_code_nxt = player1_name[6];
                            8'h64: 
                                if(!active_player)
                                    char_code_nxt = player2_name[7];
                                else
                                    char_code_nxt = player1_name[7];
                            8'h74: 
                                if(!active_player)
                                    char_code_nxt = player2_name[8];
                                else
                                    char_code_nxt = player1_name[8];
                            8'h84: 
                                if(!active_player)
                                    char_code_nxt = player2_name[9];
                                else
                                    char_code_nxt = player1_name[9];
                            8'h94:  
                                if(!active_player)
                                    char_code_nxt = player2_name[10];
                                else
                                    char_code_nxt = player1_name[10];
                            8'ha4: 
                                if(!active_player)
                                    char_code_nxt = player2_name[11];
                                else
                                    char_code_nxt = player1_name[11];
                            8'hb4: 
                                if(!active_player)
                                    char_code_nxt = player2_name[12];
                                else
                                    char_code_nxt = player1_name[12];
                            8'hc4: 
                                if(!active_player)
                                    char_code_nxt = player2_name[13];
                                else
                                    char_code_nxt = player1_name[13];
                            8'hd4: 
                                if(!active_player)
                                    char_code_nxt = player2_name[14];
                                else
                                    char_code_nxt = player1_name[14];
                            8'he4:  
                                if(!active_player)
                                    char_code_nxt = player2_name[15];
                                else
                                    char_code_nxt = player1_name[15];
                                    
                            8'h05: char_code_nxt = f;
                            8'h15: char_code_nxt = o;
                            8'h25: char_code_nxt = u;
                            8'h35: char_code_nxt = n;
                            8'h45: char_code_nxt = d;  
                            8'h55: char_code_nxt = 58; // : 
                            8'h75:
                                if(!active_player)
                                begin
                                    if(hit_ships2 >= 10)
                                        char_code_nxt = 48+(hit_ships2)/10;
                                else
                                        char_code_nxt = 48+hit_ships2;
                                end
                                else
                                begin
                                    if(hit_ships1 >= 10)
                                        char_code_nxt = 48+(hit_ships1)/10;
                                    else
                                        char_code_nxt = 48+hit_ships1;
                                end                                   
                            8'h85: 
                                if(!active_player)
                                begin
                                    if(hit_ships2 >= 10)
                                        char_code_nxt = 48+(hit_ships2)%10;
                                    else
                                        char_code_nxt = 47; // /
                                end
                                else
                                begin
                                    if(hit_ships1 >= 10)
                                        char_code_nxt = 48+(hit_ships1)%10;
                                    else
                                        char_code_nxt = 47; // /
                                end      
                            8'h95: 
                                if(!active_player)
                                begin
                                    if(hit_ships2 >= 10)
                                        char_code_nxt = 47; // / 
                                    else
                                        char_code_nxt = 48+ships_to_hit/10;
                                end
                                else
                                begin
                                    if(hit_ships1 >= 10)
                                        char_code_nxt = 47; // / 
                                    else
                                        char_code_nxt = 48+ships_to_hit/10;
                                end
                            8'ha5: 
                                if(!active_player)
                                begin
                                    if(hit_ships2 >= 10)
                                        char_code_nxt = 48+ships_to_hit/10; 
                                else
                                        char_code_nxt = 48+ships_to_hit%10;
                                end
                                else
                                begin
                                    if(hit_ships1 >= 10)
                                        char_code_nxt = 48+ships_to_hit/10; 
                                    else
                                        char_code_nxt = 48+ships_to_hit%10;
                                end                             
                            8'hb5: 
                                if(!active_player)
                                begin
                                    if(hit_ships2 >= 10)
                                        char_code_nxt = 48+ships_to_hit%10; 
                                    else
                                        char_code_nxt = 0;
                                end
                                else
                                begin
                                    if(hit_ships1 >= 10)
                                        char_code_nxt = 48+ships_to_hit%10; 
                                    else
                                        char_code_nxt = 0;
                                end
                            8'h06: char_code_nxt = s;         
                            8'h16: char_code_nxt = h;  
                            8'h26: char_code_nxt = i;
                            8'h36: char_code_nxt = p;
                            8'h46: char_code_nxt = s;
                            8'h07: char_code_nxt = R;         
                            8'h17: char_code_nxt = i;  
                            8'h27: char_code_nxt = g;
                            8'h37: char_code_nxt = h;
                            8'h47: char_code_nxt = t;
                            8'h57: char_code_nxt = c;
                            8'h67: char_code_nxt = l;
                            8'h77: char_code_nxt = i;  
                            8'h87: char_code_nxt = c;
                            8'h97: char_code_nxt = k;
                            8'hb7: char_code_nxt = t;
                            8'hc7: char_code_nxt = o;     
                            8'h08: char_code_nxt = f;         
                            8'h18: char_code_nxt = i;  
                            8'h28: char_code_nxt = n;
                            8'h38: char_code_nxt = i;
                            8'h48: char_code_nxt = s;   
                            8'h58: char_code_nxt = h;         
                            8'h78: char_code_nxt = m;  
                            8'h88: char_code_nxt = o;
                            8'h98: char_code_nxt = v;
                            8'ha8: char_code_nxt = e; 
                            default: char_code_nxt = 0;
                        endcase                                                                                      
                    end
                end                      
            end
            // */
            GAME_ENDING:
            begin
                case(char_xy) // Player1/2 Press ENTER when ready to start a move
                    8'h00: 
                        if(active_player)
                            char_code_nxt = player2_name[1]; 
                        else
                            char_code_nxt = player1_name[1];
                    8'h10: 
                        if(active_player)
                            char_code_nxt = player2_name[2];
                        else
                            char_code_nxt = player1_name[2];
                    8'h20:  
                        if(active_player)
                            char_code_nxt = player2_name[3];
                        else
                            char_code_nxt = player1_name[3];
                    8'h30: 
                        if(active_player)
                            char_code_nxt = player2_name[4];
                        else
                            char_code_nxt = player1_name[4];
                    8'h40: 
                        if(active_player)
                            char_code_nxt = player2_name[5];
                        else
                            char_code_nxt = player1_name[5];
                    8'h50: 
                        if(active_player)
                            char_code_nxt = player2_name[6];
                        else
                            char_code_nxt = player1_name[6];
                    8'h60: 
                        if(active_player)
                            char_code_nxt = player2_name[7];
                        else
                            char_code_nxt = player1_name[7];
                    8'h70: 
                        if(active_player)
                            char_code_nxt = player2_name[8];
                        else
                            char_code_nxt = player1_name[8];
                    8'h80: 
                        if(active_player)
                            char_code_nxt = player2_name[9];
                        else
                            char_code_nxt = player1_name[9];
                    8'h90:  
                        if(active_player)
                            char_code_nxt = player2_name[10];
                        else
                            char_code_nxt = player1_name[10];
                    8'ha0: 
                        if(active_player)
                            char_code_nxt = player2_name[11];
                        else
                            char_code_nxt = player1_name[11];
                    8'hb0: 
                        if(active_player)
                            char_code_nxt = player2_name[12];
                        else
                            char_code_nxt = player1_name[12];
                    8'hc0: 
                        if(active_player)
                            char_code_nxt = player2_name[13];
                        else
                            char_code_nxt = player1_name[13];
                    8'hd0: 
                        if(active_player)
                            char_code_nxt = player2_name[14];
                        else
                            char_code_nxt = player1_name[14];
                    8'he0:  
                        if(active_player)
                            char_code_nxt = player2_name[15];
                        else
                            char_code_nxt = player1_name[15];
                                                      
                    8'h01: char_code_nxt = Y;
                    8'h11: char_code_nxt = o;  
                    8'h21: char_code_nxt = u;
                    8'h41: char_code_nxt = w;
                    8'h51: char_code_nxt = o;
                    8'h61: char_code_nxt = n;
                    8'h71: char_code_nxt = 33; // !
                    8'h03: char_code_nxt = T;
                    8'h13: char_code_nxt = o;  
                    8'h33: char_code_nxt = s;
                    8'h43: char_code_nxt = t;
                    8'h53: char_code_nxt = a;
                    8'h63: char_code_nxt = r;
                    8'h73: char_code_nxt = t;
                    8'h93: char_code_nxt = a;  
                    8'h04: char_code_nxt = r;
                    8'h14: char_code_nxt = e;
                    8'h24: char_code_nxt = m;
                    8'h34: char_code_nxt = a; 
                    8'h44: char_code_nxt = t;
                    8'h54: char_code_nxt = c;
                    8'h64: char_code_nxt = h;
                    8'h84: char_code_nxt = s;  
                    8'h94: char_code_nxt = w;
                    8'ha4: char_code_nxt = i;
                    8'hb4: char_code_nxt = t;
                    8'hc4: char_code_nxt = c;
                    8'hd4: char_code_nxt = h;
                    8'h05: char_code_nxt = o;
                    8'h15: char_code_nxt = n;
                    8'h35: char_code_nxt = a;  
                    8'h45: char_code_nxt = n;
                    8'h55: char_code_nxt = d;
                    8'h75: char_code_nxt = o;  
                    8'h85: char_code_nxt = f;
                    8'h95: char_code_nxt = f;
                    8'h06: char_code_nxt = b;
                    8'h16: char_code_nxt = u;
                    8'h26: char_code_nxt = t;
                    8'h36: char_code_nxt = t;  
                    8'h46: char_code_nxt = o;
                    8'h56: char_code_nxt = n;
                    8'h76: char_code_nxt = V;
                    8'h86: char_code_nxt = ZERO+1;
                    8'h96: char_code_nxt = ZERO+7;
                    default: char_code_nxt = 0;                   
                endcase           
            end            
        endcase     
    end
endmodule  
