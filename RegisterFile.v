module RegisterFile(
  input clk,
  input [4:0] source1RegisterIndex,
  input [4:0] source2RegisterIndex, 
  input [4:0] writeRegisterIndex,
  input [31:0] writeRegisterData,
  input shouldWrite,
  output [31:0] source1RegisterData,
  output [31:0] source2RegisterData
);
  reg [31:0] registers [32];

  assign registers[0] = 0;

  assign source1RegisterData = registers[source1RegisterIndex];
  assign source2RegisterData = registers[source2RegisterIndex];

  // Writing at the rising edge solves the structural hazard of reading and writing at the same clock
  always @(posedge clk) begin
    if (shouldWrite) begin
      registers[writeRegisterIndex] <= writeRegisterData;
    end
  end

endmodule
