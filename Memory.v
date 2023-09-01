module Memory (
  input [31:0] address,
  input writeEnable,
  input readEnable,
  input [31:0] dataIn,
  output [31:0] dataOut
);

  reg [31:0] ramData;
  reg [31:0] romData;

  ROMMemory MemoryROM(
    .address(address),
    .data(romData)
  );
  
  RAM MemoryRAM(
    .writeEnable(writeEnable & address[10]),
    .readEnable(readEnable & address[10]),
    .address(address),
    .dataIn(dataIn),
    .dataOut(ramData)
  );

  always @* begin
    // ROM
    if (readEnable == 1 && adress[10] == 0) begin
      dataOut = romData;
    end

    // RAM
    if (readEnable == 1 && adress[10] == 1) begin
      dataOut = ramData;
    end
  end

endmodule
