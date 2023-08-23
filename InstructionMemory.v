module InstructionMemory (
    input clk,
    input [31:0] readAdress,
    output [31:0] instruction
);

    ROMMemory instructionMemoryROM(
        .clk(clk),
        .address(readAdress),
        .data(instruction)
    );

endmodule
