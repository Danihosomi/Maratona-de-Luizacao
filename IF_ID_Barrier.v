module IF_ID_Barrier(
  input clk,
  input dontUpdate,
  input [31:0] ifInstruction,
  output reg [31:0] idInstruction
);

always @(posedge clk) begin
  if (dontUpdate == 0) begin
    idInstruction <= ifInstruction;
  end
end

endmodule
