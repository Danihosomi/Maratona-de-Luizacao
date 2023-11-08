module ROMMemory (
  input [31:0] address,
  output reg [31:0] data
);

always @* begin
  case(address[9:2]) 
        0: data = 32'h00a00093;
        1: data = 32'h00f00113;
        2: data = 32'h01400193;
        3: data = 32'h01900213;
        4: data = 32'h800004b7;
        5: data = 32'h0030e093;
        6: data = 32'h00317113;
        7: data = 32'h40118233;
        8: data = 32'h003201b3;
        9: data = 32'h0014a023;
        10: data = 32'h0024a023;
        11: data = 32'h0034a023;
        12: data = 32'h0044a023;
        13: data = 32'h40002283;
        14: data = 32'h40402303;
        15: data = 32'h40802383;
        16: data = 32'h40c02403;
        17: data = 32'h00000013;
        default: data = 32'h0;
  endcase
end

endmodule
