`timescale 1ns / 1ps
module data_mem #(parameter WIDTH = 32, HEIGHT = 256)
  (
    input logic clk,
    input logic data_WE,
    input logic [WIDTH-1:0] data_addr,
    input logic [WIDTH-1:0] data_WD,
    output logic [WIDTH-1:0] data_RD
  );

  logic [WIDTHJ-1:0] data_mem [HEIGHT-1:0];

  always_ff @(posedge clk)
  begin
    if (data_WE)
      data_mem[data_addr[WIDTH-1:2]] <= data_WD;
  end

  assign data_RD = data_mem[data_addr[WIDTH-1:2]];

endmodule
