module ID_EX_Barrier(
  input clk,
  input [31:0] idLHSRegisterValue,
  input [31:0] idRHSRegisterValue,
  input idIsMemoryWrite,
  input idShouldUseMemoryData,
  input idIsRegisterWrite,
  output [31:0] exLHSRegisterValue,
  output [31:0] exRHSRegisterValue,
  output exIsMemoryWrite,
  output exShouldUseMemoryData,
  output exIsRegisterWrite
);

  reg [31:0] regLHSRegisterValue;
  reg [31:0] regRHSRegisterValue;
  reg regIsMemoryWrite;
  reg regShouldUseMemoryData;
  reg regIsRegisterWrite;

  assign exLHSRegisterValue = regLHSRegisterValue;
  assign exRHSRegisterValue = regRHSRegisterValue;
  assign exIsMemoryWrite = regIsMemoryWrite;
  assign exShouldUseMemoryData = regShouldUseMemoryData;
  assign exIsRegisterWrite = regIsRegisterWrite;

  always @(posedge clk) begin
    regLHSRegisterValue <= idLHSRegisterValue;
    regRHSRegisterValue <= idRHSRegisterValue;
    regIsMemoryWrite <= idIsMemoryWrite;
    regShouldUseMemoryData <= idShouldUseMemoryData;
    regIsRegisterWrite <= idIsRegisterWrite;
  end

endmodule
