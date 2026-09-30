`timescale 1ns / 1ps
module core_pip #(parameter WIDTH = 32)
  (
    input logic clk,
    input logic srst,
    input logic Stall_F,
    input logic Stall_D,
    input logic Flush_D,
    input logic Flush_E,
    input logic [1:0] ForwardA_E,
    input logic [1:0] ForwardB_E
  );

  //------------------------
  // IF Stage
  //------------------------
  logic [WIDTH-1:0] PCPlus4_F;
  logic [WIDTH-1:0] PCNext_F;
  logic [WIDTH-1:0] PCOut_F;
  logic [WIDTH-1:0] IMemWriteData_F;
  logic [WIDTH-1:0] Instr_F;

  logic IMemWrite_F;
  MUX_2 #(.WIDTH(WIDTH)) PCNext_SelMux(
          .A(PCPlus4_F),
          .B(PCTarget_E),
          .Sel(PCSrc_E),
          .Y(PCNext_F)
        );

  en_reg #(.WIDTH(WIDTH)) ProgramCounter(
           .clk(clk),
           .srst(srst),
           .en(Stall_F),
           .reg_in(PCNext_F),
           .reg_out(PCOut_F)
         );

  adder #(.WIDTH(WIDTH)) PcPlus4_Adder(
          .A(PCOut_F),
          .B(32'd4),
          .Sum(PCPlus4_F)
        );

  memory #(.WIDTH(WIDTH), .HEIGHT(256)) Instruction_Mem(
           .clk(clk),
           .WE(IMemWrite_F),
           .A(PCOut_F),
           .WD(IMemWriteData_F),
           .RD(Instr_F)
         );

  //------------------------
  // ID Stage
  //------------------------
  logic [WIDTH-1:0] Instr_D;
  logic [WIDTH-1:0] PCOut_D;
  logic [WIDTH-1:0] PCPlus4_D;
  logic [WIDTH-1:0] RegReadDataA_D;
  logic [WIDTH-1:0] RegReadDataB_D;
  logic [WIDTH-1:0] output_reg;
  logic [WIDTH-1:0] ImmExt_D;
  logic [WIDTH-8:0] Imm_D;
  logic [6:0] op_code;
  logic [4:0] Rs1_D;
  logic [4:0] Rs2_D;
  logic [4:0] Rd_D;
  logic [4:0] selected_reg;
  logic [3:0] ALUControl_D;
  logic [2:0] funct3;
  logic [1:0] ResultSrc_D;
  logic [1:0] ImmSrc_D;
  logic funct7_5;
  logic Branch_D;
  logic Jump_D;
  logic MemWrite_D;
  logic ALUSrc_D;
  logic RegWrite_D;

  if_id_pip_reg #(.WIDTH(WIDTH)) u_if_id_pip_reg(
                  .clk(clk),
                  .srst(srst || Flush_D),
                  .en(Stall_D),
                  .Instr_F(Instr_F),
                  .PCOut_F(PCOut_F),
                  .PCPlus4_F(PCPlus4_F),
                  .Instr_D(Instr_D),
                  .PCOut_D(PCOut_D),
                  .PCPlus4_D(PCPlus4_D)
                );

  assign{op_code, funct3, funct7_5} = {Instr_D[6:0], Instr_D[14:12], Instr_D[30]};
  pip_Control_Unit Control_Unit(
                     .op_code(op_code),
                     .funct3(funct3),
                     .funct7_5(funct7_5),
                     .ALUControl(ALUControl_D),
                     .ResultSrc(ResultSrc_D),
                     .ImmSrc(ImmSrc_D),
                     .Branch(Branch_D),
                     .Jump(Jump_D),
                     .MemWrite(MemWrite_D),
                     .ALUSrc(ALUSrc_D),
                     .RegWrite(RegWrite_D)
                   );

  assign {Rs2_D,Rs1_D,Rd_D} = {Instr_D[24:15], Instr_D[11:7]};
  reg_file #(.WIDTH(WIDTH)) RegisterFile(
             .clk(clk),
             .we(RegWrite_W),
             .A1(Rs1_D),
             .A2(Rs2_D),
             .A3(Rd_W),
             .selected_reg(selected_reg),
             .wd(Result_W),
             .rd1(RegReadDataA_D),
             .rd2(RegReadDataB_D),
             .output_reg(output_reg)
           );

  assign Imm_D = Instr_D[31:7];
  extend_unit #(.WIDTH(WIDTH)) Extend_Unit(
                .Imm(Imm_D),
                .ImmSrc(ImmSrc_D),
                .ImmExt(ImmExt_D)
              );

  //------------------------
  // EX Stage
  //------------------------
  logic [WIDTH-1:0] PCTarget_E;
  logic [WIDTH-1:0] RegReadDataA_E;
  logic [WIDTH-1:0] RegReadDataB_E;
  logic [WIDTH-1:0] SrcA_E;
  logic [WIDTH-1:0] SrcB_E;
  logic [WIDTH-1:0] ALUResult_E;
  logic [WIDTH-1:0] PCOut_E;
  logic [WIDTH-1:0] ImmExt_E;
  logic [WIDTH-1:0] PCPlus4_E;
  logic [4:0] Rd_E;
  logic [3:0] ALUControl_E;
  logic [1:0] ResultSrc_E;
  logic z_flag_E;
  logic RegWrite_E;
  logic MemWrite_E;
  logic Jump_E;
  logic Branch_E;
  logic ALUSrc_E;
  logic PCSrc_E;
  id_ex_pip_reg #(.WIDTH(WIDTH)) u_id_ex_pip_reg(
                  .clk(clk),
                  .srst(srst || Flush_E),
                  .ALUControl_D(ALUControl_D),
                  .ResultSrc_D(ResultSrc_D),
                  .RegWrite_D(RegWrite_D),
                  .MemWrite_D(MemWrite_D),
                  .Jump_D(Jump_D),
                  .Branch_D(Branch_D),
                  .ALUSrc_D(ALUSrc_D),
                  .RegReadDataA_D(RegReadDataA_D),
                  .RegReadDataB_D(RegReadDataB_D),
                  .PCOut_D(PCOut_D),
                  .ImmExt_D(ImmExt_D),
                  .PCPlus4_D(PCPlus4_D),
                  .Rd_D(Rd_D),
                  .ALUControl_E(ALUControl_E),
                  .ResultSrc_E(ResultSrc_E),
                  .RegWrite_E(RegWrite_E),
                  .MemWrite_E(MemWrite_E),
                  .Jump_E(Jump_E),
                  .Branch_E(Branch_E),
                  .ALUSrc_E(ALUSrc_E),
                  .RegReadDataA_E(RegReadDataA_E),
                  .RegReadDataB_E(RegReadDataB_E),
                  .PCOut_E(PCOut_E),
                  .ImmExt_E(ImmExt_E),
                  .PCPlus4_E(PCPlus4_E),
                  .Rd_E(Rd_E)
                );

  adder #(.WIDTH(WIDTH)) PcTarget_Adder(
          .A(PCOut_E),
          .B(ImmExt_E),
          .Sum(PCTarget_E)
        );

  MUX_4 #(.WIDTH(WIDTH)) ALUSrcA_ForwardingMux(
          .A(RegReadDataA_E),
          .B(Result_W),
          .C(ALUResult_M),
          .D(0),
          .Sel(ForwardA_E),
          .Y(SrcA_E)
        );

  MUX_4 #(.WIDTH(WIDTH)) ALURSrcB_ForwardingMux(
          .A(RegReadDataB_E),
          .B(Result_W),
          .C(ALUResult_M),
          .D(0),
          .Sel(ForwardB_E),
          .Y(ForwardDataB_E)
        );

  MUX_2 #(.WIDTH(WIDTH)) ALU_SrcB_SelMux(
          .A(ForwardDataB_E),
          .B(ImmExt_E),
          .Sel(ALUSrc_E),
          .Y(SrcB_E)
        );

  ALU #(.WIDTH(WIDTH)) u_ALU(
        .ALUControl(ALUControl_E),
        .SrcA(SrcA_E),
        .SrcB(SrcB_E),
        .ALUResult(ALUResult_E),
        .z_flag(z_flag_E)
      );

  assign PCSrc_E = (Branch_E && z_flag_E) || Jump_E;
  //------------------------
  // MEM Stage
  //------------------------
  logic [WIDTH-1:0] ALUResult_M;
  logic [WIDTH-1:0] WriteData_M;
  logic [WIDTH-1:0] PCPlus4_M;
  logic [WIDTH-1:0] ReadData_M;
  logic [4:0] Rd_M;
  logic [1:0] ResultSrc_M;
  logic RegWrite_M;
  logic MemWrite_M;
  ex_mem_pip_reg #(.WIDTH(WIDTH)) u_ex_mem_pip_reg(
                   .clk(clk),
                   .srst(srst),
                   .RegWrite_E(RegWrite_E),
                   .MemWrite_E(MemWrite_E),
                   .ResultSrc_E(ResultSrc_E),
                   .ALUResult_E(ALUResult_E),
                   .WriteData_E(RegReadDataB_E),
                   .Rd_E(Rd_E),
                   .PCPlus4_E(PCPlus4_E),
                   .RegWrite_M(RegWrite_M),
                   .MemWrite_M(MemWrite_M),
                   .ResultSrc_M(ResultSrc_M),
                   .ALUResult_M(ALUResult_M),
                   .WriteData_M(WriteData_M),
                   .Rd_M(Rd_M),
                   .PCPlus4_M(PCPlus4_M)
                 );

  data_mem #(.WIDTH(WIDTH), .HEIGHT(256)) Data_mem(
             .clk(clk),
             .data_WE(MemWrite_M),
             .data_addr(ALUResult_M),
             .data_WD(WriteData_M),
             .data_RD(ReadData_M)
           );

  //------------------------
  // WB Stage
  //------------------------
  logic [WIDTH-1:0] ReadData_W;
  logic [WIDTH-1:0] PCPlus4_W;
  logic [WIDTH-1:0] ALUResult_W;
  logic [WIDTH-1:0] Result_W;
  logic [4:0] Rd_W;
  logic [1:0] ResultSrc_W;
  logic RegWrite_W;
  mem_wb_pip_reg #(.WIDTH(WIDTH)) u_mem_wb_pip_reg(
                   .clk(clk),
                   .srst(srst),
                   .RegWrite_M(RegWrite_M),
                   .ResultSrc_M(ResultSrc_M),
                   .ReadData_M(ReadData_M),
                   .Rd_M(Rd_M),
                   .PCPlus4_M(PCPlus4_M),
                   .ALUResult_M(ALUResult_M),
                   .RegWrite_W(RegWrite_W),
                   .ResultSrc_W(ResultSrc_W),
                   .ReadData_W(ReadData_W),
                   .Rd_W(Rd_W),
                   .PCPlus4_W(PCPlus4_W),
                   .ALUResult_W(ALUResult_W)
                 );

  MUX_4 #(.WIDTH(WIDTH)) Result_SelMux(
          .A(ALUResult_W),
          .B(ReadData_W),
          .C(PCPlus4_W),
          .D(0),
          .Sel(ResultSrc_W),
          .Y(Result_W)
        );
endmodule
