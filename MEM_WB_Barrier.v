module MEM_WB_Barrier(
  input clk,
  input [31:0] memMemoryData,
  input [31:0] memExecutionData,
  input memShouldUseMemoryData,
  input memIsRegisterWrite,
  output [31:0] wbMemoryData,
  output [31:0] wbExecutionData,
  output wbShouldUseMemoryData,
  output wbIsRegisterWrite
);
  reg [31:0] regMemoryData;
  reg [31:0] regExecutionData;
  reg regShouldUseMemoryData;
  reg regIsRegisterWrite;

  assign wbMemoryData = regMemoryData;
  assign wbExecutionData = regExecutionData;
  assign wbShouldUseMemoryData = regShouldUseMemoryData;
  assign wbIsRegisterWrite = regIsRegisterWrite;

  always @(posedge clk) begin
    regMemoryData <= memMemoryData;
    regExecutionData <= memExecutionData;
    regShouldUseMemoryData <= memShouldUseMemoryData;
    regIsRegisterWrite <= memIsRegisterWrite;
  end
endmodule
