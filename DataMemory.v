module DataMemory (
  input clk,
  input memWrite,
  input memRead,
  input [31:0] address,
  input [31:0] writeData,
  output [31:0] readData
);

  reg [31:0] ram [255:0];

  // Change on clock to avoid reading and writing at same time
  always @(posedge clk) begin
    if(memWrite == 1) begin
      ram[address[9:2]] <= writeData;
    end
    if (memRead == 1) begin
      readData <= ram[address[9:2]];
    end
  end

endmodule
