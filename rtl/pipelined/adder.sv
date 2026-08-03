`timescale 1ns / 1ps
module adder #(parameter WIDTH = 32)
  (
    input logic [WIDTH-1:0] A, B,
    output logic [WIDTH-1:0] Sum
  );

  assign Sum = A + B;

endmodule
