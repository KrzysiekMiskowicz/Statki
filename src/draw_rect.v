`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Module Name: draw_game
// Project Name: Statki
// Description: Modu³ wyœwietla ró¿ne obiekty na ekranie (zaznaczone statki, przyciski, itp.), w odpowiedzi na sygna³y wysy³ane przez graczy 
//////////////////////////////////////////////////////////////////////////////////

    module draw_game (
    input wire clk,
    input wire rst,
    input wire [3:0] program_state,
    input wire [11:0] mouse_xpos,
    input wire [11:0] mouse_ypos,
    input wire active_player,
    input wire [2:0] players_ships1x,
    input wire [2:0] players_ships2x,
    input wire [2:0] players_ships3x,
    input wire [2:0] players_ships4x,
    input wire [2:0] players_ships5x,
    input wire [1:0] place_ship_state,
    input wire [2:0] clicked_ship,
    input wire [63:0] player1_placing_board,
    input wire [63:0] player2_placing_board,
    input wire [63:0] player1_findings_board,
    input wire [63:0] player2_findings_board,
    input wire [10:0] hcount_in,
    input wire hsync_in,
    input wire hblnk_in,
    input wire [10:0] vcount_in,
    input wire vsync_in,
    input wire vblnk_in,
    input wire [11:0] rgb_in,
    output reg [10:0] hcount_out,
    output reg hsync_out,
    output reg hblnk_out,
    output reg [10:0] vcount_out,
    output reg vsync_out,
    output reg vblnk_out,
    output reg [11:0] rgb_out
    );
    
    // modu³ przechowuje informacje o stanie plansz zawodników
    reg [11:0] rgb_out_nxt;
        
    // integers in for loop (PLACING SHIPS) 
    integer rows_counter, columns_counter, square_index;
    
    
    // program states
    localparam IDLE = 4'b0000;
    localparam CHOSING_BOARD_SIZE = 4'b0001;
    localparam CHOSING_PLAYERS = 4'b0010;
    localparam PLACING_SHIPS = 4'b0011;
    localparam FINDING_SHIPS = 4'b0100;
    localparam SCREEN_BLANKING = 4'b0101;
    localparam GAME_ENDING = 4'b0110;
  
    localparam BUTTONS_WIDTH = 200;
    localparam BUTTONS_LENGTH = 100;
    localparam BUTTONS_YPOS = 250;
    localparam BUTTON1_XPOS = 50; 
    localparam BUTTON2_XPOS = 300;
    localparam BUTTON3_XPOS = 550;  
    
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
    
    // place_ship_state
    localparam NO_ACTION = 2'b00;
    localparam VERTICAL = 2'b10;
    localparam HORIZONTAL = 2'b11;
        
    always @(posedge clk)
    begin
        if(rst) // reset
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
        begin
            hcount_out <= hcount_in;
            hsync_out  <= hsync_in;
            hblnk_out  <= hblnk_in;
            vcount_out <= vcount_in;
            vsync_out  <= vsync_in;
            vblnk_out  <= vblnk_in;
            rgb_out    <= rgb_out_nxt;          
        end
    end

    always @*
    begin
        rgb_out_nxt = rgb_in; 
        case(program_state)
            CHOSING_BOARD_SIZE:
            begin
                if((hcount_in >= BUTTON1_XPOS) && (hcount_in < BUTTON1_XPOS+BUTTONS_WIDTH) && (vcount_in >= BUTTONS_YPOS) && (vcount_in < BUTTONS_YPOS+BUTTONS_LENGTH)) 
                    rgb_out_nxt = 12'h4_4_0;
                else if((hcount_in >= BUTTON2_XPOS) && (hcount_in < BUTTON2_XPOS+BUTTONS_WIDTH) && (vcount_in >= BUTTONS_YPOS) && (vcount_in < BUTTONS_YPOS+BUTTONS_LENGTH)) 
                    rgb_out_nxt = 12'h4_4_0;
                else if((hcount_in >= BUTTON3_XPOS) && (hcount_in < BUTTON3_XPOS+BUTTONS_WIDTH) && (vcount_in >= BUTTONS_YPOS) && (vcount_in < BUTTONS_YPOS+BUTTONS_LENGTH)) 
                    rgb_out_nxt = 12'h4_4_0;    
            end       
            PLACING_SHIPS:
            begin // rysujemy statki, które zosta³y do rozmieszczenia na planszy 
                if((hcount_in >= SHIP_5X_XPOS) && (hcount_in < SHIP_5X_XPOS+SQUARE_SIZE) && (vcount_in >= SHIPS_YPOS-5*SQUARE_SIZE) && (vcount_in < SHIPS_YPOS) && (players_ships5x != 0))
                begin 
                    if(clicked_ship == 5)
                        rgb_out_nxt = 12'h0_a_0;
                    else                   
                        rgb_out_nxt = 12'h0_0_a; // statki piêcioelementowe 
                end
                else if((hcount_in >= SHIP_4X_XPOS) && (hcount_in < SHIP_4X_XPOS+SQUARE_SIZE) && (vcount_in >= SHIPS_YPOS-4*SQUARE_SIZE) && (vcount_in < SHIPS_YPOS) && (players_ships4x != 0))
                begin
                    if(clicked_ship == 4)
                        rgb_out_nxt = 12'h0_a_0;
                    else
                        rgb_out_nxt = 12'h0_0_a;  // statki czteroelementowe 
                end
                else if((hcount_in >= SHIP_3X_XPOS) && (hcount_in < SHIP_3X_XPOS+SQUARE_SIZE) && (vcount_in >= SHIPS_YPOS-3*SQUARE_SIZE) && (vcount_in < SHIPS_YPOS) && (players_ships3x != 0))
                begin
                    if(clicked_ship == 3)
                        rgb_out_nxt = 12'h0_a_0;
                    else
                        rgb_out_nxt = 12'h0_0_a;  // statki trzyelementowe 
                end
                else if((hcount_in >= SHIP_2X_XPOS) && (hcount_in < SHIP_2X_XPOS+SQUARE_SIZE) && (vcount_in >= SHIPS_YPOS-2*SQUARE_SIZE) && (vcount_in < SHIPS_YPOS) && (players_ships2x != 0))
                begin
                    if(clicked_ship == 2)
                        rgb_out_nxt = 12'h0_a_0;
                    else
                        rgb_out_nxt = 12'h0_0_a;  // statki dwuelementowe
                end
                else if((hcount_in >= SHIP_1X_XPOS) && (hcount_in < SHIP_1X_XPOS+SQUARE_SIZE) && (vcount_in >= SHIPS_YPOS-SQUARE_SIZE) && (vcount_in < SHIPS_YPOS) && (players_ships1x != 0))
                begin
                    if(clicked_ship == 1)
                        rgb_out_nxt = 12'h0_a_0;
                    else
                        rgb_out_nxt = 12'h0_0_a;  // statki jednoelementowe
                end
                if((vcount_in < SHIPS_YPOS) && ((SHIPS_YPOS - vcount_in)%SQUARE_SIZE == 0)) 
                    rgb_out_nxt = rgb_in;     // tworzymy kwadraty, maj¹ce przypominaæ statki
                if(active_player)    // zaznaczamy na planszy zaznaczone wczeœniej statki
                begin
                    for(rows_counter = 0; rows_counter < 8; rows_counter=rows_counter+1) // zapêtlony pdowójnie for
                    begin
                        for(columns_counter = 0; columns_counter < 8; columns_counter=columns_counter+1)
                        begin
                            if(player2_placing_board[rows_counter+8*columns_counter] == 1)
                            begin
                                if((hcount_in >= BOARD_XPOS+rows_counter*SQUARE_SIZE+SQUARE_SIZE/4) && (hcount_in < BOARD_XPOS+rows_counter*SQUARE_SIZE+(SQUARE_SIZE/4)*3) && (vcount_in >= BOARD_YPOS+columns_counter*SQUARE_SIZE+SQUARE_SIZE/4) && (vcount_in < BOARD_YPOS+columns_counter*SQUARE_SIZE+(SQUARE_SIZE/4)*3))
                                    rgb_out_nxt = 12'h4_6_b; // rysowanie po³o¿onych wczeœniej statków
                            end
                        end
                    end
                end
                else
                begin
                    for(rows_counter = 0; rows_counter < 8; rows_counter=rows_counter+1) // zapêtlony pdowójnie for
                    begin
                        for(columns_counter = 0; columns_counter < 8; columns_counter=columns_counter+1)
                        begin
                            if(player1_placing_board[rows_counter+8*columns_counter] == 1)
                            begin
                                if((hcount_in >= BOARD_XPOS+rows_counter*SQUARE_SIZE+SQUARE_SIZE/4) && (hcount_in < BOARD_XPOS+rows_counter*SQUARE_SIZE+(SQUARE_SIZE/4)*3) && (vcount_in >= BOARD_YPOS+columns_counter*SQUARE_SIZE+SQUARE_SIZE/4) && (vcount_in < BOARD_YPOS+columns_counter*SQUARE_SIZE+(SQUARE_SIZE/4)*3))
                                    rgb_out_nxt = 12'h4_6_b; // rysowanie po³o¿onych wczeœniej statków
                            end
                        end
                    end
                end
                case(place_ship_state)   // tworzenie statków które pod¹¿aj¹ za myszk¹ podczas ustawiania statków na planszy
                    VERTICAL:       // statki pionowe
                    begin
                        if((hcount_in >= mouse_xpos) && (hcount_in < mouse_xpos+SQUARE_SIZE) && (vcount_in >= mouse_ypos) && (vcount_in < mouse_ypos+clicked_ship*SQUARE_SIZE))
                           rgb_out_nxt = 12'h0_a_0;                     
                    end
                    HORIZONTAL:     // statki poziome
                    begin
                        if((hcount_in >= mouse_xpos) && (hcount_in < mouse_xpos+clicked_ship*SQUARE_SIZE) && (vcount_in >= mouse_ypos) && (vcount_in < mouse_ypos+SQUARE_SIZE))
                            rgb_out_nxt = 12'h0_a_0;                         
                    end
                    default:        // nie naciœniêto na ¿aden statek do ustawienia
                        rgb_out_nxt = rgb_out_nxt;
                endcase
            end
            SCREEN_BLANKING:
            begin
                rgb_out_nxt = 12'h0_0_0;
            end
            FINDING_SHIPS:
            begin  
                for(square_index = 0; square_index < 64; square_index=square_index+1) // zapêtlony pdowójnie for
                begin
                    if(active_player)
                    begin      
                        if((player1_placing_board[square_index] == 1) && (player2_findings_board[square_index] == 1))
                        begin
                            if((hcount_in >= BOARD_XPOS+(square_index%8)*SQUARE_SIZE+SQUARE_SIZE/4) && (hcount_in < BOARD_XPOS+(square_index%8)*SQUARE_SIZE+(SQUARE_SIZE/4)*3) && (vcount_in >= BOARD_YPOS+(square_index/8)*SQUARE_SIZE+SQUARE_SIZE/4) && (vcount_in < BOARD_YPOS+(square_index/8)*SQUARE_SIZE+(SQUARE_SIZE/4)*3))
                                rgb_out_nxt = 12'h1_d_3; // rysowanie trafionych strza³ów do statków
                        end
                        else if((player1_placing_board[square_index] == 0) && (player2_findings_board[square_index] == 1))
                        begin
                            if((hcount_in >= BOARD_XPOS+(square_index%8)*SQUARE_SIZE+SQUARE_SIZE/4) && (hcount_in < BOARD_XPOS+(square_index%8)*SQUARE_SIZE+(SQUARE_SIZE/4)*3) && (vcount_in >= BOARD_YPOS+(square_index/8)*SQUARE_SIZE+SQUARE_SIZE/4) && (vcount_in < BOARD_YPOS+(square_index/8)*SQUARE_SIZE+(SQUARE_SIZE/4)*3))
                                rgb_out_nxt = 12'h5_1_c;// rysowanie pude³                      
                        end
                    end                        
                    else
                    begin      
                        if((player2_placing_board[square_index] == 1) && (player1_findings_board[square_index] == 1))
                        begin
                            if((hcount_in >= BOARD_XPOS+(square_index%8)*SQUARE_SIZE+SQUARE_SIZE/4) && (hcount_in < BOARD_XPOS+(square_index%8)*SQUARE_SIZE+(SQUARE_SIZE/4)*3) && (vcount_in >= BOARD_YPOS+(square_index/8)*SQUARE_SIZE+SQUARE_SIZE/4) && (vcount_in < BOARD_YPOS+(square_index/8)*SQUARE_SIZE+(SQUARE_SIZE/4)*3))
                                rgb_out_nxt = 12'h1_d_3; // rysowanie trafionych strza³ów do statków
                        end
                        else if((player2_placing_board[square_index] == 0) && (player1_findings_board[square_index] == 1))
                        begin
                            if((hcount_in >= BOARD_XPOS+(square_index%8)*SQUARE_SIZE+SQUARE_SIZE/4) && (hcount_in < BOARD_XPOS+(square_index%8)*SQUARE_SIZE+(SQUARE_SIZE/4)*3) && (vcount_in >= BOARD_YPOS+(square_index/8)*SQUARE_SIZE+SQUARE_SIZE/4) && (vcount_in < BOARD_YPOS+(square_index/8)*SQUARE_SIZE+(SQUARE_SIZE/4)*3))
                                rgb_out_nxt = 12'h5_1_c;// rysowanie pude³                      
                        end
                    end
                end
            end
            default:
                rgb_out_nxt = rgb_in;
        endcase
    end
endmodule
