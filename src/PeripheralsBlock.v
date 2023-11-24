module PeripheralsBlock(
  input clk,
  input readEnable,
  input writeEnable,
  input [30:0] address,
  input [31:0] dataIn,
  output [31:0] dataOut,

  // Peripherals
  input button,
  output [5:0] led,
  output [7:0] ledMatrixRow,
  output [7:0] ledMatrixColumn
);

  wire isLedTargeted = address[30:28] == 3'b000; // address starts with 0x8
  LedPeripheral ledPeripheral(
    .clk(clk),
    .isTarget(isLedTargeted && writeEnable),
    .address(address[27:0]),
    .data(dataIn),
    .led(led)
  );

  wire isButtonTargeted = address[30:28] == 3'b001; // address starts with 0x9
  ButtonPeripheral buttonPeripheral(
    .clk(clk),
    .isTarget(isButtonTargeted && readEnable),
    .address(address[27:0]),
    .value(dataOut),
    .button(button)
  );

  wire isLedMatrixTargeted = address[30:28] == 3'b010; // address starts with 0xA
  LedMatrixPeripheral ledMatrixPeripheral(
    .clk(clk),
    .isTarget(isLedMatrixTargeted && writeEnable),
    .data(dataIn),
    .ledMatrixRow(ledMatrixRow),
    .ledMatrixColumn(ledMatrixColumn)
  );

endmodule
