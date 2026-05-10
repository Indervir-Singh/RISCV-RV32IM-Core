`timescale 1ns / 1ps
module MUL_Unit #(parameter WIDTH = 32)
  (
    input logic clk, srst,
    input logic [1:0] MULControl,
    input logic [WIDTH-1:0] SrcA, SrcB,
    output logic [WIDTH-1:0] MULResult
  );

  logic [2*WIDTH-1:0] MUL_Reg;

  always_comb
  begin
    case(MULControl)
      2'b00,
      2'b01: // MUL/MULH
        MUL_Reg = $signed(SrcA)*$signed(SrcB);
      2'b10: // MULHU
        MUL_Reg = SrcA*SrcB;
      default:
        MUL_Reg = 0;
    endcase
  end

  always_ff @(posedge clk)
  begin
    if (srst)
    begin
      MULResult <= WIDTH'(1'b0);
    end
    else
    begin
      case(MULControl)
        2'b00: // MUL
          MULResult <= MUL_Reg[WIDTH-1:0];
        2'b01,
        2'b10: // MULH/MULHU
          MULResult <= MUL_Reg[2*WIDTH-1:WIDTH];
      endcase
    end
  end

endmodule
