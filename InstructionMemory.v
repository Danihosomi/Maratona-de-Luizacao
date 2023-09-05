module InstructionMemory (
  input [31:0] readAddress,
  output [31:0] instruction
);

ROMMemory instructionMemoryROM(
  .address(readAddress),
  .data(instruction)
);

endmodule
