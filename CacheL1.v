// Creates a cache L1 module
module CacheL1(
  input clk,
  input [31:0] address,
  input readEnable,
  input writeEnable,
  input [31:0] dataIn,
  output reg [31:0] dataOut,
  output reg cacheReady,
  
  // Memory wires
  input [31:0] memoryDataIn,
  output [31:0] memoryDataOut,
  output [31:0] memoryAddress,
  output memoryReadEnable,
  output memoryWriteEnable,
  input memoryReady
);
  // Wires passing throught cache
  assign memoryDataOut = dataIn;
  assign memoryAddress = address;
  assign memoryReadEnable = readEnable;
  assign memoryWriteEnable = writeEnable;

  // Machine states
  parameter READY = 2'b00;
  parameter WRITE = 2'b01;
  parameter READ = 2'b10;
  reg [1:0] state;
  reg validMemory;

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
    state = READY;
  end

  wire hit;
  assign hit = (tag[address[6:2]] == address[10:7]) & clean[address[6:2]];
  assign validMemory = address[31] == 0;

  // Cache controller with machine states
  always @(posedge clk) begin
    cacheReady <= 0;
    case(state)
      READY: begin
        if (!validMemory) begin
          state <= READY;
        end
        else if (hit && readEnable) begin
          state <= READY;
          cacheReady <= 1;
        end
        else if (readEnable) begin
          state <= READ;
        end
        else if (writeEnable) begin
          state <= WRITE;
        end
        else begin
          state <= READY;
        end
      end
      READ: begin
        if (memoryReady) begin
          data[address[6:2]] <= memoryDataIn;
          tag[address[6:2]] <= address[10:7];
          clean[address[6:2]] <= 1;
          cacheReady <= 1;
          state <= READY;
        end
        else begin
          state <= READ;
        end
      end
      WRITE: begin
        if (memoryReady) begin
          clean[address[6:2]] <= 0;
          cacheReady <= 1;
          state <= READY;
        end
        else begin
          state <= WRITE;
        end
      end
      default: begin
        state <= READY;
      end
    endcase
  end

  assign dataOut = data[address[6:2]];

endmodule