`timescale 1ns / 1ps
module core_mc #(parameter WIDTH = 32)
  (
    input logic clk,
    input logic srst,
    input logic uart_over,
    input logic uart_MemWrite,
    input logic [WIDTH-1:0] uart_mem_adr,
    input logic [WIDTH-1:0] uart_instr,
    input logic [WIDTH-1:0] MemReadData,
    input logic [$clog2(WIDTH)-1:0] selected_reg,
    output logic MemWrite,
    output logic [WIDTH-1:0] output_reg,
    output logic [WIDTH-1:0] MemAdr,
    output logic [WIDTH-1:0] MemWriteData
  );

  logic [WIDTH-1:0] PCNext;
  logic [WIDTH-1:0] PCOut;
  logic [WIDTH-1:0] OldPC;
  logic [WIDTH-1:0] Result;
  logic [WIDTH-1:0] Instr;
  logic [WIDTH-1:0] Data;
  logic [WIDTH-1:0] RegWriteData;
  logic [WIDTH-1:0] RegReadDataA;
  logic [WIDTH-1:0] RegReadDataB;
  logic [WIDTH-1:0] A;
  logic [WIDTH-1:0] B;
  logic [WIDTH-1:0] ImmExt;
  logic [WIDTH-1:0] SrcA;
  logic [WIDTH-1:0] SrcB;
  logic [WIDTH-1:0] ALUResult;
  logic [WIDTH-1:0] ALUOut;
  logic [WIDTH-1:0] MULResult;

  logic [WIDTH-8:0] Imm;

  logic [6:0] opcode;

  logic [4:0] Rs1;
  logic [4:0] Rs2;
  logic [4:0] Rd;

  logic [3:0] ALUControl;

  logic [2:0] ImmSrc;
  logic [2:0] funct3;
  logic [2:0] ResultSrc;

  logic [1:0] ALUSrcASel;
  logic [1:0] ALUSrcBSel;
  logic [1:0] AdrSrc;
  logic [1:0] MULControl;
  logic PCWrite;
  logic IRWrite;
  logic WrDataSrc;
  logic CU_MemWrite;
  logic RegWrite;
  logic funct7_0;
  logic funct7_5;
  logic z_flag;
  logic sign_bit;

  assign PCNext = Result;
  en_reg #(.WIDTH(WIDTH)) ProgramCounter(
           .clk(clk),
           .srst(srst),
           .en(PCWrite),
           .reg_in(PCNext),
           .reg_out(PCOut)
         );

  en_reg #(.WIDTH(WIDTH)) NonArch_PC_Reg(
           .clk(clk),
           .srst(srst),
           .en(IRWrite),
           .reg_in(PCOut),
           .reg_out(OldPC)
         );

  MUX_4 #(.WIDTH(WIDTH)) Mem_AdrSrc_SelMux(
          .A(PCOut),
          .B(Result),
          .C(uart_mem_adr),
          .D(32'b0),
          .Sel(AdrSrc),
          .Y(MemAdr)
        );

  MUX_2 #(.WIDTH(WIDTH)) Mem_WrDataSrc_SelMux(
          .A(B),
          .B(uart_instr),
          .Sel(WrDataSrc),
          .Y(MemWriteData)
        );

  en_reg #(.WIDTH(WIDTH)) NonArch_Instr_Reg(
           .clk(clk),
           .srst(srst),
           .en(IRWrite),
           .reg_in(MemReadData),
           .reg_out(Instr)
         );

  en_reg #(.WIDTH(WIDTH)) NonArch_MemData_Reg(
           .clk(clk),
           .srst(srst),
           .en(1'b1),
           .reg_in(MemReadData),
           .reg_out(Data)
         );

  assign RegWriteData = Result;
  assign {Rs2,Rs1,Rd} = {Instr[24:15], Instr[11:7]};

  reg_file #(.WIDTH(WIDTH)) RegisterFile(
             .clk(clk),
             .we(RegWrite),
             .A1(Rs1),
             .A2(Rs2),
             .A3(Rd),
             .selected_reg(selected_reg),
             .wd(RegWriteData),
             .rd1(RegReadDataA),
             .rd2(RegReadDataB),
             .output_reg(output_reg)
           );

  en_reg #(.WIDTH(WIDTH)) NonArch_RegDataA_Reg(
           .clk(clk),
           .srst(srst),
           .en(1'b1),
           .reg_in(RegReadDataA),
           .reg_out(A)
         );

  en_reg #(.WIDTH(WIDTH)) NonArch_RegDataB_Reg(
           .clk(clk),
           .srst(srst),
           .en(1'b1),
           .reg_in(RegReadDataB),
           .reg_out(B)
         );

  assign Imm = Instr[31:7];

  extend_unit #(.WIDTH(WIDTH)) Extend_Unit(
                .Imm(Imm),
                .ImmSrc(ImmSrc),
                .ImmExt(ImmExt)
              );

  MUX_4 #(.WIDTH(WIDTH)) SrcA_Mux(
          .A(PCOut),
          .B(OldPC),
          .C(A),
          .D(WIDTH'(1'b0)),
          .Sel(ALUSrcASel),
          .Y(SrcA)
        );

  MUX_4 #(.WIDTH(WIDTH)) SrcB_Mux(
          .A(B),
          .B(ImmExt),
          .C(32'd4),
          .D(WIDTH'(1'b0)),
          .Sel(ALUSrcBSel),
          .Y(SrcB)
        );

  ALU #(.WIDTH(WIDTH)) u_ALU(
        .ALUControl(ALUControl),
        .SrcA(SrcA),
        .SrcB(SrcB),
        .ALUResult(ALUResult),
        .z_flag(z_flag)
      );

  en_reg #(.WIDTH(WIDTH)) NonArch_ALU_Reg(
           .clk(clk),
           .srst(srst),
           .en(1'b1),
           .reg_in(ALUResult),
           .reg_out(ALUOut)
         );

  MUL_Unit #(.WIDTH(WIDTH)) MUL_Unit(
             .clk(clk),
             .srst(srst),
             .MULControl(MULControl),
             .SrcA(A),
             .SrcB(B),
             .MULResult(MULResult)
           );

  MUX_8 #(.WIDTH(WIDTH)) Result_Mux(
          .A(ALUOut),
          .B(Data),
          .C(ALUResult),
          .D(ImmExt),
          .E(MULResult),
          .F(WIDTH'(1'b0)),
          .G(WIDTH'(1'b0)),
          .H(WIDTH'(1'b0)),
          .Sel(ResultSrc),
          .Y(Result)
        );

  assign {funct7_5, funct7_0, funct3, opcode} = {Instr[30], Instr[25], Instr[14:12], Instr[6:0]};
  assign sign_bit = ALUResult[31];

  Control_Unit Control_Unit(
                 .clk(clk),
                 .srst(srst),
                 .funct7_0(funct7_0),
                 .funct7_5(funct7_5),
                 .z_flag(z_flag),
                 .sign_bit(sign_bit),
                 .uart_over(uart_over),
                 .funct3(funct3),
                 .opcode(opcode),
                 .PCWrite(PCWrite),
                 .WrDataSrc(WrDataSrc),
                 .AdrSrc(AdrSrc),
                 .MemWrite(CU_MemWrite),
                 .IRWrite(IRWrite),
                 .RegWrite(RegWrite),
                 .ImmSrc(ImmSrc),
                 .ALUSrcASel(ALUSrcASel),
                 .ALUSrcBSel(ALUSrcBSel),
                 .ALUControl(ALUControl),
                 .MULControl(MULControl),
                 .ResultSrc(ResultSrc)
               );

  assign MemWrite = CU_MemWrite | uart_MemWrite;

endmodule
