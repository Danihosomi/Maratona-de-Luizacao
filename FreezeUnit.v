module  FreezeUnit(
  input isDataMemoryBlocked,
  output isPipelineFrozen
);

  assign isPipelineFrozen = isDataMemoryBlocked;

endmodule
