###############################################################################
# File         : slti.S
# Project      : EE180 Lab 2: MIPS
#
# Standards/Formatting:
#   MIPS gas, soft tab, 80 column
#
# Description:
#   Test the functionality of the 'slti' instruction.
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

    slti  $v0, $t0, 1       # 1 since -2 < 1
    nop
    nop

    slti  $v1, $t0, 0xffff  # 1 since -2 < -1
    nop
    nop

    and   $v1, $v0, $v1
    nop
    nop

    slti  $v0, $t0, 0xfffd  # 0 since -2 !< -3
    nop
    nop

    sltiu $v0, $v0, 1       # v0 < 1 is true
    nop
    nop

    and   $v1, $v0, $v1
    nop
    nop
    
    sw      $v1, 4($s0)         # Set the test result
    sw      $s1, 0($s0)         # Set 'done'

$done:
    j       $done
    nop

    .end boot
