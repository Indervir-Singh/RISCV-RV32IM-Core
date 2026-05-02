`timescale 1ns / 1ps
module ALU_TB (
  );

  localparam WIDTH = 32;

  logic funct7_5, op_5, z_flag;
  logic [1:0] ALUOp;
  logic [2:0] funct3;

  logic [3:0] ALUControl;
  logic [WIDTH-1:0] SrcA, SrcB, ALUResult;

  ALU_Control dut(
                .funct7_5(funct7_5),
                .op_5(op_5),
                .ALUOp(ALUOp),
                .funct3(funct3),
                .ALUControl(ALUControl)
              );

  ALU #(.WIDTH(WIDTH)) dut2(
        .ALUControl(ALUControl),
        .SrcA(SrcA),
        .SrcB(SrcB),
        .ALUResult(ALUResult),
        .z_flag(z_flag)
      );

  logic clk;

  initial
  begin
    clk = 0;
    forever
      #5 clk = !clk;
  end

  assign funct7_5 = 1;
  assign op_5 = 1;
  assign ALUOp = 2'b10;
  assign funct3 = 3'b0;
  assign SrcA = 32'h000000F9;
  assign SrcB = 32'h000000F2;

  initial
  begin
    repeat(10) @(posedge clk);
    $finish();
  end
endmodule
