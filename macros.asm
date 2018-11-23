

#Para usar este macro: print_str("Digite algo aqui")
.macro print_str (%str)
	.data
minhaStr: .asciiz %str
	.text
	li $v0, 4
	la $a0, minhaStr
	syscall
.end_macro

.macro print_int (%x)
  li $v0, 1
  add $a0, $zero, %x
  syscall
.end_macro

.macro print_char (%x)
	li $v0, 11
	add $a0, $zero, %x
	syscall
.end_macro

#Para usar esse macro: getchar
.macro getchar
.text
getchar:
  addi $v0, $0, 12			# 12 = ler um char
  syscall				# v0 contém um char
.end_macro

