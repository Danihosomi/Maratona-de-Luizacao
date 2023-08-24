module ID_EX_Barrier(
  input clk,
  input [31:0] idLHSRegisterValue,
  input [31:0] idRHSRegisterValue,
  input [4:0] idWriteRegisterIndex,
  input idAluOp,
  input idAluSrc,
  input idMemWrite,
  input idMemToReg,
  input idRegWrite,
  output reg [31:0] exLHSRegisterValue,
  output reg [31:0] exRHSRegisterValue,
  output reg [4:0] exWriteRegisterIndex,
  output reg exAluOp,
  output reg exAluSrc,
  output reg exMemWrite,
  output reg exMemToReg,
  output reg exRegWrite
);

  always @(posedge clk) begin
    exLHSRegisterValue <= idLHSRegisterValue;
    exRHSRegisterValue <= idRHSRegisterValue;
    exWriteRegisterIndex <= idWriteRegisterIndex;
    exAluOp <= idAluOp;
    exAluSrc <= idAluSrc;
    exMemWrite <= idMemWrite;
    exMemToReg <= idMemToReg;
    exRegWrite <= idRegWrite;
  end

endmodule
