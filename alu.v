module Alu (
    input [3:0] ALUControl,
    input [31:0] operand1,
    input [31:0] operand2,
    output reg [31:0] resultALU,
    output reg zero
);

    always @* begin
        case (ALUControl)
            4'b0010: resultALU = operand1 + operand2; 
            4'b0110: resultALU = operand1 - operand2; 
            4'b0000: resultALU = operand1 & operand2; 
            4'b0001: resultALU = operand1 ^ operand2; 
            default: resultALU = operand1 + operand2;
        endcase
        
        if (resultALU == 0) begin
            zero = 1;
        end else begin
            zero = 0;
        end
    end

endmodule

// 0000 AND
// 0001 OR
// 0010 ADD
// 0110 SUB
