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
    ori  $t2, $0, 1
    sltu $v0, $t0, $t2       # 0 since 4,294,967,294 !< 1
    sltu $v1, $v0, $t2       # v0 < 1 is true
    lui  $t3, 0xffff
    ori  $t3, $t3, 0xffff
    sltu $v0, $t0, $t3  # 1 since 4,294,967,294 < 4,294,967,295   
    and $t1, $v0, $v1
    sw      $t1, 4($s0)         # Set the test result
    sw      $s1, 0($s0)         # Set 'done'
    
$done:
    j       $done
    nop

    .end boot
