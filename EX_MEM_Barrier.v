module EX_MEM_Barrier(
  input clk,
  input [31:0] exAluResult,
  input [31:0] exMemoryWriteData,
  input [4:0] exWriteRegisterIndex,
  input exMemWrite,
  input exMemToReg,
  input exRegWrite,
  output reg [31:0] memAluResult,
  output reg [31:0] memMemoryWriteData,
  output reg [4:0] memWriteRegisterIndex,
  output reg memMemWrite,
  output reg memMemToReg,
  output reg memRegWrite
);

  always @(posedge clk) begin
    memAluResult <= exAluResult;
    memMemoryWriteData <= exMemoryWriteData;
    memWriteRegisterIndex <= exWriteRegisterIndex;
    memMemWrite <= exMemWrite;
    memMemToReg <= exMemToReg;
    memRegWrite <= exRegWrite;
  end
endmodule
