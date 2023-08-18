module top
(
    input clk,
    output [5:0] led
);
wire [31:0] instruction;

InstructionFetch instructionFetch(
    .clk(ledCounter),
    .instruction(instruction)
);

localparam WAIT_TIME = 13500000;
reg ledCounter = 0;
reg [23:0] clockCounter = 0;

always @(posedge clk) begin
    clockCounter <= clockCounter + 1;
    if (clockCounter == WAIT_TIME) begin
        clockCounter <= 0;
        ledCounter <= ~ledCounter;
    end
end

assign led = instruction[5:0];
endmodule