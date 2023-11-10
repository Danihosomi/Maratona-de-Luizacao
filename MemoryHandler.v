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
  output reg [31:0] instructionMemoryDataOut,  // InstructionMemory success signal,

  // Peripherals
  input button,
  output [5:0] led,
  output [7:0] ledMatrixRow,
  output [7:0] ledMatrixColumn
);

reg [31:0] address;
reg writeEnable;
reg readEnable;
reg [31:0] dataIn;
wire [31:0] dataOut = isMemoryTarget ? memoryDataOut : peripheralDataOut;

wire [31:0] memoryDataOut;
wire [31:0] peripheralDataOut;

// Should we create a memory bus?
wire isMemoryTarget = address[31] == 0;
Memory memory(
  .clk(clk),
  .address(address),
  .writeEnable(isMemoryTarget && writeEnable),
  .readEnable(isMemoryTarget && readEnable),
  .dataIn(dataIn),
  .dataOut(memoryDataOut)
);

wire isPeripheralTarget = address[31] == 1;
PeripheralsBlock peripherals(
  .clk(clk),
  .readEnable(isPeripheralTarget && readEnable),
  .writeEnable(isPeripheralTarget && writeEnable),
  .address(address[30:0]),
  .dataIn(dataIn),
  .dataOut(peripheralDataOut),
  .button(button),
  .led(led),
  .ledMatrixRow(ledMatrixRow),
  .ledMatrixColumn(ledMatrixColumn)
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
