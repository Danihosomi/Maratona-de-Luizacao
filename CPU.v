module CPU(
  input clk,
  input rst,

  // Peripherals
  input buttonPeripheral,
  output [5:0] debug,
  output [7:0] ledMatrixRow,
  output [7:0] ledMatrixColumn
);

wire isPipelineStalled;
wire isPipelineFrozen;
wire instructionMemorySuccess;
wire dataMemorySuccess;

MMU mmu(
  .clk(clk),
  .dataMemoryWriteEnable(memMemWrite),
  .dataMemoryReadEnable(memMemRead),
  .dataMemoryAddress(memAluResult),
  .dataMemoryDataIn(memMemoryWriteData),
  .instructionMemoryAddress(pc),
  .dataMemoryDataOut(memMemoryData),
  .dataMemorySuccess(dataMemorySuccess),
  .instructionMemorySuccess(instructionMemorySuccess),
  .instructionMemoryDataOut(instruction),
  .button(buttonPeripheral),
  .led(debug),
  .ledMatrixRow(ledMatrixRow),
  .ledMatrixColumn(ledMatrixColumn)
);

FreezeUnit freezeUnit(
  .isDataMemoryBlocked(~dataMemorySuccess),
  .isPipelineFrozen(isPipelineFrozen)
);

ProgramCounter programCounter(
  .clk(clk),
  .rst(rst),
  .isStalled(isPipelineStalled | isPipelineFrozen),
  .shouldGoToTarget(shouldBranch),
  .jumpTarget(branchTarget),
  .pc(pc)
);

wire [31:0] pc;
wire [31:0] instruction;

IF_ID_Barrier if_id_barrier(
  .clk(clk),
  .rst(rst | shouldBranch),
  .dontUpdate(isPipelineStalled | isPipelineFrozen), // We must not update repeat the instruction
  .ifInstruction(instruction),
  .ifProgramCounter(pc),
  .idInstruction(idInstruction),
  .idProgramCounter(idProgramCounter)
);

wire [31:0] idInstruction;
wire [31:0] idProgramCounter;
wire [4:0] idLHSRegisterIndex;
wire [4:0] idRHSRegisterIndex;
wire [2:0] idFunct3;

assign idLHSRegisterIndex = idInstruction[19:15];
assign idRHSRegisterIndex = idInstruction[24:20];
assign idFunct3 = idInstruction[14:12];

StallUnit stallUnit(
  .decodeStageLHSReadRegisterIndex(idLHSRegisterIndex),
  .decodeStageRHSReadRegisterIndex(idRHSRegisterIndex),
  .executionStageWriteRegisterIndex(exWriteRegisterIndex),
  .isExecutionStageMemoryReadOperation(exMemRead),
  .isInstructionMemoryBlocked(~instructionMemorySuccess),
  .isPipelineStalled(isPipelineStalled)
);

RegisterFile registerFile(
  .clk(clk),
  .rst(rst),
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
  .func3(exFunct3),
  .func7(exFunct7),
  .branch(branch),
  .memRead(memRead),
  .memToReg(memToReg),
  .aluOp(aluOp),
  .memWrite(memWrite),
  .aluSrc(aluSrc),
  .regWrite(regWrite)
);

wire branch;
wire [2:0] aluOp;
wire aluSrc;
wire memRead;
wire memWrite;
wire memToReg;
wire regWrite;
wire [8:0] controlSignals;

assign controlSignals[5:0] = (isPipelineStalled) ? 0 :
                        {branch, aluSrc, memRead, memWrite, memToReg, regWrite};
assign controlSignals[8:6] = (isPipelineStalled) ? 0 : aluOp;

ImmediateGeneration immediateGeneration(
  .instruction(idInstruction),
  .immediate(idImmediateValue)
);

wire [31:0] idImmediateValue;

ID_EX_Barrier id_ex_barrier(
  .clk(clk),
  .rst(rst || shouldBranch),
  .dontUpdate(isPipelineFrozen),
  .idProgramCounter(idProgramCounter),
  .idLHSRegisterValue(idLHSRegisterValue),
  .idRHSRegisterValue(idRHSRegisterValue),
  .idLHSRegisterIndex(idLHSRegisterIndex),
  .idRHSRegisterIndex(idRHSRegisterIndex),
  .idWriteRegisterIndex(idInstruction[11:7]),
  .idImmediateValue(idImmediateValue),
  .idFunct3(idInstruction[14:12]),
  .idFunct7(idInstruction[31:25]),
  .idAluOp(controlSignals[8:6]),
  .idAluSrc(controlSignals[4]),
  .idMemWrite(controlSignals[2]),
  .idMemRead(controlSignals[3]),
  .idMemToReg(controlSignals[1]),
  .idRegWrite(controlSignals[0]),
  .idBranch(controlSignals[5]),
  .exProgramCounter(exProgramCounter),
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
  .exRegWrite(exRegWrite),
  .exBranch(exBranch)
);

wire [31:0] exProgramCounter;
wire [31:0] exLHSRegisterValue;
wire [31:0] exRHSRegisterValue;
wire [4:0] exLHSRegisterIndex;
wire [4:0] exRHSRegisterIndex;
wire [4:0] exWriteRegisterIndex;
wire [31:0] exImmediateValue;
wire [2:0] exFunct3;
wire [6:0] exFunct7;
wire [2:0] exAluOp;
wire exAluSrc;
wire exMemWrite;
wire exMemRead;
wire exMemToReg;
wire exRegWrite;
wire exBranch;

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
  .firstData(exRHSRegisterValue),
  .secondData(writeBackData),
  .thirdData(memAluResult),
  .fourthData(32'h00000000),
  .outputData(rhsAluInput)
);

wire [31:0] rhsAluInput;

ALUControl aluControl(
  .ALUOp(exAluOp),
  .func3(exFunct3),
  .func7(exFunct7),
  .result(aluControlInput)
);

wire [5:0] aluControlInput;

wire [31:0] rhsAluInputWithImmediate; // TODO: Better naming
assign rhsAluInputWithImmediate = (exAluSrc) ? exImmediateValue : rhsAluInput;

Alu alu(
  .ALUControl(aluControlInput),
  .operand1(lhsAluInput),
  .operand2(rhsAluInputWithImmediate),
  .resultALU(resultALU),
  .zero(zero)
);

wire [31:0] resultALU;
wire zero;

BranchUnit branchUnit(
  .aluZero(zero),
  .isBranchOperation(exBranch),
  .programCounter(exProgramCounter),
  .immediate(exImmediateValue),
  .shouldBranch(shouldBranch),
  .branchTarget(branchTarget)
);

wire [31:0] branchTarget;
wire shouldBranch;

EX_MEM_Barrier ex_mem_barrier(
  .clk(clk),
  .rst(rst),
  .dontUpdate(isPipelineFrozen),
  .exAluResult(resultALU),
  .exMemoryWriteData(rhsAluInput),
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

wire [31:0] memMemoryData;

MEM_WB_Barrier mem_wb_barrier(
  .clk(clk),
  .rst(rst),
  .dontUpdate(isPipelineFrozen),
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
