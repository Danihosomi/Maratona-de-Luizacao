module BranchUnit(
  input aluZero,
  input isBranchOperation,
  input [31:0] programCounter,
  input [31:0] immediate,
  output shouldBranch,
  output [31:0] branchTarget
);

assign shouldBranch = aluZero && isBranchOperation;
assign branchTarget = programCounter + immediate;

endmodule