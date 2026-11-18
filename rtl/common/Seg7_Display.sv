`timescale 1ns / 1ps
module Seg7_Display
  (
    input logic clk,
    input logic srst,
    input logic [31:0] data_in,
    output logic [7:0] dig_en,
    output logic [6:0] seg_en
  );

  logic [18:0] dig_sel;
  logic [3:0] seg7_input;
  EnGen_Counter #(.MAX_COUNT(65535)) Digit_Enabler(
                  .clk(clk),
                  .srst(srst),
                  .en(1'b1),
                  .count(dig_sel)
                );

  always_comb
  begin
    case(dig_sel[18:16])
      3'b000:
      begin
        dig_en = 8'b1000_0000;
        seg7_input = data_in[31:28];
      end
      3'b001:
      begin
        dig_en = 8'b0100_0000;
        seg7_input = data_in[27:24];
      end
      3'b010:
      begin
        dig_en = 8'b0010_0000;
        seg7_input = data_in[23:20];
      end
      3'b011:
      begin
        dig_en = 8'b0001_0000;
        seg7_input = data_in[19:16];
      end
      3'b100:
      begin
        dig_en = 8'b0000_1000;
        seg7_input = data_in[15:12];
      end
      3'b101:
      begin
        dig_en = 8'b0000_0100;
        seg7_input = data_in[11:8];
      end
      3'b110:
      begin
        dig_en = 8'b0000_0010;
        seg7_input = data_in[7:4];
      end
      3'b111:
      begin
        dig_en = 8'b0000_0001;
        seg7_input = data_in[3:0];
      end
      default:
      begin
        dig_en = 8'bxxxx_xxxx;
        seg7_input = 4'bxxxx;
      end
    endcase
  end

  Hexto7Seg Hexto7Seg(
              .input_hex(seg7_input),
              .seg7_out(seg_en)
            );

endmodule
