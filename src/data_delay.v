`timescale 1ns / 1ps

module char_line_buffer(
    input wire pclk,
    input wire rst,
    input wire [3:0] char_line,
    output reg [3:0] char_line_delayed
);

    always @(posedge pclk, posedge rst)
    begin
        if(rst)
            char_line_delayed <= 0;
        else
            char_line_delayed <= char_line;
    end
endmodule
