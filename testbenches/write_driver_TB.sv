`timescale 1ns / 1ps
module write_driver_TB(
  );

  logic clk, srst, data_valid, uart_memwrite, uart_rst_out;
  logic [7:0] data_byte;
  logic [31:0] uart_instr, uart_mem_adr;

  write_driver dut(
                 .clk(clk),
                 .srst(srst),
                 .data_valid(data_valid),
                 .data_byte(data_byte),
                 .uart_memwrite(uart_memwrite),
                 .uart_rst_out(uart_rst_out),
                 .uart_instr(uart_instr),
                 .uart_mem_adr(uart_mem_adr)
               );

  initial
  begin
    clk = 0;
    forever
      #5 clk = !clk;
  end

  logic [31:0] instr;
  int byte_index = 0;
  initial
  begin
    srst <= 1;
    repeat(2) @(posedge clk);
    srst <= 0;

    repeat(4)
    begin
      data_byte <= $random;
      instr[byte_index*8 +: 8] <= data_byte;
      byte_index <= byte_index + 1;
      repeat(2) @(posedge clk);
      data_valid <= 1'b1;
      @(posedge clk);
      data_valid <= 1'b0;
      repeat(2) @(posedge clk);
    end
    repeat(2) @(posedge clk);
    $finish;
  end
endmodule
