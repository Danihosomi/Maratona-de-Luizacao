module ROMMemory (
  input [31:0] address,
  output reg [31:0] data
);

always @* begin
  case(address[9:1]) 
        0: data = 32'ha0000137;
        1: data = 32'h0093a000;
        2: data = 32'h00000093;
        3: data = 32'h20230000;
        4: data = 32'h00112023;
        5: data = 32'h00b30011;
        6: data = 32'h000000b3;
        7: data = 32'h01130000;
        8: data = 32'h00410113;
        9: data = 32'h20230041;
        10: data = 32'h00112023;
        11: data = 32'h82330011;
        12: data = 32'h00018233;
        13: data = 32'h02b70001;
        14: data = 32'h900002b7;
        15: data = 32'ha1839000;
        16: data = 32'h0002a183;
        17: data = 32'h8ae30002;
        18: data = 32'hfe418ae3;
        19: data = 32'h88e3fe41;
        20: data = 32'hfe0188e3;
        21: data = 32'h8093fe01;
        22: data = 32'h00108093;
        23: data = 32'h20230010;
        24: data = 32'h00112023;
        25: data = 32'h02e30011;
        26: data = 32'hfe0002e3;
        27: data = 32'hfe00;
        default: data = 32'h0;
  endcase
end

endmodule
