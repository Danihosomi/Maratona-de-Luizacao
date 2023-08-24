module Memory (
  input clk,
  input [31:0] address,
  input readWrite,
  output [31:0] data
);

  reg [31:0] ramData;
  reg [31:0] romData;

  ROM MemoryROM(
    .clk(clk),
    .address(address),
    .data(romData)
  );
  
  RAM MemoryRAM(
    .clk(clk),
    .writeEnable(readWrite & address[10]),
    .address(address),
    .data_in(ramData),
    .data_out(ramData)
  );

  always @(posedge clk) begin
    // ROM
    if (readWrite == 0 && adress[10] == 0) begin
      data <= romData;
    end

    if (adress[10] == 1) begin
      if (readWrite == 0) begin
        data <= ramData;
      end
      else begin
        ramData <= data;
      end
    end
  end

endmodule
