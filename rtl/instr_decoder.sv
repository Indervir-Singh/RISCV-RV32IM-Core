`timescale 1ns / 1ps

module instr_decoder

  (input logic [6:0] opcode ,
   output logic [2:0] ImmSrc
  );

  always_comb
  begin
    case(opcode)
      7'b0000011,
      7'b0010011: //I type instruction opcode for lw
        ImmSrc = 3'b000;
      7'b0100011: //S type instruction opcode
        ImmSrc = 3'b001;
      7'b1100011: //B type instruction opcode
        ImmSrc = 3'b010;
      7'b0110111: //U type instruction opcode
        ImmSrc = 3'b011;
      7'b1101111: //J type instruction opcode
        ImmSrc = 3'b100;
      default:
        ImmSrc = 3'b111;
    endcase
  end

endmodule
