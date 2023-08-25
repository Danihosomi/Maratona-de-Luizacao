module Memory (
  input clk,
  input [31:0] address,
  input readWrite,
  input [31:0] dataIn,
  output [31:0] dataOut
);

  reg [31:0] ramData;
  reg [31:0] romData;

  ROMMemory MemoryROM(
    .clk(clk),
    .address(address),
    .data(romData)
  );
  
  RAM MemoryRAM(
    .clk(clk),
    .writeEnable(readWrite & address[10]),
    .address(address),
    .dataIn(dataIn),
    .dataOut(ramData)
  );

  always @(posedge clk) begin
    // ROM
    if (readWrite == 0 && adress[10] == 0) begin
      data <= romData;
    end

    if (adress[10] == 1) begin
      if (readWrite == 0) begin
        dataOut <= ramData;
      end
    end
  end

endmodule
