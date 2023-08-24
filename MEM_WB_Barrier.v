module MEM_WB_Barrier(
  input clk,
  input [31:0] memMemoryData,
  input [31:0] memExecutionData,
  input memMemToReg,
  input memRegWrite,
  output [31:0] wbMemoryData,
  output [31:0] wbExecutionData,
  output wbMemToReg,
  output wbRegWrite
);
  reg [31:0] regMemoryData;
  reg [31:0] regExecutionData;
  reg regMemToReg;
  reg regRegWrite;

  assign wbMemoryData = regMemoryData;
  assign wbExecutionData = regExecutionData;
  assign wbMemToReg = regMemToReg;
  assign wbRegWrite = regRegWrite;

  always @(posedge clk) begin
    regMemoryData <= memMemoryData;
    regExecutionData <= memExecutionData;
    regMemToReg <= memMemToReg;
    regRegWrite <= memRegWrite;
  end
endmodule
