module BranchUnit(
  input clk,
  input stall,
  input aluZero,
  input isBranchOperation,
  input [31:0] programCounter,
  input [31:0] immediate,
  output shouldBranch,
  output [31:0] branchTarget
);

reg [31:0] pendingBranch;

wire currentShouldBranch = aluZero && isBranchOperation;
wire [31:0] currentBranchTarget = programCounter + immediate;

assign shouldBranch = currentShouldBranch || (pendingBranch != 0);
assign branchTarget = currentShouldBranch ? currentBranchTarget : pendingBranch;

always @(posedge clk) begin
  pendingBranch <= (currentShouldBranch && stall) ? branchTarget : 0;
end

endmodule