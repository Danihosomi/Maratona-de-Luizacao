module ID_EX_Barrier(
  input clk,
  input [31:0] idLHSRegisterValue,
  input [31:0] idRHSRegisterValue,
  input [4:0] idLHSRegisterIndex,
  input [4:0] idRHSRegisterIndex,
  input [4:0] idWriteRegisterIndex,
  input [31:0] idImmediateValue,
  input [2:0] idFunct3,
  input [6:0] idFunct7,
  input [1:0] idAluOp,
  input idAluSrc,
  input idMemWrite,
  input idMemRead,
  input idMemToReg,
  input idRegWrite,
  output reg [31:0] exLHSRegisterValue,
  output reg [31:0] exRHSRegisterValue,
  output reg [4:0] exLHSRegisterIndex,
  output reg [4:0] exRHSRegisterIndex,
  output reg [4:0] exWriteRegisterIndex,
  output reg [31:0] exImmediateValue,
  output reg [2:0] exFunct3,
  output reg [6:0] exFunct7,
  output reg [1:0] exAluOp,
  output reg exAluSrc,
  output reg exMemWrite,
  output reg exMemRead,
  output reg exMemToReg,
  output reg exRegWrite
);

always @(posedge clk) begin
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
end

endmodule
