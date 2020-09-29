`timescale 1 ns / 1 ps

//////////////////////////////////////////////////////////////////////////////////
// Module Name: timing
// Project Name: Statki
// Description: Modu³ obs³uguje podstawowe operacje  pikseli na ekranie - wyznacza sygna³y, które poŸniej 
// s¹ przetwarzane przez kolejne modu³y i wyœwietlane na ekranie (hcount, vcount) oraz sygna³y steruj¹ce,
// odpowiadaj¹ce za synchronizacjê ekranu z pikselami (vsync, vblnk, hsync, hblnk)
//////////////////////////////////////////////////////////////////////////////////

module vga_timing (
  input wire clk,
  input wire rst,
  output wire [10:0] vcount,
  output wire vsync,
  output wire vblnk,
  output wire [10:0] hcount,
  output wire hsync,
  output wire hblnk
  );

    reg [10:0] vcount_reg;
    reg [10:0] hcount_reg;
    reg [10:0] vcount_nxt;
    reg [10:0] hcount_nxt;  

    assign vcount = vcount_reg;
    assign hcount = hcount_reg;
    assign vsync = ((vcount_reg > 600) && (vcount_reg < 605));
    assign hsync = ((hcount_reg > 839) && (hcount_reg < 968));
    assign vblnk = (vcount_reg > 599);
    assign hblnk = (hcount_reg > 799); 

    initial
    begin
        vcount_reg = 0;
        hcount_reg = 0;
    end

    always @(posedge clk) 
    begin
        if(rst)
        begin
            vcount_reg <= 0;
            hcount_reg <= 0;        
        end
        else 
        begin
            vcount_reg <= vcount_nxt;
            hcount_reg <= hcount_nxt;
        end
    end

    always @* 
    begin
        if((hcount_reg < 1055) && (vcount_reg < 700))
            begin
                hcount_nxt = hcount_reg + 1;
                vcount_nxt = vcount_reg;
            end     
        else
        begin
            if((vcount_reg < 627) && (hcount_reg == 1055)) 
            begin
                hcount_nxt = 0;
                vcount_nxt = vcount_reg + 1;
            end
            else
            begin
                hcount_nxt = 0;
                vcount_nxt = 0;
            end
        end
    end
endmodule 