`timescale 1ns / 1ps


module UART_communication(
    input wire pclk,
    input wire loopback_enable,
    input wire [7:0] rx,
    output reg [7:0] rx_monitor,
    output reg [7:0] tx,
    output reg [7:0] tx_monitor   
    );
    
    reg [7:0] tx_nxt;
    
    always @(posedge pclk)
    begin
        tx <= tx_nxt;
        tx_monitor <= tx_nxt;
        rx_monitor <= rx;
    end
    
    always @*
    begin
        if(loopback_enable)
            tx_nxt = rx;
        else
            tx_nxt = 0;
    end
endmodule
