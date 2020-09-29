module uart_communication
   (
    input wire clk, rst,
    input wire rx,
    //input wire btn,
    output wire tx,
    output wire data_enable,
    output wire [7:0] uart_data
   );

   // signal declaration
   wire tx_full, rx_empty, btn_tick, btn;
   wire [7:0] rec_data, rec_data1;
   
   // body
   // instantiate uart
   uart uart_unit
      (.clk(clk), .reset(rst), .rd_uart(btn_tick),
       .wr_uart(btn_tick), .rx(rx), .w_data(rec_data1),
       .tx_full(tx_full), .rx_empty(rx_empty),
       .r_data(rec_data), .enable(data_enable), .tx(tx));
   // instantiate debounce circuit
   debounce btn_db_unit
      (.clk(clk), .reset(rst), .sw(btn),
       .db_level(), .db_tick(btn_tick));
   // incremented data loops back
   assign rec_data1 = rec_data;
   // LED display
   assign uart_data = rec_data;
    
endmodule
