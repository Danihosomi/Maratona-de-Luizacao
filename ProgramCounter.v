module ProgramCounter(
  input clk,
  input isStalled,
  output reg [31:0]pc
);
  always @(posedge clk) begin
    if (isStalled == 0) begin
      pc <= pc + 4;
    end
  end 
endmodule
