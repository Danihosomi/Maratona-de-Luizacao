module ROMMemory (
  input [31:0] address,
  output reg [31:0] data
);

  always @* begin
    case(address[9:2]) 
        0: data = 32'hfce08793;
        1: data = 32'h00812703;
        2: data = 32'h1f408067;
        3: data = 32'h00e12423;
        4: data = 32'h12a98663;
        5: data = 32'h0a78f537;
        6: data = 32'h09218c6f;
    endcase
  end

endmodule
