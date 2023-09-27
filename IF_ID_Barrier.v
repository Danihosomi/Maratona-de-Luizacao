module IF_ID_Barrier(
  input clk,
  input rst,
  input dontUpdate,
  input [31:0] ifInstruction,
  input [31:0] ifProgramCounter,
  output reg [31:0] idInstruction,
  output reg [31:0] idProgramCounter
);
always @(posedge clk) begin
  if (dontUpdate == 0) begin
    idInstruction <= ifInstruction;
    idProgramCounter <= ifProgramCounter;
  end
  else begin
    idInstruction <= idInstruction;
  end

  if (rst) begin
    idInstruction <= 0;
    idProgramCounter <= 0;
  end
end

endmodule
