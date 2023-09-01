module IF_ID_Barrier(
  input clk,
  input dontUpdate,
  input flush,
  input [31:0] ifInstruction,
  input [31:0] ifProgramCounter,
  output reg [31:0] idInstruction,
  output reg [31:0] idProgramCounter
);

always @(posedge clk) begin
  if (flush) begin
    idInstruction <= 0;
    idProgramCounter <= 0;
  end
  if (dontUpdate == 0) begin
    idInstruction <= ifInstruction;
    idProgramCounter <= ifProgramCounter;
  end
end

endmodule
