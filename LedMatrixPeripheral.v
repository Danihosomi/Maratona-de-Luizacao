
module LedMatrixPeripheral(
  input clk,
  input isTarget,
  input [27:0] address,
  input [31:0] data
  // TODO: add led matrix wires
);

always @(negedge clk) begin
  if (isTarget) begin
    // TODO: add led matrix logic
  end
end

endmodule
