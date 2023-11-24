module EX_MEM_Barrier(
  input clk,
  input rst,
  input dontUpdate,
  input [31:0] exAluResult,
  input [31:0] exMemoryWriteData,
  input [4:0] exWriteRegisterIndex,
  input exMemWrite,
  input exMemRead,
  input exMemToReg,
  input exRegWrite,
  output reg [31:0] memAluResult,
  output reg [31:0] memMemoryWriteData,
  output reg [4:0] memWriteRegisterIndex,
  output reg memMemWrite,
  output reg memMemRead,
  output reg memMemToReg,
  output reg memRegWrite
);

always @(posedge clk) begin
  if (dontUpdate == 0) begin
    memAluResult <= exAluResult;
    memMemoryWriteData <= exMemoryWriteData;
    memWriteRegisterIndex <= exWriteRegisterIndex;
    memMemWrite <= exMemWrite;
    memMemRead <= exMemRead;
    memMemToReg <= exMemToReg;
    memRegWrite <= exRegWrite;
  end

  if (rst) begin
    memMemWrite <= 0;
    memMemRead <= 0;
    memMemToReg <= 0;
    memRegWrite <= 0;
  end
end
endmodule
