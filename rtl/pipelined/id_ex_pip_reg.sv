`timescale 1ns / 1ps
module id_ex_pip_reg #(parameter WIDTH = 32)
  (
    input logic clk,
    input logic srst,
    input logic [WIDTH-1:0] RegReadDataA_D,
    input logic [WIDTH-1:0] RegReadDataB_D,
    input logic [WIDTH-1:0] PCOut_D,
    input logic [WIDTH-1:0] ImmExt_D,
    input logic [WIDTH-1:0] PCPlus4_D,
    input logic [4:0] Rd_D,
    output logic [WIDTH-1:0] RegReadDataA_E,
    output logic [WIDTH-1:0] RegReadDataB_E,
    output logic [WIDTH-1:0] PCOut_E,
    output logic [WIDTH-1:0] ImmExt_E,
    output logic [WIDTH-1:0] PCPlus4_E,
    output logic [4:0] Rd_E
  );

  always_ff @(posedge clk)
  begin
    if (srst)
    begin
      RegReadDataA_E <= 0;
      RegReadDataB_E <= 0;
      PCOut_E <= 0;
      ImmExt_E <= 0;
      PCPlus4_E <= 0;
      Rd_E <= 0;
    end
    else
    begin
      RegReadDataA_E <= RegReadDataA_D;
      RegReadDataB_E <= RegReadDataB_D;
      PCOut_E <= PCOut_D;
      ImmExt_E <= ImmExt_D;
      PCPlus4_E <= PCPlus4_D;
      Rd_E <= Rd_D;
    end
  end
endmodule

