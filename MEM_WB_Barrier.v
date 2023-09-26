module MEM_WB_Barrier(
  input clk,
  input rst,
  input [31:0] memMemoryData,
  input [31:0] memExecutionData,
  input [4:0] memWriteRegisterIndex,  
  input memMemToReg,
  input memRegWrite,
  output reg [31:0] wbMemoryData,
  output reg [31:0] wbExecutionData,
  output reg [4:0] wbWriteRegisterIndex,
  output reg wbMemToReg,
  output reg wbRegWrite
);

always @(posedge clk) begin
  wbMemoryData <= memMemoryData;
  wbExecutionData <= memExecutionData;
  wbWriteRegisterIndex <= memWriteRegisterIndex;
  wbMemToReg <= memMemToReg;
  wbRegWrite <= memRegWrite;

  if (rst) begin
    wbMemoryData <= 0;
    wbExecutionData <= 0;
    wbWriteRegisterIndex <= 0;
    wbMemToReg <= 0;
    wbRegWrite <= 0;
  end
end
endmodule
