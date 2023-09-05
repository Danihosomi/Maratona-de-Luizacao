module ProgramCounter(
  input clk,
  input isStalled,
  input shouldGoToTarget,
  input [31:0] jumpTarget,
  output reg [31:0]pc
);
always @(posedge clk) begin
  if (isStalled == 0) begin
    pc <= (shouldGoToTarget) ? jumpTarget : pc + 4;
  end
end 
endmodule
