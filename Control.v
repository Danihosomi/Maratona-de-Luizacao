module Control(
  input [6:0] instruction,
  input [2:0] func3,
  input [6:0] func7,
  output branch,
  output memRead,
  output memToReg,
  output reg [2:0] aluOp,
  output memWrite,
  output aluSrc,
  output regWrite
);

// load = 0000011
// store = 0100011

reg [6:0] opcode;

assign opcode = instruction[6:0];

assign branch = (opcode == 'b1100011) ? 1 : 0; // branch

assign memRead = ((opcode == 'b0000011) || (func7[6:2]===00010 && opcode==='b0101111)) ? 1 : 0; // load

assign memToReg = ((opcode == 'b0000011) || (func7[6:2]===00010 && opcode==='b0101111)) ? 1 : 0; // load 

assign memWrite = (opcode == 'b0100011) ? 1 : 0; // store

assign aluSrc = ((opcode == 'b0010011) || (opcode == 'b0000011) || (opcode == 'b0100011) || (opcode == 'b1101111) || (opcode == 'b1100111) || (opcode == 'b0110111)  // store and load
      || (opcode == 'b0010111) || (func7[6:2]===00010 && opcode==='b0101111)) ? 1 : 0;

assign regWrite = ((opcode == 'b0010011) || (opcode == 'b0000011) || (opcode == 'b0110011) || (opcode == 'b1101111) || (opcode == 'b1100111) || (opcode == 'b0110111) // store and load
      || (opcode == 'b0010111) || (func7[6:2]===00010 && opcode==='b0101111)) ? 1 : 0;

always @(opcode) begin
  case (opcode)
    'b0000011, // LOAD
    'b0100011: aluOp = 'b000; // STORE
    'b1100011: aluOp = 'b001; // BRANCH
    'b0110011: aluOp = 'b010; // OP
    'b1101111, // JAL
    'b1100111, // JALR
    'b0110111, // LUI
    'b0010111: aluOp = 'b011; // AUIPC
    'b0101111: aluOp = 'b100; // AMO
    'b0010011: aluOp = 'b110; // OP-IMM
    default:   aluOp = 'b111;
  endcase
end

endmodule
