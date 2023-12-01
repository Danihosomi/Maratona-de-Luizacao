// Creates a cache L1 module
module CacheL1(
  input clk,
  input [31:0] address,
  input readEnable,
  input writeEnable,
  input byteOperation,
  input halfOperation,
  input unsignedRead,
  input [31:0] dataIn,
  output [31:0] dataOut,
  output cacheReady,

  // Memory wires
  input [31:0] memoryDataIn,
  output [31:0] memoryDataOut,
  output [31:0] memoryAddress,
  output memoryReadEnable,
  output memoryWriteEnable,
  input memoryReady
);
  // Handling 'broken' memory reads and writes
  wire wordOperation;
  wire needNextAddress;
  wire needReadAddress;
  wire [31:0] nextAddress;
  wire [31:0] readAddress;
  wire [31:0] writeAddress;
  reg readNextAddress;
  reg writeNextAddress;
  reg writeReadPhase;
  wire writeWritePhase;
  assign wordOperation = ~(byteOperation | halfOperation);
  assign needNextAddress = (wordOperation & (address[1:0] != 2'b00)) | (halfOperation & (address[1:0] == 2'b11));
  assign needReadAddress = (~(wordOperation & (address[1:0] == 2'b00)) & writeEnable) | ~hit | (needNextAddress & ~nextAddressHit);
  assign nextAddress = address + 4;
  assign readAddress = readNextAddress ? nextAddress : address;
  assign writeAddress = writeNextAddress ? nextAddress : address;
  assign writeWritePhase = ~writeReadPhase;

  // Memory wires
  assign memoryDataOut = invalidMemory? dataIn : writeNextAddress ? bigCacheDataToWrite[63:32] : bigCacheDataToWrite[31:0];
  assign memoryAddress = invalidMemory ? address : memoryReadEnable ? readAddress : writeAddress;
  assign memoryReadEnable = invalidMemory ? readEnable : readEnable | (writeReadPhase & writeEnable);
  assign memoryWriteEnable = invalidMemory ? writeEnable : writeWritePhase & writeEnable;

  // Machine states
  parameter IDLE = 2'b00;
  parameter READY = 2'b01;
  parameter WRITE = 2'b10;
  parameter READ = 2'b11;
  reg [1:0] state;

  wire [31:0] inFlightAddress = (state == IDLE) ? address : savedAddress;
  reg [31:0] savedAddress;

  // Cache
  reg clean [31:0];
  reg [3:0] tag [31:0];
  reg [31:0] data [31:0];

  initial begin
    clean[0] = 0;
    clean[1] = 0;
    clean[2] = 0;
    clean[3] = 0;
    clean[4] = 0;
    clean[5] = 0;
    clean[6] = 0;
    clean[7] = 0;
    clean[8] = 0;
    clean[9] = 0;
    clean[10] = 0;
    clean[11] = 0;
    clean[12] = 0;
    clean[13] = 0;
    clean[14] = 0;
    clean[15] = 0;
    clean[16] = 0;
    clean[17] = 0;
    clean[18] = 0;
    clean[19] = 0;
    clean[20] = 0;
    clean[21] = 0;
    clean[22] = 0;
    clean[23] = 0;
    clean[24] = 0;
    clean[25] = 0;
    clean[26] = 0;
    clean[27] = 0;
    clean[28] = 0;
    clean[29] = 0;
    clean[30] = 0;
    clean[31] = 0;
    state = IDLE;
    readNextAddress = 0;
    writeNextAddress = 0;
    writeReadPhase = 1;
  end

  wire tagMatch;
  wire hit;
  wire nextAddressTagMatch;
  wire nextAddressHit;
  wire readReady;
  wire invalidMemory;
  wire cacheIdle;
  assign tagMatch = tag[address[6:2]] == address[10:7];
  assign hit = tagMatch & clean[address[6:2]];
  assign nextAddressTagMatch = tag[nextAddress[6:2]] == nextAddress[10:7];
  assign nextAddressHit = nextAddressTagMatch & clean[nextAddress[6:2]];
  assign invalidMemory = address[31];
  assign cacheIdle = ~(readEnable | writeEnable);
  assign readReady = memoryReadEnable & ~needReadAddress;

  // Cache controller with machine states
  always @(posedge clk) begin
    if (state != IDLE && inFlightAddress != address) begin
      state <= IDLE;
    end
    else begin
      case(state)
        IDLE: begin
          savedAddress <= address;
          if (invalidMemory) begin
            state <= IDLE;
          end
          else if (readReady) begin
            if (writeEnable) begin
              writeReadPhase <= 0;
              state <= WRITE;
            end
            else begin
              state <= IDLE;
            end
          end
          else if (memoryReadEnable) begin
            readNextAddress <= hit;
            state <= READ;
          end
          else begin
            state <= IDLE;
          end
        end
        READ: begin
          if (memoryReady) begin
            data[memoryAddress[6:2]] <= memoryDataIn;
            tag[memoryAddress[6:2]] <= memoryAddress[10:7];
            clean[memoryAddress[6:2]] <= 1;
            if (needNextAddress & ~readNextAddress & ~nextAddressHit) begin
              readNextAddress <= 1;
              state <= READ;
            end
            else begin
              readNextAddress <= 0;
              if (writeEnable) begin
                writeReadPhase <= 0;
                state <= WRITE;
              end
              else begin
                state <= READY;
              end
            end
          end
          else begin
            state <= READ;
          end
        end
        WRITE: begin
          if (memoryReady) begin
            clean[memoryAddress[6:2]] <= (tagMatch) ? 0 : clean[memoryAddress[6:2]];
            if (needNextAddress & ~writeNextAddress) begin
              writeNextAddress <= 1;
              state <= WRITE;
            end
            else begin
              writeNextAddress <= 0;
              state <= READY;
            end
          end
          else begin
            state <= WRITE;
          end
        end
        default: begin
          state <= IDLE;
          writeReadPhase <= 1;
        end
      endcase
    end
  end

  wire [63:0] bigCacheData;
  wire [31:0] signedData;
  wire [31:0] unsignedData;
  reg  [63:0] bigCacheDataToWrite;

  assign bigCacheData = {data[nextAddress[6:2]], data[address[6:2]]};

  reg [5:0] startBit;

  always @* begin
    startBit =
      (address[1:0] == 2'b00) ? 0 :
      (address[1:0] == 2'b01) ? 8 :
      (address[1:0] == 2'b10) ? 16 :
      24;
  end

  assign unsignedData =
    (byteOperation) ? {24'b0, bigCacheData[startBit +: 8]} :
    (halfOperation) ? {16'b0, bigCacheData[startBit +: 16]} :
    (wordOperation) ? bigCacheData[startBit +: 32] :
    0;

  assign signedData =
    (byteOperation) ? {{24{bigCacheData[startBit + 7]}}, bigCacheData[startBit +: 8]} :
    (halfOperation) ? {{16{bigCacheData[startBit + 15]}}, bigCacheData[startBit +: 16]} :
    (wordOperation) ? bigCacheData[startBit +: 32] :
    0;

  always @* begin
    bigCacheDataToWrite = bigCacheData;
    if (byteOperation) begin
      bigCacheDataToWrite[startBit +: 8] = dataIn[7:0];
    end
    else if (halfOperation) begin
      bigCacheDataToWrite[startBit +: 16] = dataIn[15:0];
    end
    else if (wordOperation) begin
      bigCacheDataToWrite[startBit +: 32] = dataIn;
    end
  end

  assign dataOut = unsignedRead ? unsignedData : signedData;
  assign cacheReady = ((state == READY) | (readReady & ~writeEnable) | cacheIdle) && inFlightAddress == address;

endmodule
