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
    ori   $t0, $t0, 0xfffe
    ori   $t2, $0, 1           
    slt   $v0, $t0, $t2       # 1 since -2 < 1
    lui   $t3, 0xffff         
    ori   $t3, $0, 0xffff         
    slt  $v1, $t0, $t3        # 1 since -2 < -1
    and   $v1, $v0, $v1
    lui   $t2, 0xffff         
    ori   $t2, $t2, 0xfffd          
    slt   $v0, $t0, $t2     # 0 since -2 !< -3
    ori   $t3, $0, 1          
    slt   $v0, $v0, $t3       # v0 < 1 is true
    and   $v1, $v0, $v1
    sw      $v1, 4($s0)         # Set the test result
    sw      $s1, 0($s0)         # Set 'done'

$done:
    j       $done
    nop

    .end boot
