module ID_EX_Barrier(
  input clk,
  input rst,
  input dontUpdate,
  input [31:0] idProgramCounter,
  input [31:0] idLHSRegisterValue,
  input [31:0] idRHSRegisterValue,
  input [4:0] idLHSRegisterIndex,
  input [4:0] idRHSRegisterIndex,
  input [4:0] idWriteRegisterIndex,
  input [31:0] idImmediateValue,
  input [2:0] idFunct3,
  input [6:0] idFunct7,
  input [2:0] idAluOp,
  input idAluSrc,
  input idMemWrite,
  input idMemRead,
  input idMemToReg,
  input idRegWrite,
  input idPcToAlu,
  input idJump,
  input idJumpRegister,
  input idBranch,
  input idByteLoad,
  input idHalfLoad,
  input idUnsignedLoad,
  input [31:0] idJumpReturnOffset,
  output reg [31:0] exProgramCounter,
  output reg [31:0] exLHSRegisterValue,
  output reg [31:0] exRHSRegisterValue,
  output reg [4:0] exLHSRegisterIndex,
  output reg [4:0] exRHSRegisterIndex,
  output reg [4:0] exWriteRegisterIndex,
  output reg [31:0] exImmediateValue,
  output reg [2:0] exFunct3,
  output reg [6:0] exFunct7,
  output reg [2:0] exAluOp,
  output reg exAluSrc,
  output reg exMemWrite,
  output reg exMemRead,
  output reg exMemToReg,
  output reg exRegWrite,
  output reg exPcToAlu,
  output reg exJump,
  output reg exJumpRegister,
  output reg exBranch,
  output reg exByteLoad,
  output reg exHalfLoad,
  output reg exUnsignedLoad,
  output reg [31:0] exJumpReturnOffset
);

always @(posedge clk) begin
  if (dontUpdate == 0) begin
    exProgramCounter <= idProgramCounter;
    exLHSRegisterValue <= idLHSRegisterValue;
    exRHSRegisterValue <= idRHSRegisterValue;
    exLHSRegisterIndex <= idLHSRegisterIndex;
    exRHSRegisterIndex <= idRHSRegisterIndex;
    exWriteRegisterIndex <= idWriteRegisterIndex;
    exImmediateValue <= idImmediateValue;
    exFunct3 <= idFunct3;
    exFunct7 <= idFunct7;
    exAluOp <= idAluOp;
    exAluSrc <= idAluSrc;
    exMemWrite <= idMemWrite;
    exMemRead <= idMemRead;
    exMemToReg <= idMemToReg;
    exRegWrite <= idRegWrite;
    exPcToAlu <= idPcToAlu;
    exJump <= idJump;
    exJumpRegister <= idJumpRegister;
    exBranch <= idBranch;
    exByteLoad <= idByteLoad;
    exHalfLoad <= idHalfLoad;
    exUnsignedLoad <= idUnsignedLoad;
    exJumpReturnOffset <= idJumpReturnOffset;
  end

  if (rst) begin
    exAluOp <= 0;
    exAluSrc <= 0;
    exMemWrite <= 0;
    exMemRead <= 0;
    exMemToReg <= 0;
    exRegWrite <= 0;
    exJump <= 0;
    exJumpRegister <= 0;
    exBranch <= 0;
    exByteLoad <= 0;
    exHalfLoad <= 0;
    exUnsignedLoad <= 0;
    exJumpReturnOffset <= 0;
  end
end

endmodule
