module ID_EX_Barrier(
  input clk,
  input [31:0] idLHSRegisterValue,
  input [31:0] idRHSRegisterValue,
  input idMemWrite,
  input idMemToReg,
  input idRegWrite,
  output [31:0] exLHSRegisterValue,
  output [31:0] exRHSRegisterValue,
  output exMemWrite,
  output exMemToReg,
  output exRegWrite
);

  reg [31:0] regLHSRegisterValue;
  reg [31:0] regRHSRegisterValue;
  reg regMemWrite;
  reg regMemToReg;
  reg regRegWrite;

  assign exLHSRegisterValue = regLHSRegisterValue;
  assign exRHSRegisterValue = regRHSRegisterValue;
  assign exMemWrite = regMemWrite;
  assign exMemToReg = regMemToReg;
  assign exRegWrite = regRegWrite;

  always @(posedge clk) begin
    regLHSRegisterValue <= idLHSRegisterValue;
    regRHSRegisterValue <= idRHSRegisterValue;
    regMemWrite <= idMemWrite;
    regMemToReg <= idMemToReg;
    regRegWrite <= idRegWrite;
  end

endmodule
