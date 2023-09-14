module RAM(
  input writeEnable,
  input readEnable,
  input [31:0] address,
  input [31:0] dataIn,
  output reg [31:0] dataOut
);

reg [31:0] memory [255:0];

always @(address, dataIn, writeEnable, readEnable) begin
  if (writeEnable == 1) begin
    memory[address[9:2]] <= dataIn;
  end

  if (readEnable == 1) begin
    dataOut <= memory[address[9:2]];
  end
  else begin
    dataOut <= 0;
  end
end

endmodule
