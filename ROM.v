module ROM (
  input [31:0] address,
  output reg [31:0] data
);

  always @(*) begin
    case(address[9:2]) 
      0: data <= 32'h00000000;
      1: data <= 32'h00000001;
      2: data <= 32'h00000002;
      3: data <= 32'h00000003;
      4: data <= 32'h00000004;
      5: data <= 32'h00000005;
      6: data <= 32'h00000006;
      7: data <= 32'h00000007;
      8: data <= 32'h00000008;
      9: data <= 32'h00000009;
      10: data <= 32'h0000000A;
      11: data <= 32'h0000000B;
      12: data <= 32'h0000000C;
      13: data <= 32'h0000000D;
      14: data <= 32'h0000000E;
      15: data <= 32'h0000000F;
      16: data <= 32'h00000010;
      17: data <= 32'h00000000;
      18: data <= 32'h00000000;
      19: data <= 32'h00000000;
      20: data <= 32'h00000000;
      21: data <= 32'h00000000;
      22: data <= 32'h00000000;
      23: data <= 32'h00000000;
      24: data <= 32'h00000000;
      25: data <= 32'h00000000;
      26: data <= 32'h00000000;
      27: data <= 32'h00000000;
      28: data <= 32'h00000000;
      29: data <= 32'h00000000;
      30: data <= 32'h00000000;
      31: data <= 32'h00000000;
      32: data <= 32'h00000000;
      33: data <= 32'h00000000;
      34: data <= 32'h00000000;
      35: data <= 32'h00000000;
      36: data <= 32'h00000000;
      37: data <= 32'h00000000;
      38: data <= 32'h00000000;
      39: data <= 32'h00000000;
      40: data <= 32'h00000000;
      41: data <= 32'h00000000;
      42: data <= 32'h00000000;
      43: data <= 32'h00000000;
      44: data <= 32'h00000000;
      45: data <= 32'h00000000;
      46: data <= 32'h00000000;
      47: data <= 32'h00000000;
      48: data <= 32'h00000000;
      49: data <= 32'h00000000;
      50: data <= 32'h00000000;
      51: data <= 32'h00000000;
      52: data <= 32'h00000000;
      53: data <= 32'h00000000;
      54: data <= 32'h00000000;
      55: data <= 32'h00000000;
      56: data <= 32'h00000000;
      57: data <= 32'h00000000;
      58: data <= 32'h00000000;
      59: data <= 32'h00000000;
      60: data <= 32'h00000000;
      61: data <= 32'h00000000;
      62: data <= 32'h00000000;
      63: data <= 32'h00000000;
      64: data <= 32'h00000000;
      65: data <= 32'h00000000;
      66: data <= 32'h00000000;
      67: data <= 32'h00000000;
      68: data <= 32'h00000000;
      69: data <= 32'h00000000;
      70: data <= 32'h00000000;
      71: data <= 32'h00000000;
      72: data <= 32'h00000000;
      73: data <= 32'h00000000;
      74: data <= 32'h00000000;
      75: data <= 32'h00000000;
      76: data <= 32'h00000000;
      77: data <= 32'h00000000;
      78: data <= 32'h00000000;
      79: data <= 32'h00000000;
      80: data <= 32'h00000000;
      81: data <= 32'h00000000;
      82: data <= 32'h00000000;
      83: data <= 32'h00000000;
      84: data <= 32'h00000000;
      85: data <= 32'h00000000;
      86: data <= 32'h00000000;
      87: data <= 32'h00000000;
      88: data <= 32'h00000000;
      89: data <= 32'h00000000;
      90: data <= 32'h00000000;
      91: data <= 32'h00000000;
      92: data <= 32'h00000000;
      93: data <= 32'h00000000;
      94: data <= 32'h00000000;
      95: data <= 32'h00000000;
      96: data <= 32'h00000000;
      97: data <= 32'h00000000;
      98: data <= 32'h00000000;
      99: data <= 32'h00000000;
      100: data <= 32'h00000000;
      101: data <= 32'h00000000;
      102: data <= 32'h00000000;
      103: data <= 32'h00000000;
      104: data <= 32'h00000000;
      105: data <= 32'h00000000;
      106: data <= 32'h00000000;
      107: data <= 32'h00000000;
      108: data <= 32'h00000000;
      109: data <= 32'h00000000;
      110: data <= 32'h00000000;
      111: data <= 32'h00000000;
      112: data <= 32'h00000000;
      113: data <= 32'h00000000;
      114: data <= 32'h00000000;
      115: data <= 32'h00000000;
      116: data <= 32'h00000000;
      117: data <= 32'h00000000;
      118: data <= 32'h00000000;
      119: data <= 32'h00000000;
      120: data <= 32'h00000000;
      121: data <= 32'h00000000;
      122: data <= 32'h00000000;
      123: data <= 32'h00000000;
      124: data <= 32'h00000000;
      125: data <= 32'h00000000;
      126: data <= 32'h00000000;
      127: data <= 32'h00000000;
      128: data <= 32'h00000000;
      129: data <= 32'h00000000;
      130: data <= 32'h00000000;
      131: data <= 32'h00000000;
      132: data <= 32'h00000000;
      133: data <= 32'h00000000;
      134: data <= 32'h00000000;
      135: data <= 32'h00000000;
      136: data <= 32'h00000000;
      137: data <= 32'h00000000;
      138: data <= 32'h00000000;
      139: data <= 32'h00000000;
      140: data <= 32'h00000000;
      141: data <= 32'h00000000;
      142: data <= 32'h00000000;
      143: data <= 32'h00000000;
      144: data <= 32'h00000000;
      145: data <= 32'h00000000;
      146: data <= 32'h00000000;
      147: data <= 32'h00000000;
      148: data <= 32'h00000000;
      149: data <= 32'h00000000;
      150: data <= 32'h00000000;
      151: data <= 32'h00000000;
      152: data <= 32'h00000000;
      153: data <= 32'h00000000;
      154: data <= 32'h00000000;
      155: data <= 32'h00000000;
      156: data <= 32'h00000000;
      157: data <= 32'h00000000;
      158: data <= 32'h00000000;
      159: data <= 32'h00000000;
      160: data <= 32'h00000000;
      161: data <= 32'h00000000;
      162: data <= 32'h00000000;
      163: data <= 32'h00000000;
      164: data <= 32'h00000000;
      165: data <= 32'h00000000;
      166: data <= 32'h00000000;
      167: data <= 32'h00000000;
      168: data <= 32'h00000000;
      169: data <= 32'h00000000;
      170: data <= 32'h00000000;
      171: data <= 32'h00000000;
      172: data <= 32'h00000000;
      173: data <= 32'h00000000;
      174: data <= 32'h00000000;
      175: data <= 32'h00000000;
      176: data <= 32'h00000000;
      177: data <= 32'h00000000;
      178: data <= 32'h00000000;
      179: data <= 32'h00000000;
      180: data <= 32'h00000000;
      181: data <= 32'h00000000;
      182: data <= 32'h00000000;
      183: data <= 32'h00000000;
      184: data <= 32'h00000000;
      185: data <= 32'h00000000;
      186: data <= 32'h00000000;
      187: data <= 32'h00000000;
      188: data <= 32'h00000000;
      189: data <= 32'h00000000;
      190: data <= 32'h00000000;
      191: data <= 32'h00000000;
      192: data <= 32'h00000000;
      193: data <= 32'h00000000;
      194: data <= 32'h00000000;
      195: data <= 32'h00000000;
      196: data <= 32'h00000000;
      197: data <= 32'h00000000;
      198: data <= 32'h00000000;
      199: data <= 32'h00000000;
      200: data <= 32'h00000000;
      201: data <= 32'h00000000;
      202: data <= 32'h00000000;
      203: data <= 32'h00000000;
      204: data <= 32'h00000000;
      205: data <= 32'h00000000;
      206: data <= 32'h00000000;
      207: data <= 32'h00000000;
      208: data <= 32'h00000000;
      209: data <= 32'h00000000;
      210: data <= 32'h00000000;
      211: data <= 32'h00000000;
      212: data <= 32'h00000000;
      213: data <= 32'h00000000;
      214: data <= 32'h00000000;
      215: data <= 32'h00000000;
      216: data <= 32'h00000000;
      217: data <= 32'h00000000;
      218: data <= 32'h00000000;
      219: data <= 32'h00000000;
      220: data <= 32'h00000000;
      221: data <= 32'h00000000;
      222: data <= 32'h00000000;
      223: data <= 32'h00000000;
      224: data <= 32'h00000000;
      225: data <= 32'h00000000;
      226: data <= 32'h00000000;
      227: data <= 32'h00000000;
      228: data <= 32'h00000000;
      229: data <= 32'h00000000;
      230: data <= 32'h00000000;
      231: data <= 32'h00000000;
      232: data <= 32'h00000000;
      233: data <= 32'h00000000;
      234: data <= 32'h00000000;
      235: data <= 32'h00000000;
      236: data <= 32'h00000000;
      237: data <= 32'h00000000;
      238: data <= 32'h00000000;
      239: data <= 32'h00000000;
      240: data <= 32'h00000000;
      241: data <= 32'h00000000;
      242: data <= 32'h00000000;
      243: data <= 32'h00000000;
      244: data <= 32'h00000000;
      245: data <= 32'h00000000;
      246: data <= 32'h00000000;
      247: data <= 32'h00000000;
      248: data <= 32'h00000000;
      249: data <= 32'h00000000;
      250: data <= 32'h00000000;
      251: data <= 32'h00000000;
      252: data <= 32'h00000000;
      253: data <= 32'h00000000;
      254: data <= 32'h00000000;
      255: data <= 32'h00000000;
    endcase
  end

endmodule
