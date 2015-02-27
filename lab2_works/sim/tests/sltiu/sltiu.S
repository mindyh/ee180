###############################################################################
# File         : sltiu.S
# Project      : EE180 Lab 2: MIPS
#
# Standards/Formatting:
#   MIPS gas, soft tab, 80 column
#
# Description:
#   Test the functionality of the 'sltiu' instruction.
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
    
    lui   $t0, 0xffff
    nop
    ori   $t0, $t0, 0xfffe
    nop
    nop

    sltiu $v0, $t0, 1       # 0 since 4,294,967,294 !< 1
    nop
    sltiu $v1, $v0, 1       # v0 < 1 is true
    nop
    nop

    sltiu $v0, $t0, 0xffff  # 1 since 4,294,967,294 < 4,294,967,295   
    nop
    nop

    and $t1, $v0, $v1
    nop
    nop

    sw      $t1, 4($s0)         # Set the test result
    sw      $s1, 0($s0)         # Set 'done'

$done:
    j       $done
    nop

    .end boot
