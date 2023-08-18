module Tester();
  parameter CLK_HALF_PERIOD = 5;
  
  reg clk;
  initial begin
    forever clk = #( CLK_HALF_PERIOD )  ~clk;
  end

  always @(posedge clk) begin
  end
endmodule