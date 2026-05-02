`timescale 1ns / 1ps
module en_reg #(parameter WIDTH = 32)
  (
    input logic clk,
    input logic srst,
    input logic en,
    input logic [WIDTH-1:0] reg_in,
    output logic [WIDTH-1:0] reg_out
  );

  always_ff @(posedge clk)
  begin
    if (srst)
      reg_out <= WIDTH'(1'b0);
    else if (en)
      reg_out <= reg_in;
  end
endmodule
