module EX_MEM_Barrier(
  input clk,
  input [31:0] exAluResult,
  input [31:0] exMemoryWriteData,
  input exMemWrite,
  input exMemToReg,
  input exRegWrite,
  output [31:0] memAluResult,
  output [31:0] memMemoryWriteData,
  output memMemWrite,
  output memMemToReg,
  output memRegWrite
);
  reg [31:0] regAluResult;
  reg [31:0] regMemoryWriteData;
  reg regMemWrite;
  reg regMemToReg;
  reg regRegWrite;

  assign memAluResult = regAluResult;
  assign memMemoryWriteData = regMemoryWriteData;
  assign memMemWrite = regMemWrite;
  assign memMemToReg = regMemToReg;
  assign memRegWrite = regRegWrite;

  always @(posedge clk) begin
    regAluResult <= exAluResult;
    regMemoryWriteData <= exMemoryWriteData;
    regMemWrite <= exMemWrite;
    regMemToReg <= exMemToReg;
    regRegWrite <= exRegWrite;
  end
endmodule
