`timescale 1ns / 1ps
module write_driver
  (
    input logic clk, srst,
    input logic data_valid,
    input logic [7:0] data_byte,
    output logic uart_MemWrite,
    output logic [31:0] uart_instr,
    output logic [31:0] uart_mem_adr
  );

  typedef enum logic [2:0] {S0, S1, S2, S3, S4} statetype;
  statetype state;

  logic [1:0] byte_count;
  logic [3:0] [7:0] instr_buffer;
  always_ff @(posedge clk)
  begin
    if (srst)
    begin
      uart_MemWrite <= 1'b0;
      byte_count    <= 2'b0;
      uart_instr    <= 32'b0;
      
      uart_mem_adr  <= 32'b0;

      state     <= S0;
    end

    else
    begin
      case(state)
        S0:
        begin
          byte_count    <= 0;
          uart_MemWrite <= 1'b0;

          if (data_valid)
          begin
            instr_buffer[0] <= data_byte;
            byte_count  <= 2'b1;

            state <= S1;
          end

        end
        S1:
        begin
          if (data_valid)
          begin
            byte_count <= byte_count + 1'b1;
            instr_buffer[byte_count] <= data_byte;

            if (byte_count == 2'b11)
              state <= S2;
          end
        end
        S2:
        begin
          uart_instr <= {instr_buffer[3], instr_buffer[2], instr_buffer[1], instr_buffer[0]};
          uart_MemWrite <= 1'b1;

          state <= S3;
        end
        S3:
        begin
          uart_MemWrite <= 1'b0;
          uart_mem_adr  <= uart_mem_adr + 3'd4;

          state <= S0;
        end
        default:
        begin
          uart_MemWrite <= 1'b0;
          uart_instr    <= 32'b0;
          uart_mem_adr  <= 32'b0;

          state <= S0;
        end
      endcase
    end
  end

endmodule
