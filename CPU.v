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
    .shouldWriteToRegister(wbRegWrite),
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
    .idMemWrite(memWrite),
    .idMemToReg(memToReg),
    .idRegWrite(regWrite),
    .exLHSRegisterValue(exLHSRegisterValue),
    .exRHSRegisterValue(exRHSRegisterValue),
    .exMemWrite(exMemWrite),
    .exMemToReg(exMemToReg),
    .exRegWrite(exRegWrite)
  );

  wire [31:0] exLHSRegisterValue;
  wire [31:0] exRHSRegisterValue;
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
