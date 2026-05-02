`timescale 1ns / 1ps
module uart_RX #(parameter CLKS_PER_BIT = 217)
  (
    input logic clk, srst,
    input logic serial_data,
    output logic data_valid,
    output logic [7:0] data_byte
  );

  logic [$clog2(CLKS_PER_BIT)-1:0] clk_count;
  logic [3:0] bit_index;

  typedef enum logic [2:0] {IDLE, START_BIT, DATA_BITS, STOP_BIT, CLEANUP} statetype;
  statetype state;

  always_ff @(posedge clk)
  begin
    if (srst)
    begin
      data_valid  <= 1'b0;
      clk_count   <= 1'b0;
      bit_index   <= 1'b0;
      data_byte   <= 8'b0;

      state       <= IDLE;
    end
    else
    begin
      case(state)
        IDLE:
        begin
          data_valid  <= 1'b0;
          clk_count   <= 8'b0;
          bit_index   <= 3'b0;

          if (serial_data == 1'b0)
          begin
            state <= START_BIT;
          end
          else
          begin
            state <= IDLE;
          end
        end
        START_BIT:
        begin
          clk_count <= clk_count + 1'b1;
          if (clk_count == (CLKS_PER_BIT-1)/2)
            if (serial_data == 1'b0)
                clk_count <= 8'b0;


          state <= START_BIT;
          if (clk_count == (CLKS_PER_BIT - 1)/2)
          begin
            if (serial_data == 1'b0)
            begin
              state <= DATA_BITS;
            end
            else
            begin
              state <= IDLE;
            end
          end
        end
        DATA_BITS:
        begin
          clk_count <= clk_count + 1'b1;
          if (clk_count == CLKS_PER_BIT-1)
          begin
            data_byte[bit_index] <= serial_data;
            clk_count <= 8'b0;
            if (bit_index == 3'd7)
              bit_index <= 3'b0;
            else
              bit_index <= bit_index + 1'b1;
          end

          state <= DATA_BITS;
          if (clk_count == CLKS_PER_BIT-1)
            if (bit_index == 3'd7)
              state <= STOP_BIT;
        end
        STOP_BIT:
        begin
          clk_count <= clk_count + 1'b1;
          if (clk_count == CLKS_PER_BIT - 1)
          begin
            clk_count <= 8'b0;
            data_valid <= 1;
          end

          state <= STOP_BIT;
          if (clk_count == CLKS_PER_BIT-1)
            state <= CLEANUP;
        end
        CLEANUP:
        begin
          data_valid <= 1'b0;
          clk_count  <= 8'b0;
          bit_index  <= 3'b0;

          state <= IDLE;
        end

        default:
        begin
          data_valid <= 1'b0;
          clk_count  <= 8'b0;
          bit_index  <= 3'b0;

          state  <= IDLE;
        end
      endcase
    end
  end
endmodule
