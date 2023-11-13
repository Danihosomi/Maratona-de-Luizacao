lui x2, 0xA0000
addi x1, x0, 0b00000000
sw x1, 0(x2)
add x1, x0, x0
addi x2, x2, 1
sw x1, 0(x2)
start:
add x4, x3, x0
lui x5, 0x90000
lw x3, 0(x5)
beq x3, x4, start
beq x3, x0, start
addi x1, x1, 1
sw x1, 0(x2)
beq x0, x0, start
