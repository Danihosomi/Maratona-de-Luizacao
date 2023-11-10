module ROMMemory (
  input [31:0] address,
  output reg [31:0] data
);

always @* begin
  case(address[9:2]) 
        0: data = 32'h60000137;
        1: data = 32'h00000093;
        2: data = 32'h00112023;
        3: data = 32'h000000b3;
        4: data = 32'h00110113;
        5: data = 32'h00112023;
        6: data = 32'h00018233;
        7: data = 32'h700002b7;
        8: data = 32'h0002a183;
        9: data = 32'hfe418ae3;
        10: data = 32'hfe0188e3;
        11: data = 32'h00108093;
        12: data = 32'h00112023;
        13: data = 32'hfe0002e3;
        default: data = 32'h0;
  endcase
end

endmodule
