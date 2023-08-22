module CPU(
  input clk
);
  wire [31:0] instruction;
  wire branch;
  wire MemRead;
  wire MemtoReg;
  wire ALUOp;
  wire MemWrite;
  wire ALUSrc;
  wire RegWrite;

  InstructionFetch instructionFetch(
    .clk(clk),
    .instruction(instruction)
  );

  Control control(
    instruction,
    branch,
    MemRead,
    MemtoReg,
    ALUOp,
    MemWrite,
    ALUSrc,
    RegWrite
  );

endmodule
