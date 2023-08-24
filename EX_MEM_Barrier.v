module EX_MEM_Barrier(
  input clk,
  input [31:0] exAluResult,
  input [31:0] exMemoryWriteData,
  input exIsMemoryWrite,
  input exShouldUseMemoryData,
  input exIsRegisterWrite,
  output [31:0] memAluResult,
  output [31:0] memMemoryWriteData,
  output memIsMemoryWrite,
  output memShouldUseMemoryData,
  output memIsRegisterWrite
);
  reg [31:0] regAluResult;
  reg [31:0] regMemoryWriteData;
  reg regIsMemoryWrite;
  reg regShouldUseMemoryData;
  reg regIsRegisterWrite;

  assign memAluResult = regAluResult;
  assign memMemoryWriteData = regMemoryWriteData;
  assign memIsMemoryWrite = regIsMemoryWrite;
  assign memShouldUseMemoryData = regShouldUseMemoryData;
  assign memIsRegisterWrite = regIsRegisterWrite;

  always @(posedge clk) begin
    regAluResult <= exAluResult;
    regMemoryWriteData <= exMemoryWriteData;
    regIsMemoryWrite <= exIsMemoryWrite;
    regShouldUseMemoryData <= exShouldUseMemoryData;
    regIsRegisterWrite <= exIsRegisterWrite;
  end
endmodule
