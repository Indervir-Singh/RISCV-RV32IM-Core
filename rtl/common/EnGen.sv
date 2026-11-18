`timescale 1ns / 1ps
module EnGen_Counter #(parameter MAX_COUNT = 65_535)
  (
    input logic clk, srst, en,
    output logic [$clog2(MAX_COUNT)+2:0] count
  );

  always_ff @(posedge clk)
  begin
    if (srst)
      count <= 0;
    else if (en)
      count <= count + 1'b1;
  end
endmodule
