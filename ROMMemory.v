module ROMMemory (
  input [31:0] address,
  output reg [31:0] data
);

always @* begin
  case(address[9:2]) 
        0: data = 32'h00a00093;
        1: data = 32'h40000113;
        2: data = 32'h00300193;
        3: data = 32'h00112023;
        4: data = 32'h00012203;
        5: data = 32'hfff18193;
        6: data = 32'h00a08093;
        7: data = 32'hfe3018e3;
        default: data = 32'h0;
  endcase
end

endmodule
