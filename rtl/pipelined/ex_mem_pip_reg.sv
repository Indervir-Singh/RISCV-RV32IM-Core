`timescale 1ns / 1ps
module ex_mem_pip_reg #(parameter WIDTH = 32)
  (
    input logic clk,
    input logic srst,
    input logic RegWrite_E,
    input logic MemWrite_E,
    input logic [1:0] ResultSrc_E,
    input logic [4:0] Rd_E,
    input logic [WIDTH-1:0] ALUResult_E,
    input logic [WIDTH-1:0] WriteData_E,
    input logic [WIDTH-1:0] PCPlus4_E,
    output logic RegWrite_M,
    output logic MemWrite_M,
    output logic [1:0] ResultSrc_M,
    output logic [4:0] Rd_M,
    output logic [WIDTH-1:0] ALUResult_M,
    output logic [WIDTH-1:0] WriteData_M,
    output logic [WIDTH-1:0] PCPlus4_M
  );

  always_ff @(posedge clk)
  begin
    if (srst)
    begin
      RegWrite_M <= 0;
      MemWrite_M <= 0;
      ResultSrc_M <= 0;
      ALUResult_M <= 0;
      WriteData_M <= 0;
      Rd_M <= 0;
      PCPlus4_M <= 0;
    end
    else
    begin
      RegWrite_M <= RegWrite_E;
      MemWrite_M <= MemWrite_E;
      ResultSrc_M <= ResultSrc_E;
      ALUResult_M <= ALUResult_E;
      WriteData_M <= WriteData_E;
      Rd_M <= Rd_E;
      PCPlus4_M <= PCPlus4_E;
    end
  end
endmodule
