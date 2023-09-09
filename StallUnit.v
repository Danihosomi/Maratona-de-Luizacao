module StallUnit(
  input [4:0] decodeStageLHSReadRegisterIndex,
  input [4:0] decodeStageRHSReadRegisterIndex,
  input [4:0] executionStageWriteRegisterIndex,
  input isExecutionStageMemoryReadOperation,
  input isInstructionMemoryBlocked,
  output isPipelineStalled
);
  assign isPipelineStalled = isInstructionMemoryBlocked || 
    (isExecutionStageMemoryReadOperation && (
      executionStageWriteRegisterIndex == decodeStageRHSReadRegisterIndex || 
      executionStageWriteRegisterIndex == decodeStageLHSReadRegisterIndex
  ));
endmodule
