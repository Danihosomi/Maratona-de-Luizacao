module CompactInstructionsUnit(
 input [31:0] targetInstruction,
 output [31:0] resultInstruction,
 output descompactedInstruction
);

assign descompactedInstruction = isInstructionCompacted;

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

wire [31:0] ADDI4SPNimmmediate = { {22{1'b0}}, compactInstruction[10:7], compactInstruction[12:11], compactInstruction[5], compactInstruction[6], 2'b00 }; // unsigned
wire [31:0] LWimmediate = { {25{1'b0}}, compactInstruction[5], compactInstruction[12:10], compactInstruction[6], 2'b00 };
wire [31:0] SWimmediate = { {25{1'b0}}, compactInstruction[5], compactInstruction[12:10], compactInstruction[6], 2'b00 }; // unsigned
wire [31:0] ADDIimmediate = { {27{compactInstruction[12]}}, compactInstruction[6:2] }; // signed
wire [31:0] JALimmediate = { {21{compactInstruction[12]}}, compactInstruction[8], compactInstruction[10:9], compactInstruction[6], compactInstruction[7], compactInstruction[2], compactInstruction[11], compactInstruction[5:3], 1'b0 }; // signed
wire [31:0] LIimmediate = { {27{compactInstruction[12]}}, compactInstruction[6:2] }; // signed
wire [31:0] ADDI16SPimmediate = { {23{compactInstruction[12]}}, compactInstruction[4:3], compactInstruction[5], compactInstruction[2], compactInstruction[6], 4'b0000 }; // signed
wire [31:0] LUIimmediate = { {15{compactInstruction[12]}}, compactInstruction[6:2], {12{1'b0}} }; // signed
wire [31:0] SRLIimmediate = { {26{1'b0}}, compactInstruction[12], compactInstruction[6:2] }; // unsigned
wire [31:0] SRAIimmediate = { {26{1'b0}}, compactInstruction[12], compactInstruction[6:2] }; // unsigned
wire [11:0] ANDIimmediate = { {7{compactInstruction[12]}}, compactInstruction[6:2] }; // signed
wire [31:0] Jimmediate = { {21{compactInstruction[12]}}, compactInstruction[8], compactInstruction[10:9], compactInstruction[6], compactInstruction[7], compactInstruction[2], compactInstruction[11], compactInstruction[5:3], 1'b0 }; // signed
wire [31:0] BEQZimmediate = { {24{compactInstruction[12]}}, compactInstruction[6:5], compactInstruction[2], compactInstruction[11:10], compactInstruction[4:3], 1'b0 }; // signed
wire [31:0] BNEZimmediate = { {24{compactInstruction[12]}}, compactInstruction[6:5], compactInstruction[2], compactInstruction[11:10], compactInstruction[4:3], 1'b0 }; // signed
wire [5:0] SLLIimmediate = { compactInstruction[12], compactInstruction[6:2] }; // unsigned
wire [11:0] LWSPimmediate = { 4'b0000, compactInstruction[3:2], compactInstruction[12], compactInstruction[6:4], 2'b00 }; // unsigned
wire [11:0] SWSPimmediate = { 4'b0000, compactInstruction[8:7], compactInstruction[12:9], 2'b00 }; // unsigned

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
            expandedInstruction <= { ADDI4SPNimmmediate[11:0], 5'b00010, 3'b000, expandedRsRight, 7'b0010011 };
         end
       end

       3'b001: shouldIgnoreInstruction <= 1; // C.FLD / C.LQ

       3'b010: begin // C.LW
          expandedInstruction <= { LWimmediate[11:0], expandedRsLeft, 3'b010, expandedRsRight, 7'b0000011 };
       end

       3'b011: shouldIgnoreInstruction <= 1; // C.FLW / C.LD

       3'b100: isIllegalInstruction <= 1; // Reserved

       3'b101: shouldIgnoreInstruction <= 1; // C.FSD / C.SQ

       3'b110: begin // C.SW
          expandedInstruction <= { SWimmediate[11:5], expandedRsRight, expandedRsLeft, 3'b010, SWimmediate[4:0], 7'b0100011 };
       end

       3'b111: shouldIgnoreInstruction <= 1; // C.FSW / C.SD
     endcase
   end


   2'b01: begin
     case(func3)
       3'b000: begin // C.NOP / C.ADDI
          expandedInstruction <= { ADDIimmediate[11:0], wideRsLeft, 3'b000, wideRsLeft, 7'b0010011 };
       end

       3'b001: begin // C.JAL
          expandedInstruction <= { JALimmediate[20], JALimmediate[10:1], JALimmediate[11], JALimmediate[19:12], 5'b00001, 7'b1101111 };
       end

       3'b010: begin // C.LI
          expandedInstruction <= { LIimmediate[11:0], 5'b00000, 3'b000, wideRsLeft, 7'b0010011 };
       end

       3'b011: begin
         if (wideRsLeft == 2) begin // C.ADDI16SP  
            expandedInstruction <= { ADDI16SPimmediate[11:0], 5'b00010, 3'b000, 5'b00010, 7'b0010011 };
         end
         else begin // C.LUI
            expandedInstruction <= { LUIimmediate[31:12], wideRsLeft, 7'b0110111 };
         end
       end

       3'b100: begin
         case(compactInstruction[11:10])
           2'b00: begin // C.SRLI
              expandedInstruction <= { 7'b0000000, SRLIimmediate[4:0], expandedRsLeft, 3'b101, expandedRsLeft, 7'b0010011 };
           end

           2'b01: begin // C.SRAI
              expandedInstruction <= { 7'b0100000, SRAIimmediate[4:0], expandedRsLeft, 3'b101, expandedRsLeft, 7'b0010011 };
           end

           2'b10: begin // C.ANDI
              expandedInstruction <= { ANDIimmediate, expandedRsLeft, 3'b111, expandedRsLeft, 7'b0010011 };
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
          expandedInstruction <= { Jimmediate[20], Jimmediate[10:1], Jimmediate[11], Jimmediate[19:12], 5'b00000, 7'b1101111 };
       end

       3'b110: begin // C.BEQZ
          expandedInstruction <= { BEQZimmediate[12], BEQZimmediate[10:5], 5'b00000, expandedRsLeft, 3'b000, BEQZimmediate[4:1], BEQZimmediate[11], 7'b1100011 };
       end

       3'b111: begin // C.BNEZ
          expandedInstruction <= { BNEZimmediate[12], BNEZimmediate[10:5], 5'b00000, expandedRsLeft, 3'b001, BNEZimmediate[4:1], BNEZimmediate[11], 7'b1100011 };
       end
     endcase
   end


   2'b10: begin
     case(func3)
          
       3'b000: begin // C.SLLI
          expandedInstruction <= { 7'b0000000, SLLIimmediate[4:0], wideRsLeft, 3'b001, wideRsLeft, 7'b0010011 };
       end

       3'b001: shouldIgnoreInstruction <= 1; // C.FLDSP / C.LQSP

       3'b010: begin // C.LWSP
          expandedInstruction <= { LWSPimmediate[11:0], 5'b00010, 3'b010, wideRsLeft, 7'b0000011 };
       end

       3'b011: shouldIgnoreInstruction <= 1; // C.FLWSP / C.LDSP

       3'b100: begin
         if (func4 == 0) begin
           if (wideRsRight == 0) begin // C.JR
              expandedInstruction <= { 12'b000000000000, wideRsLeft, 3'b000, 5'b00000, 7'b1100111 };
           end
           else begin // C.MV
              expandedInstruction <= { 7'b0000000, wideRsRight, 5'b00000, 3'b000, wideRsLeft, 7'b0110011 };
           end
         end
         else begin
           if (wideRsRight == 0) begin
             if (wideRsLeft == 0) begin // C.EBREAK
                expandedInstruction <= { 12'b000000000001, 5'b00000, 3'b000, 5'b00000, 7'b1110011 };
             end
             else begin // C.JALR
                expandedInstruction <= { 12'b000000000000, wideRsLeft, 3'b000, 5'b00001, 7'b1100111 };
             end
           end
           else begin // C.ADD
              expandedInstruction <= { 7'b0000000, wideRsRight, wideRsLeft, 3'b000, wideRsLeft, 7'b0110011 };
           end
         end
       end

       3'b101: shouldIgnoreInstruction <= 1; // C.FSDSP / C.SQSP

       3'b110: begin // C.SWSP
          expandedInstruction <= { SWSPimmediate[11:5], wideRsRight, 5'b00010, 3'b010, SWSPimmediate[4:0], 7'b0100011 };
       end

       3'b111: shouldIgnoreInstruction <= 1; // C.FSWSP / C.SDSP
     endcase
   end

   default: begin
   end
 endcase
end

endmodule