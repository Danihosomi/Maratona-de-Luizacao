module top
(
  input clk,
  input rst,
  output [5:0] led
);
wire [5:0] debug; // TODO: hook this into the led

CPU cpu(
  .clk(slowerClk),
  .rst(~rst),
  .debug(debug)
);

localparam WAIT_TIME = 13500000;
reg slowerClk = 0;
reg [25:0] clockCounter = 0;

assign led = ~debug[5:0];

always @(posedge clk) begin
  clockCounter <= clockCounter + 1;
  if (clockCounter == WAIT_TIME) begin
    clockCounter <= 0;
    slowerClk <= ~slowerClk;   
  end
end

endmodule
