module BranchUnit(
  input aluZero,
  input isBranchOperation,
  input jump,
  input [31:0] programCounter,
  input [31:0] immediate,
  input [31:0] aluResult,
  output shouldBranch,
  output [31:0] branchTarget
);

assign shouldBranch = (aluZero && isBranchOperation) || jump;
assign branchTarget = jump ? aluResult : programCounter + immediate;

endmodule