###############################################################################
# File         : add.S
# Project      : EE180 Lab 2: MIPS
#
# Standards/Formatting:
#   MIPS gas, soft tab, 80 column
#
# Description:
#   Test the functionality of the 'add' instruction.
#
###############################################################################


    .section .boot, "x"
    .balign 4
    .set    noreorder
    .global boot
    .ent    boot
boot:
    lui     $s0, 0x8002         # Load the base address of the status/test registers
    ori     $s1, $0, 1          # Prepare the 'done' status
    
    lui     $t0, 0xffff         # A = 0xfffffffd (-3)
    nop
    ori     $t0, $t0, 0xfffd
    
    addi    $t1, $t0, -2        # t1 = -3 + -2 = -5

    addi    $t2, $t1, 6         # t2 = -5 + 6 = 1
    
    sw      $t2, 4($s0)         # Set the test result
    sw      $s1, 0($s0)         # Set 'done'

$done:
    j       $done
    nop

    .end boot
