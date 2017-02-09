.globl main
main:
	lui $t1, 0x2001
	ori $t1, 0x4924

	li $v0, 35
	add $a0, $t1, $zero
	syscall
