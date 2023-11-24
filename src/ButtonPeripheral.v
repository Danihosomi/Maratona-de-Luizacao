module ButtonPeripheral(
  input clk,
  input isTarget,
  input [27:0] address,
  output [31:0] value,

  input button
);

assign value = isTarget ? { 31'b0, button } : 0;

endmodule
