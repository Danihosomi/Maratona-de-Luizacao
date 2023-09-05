module Tester();
parameter CLK_HALF_PERIOD = 5;
parameter MAX_CYCLES = 10; // Stores the number of clock cycles we want to test

reg clk;
wire [31:0] debug;
// wire [31:0] instruction;

CPU cpu(clk, debug);

// InstructionFetch instructionFetch(
//   .clk(clk),
//   .instruction(instruction)
// );

//wire [3:0] resultALUControl;

// ALUControl aluControl(
//   .ALUOp(2'b10),
//   .func3(3'b110),
//   .func7(1'b0),
//   .result(resultALUControl)
// );

// wire [31:0] resultALU;
// wire zero;

// ALU alu(
//   .ALUControl(resultALUControl),
//   .operand1(32'h00000011),
//   .operand2(32'h0000000A),
//   .resultALU(resultALU),
//   .zero(zero)
// );


// --------- UNCOMMENT THIS FOR TESTING ---------
// initial begin
//   forever clk = #(CLK_HALF_PERIOD) ~clk;
// end

integer curr_cycle = 0;
always @(posedge clk) begin
  if (curr_cycle != MAX_CYCLES) begin
    $display(debug);
    curr_cycle++;
  end
end
endmodule
