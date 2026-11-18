# P56 program - see README.md for the task.
# Rules: start at the label p56_main and finish with ret; every label you
# create starts with p56_ ; save ra (and any s registers you use) on the stack.
# You may call the library routines in sw/lib/rcv_lib.s (rcv_puts, rcv_getc, ...).

    .text
p56_main:
    addi sp, sp, -80
    sw   ra, 76(sp)
    sw   s0, 72(sp)
    sw   s1, 68(sp)
    sw   s2, 64(sp)
    sw   s3, 60(sp)
    sw   s4, 56(sp)
    sw   s5, 52(sp)
    sw   s6, 48(sp)

    # ---- read 10 numbers into the array at 0(sp)..39(sp) ----
    mv   s0, sp
    li   s1, 0
p56_rd:
    call rcv_read_dec
    sw   a0, 0(s0)
    addi s0, s0, 4
    addi s1, s1, 1
    li   t0, 10
    blt  s1, t0, p56_rd

    # ---- STATS_CLEAR, then sort ----
    li   t0, 0x00020380
    sw   zero, 0(t0)
    mv   a0, sp
    call p56_sort

    # ---- read the counters straight away, loads first ----
    li   t0, 0x00020380
    lw   s1, 4(t0)          # loads
    lw   s2, 8(t0)          # stores
    lw   s3, 12(t0)         # branches
    lw   s4, 16(t0)         # taken
    lw   s5, 20(t0)         # jumps

    # ---- print: sorted: n n n ... ----
    la   a0, p56_s_sorted
    call rcv_puts
    mv   s0, sp
    addi s6, sp, 40
p56_pl:
    li   a0, 32
    call rcv_putc
    lw   a0, 0(s0)
    call rcv_print_dec
    addi s0, s0, 4
    blt  s0, s6, p56_pl
    call rcv_newline

    # ---- print the five counts ----
    la   a0, p56_s_loads
    call rcv_puts
    mv   a0, s1
    call rcv_print_dec
    call rcv_newline

    la   a0, p56_s_stores
    call rcv_puts
    mv   a0, s2
    call rcv_print_dec
    call rcv_newline

    la   a0, p56_s_branches
    call rcv_puts
    mv   a0, s3
    call rcv_print_dec
    call rcv_newline

    la   a0, p56_s_taken
    call rcv_puts
    mv   a0, s4
    call rcv_print_dec
    call rcv_newline

    la   a0, p56_s_jumps
    call rcv_puts
    mv   a0, s5
    call rcv_print_dec
    call rcv_newline

    lw   ra, 76(sp)
    lw   s0, 72(sp)
    lw   s1, 68(sp)
    lw   s2, 64(sp)
    lw   s3, 60(sp)
    lw   s4, 56(sp)
    lw   s5, 52(sp)
    lw   s6, 48(sp)
    addi sp, sp, 80
    ret

# ---- bubble sort: a0 = array base; t registers only, no stack ----
p56_sort:
    mv   t0, a0
    li   t1, 0              # i
p56_outer:
    li   t2, 0              # j
    li   t3, 9
    sub  t3, t3, t1         # limit = 9 - i
p56_inner:
    slli t4, t2, 2
    add  t4, t0, t4
    lw   t5, 0(t4)          # a[j]
    lw   t6, 4(t4)          # a[j+1]
    ble  t5, t6, p56_noswap
    sw   t6, 0(t4)
    sw   t5, 4(t4)
p56_noswap:
    addi t2, t2, 1
    blt  t2, t3, p56_inner  # inner do-while
    addi t1, t1, 1
    li   t3, 9
    blt  t1, t3, p56_outer  # outer do-while
    ret

    .rodata
p56_s_sorted:   .asciz "sorted:"
p56_s_loads:    .asciz "loads: "
p56_s_stores:   .asciz "stores: "
p56_s_branches: .asciz "branches: "
p56_s_taken:    .asciz "taken: "
p56_s_jumps:    .asciz "jumps: "
    .align 2
