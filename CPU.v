module CPU(
  input clk,
  output [31:0] debug
);
  assign debug = memMemoryData;

  wire isPipelineStalled;

  ProgramCounter programCounter(
    .clk(clk),
    .pc(pc)
  );

  wire [31:0] pc;
  wire [31:0] instruction;

  InstructionMemory instructionMemory(
    .clk(clk),
    .readAddress(pc),
    .instruction(instruction)
  );

  IF_ID_Barrier if_id_barrier(
    .clk(clk),
    .dontUpdate(0),
    .ifInstruction(instruction),
    .idInstruction(idInstruction)
  );

  wire [31:0] idInstruction;
  wire [4:0] idLHSRegisterIndex;
  wire [4:0] idRHSRegisterIndex;

  assign idLHSRegisterIndex = idInstruction[19:15];
  assign idRHSRegisterIndex = idInstruction[24:20];

  StallUnit stallUnit(
    .decodeStageLHSReadRegisterIndex(idLHSRegisterIndex),
    .decodeStageRHSReadRegisterIndex(idRHSRegisterIndex),
    .executionStageWriteRegisterIndex(exWriteRegisterIndex),
    .isExecutionStageMemoryReadOperation(exMemRead),
    .isPipelineStalled(isPipelineStalled)
  );

  RegisterFile registerFile(
    .clk(clk),
    .source1RegisterIndex(idLHSRegisterIndex),
    .source2RegisterIndex(idRHSRegisterIndex),
    .writeRegisterIndex(wbWriteRegisterIndex),
    .writeRegisterData(writeBackData),
    .shouldWrite(wbRegWrite),
    .source1RegisterData(idLHSRegisterValue),
    .source2RegisterData(idRHSRegisterValue)
  );

  wire [31:0] idLHSRegisterValue;
  wire [31:0] idRHSRegisterValue;

  Control control(
    .instruction(idInstruction[6:0]),
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

  ImmediateGeneration immediateGeneration(
    .instruction(idInstruction),
    .immediate(idImmediateValue)
  );

  wire [31:0] idImmediateValue;

  ID_EX_Barrier id_ex_barrier(
    .clk(clk),
    .idLHSRegisterValue(idLHSRegisterValue),
    .idRHSRegisterValue(idRHSRegisterValue),
    .idLHSRegisterIndex(idLHSRegisterIndex),
    .idRHSRegisterIndex(idRHSRegisterIndex),
    .idWriteRegisterIndex(idInstruction[11:7]),
    .idImmediateValue(idImmediateValue),
    .idFunct3(idInstruction[14:12]),
    .idFunct7(idInstruction[31:25]),
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
    .exFunct3(exFunct3),
    .exFunct7(exFunct7),
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

  _MUX4 mux4_lhsAluInputSelect(
    .dataSelector(lhsAluInputSelect),
    .firstData(exLHSRegisterValue),
    .secondData(writeBackData),
    .thirdData(memAluResult),
    .fourthData(32'h00000000),
    .outputData(lhsAluInput)
  );

  wire [31:0] lhsAluInput;

  _MUX4 mux4_rhsAluInputSelect(
    .dataSelector(rhsAluInputSelect),
    .firstData(exRHSInput),
    .secondData(writeBackData),
    .thirdData(memAluResult),
    .fourthData(32'h00000000),
    .outputData(rhsAluInput)
  );

  wire [31:0] rhsAluInput;

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
    .operand1(lhsAluInput),
    .operand2(rhsAluInput),
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
    .memRead(memMemRead),
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
