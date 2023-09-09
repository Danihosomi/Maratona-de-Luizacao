addi x1, x0, 10
addi x2, x0, 20
addi x3, x0, 30
sw x1, 1024(x0)
sw x2, 1028(x0)
sw x3, 1032(x0)
lw x4, 1024(x0)
lw x5, 1028(x0)
lw x6, 1032(x0)