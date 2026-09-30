`timescale 1ns / 1ps
module hazard_unit
  (
    // Signals for FORWARDING
    input logic RegWrite_M,
    input logic RegWrite_W,
    input logic [4:0] Rs1_E,
    input logic [4:0] Rs2_E,
    input logic [4:0] Rd_M,
    input logic [4:0] Rd_W,
    output logic [1:0] ForwardA_E,
    output logic [1:0] ForwardB_E,

    //Signals for STALLING
    input logic ResultSrc_E_0,
    input logic [4:0] Rs1_D,
    input logic [4:0] Rs2_D,
    input logic [4:0] Rd_E,
    output logic Stall_F,
    output logic Stall_D,
    output logic Flush_E,

    //Signals for Flushing Branch mispredictions
    input logic PCSrc_E,
    output logic Flush_D
  );

  // --------------------------------------------------
  // FORWARDING:
  //   - Rd --> Rs1 when Rs1_E == (Rd_M | Rd_W)
  //   - Rd --> Rs2 when Rs2_E == (Rd_M | Rd_W)
  //   - Priority: MEM > WB : As MEM Stage containes
  //                          more recent instruction
  // --------------------------------------------------
  
  always_comb
  begin
    // Forward SrcA
    // Forward from MEM Stage at higher priority
    if (RegWrite_M && (Rs1_E == Rd_M))
      ForwardA_E = 2'b10;
    // Forward from WB Stage
    else if (RegWrite_W && (Rs1_E == Rd_W))
      ForwardA_E = 2'b01;
    //No Forwarding
    else
      ForwardA_E = 2'b00;

    // Forward SrcB
    // Forward from MEM Stage at higher priority
    if (RegWrite_M && (Rs2_E == Rd_M))
      ForwardB_E = 2'b10;
    // Forward from WB Stage
    else if (RegWrite_W && (Rs2_E == Rd_W))
      ForwardB_E = 2'b01;
    //No Forwarding
    else
      ForwardB_E = 2'b00;
  end

  // --------------------------------------------------
  // STALLING:
  //   - Stall ID and IF and Flush ex_mem_pip_reg when
  //     LW is mid-execution (ResultSrc_E_0 == 1) &
  //     Source Register (Rs1 or Rs2) is equal to
  //     destination register (Rd) of the LW
  // --------------------------------------------------

  logic Flush_E_stall;
  always_comb
  begin
    if (ResultSrc_E_0 && ((Rs1_D == Rd_E) || (Rs2_D == Rd_E)))
    begin
      Stall_D = 1'b1;
      Stall_F = 1'b1;
      Flush_E_stall = 1'b1;
    end
    else
    begin
      Stall_D = 0;
      Stall_F = 0;
      Flush_E_stall = 0;
    end
  end

  // --------------------------------------------------
  // Branch Misprediction:
  //   - Using Always Not-Taken Branch Prediction.
  //   - If branch is to be taken, hazard unit flushes
  //     the Decode and Execute stages.
  // --------------------------------------------------

  logic Flush_E_branch;
  always_comb
  begin
    if (PCSrc_E)
    begin
      Flush_D = 1'b1;
      Flush_E = 1'b1;
    end
    else
    begin
      Flush_D = 0;
      Flush_E_branch = 0;    
    end
  end

  assign Flush_E = Flush_E_stall || Flush_E_branch;

endmodule
