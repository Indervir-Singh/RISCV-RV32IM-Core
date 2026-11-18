`timescale 1ns / 1ps

module main_decoder (
    input logic [6:0] op_code,
    output logic [1:0] ALUOp,
    output logic [1:0] ResultSrc,
    output logic [2:0] ImmSrc,
    output logic Branch,
    output logic Jump,
    output logic MemWrite,
    output logic ALUSrc,
    output logic RegWrite
);

  always_comb begin
    case (op_code)
      7'b0000011:
      {ALUOp, ResultSrc, ImmSrc, Branch, Jump, MemWrite, ALUSrc, RegWrite} = {
        2'b00, 2'b01, 3'b000, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1
      };
      7'b0100011:
      {ALUOp, ResultSrc, ImmSrc, Branch, Jump, MemWrite, ALUSrc, RegWrite} = {
        2'b00, 2'b00, 3'b001, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0
      };
      7'b0110011:
      {ALUOp, ResultSrc, ImmSrc, Branch, Jump, MemWrite, ALUSrc, RegWrite} = {
        2'b10, 2'b00, 3'b000, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1
      };
      7'b1100011:
      {ALUOp, ResultSrc, ImmSrc, Branch, Jump, MemWrite, ALUSrc, RegWrite} = {
        2'b01, 2'b00, 3'b010, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0
      };
      7'b0010011:
      {ALUOp, ResultSrc, ImmSrc, Branch, Jump, MemWrite, ALUSrc, RegWrite} = {
        2'b10, 2'b00, 3'b000, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1
      };
      7'b1101111:
      {ALUOp, ResultSrc, ImmSrc, Branch, Jump, MemWrite, ALUSrc, RegWrite} = {
        2'b00, 2'b10, 3'b100, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1
      };
      7'b0110111:
      {ALUOp, ResultSrc, ImmSrc, Branch, Jump, MemWrite, ALUSrc, RegWrite} = {
        2'b00, 2'b11, 3'b011, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1
      };
      default:
      {ALUOp, ResultSrc, ImmSrc, Branch, Jump, MemWrite, ALUSrc, RegWrite} = {
        2'b00, 2'b00, 3'b000, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0
      };
    endcase
  end
endmodule
