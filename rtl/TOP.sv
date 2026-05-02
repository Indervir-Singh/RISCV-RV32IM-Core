`timescale 1ns / 1ps
module TOP #(parameter WIDTH = 32, CLKS_PER_BIT = 434)
  (
    input logic clk,
    input logic srst,
    input logic reg_select,
    input logic serial_data,
    input logic uart_over,
    output logic [3:0] leds,
    output logic [7:0] dig_en,
    output logic [6:0] seg_en
  );
  logic clk_50Mhz;
  logic locked;
  clk_wiz_0 clk_pll(
              .clk_in1(clk),
              .clk_out1(clk_50Mhz),
              .locked(locked)
            );
  logic CPU_reset;
  assign CPU_reset = srst | ~locked;

  logic debounced_uart_over;
  debouncer #(.CLK_FREQ(50_000_000), .DEBOUNCE_TIME_MS(20)) uart_over_debouncer(
              .clk(clk_50Mhz),
              .srst(srst),
              .button_in(uart_over),
              .button_out(debounced_uart_over)
            );

  logic debounced_reg_select;
  debouncer #(.CLK_FREQ(50_000_000), .DEBOUNCE_TIME_MS(20)) reg_select_debouncer(
              .clk(clk_50Mhz),
              .srst(srst),
              .button_in(reg_select),
              .button_out(debounced_reg_select)
            );

  logic debounced_reg_select_d;
  logic reg_select_pulse;
  logic debounced_uart_over_d;
  logic uart_over_pulse;
  // Converting Level signal to Pulse Signal
  always_ff @(posedge clk_50Mhz)
  begin
    if (srst)
    begin
      debounced_reg_select_d <= 0;
      reg_select_pulse <= 0;
      
      debounced_uart_over_d  <= 0;
      uart_over_pulse  <= 0;
    end
    else
    begin
      reg_select_pulse <= debounced_reg_select & ~debounced_reg_select_d;
      debounced_reg_select_d <= debounced_reg_select;

      uart_over_pulse <= debounced_uart_over & ~debounced_uart_over_d;
      debounced_uart_over_d  <= debounced_uart_over;
    end
  end

  //Register Selection increments once every button press
  logic [$clog2(WIDTH)-1:0] selected_reg;
  always_ff @(posedge clk_50Mhz)
  begin
    if (srst)
      selected_reg <= 1;
    else if (reg_select_pulse)
      selected_reg <= selected_reg + 1'b1;
  end

  logic data_valid;
  logic [7:0] data_byte;
  uart_RX #(.CLKS_PER_BIT(CLKS_PER_BIT)) uart_RX(
            .clk(clk_50Mhz),
            .srst(srst),
            .serial_data(serial_data),
            .data_valid(data_valid),
            .data_byte(data_byte)
          );

  logic uart_MemWrite;
  logic [WIDTH-1:0] uart_mem_adr, uart_instr;
  write_driver write_driver(
                 .clk(clk_50Mhz),
                 .srst(srst),
                 .data_valid(data_valid),
                 .data_byte(data_byte),
                 .uart_MemWrite(uart_MemWrite),
                 .uart_instr(uart_instr),
                 .uart_mem_adr(uart_mem_adr)
               );

  logic MemWrite;
  logic [WIDTH-1:0] RegisterFileOutput;
  logic [WIDTH-1:0] MemReadData, MemWriteData, MemAdr;
  core_mc #(.WIDTH(WIDTH)) CPU(
            .clk(clk_50Mhz),
            .srst(srst),
            .uart_over(uart_over_pulse),
            .uart_MemWrite(uart_MemWrite),
            .uart_mem_adr(uart_mem_adr),
            .uart_instr(uart_instr),
            .MemReadData(MemReadData),
            .MemWrite(MemWrite),
            .MemAdr(MemAdr),
            .MemWriteData(MemWriteData),
            .output_reg(RegisterFileOutput),
            .selected_reg(selected_reg)
          );

  memory #(.WIDTH(WIDTH), .HEIGHT(256)) Mem(
           .clk(clk_50Mhz),
           .WE(MemWrite),
           .A(MemAdr),
           .WD(MemWriteData),
           .RD(MemReadData)
         );

  Seg7_Display RegisterFile_7SegDisplay(
                 .clk(clk_50Mhz),
                 .srst(srst),
                 .data_in(RegisterFileOutput),
                 .dig_en(dig_en),
                 .seg_en(seg_en)
               );

  always_ff @(posedge clk_50Mhz)
  begin
    if (srst)
      leds <= 4'b0;
    else
      leds <= RegisterFileOutput[3:0];
  end

endmodule
