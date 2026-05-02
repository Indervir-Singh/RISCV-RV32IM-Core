`timescale 1ns / 1ps
module reg_file #(parameter WIDTH = 32)
(
    input logic clk,
    input logic we,
    input logic [4:0] A1, A2, A3,
    input logic [$clog2(WIDTH)-1:0] selected_reg,
    input logic [WIDTH-1:0] wd,
    output logic [WIDTH-1:0] rd1, rd2,
    output logic [WIDTH-1:0] output_reg
    );
    
    logic [WIDTH-1:0] Registers [31:0];
    
    always_ff @(posedge clk)
    begin
        if (we && A3 != 5'b0)
        begin
            Registers[A3] <= wd;
        end
    end
    
    assign rd1 = (A1 == 5'b0) ? WIDTH'(1'b0) : (Registers[A1]);
    assign rd2 = (A2 == 5'b0) ? WIDTH'(1'b0) : (Registers[A2]);

    assign output_reg = Registers[selected_reg][WIDTH-1:0];
    
endmodule
