module Div (
    input [31:0] dividend,
    input [31:0] divisor,
    output reg [31:0] quocient,
    output reg [31:0] remainder
);

reg [63:0] tmp_divisor;
reg [31:0] tmp_dividend;
reg [31:0] aux;


always @* begin
    aux = {1'b1, 31'b0};
    quocient = 0;

    if (divisor[31] == 1) begin
        tmp_divisor = {~divisor + 1, 32'b0};
    end
    if (dividend[31] == 1) begin
        tmp_dividend =  ~dividend + 1;
    end

    for (integer i = 0; i < 32; i = i + 1) begin
        if (tmp_dividend - tmp_divisor >= 0) begin
            tmp_dividend = tmp_dividend - tmp_divisor;
            quocient = {quocient, 1};
            tmp_divisor = tmp_divisor >> 1;
        end
    end

    quocient = quocient << 1;

    remainder = tmp_dividend;

    if (divisor[31] ^ dividend[31]) begin
        quocient = ~quocient + 1;
    end
    if (dividend[31]) begin
        remainder = ~remainder + 1;
    end
end

endmodule