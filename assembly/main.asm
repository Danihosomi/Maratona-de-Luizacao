lui x9, 0x80000
lui x10, 0x70000
addi x1, x0, 0
BUTTON_LOOP:
lw x2, 0(x10)
add x1, x1, x2
sw x1, 0(x9)
beq x0, x0, BUTTON_LOOP