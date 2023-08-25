module CPU(
  input clk,
  output [31:0] debug
);
  assign debug = instruction;

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
    .writeRegisterIndex(wbWriteRegisterIndex),
    .writeRegisterData(writeBackData),
    .shouldWrite(wbRegWrite),
    .source1RegisterData(idLHSRegisterValue),
    .source2RegisterData(idRHSRegisterValue)
  );

  wire [31:0] idLHSRegisterValue;
  wire [31:0] idRHSRegisterValue;

  Control control(
    .instruction(instruction[6:0]),
    .branch(branch),
    .memRead(memRead),
    .memToReg(memToReg),
    .aluOp(aluOp),
    .memWrite(memWrite),
    .aluSrc(aluSrc),
    .regWrite(regWrite)
  );

  wire branch;
  wire [1:0] aluOp;
  wire aluSrc;
  wire memRead;
  wire memWrite;
  wire memToReg;
  wire regWrite;

  ImmediateGeneration ImmediateGeneration(
    .instruction(instruction),
    .immediate(idImmediateValue)
  );

  wire [31:0] idImmediateValue;

  ID_EX_Barrier id_ex_barrier(
    .clk(clk),
    .idLHSRegisterValue(idLHSRegisterValue),
    .idRHSRegisterValue(idRHSRegisterValue),
    .idLHSRegisterIndex(instruction[19:15]),
    .idRHSRegisterIndex(instruction[24:20]),
    .idWriteRegisterIndex(instruction[11:7]),
    .idImmediateValue(idImmediateValue),
    .idFunct3(instruction[14:12]),
    .idFunct7(instruction[31:25]),
    .idAluOp(aluOp),
    .idAluSrc(aluSrc),
    .idMemWrite(memWrite),
    .idMemRead(memRead),
    .idMemToReg(memToReg),
    .idRegWrite(regWrite),
    .exLHSRegisterValue(exLHSRegisterValue),
    .exRHSRegisterValue(exRHSRegisterValue),
    .exLHSRegisterIndex(exLHSRegisterIndex),
    .exRHSRegisterIndex(exRHSRegisterIndex),
    .exWriteRegisterIndex(exWriteRegisterIndex),
    .exImmediateValue(exImmediateValue),
    .exAluOp(exAluOp),
    .exAluSrc(exAluSrc),
    .exMemWrite(exMemWrite),
    .exMemRead(exMemRead),
    .exMemToReg(exMemToReg),
    .exRegWrite(exRegWrite)
  );

  wire [31:0] exLHSRegisterValue;
  wire [31:0] exRHSRegisterValue;
  wire [4:0] exLHSRegisterIndex;
  wire [4:0] exRHSRegisterIndex;
  wire [4:0] exWriteRegisterIndex;
  wire [31:0] exImmediateValue;
  wire [2:0] exFunct3;
  wire [6:0] exFunct7;
  wire [1:0] exAluOp;
  wire exAluSrc;
  wire exMemWrite;
  wire exMemRead;
  wire exMemToReg;
  wire exRegWrite;

  wire [31:0] exRHSInput;
  assign exRHSInput = (exAluSrc) ? exImmediateValue : exRHSRegisterValue;

  // Hazard handling
  ForwardingUnit lhsForwardingUnit(
    .executeStageReadRegisterIndex(exLHSRegisterIndex),
    .memoryStageWriteRegisterIndex(memWriteRegisterIndex),
    .writebackStageWriteRegisterIndex(wbWriteRegisterIndex),
    .isMemoryStageWrite(memRegWrite),
    .isWritebackStageWrite(wbRegWrite),
    .forwardSelect(lhsAluInputSelect)
  );

  ForwardingUnit rhsForwardingUnit(
    .executeStageReadRegisterIndex(exRHSRegisterIndex),
    .memoryStageWriteRegisterIndex(memWriteRegisterIndex),
    .writebackStageWriteRegisterIndex(wbWriteRegisterIndex),
    .isMemoryStageWrite(memRegWrite),
    .isWritebackStageWrite(wbRegWrite),
    .forwardSelect(rhsAluInputSelect)
  );

  wire [1:0] lhsAluInputSelect;
  wire [1:0] rhsAluInputSelect;

  // TODO: Mux for alu input on lhsAluInputSelect
  // 00 -> exLHSRegisterValue
  // 01 -> writeBackData
  // 10 -> memAluResult

  // TODO: Mux for alu input on rhsAluInputSelect
  // 00 -> exRHSInput
  // 01 -> writeBackData
  // 10 -> memAluResult


  // TODO: ALU control and ALU
  ALUControl aluControl(
    .ALUOp(exAluOp),
    .func3(exFunct3),
    .func7(exFunct7),
    .result(aluControlInput)
  );

  wire [3:0] aluControlInput;

  Alu alu(
    .ALUControl(aluControlInput),
    .operand1(exLHSRegisterValue),
    .operand2(exRHSRegisterValue),
    .resultALU(resultALU),
    .zero(zero)
  );

  wire [31:0] resultALU;
  wire zero;

  EX_MEM_Barrier ex_mem_barrier(
    .clk(clk),
    .exAluResult(resultALU),
    .exMemoryWriteData(exRHSRegisterValue),
    .exWriteRegisterIndex(exWriteRegisterIndex),
    .exMemWrite(exMemWrite),
    .exMemRead(exMemRead),
    .exMemToReg(exMemToReg),
    .exRegWrite(exRegWrite),
    .memAluResult(memAluResult),
    .memMemoryWriteData(memMemoryWriteData),
    .memWriteRegisterIndex(memWriteRegisterIndex),
    .memMemWrite(memMemWrite),
    .memMemRead(memMemRead),
    .memMemToReg(memMemToReg),
    .memRegWrite(memRegWrite)
  );

  wire [31:0] memAluResult;
  wire [31:0] memMemoryWriteData;
  wire [4:0] memWriteRegisterIndex;
  wire memMemWrite;
  wire memMemRead;
  wire memMemToReg;
  wire memRegWrite;

  DataMemory dataMemory(
    .clk(clk),
    .memWrite(memMemWrite),
    .memRead(memMemRead), // TODO: add Memory read to the pipeline
    .address(memAluResult),
    .writeData(memMemoryWriteData),
    .readData(memMemoryData)
  );

  wire [31:0] memMemoryData;

  MEM_WB_Barrier mem_wb_barrier(
    .clk(clk),
    .memMemoryData(memMemoryData),
    .memExecutionData(memAluResult),
    .memWriteRegisterIndex(memWriteRegisterIndex),
    .memMemToReg(memMemToReg),
    .memRegWrite(memRegWrite),
    .wbMemoryData(wbMemoryData),
    .wbExecutionData(wbExecutionData),
    .wbWriteRegisterIndex(wbWriteRegisterIndex),
    .wbMemToReg(wbMemToReg),
    .wbRegWrite(wbRegWrite)
  );

  wire [31:0] wbMemoryData;
  wire [31:0] wbExecutionData;
  wire [4:0] wbWriteRegisterIndex;
  wire wbMemToReg;
  wire wbRegWrite;

  // WriteBack mux
  assign writeBackData = (wbMemToReg) ? wbMemoryData : wbExecutionData;

  wire [31:0] writeBackData;

endmodule
