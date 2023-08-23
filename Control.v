module Control(
  input [31:0] instruction,
  output branch,
  output memRead,
  output memtoReg,
  output aluOp,
  output memWrite,
  output aluSrc,
  output regWrite
);

  reg [6:0] opcode;

  assign opcode = instruction[6:0];

  assign branch = (opcode == 'b1100011) ? 1 : 0;
  assign memRead = (opcode == 'b0000011) ? 1 : 0;
  assign memtoReg = (opcode == 'b0000011) ? 1 : 0;
  assign aluOp = ((opcode == 'b1100011) || (opcode == 'b0010011) || (opcode == 'b0110011) || (opcode == 'b0000011) || (opcode == 'b0100011)) ? 1 : 0;
  assign memWrite = (opcode == 'b0100011) ? 1 : 0;
  assign aluSrc = (opcode == 'b0010011) ? 1 : 0;
  assign regWrite = ((opcode == 'b0000011) || (opcode == 'b0010011) || (opcode == 'b0110011)) ? 1 : 0;

endmodule