lui x1, 0x44332
addi x1, x1, 0x211
addi x2, x0, 1024
main:
sw x1, 0(x2)
sw x1, 4(x2)
lw x3, 0(x2)
lw x4, 1(x2)
lw x5, 2(x2)
lw x6, 3(x2)
beq x0, x0, main
