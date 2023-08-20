module IntructionMemory (
    input [31:0] readAdress,
    output [31:0] intruction
);

    ROM instructionMemoryROM(
        .address(readAdress),
        .data(instruction)
    );

endmodule
