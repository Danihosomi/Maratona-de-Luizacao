addi x1, x0, 10
addi x2, x0, 1024
addi x3, x0, 3
main:
sw x1, 0(x2)
lw x4, 0(x2)
addi x3, x3, -1
addi x1, x1, 10
bne x0, x3, main
