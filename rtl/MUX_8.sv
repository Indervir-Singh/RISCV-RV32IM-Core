`timescale 1ns / 1ps

module MUX_8 #(parameter WIDTH = 8)
  (
    input  logic [WIDTH-1:0] A, B, C, D, E, F, G, H,
    input  logic [2:0]       Sel,
    output logic [WIDTH-1:0] Y
  );

  always_comb
  begin
    case (Sel)
      3'b000:
        Y = A;
      3'b001:
        Y = B;
      3'b010:
        Y = C;
      3'b011:
        Y = D;
      3'b100:
        Y = E;
      3'b101:
        Y = F;
      3'b110:
        Y = G;
      3'b111:
        Y = H;
      default:
        Y = 'x;
    endcase
  end

endmodule
