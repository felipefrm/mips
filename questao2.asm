.data

msg1: .asciiz "\nDigite o primeiro número: "
msg2: .asciiz "Digite o segundo número: "
msg3: .asciiz "\nO MDC é igual a: "
	.text
	.globl main
	
main:
	li $v0, 4		#printa a mensagem 1
 	la $a0, msg1
 	syscall
 	
 	li $v0, 5		#le o primeiro inteiro
 	syscall
 	add $a1, $v0, $zero	#guarda valor lido no $a0 (parametro do procedimento)
 
 	li $v0, 4		#printa a mensagem 2
 	la $a0, msg2
 	syscall
 	
 	li $v0, 5		#le o segundo inteiro
 	syscall
 	add $a2, $v0, $zero	#guarda valor lido no $a1 (parametro do procedimento)
 	
 	jal mdc
 	
 	add $t0, $a0, $zero
 	li, $v0, 4
 	la $a0, msg3
 	syscall

	add $a0, $t0, $zero
 	li $v0, 1
 	syscall
 	j exit
 	
 mdc:
 	addi $sp, $sp, -12	#aloca memoria para variavel recebida da main
 	sw $a1, 0($sp)		#carrega o espaço de memoria alocado
 	sw $a2, 4($sp)
 	sw $ra, 8($sp)		# Guarda endereço de retorno
 	
 	bnez $a2, else
 	add $a0, $a1, $zero
 	addi $sp, $sp, 12	#liberando memoria
 	jr $ra
 	
else:
	add $t0, $a2, $zero
 	div $a1, $a2 		#divide numero 1 pelo numero 2
 	mfhi $a2   		#salva o resto da divisão
 	add $a1, $t0, $zero
 	
 	jal mdc			#chamada recursiva
 	
 	lw $a1, 0($sp)		#recuperando $s0
 	lw $a2, 4($sp)		#recuperando $s1
 	lw $ra 8($sp)
 	addi $sp, $sp, 12
 	jr $ra

exit:
	li $v0, 10		#termino de execução
	syscall