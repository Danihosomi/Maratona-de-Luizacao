module ProgramCounter(
  input clk,
  input isStalled,
  input shouldGoToTarget,
  input [31:0] jumpTarget,
  output reg [31:0]pc
);
  initial begin
    pc = 0;
  end

  always @(posedge clk) begin
    if (!isStalled) begin
      pc <= (shouldGoToTarget) ? jumpTarget : pc + 4;
    end
    else begin
      pc <= pc;
    end
  end 
endmodule
