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

ROMMemory MemoryROM(
  .address(address),
  .data(romData)
);

RAM MemoryRAM(
  .clk(clk),
  .writeEnable(writeEnable & address[10]),
  .readEnable(readEnable & address[10]),
  .address(address),
  .dataIn(dataIn),
  .dataOut(ramData)
);

always @* begin
  dataOut = 0;
  // ROM
  if (readEnable == 1 && address[10] == 0) begin
    dataOut = romData;
  end

  // RAM
  if (readEnable == 1 && address[10] == 1) begin
    dataOut = ramData;
  end
end

endmodule
