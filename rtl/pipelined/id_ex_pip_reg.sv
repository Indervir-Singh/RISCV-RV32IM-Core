`timescale 1ns / 1ps
module id_ex_pip_reg #(
    parameter WIDTH = 32
) (
    input logic clk,
    input logic srst,
    input logic RegWrite_D,
    input logic MemWrite_D,
    input logic Jump_D,
    input logic Branch_D,
    input logic ALUSrc_D,
    input logic [1:0] ResultSrc_D,
    input logic [3:0] ALUControl_D,
    input logic [4:0] Rs1_D,
    input logic [4:0] Rs2_D,
    input logic [4:0] Rd_D,
    input logic [WIDTH-1:0] RegReadDataA_D,
    input logic [WIDTH-1:0] RegReadDataB_D,
    input logic [WIDTH-1:0] PCOut_D,
    input logic [WIDTH-1:0] ImmExt_D,
    input logic [WIDTH-1:0] PCPlus4_D,
    output logic RegWrite_E,
    output logic MemWrite_E,
    output logic Jump_E,
    output logic Branch_E,
    output logic ALUSrc_E,
    output logic [1:0] ResultSrc_E,
    output logic [3:0] ALUControl_E,
    output logic [4:0] Rs1_E,
    output logic [4:0] Rs2_E,
    output logic [4:0] Rd_E,
    output logic [WIDTH-1:0] RegReadDataA_E,
    output logic [WIDTH-1:0] RegReadDataB_E,
    output logic [WIDTH-1:0] PCOut_E,
    output logic [WIDTH-1:0] ImmExt_E,
    output logic [WIDTH-1:0] PCPlus4_E
);

  always_ff @(posedge clk) begin
    if (srst) begin
      RegWrite_E <= 0;
      MemWrite_E <= 0;
      Jump_E <= 0;
      Branch_E <= 0;
      ALUSrc_E <= 0;
      ResultSrc_E <= 0;
      ALUControl_E <= 0;
      Rs1_E <= 0;
      Rs2_E <= 0;
      Rd_E <= 0;
      RegReadDataA_E <= 0;
      RegReadDataB_E <= 0;
      PCOut_E <= 0;
      ImmExt_E <= 0;
      PCPlus4_E <= 0;
    end else begin
      RegWrite_E <= RegWrite_D;
      MemWrite_E <= MemWrite_D;
      Jump_E <= Jump_D;
      Branch_E <= Branch_D;
      ALUSrc_E <= ALUSrc_D;
      ResultSrc_E <= ResultSrc_D;
      ALUControl_E <= ALUControl_D;
      Rs1_E <= Rs1_D;
      Rs2_E <= Rs2_D;
      Rd_E <= Rd_D;
      RegReadDataA_E <= RegReadDataA_D;
      RegReadDataB_E <= RegReadDataB_D;
      PCOut_E <= PCOut_D;
      ImmExt_E <= ImmExt_D;
      PCPlus4_E <= PCPlus4_D;
    end
  end
endmodule

