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
  input exByteLoad,
  input exHalfLoad,
  input exUnsignedLoad,
  output reg [31:0] memAluResult,
  output reg [31:0] memMemoryWriteData,
  output reg [4:0] memWriteRegisterIndex,
  output reg memMemWrite,
  output reg memMemRead,
  output reg memMemToReg,
  output reg memRegWrite,
  output reg memByteLoad,
  output reg memHalfLoad,
  output reg memUnsignedLoad
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
    memByteLoad <= exByteLoad;
    memHalfLoad <= exHalfLoad;
    memUnsignedLoad <= exUnsignedLoad;
  end

  if (rst) begin
    memMemWrite <= 0;
    memMemRead <= 0;
    memMemToReg <= 0;
    memRegWrite <= 0;
    memByteLoad <= 0;
    memHalfLoad <= 0;
    memUnsignedLoad <= 0;
  end
end
endmodule
