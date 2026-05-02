`timescale 1ns / 1ps

module MUX_4 #(parameter WIDTH = 8)
  (
    input  logic [WIDTH-1:0] A, B, C, D,
    input  logic [1:0]       Sel,
    output logic [WIDTH-1:0] Y
  );

  always_comb
  begin
    case (Sel)
      2'b00:
        Y = A;
      2'b01:
        Y = B;
      2'b10:
        Y = C;
      2'b11:
        Y = D;
      default:
        Y = 'x;
    endcase
  end

endmodule
