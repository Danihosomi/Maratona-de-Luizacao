module ROMMemory (
  input [31:0] address,
  output reg [31:0] data
);

// 4 KB. If this is changed, please update the makefile -Tdata
reg [31:0] rom [0:1023];

initial begin
  $readmemh("rom.hex", rom);
end

always @* begin
  if (address == 0) begin
    data = 32'h00001137;
  end
  else if (address == 4) begin
    // Change the stack pointer to the top of the memory
    // if memory is changed, please update it
    data = 32'h3fc10113; // Initializing the stack pointer
  end
  else begin
    data = rom[address[11:2]];
  end
end

endmodule
