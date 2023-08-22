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
    .RHSRegisterValue(idRHSRegisterValue)
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

endmodule
