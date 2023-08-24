module CPU(
  input clk
);
  wire [31:0] instruction;

  InstructionFetch instructionFetch(
    .clk(clk),
    .instruction(instruction)
  );

  // TODO If/Id barrier

  RegisterFile registerFile(
    .clk(clk),
    .source1RegisterIndex(instruction[19:15]),
    .source2RegisterIndex(instruction[24:20]),
    .writeRegisterIndex(instruction[11:7]),
    .writeRegisterData(writeBackData),
    .shouldWrite(wbRegWrite),
    .source1RegisterData(idLHSRegisterValue),
    .source2RegisterData(idRHSRegisterValue)
  );

  wire [31:0] idLHSRegisterValue;
  wire [31:0] idRHSRegisterValue;

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

  wire branch;
  wire aluOp;
  wire aluSrc;
  wire memRead; // TODO: This must be forwarded
  wire memWrite;
  wire memToReg;
  wire regWrite;

  ID_EX_Barrier id_ex_barrier(
    .clk(clk),
    .idLHSRegisterValue(idLHSRegisterValue),
    .idRHSRegisterValue(idRHSRegisterValue),
    .idAluOp(aluOp),
    .idAluSrc(aluSrc),
    .idMemWrite(memWrite),
    .idMemToReg(memToReg),
    .idRegWrite(regWrite),
    .exLHSRegisterValue(exLHSRegisterValue),
    .exRHSRegisterValue(exRHSRegisterValue),
    .exAluOp(exAluOp),
    .exAluSrc(exAluSrc),
    .exMemWrite(exMemWrite),
    .exMemToReg(exMemToReg),
    .exRegWrite(exRegWrite)
  );

  wire [31:0] exLHSRegisterValue;
  wire [31:0] exRHSRegisterValue;
  wire exAluOp;
  wire exAluSrc;
  wire exMemWrite;
  wire exMemToReg;
  wire exRegWrite;

  // TODO: Execution stage

  EX_MEM_Barrier ex_mem_barrier(
    .clk(clk),
    .exAluResult(1),
    .exMemoryWriteData(1),
    .exMemWrite(exMemWrite),
    .exMemToReg(exMemToReg),
    .exRegWrite(exRegWrite),
    .memAluResult(memAluResult),
    .memMemoryWriteData(memMemoryWriteData),
    .memMemWrite(memMemWrite),
    .memMemToReg(memMemToReg),
    .memRegWrite(memRegWrite)
  );

  wire [31:0] memAluResult;
  wire [31:0] memMemoryWriteData;
  wire memMemWrite;
  wire memMemToReg;
  wire memRegWrite;

  // Memory memory(
  //   .clk(clk),
  //   .address(memAluResult), // The address come from the ALU
  //   .readWrite(memMemWrite), // TODO: the design actually uses 2 flags, as it is possible that it is neither read nor write
  //   .data(memMemoryData)
  // );

  wire [31:0] memMemoryData;

  MEM_WB_Barrier mem_wb_barrier(
    .clk(clk),
    .memMemoryData(memMemoryData),
    .memExecutionData(memAluResult),
    .memMemToReg(memMemToReg),
    .memRegWrite(memRegWrite),
    .wbMemoryData(wbMemoryData),
    .wbExecutionData(wbExecutionData),
    .wbMemToReg(wbMemToReg),
    .wbRegWrite(wbRegWrite)
  );

  wire [31:0] wbMemoryData;
  wire [31:0] wbExecutionData;
  wire wbMemToReg;
  wire wbRegWrite;

  WriteBackStage writeBackStage(
    .memoryData(wbMemoryData),
    .executionData(wbExecutionData),
    .shouldUseMemoryData(wbMemToReg),
    .dataToWrite(writeBackData)
  );

  wire [31:0] writeBackData;

endmodule
