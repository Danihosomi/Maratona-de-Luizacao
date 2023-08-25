module RAM(
    input writeEnable,
    input readEnable,
    input [31:0] address,
    input [31:0] dataIn,
    output reg [31:0] dataOut
);

    reg [31:0] memory [255:0];

    always @* begin
        if (writeEnable) begin
            memory[address[9:2]] = dataIn;
            dataOut = 0;
        end
        else begin
          memory[address[9:2]] = memory[address[9:2]];
          if (readEnable) begin
            dataOut = memory[address[9:2]];
          end
          else begin
            dataOut = 0;
          end
        end
    end

endmodule
