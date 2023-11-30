module BranchUnit(
  input aluZero,
  input isBranchOperation,
  input jump,
  input [31:0] baseValue,
  input [31:0] immediate,
  output shouldBranch,
  output [31:0] branchTarget
);

assign shouldBranch = (aluZero && isBranchOperation) || jump;
assign branchTarget = baseValue + immediate;

endmodule