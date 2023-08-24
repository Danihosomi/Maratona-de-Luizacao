module MEM_WB_Barrier(
  input clk,
  input [31:0] memMemoryData,
  input [31:0] memExecutionData,
  input [4:0] memWriteRegisterIndex,  
  input memMemToReg,
  input memRegWrite,
  output [31:0] wbMemoryData,
  output [31:0] wbExecutionData,
  output [4:0] wbWriteRegisterIndex,
  output wbMemToReg,
  output wbRegWrite
);
  reg [31:0] regMemoryData;
  reg [31:0] regExecutionData;
  reg [4:0] regWriteRegisterIndex;
  reg regMemToReg;
  reg regRegWrite;

  assign wbMemoryData = regMemoryData;
  assign wbExecutionData = regExecutionData;
  assign wbWriteRegisterIndex = regWriteRegisterIndex;
  assign wbMemToReg = regMemToReg;
  assign wbRegWrite = regRegWrite;

  always @(posedge clk) begin
    regMemoryData <= memMemoryData;
    regExecutionData <= memExecutionData;
    regWriteRegisterIndex <= memWriteRegisterIndex;
    regMemToReg <= memMemToReg;
    regRegWrite <= memRegWrite;
  end
endmodule
