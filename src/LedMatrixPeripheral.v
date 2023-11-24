
module LedMatrixPeripheral(
  input clk,
  input isTarget,
  input [31:0] data,
  output reg [7:0] ledMatrixRow,
  output reg [7:0] ledMatrixColumn
);

always @(negedge clk) begin
  if (isTarget) begin
    ledMatrixRow <= data[7:0];
    ledMatrixColumn <= data[15:8];
  end
end

endmodule
