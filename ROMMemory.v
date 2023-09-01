module ROMMemory (
  input [31:0] address,
  output reg [31:0] data
);

  always @* begin
    case(address[9:2]) 
        0: data = 32'h03300093;
        1: data = 32'h03200113;
        2: data = 32'h00209063;
        3: data = 32'h00112023;
        4: data = 32'h001120a3;
        5: data = 32'h00112123;
        6: data = 32'h001121a3;
        7: data = 32'h00112223;
    endcase
  end

endmodule
