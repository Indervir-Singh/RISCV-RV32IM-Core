`timescale 1ns / 1ps

module core_mc_TB();
  logic clk;
  logic srst;
  logic [31:0] MemWriteData, ALUOut;
  logic MemWrite;
  // instantiate device to be tested
  core_mc #(.WIDTH(32)) dut(
            .clk(clk),
            .srst(srst),
            .MemWriteData(MemWriteData),
            .ALUOut(ALUOut),
            .MemWrite(MemWrite)
          );
  // generate clock to sequence tests
  initial
  begin
    clk = 0;
    forever
      #5 clk = !clk;
  end
  // initialize test
  initial
  begin
    srst <= 1;
    repeat(2) @(posedge clk);
    srst <= 0;
  end
  // check results
  always @(posedge clk)
  begin
    if(MemWrite)
    begin
      if(ALUOut === 32'h2302100C & MemWriteData === 32'd10)
      begin
        $display("Simulation succeeded");
        $finish();
      end
      else if (ALUOut !== 32'd96)
      begin
        $display("Simulation failed");
        $finish();
      end
    end
  end
endmodule
