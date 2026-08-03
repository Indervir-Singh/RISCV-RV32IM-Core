`timescale 1ns / 1ps
module memory #(parameter WIDTH = 32, HEIGHT = 256)
  (
    input logic clk,
    input logic WE,
    input logic [WIDTH-1:0] A,
    input logic [WIDTH-1:0] WD,
    output logic [WIDTH-1:0] RD
  );

  logic [WIDTH-1:0] memory[HEIGHT-1:0];

  /*initial
  begin
    $readmemh("riscvtestfile1.mem", memory);
  end*/

  always_ff @(posedge clk)
  begin
    if (WE)
      memory[A[WIDTH-1:2]] <= WD;
  end

  assign RD = memory[A[WIDTH-1:2]];
  
endmodule
