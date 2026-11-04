`timescale 1ns / 1ps
module TOP_Pipelined #(
    parameter WIDTH = 32,
    CLKS_PER_BIT = 434
) (
    input logic clk,
    input logic srst,
    input logic reg_select,
    input logic serial_data,
    input logic load_over,
    output logic [3:0] leds,
    output logic [6:0] seg_en,
    output logic [7:0] dig_en
);

  logic [4:0] Rs1_D;
  logic [4:0] Rs2_D;
  logic [4:0] Rd_E;
  logic [4:0] Rd_M;
  logic [1:0] ForwardA_D;
  logic [1:0] ForwardB_D;
  logic Stall_F;
  logic Stall_D;
  logic Flush_D;
  logic Flush_E;
  logic RegWrite_E;
  logic RegWrite_M;
  logic ResultSrc_E_0;
  logic PCSrc_E;
  logic cpu_srst;

  logic debounced_load_over;
  debouncer #(
      .CLK_FREQ(125_000_000),
      .DEBOUNCE_TIME_MS(20)
  ) load_over_debouncer (
      .clk(clk),
      .srst(srst),
      .button_in(load_over),
      .button_out(debounced_load_over)
  );
  logic debounced_reg_select;
  debouncer #(
      .CLK_FREQ(125_000_000),
      .DEBOUNCE_TIME_MS(20)
  ) reg_select_debouncer (
      .clk(clk),
      .srst(srst),
      .button_in(reg_select),
      .button_out(debounced_reg_select)
  );

  logic debounced_reg_select_d;
  logic reg_select_pulse;
  logic debounced_load_over_d;
  logic load_over_pulse;
  // Converting Level signal to Pulse Signal
  always_ff @(posedge clk) begin
    if (srst) begin
      debounced_reg_select_d <= 0;
      reg_select_pulse <= 0;

      debounced_load_over_d <= 0;
      load_over_pulse <= 0;
    end else begin
      reg_select_pulse <= debounced_reg_select & ~debounced_reg_select_d;
      debounced_reg_select_d <= debounced_reg_select;

      load_over_pulse <= debounced_load_over & ~debounced_load_over_d;
      debounced_load_over_d <= debounced_load_over;
    end
  end

  //Register Selection increments once every button press
  logic [$clog2(WIDTH)-1:0] selected_reg;
  always_ff @(posedge clk) begin
    if (srst) selected_reg <= 1;
    else if (reg_select_pulse) selected_reg <= selected_reg + 1'b1;
  end
  logic data_valid;
  logic [7:0] data_byte;
  uart_RX #(
      .CLKS_PER_BIT(CLKS_PER_BIT)
  ) uart_RX (
      .clk(clk),
      .srst(srst),
      .serial_data(serial_data),
      .data_valid(data_valid),
      .data_byte(data_byte)
  );

  logic uart_MemWrite;
  logic [WIDTH-1:0] uart_mem_adr, uart_instr;
  write_driver write_driver (
      .clk(clk),
      .srst(srst),
      .data_valid(data_valid),
      .data_byte(data_byte),
      .uart_MemWrite(uart_MemWrite),
      .uart_instr(uart_instr),
      .uart_mem_adr(uart_mem_adr)
  );

  UART_Load_Unit UART_Load_Unit (
      .clk(clk),
      .srst(srst),
      .load_over(load_over_pulse),
      .cpu_srst(cpu_srst)
  );
  logic [WIDTH-1:0] RegisterFileOutput;
  core_pip #(
      .WIDTH(WIDTH)
  ) core_pip (
      .clk(clk),
      .srst(srst | cpu_srst),
      .Stall_F(Stall_F),
      .Stall_D(Stall_D),
      .Flush_D(Flush_D),
      .Flush_E(Flush_E),
      .uart_MemWrite(uart_MemWrite),
      .ForwardA_D(ForwardA_D),
      .ForwardB_D(ForwardB_D),
      .selected_reg(selected_reg),
      .uart_mem_adr(uart_mem_adr),
      .uart_instr(uart_instr),
      .RegWrite_E(RegWrite_E),
      .RegWrite_M(RegWrite_M),
      .ResultSrc_E_0(ResultSrc_E_0),
      .PCSrc_E(PCSrc_E),
      .Rs1_D(Rs1_D),
      .Rs2_D(Rs2_D),
      .Rd_E(Rd_E),
      .Rd_M(Rd_M),
      .output_reg(RegisterFileOutput)
  );

  hazard_unit hazard_unit (
      .RegWrite_E(RegWrite_E),
      .RegWrite_M(RegWrite_M),
      .Rs1_D(Rs1_D),
      .Rs2_D(Rs2_D),
      .Rd_E(Rd_E),
      .Rd_M(Rd_M),
      .ForwardA_D(ForwardA_D),
      .ForwardB_D(ForwardB_D),
      .ResultSrc_E_0(ResultSrc_E_0),
      .Stall_F(Stall_F),
      .Stall_D(Stall_D),
      .Flush_E(Flush_E),
      .PCSrc_E(PCSrc_E),
      .Flush_D(Flush_D)
  );
  Seg7_Display RegisterFile_7SegDisplay (
      .clk(clk),
      .srst(srst),
      .data_in(RegisterFileOutput),
      .dig_en(dig_en),
      .seg_en(seg_en)
  );

  always_ff @(posedge clk) begin
    if (srst) leds <= 4'b0;
    else leds <= RegisterFileOutput[3:0];
  end

endmodule
