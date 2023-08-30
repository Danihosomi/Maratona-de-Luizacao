addi x15, x1, -50
lw x14, 8(x2)
jalr x0, x1, 500
sw x14, 8(x2)
beq x19, x10, 300
lui x10, 42895
jal x24, 98450