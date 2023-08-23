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
    .MemRead(MemRead),
    .MemtoReg(MemtoReg),
    .ALUOp(ALUOp),
    .MemWrite(MemWrite),
    .ALUSrc(ALUSrc),
    .RegWrite(RegWrite)
  );

  wire [31:0] idLHSRegisterValue;
  wire [31:0] idRHSRegisterValue;

  wire branch;
  wire MemRead;
  wire MemtoReg;
  wire ALUOp;
  wire MemWrite;
  wire ALUSrc;
  wire RegWrite;

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
