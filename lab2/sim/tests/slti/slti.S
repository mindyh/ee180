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
    slti    $t0, $s0, 0xffff
    nop
    nop
<<<<<<< HEAD
    sw      $t0, 4($s0)         # Set the test result
=======
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

    slti $v0, $v0, 1       # v0 < 1 is true
    nop
    nop

    and   $v1, $v0, $v1
    nop
    nop
    
    sw      $v1, 4($s0)         # Set the test result
>>>>>>> dd4a775c5b794cdcc0f45c117d6526334f2db5a9
    sw      $s1, 0($s0)         # Set 'done'

$done:
    j       $done
    nop

    .end boot
