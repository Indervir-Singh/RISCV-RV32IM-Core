`timescale 1ns / 1ps

module MUX_2 #(parameter WIDTH = 8)
  (
    input  logic [WIDTH-1:0] A,B,
    input  logic Sel,
    output logic [WIDTH-1:0] Y
  );
  always_comb
    Y = Sel ? B : A;

endmodule
