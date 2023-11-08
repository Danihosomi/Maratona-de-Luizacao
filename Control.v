module Control(
  input [6:0] instruction,
  output branch,
  output memRead,
  output memToReg,
  output reg [2:0] aluOp,
  output memWrite,
  output aluSrc,
  output regWrite
);

wire [6:0] opcode;

assign opcode = instruction[6:0];

assign branch = (opcode == 'b1100011) ? 1 : 0;
assign memRead = (opcode == 'b0000011) ? 1 : 0;
assign memToReg = (opcode == 'b0000011) ? 1 : 0;
assign memWrite = (opcode == 'b0100011) ? 1 : 0;
assign aluSrc = ((opcode == 'b0010011) || (opcode == 'b0000011) || (opcode == 'b0100011) || (opcode == 'b0110111)) ? 1 : 0;
assign regWrite = ((opcode == 'b0000011) || (opcode == 'b0010011) || (opcode == 'b0110011) || (opcode == 'b0110111)) ? 1 : 0;

always @(opcode) begin
  case (opcode)
    'b0000011: aluOp = 'b000;
    'b0100011: aluOp = 'b000;
    'b1100011: aluOp = 'b001;
    'b0010011: aluOp = 'b110;
    'b0110011: aluOp = 'b010;
    default:   aluOp = 'b011;
  endcase
end

endmodule
