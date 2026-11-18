`timescale 1ns / 1ps
module UART_Load_Unit (
    input  logic clk,
    input  logic srst,
    input  logic load_over,
    output logic cpu_srst
);

  always_ff @(posedge clk) begin
    if (srst) cpu_srst <= 1'b1;
    else if (load_over) cpu_srst <= 1'b0;
  end
endmodule
