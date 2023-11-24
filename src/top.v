module top
(
  input clk,
  input rst,

  // Peripheral
  input button,
  output [5:0] led,
  output [7:0] matrixRow,
  output [7:0] matrixCol
);
wire [5:0] debug;

CPU cpu(
  .clk(slowerClk),
  .rst(~rst),
  .buttonPeripheral(~button),
  .debug(debug),
  .ledMatrixRow(matrixRow),
  .ledMatrixColumn(matrixCol)
);

localparam WAIT_TIME = 1350000;
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
