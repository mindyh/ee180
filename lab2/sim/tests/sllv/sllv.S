###############################################################################
# File         : sll.S
# Project      : EE180 Lab 2: MIPS
#
# Standards/Formatting:
#   MIPS gas, soft tab, 80 column
#
# Description:
#   Test the functionality of the 'sll' instruction.
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
    
    lui     $t0, 0xdeaf         # A = 0xdeafbeef
    nop
    ori     $t0, $t0, 0x0123

    ori     $t1, $0, 4          
    nop
    nop

    sllv    $t2, $t0, $t1       # B = 0xdeaf0123 << 4 = 0xeaf01230
    
    lui     $t3, 0xeaf0         # C = 0xeaf01231
    nop
    ori     $t3, $t3, 0x1231
    nop
    subu    $t4, $t3, $t2       # D = C - B = 1
    nop
    nop
    sw      $t4, 4($s0)         # Set the test result
    sw      $s1, 0($s0)         # Set 'done'

$done:
    j       $done
    nop

    .end boot
