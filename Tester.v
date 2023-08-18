module Tester();
  parameter CLK_HALF_PERIOD = 5;
  parameter MAX_CYCLES = 1000; // Stores the number of clock cycles we want to test
  
  reg clk;
  wire [31:0] instruction;

  InstructionFetch instructionFetch(
    .clk(clk),
    .instruction(instruction)
  );

  initial begin
    forever clk = #( CLK_HALF_PERIOD )  ~clk;
  end

  integer curr_cycle = 0;
  always @(posedge clk) begin
    if (curr_cycle != MAX_CYCLES) begin
      if (instruction != 0) begin
        $display(instruction);
      end
      curr_cycle++;
    end
  end
endmodule
