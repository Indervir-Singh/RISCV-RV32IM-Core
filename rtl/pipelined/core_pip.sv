`timescale 1ns / 1ps
module core_pip #(parameter WIDTH = 32)
  (
    input logic clk,
    input logic srst
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
           .en(1'b1),
           .reg_in(PCNext_F),
           .reg_out(PCOut_F)
         );

  adder #(.WIDTH(WIDTH)) PcPlus4_Adder(
          .A(PCOut_F),
          .B(WIDTH'(3'b100)),
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
  logic [4:0] Rs1_D;
  logic [4:0] Rs2_D;
  logic [4:0] Rd_D;
  logic [4:0] selected_reg;
  logic [2:0] ImmSrc_D;

  if_id_pip_reg #(.WIDTH(WIDTH)) u_if_id_pip_reg(
                  .clk(clk),
                  .srst(srst),
                  .Instr_F(Instr_F),
                  .PCOut_F(PCOut_F),
                  .PCPlus4_F(PCPlus4_F),
                  .Instr_D(Instr_D),
                  .PCOut_D(PCOut_D),
                  .PCPlus4_D(PCPlus4_D)
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
  logic [2:0] ALUControl_E;
  logic z_flag_E;
  logic PCSrc_E;
  logic ALUSrc_E;
  id_ex_pip_reg #(.WIDTH(WIDTH)) u_id_ex_pip_reg(
                  .clk(clk),
                  .srst(srst),
                  .RegReadDataA_D(RegReadDataA_D),
                  .RegReadDataB_D(RegReadDataB_D),
                  .PCOut_D(PCOut_D),
                  .ImmExt_D(ImmExt_D),
                  .PCPlus4_D(PCPlus4_D),
                  .Rd_D(Rd_D),
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

  MUX_2 #(.WIDTH(WIDTH)) ALU_SrcB_SelMux(
          .A(RegReadDataB_E),
          .B(ImmExt_E),
          .Sel(ALUSrc_E),
          .Y(SrcB_E)
        );

  assign SrcA_E = RegReadDataA_E;
  ALU #(.WIDTH(WIDTH)) u_ALU(
        .ALUControl(ALUControl_E),
        .SrcA(SrcA_E),
        .SrcB(SrcB_E),
        .ALUResult(ALUResult_E),
        .z_flag(z_flag_E)
      );

  //------------------------
  // MEM Stage
  //------------------------
  logic [WIDTH-1:0] ALUResult_M;
  logic [WIDTH-1:0] WriteData_M;
  logic [WIDTH-1:0] Rd_M;
  logic [WIDTH-1:0] PCPlus4_M;
  logic [WIDTH-1:0] ReadData_M;
  logic MemWrite_M;
  ex_mem_pip_reg #(.WIDTH(WIDTH)) u_ex_mem_pip_reg(
                   .clk(clk),
                   .srst(srst),
                   .ALUResult_E(ALUResult_E),
                   .WriteData_E(RegReadDataB_E),
                   .Rd_E(Rd_E),
                   .PCPlus4_E(PCPlus4_E),
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
  logic [WIDTH-1:0] Rd_W;
  logic [WIDTH-1:0] PCPlus4_W;
  logic [WIDTH-1:0] ALUResult_W;
  logic [WIDTH-1:0] Result_W;
  logic ResultSrc_w;
  mem_wb_pip_reg #(.WIDTH(WIDTH)) u_mem_wb_pip_reg(
                   .clk(clk),
                   .srst(srst),
                   .ReadData_M(ReadData_M),
                   .Rd_M(Rd_M),
                   .PCPlus4_M(PCPlus4_M),
                   .ALUResult_M(ALUResult_M),
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
