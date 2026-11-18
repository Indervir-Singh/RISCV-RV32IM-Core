`timescale 1ns / 1ps
module MUL_Unit #(parameter WIDTH = 32)
  (
    input logic clk, srst,
    input logic [1:0] MULControl,
    input logic [WIDTH-1:0] SrcA, SrcB,
    output logic [WIDTH-1:0] MULResult
  );

  logic [2*WIDTH+1:0] MUL_Result_r1;
  logic [WIDTH:0] SrcA_w, SrcA_reg1, SrcA_reg2;
  logic [WIDTH:0] SrcB_w, SrcB_reg1, SrcB_reg2;
  always_comb
  begin
    if (MULControl == 2'b00)
    begin
      SrcA_w = {1'b0, SrcA};
      SrcB_w = {1'b0, SrcB};
    end
    else if (MULControl == 2'b01)
    begin
      SrcA_w = {SrcA[31], SrcA};
      SrcB_w = {SrcB[31], SrcB};
    end
    else if (MULControl == 2'b10)
    begin
      SrcA_w = {1'b0, SrcA};
      SrcB_w = {1'b0, SrcB};
    end
    else
    begin
      SrcA_w = {SrcA[31], SrcA};
      SrcB_w = {1'b0, SrcB};
    end
  end

  always_ff @(posedge clk)
  begin
    if (srst)
    begin
      SrcA_reg1 <= 0;
      SrcB_reg1 <= 0;
      SrcA_reg2 <= 0;
      SrcB_reg2 <= 0;
      MUL_Result_r1 <= 0;
    end
    else
    begin
      SrcA_reg1 <= SrcA_w;
      SrcB_reg1 <= SrcB_w;
      SrcA_reg2 <= SrcA_reg1;
      SrcB_reg2 <= SrcB_reg1;
      MUL_Result_r1 <= SrcA_reg2 * SrcB_reg2;
    end
  end

  always_comb
  begin
    if (MULControl == 2'b00)
      MULResult = MUL_Result_r1[WIDTH-1:0];
    else
      MULResult = MUL_Result_r1[2*WIDTH-1:WIDTH];
  end
endmodule
