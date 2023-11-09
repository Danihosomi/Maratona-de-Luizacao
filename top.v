module top
(
  input clk,
  input rst,

  // Peripheral
  input button,
  output [5:0] led
  // TODO: add led matrix wires
);
wire [5:0] debug;
wire [7:0] ledMatrixRow;
wire [7:0] ledMatrixColumn;

CPU cpu(
  .clk(slowerClk),
  .rst(~rst),
  .buttonPeripheral(~button),
  .debug(debug),
  .ledMatrixRow(ledMatrixRow),
  .ledMatrixColumn(ledMatrixColumn)
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
