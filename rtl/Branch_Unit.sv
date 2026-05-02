`timescale 1ns / 1ps
module Branch_Unit
  (
    input  logic  sign_bit, z_flag , Branch, PCUpdate,               // B_data is register value
    input  logic [1:0] funct3_2_0,
    output logic PCWrite                    // Final PC select
  );

  logic mux_out;

  // 4x1 MUX
  MUX_4 #(.WIDTH(1)) Branch_Mux(
          .A(z_flag),
          .B(!z_flag),
          .C(sign_bit),
          .D(!sign_bit),
          .Sel(funct3_2_0),
          .Y(mux_out)
        );

  // AND gate with Branch control
  logic and_out;
  assign and_out = mux_out & Branch;

  // OR gate with PCUpdate
  assign PCWrite = and_out | PCUpdate;

endmodule
