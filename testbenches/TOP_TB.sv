`timescale 1ns / 1ps
module TOP_TB(
  );

  localparam CLKS_PER_BIT = 5;

  logic clk, srst, reg_select, serial_data;
  logic [3:0] leds;
  logic [6:0] seg_en;
  logic [7:0] dig_en;

  TOP #(.WIDTH(32), .CLKS_PER_BIT(CLKS_PER_BIT)) dut(
        .clk(clk),
        .srst(srst),
        .reg_select(reg_select),
        .serial_data(serial_data),
        .dig_en(dig_en),
        .seg_en(seg_en),
        .leds(leds)
      );

  // generate clock to sequence tests
  logic [3:0] [7:0] test_instrs [255:0];
  logic [8:0] instr_num;
  initial
  begin
    $readmemh("riscvtestfile1.mem", test_instrs);
    instr_num = 9'b0;
  end
  task WAIT;
    input [7:0] clks;
    begin
      repeat(clks) @(posedge clk);
    end
  endtask

  initial
  begin
    clk = 0;
    forever
      #5
       clk = !clk;
  end

  logic [7:0] input_byte;
  integer i, j;
  initial
  begin
    srst <= 1;
    serial_data <= 1;
    reg_select <= 0;
    repeat(2) @(posedge clk);
    srst <= 0;
    repeat(23)
    begin
      @(posedge clk);
      for(j = 0; j < 4 ; j++)
      begin
        input_byte <= test_instrs[instr_num][j];
        serial_data <= 0;
        WAIT(CLKS_PER_BIT);
        for(i = 0; i < 8; i++)
        begin
          serial_data <= input_byte[i];
          WAIT(CLKS_PER_BIT);
        end
        serial_data <= 1;
        WAIT(CLKS_PER_BIT);
      end
      instr_num <= instr_num + 1'b1;
    end
    repeat(40) @(posedge clk);
    $finish();
  end


endmodule
