module Div (
    input clk,
    input [31:0] dividend,
    input [31:0] divisor,
    input isUnsigned,
    input start,
    output reg done,
    output reg busy,
    output reg [31:0] val,
    output reg [31:0] rem
);

    parameter IDLE = 0;
    parameter INIT = 1;
    parameter DIVIDE = 2;
    parameter FINISH = 3;

    initial begin
        state = IDLE;
    end

    reg [6:0] i;
    reg [63:0] tmp_dividend, next_tmp_dividend;
    reg [31:0] quo, next_quo, curr_rem, next_rem;
    reg [31:0] a, b;
    reg a_sign, b_sign, sign;
    reg [2:0] state;

    always @* begin
        a_sign = dividend[31];
        b_sign = divisor[31];
    end

    always @* begin
        if (tmp_dividend <= curr_rem) begin
            next_rem = next_rem - tmp_dividend[31:0];
            next_quo = {quo[30:0], 1'b1};
            next_tmp_dividend = tmp_dividend >> 1;
        end else begin
            next_quo = quo << 1;
            next_tmp_dividend = tmp_dividend >> 1;
        end
    end

    always @(posedge clk) begin
        done <= 0;
        case (state)
            INIT: begin
                state <= DIVIDE;
                i <= 0;
                curr_rem <= a;
                tmp_dividend <= {b, 32'b0};
            end
            DIVIDE: begin
                if (i == 31) state <= FINISH;
                i <= i + 1;
                tmp_dividend <= next_tmp_dividend;
                curr_rem <= next_rem;
                quo <= next_quo;
            end
            FINISH: begin
                state <= IDLE;
                busy <= 0;
                done <= 1;
                if (quo != 0) val <= (sign) ? (~quo + 1) : quo;
                rem <= (a_sign & ~isUnsigned) ? (~curr_rem + 1) : curr_rem;
            end
            default: begin
                if (start) begin
                    state <= INIT;
                    busy <= 1;
                    if(~isUnsigned) begin
                        a <= (a_sign) ? ~dividend + 1 : dividend;
                        b <= (b_sign) ? ~divisor + 1 : divisor;
                        sign <= a_sign ^ b_sign;
                    end else begin
                        a <= dividend;
                        b <= divisor;
                        sign <= 0;
                    end

                end
            end
        endcase
    end
endmodule
