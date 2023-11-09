module ROMMemory (
  input [31:0] address,
  output reg [31:0] data
);

always @* begin
  case(address[9:2]) 
        0: data = 32'h0af00093;
        1: data = 32'h60000137;
        2: data = 32'h00112023;
        3: data = 32'h00110113;
        4: data = 32'h00112023;
        default: data = 32'h0;
  endcase
end

endmodule
