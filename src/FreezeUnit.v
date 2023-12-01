module  FreezeUnit(
  input aluBusy,
  input isDataMemoryBlocked,
  output isPipelineFrozen
);

  assign isPipelineFrozen = isDataMemoryBlocked || aluBusy;

endmodule
