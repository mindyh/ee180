###############################################################################
# File         : ori.S
# Project      : EE180 Lab 2: MIPS
#
# Standards/Formatting:
#   MIPS gas, soft tab, 80 column
#
# Description:
#   Test the functionality of the 'ori' instruction.
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
    nop
    nop
    
    lui     $t0, 0xffff
    nop
    ori     $t0, $t0, 0xdeaf     # A = 0xdeaf
    nop
    nop

    ori     $t1, $0, 0x2150     # B = ~(0xdeaf)
    nop
    nop

    nor     $t2, $t0, $t1       # nor(0xdeaf, ~0xdeaf) should be 0
    nop
    nop

    sltiu   $t3, $t2, 1  
    nop
    nop       

    sw      $t3, 4($s0)         # Set the test result
    sw      $s1, 0($s0)         # Set 'done'

$done:
    j       $done
    nop

    .end boot
