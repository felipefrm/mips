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
 	
 	add $t0, $v0, $zero	#guarda o retorno da função em uma reigstrador temporario (p/ q o v0 possa ser usado para printar a string) 
 	li, $v0, 4
 	la $a0, msg3		#printa a mensagem 3
 	syscall

	add $a0, $t0, $zero	#a0 recebe o valor retornado da funão para que ele possa ser printado na tela
 	li $v0, 1
 	syscall
 	j exit
 	
 mdc:
 	addi $sp, $sp, -12	#aloca memoria para variavel recebida da main
 	sw $a1, 0($sp)		#carrega o espaço de memoria alocado
 	sw $a2, 4($sp)
 	sw $ra, 8($sp)		# Guarda endereço de retorno
 	
 	bnez $a2, else		# a2 != 0 ?
 	add $v0, $a1, $zero	# se a2 == 0, coloca-se o valor de a2 em v0 para que possa ser retornado para a main 
 	addi $sp, $sp, 12	#liberando memoria
 	jr $ra			#desvia o programa para o endereço de retorno do programa principal
 	
else:
	add $t0, $a2, $zero	#aux = $a2
	rem $a2, $a1, $a2	#resto da divisão de $a1 por $a2
 	add $a1, $t0, $zero	# $a1 = aux
 	
 	jal mdc			#chamada recursiva
 	
 	lw $a1, 0($sp)		#recuperando $a1
 	lw $a2, 4($sp)		#recuperando $a2
 	lw $ra 8($sp)		#recuperando o endereço de retorno
 	addi $sp, $sp, 12	#libera o espaço usado
 	jr $ra			#desvia o programa para o endereço de retorno do programa principal

exit:
	li $v0, 10		#termino de execução
	syscall
