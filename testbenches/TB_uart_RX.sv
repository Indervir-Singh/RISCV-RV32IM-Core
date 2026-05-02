`timescale 1ns / 1ps

module TB_uart_RX(
    );
    
    parameter CLKS_PER_BIT = 7;
    logic clk, srst, serial_data, data_valid;
    logic [7:0] data_byte;
    
    uart_RX #(.CLKS_PER_BIT(CLKS_PER_BIT)) dut(
        .clk(clk),
        .srst(srst),
        .serial_data(serial_data),
        .data_valid(data_valid),
        .data_byte(data_byte)
        );
        
    task WAIT; 
        input [7:0] clks;
        begin
            repeat(clks) @(posedge clk);
        end
    endtask
    
    initial
    begin
        clk = 0;
        forever #5 clk = !clk;
    end
    
    logic [7:0] input_byte;
    integer i;
    initial
    begin
        srst <= 1;
        serial_data <= 1;
        repeat(2) @(posedge clk);
        srst <= 0;
        repeat(4)
        begin
            input_byte <= $random();
            serial_data <= 0;
            WAIT(CLKS_PER_BIT);
            for(i = 0; i < 8; i++)
            begin
                serial_data <= input_byte[i];
                WAIT(CLKS_PER_BIT);
            end
            serial_data <= 1;
            assert(input_byte == data_byte)
            else $error("Incorrect Data Received");
            WAIT(CLKS_PER_BIT);
        end
        $finish();
    end 
endmodule
