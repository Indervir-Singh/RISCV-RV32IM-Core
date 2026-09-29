`timescale 1ns / 1ps
module pip_Control_Unit
  (
    input logic [6:0] op_code,
    input logic [2:0] funct3,
    input logic funct7_5,
    output logic [3:0] ALUControl,
    output logic [1:0] ResultSrc,
    output logic [1:0] ImmSrc,
    output logic Branch,
    output logic Jump,
    output logic MemWrite,
    output logic ALUSrc,
    output logic RegWrite
  );

  logic [1:0] ALUOp;

  main_decoder u_main_decoder(
                 .op_code(op_code),
                 .ALUOp(ALUOp),
                 .ResultSrc(ResultSrc),
                 .ImmSrc(ImmSrc),
                 .Branch(Branch),
                 .Jump(Jump),
                 .MemWrite(MemWrite),
                 .ALUSrc(ALUSrc),
                 .RegWrite(RegWrite)
               );
  
  pip_ALU_Control u_ALU_decoder(
    .funct3(funct3),
    .ALUOp(ALUOp),
    .funct7_5(funct7_5),
    .op_5(op_code[5]),
    .ALUControl(ALUControl)
  );
  
endmodule
