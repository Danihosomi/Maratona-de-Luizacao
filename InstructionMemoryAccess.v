module InstructionMemoryAccess(
  input [31:0] MemoryAddress,
  output [31:0] Instruction32b
);
  reg [31:0] mem [1023:0];

  initial begin
    $readmemh("input.hex", mem); // TODO: Perguntar pro Rodolfo sobre inicialização da mémoria na FPGA
  end

  assign Instruction32b = mem[MemoryAddress[31:0]];

endmodule