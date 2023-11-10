module RegisterFile(
  input clk,
  input rst,
  input [4:0] source1RegisterIndex,
  input [4:0] source2RegisterIndex, 
  input [4:0] writeRegisterIndex,
  input [31:0] writeRegisterData,
  input shouldWrite,
  output [31:0] source1RegisterData,
  output [31:0] source2RegisterData
);
reg [31:0] registers [0:31] /* synthesis syn_ramstyle ="block_ram" */;

assign source1RegisterData = (source1RegisterIndex == 0) ? 0 : registers[source1RegisterIndex];
assign source2RegisterData = (source2RegisterIndex == 0) ? 0 : registers[source2RegisterIndex];

integer i;
// Writing at the falling edge solves the structural hazard of reading and writing at the same clock
always @(negedge clk) begin
  // This forces the synthetizer to not use ram cells, which break the timing for some reason???
//  if (rst == 1) begin
//    for (i = 1; i < 32; i = i + 1) begin
//      registers[i] <= 0;
//    end
//  end

  if (shouldWrite == 1 && (writeRegisterIndex != 0)) begin
    registers[writeRegisterIndex] <= writeRegisterData;
  end
end

endmodule
