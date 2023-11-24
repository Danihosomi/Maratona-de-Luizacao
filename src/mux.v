module MUX(
  input dataSelector,
  input [31:0] firstData,
  input [31:0] secondData,
  output reg [31:0] outputData
);

always @(*) begin
  case (dataSelector)
    0: outputData = firstData;
    1: outputData = secondData;
  endcase
end

endmodule
