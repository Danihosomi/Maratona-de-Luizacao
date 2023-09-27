module PeripheralsBlock(
  input clk,
  input readEnable,
  input writeEnable,
  input [30:0] address,
  input [31:0] dataIn,
  output [5:0] led
);

  wire isLedTargeted = address[30:28] == 3'b000;
  LedPeripheral ledPeripheral(
    .clk(clk),
    .isTarget(isLedTargeted && writeEnable),
    .address(address[27:0]),
    .data(dataIn),
    .led(led)
  );

endmodule
