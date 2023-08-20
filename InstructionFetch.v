module InstructionFetch(
  input clk,
  output [31:0] instruction
); 
  wire [31:0] pc;
  wire [31:0] nextPc;

  assign nextPc = pc + 4;

  ProgramCounter programCounter(
    .clk(clk),
    .nextAddress(nextPc),
    .currentAddress(pc)
  );

  InstructionMemory instructionMemory(
    .address(pc),
    .data(instruction)
  );

endmodule
