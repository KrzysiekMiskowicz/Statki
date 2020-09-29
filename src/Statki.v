`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Module Name: Ships
// Project Name: Ships
// Description: Plik top projektu, bêdzie odpowiada³ za ³¹czenie siê Basysem oraz komunikowanie siê ze sob¹ modu³ów
//////////////////////////////////////////////////////////////////////////////////

module Ships(
    input wire clk,
    input wire rst,
    input wire play_game,
    input wire rx,
    inout wire ps2_clk,
    inout wire ps2_data,
    output reg vs,
    output reg hs,
    output reg [3:0] r,
    output reg [3:0] g,
    output reg [3:0] b
    );
    
    wire locked, clk40MHz, clk100MHz;  
// Modu³ odpowiada za tworzewnie sygna³ów zegarowych o czêstotliwoœci 40MHz oraz 100MHz. Oba sygna³y dostarczane s¹ nastêpnie do wszystkich modu³ów w projekcie        
    clk_wiz_0 clk_generator (
        .clk(clk),
        .reset(rst),
        .clk100MHz(clk100MHz),
        .clk40MHz(clk40MHz),
        .locked(locked)
    );
      
    wire left_out_MouseCtl, right_out_MouseCtl, mouse_ctrl;
    wire [11:0] xpos_out_MouseCtl, ypos_out_MouseCtl, max_mouse_value;
// Modu³ odpowiada za obs³ugiwanie sygna³ów od myszki - wspó³rzêdne x i y, prawy oraz lewy przycisk
    MouseCtl my_Mouse (
        .clk(clk40MHz),
        .ps2_clk(ps2_clk),
        .ps2_data(ps2_data),
        .xpos(xpos_out_MouseCtl),
        .ypos(ypos_out_MouseCtl),
        .rst(rst),
        .value(max_mouse_value),
        .setx(1'b0),
        .sety(1'b0),
        .setmax_x(!mouse_ctrl),
        .setmax_y(mouse_ctrl),
        .zpos(),
        .left(left_out_MouseCtl),
        .middle(),
        .right(right_out_MouseCtl),
        .new_event()    
    );
    
    wire tx, uart_data_enable;
    wire [7:0] uart_data;
    uart_communication my_uart (
        .clk(clk100MHz),
        .rst(rst),
        .rx(rx),
        .tx(tx),
        .data_enable(uart_data_enable),
        .uart_data(uart_data)
    );
    
    wire [7:0] uart_buffered_data_out;
    wire uart_buffer_data_enable_out;
    uart_buffer my_uart_buffer (
        .input_clk(clk100MHz),
        .output_clk(clk40MHz),
        .rst(rst),
        .uart_data_enable(uart_data_enable),
        .uart_data(uart_data),
        .uart_buffer_data_enable(uart_buffer_data_enable_out),
        .uart_buffered_data(uart_buffered_data_out)
    );
     
    wire [63:0] player1_placing_board, player2_placing_board, player1_findings_board, player2_findings_board;
    wire [7:0] program_uart_data_out;
    wire [4:0] hit_ships1, hit_ships2, ships_to_hit;
    wire [3:0] program_state, program_uart_data_out_counter, finding_rows_counter, finding_columns_counter;
    wire [3:0] board_size;
    wire warning, place_ships_warning, find_ships_warning, program_uart_data_enable_out, active_player, finished_move_placing, finished_move_finding, active_move_finding, hit_ship;
    wire [1:0] place_ship_state;
// Modu³ ma za zadanie byæ "procesorem" programu. Jako sygna³y wejœciowe otrzymuje przyciski z p³ytki oraz myszkê. Na ich podstawie
// wyznacza stan do którego bêdzie przechodzi³ program
    ProgramData my_ProgramData (
        .clk(clk40MHz),
        .rst(rst),
        .mouse_ctrl(mouse_ctrl),
        .max_mouse_value(max_mouse_value),
        .play_game(play_game),
        .mouse_xpos(xpos_out_MouseCtl),
        .mouse_ypos(ypos_out_MouseCtl),
        .mouse_left_tick(left_out_MouseCtl),
        .mouse_right_tick(right_out_MouseCtl),
        .uart_data_enable_in(uart_buffer_data_enable_out),
        .uart_data_in(uart_buffered_data_out),
        .program_state(program_state),
        .warning(warning),
        .place_ships_warning(place_ships_warning),
        .find_ships_warning(find_ships_warning),
        .finished_move_placing(finished_move_placing),
        .finished_move_finding(finished_move_finding),
        .active_move_finding(active_move_finding),
        .active_player(active_player),
        .board_size(board_size),
        .player1_placing_board(player1_placing_board),
        .player2_placing_board(player2_placing_board),
        .finding_rows_counter(finding_rows_counter),
        .finding_columns_counter(finding_columns_counter),
        .uart_data_enable_out(program_uart_data_enable_out),
        .uart_data_out(program_uart_data_out),
        .uart_data_counter(program_uart_data_out_counter),
        .hit_ship(hit_ship),
        .hit_ships1(hit_ships1),
        .hit_ships2(hit_ships2),
        .ships_to_hit(ships_to_hit)
    );

    wire [2:0] players_ships1x, players_ships2x, players_ships3x, players_ships4x, players_ships5x, clicked_ship;
// Modu³ odpowiada za umiejscowienie statków na planszy    
    place_ships my_ships (
        .clk(clk40MHz),
        .rst(rst),
        .mouse_xpos(xpos_out_MouseCtl),
        .mouse_ypos(ypos_out_MouseCtl),
        .mouse_left_tick(left_out_MouseCtl),
        .mouse_right_tick(right_out_MouseCtl),
        .program_state(program_state),
        .warning(place_ships_warning),
        .board_size(board_size),
        .players_ships1x(players_ships1x),
        .players_ships2x(players_ships2x),
        .players_ships3x(players_ships3x),
        .players_ships4x(players_ships4x),
        .players_ships5x(players_ships5x),
        .clicked_ship(clicked_ship),
        .active_player(active_player),
        .place_ship_state(place_ship_state),
        .player1_board(player1_placing_board),
        .player2_board(player2_placing_board),
        .finished_move(finished_move_placing)        
    );
    
// Modu³ odpowiada za odnajdywanie statków na planszy
    find_ships my_findings (
        .clk(clk40MHz),
        .rst(rst),
        .mouse_xpos(xpos_out_MouseCtl),
        .mouse_ypos(ypos_out_MouseCtl),
        .mouse_left_tick(left_out_MouseCtl),
        .mouse_right_tick(right_out_MouseCtl),
        .program_state(program_state),
        .board_size(board_size),
        .warning(find_ships_warning),
        .active_player(active_player),
        .player1_board(player1_findings_board),
        .player2_board(player2_findings_board),
        .rows_counter(finding_rows_counter),
        .columns_counter(finding_columns_counter),
        .active_move(active_move_finding),
        .finished_move(finished_move_finding)
    );
    
    wire [10:0] vcount_out_timing, hcount_out_timing;
    wire vsync_out_timing, hsync_out_timing;
    wire vblnk_out_timing, hblnk_out_timing;    
// Modu³ obs³uguje podstawowe operacje  pikseli na ekranie - wyznacza sygna³y, które poŸniej s¹ przetwarzane przez kolejne modu³y i wyœwietlane 
// na ekranie (hcount, vcount) oraz sygna³y steruj¹ce, odpowiadaj¹ce za synchronizacjê ekranu z pikselami (vsync, vblnk, hsync, hblnk) 
    vga_timing my_timing (
        .clk(clk40MHz),
        .rst(rst),
        .vcount(vcount_out_timing),
        .vsync(vsync_out_timing),
        .vblnk(vblnk_out_timing),
        .hcount(hcount_out_timing),
        .hsync(hsync_out_timing),
        .hblnk(hblnk_out_timing)
    );
            
    wire [10:0] hcount_out_background, vcount_out_background;
    wire hsync_out_background, vsync_out_background;
    wire hblnk_out_background, vblnk_out_background;
    wire [11:0] rgb_out_background;     
// Modu³ obs³uguje rysowanie t³a na ekranie (planszy). Otrzymane sygna³y pikseli od modu³u timing zostaj¹ wstêpnie pokolorwane, a sygna³y steruj¹ce zinkrementowane. 
// Wszytskie sygna³y id¹ wspólnie do nastêpnego modu³u przetwarzaj¹cego piksele
    draw_background my_background (
        .clk(clk40MHz),
        .rst(rst),
        .program_state(program_state),
        .hcount_in(hcount_out_timing),
        .hsync_in(hsync_out_timing),
        .hblnk_in(hblnk_out_timing),
        .vcount_in(vcount_out_timing),
        .vsync_in(vsync_out_timing),
        .vblnk_in(vblnk_out_timing),
        .board_size_in(board_size),
        .hcount_out(hcount_out_background),
        .hsync_out(hsync_out_background),
        .hblnk_out(hblnk_out_background),
        .vcount_out(vcount_out_background),
        .vsync_out(vsync_out_background),
        .vblnk_out(vblnk_out_background),
        .rgb_out(rgb_out_background)
    ); 
      
    wire [10:0] hcount_out_game, vcount_out_game;
    wire hsync_out_game, vsync_out_game;
    wire hblnk_out_game, vblnk_out_game;
    wire [11:0] rgb_out_game;
// Modu³ wyœwietla ró¿ne obiekty na ekranie (zaznaczone statki, przyciski, itp.), w odpowiedzi na sygna³y wysy³ane przez graczy 
    draw_game my_game (
        .clk(clk40MHz),
        .rst(rst),
        .mouse_xpos(xpos_out_MouseCtl),
        .mouse_ypos(ypos_out_MouseCtl),
        .program_state(program_state),
        .active_player(active_player),
        .players_ships1x(players_ships1x),
        .players_ships2x(players_ships2x),
        .players_ships3x(players_ships3x),
        .players_ships4x(players_ships4x),
        .players_ships5x(players_ships5x),
        .place_ship_state(place_ship_state),
        .clicked_ship(clicked_ship),
        .player1_placing_board(player1_placing_board),
        .player2_placing_board(player2_placing_board),
        .player1_findings_board(player1_findings_board),
        .player2_findings_board(player2_findings_board),
        .hcount_in(hcount_out_background),
        .hsync_in(hsync_out_background),
        .hblnk_in(hblnk_out_background),
        .vcount_in(vcount_out_background),
        .vsync_in(vsync_out_background),
        .vblnk_in(vblnk_out_background),
        .rgb_in(rgb_out_background),
        .hcount_out(hcount_out_game),
        .hsync_out(hsync_out_game),
        .hblnk_out(hblnk_out_game),
        .vcount_out(vcount_out_game),
        .vsync_out(vsync_out_game),
        .vblnk_out(vblnk_out_game),
        .rgb_out(rgb_out_game)
    );
    
    wire [10:0] hcount_out_char, vcount_out_char;
    wire hsync_out_char, vsync_out_char;
    wire hblnk_out_char, vblnk_out_char;
    wire [11:0] rgb_out_char;   
    wire [7:0] char_xy, char_pixels;
    wire [3:0] char_line;
// Modu³ odpowiada za wyœwietlanie wiadomoœci o stanie programu na ekran
    draw_char my_char (
        .clk(clk40MHz),
        .rst(rst),
        .hcount_in(hcount_out_game),
        .hsync_in(hsync_out_game),
        .hblnk_in(hblnk_out_game),
        .vcount_in(vcount_out_game),
        .vsync_in(vsync_out_game),
        .vblnk_in(vblnk_out_game),
        .rgb_in(rgb_out_game),
        .char_instruction(char_pixels),
        .hcount_out(hcount_out_char),
        .hsync_out(hsync_out_char),
        .hblnk_out(hblnk_out_char),
        .vcount_out(vcount_out_char),
        .vsync_out(vsync_out_char),
        .vblnk_out(vblnk_out_char),
        .rgb_out(rgb_out_char),
        .char_xy_instruction(char_xy),
        .char_line_instruction(char_line)
    );
    
    wire [6:0] char_code;
// Modu³ odpowiada za wybór odpowiedniej informacji do wyœwietlenia. Dokonuje tego na podstawie sygna³ z modu³u ProgramData
    char_rom_16x16 my_char_rom (
        .clk(clk40MHz),
        .rst(rst),
        .program_state(program_state),
        .warning(warning),
        .active_player(active_player),
        .active_move_finding(active_move_finding),
        .player_name_character_enable(program_uart_data_enable_out),
        .player_name_character(program_uart_data_out), 
        .player_name_character_counter(program_uart_data_out_counter),        
        .char_xy(char_xy),
        .players_ships1x(players_ships1x),
        .players_ships2x(players_ships2x),
        .players_ships3x(players_ships3x),
        .players_ships4x(players_ships4x),
        .players_ships5x(players_ships5x),
        .char_code(char_code),
        .hit_ship(hit_ship),
        .hit_ships1(hit_ships1),
        .hit_ships2(hit_ships2),
        .ships_to_hit(ships_to_hit)
    );
    
    font_rom my_font_rom (
        .clk(clk40MHz),
        .rst(rst),
        .addr({char_code, char_line}),
        .char_line_pixels(char_pixels)
    );
    

    wire [3:0] red_out, green_out, blue_out;      
    MouseDisplay my_Display (
      .xpos(xpos_out_MouseCtl),
      .ypos(ypos_out_MouseCtl),
      .pixel_clk(clk40MHz),
      .hcount({1'b0, hcount_out_char}),
      .vcount({1'b0, vcount_out_char}),
      .blank(hblnk_out_char | vblnk_out_char),
      .red_in(rgb_out_char[3:0]),
      .green_in(rgb_out_char[7:4]),   
      .blue_in(rgb_out_char[11:8]),
      .red_out(red_out),
      .green_out(green_out),   
      .blue_out(blue_out)    
    );
      
    always @(posedge clk40MHz)
    begin
        hs <= hsync_out_char;
        vs <= vsync_out_char; 
        {r,g,b} <= {red_out, green_out, blue_out};
    end  

    
endmodule
