`timescale 1ns / 1ps
module Hexto7Seg
  (
    input logic [3:0] input_hex,
    output logic [6:0] seg7_out
  );

  logic [6:0] seg7;
  always_comb
  begin
    case(input_hex)
      4'h0:
        seg7 = 7'b011_1111;
      4'h1:
        seg7 = 7'b000_0110;
      4'h2:
        seg7 = 7'b101_1011;
      4'h3:
        seg7 = 7'b100_1111;
      4'h4:
        seg7 = 7'b110_0110;
      4'h5:
        seg7 = 7'b110_1101;
      4'h6:
        seg7 = 7'b111_1101;
      4'h7:
        seg7 = 7'b000_0111;
      4'h8:
        seg7 = 7'b111_1111;
      4'h9:
        seg7 = 7'b110_1111;
      4'hA:
        seg7 = 7'b111_0111;
      4'hb:
        seg7 = 7'b111_1100;
      4'hC:
        seg7 = 7'b011_1001;
      4'hd:
        seg7 = 7'b101_1110;
      4'he:
        seg7 = 7'b111_1001;
      4'hf:
        seg7 = 7'b111_0001;
      default:
        seg7 = 7'bxxx_xxxx;
    endcase
  end

  assign seg7_out = ~seg7;
endmodule
