`timescale 1ns / 1ps
module TOP_Pipelined_TB ();

  localparam WIDTH = 32;
  logic clk;
  logic srst;
  logic [WIDTH-1:0] WriteData_M, data_addr_M;
  logic MemWrite_M;
  // instantiate device to be tested
  TOP_Pipelined #(
      .WIDTH(WIDTH)
  ) dut (
      .clk(clk),
      .srst(srst),
      .MemWrite_M(MemWrite_M),
      .WriteData_M(WriteData_M),
      .data_addr_M(data_addr_M)
  );
  // initialize test
  initial begin
    clk = 0;
    forever #5 clk = !clk;
  end
  // check results
  initial begin
    @(posedge clk);
    srst <= 1;
    repeat(2) @(posedge clk);
    srst <= 0;
  end
  always @(negedge clk) begin
    if (MemWrite_M) begin
      if (data_addr_M === 100 & WriteData_M === 25) begin
        $display("Simulation succeeded");
        $stop;
      end else if (data_addr_M !== 96) begin
        $display("Simulation failed");
        $stop;
      end
    end
  end
endmodule
