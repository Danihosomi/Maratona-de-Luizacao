module ALUControl (
  input [2:0] ALUOp, // inventado
  input [2:0] func3,
  input [6:0] func7,
  output reg [5:0] result // inventado
);

always @(ALUOp, func3, func7) begin
  result = 6'b000010;
  case (ALUOp)
    3'b000: result = 6'b000010;
    3'b001:
      case (func3)
        3'b000: result = 6'b001000; //beq
        3'b001: result = 6'b001001; //bne
        3'b100: result = 6'b001010; //blt
        3'b101: result = 6'b001011; //bge
        3'b110: result = 6'b001100; //bltu
        3'b111: result = 6'b001101; //bgeu
        default: result = 6'b001000;
      endcase
    3'b011: result = 6'b111111; //lui, auipc
    
    3'b100: // atomic operations
      case (func7[6:2])
        5'b00010: result = 6'b000010; // lr (load reserved)
        5'b00011: result = 6'b000010; // sc (store conditional) (é um add) (preciso revisar com alguem)
        5'b00000: result = 6'b000010; // add
        5'b00100: result = 6'b000101; // xor
        5'b01100: result = 6'b000000; // and
        5'b01000: result = 6'b000001; // or
        5'b10000: result = 6'b100000; // min
        5'b10100: result = 6'b100001; // max
        5'b11000: result = 6'b100010; // minu
        5'b11100: result = 6'b100011; // maxu
        5'b00001: result = 6'b100100; // swap (falta)
        default: result = 6'b000010; // default é a soma
      endcase

    3'b010:
      if (func7[0]) begin
        case(func3)
          3'b000: result = 6'b010000; //mul
          3'b001: result = 6'b010001; //mulh
          3'b010: result = 6'b010010; //mulhsu
          3'b011: result = 6'b010011; //mulhu
          3'b100: result = 6'b010100; //div
          3'b101: result = 6'b010101; //divu
          3'b110: result = 6'b010110; //rem
          3'b111: result = 6'b010111; //remu
          default: result = 6'b011000;
        endcase
      end
      else begin
        case (func3)
          3'b000: result = (func7[5]) ? 6'b000110 : 6'b000010; //sub or add
          3'b110: result = 6'b000001; //or
          3'b111: result = 6'b000000; //and
          3'b001: result = 6'b000011; //sll
          3'b101: result = (func7[5]) ? 6'b000111 : 6'b000100; //sra or srl
          3'b100: result = 6'b000101; //xor
          default: result = 6'b000010;
        endcase
      end
    3'b110:
      case (func3)
        3'b000: result = 6'b000010; //addi
        3'b110: result = 6'b000001; //ori
        3'b111: result = 6'b000000; //andi
        3'b001: result = 6'b000011; //slli
        3'b101: result = (func7[5]) ? 6'b000111 : 6'b000100; //srai or srli
        3'b100: result = 6'b000101; //xori
        default: result = 6'b000010;
      endcase
    default: result = 6'b000010;
  endcase
end

endmodule

// 000000 AND
// 000001 OR
// 000010 ADD
// 000011 SLL
// 000100 SRL
// 000101 XOR
// 000110 SUB
// 000111 SRA