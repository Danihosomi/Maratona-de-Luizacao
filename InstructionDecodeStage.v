module InstructionDecodeStage(
  input clk,
  input [31:0] instruction,
  input [31:0] writebackData,
  output [31:0] decodedLHSRegisterValue,
  output [31:0] decodedRHSRegisterValue
);
  wire [31:0] currentDecodedLHSRegisterValue;
  wire [31:0] currentDecodedRHSRegisterValue;
  
  // Pipeline registers
  reg [31:0] pipelinedDecodedLHSRegisterValue;
  reg [31:0] pipelinedDecodedRHSRegisterValue;

  RegisterFile registerFile(
    .clk(clk),
    .source1RegisterIndex(instruction[19:15]),
    .source2RegisterIndex(instruction[24:20]),
    .writeRegisterIndex(instruction[11:7]), // This should come from the WB pipeline stage instead
    .writeRegisterData(writebackData),
    .shouldWrite(0), // This should come from the WB pipeline stage instead
    .source1RegisterData(currentDecodedLHSRegisterValue),
    .source2RegisterData(currentDecodedRHSRegisterValue)
  );

  // Pipeline wiring
  assign decodedLHSRegisterValue = pipelinedDecodedLHSRegisterValue;
  assign decodedRHSRegisterValue = pipelinedDecodedRHSRegisterValue;

  always @(posedge clk) begin
    pipelinedDecodedLHSRegisterValue <= currentDecodedLHSRegisterValue;
    pipelinedDecodedRHSRegisterValue <= currentDecodedRHSRegisterValue;
  end
endmodule
