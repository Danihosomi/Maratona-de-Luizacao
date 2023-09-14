module StallUnit(
  input [4:0] decodeStageLHSReadRegisterIndex,
  input [4:0] decodeStageRHSReadRegisterIndex,
  input [4:0] executionStageWriteRegisterIndex,
  input isExecutionStageMemoryReadOperation,
  output isPipelineStalled
);
assign isPipelineStalled = (isExecutionStageMemoryReadOperation && (
  executionStageWriteRegisterIndex == decodeStageRHSReadRegisterIndex || 
  executionStageWriteRegisterIndex == decodeStageLHSReadRegisterIndex
));
endmodule
