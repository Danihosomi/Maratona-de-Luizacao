module RAM(
    input clk,
    input writeEnable,
    input [31:0] address,
    input [31:0] data_in,
    output [31:0] data_out
);

    reg [31:0] memory [255:0];

    always @(posedge clk) begin
        if (writeEnable) begin
            memory[address[9:2]] <= data_in;
        end
    end

    assign data_out = memory[address[9:2]];
endmodule

