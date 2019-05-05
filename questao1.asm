.data 
 
 msg1: .asciiz "\nDigite quantas termos para calcular o PI deseja: " 
 msg2: .asciiz "\nO valor de PI é: "
 	.text
 	.globl main
 	
 main:
 	li $v0, 4		#imprime a mensagem 1
 	la $a0, msg1
 	syscall
 	
 	li $v0, 5		#le um inteiro
 	syscall
 	add $a0, $v0, $zero	#guarda valor lido no $a0 (parametro do procedimento)
 	add $a0, $a0, 1		#atribui 1 ao valor para facilitar na comparação lógica dentro do loop
	
	jal CalculaPi		#chama procedimento que calcula o pi
	
	li $v0, 4 
	la $a0, msg2		#imprime mensagem 2
	syscall
	li $v0, 2		#imprime valor aproximado de pi (float)
 	syscall	
 	j exit			#jump para o fim do programa
 	
 CalculaPi:
 	addi $sp, $sp, -4	#aloca memoria para variavel recebida da main
 	sw $s0, 0($sp)		#carrega o espaço de memoria alocado
 	add $s0, $a0, $zero	#guarda variavel vinda como parametro no espaço alocado 
 	li $s1, 1		#contador de termos
 	li $s2, 1		#denominador das divisões 
 	li $s3, 4		#variavel fixa do numerador
 	li $s4, 2		#variavel fixa para descobrir se o s1 é par ou impar 	
 loop: 	
 	beq $s0, $s1, return	#caso de saida do loop
	rem $t0, $s1, $s4	# resto da divisão para verificar se o termo é par ou impar
 	beq $t0, $zero, par	#se s1 for par, pula pra label par
 	mtc1 $s3,$f1		#converte inteiro para float e salva em f1
 	mtc1 $s2,$f2		#converte inteiro para float e salva em f2
 	div.s $f1, $f1, $f2 	#divide a constante 4 por um numero impar
 	add.s $f12,$f12,$f1	#soma ao valor de pi o resultado da divisão
 	add $s1, $s1, 1		#incrementa 1 ao contador
 	add $s2, $s2, 2		#incrementa 2 ao denominador das diviões (é sempre impar)
 	j loop

 par:
 	mtc1 $s3,$f1		#converte inteiro para float e salva em f1
 	mtc1 $s2,$f2		#converte inteiro para float e salva em f2
 	div.s $f1, $f1, $f2	#divide a constante 4 por um numero impar	
 	sub.s $f12,$f12,$f1	#subtrai ao valor de pi o resultado da divisão
 	add $s1,$s1, 1		#incrmeenta 1 ao contador
 	add $s2, $s2, 2		#incremena 2 ao denominador das divisões (é sempre impar)
 	j loop
 
 return: 
 	lw $s0, 0($sp)		#recuperando $s0
 	addi $sp, $sp, 4	#liberando memoria
 	jr $ra			#retorna o controle pra main
 	
 exit:
	li $v0, 10		#termino de execução
	syscall
