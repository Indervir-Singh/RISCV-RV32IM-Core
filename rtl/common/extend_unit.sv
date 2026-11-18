`timescale 1ns / 1ps

module extend_unit #(parameter  WIDTH = 32)

  (input logic [WIDTH-8:0] Imm,
   input logic [2:0] ImmSrc,
   output logic [WIDTH-1:0] ImmExt
  );

  always_comb
  begin
    case(ImmSrc)
      3'b000 :    //I type instruction
        ImmExt = {{21{Imm[24]}},Imm[23:13]};
      3'b001 :    //S type instruction
        ImmExt = {{21{Imm[24]}},Imm[23:18],Imm[4:0]};
      3'b010 :    //B type instruction
        ImmExt = {{20{Imm[24]}},Imm[0],Imm[23:18],Imm[4:1],1'b0};
      3'b011 :    //U type instruction
        ImmExt = {Imm[24:5],12'b0};
      3'b100 :    //J type instruction
        ImmExt = {{13{Imm[24]}},Imm[11:5],Imm[13],Imm[23:14],1'b0};
      default:
        ImmExt = 32'b0;
    endcase
  end

endmodule
