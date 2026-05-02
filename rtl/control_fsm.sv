`timescale 1ns / 1ps
module control_fsm
  (
    input logic clk,
    input logic srst,
    input logic uart_over,
    input logic [6:0] opcode,
    output logic PCUpdate,
    output logic MemWrite,
    output logic IRWrite,
    output logic RegWrite,
    output logic WrDataSrc,
    output logic [1:0] AdrSrc,
    output logic [1:0] ALUSrcA, ALUSrcB,
    output logic [1:0] ALUOp,
    output logic [1:0] ResultSrc,
    output logic Branch
  );

  typedef enum logic [3:0]
          {S0_UART, S1_FETCH, S2_DECODE, S3_MEMADR, S4_MEMREAD, S5_MEMWB, S6_MEMWRITE, S7_EXECUTER, S8_ALUWB, S9_BRANCH, S10_EXECUTEI, S11_JAL, S12_LUI}
          statetype;
  statetype state, nextstate;

  always_ff @(posedge clk)
  begin
    if (srst)
      state <= S0_UART;
    else
      state <= nextstate;
  end

  always_comb
  begin
    case(state)
      S0_UART:
      begin
        PCUpdate  = 1'b0;
        MemWrite  = 1'b0;
        IRWrite   = 1'b0;
        RegWrite  = 1'b0;
        Branch    = 1'b0;
        WrDataSrc = 1'b1;
        AdrSrc    = 2'b10;
        ALUSrcA   = 2'b00;
        ALUSrcB   = 2'b00;
        ResultSrc = 2'b00;
        ALUOp     = 2'b00;

        if (uart_over)
          nextstate = S1_FETCH;
        else
          nextstate = S0_UART;
      end
      S1_FETCH:       // Instruction Fetch and PC Increment
      begin
        PCUpdate  = 1'b1;
        MemWrite  = 1'b0;
        IRWrite   = 1'b1;
        RegWrite  = 1'b0;
        Branch    = 1'b0;
        WrDataSrc = 1'b0;
        AdrSrc    = 2'b0;
        ALUSrcA   = 2'b00;
        ALUSrcB   = 2'b10;
        ResultSrc = 2'b10;
        ALUOp     = 2'b00;

        nextstate = S2_DECODE;
      end
      S2_DECODE:      // Decoding and Branch/Jump Target Address Calculation
      begin
        PCUpdate  = 1'b0;
        MemWrite  = 1'b0;
        IRWrite   = 1'b0;
        RegWrite  = 1'b0;
        Branch    = 1'b0;
        WrDataSrc = 1'b0;
        AdrSrc    = 2'b0;
        ALUSrcA   = 2'b01;
        ALUSrcB   = 2'b01;
        ResultSrc = 2'b00;
        ALUOp     = 2'b00;

        case(opcode)
          7'h03,
          7'h23:
            nextstate = S3_MEMADR;      // LW/SW
          7'h33:
            nextstate = S7_EXECUTER;    // R-Type
          7'h63:
            nextstate = S9_BRANCH;      // B-Type
          7'h13:
            nextstate = S10_EXECUTEI;    // I-Type
          7'h6F:
            nextstate = S11_JAL;        // JAL
          7'h37:
            nextstate = S12_LUI;        // LUI
          default:
            nextstate = S1_FETCH;
        endcase
      end
      S3_MEMADR:      // Memory Address Calculation for LW and SW
      begin
        PCUpdate  = 1'b0;
        MemWrite  = 1'b0;
        IRWrite   = 1'b0;
        RegWrite  = 1'b0;
        Branch    = 1'b0;
        WrDataSrc = 1'b0;
        AdrSrc    = 2'b0;
        ALUSrcA   = 2'b10;
        ALUSrcB   = 2'b01;
        ResultSrc = 2'b00;
        ALUOp     = 2'b00;

        case(opcode)
          7'h03:
            nextstate = S4_MEMREAD;     // LW
          7'h23:
            nextstate = S6_MEMWRITE;    // SW
          default:
            nextstate = S1_FETCH;
        endcase
      end
      S4_MEMREAD:     // Memory read at calculated address for LW
      begin
        PCUpdate  = 1'b0;
        MemWrite  = 1'b0;
        IRWrite   = 1'b0;
        RegWrite  = 1'b0;
        Branch    = 1'b0;
        WrDataSrc = 1'b0;
        AdrSrc    = 2'b1;
        ALUSrcA   = 2'b00;
        ALUSrcB   = 2'b00;
        ResultSrc = 2'b00;
        ALUOp     = 2'b00;

        nextstate = S5_MEMWB;
      end
      S5_MEMWB:       // Read data written in  Reg File
      begin
        PCUpdate  = 1'b0;
        MemWrite  = 1'b0;
        IRWrite   = 1'b0;
        RegWrite  = 1'b1;
        Branch    = 1'b0;
        WrDataSrc = 1'b0;
        AdrSrc    = 2'b0;
        ALUSrcA   = 2'b00;
        ALUSrcB   = 2'b00;
        ResultSrc = 2'b01;
        ALUOp     = 2'b00;

        nextstate = S1_FETCH;
      end
      S6_MEMWRITE:    // Reg data written in memory at calculated address for SW
      begin
        PCUpdate  = 1'b0;
        MemWrite  = 1'b1;
        IRWrite   = 1'b0;
        RegWrite  = 1'b0;
        Branch    = 1'b0;
        WrDataSrc = 1'b0;
        AdrSrc    = 2'b1;
        ALUSrcA   = 2'b00;
        ALUSrcB   = 2'b00;
        ResultSrc = 2'b00;
        ALUOp     = 2'b00;

        nextstate = S1_FETCH;
      end
      S7_EXECUTER:    // R-type instruction as decoded by ALU_Control is performed
      begin
        PCUpdate  = 1'b0;
        MemWrite  = 1'b0;
        IRWrite   = 1'b0;
        RegWrite  = 1'b0;
        Branch    = 1'b0;
        WrDataSrc = 1'b0;
        AdrSrc    = 2'b0;
        ALUSrcA   = 2'b10;
        ALUSrcB   = 2'b00;
        ResultSrc = 2'b00;
        ALUOp     = 2'b10;

        nextstate = S8_ALUWB;
      end
      S8_ALUWB:       // ALU Output written back in reg file
      begin
        PCUpdate  = 1'b0;
        MemWrite  = 1'b0;
        IRWrite   = 1'b0;
        RegWrite  = 1'b1;
        Branch    = 1'b0;
        WrDataSrc = 1'b0;
        AdrSrc    = 2'b0;
        ALUSrcA   = 2'b00;
        ALUSrcB   = 2'b00;
        ResultSrc = 2'b00;
        ALUOp     = 2'b00;

        nextstate = S1_FETCH;
      end
      S9_BRANCH:      // Branch condition checked
      begin
        PCUpdate  = 1'b0;
        MemWrite  = 1'b0;
        IRWrite   = 1'b0;
        RegWrite  = 1'b0;
        Branch    = 1'b1;
        WrDataSrc = 1'b0;
        AdrSrc    = 2'b0;
        ALUSrcA   = 2'b10;
        ALUSrcB   = 2'b00;
        ResultSrc = 2'b00;
        ALUOp     = 2'b01;

        nextstate = S1_FETCH;
      end
      S10_EXECUTEI:    // I-Type instruction as decoded by ALU_Control is performed
      begin
        PCUpdate  = 1'b0;
        MemWrite  = 1'b0;
        IRWrite   = 1'b0;
        RegWrite  = 1'b0;
        Branch    = 1'b0;
        WrDataSrc = 1'b0;
        AdrSrc    = 2'b0;
        ALUSrcA   = 2'b10;
        ALUSrcB   = 2'b01;
        ResultSrc = 2'b00;
        ALUOp     = 2'b10;

        nextstate = S8_ALUWB;
      end
      S11_JAL:        // Jump target address written to PC, Return Address Calculated by ALU
      begin
        PCUpdate  = 1'b1;
        MemWrite  = 1'b0;
        IRWrite   = 1'b0;
        RegWrite  = 1'b0;
        Branch    = 1'b0;
        WrDataSrc = 1'b0;
        AdrSrc    = 2'b0;
        ALUSrcA   = 2'b01;
        ALUSrcB   = 2'b10;
        ResultSrc = 2'b00;
        ALUOp     = 2'b00;

        nextstate = S8_ALUWB;
      end
      S12_LUI:        // Immediate loaded into the reg file
      begin
        PCUpdate  = 1'b0;
        MemWrite  = 1'b0;
        IRWrite   = 1'b0;
        RegWrite  = 1'b1;
        Branch    = 1'b0;
        WrDataSrc = 1'b0;
        AdrSrc    = 2'b0;
        ALUSrcA   = 2'b00;
        ALUSrcB   = 2'b00;
        ResultSrc = 2'b11;
        ALUOp     = 2'b00;

        nextstate = S1_FETCH;
      end
      default:
      begin
        PCUpdate  = 1'b0;
        MemWrite  = 1'b0;
        IRWrite   = 1'b0;
        RegWrite  = 1'b0;
        Branch    = 1'b0;
        WrDataSrc = 1'b0;
        AdrSrc    = 2'b0;
        ALUSrcA   = 2'b00;
        ALUSrcB   = 2'b00;
        ResultSrc = 2'b00;
        ALUOp     = 2'b00;

        nextstate = S1_FETCH;
      end
    endcase
  end
endmodule
