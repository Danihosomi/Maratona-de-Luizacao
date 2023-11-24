module LedPeripheral(
  input clk,
  input isTarget,
  input [27:0] address,
  input [31:0] data,
  output reg [5:0] led
);

initial begin
  led = 0;
end

// always @(isTarget, address, data) begin
always @(negedge clk) begin
  if (isTarget/* && address == 0*/) begin
    led <= data[5:0];
  end
  else begin
    led <= led;
  end
end

endmodule
