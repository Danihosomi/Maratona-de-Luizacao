module ROMMemory (
  input [31:0] address,
  output reg [31:0] data
);

// 1 KB. If this is changed, please update the makefile -Tdata
reg [31:0] rom [0:255];

initial begin
  $readmemh("rom.hex", rom);
end

always @* begin
  if (address == 0 ) begin
    data = 32'h7fc00113; // Initializing the stack pointer
  end
  else begin
    data = rom[address[9:2]];
  end
end

endmodule
