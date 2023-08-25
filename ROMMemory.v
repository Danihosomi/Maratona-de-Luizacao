module ROMMemory (
  input [31:0] address,
  output reg [31:0] data
);

  always @* begin
    case(address[9:2]) 
        0: data = 32'h00a00093;
    endcase
  end

endmodule
