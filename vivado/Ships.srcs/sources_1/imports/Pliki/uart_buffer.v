`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Module Name: uart_buffer
// Project Name: Statki
// Description: Modu³ buforuje dane z uarta do ProgramData. Nastêpuje w nim zmiana czêstotliwoœci przesy³ania danych(dane wejœciowe zasilane s¹ zegarem 100MHz, a wyjœciowe 40MHz) 
//////////////////////////////////////////////////////////////////////////////////

module uart_buffer(
    input wire input_clk, // 100MHz
    input wire output_clk, // 40MHz
    input wire rst,
    input wire [7:0] uart_data,
    input wire uart_data_enable,
    output reg [7:0] uart_buffered_data,
    output reg uart_buffer_data_enable
    );
    
    reg [7:0] uart_buffered_data_nxt;
    reg uart_buffer_data_enable_nxt;
    reg input_enable1, input_enable1_nxt, input_enable2, input_enable2_nxt, input_enable3, input_enable3_nxt;
    reg [2:0] input_clk_counter, input_clk_counter_nxt;
    
    always @(posedge output_clk)
    begin
        if(rst)
        begin
            uart_buffer_data_enable <= 0;
            uart_buffered_data <= 0;               
        end
        else
        begin
            uart_buffer_data_enable <= uart_buffer_data_enable_nxt;
            uart_buffered_data <= uart_buffered_data_nxt;
        end
    end
     
    always @(posedge input_clk)
    begin
        if(rst)
        begin
            input_clk_counter <= 0; 
            input_enable1 <= 0;
            input_enable2 <= 0;
            input_enable3 <= 0;
        end          
        else
        begin
            input_clk_counter <= input_clk_counter_nxt;
            input_enable1 <= input_enable1_nxt;
            input_enable2 <= input_enable2_nxt;
            input_enable3 <= input_enable3_nxt;
        end            
    end 
     
    always @*
    begin
        input_clk_counter_nxt = (input_clk_counter+1)%3;
        input_enable1_nxt = input_enable1;
        input_enable2_nxt = input_enable2;
        input_enable3_nxt = input_enable3;
        case(input_clk_counter_nxt)
            2'b00: input_enable1_nxt = uart_data_enable;
            2'b01: input_enable2_nxt = uart_data_enable;
            2'b10: input_enable3_nxt = uart_data_enable;
            default: input_enable1_nxt = uart_data_enable;
        endcase
        uart_buffered_data_nxt = uart_data;
        uart_buffer_data_enable_nxt = ((input_enable1 | input_enable2 | input_enable3) && (!uart_buffer_data_enable));
    end
endmodule
