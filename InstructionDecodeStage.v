module InstructionDecodeStage(
  input clk,
  input [31:0] instruction,
  input [31:0] writeBackData,
  input shouldWriteToRegister,
  output [31:0] LHSRegisterValue,
  output [31:0] RHSRegisterValue,
  output branch,
  output MemRead,
  output MemtoReg,
  output ALUOp,
  output MemWrite,
  output ALUSrc,
  output RegWrite
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

  RegisterFile registerFile(
    .clk(clk),
    .source1RegisterIndex(instruction[19:15]),
    .source2RegisterIndex(instruction[24:20]),
    .writeRegisterIndex(instruction[11:7]),
    .writeRegisterData(writeBackData),
    .shouldWrite(shouldWriteToRegister),
    .source1RegisterData(LHSRegisterValue),
    .source2RegisterData(RHSRegisterValue)
  );
endmodule
