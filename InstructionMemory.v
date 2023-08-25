module InstructionMemory (
    input clk,
    input [31:0] readAddress,
    output [31:0] instruction
);

    ROMMemory instructionMemoryROM(
        .clk(clk),
        .address(readAddress),
        .data(instruction)
    );

endmodule
