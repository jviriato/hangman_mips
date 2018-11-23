.macro forca(%f)


forca:

  move $t7, %f 
  
  addi $t6, $zero, 6
  beq $t6, $t7, f6vidas
  addi $t6, $zero, 5
  beq $t6, $t7, f5vidas
  addi $t6, $zero, 4
  beq $t6, $t7, f4vidas
  addi $t6, $zero, 3
  beq $t6, $t7, f3vidas
  addi $t6, $zero, 2
  beq $t6, $t7, f2vidas
  addi $t6, $zero, 1
  beq $t6, $t7, f1vidas
  addi $t6, $zero, 0
  beqz $t6, morto

f6vidas:

  li $v0, 4
  la $a0, forca_topo
  syscall

  li $v0, 4
  la $a0, forca_cabeca
  syscall

  li $v0, 4
  la $a0, forca_braco
  syscall
  
  li $v0, 4
  la $a0, forca_perna
  syscall

  li $v0, 4
  la $a0, forca_chao
  syscall
  
  j _forca_fim
  
f5vidas:
  #incluir a cabeça
  
  li $v0, 4
  la $a0, forca_topo
  syscall

  li $v0, 4
  la $a0, forca_cabeca
  syscall
  print_str("O")
  

  li $v0, 4
  la $a0, forca_braco
  syscall
  
  li $v0, 4
  la $a0, forca_perna
  syscall

  li $v0, 4
  la $a0, forca_chao
  syscall
  
  j _forca_fim

f4vidas:
#incluir a cabeça e tronco
  
  li $v0, 4
  la $a0, forca_topo
  syscall

  li $v0, 4
  la $a0, forca_cabeca
  syscall
  print_str("O")
  

  li $v0, 4
  la $a0, forca_braco
  syscall
  print_str(" |")
  
  li $v0, 4
  la $a0, forca_perna
  syscall

  li $v0, 4
  la $a0, forca_chao
  syscall
  
  j _forca_fim  

f3vidas:
#incluir a cabeça e tronco e braço esquerdo
  
  li $v0, 4
  la $a0, forca_topo
  syscall

  li $v0, 4
  la $a0, forca_cabeca
  syscall
  print_str("O")
  

  li $v0, 4
  la $a0, forca_braco
  syscall
  print_str("/")
  print_str("|")
  
  li $v0, 4
  la $a0, forca_perna
  syscall

  li $v0, 4
  la $a0, forca_chao
  syscall

  j _forca_fim

f2vidas:
#incluir a cabeça e tronco e ambos os braços
  
  li $v0, 4
  la $a0, forca_topo
  syscall

  li $v0, 4
  la $a0, forca_cabeca
  syscall
  print_str("O")
  

  li $v0, 4
  la $a0, forca_braco
  syscall
  print_str("/")
  print_str("|")
  li $v0, 4
  la $a0, dir
  syscall
  
  li $v0, 4
  la $a0, forca_perna
  syscall

  li $v0, 4
  la $a0, forca_chao
  syscall
  
  j _forca_fim

f1vidas:
#incluir a cabeça e tronco e ambos os braços e uma perna
  
  li $v0, 4
  la $a0, forca_topo
  syscall

  li $v0, 4
  la $a0, forca_cabeca
  syscall
  print_str("O")
  

  li $v0, 4
  la $a0, forca_braco
  syscall
  print_str("/")
  print_str("|")
  li $v0, 4
  la $a0, dir
  syscall
  
  li $v0, 4
  la $a0, forca_perna
  syscall
  print_str("/")
  li $v0, 4
  la $a0, forca_chao
  syscall
  
  j _forca_fim

morto:
#incluir a cabeça e tronco e ambos os braços e uma perna
  
  li $v0, 4
  la $a0, forca_topo
  syscall

  li $v0, 4
  la $a0, forca_cabeca
  syscall
  print_str("O")
  

  li $v0, 4
  la $a0, forca_braco
  syscall
  print_str("/")
  print_str("|")
  li $v0, 4
  la $a0, dir
  syscall
  
  li $v0, 4
  la $a0, forca_perna
  syscall
  print_str("/")
  li $v0, 4
  la $a0, dir
  syscall
  li $v0, 4
  la $a0, forca_chao
  syscall
  
  j _forca_fim


_forca_fim:

.data
forca_topo:   .asciiz "___________\n|          |"
forca_cabeca: .asciiz " \n|          " #Linha da cabeça, sem cabeça. Representada pelo char "O"
forca_braco:  .asciiz "\n|         "
forca_perna:  .asciiz "\n|         "
forca_chao:   .asciiz "\n|============"
dir:          .asciiz "\\"

.end_macro
