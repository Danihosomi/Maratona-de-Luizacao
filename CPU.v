module CPU(
  input clk
);
  wire [31:0] instruction;

  InstructionFetch instructionFetch(
    .clk(clk),
    .instruction(instruction)
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

  // Control control(
  //   instruction,
  //   branch,
  //   memRead,
  //   memToReg,
  //   aluOp,
  //   memWrite,
  //   aluSrc,
  //   regWrite
  // );

  wire branch;
  wire memRead;
  wire memToReg;
  wire aluOp;
  wire memWrite;
  wire aluSrc;
  wire regWrite;

  ID_EX_Barrier id_ex_barrier(
    .clk(clk),
    .idLHSRegisterValue(idLHSRegisterValue),
    .idRHSRegisterValue(idRHSRegisterValue),
    .idIsMemoryWrite(memWrite),
    .idShouldUseMemoryData(memToReg),
    .idIsRegisterWrite(regWrite),
    .exLHSRegisterValue(exLHSRegisterValue),
    .exRHSRegisterValue(exRHSRegisterValue),
    .exIsMemoryWrite(exIsMemoryWrite),
    .exShouldUseMemoryData(exShouldUseMemoryData),
    .exIsRegisterWrite(exIsRegisterWrite)
  );

  wire [31:0] exLHSRegisterValue;
  wire [31:0] exRHSRegisterValue;
  wire exIsMemoryWrite;
  wire exShouldUseMemoryData;
  wire exIsRegisterWrite;

  // TODO: Execution stage

  EX_MEM_Barrier ex_mem_barrier(
    .clk(clk),
    .exAluResult(1),
    .exMemoryWriteData(1),
    .exIsMemoryWrite(exIsMemoryWrite),
    .exShouldUseMemoryData(exShouldUseMemoryData),
    .exIsRegisterWrite(exIsRegisterWrite),
    .memAluResult(memAluResult),
    .memMemoryWriteData(memMemoryWriteData),
    .memIsMemoryWrite(memIsMemoryWrite),
    .memShouldUseMemoryData(memShouldUseMemoryData),
    .memIsRegisterWrite(memIsRegisterWrite)
  );

  wire [31:0] memAluResult;
  wire [31:0] memMemoryWriteData;
  wire memIsMemoryWrite;
  wire memShouldUseMemoryData;
  wire memIsRegisterWrite;

  // Memory memory(
  //   .clk(clk),
  //   .address(memAluResult), // The address come from the ALU
  //   .readWrite(memIsMemoryWrite), // TODO: the design actually uses 2 flags, as it is possible that it is neither read nor write
  //   .data(memMemoryData)
  // );

  wire [31:0] memMemoryData;

  MEM_WB_Barrier mem_wb_barrier(
    .clk(clk),
    .memMemoryData(memMemoryData),
    .memExecutionData(memAluResult),
    .memShouldUseMemoryData(memShouldUseMemoryData),
    .memIsRegisterWrite(memIsRegisterWrite),
    .wbMemoryData(wbMemoryData),
    .wbExecutionData(wbExecutionData),
    .wbShouldUseMemoryData(wbShouldUseMemoryData),
    .wbIsRegisterWrite(wbIsRegisterWrite)
  );

  wire [31:0] wbMemoryData;
  wire [31:0] wbExecutionData;
  wire wbShouldUseMemoryData;
  wire wbIsRegisterWrite;

  WriteBackStage writeBackStage(
    .memoryData(wbMemoryData),
    .executionData(wbExecutionData),
    .shouldUseMemoryData(wbShouldUseMemoryData),
    .dataToWrite(writeBackData)
  );

  wire [31:0] writeBackData;

endmodule
