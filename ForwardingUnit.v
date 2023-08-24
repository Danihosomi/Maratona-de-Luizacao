module ForwardingUnit(
  input [4:0] executeStageReadRegisterIndex,
  input [4:0] memoryStageWriteRegisterIndex,
  input [4:0] writebackStageWriteRegisterIndex,
  input isMemoryStageWrite,
  input isWritebackStageWrite,
  output [1:0] forwardSelect
);
  wire isMemHazard;
  wire isWbHazard;

  assign isMemHazard = isMemoryStageWrite && memoryStageWriteRegisterIndex != 0 
                       && executeStageReadRegisterIndex == memoryStageWriteRegisterIndex;
  assign isWbHazard = isWritebackStageWrite && writebackStageWriteRegisterIndex != 0 
                      && executeStageReadRegisterIndex == writebackStageWriteRegisterIndex;

  assign forwardSelect = (isMemHazard) ? 2'b10 :
                         (isWbHazard) ? 2'b01 : 
                         2'b00;
endmodule
