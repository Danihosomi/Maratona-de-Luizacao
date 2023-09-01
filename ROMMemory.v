module ROMMemory (
  input [31:0] address,
  output reg [31:0] data
);

  always @* begin
    case(address[9:2]) 
        0: data = 32'h00a00093;
        1: data = 32'h01400113;
        2: data = 32'h01e00193;
        3: data = 32'h40102023;
        4: data = 32'h40202223;
        5: data = 32'h40302423;
        6: data = 32'h40002203;
        7: data = 32'h40402283;
        8: data = 32'h40802303;
    endcase
  end

endmodule
