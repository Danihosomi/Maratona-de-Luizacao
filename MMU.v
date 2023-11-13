module MMU (
  input clk,
  input dataMemoryWriteEnable,
  input dataMemoryReadEnable,
  input [31:0] dataMemoryAddress,
  input [31:0] dataMemoryDataIn,
  input [31:0] instructionMemoryAddress,
  output [31:0] dataMemoryDataOut,
  output instructionMemorySuccess,
  output dataMemorySuccess,
  output [31:0] instructionMemoryDataOut,
  output [5:0] led,
  input button
);

wire instructionMemoryIsPeripheralTarget = instructionMemoryAddress[31];
wire instructionMemoryIsMemoryTarget = ~instructionMemoryIsPeripheralTarget;
wire dataMemoryIsPeripheralTarget = dataMemoryAddress[31];
wire dataMemoryIsMemoryTarget = ~dataMemoryIsPeripheralTarget;
wire [31:0] unused1;
wire unused2;
wire unused3;

CacheL1 instructionMemoryCacheL1(
  .clk(clk),
  .writeEnable(0),
  .readEnable(1),
  .address(instructionMemoryAddress),
  .dataIn(0),
  .dataOut(instructionMemoryCacheDataOut),
  .cacheReady(instructionMemoryCacheSuccess),
  .memoryAddress(instructionMemoryCacheToMemoryAddress),
  .memoryDataIn(instructionMemoryMemoryToCacheData),
  .memoryDataOut(unused1),
  .memoryReadEnable(unused2),
  .memoryWriteEnable(unused3),
  .memoryReady(instructionMemoryMemoryReady)
);

wire [31:0] instructionMemoryMemoryToCacheData;
wire [31:0] instructionMemoryCacheToMemoryAddress;
wire instructionMemoryMemoryReady;
wire [31:0] instructionMemoryCacheDataOut;
wire instructionMemoryCacheSuccess;


MemoryHandler memoryHandler(
  .clk(clk),
  .dataMemoryWriteEnable(dataMemoryCacheToMemoryWriteEnable),
  .dataMemoryReadEnable(dataMemoryCacheToMemoryReadEnable),
  .dataMemoryAddress(dataMemoryCacheToMemoryAddress),
  .dataMemoryDataIn(dataMemoryCacheToMemoryData),
  .instructionMemoryAddress(instructionMemoryCacheToMemoryAddress),
  .dataMemoryDataOut(dataMemoryMemoryToCacheData),
  .instructionMemorySuccess(instructionMemoryMemoryReady),
  .instructionMemoryDataOut(instructionMemoryMemoryToCacheData),
  .led(led),
  .button(button)
);

wire [31:0] dataMemoryCacheToMemoryData;
wire [31:0] dataMemoryMemoryToCacheData;
wire [31:0] dataMemoryCacheToMemoryAddress;
wire dataMemoryCacheToMemoryReadEnable;
wire dataMemoryCacheToMemoryWriteEnable;
wire [31:0] dataMemoryCacheDataOut;
wire dataMemoryCacheSuccess;

CacheL1 dataMemoryCacheL1(
  .clk(clk),
  .writeEnable(dataMemoryWriteEnable),
  .readEnable(dataMemoryReadEnable),
  .address(dataMemoryAddress),
  .dataIn(dataMemoryDataIn),
  .dataOut(dataMemoryCacheDataOut),
  .cacheReady(dataMemoryCacheSuccess),
  .memoryDataIn(dataMemoryMemoryToCacheData),
  .memoryDataOut(dataMemoryCacheToMemoryData),
  .memoryAddress(dataMemoryCacheToMemoryAddress),
  .memoryReadEnable(dataMemoryCacheToMemoryReadEnable),
  .memoryWriteEnable(dataMemoryCacheToMemoryWriteEnable),
  .memoryReady(1)
);

assign dataMemoryDataOut = dataMemoryIsMemoryTarget ? dataMemoryCacheDataOut : dataMemoryMemoryToCacheData;
assign instructionMemoryDataOut = instructionMemoryIsMemoryTarget ? instructionMemoryCacheDataOut : instructionMemoryMemoryToCacheData;
assign dataMemorySuccess = dataMemoryIsMemoryTarget ? dataMemoryCacheSuccess  : 1;
assign instructionMemorySuccess = instructionMemoryIsMemoryTarget ? instructionMemoryCacheSuccess : 1;

endmodule
