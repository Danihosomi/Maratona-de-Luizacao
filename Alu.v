module Alu (
  input [5:0] ALUControl, // Change width to 6 bits
  input signed [31:0] operand1,
  input signed [31:0] operand2,
  output reg signed [31:0] resultALU,
  output reg zero
);

wire [63:0] mult;
wire [63:0] mulhsu;
wire [63:0] mulhu;

assign mult = operand1 * operand2;
assign mulhsu = {{32'b0, operand1} * {32'b0, operand2}};
assign mulhu = {{32'b0, operand1} * {32'b0, operand2}};


`define isNegative(A) A[31] == 1


always @(operand1, operand2, ALUControl) begin
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

    6'b010000: resultALU = mult[31:0]; //mul
    6'b010001: resultALU = mult[63:32]; //mulh
    6'b010010: resultALU = mulhsu[63:32]; //mulhsu
    6'b010011: resultALU = mulhu[63:32]; //mulhu
    //6'b010100: resultALU = (operand1 / operand2); //div
    //6'b010101: resultALU = {{1'b0, operand1} / {1'b0, operand2}}; //divu
    //6'b010110: resultALU = (operand1 % operand2); //rem
    //6'b010111: resultALU = {{1'b0, operand1} % {1'b0, operand2}}; //remu

    6'b100000: begin // min
      if (`isNegative(operand1) && !(`isNegative(operand2))) resultALU = operand1;
      else if (!(`isNegative(operand1)) && `isNegative(operand2)) resultALU = operand2;
      else resultALU = (operand1 < operand2) ? operand1 : operand2;
    end 
    6'b100001: begin // max
      if (`isNegative(operand1) && !(`isNegative(operand2))) resultALU = operand2;
      else if (!(`isNegative(operand1)) && `isNegative(operand2)) resultALU = operand1;
      else resultALU = (operand1 >= operand2) ? operand1 : operand2;
    end 
    6'b100010: resultALU = (operand1 < operand2) ? operand1 : operand2; // minu
    6'b100011: resultALU = (operand1 < operand2) ? operand2 : operand1; // maxu

    //6'b100100: ; // swap 

    default: resultALU = operand2;
  endcase

  zero <= resultALU == 0;
end

endmodule
