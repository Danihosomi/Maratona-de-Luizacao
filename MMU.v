module MMU (
  input clk,
  input dataMemoryWriteEnable,
  input dataMemoryReadEnable,
  input [31:0] dataMemoryAddress,
  input [31:0] dataMemoryDataIn,
  input [31:0] instructionMemoryAddress,
  output reg [31:0] dataMemoryDataOut,
  output reg instructionMemorySuccess,
  output reg dataMemorySuccess,
  output reg [31:0] instructionMemoryDataOut,
  output reg [5:0] led
);

wire isPeripheralTarget = instructionMemoryAddress[31];
wire isMemoryTarget = ~isPeripheralTarget;
wire [31:0] unused1;
wire unused2;
wire unused3;

CacheL1 instructionMemoryCacheL1(
  .clk(clk),
  .writeEnable(0),
  .readEnable(1 & isMemoryTarget),
  .address(instructionMemoryAddress),
  .dataIn(0),
  .dataOut(instructionMemoryCacheDataOut),
  .cacheReady(instructionMemorySuccess),
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
  .led(led)
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
  .writeEnable(dataMemoryWriteEnable & isMemoryTarget),
  .readEnable(dataMemoryReadEnable & isMemoryTarget),
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

assign dataMemoryDataOut = isMemoryTarget ? dataMemoryCacheDataOut : dataMemoryMemoryToCacheData;
assign instructionMemoryDataOut = isMemoryTarget ? instructionMemoryCacheDataOut : instructionMemoryMemoryToCacheData;
assign dataMemorySuccess = isMemoryTarget ? dataMemoryCacheSuccess  : 1;

endmodule
