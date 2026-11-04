`timescale 1ns / 1ps
module TOP_Pipelined_TB ();

  localparam WIDTH = 32;
  logic clk;
  logic srst;
  logic reg_select, serial_data, load_over, locked;
  logic [3:0] leds;
  logic [6:0] seg_en;
  logic [7:0] dig_en;
  logic [WIDTH-1:0] WriteData_M, Data_addr_M;
  logic MemWrite_M;
  // instantiate device to be tested
  TOP_Pipelined #(
      .WIDTH(WIDTH)
  ) dut (
      .clk(clk),
      .srst(srst),
      .reg_select(reg_select),
      .serial_data(serial_data),
      .load_over(load_over),
      .locked(locked),
      .leds(leds),
      .seg_en(seg_en),
      .dig_en(dig_en),
      .MemWrite_M(MemWrite_M),
      .WriteData_M(WriteData_M),
      .Data_addr_M(Data_addr_M)
  );
  // initialize test
  initial begin
    clk = 0;
    forever #5 clk = !clk;
  end
  // check results
  initial begin
    srst <= 1;
    reg_select <= 0;
    serial_data <= 1;
    load_over <= 0;
    repeat(2) @(posedge clk);
    srst <= 0;
    load_over <= 1;
    @(posedge clk);
    load_over <= 0;
  end
  always @(negedge clk) begin
    if (MemWrite_M) begin
      if (Data_addr_M === 100 & WriteData_M === 25) begin
        $display("Simulation succeeded");
        $stop;
      end else if (Data_addr_M !== 96) begin
        $display("Simulation failed");
        $stop;
      end
    end
  end
endmodule
