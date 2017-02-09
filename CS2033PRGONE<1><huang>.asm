.data
	string:	.space 16
	input: .asciiz "Enter a string: "
	output: .asciiz "the number is: "
	Mulier:.word 0
	MulCand:.word 0
	newline:.asciiz "\n"
	s1str:.asciiz "s1:"
	s2str:.asciiz "s2:"
	prebit:.asciiz "pre:"
	curbit:.asciiz "cur:"
.text
	
main:	
	
	jal int2string
	sw $v0,Mulier
	#move $a0,$v0
	#li $v0,1
	#syscall
	jal int2string
	sw $v0 MulCand
	#move $a0,$v0	
	#li $v0,1
	#syscall
	addi $t0,$zero,0#i
	li $t1,0#previos bit 
	li $s1,0#mulier upper 32bit
	lw $s2,Mulier#mulier lowwer 32bit
	lw $s3,MulCand#mulcand
MulLoop:   beq $t0,32,MulLoopend	
	andi $t2,$s2,1#current bit	
	beq $t1,1,Prebit1
	beq $t2,1,Curbit1
	j MulCombineSrl
Prebit1:
	beq $t2,0,MulCur0_Pre1Combine
	j MulCombineSrl
Curbit1:
	beq $t1,0,MulCur1_Pre0Combine
	j MulCombineSrl
MulCur0_Pre1Combine:
	add $s1,$s1,$s3
	j MulCombineSrl
MulCur1_Pre0Combine:
	sub $s1,$s1,$s3	
MulCombineSrl:
	
	andi $t3,$s2,1#lower over bit
	andi $t4,$s1,1#uper over bit	
	srl $s1,$s1,1
	sll $t3,$t3,31
	add $s1,$s1,$t3	
	srl $s2,$s2,1
	sll $t4,$t4,31
	add $s2,$s2,$t4	
	move $a0,$t2
	li $v0,1
	syscall
	
	move $a0,$t1
	li $v0,1
	syscall
	
	la $a0,newline
	li $v0,4
	syscall
	
	la $a0,s1str
	li $v0,4
	syscall	
	move $a0,$s1
	li $v0,35
	syscall	
	la $a0,newline
	li $v0,4
	syscall
	la $a0,s2str
	li $v0,4
	syscall
	move $a0,$s2
	li $v0,35
	syscall		
	la $a0,newline
	li $v0,4
	syscall
	
	move $t1,$t2	
	addi $t0,$t0,1
	j MulLoop
MulLoopend:

	move $a0,$s1
	li $v0,1
	#syscall
	la $a0,newline
	li $v0,4
	#syscall
	move $a0,$s2
	li $v0,1
	#syscall
	la $a0,newline
	li $v0,4
	syscall
	move $a0,$s1
	li $v0,35
	syscall
	move $a0,$s2
	li $v0,35
	syscall
	
exit:
li $v0,10
syscall
int2string:
	addi $sp,$sp,-24
	sw $fp,0($sp)
	sw $ra,4($sp)
	addi $fp,$sp,20
	la $t1, string #load address of string in t1
	li $s1, 0 #s1=0
	li $s2, 1 #s2=1
	li $v0, 4 #$System call code for print string
	la $a0, input #$address of string to print
	syscall#print
	li $v0, 8 #$System call code for read string
	la $a0, ($t1) #$address where string to be stored
	addi $a1, $zero, 16 #number of character to read
	syscall #print
	j int2stringloop#jump to loop
	
int2stringloop:
	lb $s6, 0($t1) #load 0 byte of t1 in s6
	jal int2stringcheck #jump and link check
	addi $t1, $t1, 1 #add 1 in t1 store in t1
	j int2stringloop

int2stringcheck:
	li $t4, 45 #t4=45
	beq $s6, $t4, int2stringnegative # if s6=t4, negative
	# if null, exit2
	li $t4, 10 #t4=10
	beq $s6, $t4, int2stringexit2 # if s6=t4, exit2
	# if $s6 < 48, exit1
	slti $s0, $s6, 48
	bne $s0, $zero, int2stringexit1
	# if $s6 - 58 > 0, exit1
	addi $s0, $s6, -58
	slti $t0, $s0, 0
	beqz $t0, int2stringexit1
	# else 
	li $t0, 10 #t0=10
	# should be the same as mul $s1, $s1, $t0
	mult $s1, $t0 
	mflo $s1 
	mfhi $t9
	bne $t9,0,int2stringoverflow
	addi $s6, $s6, -48 #store s6-48 in s6
	add $s1, $s6, $s1 #add s6 and s1 in s1
	jr $ra #return
	
int2stringnegative:
	li $s2, -1 # s2=-1
	jr $ra # jump to return address in ra

int2stringexit1:
	li $v0, 1 #$System call code for print integer
	li $a0, -1 #$integer to print
	syscall #print
	j int2stringexit

int2stringexit2:
	mul $s1,$s1,$s2 #multiply by s2 and convert it to negative  
	li $v0, 1 #$System call code for print integer
	add $a0, $s1, $zero #$integer to print
	move $v0,$a0
	#syscall #print
	j int2stringexit

int2stringexit:
	lw $fp,0($sp)
	lw $ra,4($sp)
	addi $sp,$sp,24
	jr $ra
int2stringoverflow:
	la $a0,errormessage
	li $v0,4
	syscall
	li $v0,10
	syscall
	
.data
errormessage:.asciiz "value overflow "

