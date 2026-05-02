`timescale 1ns / 1ps
module ALU_Control
  (
    input logic funct7_5, funct7_0,
    input logic op_5,
    input logic [1:0] ALUOp,
    input logic [2:0] funct3,
    output logic [3:0] ALUControl
  );

  always_comb
  begin
    case(ALUOp)
      2'b00:  //  Load/Store Word
        ALUControl = 4'b0000;   //  ADD
      2'b01:  //  Branches
        ALUControl = 4'b0001;   //  SUB
      default:  // R/I Type
      begin
        case(funct3)
          3'b000:
          begin
            if ({op_5, funct7_0} != 2'b11)
            begin
              if ({op_5,funct7_5} != 2'b11)
                ALUControl = 4'b0000;   // ADD/ADDI
              else
                ALUControl = 4'b0001;   // SUB
            end
            else
              ALUControl = 4'b1010;     // MUL
          end
          3'b110:
            ALUControl = 4'b0010;       // OR/ORI
          3'b111:
            ALUControl = 4'b0011;       // AND/ANDI
          3'b100:
            ALUControl = 4'b0100;       // XOR/XORI
          3'b001:
          begin
            if ({op_5, funct7_0} != 2'b11)
              ALUControl = 4'b0101;     // SLL/SLLI
            else
              ALUControl = 4'b1011;     // MULH
          end
          3'b101:
            if ({op_5,funct7_5} != 2'b11)
              ALUControl = 4'b0110;     // SRL/SRLI
            else
              ALUControl = 4'b0111;     // SRA/SRAI
          3'b010:
            ALUControl = 4'b1000;       // SLT/SLTI
          3'b011:
            ALUControl = 4'b1001;       // SLTI/SLTIU
          default:
            ALUControl = 4'b0000;
        endcase
      end
    endcase
  end
endmodule
