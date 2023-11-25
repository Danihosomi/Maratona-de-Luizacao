module Control(
  input [6:0] instruction,
  input [2:0] func3,
  input [6:0] func7,
  output branch,
  output jump,
  output reg [2:0] aluOp,
  output memWrite,
  output aluSrc,
  output pcToAlu,
  output regWrite,

  // Load wires
  output memRead,
  output memToReg,
  output byteLoad,
  output halfLoad,
  output unsignedLoad
);

// load = 0000011
// store = 0100011

wire [6:0] opcode;

assign opcode = instruction[6:0];

assign branch = ((opcode == 'b1100011)) ? 1 : 0; // branch

assign jump = ((opcode == 'b1101111) || (opcode == 'b1100111)) ? 1 : 0; // jal && jalr

assign memRead = ((opcode == 'b0000011) || (func7[6:2]==00010 && opcode=='b0101111)) ? 1 : 0; // load && lr.w

assign memToReg = ((opcode == 'b0000011) || (func7[6:2]==00010 && opcode=='b0101111)) ? 1 : 0; // load && lr.w

assign memWrite = ((opcode == 'b0100011) || (func7[6:2]==00011 && opcode=='b0101111)) ? 1 : 0; // store && sc.w

assign aluSrc = ((opcode == 'b0010011) || (opcode == 'b0000011) || (opcode == 'b0100011) || (opcode == 'b1101111) || (opcode == 'b1100111) || (opcode == 'b0110111)  // store and load
      || (opcode == 'b0010111)) ? 1 : 0;

assign regWrite = ((opcode == 'b0010011) || (opcode == 'b0000011) || (opcode == 'b0110011) || (opcode == 'b1101111) || (opcode == 'b1100111) || (opcode == 'b0110111) 
      || (opcode == 'b0010111) || (func7[6:2]==00010 && opcode=='b0101111) || (func7[6:2]==00011 && opcode=='b0101111)) ? 1 : 0; // store && load && lr.w && sc.w

assign pcToAlu = ((opcode == 'b0010111) || (opcode == 'b1101111)) ? 1 : 0; // auipc && jal

// Load wires
parameter LOAD_BYTE_FUNC3 = 'b000;
parameter LOAD_HALF_FUNC3 = 'b001;
parameter LOAD_BYTE_UNSIGNED_FUNC3 = 'b100;
parameter LOAD_HALF_UNSIGNED_FUNC3 = 'b101;

assign byteLoad = (func3 == LOAD_BYTE_FUNC3 || func3 == LOAD_BYTE_UNSIGNED_FUNC3) ? 1 : 0;
assign halfLoad = (func3 == LOAD_HALF_FUNC3 || func3 == LOAD_HALF_UNSIGNED_FUNC3) ? 1 : 0;
assign unsignedLoad = (func3 == LOAD_BYTE_UNSIGNED_FUNC3 || func3 == LOAD_HALF_UNSIGNED_FUNC3) ? 1 : 0;


always @(opcode) begin
  case (opcode)
    'b0000011, // LOAD
    'b0100011: aluOp = 'b000; // STORE
    'b1100011: aluOp = 'b001; // BRANCH
    'b0110011: aluOp = 'b010; // OP
    'b1101111: aluOp = 'b011; // JAL
    'b1100111: aluOp = 'b011; // JALR
    'b0110111, // LUI
    'b0010111: aluOp = 'b011; // AUIPC
    'b0101111: aluOp = 'b100; // AMO
    'b0010011: aluOp = 'b110; // OP-IMM
    default:   aluOp = 'b111;
  endcase
end

endmodule
