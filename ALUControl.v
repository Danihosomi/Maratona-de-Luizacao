module ALUControl (
  input [2:0] ALUOp,
  input [2:0] func3,
  input [6:0] func7,
  output reg [3:0] result
);

always @* begin
  case (ALUOp)
    3'b000: result = 4'b0010;
    3'b001:
      case (func3)
        3'b000: result = 4'b1000; //beq
        3'b001: result = 4'b1001; //bne
        3'b100: result = 4'b1010; //blt
        3'b101: result = 4'b1011; //bge
        3'b110: result = 4'b1100; //bltu
        3'b111: result = 4'b1101; //bgeu
        default: result = 4'b1000;
      endcase
    3'b011: result = 4'b0110;
    3'b010:
      case (func3)
        3'b000: result = (func7[5]) ? 4'b0110 : 4'b0010; //sub or add
        3'b110: result = 4'b0001; //or
        3'b111: result = 4'b0000; //and
        3'b001: result = 4'b0011; //sll
        3'b101: result = 4'b0100; //sr
        3'b100: result = 4'b0101; //xor
        default: result = 4'b0010;
      endcase
    3'b110:
      case (func3)
        3'b000: result = 4'b0010;
        3'b110: result = 4'b0001;
        3'b111: result = 4'b0000;
        default: result = 4'b0010;
      endcase
    default: result = 4'b0010;
  endcase
end

endmodule

// 0000 AND
// 0001 OR
// 0010 ADD
// 0011 SLL
// 0100 SR
// 0101 XOR
// 0110 SUB
