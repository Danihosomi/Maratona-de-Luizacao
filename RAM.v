module RAM(
    input clk,
    input writeEnable,
    input [31:0] address,
    input [31:0] dataIn,
    output [31:0] dataOut
);

    reg [31:0] memory [255:0];

    always @(posedge clk) begin
        if (writeEnable) begin
            memory[address[9:2]] <= dataIn;
        end
    end

    assign dataOut = memory[address[9:2]];
endmodule

