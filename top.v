module top
(
  input clk,
  output [5:0] led
);

CPU cpu(
  .clk(slowerClk)
);

localparam WAIT_TIME = 13500000;
reg slowerClk = 0;
reg [23:0] clockCounter = 0;

always @(posedge clk) begin
  clockCounter <= clockCounter + 1;
  if (clockCounter == WAIT_TIME) begin
    clockCounter <= 0;
    slowerClk <= ~slowerClk;
  end
end

endmodule
