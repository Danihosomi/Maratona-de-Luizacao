addi x1, x0, 10
addi x2, x0, 15
addi x3, x0, 20
addi x4, x0, 25
lui x9, 0x80000
ori x1, x1, 3
andi x2, x2, 3
sub x4, x3, x1
add x3, x4, x3
sw x1, 0(x9)
sw x2, 0(x9)
sw x3, 0(x9)
sw x4, 0(x9)
lw x5, 1024(x0)
lw x6, 1028(x0)
lw x7, 1032(x0)
lw x8, 1036(x0)
addi x0, x0, 0