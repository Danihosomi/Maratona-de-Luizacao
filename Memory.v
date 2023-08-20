module Memory (
  input [31:0] address,
  input readWrite,
  reg [31:0] data
);

  reg [31:0] ram [255:0];
  reg [31:0] romData;

  ROM MemoryROM(
    .address(address),
    .data(romData)
  );

  always @(*) begin
    // ROM
    if (readWrite == 0 && adress[10] == 0) begin
      data <= romData;
    end

    if (adress[10] == 1) begin
      if (readWrite == 0) begin
        data <= mem[adress[9:2]];
      end
      else begin
        mem[adress[9:2]] <= data;
      end
    end
  end

endmodule
