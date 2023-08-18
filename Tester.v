module Tester();
  parameter CLK_HALF_PERIOD = 5;
  
  reg clk;
  wire [31:0] instruction;

  InstructionFetch instructionFetch(
    .clk(clk),
    .instruction(instruction)
  );

  initial begin
    forever clk = #( CLK_HALF_PERIOD )  ~clk;
  end

  always @(posedge clk) begin
    $display(instruction);
  end
endmodule