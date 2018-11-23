
.data  
arquivo: .asciiz "palavras.txt"      # filename for input
buffer: .space 1024
palabra: .space 256

.text

rand:
  li $v0, 42   #syscall
  li $a0, 0    #seed
  li $a1, 9    #max
  syscall
  move $s1, $a0

  print_int($s1)


abre_arquivo:
  li   $v0, 13       # syscall
  la   $a0, arquivo  # nome do arquivo
  li   $a1, 0        # modo leitura
  li   $a2, 0
  syscall            # file descriptor em $v0
  move $s0, $v0      # salva o file descriptor 

ler_arquivo:
  li   $v0, 14       # syscall
  move $a0, $s0      # file descriptor 
  la   $a1, buffer   # endereço do buffer para leitura
  li   $a2, 1024     # tamanho do buffer
  syscall            # ler do arquivo

fecha_arquivo:
  li   $v0, 16       # syscal
  move $a0, $s0      # file descriptor
  syscall            # fecha

  
################################
#    
#     $s1 = numero aleatorio
#     $s6 = end. do buffer
#     $s0 = fd
#     $s2 = '\n'
#     $s3 = contador
#     $s4 = palavra

  la   $s4, palavra
  la $s6, buffer
  li $s2, '\n'
  li $s3, 0

  add, $t0, $s6, $zero  

percorre_strings:
  beq $s3, $s1, achou_string            #se contador for igual ao numero aleatorio, achou a palavra
  lb $t1, 0($t0)                        #carregamos o char presente
  move $a0, $t1
  li $v0, 11    # print_character
  syscall
  beq $t1, $s2, percorre_strings_fim	#quando achar um '\n' siginifca que a palavra acabou.
  addi, $t0, $t0, 1                     #aumenta o end em 1
  j percorre_strings
  
percorre_strings_fim:
  #Foi encontrada o fim de uma string, entao aumentamos o contador em 1.
  addi $s3, $s3, 1 #aumenta contador
  addi, $t0, $t0, 1                     #aumenta o end em 1
  j percorre_strings
  
achou_string:
  move $t2, $s4                   #carrego endereço da palavbra em s4
  
achou_string_loop:
  lb $t1, 0($t0)                  #carrego char da string em t1
  
  move $a0, $t1
  li $v0, 11    # print_character
  syscall
  
  
  sb $t1, 0($t2)
  beq $t1, $s2, achou_string_fim
  addi $t0, $t0, 1                # aumenta 1 o buffer
  addi $t2, $t2, 1                # aumenta 1 a palabra
  j achou_string_loop


achou_string_fim:
    li $t1, 0
    sb $t1, 0($t2)
    print_str("STRING: \n")
    la $a0, palavra
    li $v0, 4
    syscall



fim:
