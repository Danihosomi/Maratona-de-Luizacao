module DataMemory (
  input clk,
  input memWrite,
  input memRead,
  input [31:0] address,
  input [31:0] writeData,
  output [31:0] readData
);

  reg [31:0] ramData;
  RAM DataMemoryRAM(
    .clk(clk),
    .writeEnable(memWrite),
    .address(address),
    .data_in(writeData),
    .data_out(ramData)
  );

  // Change on clock to avoid reading and writing at same time
  always @(posedge clk) begin
    if (memRead == 1) begin
      readData <= ramData;
    end
  end

endmodule
