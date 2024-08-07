module ProgramCounter(
  input clk,
  input rst,
  input isStalled,
  input isCompactInstruction,
  input shouldGoToTarget,
  input [31:0] jumpTarget,
  output reg [31:0] pc
);
initial begin
  pc = 0;
end

always @(posedge clk) begin
  if (!isStalled) begin
    if (isCompactInstruction) begin
      pc <= (shouldGoToTarget) ? jumpTarget : pc + 2;
    end
    else begin
      pc <= (shouldGoToTarget) ? jumpTarget : pc + 4;
    end
  end
  else begin
    pc <= (shouldGoToTarget) ? jumpTarget : pc;
  end

  if (rst) begin
    pc <= 0;
  end
end 
endmodule
