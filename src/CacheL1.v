// Creates a cache L1 module
module CacheL1(
  input clk,
  input [31:0] address,
  input readEnable,
  input writeEnable,
  input byteRead,
  input halfRead,
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
  // Handling 'broken' memory reads
  wire wordRead;
  wire needNextAddress;
  wire [31:0] nextAddress;
  wire [31:0] readAddress;
  wire [31:0] writeAddress;
  reg readNextAddress;
  assign wordRead = ~(byteRead | halfRead);
  assign needNextAddress = (wordRead & (address[1:0] != 2'b00)) || (halfRead & (address[1:0] == 2'b11));
  assign nextAddress = address + 4;
  assign readAddress = readNextAddress ? nextAddress : address;
  assign writeAddress = address;

  // Wires passing throught cache
  assign memoryDataOut = dataIn;
  assign memoryAddress = readEnable ? readAddress : writeAddress;
  assign memoryReadEnable = readEnable;
  assign memoryWriteEnable = writeEnable;

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
  end

  wire hit;
  wire tagMatch;
  wire readReady;
  wire invalidMemory;
  wire cacheIdle;
  assign tagMatch = tag[memoryAddress[6:2]] == memoryAddress[10:7];
  assign hit = tagMatch & clean[memoryAddress[6:2]];
  assign invalidMemory = memoryAddress[31];
  assign cacheIdle = ~(readEnable | writeEnable);
  assign readReady = hit & readEnable & ~needNextAddress;

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
            state <= IDLE;
          end
          else if (readEnable) begin
            state <= READ;
          end
          else if (writeEnable) begin
            state <= WRITE;
          end
          else begin
            state <= IDLE;
          end
        end
        READ: begin
          if (memoryReady) begin
            data[readAddress[6:2]] <= memoryDataIn;
            tag[readAddress[6:2]] <= readAddress[10:7];
            clean[readAddress[6:2]] <= 1;
            if (needNextAddress == 1 & readNextAddress == 0) begin
              readNextAddress <= 1;
              state <= READ;
            end
            else begin
              readNextAddress <= 0;
              state <= READY;
            end
          end
          else begin
            state <= READ;
          end
        end
        WRITE: begin
          if (memoryReady) begin
            clean[writeAddress[6:2]] <= (tagMatch) ? 0 : clean[writeAddress[6:2]];
            state <= READY;
          end
          else begin
            state <= WRITE;
          end
        end
        default: begin
          state <= IDLE;
        end
      endcase
    end
  end

  wire [63:0] bigCacheData;
  wire [31:0] signedData;
  wire [31:0] unsignedData;

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
    (byteRead) ? {24'b0, bigCacheData[startBit +: 8]} :
    (halfRead) ? {16'b0, bigCacheData[startBit +: 16]} :
    (wordRead) ? bigCacheData[startBit +: 32] :
    0;

  assign signedData =
    (byteRead) ? {{24{bigCacheData[startBit + 7]}}, bigCacheData[startBit +: 8]} :
    (halfRead) ? {{16{bigCacheData[startBit + 15]}}, bigCacheData[startBit +: 16]} :
    (wordRead) ? bigCacheData[startBit +: 32] :
    0;

  assign dataOut = unsignedRead ? unsignedData : signedData;
  assign cacheReady = ((state == READY) | readReady | cacheIdle) && inFlightAddress == address;

endmodule
