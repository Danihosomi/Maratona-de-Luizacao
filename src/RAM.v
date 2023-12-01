module RAM(
  input clk,
  input writeEnable,
  input readEnable,
  input [31:0] address,
  input [31:0] dataIn,
  output [31:0] dataOut
);
reg [31:0] memory [255:0];

assign dataOut = readEnable == 1 ? memory[address[9:2]] : 32'b0;

always @(negedge clk) begin
  if (writeEnable == 1) begin
    memory[address[9:2]] <= dataIn;
  end
end
endmodule
