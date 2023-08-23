module CPU(
  input clk
);
  wire [31:0] instruction;
  wire branch;
  wire memRead;
  wire memToReg;
  wire aluOp;
  wire memWrite;
  wire aluSrc;
  wire regWrite;

  InstructionFetch instructionFetch(
    .clk(clk),
    .instruction(instruction)
  );

  Control control(
    instruction,
    branch,
    memRead,
    memToReg,
    aluOp,
    memWrite,
    aluSrc,
    regWrite
  );

endmodule
