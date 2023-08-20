module CPU(
  input clk
);
  wire [31:0] instruction;

  InstructionFetch instructionFetch(
    .clk(clk),
    .instruction(instruction)
  );

endmodule
