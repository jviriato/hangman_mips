#      _                         _         _____                   
#     | | ___   __ _  ___     __| | __ _  |  ___|__  _ __ ___ __ _ 
#  _  | |/ _ \ / _` |/ _ \   / _` |/ _` | | |_ / _ \| '__/ __/ _` |
# | |_| | (_) | (_| | (_) | | (_| | (_| | |  _| (_) | | | (_| (_| |
#  \___/ \___/ \__, |\___/   \__,_|\__,_| |_|  \___/|_|  \___\__,_|
#              |___/                                               


.include "macros.asm"
#.include "musica.asm"
.include "dicionario.asm"
.include "forca.asm"
.text

main:
  
  
  la $s0, palavra
  li $s1, 0        #contador
  add $a0, $s0, $zero #passo como argumento o endereço da palavra
  jal strlen
  move $s1, $v0     #s1 passa a valer o n° de letras que a palavra contém
 
  #nota: registradores $a0 ... $a3 servem para passar argumentos para a funçao 
  la $a0, acertos     #endereço de acertos
  move $a1, $s1      #$s1 contém a qtd. de letras
  jal preenche_string
  move $s2, $v0      #movo o endereço da string acertos para $s2
  
  addi $s3, $zero, 6   #vidas
  #
  #    até agora temos:
  #    $s0 = end. da palavra
  #    $s1 = contador
  #    $s2 = end. da string acertos
  #    $s3 = "vidas"
  
  #Agora vem o loop do jogo...
  #Enquanto vidas > 0 || a string acertos ainda conter "_"
  
  print_str("Bem-vindo ao jogo da Forca! Feito por José Victor Viriato e João Davi Nunes.\n")
  
  print_str("A palavra a se adivinhar contem ")
  print_int($s1)
  print_str(" letras\n")

game_loop:
  beq $zero, $s3, fim_ruim     #Se vidas chegar em 0, vá para o fim.
  forca($s3)
  print_str("\nTens ")
  print_int($s3)
  print_str(" vidas restantes...\n")
  
  #printa a string....
  print_str("\n")	
  li $v0, 4
  la $a0, acertos
  syscall
  print_str("\n")	
  # 
 
  print_str("\nInsira um caractere: ")
  getchar
  move $t0, $v0
  print_str("\nCaractere digitado foi: ")
  print_char($t0)
  print_str("\n ")
  
  #caractere está em $t0
  move $s4, $t0

  move $a0, $s0
  move $a1, $t0
  jal compara_string

  
  bne $zero, $v0, _game_achou_char    #Isso significa que o caractere está na string
  
  #Caso contrário, errou:
  print_str("O char digitado nao esta presente na string!\n")
  addi $s3, $s3, -1  #retira uma vida.
  
  j game_loop
_game_achou_char:
  print_str("A letra está presente na string!\n")
  
  la $a0, acertos
  la $a1, palavra
  move $a2, $s4 #char
    
  jal contem_char
  
  
  
  #Verifica para ver se a palavra acertos ainda contem algum "_"
  la $a0, acertos
  addi	$a1, $zero, 95			# 95 = "_"
  jal compara_string
  beq	$v0, $zero, fim_bom	                #se nao tem mais _, va para o fim.
  j game_loop  
        
        
  #     
##########################################################################################
##########################################################################################
#
#                     contem_char
#             Substitui o underscore "_" pelo char encontrado
#             $a0 =      acertos
#             $a1 =      palavra
#             $a2 =      char
#

contem_char:
  #Prólogo
  addi	$sp, $sp, -8			# aoloca 4 bytes
  sw	$a0, 0($sp)			# guarda o antigo a0
  sw	$a1, 4($sp)			# guarda antigo a1
  
  
contem_char_loop:
  lb	$t0, 0($a1)				# carrega char da string
  beq	$t0, $zero, _contem_char_fim		#quer dizer que chegou ao fim da string
  bne	$t0, $a2, _nao_achou_char		#se char nao for igual, va para
  sb	$a2, 0($a0)				#guarda caractere na posiçao...
_nao_achou_char:
  addi	$a0, $a0, 1				#incrementa acertos
  addi	$a1, $a1, 1				#incrementa palavra
  j	contem_char_loop
_contem_char_fim:
  ## Epilogo
  lw	$a1, 4($sp)			# carrega antigo a1
  lw	$a0, 0($sp)			# carrega antigo a0
  addi	$sp, $sp, 8			
  jr	$ra				
  
  
  
##########################################################################################
##########################################################################################
#
#         strlen:
#    Conta o numero de caracteres numa string
#    $v0 = num de chars
#    $a0 fim da string
#  

strlen:
  #Prólogo
  addi $sp, $sp, -4   
  sw $a0, 0($sp)       #salva o endereço atual da strlen
  #
  li $v0, 0
_strlen_loop:
  lb $t2, 0($a0)

  beqz $t2, _strlen_fim   #se t2 == 0, va para FIM da strlen
  add $v0, $v0, 1         #incrementa contador
  add $a0, $a0, 1
  j _strlen_loop
  
_strlen_fim:
  #Epilogo
  lw $a0, 0($sp) #carrega antigo endereço
  addi $sp, $sp, 4 #desaloca
  jr $ra
  #


##########################################################################################
##########################################################################################
#
#         preenche_string:
#    preenche a string acertos com as letras adivinhadas
#    $a0 = endereço da string
#    $a1 = qtd. de letras

preenche_string:
  ## Prólogo ##
  addi	$sp, $sp, -8			# aloco 8 bytes
  sw	$a0, 0($sp)			# salvo a0
  sw	$a1, 4($sp)			# salvo a1

  add $a0, $a0, $a1                     #tamanho + endereço
  add $t0, $zero, 95                   #95 significa "_" em ascii
  
_preenche_string_loop:
  beq $a1, $zero, _preenche_string_fim  #quando o contador chegar a 0, vá para o fim   
  add	$a0, $a0, -1			# decrementa posicao do endereço
  add	$a1, $a1, -1			# decrementa qtd.
  sb	$t0, 0($a0)			# coloca o _ na string
  j	_preenche_string_loop		

_preenche_string_fim:
  #Epílogo#
  
  lw	$a0, 0($sp)			# carrega antigo $a0
  lw	$a1, 4($sp)			# carrega antigo $a1
  
  addi	$sp, $sp, 8			# desaloca os bytes
  move $v0, $a0
  jr	$ra				
  #

##########################################################################################
##########################################################################################
#
#         compara_string
#    compara a string palavra com o char inserido. 
#    $a0 = string
#    $v0  (char == str[i])? 1:0
compara_string:
  #Prólogo
  addi	$sp, $sp, -4			# aloco 4 bytes
  sw	$a0, 0($sp)			# salva a0

  and	$v0, $v0, $0			# $v0 = 0

_compara_string_loop:

  lb $t1, 0($a0)   #guardamos em t1 o valor que esta no endereço da string palavra
  beq $zero, $t1 _compara_string_fim
  beq $a1, $t1, _compara_string_achou
  addi $a0, $a0, 1
  j _compara_string_loop

_compara_string_achou:
   addi $v0, $zero, 1


   
_compara_string_fim:
  # Epílogo
  lw	$a0, 0($sp)
  addi	$sp, $sp, 4
  jr	$ra

##########################################################################################
##########################################################################################
#
#         getchar
#    usuario insere um caractere 
#    $v0 = caractere retornado
getchar:
  addi $v0, $0, 12			# 12 = ler um char
  syscall				# v0 contém um char
  jr $ra


fim_bom:

 print_str("\nVocê ganhou!\n")
 la $a0, palavra
 li $v0, 4
 syscall 
 j end


fim_ruim:
  forca($s3)
  print_str("\nVocê perdeu!\n A palavra era: \n ")

  la $a0, palavra
  li $v0, 4
  syscall

j end


end:


.data

palavra: .space 50
acertos: .space 50

