`timescale 1ns / 1ps
module mem_wb_pip_reg #(
    parameter WIDTH = 32
) (
    input logic clk,
    input logic srst,
    input logic RegWrite_M,
    input logic [1:0] ResultSrc_M,
    input logic [4:0] Rd_M,
    input logic [WIDTH-1:0] ReadData_M,
    input logic [WIDTH-1:0] PCPlus4_M,
    input logic [WIDTH-1:0] ALUResult_M,
    input logic [WIDTH-1:0] ImmExt_M,
    output logic RegWrite_W,
    output logic [1:0] ResultSrc_W,
    output logic [4:0] Rd_W,
    output logic [WIDTH-1:0] ReadData_W,
    output logic [WIDTH-1:0] PCPlus4_W,
    output logic [WIDTH-1:0] ALUResult_W,
    output logic [WIDTH-1:0] ImmExt_W
);

  always_ff @(posedge clk) begin
    if (srst) begin
      RegWrite_W <= 0;
      ResultSrc_W <= 0;
      ReadData_W <= 0;
      Rd_W <= 0;
      PCPlus4_W <= 0;
      ALUResult_W <= 0;
      ImmExt_W <= 0;
    end else begin
      RegWrite_W <= RegWrite_M;
      ResultSrc_W <= ResultSrc_M;
      ReadData_W <= ReadData_M;
      Rd_W <= Rd_M;
      PCPlus4_W <= PCPlus4_M;
      ALUResult_W <= ALUResult_M;
      ImmExt_W <= ImmExt_M;
    end
  end
endmodule
