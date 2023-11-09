addi x1, x0, 0b10101111
lui x2, 0x60000
sw x1, 0(x2)
addi x2, x2, 1
sw x1, 0(x2)
