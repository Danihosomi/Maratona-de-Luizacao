module _MUX4(
    input [1:0] dataSelector,
    input [31:0] firstData,
    input [31:0] secondData,
    input [31:0] thirdData,
    input [31:0] fourthData,
    output reg [31:0] outputData
);

always @(*) begin
    case (dataSelector)
        0: outputData = firstData;
        1: outputData = secondData;
        2: outputData = thirdData;
        3: outputData = fourthData;
    endcase
end

endmodule
