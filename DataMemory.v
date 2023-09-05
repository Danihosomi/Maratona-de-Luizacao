module DataMemory (
  input memWrite,
  input memRead,
  input [31:0] address,
  input [31:0] writeData,
  output reg [31:0] readData
);

RAM DataMemoryRAM(
  .writeEnable(memWrite),
  .readEnable(memRead),
  .address(address),
  .dataIn(writeData),
  .dataOut(readData)
);

endmodule
