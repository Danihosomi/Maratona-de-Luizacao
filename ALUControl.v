module ALUControl (
    input [1:0] ALUOp,
    input [2:0] func3,
    input func7,
    output reg [3:0] result
);

        always @* begin
            case (ALUOp)
                2'b00: result = 4'b0010; 
                2'b01: result = 4'b0110;                   
                2'b11: result = 4'b0110;               
                2'b10: 
                    case (func3)
                        3'b000: result = func7 ? 4'b0110 : 4'b0010;
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
// 0110 SUB