module Div (
    input clk,
    input [31:0] dividend,
    input [31:0] divisor,
    input isUnsigned,
    input start,
    output done,
    output [31:0] val,
    output [31:0] rem
);

    parameter IDLE = 0;
    parameter DIVIDE = 1;
    parameter FINISH = 2;

    initial begin
        state = IDLE;
    end

    reg [6:0] i;
    reg [63:0] tmp_divisor, next_tmp_divisor;
    reg [31:0] quo, next_quo, curr_rem, next_rem;
    wire [31:0] unsigned_dividend, unsigned_divisor;
    wire u_dividend_sign, u_divisor_sign, sign;
    reg [2:0] state;

    assign u_dividend_sign = dividend[31];
    assign u_divisor_sign = divisor[31];
    assign sign = isUnsigned ? 0 : u_dividend_sign ^ u_divisor_sign;

    assign unsigned_dividend = (u_dividend_sign & ~isUnsigned) ? ~dividend + 1 : dividend;
    assign unsigned_divisor = (u_divisor_sign & ~isUnsigned) ? ~divisor + 1 : divisor;

    assign val = (sign) ? (~quo + 1) : quo;
    assign rem = (u_dividend_sign & ~isUnsigned) ? (~curr_rem + 1) : curr_rem;

    always @(tmp_divisor, curr_rem, quo) begin
        if (tmp_divisor <= {32'b0, curr_rem}) begin
          next_rem = curr_rem - tmp_divisor[31:0];
          next_quo = {quo[30:0], 1'b1};
          next_tmp_divisor = tmp_divisor >> 1;
        end else begin
          next_rem = curr_rem;
          next_quo = quo << 1;
          next_tmp_divisor = tmp_divisor >> 1;
        end
    end

    assign done = (state == FINISH);
    always @(posedge clk) begin
        case (state)
            DIVIDE: begin
                if (i == 32) state <= FINISH;
                i <= i + 1;
                tmp_divisor <= next_tmp_divisor;
                curr_rem <= next_rem;
                quo <= next_quo;
            end
            FINISH: begin
                state <= IDLE;
            end
            default: begin //IDLE
                if (start) begin
                state <= DIVIDE;
                i <= 0;
                curr_rem <= unsigned_dividend;
                tmp_divisor <= {unsigned_divisor, 32'b0};
                end
            end
        endcase
    end
endmodule
