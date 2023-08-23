module CPU(
  input clk
);
  wire [31:0] instruction;

  InstructionFetch instructionFetch(
    .clk(clk),
    .instruction(instruction)
  );

  wire branch;
  wire memRead;
  wire memToReg;
  wire aluOp;
  wire memWrite;
  wire aluSrc;
  wire regWrite;

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

  // TODO If/Id barrier

  InstructionDecodeStage instructionDecodeStage(
    .clk(clk),
    .instruction(instruction),
    .writeBackData(writeBackData),
    .shouldWriteToRegister(wbIsRegisterWrite),
    .LHSRegisterValue(idLHSRegisterValue),
    .RHSRegisterValue(idRHSRegisterValue),
    .branch(branch),
    .MemRead(memRead),
    .MemtoReg(memToReg),
    .ALUOp(aluOp),
    .MemWrite(memWrite),
    .ALUSrc(aluSrc),
    .RegWrite(regWrite)
  );

  wire [31:0] idLHSRegisterValue;
  wire [31:0] idRHSRegisterValue;

  ID_EX_Barrier id_ex_barrier(
    .clk(clk),
    .idLHSRegisterValue(idLHSRegisterValue),
    .idRHSRegisterValue(idRHSRegisterValue),
    .exLHSRegisterValue(exLHSRegisterValue),
    .exRHSRegisterValue(exRHSRegisterValue)
  );

  wire [31:0] exLHSRegisterValue;
  wire [31:0] exRHSRegisterValue;

  // TODO: Execution stage

  // TODO Ex/Mem barrier

  // TODO Mem Stage

  MEM_WB_Barrier mem_wb_barrier(
    .clk(clk),
    .memMemoryData(1),
    .memExecutionData(1),
    .memShouldUseMemoryData(0),
    .memIsRegisterWrite(0),
    .wbMemoryData(wbMemoryData),
    .wbExecutionData(wbExecutionData),
    .wbShouldUseMemoryData(wbShouldUseMemoryData),
    .wbIsRegisterWrite(wbIsRegisterWrite)
  );

  wire [31:0] wbMemoryData;
  wire [31:0] wbExecutionData;
  wire wbShouldUseMemoryData;
  wire wbDataToWrite;
  wire wbIsRegisterWrite;

  WriteBackStage writeBackStage(
    .memoryData(wbMemoryData),
    .executionData(wbExecutionData),
    .shouldUseMemoryData(wbShouldUseMemoryData),
    .dataToWrite(writeBackData)
  );

  wire [31:0] writeBackData;

endmodule
