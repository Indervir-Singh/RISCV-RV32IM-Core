`timescale 1ns / 1ps
module TOP_Pipelined #(
    parameter WIDTH = 32
) (
    input logic clk,
    input logic srst,
    output logic MemWrite_M,
    output logic [WIDTH-1:0] data_addr_M,
    output logic [WIDTH-1:0] WriteData_M
);

  logic [4:0] Rs1_D;
  logic [4:0] Rs2_D;
  logic [4:0] Rs1_E;
  logic [4:0] Rs2_E;
  logic [4:0] Rd_E;
  logic [4:0] Rd_M;
  logic [4:0] Rd_W;
  logic [1:0] ForwardA_E;
  logic [1:0] ForwardB_E;
  logic Stall_F;
  logic Stall_D;
  logic Flush_D;
  logic Flush_E;
  logic RegWrite_M;
  logic RegWrite_W;
  logic ResultSrc_E_0;
  logic PCSrc_E;

  core_pip #(
      .WIDTH(WIDTH)
  ) core_pip (
      .clk(clk),
      .srst(srst),
      .Stall_F(Stall_F),
      .Stall_D(Stall_D),
      .Flush_D(Flush_D),
      .Flush_E(Flush_E),
      .ForwardA_E(ForwardA_E),
      .ForwardB_E(ForwardB_E),
      .RegWrite_M(RegWrite_M),
      .RegWrite_W(RegWrite_W),
      .ResultSrc_E_0(ResultSrc_E_0),
      .PCSrc_E(PCSrc_E),
      .Rs1_D(Rs1_D),
      .Rs2_D(Rs2_D),
      .Rs1_E(Rs1_E),
      .Rs2_E(Rs2_E),
      .Rd_E(Rd_E),
      .Rd_M(Rd_M),
      .Rd_W(Rd_W),
      .MemWrite_M(MemWrite_M),
      .data_addr_M(data_addr_M),
      .WriteData_M(WriteData_M)
  );

  hazard_unit hazard_unit (
      .RegWrite_M(RegWrite_M),
      .RegWrite_W(RegWrite_W),
      .Rs1_E(Rs1_E),
      .Rs2_E(Rs2_E),
      .Rd_M(Rd_M),
      .Rd_W(Rd_W),
      .ForwardA_E(ForwardA_E),
      .ForwardB_E(ForwardB_E),
      .ResultSrc_E_0(ResultSrc_E_0),
      .Rs1_D(Rs1_D),
      .Rs2_D(Rs2_D),
      .Rd_E(Rd_E),
      .Stall_F(Stall_F),
      .Stall_D(Stall_D),
      .Flush_E(Flush_E),
      .PCSrc_E(PCSrc_E),
      .Flush_D(Flush_D)
  );
endmodule
