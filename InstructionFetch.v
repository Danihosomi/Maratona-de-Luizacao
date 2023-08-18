module InstructionFetch(
  input clk,
  output [31:0] instruction
); 
  wire [31:0] pc;
  wire [31:0] nextPc;

  assign nextPc = pc + 1;

  ProgramCounter programCounter(
    .clk(clk),
    .nextAddress(nextPc),
    .currentAddress(pc)
  );

  InstructionMemoryAccess instructionMemory(
    .MemoryAddress(pc),
    .Instruction32b(instruction)
  );

endmodule