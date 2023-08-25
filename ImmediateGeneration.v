module ImmediateGeneration (
    input [31:0] instruction,
    output reg [31:0] immediate
);

        always @* begin
            case (instruction[6:0])
                // type I
                7'b1100111,
                7'b0000011,
                7'b0010011: immediate = {{20{instruction[31]}}, instruction[31:20]};
                // type S
                7'b0100011: immediate = {{20{instruction[31]}}, instruction[31:25], instruction[11:8], instruction[7]};
                // type B
                7'b1100011: immediate = {{19{instruction[31]}}, instruction[7], instruction[31:25], instruction[11:8], 1'b0};
                // type U
                7'b0110111,
                7'b0010111: immediate = {instruction[31:12], {12{1'b0}}};
                // type J
                7'b1101111 : immediate = {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:25], instruction[24:21], 1'b0};
                default: immediate = 0;
            endcase
        end

endmodule

