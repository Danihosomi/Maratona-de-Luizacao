module ProgramCounter(
  input clk,
  output reg [31:0]pc
);
  always @(posedge clk) begin
    pc <= pc + 4;
  end 
endmodule
