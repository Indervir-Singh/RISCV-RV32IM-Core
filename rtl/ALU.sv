`timescale 1ns / 1ps
module ALU #(parameter WIDTH = 32)
  (
    input logic [3:0] ALUControl,
    input logic [WIDTH-1:0] SrcA, SrcB,
    output logic [WIDTH-1:0] ALUResult,
    output logic z_flag
  );

  always_comb
  begin
    case(ALUControl)
      4'b0000: // ADD
        ALUResult = SrcA + SrcB;
      4'b0001: // SUB
        ALUResult = SrcA - SrcB;
      4'b0010: // OR
        ALUResult = SrcA | SrcB;
      4'b0011: // AND
        ALUResult = SrcA & SrcB;
      4'b0100: // XOR
        ALUResult = SrcA ^ SrcB;
      4'b0101: // SLL
        ALUResult = SrcA << 5'(SrcB);
      4'b0110: // SRL
        ALUResult = SrcA >> 5'(SrcB);
      4'b0111: // SRA
        ALUResult = $signed(SrcA) >>> 5'(SrcB);
      4'b1000: // SLT
        ALUResult = ($signed(SrcA) < $signed(SrcB)) ? WIDTH'(1'b1) : WIDTH'(1'b0);
      4'b1001: // SLTU
        ALUResult = (SrcA < SrcB) ? WIDTH'(1'b1) : WIDTH'(1'b0);
      default:
        ALUResult = WIDTH'(1'b0);
    endcase
  end

  assign z_flag = (ALUResult == WIDTH'(1'b0));
endmodule
