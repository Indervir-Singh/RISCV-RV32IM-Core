`timescale 1ns / 1ps
module HazardUnitTB ();

  logic RegWrite_M, RegWrite_W, ResultSrc_E_0, Stall_F, Stall_D, Flush_E, PCSrc_E, Flush_D;

  logic [1:0] ForwardA_E, ForwardB_E;

  logic [4:0] Rs1_E, Rs2_E, Rd_M, Rd_W, Rs1_D, Rs2_D, Rd_E;

  hazard_unit dut (
      .RegWrite_M(RegWrite_M),
      .RegWrite_W(RegWrite_W),
      .Rs1_E(Rs1_E),
      .Rs2_E(Rs2_E),
      .Rd_M(Rd_M),
      .Rd_W(Rd_W),
      .ForwardA_E(ForwardA_E),
      .ForwardB_E(ForwardB_E),
      .ResultSrc_E_0(ResultSrc_E_0),
      .Rs1_D(Rs1_D),
      .Rs2_D(Rs2_D),
      .Rd_E(Rd_E),
      .Stall_F(Stall_F),
      .Stall_D(Stall_D),
      .Flush_E(Flush_E),
      .PCSrc_E(PCSrc_E),
      .Flush_D(Flush_D)
  );

  logic clk;

  initial begin
    clk = 0;
    forever #5 clk = !clk;
  end

  initial begin
    RegWrite_M = 0;
    RegWrite_W = 0;
    Rs1_E = 0;
    Rs2_E = 0;
    Rd_M = 0;
    Rd_W = 0;

    ResultSrc_E_0 = 0;
    Rs1_D = 0;
    Rs2_D = 0;
    Rd_E = 0;

    PCSrc_E = 0;
  end

  initial begin
    repeat (500) begin
      // Signals for Forwarding:
      @(posedge clk);
      RegWrite_M <= $urandom();
      RegWrite_W <= RegWrite_M;
      Rs1_E <= $urandom();
      Rs2_E <= $urandom();
      Rd_M <= $urandom();
      Rd_W <= Rd_M;

      // Signals for Stalling:
      ResultSrc_E_0 <= $urandom();
      Rs1_D <= $urandom();
      Rs2_D <= $urandom();
      Rd_E <= $urandom();

      // Signals for Branching:
      PCSrc_E <= $urandom();
    end

    $finish();
  end


  //---------------------------------
  //  Forwarding Checks
  //---------------------------------

  sequence A_MEM_Match; RegWrite_M && (Rs1_E == Rd_M); endsequence

  sequence A_WB_Match;
    (RegWrite_W && (Rs1_E == Rd_W)) && !(RegWrite_M && (Rs1_E == Rd_M));
  endsequence

  sequence A_No_Match;
    !(RegWrite_W && (Rs1_E == Rd_W)) && !(RegWrite_M && (Rs1_E == Rd_M));
  endsequence

  property ForwardA_MEM;
    @(posedge clk) A_MEM_Match |-> (ForwardA_E == 2'b10);
  endproperty

  property ForwardA_WB;
    @(posedge clk) A_WB_Match |-> (ForwardA_E == 2'b01);
  endproperty

  property No_ForwardA;
    @(posedge clk) A_No_Match |-> (ForwardA_E == 2'b00);
  endproperty


  //-----------------------------------
  //  Stalling Checks
  //-----------------------------------

  property Stall;
    @(posedge clk)
     (ResultSrc_E_0 && ((Rs1_D == Rd_E) || Rs2_D == Rd_E))
     |-> ((Stall_D == 1'b1) && (Stall_F == 1'b1) && (Flush_E == 1'b1));
  endproperty


  //-----------------------------------
  //  Branch Misprediction Flush Checks
  //-----------------------------------

  property Flush;
    @(posedge clk) (PCSrc_E) |-> ((Flush_D == 1'b1) && (Flush_E == 1'b1));
  endproperty


  //-----------------------------------
  //  Branch Misprediction Flush Checks
  //-----------------------------------

  assert property (ForwardA_MEM)
  else $error("MEM Forwarding Error");

  assert property (ForwardA_WB)
  else $error("WB Forwarding Error");

  assert property (No_ForwardA)
  else $error("Error when no forwarding");

  assert property (Stall)
  else
    $error(
        "Stalling error: ResultSrc_E_0 = %d,\n Rs1_D = %d,\n Rs2_D = %d,\n Rd_E = %d,\n Stall_D = %d, Stall_F = %d, Flush_E = %d",
        ResultSrc_E_0,
        Rs1_D,
        Rs2_D,
        Rd_E,
        Stall_D,
        Stall_F,
        Flush_E
    );

  assert property (Flush)
  else $error("Branch Misprediction Flushing Error");

endmodule
