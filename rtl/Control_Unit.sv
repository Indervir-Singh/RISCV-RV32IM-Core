`timescale 1ns / 1ps
module Control_Unit
  (
    input logic clk,
    input logic srst,
    input logic funct7_0,
    input logic funct7_5,
    input logic z_flag,
    input logic sign_bit,
    input logic uart_over,
    input logic [2:0] funct3,
    input logic [6:0] opcode,
    output logic PCWrite,
    output logic MemWrite,
    output logic IRWrite,
    output logic RegWrite,
    output logic WrDataSrc,
    output logic [1:0] AdrSrc,
    output logic [1:0] ALUSrcASel, ALUSrcBSel,
    output logic [1:0] ResultSrc,
    output logic [2:0] ImmSrc,
    output logic [3:0] ALUControl
  );

  logic Branch;
  logic PCUpdate;
  logic [1:0] ALUOp;

  control_fsm Main_FSM(
                .clk(clk),
                .srst(srst),
                .uart_over(uart_over),
                .opcode(opcode),
                .PCUpdate(PCUpdate),
                .WrDataSrc(WrDataSrc),
                .AdrSrc(AdrSrc),
                .MemWrite(MemWrite),
                .IRWrite(IRWrite),
                .RegWrite(RegWrite),
                .ALUSrcA(ALUSrcASel),
                .ALUSrcB(ALUSrcBSel),
                .ALUOp(ALUOp),
                .ResultSrc(ResultSrc),
                .Branch(Branch)
              );

  ALU_Control ALU_Control_Unit(
                .funct7_0(funct7_0),
                .funct7_5(funct7_5),
                .op_5(opcode[5]),
                .ALUOp(ALUOp),
                .funct3(funct3),
                .ALUControl(ALUControl)
              );

  instr_decoder Instruction_Decoder(
                  .opcode(opcode),
                  .ImmSrc(ImmSrc)
                );

  Branch_Unit Branch_Unit(
                .sign_bit(sign_bit),
                .z_flag(z_flag),
                .Branch(Branch),
                .PCUpdate(PCUpdate),
                .funct3_2_0({funct3[2], funct3[0]}),
                .PCWrite(PCWrite)
              );


endmodule
