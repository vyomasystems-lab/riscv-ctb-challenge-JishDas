# See https://gitlab.com/vyoma_systems/common/-/blob/main/LICENSE.vyoma for more details
 
#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64M
RVTEST_CODE_BEGIN

  .align 2
  .option norvc

  li TESTNUM, 2
illegal_instruction:
  .word 0
  # j fail                                # before it was pointing to  fail, whereas it had to point to mtvec_handler 
  j mtvec_handler                         # changed jmp message from fail to mtvec_handler label

  .align 8
  .global mtvec_handler

  # -------------------Before-------------------
# mtvec_handler:
#   li t1, CAUSE_ILLEGAL_INSTRUCTION      # load the exeption code into t1
#   csrr t0, mcause                       # load the exeption code into t0, not by macro but by mcause reg
#   bne t0, t1, fail                      # if both codes are different, then your program has failed
#   csrr t0, mepc                         # read the mepc reg content (exeption instruction's address)

# If you directly write mret before changing the mepc reg, then it will again return to the same instruction that caused an exeption
#   mret

 # -------------------After-------------------
mtvec_handler:
  li t1, CAUSE_ILLEGAL_INSTRUCTION      # load the exeption code into t1
  csrr t0, mcause                       # load the exeption code into t0, not by macro but by mcause reg
  bne t0, t1, fail                      # if both codes are different, then your program has failed
  csrr t0, mepc                         # read the mepc reg content (exeption/interrupt instruction's address)
  addi t0, t0, 4
  csrw mepc, t0
  RVTEST_PASS
  mret

  fail:                                 # added fail command to ensure fail message is delivered
  RVTEST_FAIL
RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END