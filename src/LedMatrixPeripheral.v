
module LedMatrixPeripheral(
  input clk,
  input isTarget,
  input [27:0] address,
  input [31:0] data,
  output reg [7:0] ledMatrixRow,
  output reg [7:0] ledMatrixColumn
);

reg [10:0] index;
reg [2:0] test;
reg [7:0] values [0:7];

always @(posedge clk) begin
  ledMatrixRow <= 1 << index[10:8];
  ledMatrixColumn <= ~values[index[10:8]];
  index <= index + 1;
end

always @(negedge clk) begin
  if (isTarget) begin
    test = address[4:2];
    values[address[7:5]][address[4:2]] <= data[0];
  end
end

endmodule
