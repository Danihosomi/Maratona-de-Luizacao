module BranchTargetCalculator(
  input [31:0] programCounter,
  input [31:0] immediate,
  output reg [31:0] branchTarget
);

  assign branchTarget = programCounter + immediate;

endmodule
