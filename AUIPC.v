module AUIPC(
  input [31:0] imm, 
  input [31:0] programCounter, 
  output [31:0] newProgramCounter
);
  
  // The AUIPC operation: PC_out = PC_in + Imm
  assign pc_out = pc_in + imm;

endmodule
