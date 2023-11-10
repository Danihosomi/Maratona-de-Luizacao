module CompactInstructionsUnit(
  input [31:0] targetInstruction,
  output [31:0] resultInstruction
  // output exception
);

wire isInstructionCompacted = targetInstruction != 0 && targetInstruction[1:0] != 2'b11;
wire [15:0] compactInstruction = targetInstruction[15:0];

wire [1:0] opCode = compactInstruction[1:0];
wire [2:0] func3 = compactInstruction[15:13];
wire func4 = compactInstruction[12];

wire [4:0] wideRsLeft = compactInstruction[11:7];
wire [4:0] wideRsRight = compactInstruction[6:2];

wire [2:0] compactRsLeft = compactInstruction[9:7];
wire [2:0] compactRsRight = compactInstruction[4:2];

wire [4:0] expandedRsLeft = { 2'b01, compactRsLeft };
wire [4:0] expandedRsRight = { 2'b01, compactRsRight };

reg isIllegalInstruction;
reg shouldIgnoreInstruction;
reg notImplemented;
reg notSupported;

reg [31:0] expandedInstruction;
assign resultInstruction = isInstructionCompacted ? expandedInstruction : targetInstruction;

always @(targetInstruction) begin
  isIllegalInstruction <= 0;
  shouldIgnoreInstruction <= 0;
  notImplemented <= 0;

  case(opCode)
    2'b00: begin
      case(func3)
        3'b000: begin
          if (compactInstruction == 0) begin // Illegal
            isIllegalInstruction <= 1;
          end
          else begin // C.ADDI4SPN
            notImplemented <= 1;
          end
        end

        3'b001: shouldIgnoreInstruction <= 1; // C.FLD / C.LQ

        3'b010: begin // C.LW
          reg [31:0] immediate = { {25{1'b0}}, compactInstruction[5], compactInstruction[12:10], compactInstruction[6], 2'b00 };
          expandedInstruction <= { immediate[11:0], expandedRsLeft, 3'b010, expandedRsRight, 7'b0000011 };
        end

        3'b011: shouldIgnoreInstruction <= 1; // C.FLW / C.LD

        3'b100: isIllegalInstruction <= 1; // Reserved

        3'b101: shouldIgnoreInstruction <= 1; // C.FSD / C.SQ

        3'b110: begin // C.SW
          reg [31:0] immediate = { {25{1'b0}}, compactInstruction[5], compactInstruction[12:10], compactInstruction[6], 2'b00 }; // unsigned
          expandedInstruction <= { immediate[11:5], expandedRsRight, expandedRsLeft, 3'b010, immediate[4:0], 7'b0100011 };
        end

        3'b111: shouldIgnoreInstruction <= 1; // C.FSW / C.SD
      endcase
    end


    2'b01: begin
      case(func3)
        3'b000: begin // C.NOP / C.ADDI
          reg [31:0] immediate = { {27{compactInstruction[12]}}, compactInstruction[6:2] }; // signed
          expandedInstruction <= { immediate[11:0], wideRsLeft, 3'b000, wideRsLeft, 7'b0010011 };
        end

        3'b001: begin // C.JAL
          notImplemented <= 1;
        end

        3'b010: begin // C.LI
          notImplemented <= 1;
        end

        3'b011: begin
          if (wideRsLeft == 2) begin // C.ADDI16SP
            notImplemented <= 1;
          end
          else begin // C.LUI
            notImplemented <= 1;
          end
        end

        3'b100: begin
          case(compactInstruction[11:10])
            2'b00: begin // C.SRLI
              notImplemented <= 1;
            end

            2'b01: begin // C.SRAI
              notImplemented <= 1;
            end

            2'b10: begin // C.ANDI
              reg [11:0] andImm = { {7{compactInstruction[12]}}, compactInstruction[6:2] }; // signed
              expandedInstruction <= { andImm, expandedRsLeft, 3'b111, expandedRsLeft, 7'b0010011 };
            end

            2'b11: begin 
              case({func4, compactInstruction[6:5]})
                3'b000: begin // C.SUB
                  expandedInstruction <= { 7'b0100000, expandedRsRight, expandedRsLeft, 3'b000, expandedRsLeft, 7'b0110011 };
                end

                3'b001: begin // C.XOR
                  expandedInstruction <= { 7'b0000000, expandedRsRight, expandedRsLeft, 3'b100, expandedRsLeft, 7'b0110011 };
                end

                3'b010: begin // C.OR
                  expandedInstruction <= { 7'b0000000, expandedRsRight, expandedRsLeft, 3'b110, expandedRsLeft, 7'b0110011 };
                end

                3'b011: begin // C.AND
                  expandedInstruction <= { 7'b0000000, expandedRsRight, expandedRsLeft, 3'b111, expandedRsLeft, 7'b0110011 };
                end

                3'b100: shouldIgnoreInstruction <= 1; // C.SUBW // TODO: Review

                3'b101: shouldIgnoreInstruction <= 1; // C.ADDW // TODO: Review

                3'b110: isIllegalInstruction <= 1; // Reserved

                3'b111: isIllegalInstruction <= 1; // Reserved
              endcase
            end
          endcase
        end

        3'b101: begin // C.J
          notImplemented <= 1;
        end

        3'b110: begin // C.BEQZ
          notImplemented <= 1;
        end

        3'b111: begin // C.BNEZ
          notImplemented <= 1;
        end
      endcase
    end


    2'b10: begin
      case(func3)
        3'b000: begin // C.SLLI
          notImplemented <= 1;
        end

        3'b001: shouldIgnoreInstruction <= 1; // C.FLDSP / C.LQSP

        3'b010: begin // C.LWSP
          notImplemented <= 1;
        end

        3'b011: shouldIgnoreInstruction <= 1; // C.FLWSP / C.LDSP

        3'b100: begin
          if (func4 == 0) begin
            if (wideRsRight == 0) begin // C.JR
              notImplemented <= 1;
            end
            else begin // C.MV
              notImplemented <= 1;
            end
          end
          else begin
            if (wideRsRight == 0) begin
              if (wideRsLeft == 0) begin // C.EBREAK
                notImplemented <= 1;
              end
              else begin // C.JALR
                notImplemented <= 1;
              end
            end
            else begin // C.ADD
              expandedInstruction <= { 7'b0000000, wideRsRight, wideRsLeft, 3'b000, wideRsLeft, 7'b0110011 };
            end
          end
        end

        3'b101: shouldIgnoreInstruction <= 1; // C.FSDSP / C.SQSP

        3'b110: begin // C.SWSP
          notImplemented <= 1;
        end

        3'b111: shouldIgnoreInstruction <= 1; // C.FSWSP / C.SDSP
      endcase
    end

    default: begin
    end
  endcase
end

endmodule