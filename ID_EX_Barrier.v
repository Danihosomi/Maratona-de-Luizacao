module ID_EX_Barrier(
  input clk,
  input [31:0] idLHSRegisterValue,
  input [31:0] idRHSRegisterValue,
  output [31:0] exLHSRegisterValue,
  output [31:0] exRHSRegisterValue
);

  reg [31:0] regLHSRegisterValue;
  reg [31:0] regRHSRegisterValue;

  assign exLHSRegisterValue = regLHSRegisterValue;
  assign exRHSRegisterValue = regRHSRegisterValue;

  always @(posedge clk) begin
    regLHSRegisterValue <= idLHSRegisterValue;
    regRHSRegisterValue <= idRHSRegisterValue;
  end

endmodule
