module Alu (
  input [5:0] ALUControl, // Change width to 6 bits
  input signed [31:0] operand1,
  input signed [31:0] operand2,
  output reg signed [31:0] resultALU,
  output reg zero
);

`define isNegative(A) A >= 2147483648

always @* begin
  case (ALUControl)
    6'b000010: resultALU = operand1 + operand2;  // 0010: ADD
    6'b000110: resultALU = operand1 - operand2;  // 0110: SUB
    6'b000000: resultALU = operand1 & operand2;  // 0000: AND
    6'b000001: resultALU = operand1 | operand2;  // 0001: OR
    6'b000011: resultALU = operand1 << operand2; // 0011: SLL
    6'b000100: resultALU = operand1 >> operand2; // 0100: SR
    6'b000101: resultALU = operand1 ^ operand2;  // 0101: XOR
    6'b000111: resultALU = operand1 >>> operand2[4:0]; // 0111: SRA

    6'b001000: resultALU = (operand1 == operand2) ? 0 : 1; // 1000: BEQ
    6'b001001: resultALU = (operand1 != operand2) ? 0 : 1; // 1001: BNE

    6'b001010: begin // 1010: BLT
      if (`isNegative(operand1) && !(`isNegative(operand2))) resultALU = 0;
      else if (!(`isNegative(operand1)) && `isNegative(operand2)) resultALU = 1;
      else resultALU = (operand1 < operand2) ? 0 : 1;
    end

    6'b001011: begin // 1011: BGE
      if (`isNegative(operand1) && !(`isNegative(operand2))) resultALU = 1;
      else if (!(`isNegative(operand1)) && `isNegative(operand2)) resultALU = 0;
      else resultALU = (operand1 >= operand2) ? 0 : 1;
    end

    6'b001100: resultALU = (operand1 < operand2) ? 0 : 1;  // 1100: BLTU
    6'b001101: resultALU = (operand1 >= operand2) ? 0 : 1; // 1101: BGEU

    6'b001000: resultALU = operand1 * operand2; //mul
    6'b001001: resultALU = (operand1 * operand2) >> 32; //mulh
    6'b001010: resultALU = (operand1 * operand2) >> 32; //mulhsu
    6'b001011: resultALU = (operand1 * operand2) >> 32; //mulhu
    6'b001100: resultALU = (operand1 / operand2); //div
    6'b001101: resultALU = (operand1 / operand2); //divu
    6'b001110: resultALU = (operand1 % operand2); //rem
    6'b001111: resultALU = (operand1 % operand2); //remu

    6'b100000: begin // min
      if (`isNegative(operand1) && !(`isNegative(operand2))) resultALU = 0;
      else if (!(`isNegative(operand1)) && `isNegative(operand2)) resultALU = 1;
      else resultALU = (operand1 < operand2) ? 0 : 1;
    end 
    6'b100001: begin // max
      if (`isNegative(operand1) && !(`isNegative(operand2))) resultALU = 1;
      else if (!(`isNegative(operand1)) && `isNegative(operand2)) resultALU = 0;
      else resultALU = (operand1 >= operand2) ? 0 : 1;
    end 
    6'b100010: resultALU = (operand1 < operand2) ? operand1 : operand2; // minu
    6'b100011: resultALU = (operand1 < operand2) ? operand2 : operand1; // maxu

    6'b100100: ; // swap 

    default: resultALU = operand1 + operand2;
  endcase

  if (resultALU == 0) begin
    zero = 1;
  end else begin
    zero = 0;
  end
end

endmodule