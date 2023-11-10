module ROMMemory (
  input [31:0] address,
  output reg [31:0] data
);

always @* begin
  case(address[9:1]) 
        0: data = 32'h00000013;
        1: data = 32'h908a0000;
        2: data = 32'h0013908a;
        3: data = 32'h00000013;
        4: data = 32'h00130000;
        5: data = 32'h00000013;
        6: data = 32'h80b30000;
        7: data = 32'h002080b3;
        8: data = 32'h0020;
        default: data = 32'h0;
  endcase
end

endmodule
