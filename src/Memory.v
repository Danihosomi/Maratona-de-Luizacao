module Memory (
  input clk,
  input [31:0] address,
  input writeEnable,
  input readEnable,
  input [31:0] dataIn,
  output reg [31:0] dataOut
);

wire [31:0] ramData;
wire [31:0] romData;

wire isRom = address[31:10] == 0;

ROMMemory MemoryROM(
  .address(address),
  .data(romData)
);

RAM MemoryRAM(
  .clk(clk),
  .writeEnable(writeEnable & !isRom),
  .readEnable(readEnable & !isRom),
  .address(address),
  .dataIn(dataIn),
  .dataOut(ramData)
);

always @* begin
  dataOut = 0;
  // ROM
  if (readEnable == 1 && isRom) begin
    dataOut = romData;
  end

  // RAM
  if (readEnable == 1 && !isRom) begin
    dataOut = ramData;
  end
end

endmodule