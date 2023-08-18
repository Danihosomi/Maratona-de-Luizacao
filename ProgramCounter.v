module ProgramCounter(
    input clk,
    input [31:0]nextAddress,
    output [31:0]currentAddress
);
  reg [31:0] tempAddress;
  
  assign currentAddress = tempAddress;

  always @(posedge clk) begin
    tempAddress <= nextAddress;
  end 
endmodule