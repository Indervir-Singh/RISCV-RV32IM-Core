`timescale 1ns / 1ps
module mem_wb_pip_reg #(parameter WIDTH = 32)
  (
    input logic clk,
    input logic srst,
    input logic [WIDTH-1:0] ReadData_M,
    input logic [WIDTH-1:0] Rd_M,
    input logic [WIDTH-1:0] PCPlus4_M,
    input logic [WIDTH-1:0] ALUResult_M,
    output logic [WIDTH-1:0] ReadData_W,
    output logic [WIDTH-1:0] Rd_W,
    output logic [WIDTH-1:0] PCPlus4_W,
    output logic [WIDTH-1:0] ALUResult_W
  );

  always_ff @(posedge clk)
  begin
    if (srst)
    begin
        ReadData_W <= 0;
        Rd_W <= 0;
        PCPlus4_W <= 0;
        ALUResult_W <= 0;
    end
    else
    begin
        ReadData_W <= ReadData_M;
        Rd_W <= Rd_M;
        PCPlus4_W <= PCPlus4_M;
        ALUResult_W <= ALUResult_M;
    end
  end
endmodule
