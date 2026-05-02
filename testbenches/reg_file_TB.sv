`timescale 1ns / 1ps
module reg_file_TB(
    );
    
    logic clk, we;
    logic [4:0] A1, A2, A3;
    logic [31:0] wd, rd1, rd2;
    
    reg_file #(.WIDTH(32)) dut(
        .clk(clk),
        .we(we),
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .wd(wd),
        .rd1(rd1),
        .rd2(rd2)
        );
    
    initial
    begin
        clk = 0;
        forever #5 clk = !clk;
    end
    
    integer i;
    
    initial
    begin
        A1 = 0;
        A2 = -1;
        A3 = 0;
        we = 1;
        
        for (i = 0; i < 32; i++)
        begin
            wd <= i + 1'b1;
            @(posedge clk);
            A1 <= A1 + 1'b1;
            A2 <= A2 + 1'b1;
            A3 <= A3 + 1'b1;
        end
        @(posedge clk);
        $finish();
    end
    
endmodule
