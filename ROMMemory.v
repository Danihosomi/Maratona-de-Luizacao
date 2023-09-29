module ROMMemory (
  input [31:0] address,
  output reg [31:0] data
);

always @* begin
  case(address[9:2]) 
        0: data = 32'h800004b7;
        1: data = 32'h70000537;
        2: data = 32'h00000093;
        3: data = 32'h00052103;
        4: data = 32'h002080b3;
        5: data = 32'h0014a023;
        6: data = 32'hfe000ae3;
        default: data = 32'h0;
  endcase
end

endmodule
