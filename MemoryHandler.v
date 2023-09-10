module MemoryHandler (
  input clk,

  // Signals from DataMemory
  input dataMemoryWriteEnable,   // DataMemory write enable
  input dataMemoryReadEnable,   // DataMemory write enable
  input [31:0] dataMemoryAddress,  // DataMemory address for write
  input [31:0] dataMemoryDataIn,  // Data to write into DataMemory

  // Signals from InstructionMemory
  input [31:0] instructionMemoryAddress,  // InstructionMemory address for read

  // Success signals to DataMemory and InstructionMemory
  output reg [31:0] dataMemoryDataOut,  // Data read to DataMemory
  output reg instructionMemorySuccess,  // InstructionMemory success signal
  output reg [31:0] instructionMemoryDataOut  // InstructionMemory success signal
);

reg [31:0] address;
reg writeEnable;
reg readEnable;
reg [31:0] dataIn;
reg [31:0] dataOut;

Memory memory(
  .clk(clk),
  .address(address),
  .writeEnable(writeEnable),
  .readEnable(readEnable),
  .dataIn(dataIn),
  .dataOut(dataOut)
);

always @* begin
  address = 0;
  writeEnable = 0;
  readEnable = 0;
  dataIn = 0;
  dataMemoryDataOut = 0;
  instructionMemorySuccess = 0;
  instructionMemoryDataOut = 0;

  if (dataMemoryReadEnable == 1) begin
    address = dataMemoryAddress;
    dataMemoryDataOut = dataOut;
    readEnable = 1;
  end

  if (dataMemoryWriteEnable == 1) begin
    address = dataMemoryAddress;
    writeEnable = 1;
    dataIn = dataMemoryDataIn;
  end

  if (dataMemoryWriteEnable == 0 && dataMemoryReadEnable == 0) begin
    address = instructionMemoryAddress;
    instructionMemorySuccess = 1;
    instructionMemoryDataOut = dataOut;
    readEnable = 1;
  end

end

endmodule
