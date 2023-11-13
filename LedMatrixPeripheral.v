
module LedMatrixPeripheral(
  input clk,
  input isTarget,
  input [27:0] address,
  input [31:0] data,
  output reg [7:0] ledMatrixRow,
  output reg [7:0] ledMatrixColumn
);

always @(negedge clk) begin
  if (isTarget && address == 0) begin
      ledMatrixColumn <= data[7:0];
  end

  if (isTarget && address == 1) begin
    ledMatrixRow <= data[7:0];
  end
end

endmodule
