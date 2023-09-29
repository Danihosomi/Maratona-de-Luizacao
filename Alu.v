module Alu (
  input [3:0] ALUControl,
  input [31:0] operand1,
  input [31:0] operand2,
  output reg [31:0] resultALU,
  output reg zero
);

`define isNegative(A) A >= 2147483648

always @(operand1, operand2, ALUControl) begin
  case (ALUControl)
    4'b0010: resultALU = operand1 + operand2;
    4'b0110: resultALU = operand1 - operand2;
    4'b0000: resultALU = operand1 & operand2;
    4'b0001: resultALU = operand1 | operand2;
    // 4'b0011: resultALU = operand1 << operand2[4:0];
    // 4'b0100: resultALU = operand1 >> operand2[4:0];
    4'b0101: resultALU = operand1 ^ operand2;
    4'b1000: resultALU = (operand1 == operand2) ? 0 : 1; //beq
    4'b1001: resultALU = (operand1 != operand2) ? 0 : 1; //bne
    4'b1010: begin                                       //blt
      if(`isNegative(operand1) && !(`isNegative(operand2))) resultALU = 0;
      else if(!(`isNegative(operand1)) && `isNegative(operand2)) resultALU = 1;
      else resultALU = (operand1 < operand2) ? 0 : 1;
    end
    4'b1011: begin                                       //bge
      if(`isNegative(operand1) && !(`isNegative(operand2))) resultALU = 1;
      else if(!(`isNegative(operand1)) && `isNegative(operand2)) resultALU = 0;
      else resultALU = (operand1 >= operand2) ? 0 : 1;
    end
    4'b1100: resultALU = (operand1 < operand2) ? 0 : 1;  //bltu
    4'b1101: resultALU = (operand1 >= operand2) ? 0 : 1; //bgeu
    default: resultALU = operand1 + operand2;
  endcase

  zero <= resultALU == 0;
end

endmodule

// 0000 AND
// 0001 OR
// 0010 ADD
// 0011 SLL
// 0100 SR
// 0110 SUB
