module Control(
  input [6:0] instruction,
  output branch,
  output memRead,
  output memToReg,
  output reg [1:0] aluOp,
  output memWrite,
  output aluSrc,
  output regWrite,
);

  reg [6:0] opcode;

  assign opcode = instruction[6:0];

  assign branch = (opcode == 'b1100011) ? 1 : 0;
  assign memRead = (opcode == 'b0000011) ? 1 : 0;
  assign memToReg = (opcode == 'b0000011) ? 1 : 0;
  assign memWrite = (opcode == 'b0100011) ? 1 : 0;
  assign aluSrc = (opcode == 'b0010011) ? 1 : 0;
  assign regWrite = ((opcode == 'b0000011) || (opcode == 'b0010011) || (opcode == 'b0110011)) ? 1 : 0;
  assign aluOp = ((opcode == 'b1100011) || (opcode == 'b0010011) || (opcode == 'b0110011) || (opcode == 'b0000011) || (opcode == 'b0100011)) ? 1 : 0;

  always @* begin
    case (opcode)
      'b0000011: aluOp = 'b00;
      'b0100011: aluOp = 'b00;
      'b1100011: aluOp = 'b01;
      'b0010011: aluOp = 'b10;
      'b0110011: aluOp = 'b10;
    endcase
  end

endmodule