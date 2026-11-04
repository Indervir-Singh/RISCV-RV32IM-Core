`timescale 1ns / 1ps
module if_id_pip_reg #(
    parameter WIDTH = 32
) (
    input logic clk,
    input logic srst,
    input logic Flush_D,
    input logic en,
    input logic [WIDTH-1:0] Instr_F,
    input logic [WIDTH-1:0] PCOut_F,
    input logic [WIDTH-1:0] PCPlus4_F,
    output logic [WIDTH-1:0] Instr_D,
    output logic [WIDTH-1:0] PCOut_D,
    output logic [WIDTH-1:0] PCPlus4_D
);

  always_ff @(posedge clk) begin
    if (srst) begin
      Instr_D   <= '0;
      PCOut_D   <= '0;
      PCPlus4_D <= '0;
    end else begin
      // Flush only the instruction
      if (Flush_D) Instr_D <= '0;
      else if (!en) Instr_D <= Instr_F;
      // PC metadata is independent of Flush_D
      if (!en) begin
        PCOut_D   <= PCOut_F;
        PCPlus4_D <= PCPlus4_F;
      end
    end
  end
endmodule
