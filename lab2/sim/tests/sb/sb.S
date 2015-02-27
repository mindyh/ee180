###############################################################################
# File         : lb.S
# Project      : EE180 Lab 2: MIPS
#
# Standards/Formatting:
#   MIPS gas, soft tab, 80 column
#
# Description:
#   Test the functionality of the 'sb' instruction.
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
    lui     $t0, 0              # Load some valid address 0x00003210 to register $t0
    nop
    nop
    ori     $t0, $t0, 0x3210
    ori     $t1, $0, 0xde
    ori     $t2, $0, 0xaf
    ori     $t3, $0, 0xbe
    ori     $t4, $0, 0xef
    lui     $t5, 0xdeaf
    nop
    nop
    ori     $t5, $t5, 0xbeef
    nop
    nop
    sb      $t1, 0($t0)         # 0xdeXXXXXX
    nop
    nop
    sb      $t2, 1($t0)         # 0xdeafXXXX
    nop
    nop
    sb      $t3, 2($t0)         # 0xdeafbeXX
    nop
    nop
    sb      $t4, 3($t0)         # 0xdeafbeef
    nop
    nop
    lw      $t0, 0($t0)
    nop
    nop
    beq     $t0, $t5, $target
    ori     $v0, $0, 0
    
$finish:
    nop
    nop
    sw      $v0, 4($s0)         # Set the test result
    sw      $s1, 0($s0)         # Set 'done'

$done:
    j       $done
    nop

$target:
    j       $finish
    ori     $v0, $0, 1

    .end boot
