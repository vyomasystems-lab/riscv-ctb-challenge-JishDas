.include "user_define.h"
.globl _start
.section .text
.option norvc;
_start:           
                  .include "user_init.s"
                  csrr x5, 0xf14
                  li x6, 0
                  beq x5, x6, 0f

0: la x31, h0_start
jalr x0, x31, 0
h0_start:
                  li x23, 0x40000100
                  csrw 0x301, x23
kernel_sp:        
                  la x30, kernel_stack_end

trap_vec_init:    
                  la x23, mtvec_handler
                  ori x23, x23, 0
                  csrw 0x305, x23 # MTVEC

mepc_setup:       
                  la x23, init
                  csrw 0x341, x23

init_machine_mode:
                  li x23, 0x1a00
                  csrw 0x300, x23 # MSTATUS
                  li x23, 0x0
                  csrw 0x304, x23 # MIE
                  mret
init:             
                  li x0, 0x80000000
                  li x1, 0xa5ea5bc6
                  li x2, 0x0
                  li x3, 0xf5ff7c8e
                  li x4, 0x80000000
                  li x5, 0xffbf08c7
                  li x6, 0x0
                  li x7, 0x0
                  li x8, 0x80000000
                  li x9, 0xb
                  li x10, 0xe
                  li x11, 0x85da6f16
                  li x12, 0x0
                  li x13, 0x0
                  li x14, 0x3
                  li x15, 0xf15361cd
                  li x16, 0xf6719bcd
                  li x17, 0xf25d047d
                  li x18, 0xc
                  li x19, 0x0
                  li x20, 0x0
                  li x21, 0x8
                  li x22, 0x80000000
                  li x23, 0x0
                  li x24, 0x80000000
                  li x25, 0x4
                  li x26, 0x80000000
                  li x27, 0x53a073f4
                  li x28, 0x80000000
                  li x31, 0xcea7cd93
                  la x29, user_stack_end
main:             sltu        s0, s2, s8
                  slti        s0, gp, -1369
                  slli        a5, s6, 16
                  sra         s0, t1, sp
                  srai        t0, s3, 5
                  srai        a4, s6, 24
                  srl         sp, t1, s0
                  srli        ra, s1, 20
                  li         t3, 0x0 #start riscv_int_numeric_corner_stream_0
                  li         s11, 0x0
                  li         s10, 0x0
                  li         gp, 0x0
                  li         a1, 0x0
                  li         s9, 0x1
                  li         s1, 0x0
                  li         a7, 0x1
                  li         s0, 0x0
                  li         tp, 0x0
                  add         tp, t5, a3
                  add         s11, s4, s6
                  lui         t2, 259456
                  add         s4, a4, t6
                  add         s5, a3, a4
                  sub         ra, s5, t3
                  addi        s6, s4, 1642
                  sub         s10, s2, a4
                  lui         zero, 174583
                  lui         t2, 957136
                  sub         s4, s8, a6
                  add         zero, s8, s2
                  nop
                  nop
                  add         a7, a6, s3 #end riscv_int_numeric_corner_stream_0
                  or          zero, t0, s11
                  sltiu       s9, a6, -103
                  la x31, test_done
                  jalr x0, x31, 0
test_done:        
                  li gp, 1
                  ecall
write_tohost:     
                  sw gp, tohost, t5

_exit:            
                  j write_tohost

instr_end:        
                  nop

.section .data
.align 6; .global tohost; tohost: .dword 0;
.align 6; .global fromhost; fromhost: .dword 0;
.section .user_stack,"aw",@progbits;
.align 2
user_stack_start:
.rept 4999
.4byte 0x0
.endr
user_stack_end:
.4byte 0x0
.align 2
kernel_instr_start:
.text
.align 2
mtvec_handler:    
                  csrrw x29, 0x340, x29
                  add x29, x30, zero
                  1: addi x29, x29, -124
                  sw x1, 4(x29)
                  sw x2, 8(x29)
                  sw x3, 12(x29)
                  sw x4, 16(x29)
                  sw x5, 20(x29)
                  sw x6, 24(x29)
                  sw x7, 28(x29)
                  sw x8, 32(x29)
                  sw x9, 36(x29)
                  sw x10, 40(x29)
                  sw x11, 44(x29)
                  sw x12, 48(x29)
                  sw x13, 52(x29)
                  sw x14, 56(x29)
                  sw x15, 60(x29)
                  sw x16, 64(x29)
                  sw x17, 68(x29)
                  sw x18, 72(x29)
                  sw x19, 76(x29)
                  sw x20, 80(x29)
                  sw x21, 84(x29)
                  sw x22, 88(x29)
                  sw x23, 92(x29)
                  sw x24, 96(x29)
                  sw x25, 100(x29)
                  sw x26, 104(x29)
                  sw x27, 108(x29)
                  sw x28, 112(x29)
                  sw x29, 116(x29)
                  sw x30, 120(x29)
                  sw x31, 124(x29)
                  csrr x23, 0x300 # MSTATUS
                  csrr x23, 0x342 # MCAUSE
                  srli x23, x23, 31
                  bne x23, x0, mmode_intr_handler

mmode_exception_handler:
                  csrr x23, 0x341 # MEPC
                  csrr x23, 0x342 # MCAUSE
                  li x6, 0xb # ECALL_MMODE
                  beq x23, x6, ecall_handler
                  li x6, 0x2 # ILLEGAL_INSTRUCTION
                  beq x23, x6, illegal_instr_handler
                  csrr x6, 0x343 # MTVAL
                  1: la x31, test_done
                  jalr x1, x31, 0

ecall_handler:    
                  la x23, _start
                  sw x0, 0(x23)
                  sw x1, 4(x23)
                  sw x2, 8(x23)
                  sw x3, 12(x23)
                  sw x4, 16(x23)
                  sw x5, 20(x23)
                  sw x6, 24(x23)
                  sw x7, 28(x23)
                  sw x8, 32(x23)
                  sw x9, 36(x23)
                  sw x10, 40(x23)
                  sw x11, 44(x23)
                  sw x12, 48(x23)
                  sw x13, 52(x23)
                  sw x14, 56(x23)
                  sw x15, 60(x23)
                  sw x16, 64(x23)
                  sw x17, 68(x23)
                  sw x18, 72(x23)
                  sw x19, 76(x23)
                  sw x20, 80(x23)
                  sw x21, 84(x23)
                  sw x22, 88(x23)
                  sw x23, 92(x23)
                  sw x24, 96(x23)
                  sw x25, 100(x23)
                  sw x26, 104(x23)
                  sw x27, 108(x23)
                  sw x28, 112(x23)
                  sw x29, 116(x23)
                  sw x30, 120(x23)
                  sw x31, 124(x23)
                  la x31, write_tohost
                  jalr x0, x31, 0

illegal_instr_handler:
                  csrr  x23, 0x341
                  addi  x23, x23, 4
                  csrw  0x341, x23
                  lw x1, 4(x29)
                  lw x2, 8(x29)
                  lw x3, 12(x29)
                  lw x4, 16(x29)
                  lw x5, 20(x29)
                  lw x6, 24(x29)
                  lw x7, 28(x29)
                  lw x8, 32(x29)
                  lw x9, 36(x29)
                  lw x10, 40(x29)
                  lw x11, 44(x29)
                  lw x12, 48(x29)
                  lw x13, 52(x29)
                  lw x14, 56(x29)
                  lw x15, 60(x29)
                  lw x16, 64(x29)
                  lw x17, 68(x29)
                  lw x18, 72(x29)
                  lw x19, 76(x29)
                  lw x20, 80(x29)
                  lw x21, 84(x29)
                  lw x22, 88(x29)
                  lw x23, 92(x29)
                  lw x24, 96(x29)
                  lw x25, 100(x29)
                  lw x26, 104(x29)
                  lw x27, 108(x29)
                  lw x28, 112(x29)
                  lw x29, 116(x29)
                  lw x30, 120(x29)
                  lw x31, 124(x29)
                  addi x29, x29, 124
                  add x30, x29, zero
                  csrrw x29, 0x340, x29
                  mret

pt_fault_handler: 

.align 2
mmode_intr_handler:
                  csrr  x23, 0x300 # MSTATUS;
                  csrr  x23, 0x304 # MIE;
                  csrr  x23, 0x344 # MIP;
                  csrrc x23, 0x344, x23 # MIP;
                  lw x1, 4(x29)
                  lw x2, 8(x29)
                  lw x3, 12(x29)
                  lw x4, 16(x29)
                  lw x5, 20(x29)
                  lw x6, 24(x29)
                  lw x7, 28(x29)
                  lw x8, 32(x29)
                  lw x9, 36(x29)
                  lw x10, 40(x29)
                  lw x11, 44(x29)
                  lw x12, 48(x29)
                  lw x13, 52(x29)
                  lw x14, 56(x29)
                  lw x15, 60(x29)
                  lw x16, 64(x29)
                  lw x17, 68(x29)
                  lw x18, 72(x29)
                  lw x19, 76(x29)
                  lw x20, 80(x29)
                  lw x21, 84(x29)
                  lw x22, 88(x29)
                  lw x23, 92(x29)
                  lw x24, 96(x29)
                  lw x25, 100(x29)
                  lw x26, 104(x29)
                  lw x27, 108(x29)
                  lw x28, 112(x29)
                  lw x29, 116(x29)
                  lw x30, 120(x29)
                  lw x31, 124(x29)
                  addi x29, x29, 124
                  add x30, x29, zero
                  csrrw x29, 0x340, x29
                  mret;

kernel_instr_end: nop
.align 2
kernel_data_start:
.section .kernel_stack,"aw",@progbits;
.align 2
kernel_stack_start:
.rept 4999
.4byte 0x0
.endr
kernel_stack_end:
.4byte 0x0
