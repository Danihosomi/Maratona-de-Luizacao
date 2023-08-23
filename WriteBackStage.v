module WriteBackStage(
  input [31:0] memoryData,
  input [31:0] executionData,
  input shouldUseMemoryData,
  output [31:0] dataToWrite 
);

  assign dataToWrite = (shouldUseMemoryData) ? memoryData : executionData;

endmodule
